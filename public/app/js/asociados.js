var asociados = new BASE_JS('asociados', 'asociados');
var bajas = new BASE_JS('bajas', 'asociados');
var altas = new BASE_JS('altas', 'asociados');
var responsables = new BASE_JS('responsables', 'asociados');
var principal = new BASE_JS('principal', 'principal');
var divisiones = new BASE_JS('divisiones', 'divisiones');
var paises = new BASE_JS('paises', 'paises');
var uniones = new BASE_JS('uniones', 'uniones');
var misiones = new BASE_JS('misiones', 'misiones');
var distritos_misioneros = new BASE_JS('distritos_misioneros', 'distritos_misioneros');
var iglesias = new BASE_JS('iglesias', 'iglesias');

document.getElementsByName("fecharegistro")[0].setAttribute("default-value", BASE_JS.ObtenerFechaActual("user"));
var eventClick = new Event('click');

asociados.enter("nombres","apellidos");
asociados.enter("apellidos","apellido_soltera");
asociados.enter("apellido_soltera","sexo", "", false);
asociados.enter("sexo","idtipodoc");

asociados.enter("nrodoc","celular");
asociados.enter("celular","telefono");
asociados.enter("telefono","email");
asociados.enter("email","emailalternativo");
asociados.enter("emailalternativo","iddepartamentodomicilio", "", false);

asociados.enter("direccion","referenciadireccion");
asociados.enter("referenciadireccion","fechanacimiento", "", false);
asociados.enter("fechanacimiento","pais_id_nacimiento");
asociados.enter("ciudadnacextranjero","idestadocivil");

asociados.enter("observaciones","iddivision", "", false);
// asociados.enter("tipolugarnac","iddepartamentonacimiento");

// asociados.enter("fecharegistro","observaciones");

$("input[name=fechanacimiento], input[name=fecha]").inputmask();

jQuery( "input[name=fechanacimiento], input[name=fecha]" ).datepicker({
	format: "dd/mm/yyyy",
	language: "es",
	todayHighlight: true,
	todayBtn: "linked",
	autoclose: true,
	endDate: "now()",

});

$(function() {
    $('input[type="radio"], input[type="checkbox"]').iCheck({
        checkboxClass: 'icheckbox_minimal-blue',
        radioClass   : 'iradio_minimal-blue'
    })
})

// paises.select({
//     name: 'pais_id',
//     url: '/obtener_paises',
//     placeholder: 'Seleccione ...',
// })

// paises.select({
//     name: 'pais_id_nacionalidad',
//     url: '/obtener_paises',
//     placeholder: 'Seleccione ...',
// }).then(function() {
//     asociados.enter("pais_id_nacionalidad","fecharegistro");
// });

principal.select({
    name: 'idmotivobaja',
    url: '/obtener_motivos_baja',
    placeholder: 'Seleccione ...',
}).then(function() {
    
})

paises.select({
    name: 'pais_id_nacimiento',
    url: '/obtener_todos_paises',
    placeholder: 'Seleccione ...',
}).then(function() {
    asociados.enter("pais_id_nacimiento","ciudadnacextranjero");
})


principal.select({
    name: 'idtipodoc',
    url: '/obtener_tipos_documento',
    placeholder: 'Seleccione ...',
}).then(function() {
    asociados.enter("idtipodoc","nrodoc");
})

asociados.TablaListado({
    tablaID: '#tabla-asociados',
    url: "/buscar_datos",
});




asociados.select({
    name: 'idestadocivil',
    url: '/obtener_estado_civil',
    placeholder: 'Seleccione ...'
}).then(function() {
    asociados.enter("idestadocivil","idgradoinstruccion");
    
}) 

asociados.select({
    name: 'idgradoinstruccion',
    url: '/obtener_nivel_educativo',
    placeholder: 'Seleccione ...'
}).then(function() {
    asociados.enter("idgradoinstruccion","idocupacion");
    
}) 

asociados.select({
    name: 'idocupacion',
    url: '/obtener_profesiones',
    placeholder: 'Seleccione ...'
}).then(function() {
    asociados.enter("idocupacion","observaciones");
    
}) 

principal.select({
    name: 'iddepartamentodomicilio',
    url: '/obtener_departamentos',
    placeholder: 'Seleccione ...'
}).then(function() {
    
    $("#iddepartamentodomicilio").trigger("change", ["", "", ""]);
    $("#idprovinciadomicilio").trigger("change", ["", "", ""]);
}) 



