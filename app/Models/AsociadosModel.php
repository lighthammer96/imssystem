<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Tabla;

class AsociadosModel extends Model
{
    use HasFactory;


    

    public function __construct() {
        parent::__construct();
        
        //$tabla = new Tabla();


    }

    public function tabla($curriculum = "") {
        $funcion = "iglesias.fn_mostrar_jerarquia('s.division || '' / '' || s.pais  || '' / '' ||  s.union || '' / '' || s.mision || '' / '' || s.distritomisionero || '' / '' || s.iglesia', 'i.idiglesia=' || m.idiglesia, ".session("idioma_id").", ".session("idioma_id_defecto").")";
        $tabla = new Tabla();
        $tabla->asignarID("tabla-asociados");
        $tabla->agregarColumna("m.idmiembro", "idmiembro", "Id");
        $tabla->agregarColumna("m.nombres", "nombres", traducir("traductor.nombres"));
        $tabla->agregarColumna("td.descripcion", "descripcion", traducir("traductor.documento"));
        $tabla->agregarColumna("m.nrodoc", "nrodoc", traducir("traductor.numero"));
        $tabla->agregarColumna("m.email", "email", traducir("traductor.email"));
        $tabla->agregarColumna("m.telefono", "telefono", traducir("traductor.telefono"));
        // $tabla->agregarColumna("m.celular", "celular", traducir("traductor.celular"));
        $tabla->agregarColumna($funcion, "iglesia", traducir("traductor.iglesia"));

        $boton = "";
        // print_r($_REQUEST); 
        // var_dump($curriculum);
        if($curriculum == "1") {
            $tabla->agregarColumna("m.idmiembro", "boton", traducir("traductor.imprimir"));
            $boton = ", '<center><button type=\"button\" onclick=\"imprimir_curriculum(''' || m.idmiembro || ''')\" class=\"btn btn-danger btn-xs\" ><i class=\"fa fa-file-pdf-o\"></i></button></center>' AS boton";
        }
        
        $tabla->setSelect("m.idmiembro, (m.apellidos || ', ' || m.nombres) AS nombres, td.descripcion, m.nrodoc, m.email, m.telefono/*, m.celular*/, ".$funcion."  AS iglesia".$boton);
        $tabla->setFrom("iglesias.miembro AS m
        \nLEFT JOIN public.tipodoc AS td ON(m.idtipodoc=td.idtipodoc)");

        $array_where = array();
        $where = "";
        // var_dump(session("array_tipos_acceso")); exit;
        if(session("array_tipos_acceso") != NULL && count(session("array_tipos_acceso")) > 0) {
            foreach (session("array_tipos_acceso") as $value) {
                foreach ($value as $k => $v) {
                    array_push($array_where, " m.".$k." = ".$v);
                }
            }
            $where = implode(' AND ', $array_where);
        }
        $tabla->setWhere($where);
      
        return $tabla;
    }

    public function tabla_responsables() {
        $tabla = new Tabla();
        $tabla->asignarID("tabla-responsables");
        $tabla->agregarColumna("id", "id", "Id");
        $tabla->agregarColumna("tipo_documento", "tipo_documento", traducir("traductor.tipo_documento"));
        $tabla->agregarColumna("nrodoc", "nrodoc", traducir("traductor.numero_documento"));
        $tabla->agregarColumna("nombres", "nombres", traducir("traductor.nombres"));
        // $tabla->agregarColumna("cargo", "cargo", "Cargo");
        // $tabla->agregarColumna("periodo", "periodo", "Periodo");
        // $tabla->agregarColumna("vigente", "vigente", "Vigente");
        // $tabla->agregarColumna("tabla", "tabla", "Tabla");
        $tabla->setSelect("id, tipo_documento, nrodoc, nombres /*, cargo, periodo, vigente*/, tabla");
        $tabla->setFrom("iglesias.vista_responsables");

        if(isset($_REQUEST["idmiembro"])) {
            $tabla->setWhere("(id || tabla <> '" . $_REQUEST["idmiembro"]. "iglesias.miembro')");
        }

        return $tabla;
    }
}
