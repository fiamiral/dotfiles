use serde::Serialize;
use swayipc::{Connection, EventType};

use crate::State;

#[derive(Serialize)]
struct Workspace {
    name: String,
    focused: bool,
}

pub fn workspaces(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let dummy_conn = Connection::new()?;
    let mut conn = Connection::new()?;

    // Initial
    state.update(get_info(&mut conn)?);

    let events = dummy_conn.subscribe([EventType::Workspace])?;

    for _ in events {
        state.update(get_info(&mut conn)?);
    }

    Ok(())
}

fn get_info(conn: &mut Connection) -> Result<String, Box<dyn std::error::Error>> {
    let workspaces = conn
        .get_workspaces()?
        .into_iter()
        .map(|ws| Workspace {
            name: ws.name,
            focused: ws.focused,
        })
        .collect::<Vec<_>>();

    Ok(serde_json::to_string(&workspaces).unwrap())
}
