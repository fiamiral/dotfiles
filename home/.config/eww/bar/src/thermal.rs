use serde_json::json;
use sysinfo::{ComponentExt, System, SystemExt};

use crate::{colors, State};

pub fn thermal(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let system = {
        let mut system = System::new();
        system.refresh_components_list();
        system
    };

    let temperature = system
        .components()
        .iter()
        .map(|x| x.temperature() as i32)
        .max()
        .unwrap();

    let icon = match temperature {
        ..=39 => "",
        40..=49 => "",
        50..=59 => "",
        60..=69 => "",
        70.. => "",
    };

    let color = match temperature {
        ..=54 => colors::FROST1,
        55..=64 => colors::YELLOW,
        65..=74 => colors::ORANGE,
        75.. => colors::RED,
    };

    state.update(
        json!({
            "tooltip": format!("{temperature} °C"),
            "color": color,
            "icon": icon,
        })
        .to_string(),
    );

    Ok(())
}
