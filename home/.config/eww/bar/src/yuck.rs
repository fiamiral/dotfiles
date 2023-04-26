use std::{collections::BTreeMap, fmt::Display};

pub struct Widget {
    pub name: String,
    pub class: String,
    pub property: BTreeMap<String, String>,
    pub body: String,
}

impl Widget {
    pub fn new(
        name: impl Into<String>,
        class: impl IntoIterator<Item = &'static str>,
        property: impl IntoIterator<Item = (&'static str, String)>,
        body: impl Into<String>,
    ) -> Self {
        Self {
            name: name.into(),
            class: class.into_iter().collect::<Vec<_>>().join(" "),
            property: property
                .into_iter()
                .map(|(k, v)| (k.to_string(), v))
                .collect(),
            body: body.into(),
        }
    }
}

impl Display for Widget {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let property = self.property.iter().fold(String::new(), |mut s, (k, v)| {
            s.push(':');
            s.push_str(k);
            s.push(' ');
            s.push('"');
            s.push_str(v);
            s.push('"');
            s
        });

        write!(
            f,
            r#"({} :class "{}" {} {})"#,
            self.name, self.class, property, self.body
        )
    }
}
