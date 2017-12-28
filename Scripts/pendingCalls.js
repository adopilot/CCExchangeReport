var initWidgetsPC = function (tab) {
    switch (tab) {
        case 0:
                initGridKmapanjaPc();
            break;
        case 1:
                initGridPoziviPc();
            break;
    }
}

var spanP1 = $("<span style='float: left; margin-top: 5px; margin-right: 4px;'>Period poziva od datuma:    </span>");

var dugmeOsvjeziKampanje = $("<input type='button' style='float: left;  margin-left: 20px;' value='Osvježi podatke' id='runnReport' />").jqxButton().on('click', function () {
    $("#gridKmapanjaPc").jqxGrid('updatebounddata');
});
var dugmeOsvjezi = $("<input type='button' style='float: left;  margin-left: 20px;' value='Osvježi podatke' id='runnReport' />").jqxButton().on('click', function () {
    $("#gridPoziviPc").jqxGrid('updatebounddata');
});
var dugmeExcel = $("<input type='button' style='float: left;  margin-left: 20px;' value='Napravi EXCEL' id='runExcel' />").jqxButton({ template: "success" }).on('click', function () {
    $("#gridPoziviPc").jqxGrid('exportdata', 'xls', 'PendingCalls.xls', true, null, true, './exportExcel.php');
});


var dugmePrint = $("<input type='button' style='float: left;  margin-left: 20px;' value='Štampaj' id='runPrint' />").jqxButton({ template: "info" }).on('click', function () {
    var gridContent = $("#gridPoziviPc").jqxGrid('exportdata', 'html');
    var newWindow = window.open('', '', 'width=1000, height=600'),
    document = newWindow.document.open(),
    pageContent =
        '<!DOCTYPE html>\n' +
        '<html>\n' +
        '<head>\n' +
        '<meta charset="utf-8" />\n' +
        '<title>Report CALL Centar po danima </title>\n' +
        '</head>\n' +
        '<body>\n' + gridContent + '\n</body>\n</html>';
    document.write(pageContent);
    document.close();
    newWindow.print();

});
    

var dugmeCSV = $("<input type='button' style='float: left;  margin-left: 20px;' value='Napravi CSV' id='runCSV' />").jqxButton({ template: "info" }).on('click', function () {
    $("#gridPoziviPc").jqxGrid('exportdata', 'csv', 'PendingCalls.csv', true, null, true, './exportExcel.php');
});


var dugmeIndex = $("<input type='button' style='float: left;  margin-left: 20px;' value='Početna' id='dugmeReportPeriod' />").jqxButton().on('click', function () {
    window.location.href = './index.html';
});

var dugmeIndexKp = $("<input type='button' style='float: left;  margin-left: 20px;' value='Početna' id='dugmeReportPeriod' />").jqxButton().on('click', function () {
    window.location.href = './index.html';
});

