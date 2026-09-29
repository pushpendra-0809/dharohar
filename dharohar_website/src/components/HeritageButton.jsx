import React from 'react';
import { ArrowRight, Download, ArrowDown, Play, Compass } from 'lucide-react';

/**
 * Custom Dharohar Heritage Button Language:
 * Inspired by carved stone plaques, Nalanda brick seals, and in-game pixel UI.
 * Strictly free of generic AI pill/capsule shapes.
 */
export default function HeritageButton({
  children,
  href,
  onClick,
  variant = 'default', // 'primary', 'terracotta', 'sandstone', 'pixel', 'outline', 'default'
  icon = 'arrow-right', // 'arrow-right', 'download', 'arrow-down', 'play', 'compass', 'none'
  className = '',
  target,
  rel,
  ...props
}) {
  const getVariantClass = () => {
    switch (variant) {
      case 'primary':
        return 'btn-heritage-primary';
      case 'terracotta':
        return 'btn-heritage-terracotta';
      case 'sandstone':
        return 'btn-heritage-sandstone';
      case 'pixel':
        return 'btn-pixel-heritage';
      case 'outline':
        return 'btn-heritage-outline';
      default:
        return 'bg-parchment-light text-deepBrown border-[1.5px] border-gold hover:bg-terracotta hover:border-terracotta hover:text-ivory shadow-[2.5px_2.5px_0px_rgba(53,38,29,0.2)]';
    }
  };

  const renderIcon = () => {
    switch (icon) {
      case 'arrow-right':
        return <ArrowRight className="w-3.5 h-3.5 transition-transform duration-300 group-hover:translate-x-1" />;
      case 'download':
        return <Download className="w-3.5 h-3.5 transition-transform duration-300 group-hover:translate-y-0.5" />;
      case 'arrow-down':
        return <ArrowDown className="w-3.5 h-3.5 transition-transform duration-300 group-hover:translate-y-1" />;
      case 'play':
        return <Play className="w-3.5 h-3.5 fill-current" />;
      case 'compass':
        return <Compass className="w-3.5 h-3.5 transition-transform duration-500 group-hover:rotate-45" />;
      default:
        return null;
    }
  };

  const baseStyles = variant === 'pixel'
    ? `group relative inline-flex items-center justify-center gap-2.5 rounded-none cursor-pointer ${getVariantClass()} ${className}`
    : `btn-heritage-base group cursor-pointer ${getVariantClass()} ${className}`;

  // Authentic corner brackets for non-pixel variant
  const cornerAccents = variant !== 'pixel' && (
    <>
      <span className="absolute -top-[2px] -left-[2px] w-1.5 h-1.5 bg-current opacity-75 pointer-events-none" />
      <span className="absolute -bottom-[2px] -right-[2px] w-1.5 h-1.5 bg-current opacity-75 pointer-events-none" />
    </>
  );

  if (href) {
    return (
      <a
        href={href}
        className={baseStyles}
        target={target}
        rel={rel}
        {...props}
      >
        {cornerAccents}
        <span>{children}</span>
        {renderIcon()}
      </a>
    );
  }

  return (
    <button
      onClick={onClick}
      className={baseStyles}
      {...props}
    >
      {cornerAccents}
      <span>{children}</span>
      {renderIcon()}
    </button>
  );
}
