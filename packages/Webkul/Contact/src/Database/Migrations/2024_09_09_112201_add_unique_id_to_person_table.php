<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('persons', function (Blueprint $table) {
            $table->string('unique_id')->nullable()->unique();
        });

        if (DB::getDriverName() === 'sqlite') {
            // SQLite: use PHP to extract and concatenate
            $persons = DB::table('persons')->get();

            foreach ($persons as $person) {
                $email = '';
                $phone = '';

                if ($person->emails) {
                    $emails = json_decode($person->emails, true);
                    $email = $emails[0]['value'] ?? '';
                }

                if ($person->contact_numbers) {
                    $phones = json_decode($person->contact_numbers, true);
                    $phone = $phones[0]['value'] ?? '';
                }

                $unique_id = implode('|', [
                    $person->user_id,
                    $person->organization_id,
                    $email,
                    $phone
                ]);

                DB::table('persons')
                    ->where('id', $person->id)
                    ->update(['unique_id' => $unique_id]);
            }
        } else {
            // MySQL/PostgreSQL: use SQL
            $tableName = DB::getTablePrefix().'persons';

            DB::statement("
                UPDATE {$tableName}
                SET unique_id = CONCAT(
                    user_id, '|',
                    organization_id, '|',
                    JSON_UNQUOTE(JSON_EXTRACT(emails, '$[0].value')), '|',
                    JSON_UNQUOTE(JSON_EXTRACT(contact_numbers, '$[0].value'))
                )
            ");
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('persons', function (Blueprint $table) {
            $table->dropColumn('unique_id');
        });
    }
};
