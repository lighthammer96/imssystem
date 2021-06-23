<div id="modal-distritos_misioneros" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none" data-backdrop="static">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <!-- <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title"><span class="typeoperacion"></span></h4>
            </div> -->
            <form id="formulario-distritos_misioneros" class="form-horizontal" role="form">
                
                <div class="modal-body">
                    <div class="row">
                        <input type="hidden" name="iddistritomisionero" class="input-sm entrada">
                        <div class="col-md-12">
                            <label class="control-label">{{ trans('traductor.descripcion')}}</label>

                            <input autofocus="autofocus" type="text" class="form-control input-sm entrada" name="descripcion"  placeholder=""/>

                        </div>
                        <div class="col-md-12">
                            <label class="control-label">{{ trans('traductor.mision')}}</label>

                            <div class="input-group m-bot15 col-md-12 sin-padding">
                                <select name="idmision" id="idmision" class="selectizejs entrada"></select>

                                <span class="input-group-btn">
                                    <button type="button" id="nueva-mision" class="btn btn-primary btn-sm"><i class="fa fa-plus"></i></button>

                                </span>

                            </div>

                        </div>

                        <div class="col-md-12">
                            <label class="control-label">{{ trans('traductor.estado')}}</label>
                            <select name="estado" id="estado" class="form-control input-sm entrada" default-value="1">
                                <option value="1">ACTIVO</option>
                                <option value="0">INACTIVO</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default btn-sm" id="cancelar-distrito-misionero">[Esc] [{{ trans('cancelar') }}]</button>
                    <button type="button" id="guardar-distrito-misionero" class="btn btn-primary btn-sm">[F9] [{{ trans('guardar') }}]</button>
                </div>
            </form>

        </div>
    </div>
</div>