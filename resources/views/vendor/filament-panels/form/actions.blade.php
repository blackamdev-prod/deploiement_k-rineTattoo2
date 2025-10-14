@props([
    'actions' => [],
    'fullWidth' => false,
    'alignment' => null,
])

@php
    $containerClasses = \Illuminate\Support\Arr::toCssClasses([
        'fi-form-actions',
        'flex flex-wrap items-center gap-3',
        'sm:justify-start' => $alignment !== 'center',
        'sm:justify-center' => $alignment === 'center',
        'sm:justify-end' => $alignment === 'end',
    ]);
@endphp

@if ($actions && count($actions))
    <div {{ $attributes->class([$containerClasses]) }}>
        @foreach ($actions as $action)
            {{ $action }}
        @endforeach
    </div>
@endif