<#include "../admin-template.ftl" />

<@page title="Docker Monitor" controller="/admin/admin-dockermonitor" readonly=true>
  <style>
    .docker-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    .docker-table th, .docker-table td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: left;
    }
    .docker-table th {
      background-color: #f8f9fa;
    }
    .docker-table tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    .btn-refresh {
      background-color: #007bff;
      color: white;
      border: none;
      padding: 10px 15px;
      border-radius: 4px;
      cursor: pointer;
      margin-top: 10px;
    }
    .btn-refresh:hover {
      background-color: #0056b3;
    }
  </style>

  <div class="column-full" id="contenedor-tabla">
    <@section label="Contenedores Docker en Ejecución" />

    <button type="button" class="btn-refresh" onclick="actualizarDatosDocker(); return false;">🔄 Actualizar</button>

    <table class="docker-table" id="tabla-docker">
      <thead>
        <tr>
          <th>Contenedor</th>
          <th>CPU</th>
          <th>Memoria</th>
        </tr>
      </thead>
      <tbody>
        <#list containers as container>
          <tr>
            <td>${container.name}</td>
            <td>${container.cpu}</td>
            <td>${container.mem}</td>
          </tr>
        </#list>
      </tbody>
    </table>
    <#if !containers?has_content>
      <div id="docker-error" class="error">No se encontraron contenedores en ejecución.</div>
    </#if>
  </div>

  <script src="//code.jquery.com/jquery-3.7.1.min.js"></script>
  <script>
    function actualizarDatosDocker() {
      $.get("${url.context}/service/admin/admin-dockermonitor", function(data) {
        // Extraer solo la tabla del HTML recibido
        var tablaActualizada = $(data).find("#tabla-docker tbody").html();
        var hayError = $(data).find("#docker-error").length > 0;

        if (tablaActualizada.trim()) {
          $("#tabla-docker tbody").html(tablaActualizada);
          $("#tabla-docker").show();
          $("#docker-error").remove();
        } else if (hayError) {
          $("#tabla-docker tbody").empty();
          if ($("#docker-error").length == 0) {
            $("#contenedor-tabla").append('<div id="docker-error" class="error">No se encontraron contenedores en ejecución.</div>');
          }
        }
      })
      .fail(function(){
        alert("Error al actualizar los datos de Docker.");
      });
    }
  </script>
</@page>