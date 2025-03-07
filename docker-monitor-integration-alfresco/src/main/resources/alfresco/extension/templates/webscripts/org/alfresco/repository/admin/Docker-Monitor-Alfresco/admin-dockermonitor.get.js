<import resource="classpath:alfresco/templates/webscripts/org/alfresco/repository/admin/admin-common.lib.js">

    function obtenerDatosDocker() {
        var Runtime = java.lang.Runtime;
        var Process = Runtime.getRuntime().exec("docker stats --no-stream --format '{{.Name}},{{.CPUPerc}},{{.MemUsage}}'");
        var BufferedReader = new java.io.BufferedReader(new java.io.InputStreamReader(Process.getInputStream()));
        var output = "";
        var line;
    
        while ((line = BufferedReader.readLine()) !== null) {
            output += line + "\n";
        }
    
        var containers = [];
        var lines = output.split('\n');
        lines.forEach(function(line) {
            if (line.trim() === "") return;
            var parts = line.split(',');
            if (parts.length === 3) {
                containers.push({
                    name: parts[0],
                    cpu: parts[1].trim(),
                    mem: parts[2].trim()
                });
            }
        });
    
        return containers;
    }
    
    function main() {
        model.tools = Admin.getConsoleTools("admin-dockermonitor");
        model.metadata = Admin.getServerMetaData();
        model.containers = obtenerDatosDocker();
    }
    
    main();        