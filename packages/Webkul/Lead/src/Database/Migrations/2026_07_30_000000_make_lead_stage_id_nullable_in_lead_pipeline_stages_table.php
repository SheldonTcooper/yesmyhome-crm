<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        if (DB::getDriverName() === 'sqlite') {
            Schema::table('lead_pipeline_stages', function (Blueprint $table) {
                $table->integer('lead_stage_id')->unsigned()->nullable()->change();
            });
        }
    }

    public function down()
    {
        if (DB::getDriverName() === 'sqlite') {
            Schema::table('lead_pipeline_stages', function (Blueprint $table) {
                $table->integer('lead_stage_id')->unsigned()->nullable(false)->change();
            });
        }
    }
};
