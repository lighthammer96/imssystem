var oficiales_union = new BASE_JS('oficiales_union', 'reportes');
var divisiones = new BASE_JS('divisiones', 'divisiones');
var paises = new BASE_JS('paises', 'paises');
var uniones = new BASE_JS('uniones', 'uniones');
var misiones = new BASE_JS('misiones', 'misiones');
var distritos_misioneros = new BASE_JS('distritos_misioneros', 'distritos_misioneros');
var iglesias = new BASE_JS('iglesias', 'iglesias');
// var actividad_misionera = new BASE_JS('actividad_misionera', 'actividad_misionera');
var asociados = new BASE_JS('asociados', 'asociados');

document.addEventListener("DOMContentLoaded", function() {

    oficiales_union.select_init({
        placeholder: seleccione
    })


    $(document).on('change', '#iddivision', function(event, iddivision, pais_id) {

        var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : session["iddivision"];
        d_id = (typeof iddivision != "undefined" && iddivision != null) ? iddivision : d_id;
        var selected = (typeof pais_id != "undefined")  ? pais_id : "";

        paises.select({
            name: 'pais_id',
            url: '/obtener_paises_asociados',
            placeholder: seleccione,
            selected: selected,
            datos: { iddivision: d_id }
        }).then(function(response) {

            var condicion = typeof iddivision == "undefined";
            condicion = condicion && typeof pais_id == "undefined";

            if(condicion) {
                var required = true;
                required = required && oficiales_union.required("iddivision");
                if(required) {
                    $("#pais_id")[0].selectize.focus();
                }
            }

        })
    });



    $(document).on('change', '#pais_id', function(event, pais_id, idunion) {
        var valor = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : session['pais_id'] + "|" + session['posee_union'];
        var array = valor.toString().split("|");
        //var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : 1;

        var d_id = array[0];
        var posee_union = array[1];

        var selected = (typeof idunion != "undefined")  ? idunion : "";
        uniones.select({
            name: 'idunion',
            url: '/obtener_uniones_paises',
            placeholder: seleccione,
            selected: selected,
            datos: { pais_id: d_id }
        }).then(function() {

            var condicion = typeof pais_id == "undefined";
            condicion = condicion && typeof idunion == "undefined";

            if(condicion) {
                var required = true;
                required = required && oficiales_union.required("pais_id");
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
                placeholder: seleccione,
                datos: { pais_id: d_id }
            })
        } else {
            $(".union").show();
        }

    });



    $(document).on('change', '#idunion', function(event, idunion, idmision) {

        var d_id = ($(this).val() != "" && $(this).val() != null) ? $(this).val() : session["idunion"];
        d_id = (typeof idunion != "undefined" && idunion != null) ? idunion : d_id;
        var selected = (typeof idmision != "undefined")  ? idmision : "";

        if(this.options.length > 0) {

            document.getElementById("lugar").value = this.options[this.selectedIndex].text;

        }


    });



    document.getElementById("ver-reporte").addEventListener("click", function(e) {
        e.preventDefault();
        var pais_id = document.getElementsByName("pais_id")[0].value;
        var array_pais = pais_id.split("|");

        var required = true;
        required = required && oficiales_union.required("iddivision");
        required = required && oficiales_union.required("pais_id");
        // required = required && oficiales_union.required("iddivision");
        if(array_pais[1] == "S") {
            required = required && oficiales_union.required("idunion");
        }
        // required = required && oficiales_union.required("idmision");
        // required = required && oficiales_union.required("iddistritomisionero");
        // required = required && oficiales_union.required("idiglesia");
        required = required && oficiales_union.required("periodoini");
        required = required && oficiales_union.required("periodofin");

        if(required) {
            $("#formulario-oficiales_union").attr("action", BaseUrl + "/reportes/imprimir_oficiales_union");
            $("#formulario-oficiales_union").attr("method", "GET");
            $("#formulario-oficiales_union").attr("target", "oficiales_union");


            window.open('', 'oficiales_union');
            document.getElementById('formulario-oficiales_union').submit();
        }
    })

    $(document).on("change", "#periodoini", function(e) {
        var periodoini = parseInt($("#periodoini").val());
        var periodofin = parseInt($("#periodofin").val());

        if(periodoini > periodofin) {
            $("#periodoini")[0].selectize.setValue(periodofin - 1);



        }

        // asociados.select({
        //     name: 'periodofin',
        //     url: '/obtener_periodos_fin_dependiente',
        //     datos: { periodoini: periodoini }
        // }).then(function() {

        //     if(periodoini > periodofin) {
        //         $("#periodoini")[0].selectize.setValue(periodofin - 1);



        //     }

        // })
        // console.log($(this).val());
    })

    $(document).on("change", "#periodofin", function(e) {
        var periodoini = parseInt($("#periodoini").val());
        var periodofin = parseInt($("#periodofin").val());


        if(periodoini > periodofin) {
            $("#periodofin")[0].selectize.setValue(periodoini + 1);

        }
        // console.log($(this).val());
    })

})
