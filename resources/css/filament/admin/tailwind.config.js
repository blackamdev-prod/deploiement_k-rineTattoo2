import preset from '../../../../vendor/filament/filament/tailwind.config.preset'
import colors from 'tailwindcss/colors'

export default {
    presets: [preset],
    content: [
        './app/Filament/**/*.php',
        './resources/views/filament/**/*.blade.php',
        './vendor/filament/**/*.blade.php',
    ],
    theme: {
        extend: {
            colors: {
                primary: {
                    50: '#FEFBF4',
                    100: '#FDF6E3',
                    200: '#FAECB8',
                    300: '#F6E28C',
                    400: '#F0D962',
                    500: '#D4AF37', // K'RINE TATTOO Gold
                    600: '#B8941F',
                    700: '#9C7914',
                    800: '#805E0D',
                    900: '#644408',
                    950: '#332304',
                },
                gray: {
                    ...colors.gray,
                    750: '#374151', // Custom gray for hover states
                    850: '#1F2937',
                    950: '#0F0F0F', // Very dark for backgrounds
                },
            },
            fontFamily: {
                'display': ['Oswald', 'sans-serif'],
                'body': ['Montserrat', 'sans-serif'],
            },
        },
    },
}
