<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Portfolio extends Model
{
    protected $fillable = [
        'title',
        'description',
        'image',
        'category',
        'tag',
        'duration',
        'zone',
        'is_active',
        'sort_order',
    ];

    protected static function boot()
    {
        parent::boot();
        
        static::creating(function ($portfolio) {
            // Générer automatiquement le tag basé sur la catégorie si non fourni
            if (empty($portfolio->tag)) {
                $portfolio->tag = match($portfolio->category) {
                    'realistic' => 'Réaliste',
                    'minimaliste' => 'Minimaliste',
                    'line-art' => 'Line-art',
                    'aquarelle' => 'Couleur',
                    default => ucfirst($portfolio->category)
                };
            }
            
            // Assurer que sort_order a une valeur par défaut si non fournie
            if (is_null($portfolio->sort_order)) {
                $portfolio->sort_order = 0;
            }
        });
    }

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeByCategory($query, $category)
    {
        return $query->where('category', $category);
    }

    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order')->orderBy('created_at', 'desc');
    }

    public function getImageUrlAttribute()
    {
        return asset('storage/' . $this->image);
    }
}