#!/usr/bin/env python3
import argparse
from collections import defaultdict


def parse_manifest(path: str):
    profiles = defaultdict(lambda: {"rules": [], "commands": [], "skills": []})
    current_profile = None
    current_group = None

    with open(path, "r", encoding="utf-8") as f:
        for raw in f:
            s = raw.strip()
            if not s or s.startswith("#") or s.startswith("version:"):
                continue
            indent = len(raw) - len(raw.lstrip(" "))
            if indent == 2 and s.endswith(":"):
                current_profile = s[:-1]
                current_group = None
                _ = profiles[current_profile]
                continue
            if indent == 4 and s.endswith(":"):
                current_group = s[:-1]
                continue
            if indent == 6 and s.startswith("- ") and current_profile and current_group:
                profiles[current_profile][current_group].append(s[2:].strip())
    return profiles


def active_profiles(profile: str):
    result = ["global"]
    if profile in ("backend", "full"):
        result.append("backend")
    if profile in ("frontend", "full"):
        result.append("frontend")
    return result


def emit_sync_pairs(profiles, profile: str, include_commands: bool, include_skills: bool):
    groups = ["rules"]
    if include_commands:
        groups.append("commands")
    if include_skills:
        groups.append("skills")

    for p in active_profiles(profile):
        for group in groups:
            for item in profiles[p][group]:
                src, dst = to_sync_pair(p, group, item)
                print(f"{src}\t{dst}")


def to_sync_pair(profile_name: str, group: str, item: str):
    if profile_name != "global":
        return f"{profile_name}/.cursor/{group}/{item}", f".cursor/{group}/{item}"

    src = f".cursor/{group}/{item}"
    if group == "rules" and item == "project-overrides-template.mdc":
        return src, ".cursor/rules/project-overrides.mdc"
    return src, f".cursor/{group}/{item}"


def emit_all_source_files(profiles):
    files = []
    for p in ("global", "backend", "frontend"):
        if p not in profiles:
            continue
        for group in ("rules", "commands", "skills"):
            for item in profiles[p][group]:
                if p == "global":
                    files.append(f".cursor/{group}/{item}")
                else:
                    files.append(f"{p}/.cursor/{group}/{item}")
    for path in sorted(set(files)):
        print(path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--mode", choices=["sync_pairs", "all_source_files"], required=True)
    parser.add_argument("--profile", choices=["global", "backend", "frontend", "full"], default="global")
    parser.add_argument("--include-commands", action="store_true")
    parser.add_argument("--include-skills", action="store_true")
    args = parser.parse_args()

    profiles = parse_manifest(args.manifest)

    if args.mode == "sync_pairs":
        emit_sync_pairs(profiles, args.profile, args.include_commands, args.include_skills)
    else:
        emit_all_source_files(profiles)


if __name__ == "__main__":
    main()