$(document).on('change', '#iddepartamentodomicilio', function(event, iddepartamentodomicilio, idprovinciadomicilio) {

    var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
    d_id = (typeof iddepartamentodomicilio != "undefined" && iddepartamentodomicilio != null) ? iddepartamentodomicilio : d_id;
    var selected = (typeof idprovinciadomicilio != "undefined")  ? idprovinciadomicilio : "";
   
    principal.select({
        name: 'idprovinciadomicilio',
        url: '/obtener_provincias',
        placeholder: 'Seleccione ...',
        selected: selected,
        datos: { iddepartamento: d_id }
    }).then(function() {
       
        var condicion = typeof iddepartamentodomicilio == "undefined";
        condicion = condicion && typeof idprovinciadomicilio == "undefined";
       
        if(condicion) {
            var required = true;
            required = required && asociados.required("iddepartamentodomicilio");
            if(required) {
                $("#idprovinciadomicilio")[0].selectize.focus();
            }
        } 
       
       
        
    })

});


$(document).on('change', '#idprovinciadomicilio', function(event, idprovinciadomicilio, iddistritodomicilio) {

    var p_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
    p_id = (typeof idprovinciadomicilio != "undefined") ? idprovinciadomicilio : p_id;
    var selected = (typeof iddistritodomicilio != "undefined")  ? iddistritodomicilio : "";

    
    principal.select({
        name: 'iddistritodomicilio',
        url: '/obtener_distritos',
        placeholder: 'Seleccione ...',
        selected: selected,
        datos: { idprovincia:  p_id }
    }).then(function() {
        asociados.enter("iddistritodomicilio","direccion");
        
        var condicion = typeof idprovinciadomicilio == "undefined";
        condicion = condicion && typeof iddistritodomicilio == "undefined";

        if(condicion) {
            var required = true;
            required = required && asociados.required("idprovinciadomicilio");
            if(required) {
                $("#iddistritodomicilio")[0].selectize.focus();
            }
           
        } 
    })


});


// principal.select({
//     name: 'iddepartamentonacimiento',
//     url: '/obtener_departamentos',
//     placeholder: 'Departamento ...'
// }).then(function() {
   
//     $("#iddepartamentonacimiento").trigger("change", ["", "", ""]);
//     $("#idprovincianacimiento").trigger("change", ["", "", ""]);
// }) 



// $(document).on('change', '#iddepartamentonacimiento', function(event, iddepartamentonacimiento, idprovincianacimiento) {

//     var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
//     d_id = (typeof iddepartamentonacimiento != "undefined" && iddepartamentonacimiento != null) ? iddepartamentonacimiento : d_id;
//     var selected = (typeof idprovincianacimiento != "undefined")  ? idprovincianacimiento : "";
   
//     principal.select({
//         name: 'idprovincianacimiento',
//         url: '/obtener_provincias',
//         placeholder: 'Provincia ...',
//         selected: selected,
//         datos: { iddepartamentonacimiento: d_id }
//     }).then(function() {
       
//         var condicion = typeof iddepartamentonacimiento == "undefined";
//         condicion = condicion && typeof idprovincianacimiento == "undefined";
       
//         if(condicion) {
//             var required = true;
//             required = required && asociados.required("iddepartamentonacimiento");
//             if(required) {
//                 $("#idprovincianacimiento")[0].selectize.focus();
//             }
//         } 
       
       
        
//     })

// });


// $(document).on('change', '#idprovincianacimiento', function(event, idprovincianacimiento, iddistritonacimiento) {

//     var p_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
//     p_id = (typeof idprovincianacimiento != "undefined") ? idprovincianacimiento : p_id;
//     var selected = (typeof iddistritonacimiento != "undefined")  ? iddistritonacimiento : "";

    
//     principal.select({
//         name: 'iddistritonacimiento',
//         url: '/obtener_distritos',
//         placeholder: 'Distrito ...',
//         selected: selected,
//         datos: { idprovincianacimiento:  p_id }
//     }).then(function() {
//         asociados.enter("iddistritonacimiento","idestadocivil");
      
//         var condicion = typeof idprovincianacimiento == "undefined";
//         condicion = condicion && typeof iddistritonacimiento == "undefined";

