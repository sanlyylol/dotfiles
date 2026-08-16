from pathlib import Path
import os
import shutil
import subprocess

config_dirs = ["hypr", "waybar", "nvim", "swaync", "wlogout", "wofi", "wallpapers", "zsh", "wezterm", "snvim"]
parent_dir = Path(os.path.dirname(os.path.abspath(__file__)))
subprocess.run(["git", "clone", "https://github.com/sanlyylol/dotfiles", parent_dir], check = True)  # pyright: ignore[reportUnusedCallResult]
repo_path = parent_dir / "dotfiles"


def copy_config(repo_path: Path, program: str):
    src = repo_path / program
    dst = Path.home() / ".config" / program
    match program:
        case "wallpapers":
            dst = Path.home() / "Pictures" / program 
        case "zsh":
            src = repo_path / program / ".zshrc"
            dst = Path.home() / ".zshrc"
        case "wezterm":
            src = repo_path / program / ".wezterm.lua"
            dst = Path.home() / ".wezterm.lua"
        case "snvim":
            snvim_res_path = Path.home() / ".local" / "bin"
            if not snvim_res_path.exists():
                snvim_res_path.mkdir()
            dst = snvim_res_path / "snvim"
        case _:
            pass

    if dst.exists():
        check = input(f"{program} config detected\ndo you want to overwrite the existing config? (y/N) ")
        match check:
            case "y" | "Y":
                pass 
            case _:
                return
        try:
            if src.is_dir():
                shutil.copytree(src, dst, dirs_exist_ok=True)  # pyright: ignore[reportUnusedCallResult]
            elif src.is_file():
                shutil.copy2(src, dst)  # pyright: ignore[reportUnusedCallResult]
                if program == "snvim":
                    dst.chmod(0o777)
        except Exception as e:
            print(f"failed to overwrite {dst} with {src}: {e}")
            return
    else:
        try:
            if src.is_dir():
                shutil.copytree(src, dst)  # pyright: ignore[reportUnusedCallResult]
            elif src.is_file():
                shutil.copy2(src, dst)  # pyright: ignore[reportUnusedCallResult]
        except Exception as e:
            print(f"failed copying {src} to {dst}: {e}")
            return
    print(f"{src} copied to {dst} successfully") 
    return True

while True:
    for i, dir in enumerate(config_dirs):
        print(f"{i}: {dir}")
    print(f"{len(config_dirs)}: exit")
    choice = int(input(f"choose one of the above: "))
    if choice > (len(config_dirs) + 1) or choice < 0:
        print(f"choice out of bounds")
        continue
    elif choice == len(config_dirs):
        break
    copy_config(repo_path, config_dirs[choice])  # pyright: ignore[reportUnusedCallResult]

print(f"script finished")
