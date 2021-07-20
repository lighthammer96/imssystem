@extends('layouts.layout')
{{-- @extends('layouts.header') --}}
{{-- @extends('layouts.menu') --}}
{{-- @extends('layouts.aside') --}}
{{-- @extends('layouts.footer') --}}


@section('content')
<style>
  /* .celda:hover {
    background-color: #FFCC00;
    cursor: pointer
  } */

  .fila:hover {
    background-color: #FFFF99
  }
</style>
<form id="formulario-miembros_iglesia" class="form-horizontal" role="form">
    <div class="row">
    
            <div class="col-md-4 col-md-offset-4">
                <div class="row">
                    <div class="col-md-8 col-md-offset-1">
                        <label class="control-label">División</label>

                        <select  class="entrada selectizejs" name="iddivision" id="iddivision">

                        </select>
                    </div>
                    <div class="col-md-8 col-md-offset-1">
                        <label class="control-label">País</label>

                        <select  class="entrada selectizejs" name="pais_id" id="pais_id">

                        </select>

                    </div>
                    <div class="col-md-8 col-md-offset-1 union">
                        <label class="control-label">Unión</label>

                        <select  class="entrada selectizejs" name="idunion" id="idunion">

                        </select>

                    </div>
                    <div class="col-md-8 col-md-offset-1">
                        <label class="control-label">Asociación/Misión</label>

                        <select  class="entrada selectizejs" name="idmision" id="idmision">

                        </select>

                    </div>
                    <div class="col-md-8 col-md-offset-1">
                        <label class="control-label">Distrito Misionero</label>

                        <select  class="entrada selectizejs" name="iddistritomisionero" id="iddistritomisionero">

                        </select>

                    </div>
                    <div class="col-md-8 col-md-offset-1">
                        <label class="control-label">Iglesia</label>

                        <select  class="entrada selectizejs" name="idiglesia" id="idiglesia">

                        </select>

                    </div>
                    <div class="col-md-8 col-md-offset-1" style="margin-top: 15px;">
                        <center>
                            <button type="button" id="ver-reporte" class="btn btn-success">{{ traducir("traductor.ver") }}</button>
                        </center>
                    </div>
                </div>

            </div>
      

        
        
    </div>
   

</form>

   
@endsection
