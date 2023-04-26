use swayipc::{Connection, EventType};

use crate::{yuck::Widget, State};

pub fn workspaces(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let dummy_conn = Connection::new()?;
    let mut conn = Connection::new()?;

    // Initial
    state.update_widget(&get_widget(&mut conn)?);

    let events = dummy_conn.subscribe([EventType::Workspace])?;

    for _ in events {
        state.update_widget(&get_widget(&mut conn)?);
    }

    Ok(())
}

fn get_widget(conn: &mut Connection) -> Result<Widget, Box<dyn std::error::Error>> {
    let body = conn
        .get_workspaces()?
        .into_iter()
        .map(|ws| {
            let mut class = vec!["workspace-icon"];
            if ws.focused {
                class.push("workspace-icon-focused")
            };
            Widget::new(
                "button",
                class,
                [("onclick", format!("swaymsg workspace {}", ws.name))],
                ws.name,
            )
            .to_string()
        })
        .collect::<String>();

    let widget = Widget::new(
        "box",
        ["workspaces"],
        [("orientation", "vertical".into())],
        body,
    );

    Ok(widget)
}