//         if(condicion) {
//             var required = true;
//             required = required && asociados.required("idprovincianacimiento");
//             if(required) {
//                 $("#iddistritonacimiento")[0].selectize.focus();
//             }
           
//         } 
//     })


// });



divisiones.select({
    name: 'iddivision',
    url: '/obtener_divisiones',
    placeholder: 'Seleccione ...'
}).then(function() {

    $("#iddivision").trigger("change", ["", "", ""]);
    $("#pais_id").trigger("change", ["", "", ""]);
    $("#idunion").trigger("change", ["", "", ""]);
    $("#idmision").trigger("change", ["", "", ""]);
    $("#iddistritomisionero").trigger("change", ["", "", ""]);
    $("#idiglesia").trigger("change", ["", "", ""]);
    
    
}) 

$(document).on('change', '#iddivision', function(event, iddivision, pais_id) {

    var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
    d_id = (typeof iddivision != "undefined" && iddivision != null) ? iddivision : d_id;
    var selected = (typeof pais_id != "undefined")  ? pais_id : "";
   
    paises.select({
        name: 'pais_id',
        url: '/obtener_paises_asociados',
        placeholder: 'Seleccione ...',
        selected: selected,
        datos: { iddivision: d_id }
    }).then(function(response) {
        
        var condicion = typeof iddivision == "undefined";
        condicion = condicion && typeof pais_id == "undefined";
       
        if(condicion) {
            var required = true;
            required = required && asociados.required("iddivision");
            if(required) {
                $("#pais_id")[0].selectize.focus();
            }
        } 
    
    })
});



$(document).on('change', '#pais_id', function(event, pais_id, idunion) {
    var valor = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : "1|S"; 
    var array = valor.toString().split("|");
    //var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;   
   
    var d_id = array[0];
    var posee_union = array[1];
   
    var selected = (typeof idunion != "undefined")  ? idunion : "";
    uniones.select({
        name: 'idunion',
        url: '/obtener_uniones_paises',
        placeholder: 'Seleccione ...',
        selected: selected,
        datos: { pais_id: d_id }
    }).then(function() {
      
        var condicion = typeof pais_id == "undefined";
        condicion = condicion && typeof idunion == "undefined";
       
        if(condicion) {
            var required = true;
            required = required && asociados.required("pais_id");
            if(required) {
                $("#idunion")[0].selectize.focus();
            }
        } 
    
    })
    if(posee_union == "N") {
        $(".union").hide();

        misiones.select({
            name: 'idmision',
            url: '/obtener_misiones',
            placeholder: 'Seleccione ...',
            datos: { pais_id: d_id }
        })
    } else {
        $(".union").show();
    }
    
});



$(document).on('change', '#idunion', function(event, idunion, idmision) {

    var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
    d_id = (typeof idunion != "undefined" && idunion != null) ? idunion : d_id;
    var selected = (typeof idmision != "undefined")  ? idmision : "";
   
    misiones.select({
        name: 'idmision',
        url: '/obtener_misiones',
        placeholder: 'Seleccione ...',
        selected: selected,
        datos: { idunion: d_id }
    }).then(function() {
      
        var condicion = typeof idunion == "undefined";
        condicion = condicion && typeof idmision == "undefined";
       
        if(condicion) {
            var required = true;
            required = required && asociados.required("idunion");
            if(required) {
                $("#idmision")[0].selectize.focus();
            }
        } 
    
    })
});

$(document).on('change', '#idmision', function(event, idmision, iddistritomisionero) {

    var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
    d_id = (typeof idmision != "undefined" && idmision != null) ? idmision : d_id;
    var selected = (typeof iddistritomisionero != "undefined")  ? iddistritomisionero : "";
   
    distritos_misioneros.select({
        name: 'iddistritomisionero',
        url: '/obtener_distritos_misioneros',
        placeholder: 'Seleccione ...',
        selected: selected,
        datos: { idmision: d_id }
    }).then(function() {
      
        var condicion = typeof idmision == "undefined";
        condicion = condicion && typeof iddistritomisionero == "undefined";
       
        if(condicion) {
            var required = true;
            required = required && asociados.required("idmision");
            if(required) {
                $("#iddistritomisionero")[0].selectize.focus();
            }
        } 
    
    })
});

