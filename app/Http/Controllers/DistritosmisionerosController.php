<?php

namespace App\Http\Controllers;

use App\Models\BaseModel;
use App\Models\DistritosmisionerosModel;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;

class DistritosmisionerosController extends Controller
{
    //
    private $base_model;
    private $distritos_misioneros_model;
    
    public function __construct() {
        parent:: __construct();
        $this->distritos_misioneros_model = new DistritosmisionerosModel();
        $this->base_model = new BaseModel();
    }

    public function index() {
        $view = "distritos_misioneros.index";
        $data["title"] = traducir('traductor.titulo_distritos_misioneros');
        $data["subtitle"] = "";
        $data["tabla"] = $this->distritos_misioneros_model->tabla()->HTML();

        $botones = array();
        $botones[0] = '<button disabled="disabled" tecla_rapida="F1" style="margin-right: 5px;" class="btn btn-default btn-sm" id="nuevo-distrito-misionero"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/agregar-archivo.png').'"><br>'.traducir("traductor.nuevo").' [F1]</button>';
        $botones[1] = '<button disabled="disabled" tecla_rapida="F2" style="margin-right: 5px;" class="btn btn-default btn-sm" id="modificar-distrito-misionero"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/editar-documento.png').'"><br>'.traducir("traductor.modificar").' [F2]</button>';
        $botones[2] = '<button disabled="disabled" tecla_rapida="F7" style="margin-right: 5px;" class="btn btn-default btn-sm" id="eliminar-distrito-misionero"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/delete.png').'"><br>'.traducir("traductor.eliminar").' [F7]</button>';
        $data["botones"] = $botones;
        $data["scripts"] = $this->cargar_js(["divisiones.js", "idiomas.js", "paises.js", "uniones.js", "misiones.js", "distritos_misioneros.js?07122021"]);
        return parent::init($view, $data);

      
       
    }

    public function buscar_datos() {
        $json_data = $this->distritos_misioneros_model->tabla()->obtenerDatos();
        echo json_encode($json_data);
    }


    public function guardar_distritos_misioneros(Request $request) {
   
        $_POST = $this->toUpper($_POST, ["descripcion"]);
        if ($request->input("iddistritomisionero") == '') {
            $result = $this->base_model->insertar($this->preparar_datos("iglesias.distritomisionero", $_POST));
        }else{
            $result = $this->base_model->modificar($this->preparar_datos("iglesias.distritomisionero", $_POST));
        }

        echo json_encode($result);
    }

    public function eliminar_distritos_misioneros() {

        try {
            $sql_iglesias = "SELECT * FROM iglesias.iglesia WHERE iddistritomisionero=".$_REQUEST["id"];
            $iglesias = DB::select($sql_iglesias);

            if(count($iglesias) > 0) {
                throw new Exception(traducir("traductor.eliminar_distrito_misionero_iglesia"));
            }

            $result = $this->base_model->eliminar(["iglesias.distritomisionero","iddistritomisionero"]);
            echo json_encode($result);
        } catch (Exception $e) {
            echo json_encode(array("status" => "ee", "msg" => $e->getMessage()));
        }
       
        
    }


    public function get_distritos_misioneros(Request $request) {

        $sql = "SELECT * FROM iglesias.distritomisionero WHERE iddistritomisionero=".$request->input("id");
        $one = DB::select($sql);
        echo json_encode($one);
    }

    public function obtener_distritos_misioneros(Request $request) {

        $sql = "";
        $all = false; 
        $result = array();
		if(isset($_REQUEST["idmision"]) && !empty($_REQUEST["idmision"])) {
	
			$sql = "SELECT iddistritomisionero AS id, descripcion FROM iglesias.distritomisionero WHERE estado='1' AND idmision=".$request->input("idmision")." ".session("where_distrito_misionero").
            " ORDER BY descripcion ASC";
		} elseif(session("perfil_id") != 1 && session("perfil_id") != 2) {
            $sql = "SELECT iddistritomisionero AS id, descripcion
            FROM iglesias.distritomisionero WHERE estado='1' ".session("where_distrito_misionero").session("where_mision_padre").
            " ORDER BY descripcion ASC";
            $all = true;
		}

        if($sql != "") {
            $result = DB::select($sql);
        }
 
        if(count($result) == 1 && session("perfil_id") != 1 && session("perfil_id") != 2 && $all) {
            // print_r($result);
            $result[0]->defecto = "S";
        }
        echo json_encode($result);
    }

    
    public function obtener_distritos_misioneros_all(Request $request) {
        $array = array("id" => 0, "descripcion" => "Todos");
        $array = (object) $array;
        $sql = "";
        $result = array();
		if(isset($_REQUEST["idmision"]) && !empty($_REQUEST["idmision"])) {
	
			$sql = "SELECT iddistritomisionero AS id, descripcion FROM iglesias.distritomisionero WHERE estado='1' AND idmision=".$request->input("idmision")." ".session("where_distrito_misionero").
            " ORDER BY descripcion ASC";
		} elseif(session("perfil_id") != 1 && session("perfil_id") != 2) {
            // $sql = "SELECT iddistritomisionero AS id, descripcion FROM iglesias.distritomisionero WHERE estado='1' ".session("where_distrito_misionero").
            // " ORDER BY descripcion ASC";
		}

        if($sql != "") {
            $result = DB::select($sql);
        }
        array_push($result, $array);
        echo json_encode($result);
    }


    public function obtener_distritos_misioneros_todos(Request $request) {

        $sql = "";
		if(isset($_REQUEST["idmision"]) && !empty($_REQUEST["idmision"])) {
	
			$sql = "SELECT iddistritomisionero AS id, descripcion FROM iglesias.distritomisionero WHERE estado='1' AND idmision=".$request->input("idmision").
            " ORDER BY descripcion ASC";
		} else {
            $sql = "SELECT iddistritomisionero AS id, descripcion FROM iglesias.distritomisionero WHERE estado='1' ".
            " ORDER BY descripcion ASC";
		}

        $result = DB::select($sql);
        echo json_encode($result);
    }

}
