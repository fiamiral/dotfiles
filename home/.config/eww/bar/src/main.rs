use std::{thread, time::Duration};

use clap::{Parser, Subcommand};

mod colors;

mod battery;
mod network;
mod thermal;
mod workspaces;

#[derive(Parser)]
struct Args {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    Thermal,
    Battery,
    Workspaces,
    Network,
}

#[derive(Debug, Clone, Default)]
pub struct State {
    last_widget: String,
}

impl State {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn update(&mut self, widget: impl Into<String>) -> bool {
        let widget = widget.into();
        if widget != self.last_widget {
            println!("{widget}");
            self.last_widget = widget;
            true
        } else {
            false
        }
    }
}

fn main() {
    let args = Args::parse();

    let mut state = State::new();

    loop {
        match args.command {
            Command::Thermal => thermal::thermal(&mut state),
            Command::Battery => battery::battery(&mut state),
            Command::Workspaces => workspaces::workspaces(&mut state),
            Command::Network => network::network(&mut state),
        }
        .unwrap_or_else(|x| eprintln!("{x}"));

        thread::sleep(Duration::from_secs(1));
    }
}
