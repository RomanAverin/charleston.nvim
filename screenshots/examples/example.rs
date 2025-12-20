// Charleston colorscheme - Rust example
use std::collections::HashMap;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ColorPalette {
    bg: String,
    fg: String,
    red: String,
    green: String,
    yellow: String,
    blue: String,
    magenta: String,
    cyan: String,
}

#[derive(Debug, Clone)]
pub struct ColorScheme {
    name: String,
    colors: ColorPalette,
    cache: HashMap<String, String>,
}

impl ColorScheme {
    /// Create a new colorscheme instance
    pub fn new(name: impl Into<String>, colors: ColorPalette) -> Self {
        Self {
            name: name.into(),
            colors,
            cache: HashMap::new(),
        }
    }

    /// Get color value by name
    pub fn get_color(&mut self, color_name: &str) -> Option<&str> {
        if let Some(cached) = self.cache.get(color_name) {
            return Some(cached);
        }

        let color = match color_name {
            "bg" => &self.colors.bg,
            "fg" => &self.colors.fg,
            "red" => &self.colors.red,
            "green" => &self.colors.green,
            "yellow" => &self.colors.yellow,
            "blue" => &self.colors.blue,
            "magenta" => &self.colors.magenta,
            "cyan" => &self.colors.cyan,
            _ => return None,
        };

        self.cache.insert(color_name.to_string(), color.clone());
        Some(color)
    }

    /// Export colorscheme to JSON
    pub fn to_json(&self) -> Result<String, serde_json::Error> {
        serde_json::to_string_pretty(&self.colors)
    }
}

impl Default for ColorPalette {
    fn default() -> Self {
        Self {
            bg: "#1D2024".to_string(),
            fg: "#C5C8D3".to_string(),
            red: "#cc6666".to_string(),
            green: "#A9C476".to_string(),
            yellow: "#D0AB3C".to_string(),
            blue: "#88ABDC".to_string(),
            magenta: "#B689BC".to_string(),
            cyan: "#7fb2c8".to_string(),
        }
    }
}

fn main() {
    let colors = ColorPalette::default();
    let mut scheme = ColorScheme::new("charleston", colors);

    // Print some colors
    for name in &["bg", "fg", "blue"] {
        if let Some(color) = scheme.get_color(name) {
            println!("{}: {}", name, color);
        }
    }

    // Export to JSON
    match scheme.to_json() {
        Ok(json) => println!("\nExported JSON:\n{}", json),
        Err(e) => eprintln!("Error: {}", e),
    }
}
