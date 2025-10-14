<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PortfolioResource\Pages\CreatePortfolio;
use App\Filament\Resources\PortfolioResource\Pages\EditPortfolio;
use App\Filament\Resources\PortfolioResource\Pages\ListPortfolio;
use Filament\Forms\Components;
use Filament\Schemas\Schema;
use App\Models\Portfolio;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Actions\EditAction;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;
use BackedEnum;

class PortfolioResource extends Resource
{
    protected static ?string $model = Portfolio::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-rectangle-stack';
    
    protected static ?string $navigationLabel = 'Portfolios';
    
    protected static ?string $modelLabel = 'Portfolio';
    
    protected static ?string $pluralModelLabel = 'Portfolios';

    public static function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Components\TextInput::make('title')
                    ->label('Titre')
                    ->required()
                    ->maxLength(255),
                Components\Textarea::make('description')
                    ->label('Description')
                    ->columnSpanFull(),
                Components\FileUpload::make('image')
                    ->label('Image')
                    ->image()
                    ->directory('assets/images/portfolio')
                    ->disk('public')
                    ->maxSize(1024) // 1MB max pour améliorer les performances
                    ->acceptedFileTypes(['image/jpeg', 'image/png', 'image/webp'])
                    ->imageResizeMode('cover')
                    ->imageResizeTargetWidth(800) // Taille réduite
                    ->imageResizeTargetHeight(600) // Taille réduite
                    ->imagePreviewHeight(150) // Preview plus grande
                    ->panelLayout('integrated') // Layout intégré pour meilleur rendu
                    ->uploadingMessage('Upload en cours...')
                    ->imageEditor() // Éditeur d'image intégré
                    ->imageCropAspectRatio('16:9') // Ratio fixe
                    ->helperText('Max 1MB - JPEG, PNG ou WebP recommandés')
                    ->live() // Mise à jour en temps réel
                    ->columnSpanFull(),
                Components\Select::make('category')
                    ->label('Catégorie')
                    ->options([
                        'realistic' => 'Réaliste',
                        'minimaliste' => 'Minimaliste',
                        'line-art' => 'Line-art',
                        'aquarelle' => 'Couleur',
                    ])
                    ->required(),
                Components\TextInput::make('duration')
                    ->label('Durée')
                    ->placeholder('Ex: 3 heures')
                    ->maxLength(255),
                Components\TextInput::make('zone')
                    ->label('Zone corporelle')
                    ->placeholder('Ex: Avant-bras')
                    ->maxLength(255),
                Components\Toggle::make('is_active')
                    ->label('Actif')
                    ->default(true),
                Components\TextInput::make('sort_order')
                    ->label('Ordre de tri')
                    ->numeric()
                    ->default(0),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\ImageColumn::make('image')
                    ->disk('public')
                    ->size(60),
                Tables\Columns\TextColumn::make('title')
                    ->label('Titre')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('category')
                    ->label('Catégorie')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'realistic' => 'danger',
                        'minimaliste' => 'success',
                        'line-art' => 'info',
                        'aquarelle' => 'warning',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'realistic' => 'Réaliste',
                        'minimaliste' => 'Minimaliste',
                        'line-art' => 'Line-art',
                        'aquarelle' => 'Couleur',
                        default => ucfirst($state)
                    }),
                Tables\Columns\TextColumn::make('duration')
                    ->label('Durée'),
                Tables\Columns\TextColumn::make('zone')
                    ->label('Zone'),
                Tables\Columns\IconColumn::make('is_active')
                    ->label('Actif')
                    ->boolean(),
                Tables\Columns\TextColumn::make('sort_order')
                    ->label('Ordre')
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Créé le')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
                    ->label('Modifié le')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('category')
                    ->label('Catégorie')
                    ->options([
                        'realistic' => 'Réaliste',
                        'minimaliste' => 'Minimaliste', 
                        'line-art' => 'Line-art',
                        'aquarelle' => 'Couleur',
                    ]),
                Tables\Filters\TernaryFilter::make('is_active')
                    ->label('Statut')
                    ->trueLabel('Actifs seulement')
                    ->falseLabel('Inactifs seulement')
                    ->native(false),
            ])
            ->actions([
                EditAction::make(),
            ])
            ->bulkActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListPortfolio::route('/'),
            'create' => CreatePortfolio::route('/create'),
            'edit' => EditPortfolio::route('/{record}/edit'),
        ];
    }
}
