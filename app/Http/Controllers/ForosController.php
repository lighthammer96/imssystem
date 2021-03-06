<?php

namespace App\Http\Controllers;

use App\Models\BaseModel;
use App\Models\ForosModel;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;

class ForosController extends Controller
{
    //
    private $base_model;
    private $foros_model;
    
    public function __construct() {
        parent:: __construct();
        $this->foros_model = new ForosModel();
        $this->base_model = new BaseModel();
    }

    public function index() {
        $view = "foros.index";
        $data["title"] = traducir("asambleas.titulo_foros");
        $data["subtitle"] = "";
        $data["tabla"] = $this->foros_model->tabla()->HTML();

        $botones = array();
        $botones[0] = '<button disabled="disabled" tecla_rapida="F1" style="margin-right: 5px;" class="btn btn-default btn-sm" id="nuevo-foro"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/agregar-archivo.png').'"><br>'.traducir("traductor.nuevo").' [F1]</button>';
        $botones[1] = '<button disabled="disabled" tecla_rapida="F2" style="margin-right: 5px;" class="btn btn-default btn-sm" id="modificar-foro"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/editar-documento.png').'"><br>'.traducir("traductor.modificar").' [F2]</button>';
        $botones[2] = '<button disabled="disabled" tecla_rapida="F7" style="margin-right: 5px;" class="btn btn-default btn-sm" id="eliminar-foro"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/delete.png').'"><br>'.traducir("traductor.eliminar").' [F7]</button>';
        $data["botones"] = $botones;
        $data["scripts"] = $this->cargar_js(["foros.js"]);
        return parent::init($view, $data);
        
    }

    public function buscar_datos() {
        $json_data = $this->foros_model->tabla()->obtenerDatos();
        echo json_encode($json_data);
    }


    public function guardar_foros(Request $request) {
        $asamblea = explode("|", $_POST["asamblea_id"]);
        $_POST["asamblea_id"] = $asamblea[1];
        $_POST = $this->toUpper($_POST);
        if ($request->input("foro_id") == '') {
            $_POST["foro_fecha"] = date("Y-m-d");
            $_POST["foro_hora"] = date("H:i:s");
            $result = $this->base_model->insertar($this->preparar_datos("asambleas.foros", $_POST));
        }else{
            $result = $this->base_model->modificar($this->preparar_datos("asambleas.foros", $_POST));
        }

   
    
        // $sql_asamblea = "SELECT * FROM asambleas.asambleas WHERE asamblea_id={$asamblea[1]}";
        // $asamblea = DB::select($sql_asamblea);
        // $result["datos"][0]["asamblea"] = $asamblea[0]->asamblea_descripcion;
        echo json_encode($result);
    }

    public function eliminar_foros() {
       

        try {
       

            $sql_detalle = "SELECT * FROM asambleas.detalle_foros WHERE foro_id=".$_REQUEST["id"];
            $detalle = DB::select($sql_detalle);

            if(count($detalle) > 0) {
                throw new Exception(traducir("traductor.eliminar_foros_detalle"));
            }

            $result = $this->base_model->eliminar(["asambleas.foros","foro_id"]);
            echo json_encode($result);
        } catch (Exception $e) {
            echo json_encode(array("status" => "ee", "msg" => $e->getMessage()));
        }
    }


    public function get_foros(Request $request) {

        $sql = "SELECT f.*, (tc.tipconv_id  || '|'  || f.asamblea_id) AS asamblea_id FROM asambleas.foros  AS f
        INNER JOIN asambleas.asambleas AS a ON(a.asamblea_id=f.asamblea_id)
        INNER JOIN asambleas.tipo_convocatoria AS tc ON(tc.tipconv_id=a.tipconv_id)
        WHERE f.foro_id=".$request->input("id");
        $one = DB::select($sql);
        echo json_encode($one);
    }

    public function obtener_foros() {
        $sql = "SELECT f.foro_id AS id,  f.foro_descripcion AS descripcion 
        FROM asambleas.foros AS f 
       
        WHERE f.estado='A'";
        // die($sql);
        $result = DB::select($sql);
        echo json_encode($result);
    }


    

    
}
