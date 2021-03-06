
<div id="modal-distritos" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title"><span class="typeoperacion"></span></h4>
            </div> -->
            <form id="formulario-distritos" class="form-horizontal" role="form">
                
                <div class="modal-body">
                    <div class="row">
                        <input type="hidden" name="iddistrito" class="input-sm entrada">
                        <div class="col-md-6">
                            <label class="control-label">{{ traducir('traductor.pais')}}</label>
                            <select name="pais_id" id="pais_id" class="selectizejs entrada"></select>


                        </div>
                        <div class="col-md-6">
                            <label class="control-label">{{ traducir('traductor.division_1')}}</label>
                            <select name="iddepartamento" id="iddepartamento" class="selectizejs entrada"></select>
    

                        </div>
                        <div class="col-md-6">
                            <label class="control-label">{{ traducir('traductor.division_2')}}</label>
                            <select name="idprovincia" id="idprovincia" class="selectizejs entrada"></select>

                            <!-- <div class="input-group m-bot15 col-md-6 sin-padding">
                                
                                <span class="input-group-btn">
                                    <button style="margin-top: -5px;" type="button" id="nueva-provincia" class="btn btn-primary btn-sm"><i class="fa fa-plus"></i></button>

                                </span>

                            </div> -->

                        </div>   
                        <div class="col-md-6">
                            <label class="control-label">{{ traducir('traductor.descripcion')}}</label>

                            <input autofocus="autofocus" type="text" class="form-control input-sm entrada" name="descripcion"  placeholder=""/>

                        </div>
                        
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default btn-sm" id="cancelar-distrito"><img style="width: 20px; height: 20px;" src="{{ URL::asset('images/iconos/cancelar.png') }}" ><br>[Esc] [{{ traducir('traductor.cancelar') }}]</button>
                    <button type="button" id="guardar-distrito" class="btn btn-default btn-sm"><img style="width: 20px; height: 20px;" src="{{ URL::asset('images/iconos/salvar.png') }}" ><br>[F9] [{{ traducir('traductor.guardar') }}]</button>
                </div>
            </form>

        </div>
    </div>
</div>