$(document).on('change', '#iddistritomisionero', function(event, iddistritomisionero, idiglesia) {

    var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;     
    d_id = (typeof iddistritomisionero != "undefined" && iddistritomisionero != null) ? iddistritomisionero : d_id;
    var selected = (typeof idiglesia != "undefined")  ? idiglesia : "";
   
    iglesias.select({
        name: 'idiglesia',
        url: '/obtener_iglesias',
        placeholder: 'Seleccione ...',
        selected: selected,
        datos: { iddistritomisionero: d_id }
    }).then(function() {
      
        var condicion = typeof iddistritomisionero == "undefined";
        condicion = condicion && typeof idiglesia == "undefined";
       
        if(condicion) {
            var required = true;
            required = required && asociados.required("iddistritomisionero");
            if(required) {
                $("#idiglesia")[0].selectize.focus();
            }
        } 
    
    })
});



document.getElementById("nuevo-asociado").addEventListener("click", function(event) {
    event.preventDefault();
   
    asociados.abrirModal();
})

document.getElementById("modificar-asociado").addEventListener("click", function(event) {
    event.preventDefault();
    var datos = asociados.datatable.row('.selected').data();
    if(typeof datos == "undefined") {
		BASE_JS.sweet({
			text: "DEBE SELECCIONAR UN REGISTRO!"
		});
		return false;
    } 
	
    var promise = asociados.get(datos.idmiembro);
    
    promise.then(function(response) {
        var button = "";
        crear_botones_altas_bajas(response.estado);
        if(response.foto != null) {
            document.getElementById("cargar_foto").setAttribute("src", BaseUrl+"/fotos_asociados/"+response.foto);
        } else {
            document.getElementById("cargar_foto").setAttribute("src", BaseUrl+"/images/camara.png");
        }

        if(response.posee_union == "N") {
            $(".union").hide();
        } else {
            $(".union").show();
        }

        $(".miembro").text(response.apellidos + ", "+response.nombres);
    })
    

})

function crear_botones_altas_bajas(estado) {
    if(estado == "1") {
        document.getElementById("estado_asociado").innerText = "Activo";
        document.getElementById("estado_asociado").style.backgroundColor = "#FFFF33";
        document.getElementById("estado_asociado").style.color = "black";
        button = '<button type="button" class="btn btn-danger btn-sm" id="dar-baja">Dar de Baja</button>';
    } else {
        document.getElementById("estado_asociado").innerText = "Inactivo";
        document.getElementById("estado_asociado").style.backgroundColor = "#666666";
        document.getElementById("estado_asociado").style.color = "white";
        button = '<button type="button" class="btn btn-success btn-sm" id="dar-alta">Dar de Alta</button>';

    }
    
    document.getElementById("bajas_altas").innerHTML = button;
}

document.getElementById("ver-asociado").addEventListener("click", function(event) {
    event.preventDefault();
    var datos = asociados.datatable.row('.selected').data();
    if(typeof datos == "undefined") {
        BASE_JS.sweet({
            text: "DEBE SELECCIONAR UN REGISTRO!"
        });
        return false;
    } 
    var promise = asociados.ver(datos.idmiembro);

    promise.then(function(response) {
        if(response.foto != null) {
            document.getElementById("cargar_foto").setAttribute("src", BaseUrl+"/fotos_asociados/"+response.foto);
        } else {
            document.getElementById("cargar_foto").setAttribute("src", BaseUrl+"/images/camara.png");
        }

        if(response.posee_union == "N") {
            $(".union").hide();
        } else {
            $(".union").show();
        }
    })
})


// document.getElementById("eliminar-asociado").addEventListener("click", function(event) {
//     event.preventDefault();
//     var datos = asociados.datatable.row('.selected').data();
//     if(typeof datos == "undefined") {
//         BASE_JS.sweet({
//             text: "DEBE SELECCIONAR UN REGISTRO!"
//         });
// 		return false;
//     } 
	
// 	BASE_JS.sweet({
// 		confirm: true,
// 		text: "¿SEGURO QUE DESEA ELIMINAR ESTE REGISTRO?",
// 		callbackConfirm: function() {
// 			asociados.Operacion(datos.idmiembro, 'E');
// 			asociados.datatable.destroy();
// 			asociados.TablaListado({
// 				tablaID: '#tabla-asociados',
// 				url: "/buscar_datos",
// 			});
// 	   }
//    });
// })

