<?php

namespace App\Http\Controllers;

use App\Models\BaseModel;
use App\Models\DistritosmisionerosModel;
use App\Models\DivisionesModel;
use App\Models\IglesiasModel;
use App\Models\InstitucionesModel;
use App\Models\MisionesModel;
use App\Models\PaisesModel;
use App\Models\UnionesModel;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;

class InstitucionesController extends Controller
{
    //
    private $base_model;
    private $instituciones_model;
    private $divisiones_model;
    private $paises_model;
    private $uniones_model;
    private $misiones_model;
    private $distritos_misioneros_model;
    private $iglesias_model;

    public function __construct() {
        parent:: __construct();
        $this->instituciones_model = new InstitucionesModel();
        $this->base_model = new BaseModel();
        $this->divisiones_model = new DivisionesModel();
        $this->paises_model = new PaisesModel();
        $this->uniones_model = new UnionesModel();
        $this->misiones_model = new MisionesModel();
        $this->distritos_misioneros_model = new DistritosmisionerosModel();
        $this->iglesias_model = new IglesiasModel();
    }

    public function index() {
        $view = "instituciones.index";
        $data["title"] = traducir("traductor.titulo_instituciones");
        $data["subtitle"] = "";
        $data["tabla"] = $this->instituciones_model->tabla()->HTML();

        $botones = array();
        $botones[0] = '<button disabled="disabled" tecla_rapida="F1" style="margin-right: 5px;" class="btn btn-default btn-sm" id="nuevo-institucion"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/agregar-archivo.png').'"><br>'.traducir("traductor.nuevo").' [F1]</button>';
        $botones[1] = '<button disabled="disabled" tecla_rapida="F2" style="margin-right: 5px;" class="btn btn-default btn-sm" id="modificar-institucion"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/editar-documento.png').'"><br>'.traducir("traductor.modificar").' [F2]</button>';
        $botones[2] = '<button disabled="disabled" tecla_rapida="F7" style="margin-right: 5px;" class="btn btn-default btn-sm" id="eliminar-institucion"><img style="width: 19px; height: 20px;" src="'.URL::asset('images/iconos/delete.png').'"><br>'.traducir("traductor.eliminar").' [F7]</button>';
        $data["botones"] = $botones;
        $data["scripts"] = $this->cargar_js(["instituciones.js"]);
        return parent::init($view, $data);



    }

    public function buscar_datos() {
        $json_data = $this->instituciones_model->tabla()->obtenerDatos();
        echo json_encode($json_data);
    }


    public function guardar_instituciones(Request $request) {

        $_POST = $this->toUpper($_POST, ["tipo"]);
        $array_pais = explode("|", $_POST["pais_id"]);
        $_POST["pais_id"] = $array_pais[0];
        if(isset($array_pais[1]) && $array_pais[1] == "N" && empty($request->input("idunion"))) {
            $sql = "SELECT * FROM iglesias.union AS u
            INNER JOIN iglesias.union_paises AS up ON(u.idunion=up.idunion)
            WHERE up.pais_id={$_POST["pais_id"]}";
            $res = DB::select($sql);
            $_POST["idunion"] = $res[0]->idunion;
        }

        if ($request->input("idinstitucion") == '') {
            $result = $this->base_model->insertar($this->preparar_datos("iglesias.institucion", $_POST));
        }else{
            $result = $this->base_model->modificar($this->preparar_datos("iglesias.institucion", $_POST));
        }


        echo json_encode($result);
    }

    public function eliminar_instituciones() {


        try {
            // $sql_usuarios = "SELECT * FROM seguridad.usuarios WHERE idinstitucion=".$_REQUEST["id"];
            // $usuarios = DB::select($sql_usuarios);

            // if(count($usuarios) > 0) {
            //     throw new Exception(traducir("traductor.eliminar_perfil_usuario"));
            // }

            // $sql_permisos = "SELECT * FROM seguridad.permisos WHERE idinstitucion=".$_REQUEST["id"];
            // $permisos = DB::select($sql_permisos);

            // if(count($permisos) > 0) {
            //     throw new Exception(traducir("traductor.eliminar_perfil_permisos"));
            // }

            $result = $this->base_model->eliminar(["iglesias.institucion","idinstitucion"]);
            echo json_encode($result);
        } catch (Exception $e) {
            echo json_encode(array("status" => "ee", "msg" => $e->getMessage()));
        }
    }


    public function get_instituciones(Request $request) {

        $sql = "SELECT i.*, (i.pais_id || '|' || p.posee_union) AS pais_id, p.posee_union
        FROM iglesias.institucion AS i
        LEFT JOIN iglesias.paises AS p ON(p.pais_id=i.pais_id)
        WHERE i.idinstitucion=".$request->input("id");
        $one = DB::select($sql);
        echo json_encode($one);
    }

    public function select_init(Request $request) {
        $data["iddivision"] = $this->divisiones_model->obtener_divisiones($request);
        $data["pais_id"] = $this->paises_model->obtener_paises_asociados($request);
        $data["idunion"] = $this->uniones_model->obtener_uniones_paises($request);
        $data["idmision"] = $this->misiones_model->obtener_misiones($request);
        $data["iddistritomisionero"] = $this->distritos_misioneros_model->obtener_distritos_misioneros($request);
        $data["idiglesia"] = $this->iglesias_model->obtener_iglesias($request);

        echo json_encode($data);
    }


}
