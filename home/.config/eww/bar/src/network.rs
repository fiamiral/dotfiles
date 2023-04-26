use std::process::Command;

use crate::{yuck::Widget, State};

enum ConnectionType {
    Ethernet,
    WiFi,
    None,
}

fn get_connection_type() -> ConnectionType {
    let output = Command::new("nmcli")
        .args([
            "--terse",
            "--field",
            "TYPE",
            "connection",
            "show",
            "--active",
        ])
        .output()
        .unwrap();
    let stdout = String::from_utf8(output.stdout)
        .unwrap()
        .lines()
        .map(|x| x.to_string())
        .collect::<Vec<_>>();

    if stdout.iter().any(|x| x == "802-3-ethernet") {
        ConnectionType::Ethernet
    } else if stdout.iter().any(|x| x == "802-11-wireless") {
        ConnectionType::WiFi
    } else {
        ConnectionType::None
    }
}

fn get_wifi_power() -> Result<usize, Box<dyn std::error::Error>> {
    let output = Command::new("nmcli")
        .args([
            "--field",
            "IN-USE,SSID,BARS",
            "--terse",
            "device",
            "wifi",
            "list",
        ])
        .output()
        .unwrap();
    let stdout = String::from_utf8(output.stdout).unwrap();
    let active_line = stdout.lines().find(|x| x.starts_with('*')).ok_or("Error")?;
    let (_ssid, power) = active_line
        .trim_start_matches("*:")
        .split_once(':')
        .unwrap();

    Ok(power.trim_end_matches('_').chars().count())
}

pub fn network(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let icon = match get_connection_type() {
        ConnectionType::Ethernet => "󰈀",
        ConnectionType::WiFi => match get_wifi_power()? {
            4 => "󰤨",
            3 => "󰤥",
            2 => "󰤢",
            1 => "󰤟",
            _ => "󰤯",
        },
        ConnectionType::None => "󰀝",
    };

    let widget = Widget::new("box", ["bottom-icon"], [], format!(r#""{icon}""#));

    state.update_widget(&widget);

    Ok(())
}