document.getElementById("guardar-asociado").addEventListener("click", function(event) {
    event.preventDefault();
    var emailalternativo = document.getElementsByName("emailalternativo")[0].value;
    var pais_id = document.getElementsByName("pais_id")[0].value;
    var array_pais = pais_id.split("|");
    // alert(idmiembro);
    var required = true;
    required = required && asociados.required("nombres");
    required = required && asociados.required("apellidos");
    required = required && asociados.required("sexo");
    required = required && asociados.required("idtipodoc");
    required = required && asociados.required("nrodoc");
    required = required && asociados.required("celular");
    required = required && asociados.required("telefono");
    required = required && asociados.required("email");
    required = required && asociados.validar_email("email");
    if(emailalternativo != "") {
        required = required && asociados.validar_email("emailalternativo");
    }
    required = required && asociados.required("direccion");
    required = required && asociados.required("fechanacimiento");
    // required = required && asociados.required("tipolugarnac");
    required = required && asociados.required("idestadocivil");
    required = required && asociados.required("idgradoinstruccion");
    required = required && asociados.required("idocupacion");
    // required = required && asociados.required("pais_id_nacionalidad");
    required = required && asociados.required("fecharegistro");
    
    required = required && asociados.required("iddivision");
    required = required && asociados.required("pais_id");
    // required = required && asociados.required("iddivision");
    if(array_pais[1] == "S") {
        required = required && asociados.required("idunion");
    }
    required = required && asociados.required("idmision");
    required = required && asociados.required("iddistritomisionero");
    required = required && asociados.required("idiglesia");

    if(required) {
        asociados.guardar();
        // asociados.CerrarModal();
        // asociados.LimpiarFormulario();
        asociados.datatable.destroy();
        asociados.TablaListado({
            tablaID: '#tabla-asociados',
            url: "/buscar_datos",
        });

        document.getElementById("cargar_foto").setAttribute("src", BaseUrl+"/images/camara.png");
        // asociados.select({
        //     name: "modulo_padre",
        //     url:  '/obtenerPadres',
        // });
    }
})



document.addEventListener("keydown", function(event) {
    // console.log(event.target.name);
    // alert(modulo_controlador);
    if(modulo_controlador == "asociados/index") {
        //ESTOS EVENTOS SE ACTIVAN SUS TECLAS RAPIDAS CUANDO EL MODAL DEL FORMULARIO ESTE CERRADO
        if(!$('#modal-asociados').is(':visible')) {
			var botones = document.getElementsByTagName("button");
			for (let index = 0; index < botones.length; index++) {
				if(botones[index].getAttribute("tecla_rapida") != null) {
					if(botones[index].getAttribute("tecla_rapida") == event.code) {
						document.getElementById(botones[index].getAttribute("id")).dispatchEvent(eventClick);
						event.preventDefault();
						event.stopPropagation();
					}
				}
				//console.log(botones[index].getAttribute("tecla_rapida"));
			}

        } else {
			//NO HACER NADA EN CASO DE LAS TECLAS F4 ES QUE USUALMENTE ES PARA CERRAR EL NAVEGADOR Y EL F5 QUE ES PARA RECARGAR
			if(event.code == "F4" || event.code == "F5") {
				event.preventDefault();
				event.stopPropagation();
			}
		}

                
        if(event.code == "F3") {
            //PARA LOS BUSCADORES DE LOS DATATABLES
            var inputs = document.getElementsByTagName("input");
            for (let index = 0; index < inputs.length; index++) {
                // console.log(inputs[index].getAttribute("type"));
                if(inputs[index].getAttribute("type") == "search") {
                    inputs[index].focus();
                    
                }
                //console.log(botones[index].getAttribute("tecla_rapida"));
			}
			event.preventDefault();
			event.stopPropagation();
            
        }

        if(event.code == "F9") {
           
            if($('#modal-asociados').is(':visible')) {
                document.getElementById('guardar-asociado').dispatchEvent(eventClick);
            }
            
         
			event.preventDefault();
			event.stopPropagation();
        }
        
     
        
    
    
      
    }
   
	
})

document.getElementById("cancelar-asociado").addEventListener("click", function(event) {
	event.preventDefault();
	asociados.CerrarModal();
})


document.getElementById("cargar_foto").addEventListener("click", function(e) {
    e.preventDefault();
    document.getElementById("foto").click();
})


