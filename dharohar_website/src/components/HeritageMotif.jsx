import React from 'react';

export function HeritageDivider({ className = "" }) {
  return (
    <div className={`flex items-center justify-center gap-3 my-12 ${className}`}>
      <div className="h-[1px] w-16 bg-gradient-to-r from-transparent via-gold/40 to-gold/70" />
      <span className="text-gold text-xs">✦</span>
      <div className="h-[1px] w-2.5 bg-terracotta/40" />
      <span className="text-terracotta text-xs">◆</span>
      <div className="h-[1px] w-2.5 bg-terracotta/40" />
      <span className="text-gold text-xs">✦</span>
      <div className="h-[1px] w-16 bg-gradient-to-l from-transparent via-gold/40 to-gold/70" />
    </div>
  );
}

export function HeritageBadge({ children, className = "" }) {
  return (
    <div className={`inline-flex items-center gap-2 px-3.5 py-1 bg-parchment-light border border-gold/40 shadow-sm text-[11px] font-mono tracking-[0.2em] uppercase text-deepBrown/80 ${className}`}>
      <span className="text-terracotta text-[10px]">✦</span>
      <span>{children}</span>
      <span className="text-terracotta text-[10px]">✦</span>
    </div>
  );
}
