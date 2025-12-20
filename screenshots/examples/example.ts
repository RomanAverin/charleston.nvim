// Charleston colorscheme - TypeScript example

interface ColorPalette {
  bg: string;
  fg: string;
  red: string;
  green: string;
  yellow: string;
  blue: string;
  magenta: string;
  cyan: string;
}

interface ThemeConfig {
  terminal_colors?: boolean;
  italic?: boolean;
  transparent?: boolean;
  palette_overrides?: Partial<ColorPalette>;
}

class ColorScheme {
  private readonly name: string;
  private colors: ColorPalette;
  private cache: Map<string, string> = new Map();

  constructor(name: string, colors: ColorPalette) {
    this.name = name;
    this.colors = colors;
  }

  /**
   * Get color value by name
   * @param colorName - Name of the color
   * @returns Hex color value
   */
  getColor(colorName: keyof ColorPalette): string {
    const cached = this.cache.get(colorName);
    if (cached) return cached;

    const color = this.colors[colorName];
    this.cache.set(colorName, color);
    return color;
  }

  /**
   * Apply theme configuration
   * @param config - Theme configuration options
   */
  applyConfig(config: ThemeConfig): void {
    if (config.palette_overrides) {
      this.colors = { ...this.colors, ...config.palette_overrides };
      this.cache.clear();
    }

    if (config.terminal_colors) {
      this.setTerminalColors();
    }
  }

  private setTerminalColors(): void {
    console.log("Setting terminal colors...");
    // Implementation here
  }

  /**
   * Export theme as JSON
   */
  toJSON(): string {
    return JSON.stringify({
      name: this.name,
      colors: this.colors,
    }, null, 2);
  }
}

// Example usage
const colors: ColorPalette = {
  bg: "#1D2024",
  fg: "#C5C8D3",
  red: "#cc6666",
  green: "#A9C476",
  yellow: "#D0AB3C",
  blue: "#88ABDC",
  magenta: "#B689BC",
  cyan: "#7fb2c8",
};

const theme = new ColorScheme("charleston", colors);
const config: ThemeConfig = {
  terminal_colors: true,
  italic: true,
  transparent: false,
};

theme.applyConfig(config);
console.log(theme.toJSON());