//url referencia previsualizar img: https://anexsoft.com/como-previsualizar-una-imagen-con-javascript-antes-de-subirla
document.getElementById("foto").onchange = function(e) {
    // Creamos el objeto de la clase FileReader
    let reader = new FileReader();

    // Leemos el archivo subido y se lo pasamos a nuestro fileReader
    reader.readAsDataURL(e.target.files[0]);

    // Le decimos que cuando este listo ejecute el código interno
    reader.onload = function(){
        let images = document.getElementsByClassName("usuario_foto");
        for (var i = 0; i < images.length ; i++) {
            images[i].src = reader.result;
        }

    };
}



// $("input[name='tipolugarnac']").on('ifChecked', function(event){
//     var tipolugarnac = $(this).val();
//     if(tipolugarnac == "extranjero") {
//         $(".extranjero").show();
//         $(".nacional").hide();
//     } else {
//         $(".extranjero").hide();
//         $(".nacional").show();
//     }
// });


document.getElementById("cancelar-baja").addEventListener("click", function(event) {
	event.preventDefault();
	bajas.CerrarModal();
})


document.getElementById("cancelar-alta").addEventListener("click", function(event) {
	event.preventDefault();
	altas.CerrarModal();
})

$(document).on("click", "#dar-baja", function(e) {
    e.preventDefault();

    bajas.abrirModal();

    var idmiembro = document.getElementsByName("idmiembro")[0].value;
    document.getElementsByName("idmiembro_baja")[0].value = idmiembro;

    if(typeof responsables.datatable.length != "undefined") {
        responsables.datatable.destroy();
    }

    responsables.TablaListado({
        tablaID: '#tabla-responsables',
        url: "/buscar_datos_responsables",
        idmiembro: idmiembro
    });
    
    
})


$(document).on("click", "#dar-alta", function(e) {
    e.preventDefault();
    altas.abrirModal();

    var idmiembro = document.getElementsByName("idmiembro")[0].value;
   
    document.getElementsByName("idmiembro_alta")[0].value = idmiembro;
    
    if(typeof responsables.datatable.length != "undefined") {
        responsables.datatable.destroy();
    }

    responsables.TablaListado({
        tablaID: '#tabla-responsables',
        url: "/buscar_datos_responsables",
        idmiembro: idmiembro
    });
})



document.getElementById("buscar_responsable_baja").addEventListener("click", function(event) {
	event.preventDefault();
	$("#modal-lista-responsables").modal("show");
})

document.getElementById("buscar_responsable_alta").addEventListener("click", function(event) {
	event.preventDefault();
	$("#modal-lista-responsables").modal("show");
})


function cargar_datos_responsable(datos) {
	bajas.limpiarDatos("datos-responsable");
	altas.limpiarDatos("datos-responsable");
	//console.log(datos);
	bajas.asignarDatos({
		idresponsable: datos.id,
		responsable: datos.nombres,
		tabla: datos.tabla
		
	});
    altas.asignarDatos({
		idresponsable: datos.id,
		responsable: datos.nombres,
		tabla: datos.tabla
		
	});
    
	$("#modal-lista-responsables").modal("hide");


}

$("#tabla-responsables").on('key.dt', function(e, datatable, key, cell, originalEvent){
	if(key === 13){
		var datos = responsables.datatable.row(cell.index().row).data();
		cargar_datos_responsable(datos);
	}
});

$('#tabla-responsables').on('dblclick', 'tr', function () {
	var datos = responsables.datatable.row( this ).data();
	cargar_datos_responsable(datos);
});

document.getElementById("guardar-baja").addEventListener("click", function(event) {
    event.preventDefault();
    
    var required = true;
    required = required && bajas.required("responsable");
    required = required && bajas.required("fecha");
    required = required && bajas.required("idmotivobaja");
    required = required && bajas.required("observaciones");   
    if(required) {
        bajas.guardar();
        bajas.CerrarModal();
        crear_botones_altas_bajas("0");
    }
})


document.getElementById("guardar-alta").addEventListener("click", function(event) {
    event.preventDefault();

    var required = true;
    required = required && altas.required("responsable");
    required = required && altas.required("fecha");
    required = required && altas.required("observaciones");   
    if(required) {
        altas.guardar();
        altas.CerrarModal();
        crear_botones_altas_bajas("1");
    }
})
