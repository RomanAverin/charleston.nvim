#!/usr/bin/env python3
"""Charleston colorscheme demonstration - Python example"""

from typing import List, Dict, Optional
import json


class ColorScheme:
    """A simple colorscheme manager class"""

    def __init__(self, name: str, colors: Dict[str, str]):
        self.name = name
        self.colors = colors
        self._cache = {}

    def get_color(self, color_name: str) -> Optional[str]:
        """Get color value by name

        Args:
            color_name: Name of the color to retrieve

        Returns:
            Hex color value or None if not found
        """
        return self.colors.get(color_name)

    def set_color(self, color_name: str, value: str) -> None:
        """Set or update a color value"""
        if not value.startswith('#'):
            raise ValueError(f"Invalid color value: {value}")
        self.colors[color_name] = value
        self._invalidate_cache()

    def _invalidate_cache(self) -> None:
        """Clear internal cache"""
        self._cache.clear()

    def export_json(self) -> str:
        """Export colorscheme to JSON"""
        data = {
            "name": self.name,
            "colors": self.colors
        }
        return json.dumps(data, indent=2)


def main():
    # Define color palette
    colors = {
        "bg": "#1D2024",
        "fg": "#C5C8D3",
        "red": "#cc6666",
        "green": "#A9C476",
        "yellow": "#D0AB3C",
        "blue": "#88ABDC",
    }

    # Create colorscheme instance
    scheme = ColorScheme("charleston", colors)

    # Print some colors
    for name in ["bg", "fg", "blue"]:
        color = scheme.get_color(name)
        print(f"{name}: {color}")

    # Export to JSON
    print("\nExported JSON:")
    print(scheme.export_json())


if __name__ == "__main__":
    main()
