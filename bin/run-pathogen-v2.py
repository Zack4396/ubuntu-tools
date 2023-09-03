#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This is a script used to install the VIM plugins.
Author: zokkki@foxmail.com
Date: 9/3/2023
Version: 0.0.2

Usage:
"""
import os


class Options(object):
    verbose = False
    home_path: str
    tool_path: str
    plugin_list: list


OPTION = Options()
OPTION.plugin_list = []


def run(args, **kwargs):
    import subprocess

    if OPTION.verbose:
        print("  running: ", " ".join(args))
    return subprocess.Popen(args, **kwargs)


def run_command(cmd, usage) -> bool:
    import subprocess

    p = run(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()

    if p.returncode == 0:
        print(f"[{usage.ljust(30)}]: OKAY")
        return True
    else:
        print(f"[{usage.ljust(30)}]: FAIL")

        if OPTION.verbose:
            print(f"\nfailed log ==>")
            print(stderr.decode("utf-8").splitlines())
            print(stdout.decode("utf-8").splitlines())
        else:
            print(f"you can add '--verbose' to show more logs")
        return False


def update_native_string(native_str) -> str:
    if native_str:
        native_str = native_str.replace("$HOME", OPTION.home_path)
        native_str = native_str.replace("$TOOL", OPTION.tool_path)
    return native_str


def check_dirs_exist(field_block):
    check_pass = True
    if isinstance(field_block.get("dirs"), list):
        for i in field_block["dirs"]:
            formatted_path = update_native_string(i)
            if not os.path.isdir(formatted_path):
                check_pass = False
                print(f"DIR {formatted_path} is not exist")

                # Print Help Message
                help = field_block["help"]
                key = os.path.basename(i)
                if help and key in help:
                    print("")
                    for j in help[key]:
                        formatted_path = update_native_string(j)
                        print(f"{formatted_path}")
                    print("")
                continue

    if not check_pass:
        exit(1)


def initialization(data):
    create_info = data["Initialization"]["Create"]

    for i in create_info["dirs"]:
        # Sanity path
        formatted_path = os.path.normpath(update_native_string(i))
        if not os.path.exists(formatted_path):
            print(f"Create New Folder {formatted_path}.")
            os.makedirs(formatted_path, exist_ok=True)

    check_dirs_exist(create_info)

    copy_info = data["Initialization"]["Copy"]

    import shutil

    for i in copy_info.values():
        src = os.path.normpath(update_native_string(i["From"]))
        dst = os.path.normpath(update_native_string(i["To"]))

        if not os.path.exists(src):
            print(f"{src} is not exist")
            exit(1)

        if not os.path.exists(dst):
            shutil.copy(src, dst)

        print(f"Copy {src} to {dst}")

    import platform

    if platform.system() == "Windows":
        vimrc_src = os.path.join(OPTION.tool_path, ".vimrc")
        vimrc_dst = os.path.join(OPTION.home_path, "_vimrc")
    else:
        vimrc_src = os.path.join(OPTION.tool_path, ".vimrc")
        vimrc_dst = os.path.join(OPTION.home_path, ".vimrc")

    if not os.path.exists(vimrc_src):
        print(f"{vimrc_src} is not exist")
        exit(1)

    if not os.path.exists(vimrc_dst):
        shutil.copy(vimrc_src, vimrc_dst)

    print(f"Copy {vimrc_src} to {vimrc_dst}")


def installation(data):
    manager_info = data["Installation"]["Manager"]

    for _, value in manager_info.items():
        plugin_installation(plugin_info=value, enable_plugin=value.get("Enable"))

    staff_info = data["Installation"]["Staff"]

    for _, value in staff_info.items():
        plugin_installation(plugin_info=value, enable_plugin=value.get("Enable"))

    core_info = data["Installation"]["Core"]

    for _, value in core_info.items():
        plugin_installation(plugin_info=value, enable_plugin=value.get("Enable"))


def collection_plugins(data):
    manager_info = data["Installation"]["Manager"]

    for key in manager_info.keys():
        OPTION.plugin_list.append(key)

    staff_info = data["Installation"]["Staff"]

    for key in staff_info.keys():
        OPTION.plugin_list.append(key)

    core_info = data["Installation"]["Core"]

    for key in core_info.keys():
        OPTION.plugin_list.append(key)


def plugin_installation(plugin_info, enable_plugin):
    import platform

    common_commands = plugin_info.get("Commands")
    platform_commands = plugin_info.get(f"Commands-{platform.system()}")

    commands_info = common_commands if common_commands else platform_commands

    if commands_info:
        # Run Download Command
        _ = (
            plugin_command(commands_info["Download"], enable_plugin)
            if commands_info.get("Download")
            else None
        )

        # Run Update Command
        _ = (
            plugin_command(commands_info["Update"], enable_plugin)
            if commands_info.get("Update")
            else None
        )

        # Run Install Command
        _ = (
            plugin_command(commands_info["Install"], enable_plugin)
            if commands_info.get("Install")
            else None
        )
    else:
        return None


def plugin_command(command_info, enable_plugin):
    from_path = command_info["From"]["value"]
    if command_info["From"]["type"] == "path":
        formatted_path = update_native_string(from_path)
        from_path = os.path.normpath(formatted_path)

    to_path = command_info["To"]["value"]
    if command_info["To"]["type"] == "path":
        formatted_path = update_native_string(to_path)
        to_path = os.path.normpath(formatted_path)

    # Check
    check_list = [
        item
        for key in ["dirs", "files"]
        for item in command_info["Check"].get(key, [])
        if isinstance(item, str)
    ]
    checked_list = []
    if len(check_list) > 0:
        for i in check_list:
            formatted_path = update_native_string(i)
            formatted_path = formatted_path.replace("$To", to_path)
            formatted_path = formatted_path.replace("$From", from_path)
            formatted_path = os.path.normpath(formatted_path)

            if os.path.exists(formatted_path):
                checked_list.append(formatted_path)

    # Run
    usage = command_info.get("Usage")

    if not enable_plugin:
        # Disabled
        if OPTION.verbose:
            print(f"[{usage.ljust(30)}]: Disabled")
        return False
    elif len(checked_list) == len(check_list):
        # Doned
        if OPTION.verbose:
            print(f"[{usage.ljust(30)}]: Doned")
        return True
    elif len(checked_list) != 0:
        # Incomplete
        if OPTION.verbose:
            print(f"[{usage.ljust(30)}]: Incomplete, needs to be redone")

            max_len = 0
            msg_list = []
            for i in checked_list:
                msg = f"Please remove '{i}' manually, then try again"
                max_len = max(len(msg), max_len)
                msg_list.append(msg)

            print("-" * max_len)
            for msg in msg_list:
                print(msg)
            print("-" * max_len)
        return False
    else:
        if not command_info.get("Command"):
            if command_info.get("Help"):
                max_len = 0
                msg_list = []

                for i in command_info.get("Help"):
                    msg = f"{i}"
                    max_len = max(len(msg), max_len)
                    msg_list.append(msg)

                print("-" * max_len)
                for msg in msg_list:
                    print(msg)
                print("-" * max_len)
            return None

        # First installation
        formatted_command = " ".join(command_info["Command"])
        formatted_command = update_native_string(formatted_command)
        formatted_command = formatted_command.replace("$To", to_path)
        formatted_command = formatted_command.replace("$From", from_path)
        assert run_command(formatted_command.split(), usage)


def arg_parse():
    import argparse

    parser = argparse.ArgumentParser(description="Install Vim plugins")

    parser.add_argument(
        "-a",
        "--install_all",
        action="store_true",
        help="Install all supported plugins",
    )
    parser.add_argument(
        "-s", "--show", action="store_true", help="Show supported plugins"
    )
    parser.add_argument(
        "--verbose", action="store_true", help="Show more debug message"
    )

    return parser.parse_args()


def load_json():
    import json

    conf = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "run-pathogen-v2.json"
    )
    with open(conf, "r") as f:
        data = json.load(f)

    with open(conf, "w", newline="") as f:
        json.dump(data, f, indent=4)

    return data


def main():
    import platform

    args = arg_parse()
    if args.verbose:
        OPTION.verbose = True

    OPTION.home_path = os.path.expanduser("~")
    OPTION.tool_path = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

    data = load_json()
    collection_plugins(data)

    if args.show:
        title = "[----- supported plugins -----]"
        print(f"{title}")
        for index, plugin_name in enumerate(OPTION.plugin_list, start=1):
            print(f"{index:2}. {plugin_name:20}")
    elif args.install_all:
        initialization(data)
        installation(data)


if __name__ == "__main__":
    main()
