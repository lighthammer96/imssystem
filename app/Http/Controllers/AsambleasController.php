<?php

namespace App\Http\Controllers;

use App\Models\BaseModel;
use App\Models\AsambleasModel;
use App\Models\PaisesModel;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;

class AsambleasController extends Controller
{
    //
    private $base_model;
    private $asambleas_model;
    private $paises_model;

    public function __construct() {
        parent:: __construct();
        $this->asambleas_model = new AsambleasModel();
        $this->base_model = new BaseModel();
        $this->paises_model = new PaisesModel();
    }

    public function index() {
        $view = "asambleas.index";
        $data["title"] = traducir("asambleas.titulo_asambleas");
        $data["subtitle"] = "";
        $data["tabla"] = $this->asambleas_model->tabla()->HTML();

        $botones = array();
        $botones[0] = '<button disabled="disabled" tecla_rapida="F1" style="margin-right: 5px;" class="btn btn-sm btn-default" id="nueva-asamblea"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/agregar-archivo.png').'"><br>'.traducir("traductor.nuevo").' [F1]</button>';
        $botones[1] = '<button disabled="disabled" tecla_rapida="F2" style="margin-right: 5px;" class="btn btn-default btn-sm" id="modificar-asamblea"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/editar-documento.png').'"><br>'.traducir("traductor.modificar").' [F2]</button>';
        $botones[2] = '<button disabled="disabled" tecla_rapida="F7" style="margin-right: 5px;" class="btn btn-default btn-sm" id="eliminar-asamblea"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/delete.png').'"><br>'.traducir("traductor.eliminar").' [F7]</button>';
        $data["botones"] = $botones;
        $data["scripts"] = $this->cargar_js(["asambleas.js?version=260620231629"]);
        return parent::init($view, $data);



    }

    public function buscar_datos() {
        $json_data = $this->asambleas_model->tabla()->obtenerDatos();
        echo json_encode($json_data);
    }


    public function guardar_asambleas(Request $request) {

        $_POST = $this->toUpper($_POST);
        $_POST["asamblea_fecha_inicio"] = $this->FormatoFecha($_REQUEST["asamblea_fecha_inicio"], "server");
        $_POST["asamblea_fecha_fin"] = $this->FormatoFecha($_REQUEST["asamblea_fecha_fin"], "server");
        if ($request->input("asamblea_id") == '') {
            $result = $this->base_model->insertar($this->preparar_datos("asambleas.asambleas", $_POST));
        }else{
            $result = $this->base_model->modificar($this->preparar_datos("asambleas.asambleas", $_POST));
        }


        DB::table("asambleas.agenda")->where("asamblea_id", $result["id"])->delete();
        if(isset($_REQUEST["agenda_descripcion"]) && isset($_REQUEST["agenda_fecha"]) && isset($_REQUEST["agenda_hora"])) {

            $_POST["asamblea_id"] = $result["id"];
            // print_r($this->preparar_datos("asambleas.agenda", $_POST, "D")); exit;

            $this->base_model->insertar($this->preparar_datos("asambleas.agenda", $_POST, "D"), "D");
        }
        echo json_encode($result);
    }

    public function eliminar_asambleas() {


        try {
            $sql_agenda = "SELECT * FROM asambleas.agenda WHERE asamblea_id=".$_REQUEST["id"];
            $agenda = DB::select($sql_agenda);

            if(count($agenda) > 0) {
                throw new Exception(traducir("traductor.eliminar_asamblea_agenda"));
            }



            $result = $this->base_model->eliminar(["asambleas.asambleas","asamblea_id"]);
            echo json_encode($result);
        } catch (Exception $e) {
            echo json_encode(array("status" => "ee", "msg" => $e->getMessage()));
        }
    }


    public function get_asambleas(Request $request) {

        $sql = "SELECT * FROM asambleas.asambleas WHERE asamblea_id=".$request->input("id");
        $one = DB::select($sql);
        echo json_encode($one);
    }

    public function obtener_detalle_agenda(Request $request) {
        $sql = "SELECT ag.*
        FROM asambleas.asambleas AS a
        INNER JOIN asambleas.agenda AS ag ON(ag.asamblea_id=a.asamblea_id)
        WHERE a.estado='A' AND ag.asamblea_id={$request->input("asamblea_id")}";
        // die($sql);
        $result = DB::select($sql);
        echo json_encode($result);
    }

    public function obtener_anios() {
        $array = $this->asambleas_model->obtener_anios();
        echo json_encode($array);
    }


    public function obtener_tipo_convocatoria() {
        $result = $this->asambleas_model->obtener_tipo_convocatoria();
        echo json_encode($result);
    }

    public function obtener_asambleas() {
        $result = $this->asambleas_model->obtener_asambleas();
        echo json_encode($result);
    }

    public function select_init() {

        $data["idpais"] = $this->paises_model->obtener_todos_paises();
        $data["asamblea_anio"] = $this->asambleas_model->obtener_anios();
        $data["tipconv_id"] = $this->asambleas_model->obtener_tipo_convocatoria();


        echo json_encode($data);
    }




}
