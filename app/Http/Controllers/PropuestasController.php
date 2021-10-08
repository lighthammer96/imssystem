<?php

namespace App\Http\Controllers;

use App\Models\AsociadosModel;
use App\Models\BaseModel;
use App\Models\PropuestasModel;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PropuestasController extends Controller
{
    //
    private $base_model;
    private $propuestas_model;
    
    public function __construct() {
        parent:: __construct();
        $this->propuestas_model = new PropuestasModel();
        $this->asociados_model = new AsociadosModel();
        $this->base_model = new BaseModel();
    }

    public function temas() {
        $view = "propuestas.temas";
        $data["title"] = traducir("asambleas.titulo_propuestas_temas");
        $data["subtitle"] = "";
        $data["tabla"] = $this->propuestas_model->tabla()->HTML();
        $data["tabla_asociados"] = $this->asociados_model->tabla()->HTML();
        $botones = array();
        $botones[0] = '<button disabled="disabled" tecla_rapida="F1" style="margin-right: 5px;" class="btn btn-primary btn-sm" id="nueva-propuesta-tema">'.traducir("traductor.nuevo").' [F1]</button>';
        $botones[1] = '<button disabled="disabled" tecla_rapida="F2" style="margin-right: 5px;" class="btn btn-success btn-sm" id="modificar-propuesta-tema">'.traducir("traductor.modificar").' [F2]</button>';
        
        $botones[2] = '<button disabled="disabled" tecla_rapida="F7" style="margin-right: 5px;" class="btn btn-danger btn-sm" id="eliminar-propuesta-tema">'.traducir("traductor.eliminar").' [F7]</button>';

        $botones[3] = '<button disabled="disabled" tecla_rapida="F10" style="margin-right: 5px;" class="btn btn-warning btn-sm" id="traducir-propuesta-tema">'.traducir("asambleas.traducir").'</button>';

        $data["botones"] = $botones;
        $data["scripts"] = $this->cargar_js(["propuestas_temas.js"]);
        return parent::init($view, $data);  

      
       
    }


    public function elecciones() {
        $view = "propuestas.elecciones";
        $data["title"] = traducir("asambleas.titulo_propuestas_elecciones");
        $data["subtitle"] = "";
        $data["tabla"] = $this->propuestas_model->tabla_propuestas_elecciones()->HTML();

        $botones = array();
        $botones[0] = '<button disabled="disabled" tecla_rapida="F1" style="margin-right: 5px;" class="btn btn-primary btn-sm" id="nueva-propuesta-eleccion">'.traducir("traductor.nuevo").' [F1]</button>';
        $botones[1] = '<button disabled="disabled" tecla_rapida="F2" style="margin-right: 5px;" class="btn btn-success btn-sm" id="modificar-propuesta-eleccion">'.traducir("traductor.modificar").' [F2]</button>';
        
        $botones[2] = '<button disabled="disabled" tecla_rapida="F7" style="margin-right: 5px;" class="btn btn-danger btn-sm" id="eliminar-propuesta-eleccion">'.traducir("traductor.eliminar").' [F7]</button>';

        $botones[3] = '<button disabled="disabled" tecla_rapida="F10" style="margin-right: 5px;" class="btn btn-warning btn-sm" id="traducir-propuesta-eleccion">'.traducir("asambleas.traducir").'</button>';



        $data["botones"] = $botones;
        $data["scripts"] = $this->cargar_js(["propuestas_elecciones.js"]);
        return parent::init($view, $data);  
    }

    public function buscar_datos() {
        $json_data = $this->propuestas_model->tabla()->obtenerDatos();
        echo json_encode($json_data);
    }

    public function buscar_datos_elecciones() {
        $json_data = $this->propuestas_model->tabla_propuestas_elecciones()->obtenerDatos();
        echo json_encode($json_data);
    }


    public function guardar_propuestas_temas(Request $request) {

        $array_traducciones = array();
        
        try {
            DB::beginTransaction();
            // print_r($_REQUEST); 
            // exit;
            
            $idioma = (isset($_REQUEST["tpt_idioma"])) ? $_REQUEST["tpt_idioma"] : "";
            foreach ($_REQUEST as $key => $value) {
            // $arr = explode("_traduccion", $key);
                if(strpos($key, "_traduccion") !== false) {

                    if(!empty($value)) {
                        $array_traducciones[str_replace("_traduccion","",$key)] = $value;

                        if(str_replace("_traduccion","",$key) == "tpt_idioma") {
                            $idioma = $value;
                        }
                    }
                    
                    // echo $key." -> ". $value." ".str_replace("_traduccion","",$key)."\n";
                }

            }
            // print_r($array_traducciones); 
            // exit;
            $_POST = $this->toUpper($_POST, ["pt_email", "tpt_idioma", "lugar", "tabla"]);
           
            $asamblea = array();
            $pais = array();
            if(isset($_POST["asamblea_id"])) {
                $asamblea = explode("|", $_POST["asamblea_id"]);
            }

            if(isset($_POST["pais_id"])) {
                $pais = explode("|", $_POST["pais_id"]);
            }
            
            $_POST["asamblea_id"] = "";
            $_POST["pais_id"] = "";
        
            $_POST["pt_fecha_reunion_cpag"] = $this->FormatoFecha($_REQUEST["pt_fecha_reunion_cpag"], "server");
            $_POST["pt_fecha_reunion_uya"] = $this->FormatoFecha($_REQUEST["pt_fecha_reunion_uya"], "server");

            if(count($asamblea) > 0) {
                $_POST["asamblea_id"] = $asamblea[1];
            }

            if(count($pais) > 0) {
                $_POST["pais_id"] = $pais[0];
            }
            // print_r($_POST); exit;
            // print_r($this->preparar_datos("asambleas.propuestas_temas", $_POST));
            if ($request->input("pt_id") == '') {
                $_POST["pt_fecha"] = date("Y-m-d");
                $result = $this->base_model->insertar($this->preparar_datos("asambleas.propuestas_temas", $_POST));
            }else{
                $result = $this->base_model->modificar($this->preparar_datos("asambleas.propuestas_temas", $_POST));
            }
            $_POST["pt_id"] = $result["id"];
            DB::table("asambleas.traduccion_propuestas_temas")->where("pt_id", $result["id"])->where("tpt_idioma", $idioma)->delete();
            // print_r($array_traducciones);
            if(count($array_traducciones) > 0){
                // print_r($this->preparar_datos("asambleas.traduccion_propuestas_temas", $array_traducciones));
                $array_traducciones["pt_id"] = $_POST["pt_id"];
                $array_traducciones = $this->toUpper($array_traducciones, ["tpt_idioma"]);
                $result = $this->base_model->insertar($this->preparar_datos("asambleas.traduccion_propuestas_temas", $array_traducciones));
                
            } else {
                // print_r($this->preparar_datos("asambleas.traduccion_propuestas_temas", $_POST));
                $result = $this->base_model->insertar($this->preparar_datos("asambleas.traduccion_propuestas_temas", $_POST));
            }

       
       
            DB::commit();
            echo json_encode($result);
        } catch (Exception $e) {
            DB::rollBack();
            $response["status"] = "ei"; 
            $response["msg"] = $e->getMessage(); 
            echo json_encode($response);
        }
    }


    public function guardar_propuestas_elecciones(Request $request) {
    //    exit;

        $array_traducciones = array();
        
        try {
            DB::beginTransaction();

            $idioma = (isset($_REQUEST["tpe_idioma"])) ? $_REQUEST["tpe_idioma"] : "";
            foreach ($_REQUEST as $key => $value) {
            // $arr = explode("_traduccion", $key);
                if(strpos($key, "_traduccion") !== false) {

                    if(!empty($value)) {
                        $array_traducciones[str_replace("_traduccion","",$key)] = $value;

                        if(str_replace("_traduccion","",$key) == "tpe_idioma") {
                            $idioma = $value;
                        }
                    }
                    
                    // echo $key." -> ". $value." ".str_replace("_traduccion","",$key)."\n";
                }

            }

            $_POST = $this->toUpper($_POST, ["tpe_idioma"]);
            // print_r($array_traducciones); exit;

            if ($request->input("pe_id") == '') {
                $_POST["pe_fecha"] = date("Y-m-d");
                $sql = "SELECT COALESCE(MAX(pe_correlativo) + 1, 1) AS correlativo FROM asambleas.propuestas_elecciones  WHERE date_part('year', pe_fecha)=".date("Y");
                $correlativo = DB::select($sql);
                $_POST["pe_correlativo"] = $correlativo[0]->correlativo;
                $result = $this->base_model->insertar($this->preparar_datos("asambleas.propuestas_elecciones", $_POST));
            }else{
                $result = $this->base_model->modificar($this->preparar_datos("asambleas.propuestas_elecciones", $_POST));
            }

            // print_r($result);
            $_POST["pe_id"] = $result["id"];

            DB::table("asambleas.detalle_propuestas")->where("pe_id", $request->input("pe_id"))->where("dp_idioma", $idioma)->delete();
            if(isset($_REQUEST["dp_descripcion"]) && gettype($_REQUEST["dp_descripcion"]) == "array" && count($_REQUEST["dp_descripcion"]) > 0) {
            
                
                $result = $this->base_model->insertar($this->preparar_datos("asambleas.detalle_propuestas", $_POST, "D"), "D");
            
            }



            DB::table("asambleas.traduccion_propuestas_elecciones")->where("pe_id", $_POST["pe_id"])->where("tpe_idioma", $idioma)->delete();
            // print_r($array_traducciones);
            if(count($array_traducciones) > 0){
                // print_r($this->preparar_datos("asambleas.traduccion_propuestas_elecciones", $array_traducciones));
                $array_traducciones["pe_id"] = $_POST["pe_id"];
                $array_traducciones = $this->toUpper($array_traducciones, ["tpe_idioma"]);
                $result = $this->base_model->insertar($this->preparar_datos("asambleas.traduccion_propuestas_elecciones", $array_traducciones));
                
            } else {
                // print_r($this->preparar_datos("asambleas.traduccion_propuestas_elecciones", $_POST));
                $result = $this->base_model->insertar($this->preparar_datos("asambleas.traduccion_propuestas_elecciones", $_POST));
            }



            DB::commit();
            echo json_encode($result);
        } catch (Exception $e) {
            DB::rollBack();
            $response["status"] = "ei"; 
            $response["msg"] = $e->getMessage(); 
            echo json_encode($response);
        }
    }

    public function eliminar_propuestas_temas() {
       

        try {
            // $sql_agenda = "SELECT * FROM asambleas.agenda WHERE pt_id=".$_REQUEST["id"];
            // $agenda = DB::select($sql_agenda);

            // if(count($agenda) > 0) {
            //     throw new Exception(traducir("traductor.eliminar_asamblea_agenda"));
            // }

           

            $result = $this->base_model->eliminar(["asambleas.propuestas_temas","pt_id"]);
            echo json_encode($result);
        } catch (Exception $e) {
            echo json_encode(array("status" => "ee", "msg" => $e->getMessage()));
        }
    }

    public function eliminar_propuestas_elecciones() {
       

        try {
            // $sql_agenda = "SELECT * FROM asambleas.agenda WHERE pt_id=".$_REQUEST["id"];
            // $agenda = DB::select($sql_agenda);

            // if(count($agenda) > 0) {
            //     throw new Exception(traducir("traductor.eliminar_asamblea_agenda"));
            // }

           

            $result = $this->base_model->eliminar(["asambleas.propuestas_elecciones","pe_id"]);
            echo json_encode($result);
        } catch (Exception $e) {
            echo json_encode(array("status" => "ee", "msg" => $e->getMessage()));
        }
    }


    public function get_propuestas_temas(Request $request) {
        $id = explode("|", $_REQUEST["id"]);
        $pt_id = $id[0];
        $idioma_codigo = $id[1];

        $sql = "SELECT pt.*, (pt.pais_id || '|' || p.posee_union) AS pais_id , (tc.tipconv_id || '|' || pt.asamblea_id) AS asamblea_id, (m.apellidos || ', ' || m.nombres) AS asociado, tpt.*, pt.pt_id FROM asambleas.propuestas_temas AS pt 
        INNER JOIN asambleas.asambleas AS a ON(a.asamblea_id=pt.asamblea_id)
        INNER JOIN asambleas.tipo_convocatoria AS tc ON(a.tipconv_id=tc.tipconv_id)
        LEFT JOIN iglesias.miembro AS m ON(m.idmiembro=pt.pt_dirigido_por_uya)
        LEFT JOIN iglesias.paises AS p ON(p.pais_id=pt.pais_id)
        LEFT JOIN asambleas.traduccion_propuestas_temas AS tpt ON(tpt.pt_id=pt.pt_id AND tpt.tpt_idioma='{$idioma_codigo}')
        WHERE pt.pt_id=".$pt_id."
        ORDER BY tpt.tpt_id DESC LIMIT 1";
        $one = DB::select($sql);
        echo json_encode($one);
    }


    
    public function get_propuestas_elecciones(Request $request) {
        $id = explode("|", $_REQUEST["id"]);
        $pe_id = $id[0];
        $idioma_codigo = $id[1];

        $sql = "SELECT tpe.*, pe.* FROM asambleas.propuestas_elecciones AS pe 
        LEFT JOIN asambleas.traduccion_propuestas_elecciones AS tpe ON(tpe.pe_id=pe.pe_id AND tpe.tpe_idioma='{$idioma_codigo}')
        WHERE pe.pe_id=".$pe_id."
         ORDER BY tpe.tpe_id DESC LIMIT 1";
        $one = DB::select($sql);
        echo json_encode($one);
    }

    public function obtener_detalle_propuesta(Request $request) {
        $sql = "SELECT *
        FROM asambleas.detalle_propuestas AS dp 
      
        WHERE dp.pe_id={$request->input("pe_id")} AND dp.dp_idioma='{$request->input("idioma")}'";
        // die($sql);
        $result = DB::select($sql);
        echo json_encode($result);
    }

    

    public function obtener_anios() {
        $result = array();
        $array = array();
        for($i=date("Y"); $i < date("Y") + 10; $i++ ) {
            $result["id"] = $i;
            $result["descripcion"] = $i;
            array_push($array, $result);
        }

        echo json_encode($array);
    }


    public function obtener_tipo_convocatoria() {
        $sql = "SELECT  tc.tipconv_id  AS id, tc.tipconv_descripcion AS descripcion
        FROM asambleas.tipo_convocatoria AS tc";
        // die($sql);
        $result = DB::select($sql);
        echo json_encode($result);
    }

    public function obtener_asambleas() {
        $sql = "SELECT  a.pt_id  AS id, a.asamblea_descripcion AS descripcion
        FROM asambleas.propuestas_temas AS a
        WHERE a.estado='A'";
        // die($sql);
        $result = DB::select($sql);
        echo json_encode($result);
    }


    public function obtener_correlativo() {
        $sql = "SELECT COALESCE(MAX(pt_correlativo) + 1, 1) AS correlativo FROM asambleas.propuestas_temas  WHERE date_part('year', pt_fecha)=".date("Y");

        $correlativo = DB::select($sql);

        echo json_encode($correlativo);
    }

    

    

    
}