var initGridPoziviPc = function(){
    $('#gridPoziviPc').jqxGrid(
        {
            width: '99%',
            height:'99%',
            source: dataAdapterPendingCalls,                
            pageable: false,
           // autoheight: true,
            sortable: true,
            altrows: true,
            enabletooltips: false,
            editable: false,
            selectionmode: 'multiplerowsextended',
            columnsresize: true,
            filterable: true,
            showtoolbar: true,
            toolbarheight: 50,
            columns: [
              { text: 'Id poziva', datafield: 'id',  },
              { text: 'Pozivani Telefonski broj', datafield: 'phone' },
              { text: 'pokušaja',  datafield: 'retries' },
              { text: 'Status',  datafield: 'status' },
              { text: 'Grupni status',  datafield: 'group_status' },
              { text: 'Datum init poziva',  datafield: 'date_init' ,filtertype: 'date' , cellsformat: 'dd.MM.yyyy' },
              { text: 'Vrijeme init',  datafield: 'time_init',filtertype: 'checkedlist' },
              { text: 'Datum end poziva',  datafield: 'date_end' ,filtertype: 'date' , cellsformat: 'dd.MM.yyyy' },
              { text: 'Vrijeme end',  datafield: 'time_end',filtertype: 'checkedlist' },
              { text: 'Zakazan',  datafield: 'scheduled' ,filtertype: 'checkedlist' },
              { text: 'Kampanja' , datafield: 'kamapanja' ,filtertype: 'checkedlist'}
            ],
            rendertoolbar: 
            function (toolbar) {
                var me = this;
                var container = $("<div style='margin: 5px;'></div>");
                var input = $("<input class='jqx-input jqx-widget-content jqx-rc-all' id='datumOd' type='text' style='height: 23px; float: left; width: 223px;' />");
                toolbar.append(container);
                //container.append(spanP1);
                container.append(dugmeOsvjezi);
                container.append(dugmePrint);
                container.append(dugmeExcel);
                container.append(dugmeCSV);
                container.append(dugmeIndex);
                
            }
            
        });
};
var initGridKmapanjaPc = function(){
    $('#gridKmapanjaPc').jqxGrid(
        {
            width: '99%',
            height:'99%',
            source: dataAdapterGridKampanjaPC,                
            pageable: false,
           // autoheight: true,
            sortable: true,
            altrows: true,
            enabletooltips: false,
            editable: false,
            selectionmode: 'checkbox',
            columnsresize: true,
            filterable: true,
            showtoolbar: true,
            toolbarheight: 50,
            columns: [
              { text: 'Id kampanje', datafield: 'id'  },
              { text: 'Opis kampanje', datafield: 'name'   },
              { text: 'Status kampanje', filtertype: 'checkedlist', datafield: 'estatus' }
            ],
            rendertoolbar: 
            function (toolbar) {
                var me = this;
                var container = $("<div style='margin: 5px;'></div>");
                var input = $("<input class='jqx-input jqx-widget-content jqx-rc-all' id='datumOd' type='text' style='height: 23px; float: left; width: 223px;' />");
                toolbar.append(container);
                //container.append(spanP1);
                container.append(dugmeOsvjeziKampanje);
                container.append(dugmeIndexKp);
                
            }
        });
};


var sourcePenigCalls = {
    datatype: "json",
    datafields: [
    { name: 'id', type:'int' },
    { name: 'phone', type: 'string' },
    { name: 'retries', type: 'int' },
    { name: 'status', type: 'string' },
    { name: 'group_status', type: 'string' },
    { name: 'date_init', type: 'date' },
    { name: 'time_init', type: 'string' },
    { name: 'date_end', type: 'date' },
    { name: 'time_end', type: 'string' },
    { name: 'scheduled', type: 'string' },
    { name: 'kamapanja', type: 'string'  },

    ],
    url: 'dataPendingCalls.php',
    id: 'id',
    data: {},
    formatData: function (data) {
        
        var kampanje ='0';
        var selektovaniIndexi = $('#gridKmapanjaPc').jqxGrid('getselectedrowindexes');

        for (i = 0; i < selektovaniIndexi.length; i++) {
            var id = $('#gridKmapanjaPc').jqxGrid('getrowid', selektovaniIndexi[i]);
            kampanje +=','+id;
    
        }

        return {
            kampanje: kampanje
        };
    }
};

var dataAdapterPendingCalls = new $.jqx.dataAdapter(sourcePenigCalls,
    {
        loadComplete: function () { 
            $("#gridPoziviPc").jqxGrid('autoresizecolumns','all');
        }
    });

var sourceGridKampanjaPC = {
    datatype: "json",
    datafields: [
    { name: 'id', type:'int' },
    { name: 'name', type: 'string' },
    { name: 'estatus', type: 'string' }
    ],
    url: 'dataKampanjePC.php',
    id: 'id'
};
var dataAdapterGridKampanjaPC = new $.jqx.dataAdapter(sourceGridKampanjaPC,
{
    loadComplete: function () { 
        $("#gridKmapanjaPc").jqxGrid('autoresizecolumns','all');
    }
});


$(document).ready(function () {
    $('#tabPendingCalls').jqxTabs({ width: '99%', height:'99%', initTabContent: initWidgetsPC  });
    console.log("Kakab si mi ");

    $('#tabPendingCalls').on('selected', function (event) {
        var selectedTab = event.args.item;
        switch (selectedTab) {
            case 0:
            $("#gridKmapanjaPc").jqxGrid('updatebounddata', 'cells');
                break;
            case 1:
            $("#gridPoziviPc").jqxGrid('updatebounddata');
                break;
        }
        
    });

});