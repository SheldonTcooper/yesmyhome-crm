<?php

namespace App\Providers;

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Add safe foreign key dropping for SQLite compatibility
        Blueprint::macro('dropForeignSafe', function ($columns) {
            // SQLite doesn't support dropping foreign keys by name
            // Only drop if not using SQLite
            if (DB::getDriverName() !== 'sqlite') {
                return $this->dropForeign($columns);
            }

            return $this;
        });

        // Alias for dropping multiple foreign keys safely
        Blueprint::macro('dropForeignsSafe', function ($foreignKeys) {
            if (DB::getDriverName() !== 'sqlite') {
                foreach ($foreignKeys as $foreignKey) {
                    $this->dropForeign($foreignKey);
                }
            }

            return $this;
        });
    }
}
