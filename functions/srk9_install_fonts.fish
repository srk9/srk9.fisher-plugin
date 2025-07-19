function srk9_install_fonts --description "Install fonts from SRK9 font collection"
    echo "Installing SRK9 fonts..."
    echo "========================"
    
    set -l fonts_dir "$HOME/.srk9/src/configurator/fonts"
    set -l target_dir "$HOME/Library/Fonts"
    
    if not test -d $fonts_dir
        echo "Error: SRK9 fonts directory not found at $fonts_dir"
        return 1
    end
    
    if not test -d $target_dir
        echo "Error: System fonts directory not found at $target_dir"
        return 1
    end
    
    echo "Copying fonts from $fonts_dir to $target_dir"
    echo ""
    
    set -l font_count 0
    for font in $fonts_dir/*.ttf
        if test -f $font
            set -l font_name (basename $font)
            echo "  Installing: $font_name"
            cp $font $target_dir/
            set font_count (math $font_count + 1)
        end
    end
    
    if test $font_count -gt 0
        echo ""
        echo "✓ Installed $font_count fonts successfully!"
        echo ""
        echo "To use the new fonts:"
        echo "  1. Restart your terminal application"
        echo "  2. Update your terminal font settings"
        echo "  3. For best results with themes, choose a Nerd Font variant"
    else
        echo "No font files found in $fonts_dir"
        return 1
    end
end