var initWidgetsPC = function (tab) {
    switch (tab) {
        case 0:
                $('#kampanjeOdDatumaPC').jqxDateTimeInput({ culture: 'bs-Latn-BA',  showCalendarButton: true });
                $('#kampanjeDoDatumaPC').jqxDateTimeInput({ culture: 'bs-Latn-BA',  showCalendarButton: true });
            break;
        case 1:
            initGridKmapanjaPc();
            break;
        case 2:
            initGridPoziviPc();
            break;   
    }
}
var initGridPoziviPc = function(){
    $('#gridPoziviPc').jqxGrid(
        {
            width: '99%',
            height:'99%',
            //source: dataAdapter,                
            pageable: false,
           // autoheight: true,
            sortable: true,
            altrows: true,
            enabletooltips: false,
            editable: false,
            selectionmode: 'multiplerowsextended',
            columnsresize: true,
            columns: [
              { text: 'Id poziva', datafield: 'id',  },
              { text: 'Telefonski broj', datafield: 'phone' },
              { text: 'Broj pokušaja',  datafield: 'retries' },
              { text: 'Status poziva',  datafield: 'status' },
              { text: 'Grupni status poziva',  datafield: 'group_status' },
              { text: 'Datum init',  datafield: 'date_init' },
              { text: 'Vrijeme init',  datafield: 'time_init' },
              { text: 'Datum end',  datafield: 'date_end' },
              { text: 'Vrijeme end',  datafield: 'time_end' },
              { text: 'Zakazan',  datafield: 'scheduled' }
            ]
        });
        $("#gridPoziviPc").jqxGrid('autoresizecolumns','all');
};
var initGridKmapanjaPc = function(){
    $('#gridKmapanjaPc').jqxGrid(
        {
            width: '99%',
            height:'99%',
            //source: dataAdapter,                
            pageable: false,
           // autoheight: true,
            sortable: true,
            altrows: true,
            enabletooltips: false,
            editable: false,
            selectionmode: 'multiplerowsextended',
            columnsresize: true,
            columns: [
              { text: 'Id kampanje', datafield: 'Id', width: '30%' },
              { text: 'Opis kampanje', datafield: 'name',  width: '30%' },
              { text: 'Status kampanje',  datafield: 'estatus' , width: '30%'}
            ]
        });
        $("#gridKmapanjaPc").jqxGrid('autoresizecolumns','all');
};

$(document).ready(function () {
    $('#tabPendingCalls').jqxTabs({ width: '99%', height:'99%', initTabContent: initWidgetsPC  });
    console.log("Kakab si mi ");
});