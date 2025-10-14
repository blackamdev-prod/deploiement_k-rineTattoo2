<x-filament-panels::page.simple>
    {{ $this->form }}
    
    {{-- Inline actions to avoid component compilation issues --}}
    @php
        $actions = $this->getCachedFormActions();
        $fullWidth = $this->hasFullWidthFormActions();
    @endphp
    
    @if ($actions && count($actions))
        <div class="fi-form-actions flex flex-wrap items-center gap-3">
            @foreach ($actions as $action)
                {{ $action }}
            @endforeach
        </div>
    @endif
</x-filament-panels::page.simple>