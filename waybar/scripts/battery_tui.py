#!/usr/bin/env python3
"""battery_tui.py — Battery status TUI for Waybar click."""
import curses
import subprocess
from pathlib import Path

BAT = "/sys/class/power_supply/BAT1"


def read_sysfs(name):
    try:
        return Path(f"{BAT}/{name}").read_text().strip()
    except Exception:
        return "N/A"


def read_acpi():
    try:
        r = subprocess.run(
            ["acpi", "-V"], capture_output=True, text=True, timeout=5
        )
        return r.stdout
    except Exception:
        return ""


def get_battery_data():
    capacity = read_sysfs("capacity")
    status = read_sysfs("status")
    e_now = int(read_sysfs("energy_now") or 0)
    e_full = int(read_sysfs("energy_full") or 0)
    e_design = int(read_sysfs("energy_full_design") or 0)
    cycle_count = read_sysfs("cycle_count")
    model = read_sysfs("model_name")
    manufacturer = read_sysfs("manufacturer")
    technology = read_sysfs("technology")
    voltage = int(read_sysfs("voltage_now") or 0)

    health_pct = (e_full / e_design * 100) if e_design > 0 else 0
    acpi_out = read_acpi()

    temp = "N/A"
    for line in acpi_out.split("\n"):
        if "Thermal" in line and "degrees" in line:
            temp = line.split("degrees C")[0].split(",")[-1].strip() + "°C"
            break

    return {
        "capacity": capacity,
        "status": status,
        "energy_now": e_now,
        "energy_full": e_full,
        "energy_full_design": e_design,
        "health_pct": health_pct,
        "cycle_count": cycle_count,
        "model": model,
        "manufacturer": manufacturer,
        "technology": technology,
        "voltage": voltage,
        "temp": temp,
    }


def draw_progress_bar(scr, y, x, width, pct, pair):
    filled = int(width * pct / 100)
    bar = "█" * filled + "░" * (width - filled)
    scr.attron(curses.color_pair(pair))
    scr.addstr(y, x, bar[:width])
    scr.attroff(curses.color_pair(pair))


def main(scr):
    curses.curs_set(0)
    curses.set_escdelay(25)

    curses.start_color()
    curses.use_default_colors()

    C_DEFAULT = 1
    C_HEADER = 2
    C_BAR = 3
    C_LABEL = 4
    C_VALUE = 5
    C_HELP = 6

    curses.init_pair(C_DEFAULT, -1, -1)
    curses.init_pair(C_HEADER, 5, -1)   # magenta
    curses.init_pair(C_BAR, 2, -1)      # green
    curses.init_pair(C_LABEL, 7, -1)    # white
    curses.init_pair(C_VALUE, 6, -1)    # cyan
    curses.init_pair(C_HELP, 8, -1)     # gray

    stdscr = scr
    data = get_battery_data()

    while True:
        stdscr.erase()
        h, w = stdscr.getmaxyx()

        if h < 15 or w < 45:
            stdscr.addstr(0, 0, f"Terminal too small — need 45×15")
            stdscr.addstr(2, 0, "Press any key to quit...")
            stdscr.getch()
            break

        # ── Header border ──
        title = " ⚡ Battery "
        x_off = (w - len(title)) // 2
        stdscr.attron(curses.color_pair(C_HEADER) | curses.A_BOLD)
        try:
            stdscr.insstr(0, 0, "┌" + "─" * (w - 2) + "┐")
        except:
            try:
                stdscr.insstr(0, 0, "+" + "-" * (w - 2) + "+")
            except:
                pass
        stdscr.addstr(0, x_off, title)
        stdscr.attroff(curses.color_pair(C_HEADER) | curses.A_BOLD)

        bar_w = min(40, w - 8)
        pct = int(data["capacity"])

        # ── Big percentage ──
        pct_str = f"{pct}%"
        stdscr.attron(curses.color_pair(C_LABEL) | curses.A_BOLD)
        stdscr.addstr(3, (w - len(pct_str)) // 2, pct_str)
        stdscr.attroff(curses.color_pair(C_LABEL) | curses.A_BOLD)

        # ── Progress bar ──
        bar_x = (w - bar_w) // 2
        draw_progress_bar(stdscr, 5, bar_x, bar_w, pct, C_BAR)

        # ── Detail rows ──
        y = 7

        rows = [
            ("Status:", status_map(data["status"])),
            ("Health:", f"{data['health_pct']:.0f}% ({data['energy_full'] / 1000000:.0f}/{data['energy_full_design'] / 1000000:.0f} Wh)"),
            ("Cycles:", str(data["cycle_count"])),
            ("Temp:", data["temp"]),
            ("Model:", f"{data['manufacturer']} {data['model']}"),
            ("Voltage:", f"{data['voltage'] / 1000000:.3f}V"),
        ]

        for label, value in rows:
            stdscr.attron(curses.color_pair(C_LABEL))
            stdscr.addstr(y, 4, f"{label:8s} ")
            stdscr.attroff(curses.color_pair(C_LABEL))
            stdscr.attron(curses.color_pair(C_VALUE))
            stdscr.addstr(y, 14, value)
            stdscr.attroff(curses.color_pair(C_VALUE))
            y += 1

        # ── Separator ──
        y += 1
        stdscr.attron(curses.color_pair(C_HEADER))
        try:
            stdscr.insstr(y, 0, "─" * (w - 1))
        except:
            try:
                stdscr.insstr(y, 0, "-" * (w - 1))
            except:
                pass
        stdscr.attroff(curses.color_pair(C_HEADER))
        y += 1

        # ── Footer help ──
        help_text = "r refresh  |  any key to close"
        if h > y + 2:
            stdscr.attron(curses.color_pair(C_HELP))
            stdscr.addstr(y, 4, help_text)
            stdscr.attroff(curses.color_pair(C_HELP))

        # ── Bottom border ──
        stdscr.attron(curses.color_pair(C_HEADER) | curses.A_BOLD)
        try:
            stdscr.insstr(h - 1, 0, "└" + "─" * (w - 2) + "┘")
        except:
            try:
                stdscr.insstr(h - 1, 0, "+" + "-" * (w - 2) + "+")
            except:
                pass  # skip bottom border if terminal won't cooperate
        stdscr.attroff(curses.color_pair(C_HEADER) | curses.A_BOLD)

        stdscr.refresh()

        # ── Input ──
        key = stdscr.getch()
        if key in (ord("q"), 27):
            break
        elif key == ord("r"):
            data = get_battery_data()
            continue
        else:
            # ignore any other key (spurious input on terminal open, etc.)
            continue


def status_map(s):
    return {
        "Charging": "Charging",
        "Discharging": "Discharging",
        "Not charging": "On AC (not charging)",
        "Full": "Fully charged",
    }.get(s, s)


if __name__ == "__main__":
    import traceback
    try:
        curses.wrapper(main)
    except KeyboardInterrupt:
        pass
    except Exception:
        tb = traceback.format_exc()
        with open("/tmp/battery_tui_error.log", "w") as f:
            f.write(tb)
        # Try printing to terminal (in case curses failed)
        import sys
        sys.stdout.write("\n" + "=" * 50 + "\n")
        sys.stdout.write("BATTERY TUI CRASHED\n")
        sys.stdout.write("=" * 50 + "\n")
        sys.stdout.write(tb)
        sys.stdout.write("\nSee /tmp/battery_tui_error.log\n")
        sys.stdout.write("Press Enter to close...")
        sys.stdout.flush()
        try:
            input()
        except Exception:
            pass
