use starship_battery::{
    units::{ratio::percent, time::second},
    Manager, State as BatteryState,
};

use crate::{colors, yuck::Widget, State};

const BAT_DISCHARGING_ICONS: [&str; 11] = ["󱃍", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
const BAT_CHARGING_ICONS: [&str; 11] = ["󰢜", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"];

fn format_duration(sec: f32) -> String {
    let sec = sec as usize;
    let hour = sec / 3600;
    let min = sec % 3600 / 60;
    let sec = sec % 60;
    format!("{hour:02}:{min:02}:{sec:02}")
}

pub fn battery(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let manager = Manager::new().unwrap();
    let battery = manager.batteries()?.next().expect("no battery")?;

    let percentage = battery.state_of_charge().get::<percent>() as usize;
    let icon_idx = (percentage + 5) / 10;

    let icon = match battery.state() {
        BatteryState::Discharging => BAT_DISCHARGING_ICONS[icon_idx],
        BatteryState::Charging => BAT_CHARGING_ICONS[icon_idx],
        BatteryState::Empty => "󱃍",
        BatteryState::Unknown => "󰂑",
        BatteryState::Full => "󰁹",
    };

    let color = match percentage {
        75.. => colors::FROST1,
        50.. => colors::GREEN,
        30.. => colors::YELLOW,
        15.. => colors::ORANGE,
        _ => colors::RED,
    };

    let tooltip = match battery.state() {
        BatteryState::Charging => {
            let remain = battery.time_to_full().map(|x| x.get::<second>());
            let remain_msg = match remain {
                Some(sec) => format_duration(sec),
                None => "Infinity".to_string(),
            };
            format!("{percentage}% {remain_msg}")
        }
        BatteryState::Discharging => {
            let remain = battery.time_to_empty().map(|x| x.get::<second>());
            let remain_msg = match remain {
                Some(sec) => format_duration(sec),
                None => "Infinity".to_string(),
            };
            format!("{percentage}% {remain_msg}")
        }
        _ => format!("{percentage}%"),
    };

    let widget = Widget::new(
        "box",
        ["bottom-icon"],
        [("style", format!("color: {color}")), ("tooltip", tooltip)],
        format!(r#""{icon}""#),
    );

    state.update_widget(&widget);

    Ok(())
}
