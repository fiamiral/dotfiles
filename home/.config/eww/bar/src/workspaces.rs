use hyprland::{
    data::{self, Workspaces},
    event_listener::EventListener,
    shared::{HyprData, HyprDataActive},
};
use serde::Serialize;

use crate::State;

#[derive(Serialize)]
struct Workspace {
    name: String,
    focused: bool,
}

pub fn workspaces(_state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    print_workspace_list();

    let mut listener = EventListener::new();

    listener.add_workspace_added_handler(|_| {
        print_workspace_list();
    });

    listener.add_workspace_moved_handler(|_| {
        print_workspace_list();
    });

    listener.add_workspace_change_handler(|_| {
        print_workspace_list();
    });

    listener.add_workspace_destroy_handler(|_| {
        print_workspace_list();
    });

    listener.start_listener()?;

    Ok(())
}

fn print_workspace_list() {
    println!("{}", list_workspaces().unwrap());
}

fn list_workspaces() -> Result<String, Box<dyn std::error::Error>> {
    let active = data::Workspace::get_active()?.name;

    let ws = Workspaces::get()?
        .filter(|ws| ws.name != "special")
        .map(|ws| {
            let name = ws.name;
            let focused = name == active;

            Workspace { name, focused }
        })
        .collect::<Vec<_>>();

    Ok(serde_json::to_string(&ws).unwrap())
}
