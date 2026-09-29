/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        parchment: {
          light: '#FAF5EA',
          DEFAULT: '#F6EEDB',
          dark: '#E8DCBF',
          muted: '#DFD2B1',
        },
        sandstone: {
          light: '#F0D9A8',
          DEFAULT: '#E5C78B',
          dark: '#CCA757',
        },
        gold: {
          light: '#ECC765',
          DEFAULT: '#D4A63A',
          dark: '#B0821A',
        },
        terracotta: {
          light: '#C4744E',
          DEFAULT: '#A95D3A',
          dark: '#853F1F',
        },
        deepBrown: {
          light: '#4D3A2F',
          DEFAULT: '#35261D',
          dark: '#23170F',
          subtle: '#2A1D15',
        },
        heritageGreen: {
          light: '#6E8967',
          DEFAULT: '#52694D',
          dark: '#3A4C36',
        },
        riverBlue: {
          light: '#639BAA',
          DEFAULT: '#477D8C',
          dark: '#315C68',
        },
        warmStone: {
          light: '#A6988C',
          DEFAULT: '#7C6E63',
          dark: '#584C42',
        },
        ivory: '#FCF9F2',
      },
      fontFamily: {
        cinzel: ['Cinzel', 'serif'],
        cormorant: ['"Cormorant Garamond"', 'serif'],
        sans: ['"Plus Jakarta Sans"', 'Inter', 'sans-serif'],
      },
      animation: {
        'subtle-float': 'subtleFloat 5s ease-in-out infinite',
        'subtle-pulse': 'subtlePulse 3.5s ease-in-out infinite',
        'slow-rotate': 'slowRotate 60s linear infinite',
      },
      keyframes: {
        subtleFloat: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-6px)' },
        },
        subtlePulse: {
          '0%, 100%': { opacity: '0.6' },
          '50%': { opacity: '1' },
        },
        slowRotate: {
          '0%': { transform: 'rotate(0deg)' },
          '100%': { transform: 'rotate(360deg)' },
        }
      },
      boxShadow: {
        'plaque': '0 4px 20px -2px rgba(53, 38, 29, 0.08), 0 2px 6px -1px rgba(53, 38, 29, 0.04)',
        'plaque-hover': '0 16px 36px -4px rgba(53, 38, 29, 0.15), 0 4px 12px -2px rgba(53, 38, 29, 0.08)',
        'portal': '0 24px 64px -12px rgba(35, 23, 15, 0.25)',
      }
    },
  },
  plugins: [],
}
