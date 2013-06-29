/*
	CMF support functions
*/

function leftMenuItemCollapse(id){
	var item = 'leftMenuItem'+id;
if ($("#"+item + " > ul").is(":hidden")) {
        $("#"+item + " > ul").slideDown("slow");
		$("#"+item).removeClass();
		setQ("leftMenuItem",id,0);
      } else {
        $("#"+item + " > ul").slideUp("slow");
		$("#"+item).addClass("collapsed");
		setQ("leftMenuItem",id,1);
      }
return false;
}

function leftMenuCollapse(){

if ($("#aside").is(":hidden")) {
        $("body").removeClass();
        $("#aside").show();
        $("#aside").attr("style", "width:215px");
        $("#content_living").attr("style" , "width:1%");
        setTimeout(function(){ $("#content_living").attr("style" , "width:auto");  }, 1);
        setQ('aside',0,0);
      } else {
            $("#aside").hide();
            $("body").addClass("hidemenu");
            $("#aside").hide();                    
            $("#content_living").attr("style" , "width:1%");
            setTimeout(function(){ $("#content_living").attr("style" , "width:auto");  }, 1);
            setQ('aside',0,1);
      }
return false;
}



function filterCollapse(id){
if ($("#id-filter-body").is(":hidden")) {
        //$("#id-filter-body").slideDown("slow");
		$("#id-filter-body").show();
		$("#id-filter-title").removeClass();		
		setQ('filter',id,0);
      } else {
        //$("#id-filter-body").slideUp("slow");
		$("#id-filter-title").addClass("collapsed");		
        $("#id-filter-body").hide();		
		setQ('filter',id,1);
      }
return false;
}

function setQ(section,id,value){
$.get("/site/admin/User/savas/", { 'section': section, 'id': id, 'value': value } );
}

/*
function $(sId)
{
        if (!sId) {
                return null;
        }
        var returnObj = document.getElementById(sId);
        if (!returnObj && document.all) {
                returnObj = document.all[sId];
        }
        return returnObj;
}
*/
function checkXML(obj)
{
    var tx=obj.value;
    var re,chr;
        re=new RegExp("\&amp\;","gi");
    tx=tx.replace(re,"<#amp#>");     
        re=new RegExp("\&\#([0-9]+)\;","gi");
    tx=tx.replace(re,"<#$1#>");     
        re=new RegExp("\&lt\;","gi");
    tx=tx.replace(re,"<#lt#>");     
        re=new RegExp("\&gt\;","gi");
    tx=tx.replace(re,"<#gt#>");     
        re=new RegExp("\&","gi");
    tx=tx.replace(re,"&amp;");  
        re=new RegExp("\<\#amp\#\>","gi");
    tx=tx.replace(re,"&amp;");   
        re=new RegExp("\<\#([0-9]+)\#\>","gi");
    tx=tx.replace(re,"&#$1;");   
        re=new RegExp("\<\#lt\#\>","gi");
    tx=tx.replace(re,"&lt;");   
        re=new RegExp("\<\#gt\#\>","gi");
    tx=tx.replace(re,"&gt;");   
    obj.value=tx;

if(document.all)
{    
 var xd = new ActiveXObject('MSXML.DOMDocument');
 xd.async = false;
 xd.validateOnParse=true;
 var bOk=xd.loadXML("<A>"+tx+"</A>");
 var e=xd.parseError;
 if(!bOk){
  var fp=e.filepos-4;
  alert (e.reason);
   var tr=obj.createTextRange(); 
   tr.collapse(true);
   tr.moveStart("character",fp); tr.moveEnd("character",1);
   tr.select();
   obj.focus();
  return false;
 } else return true;
}
else
{
var parser = new DOMParser();
var doc = parser.parseFromString("<A>"+tx+"</A>", "text/xml");

var roottag = doc.documentElement;
if ((roottag.tagName == "parserError") ||
    (roottag.namespaceURI == "http://www.mozilla.org/newlayout/xml/parsererror.xml"))
{
  
  var error_text=roottag.firstChild.nodeValue;
  var error_subtext=roottag.firstChild.nextSibling.firstChild.nodeValue;
  var arr=/Line Number ([0-9]+), Column ([0-9]+)\:/.exec(error_text);
  var line=parseInt(arr[1]);
  var column=parseInt(arr[2]);
  alert(error_text +"\n-------------\n"+error_subtext);
  arr=tx.split('\n');
  var i,pos=0;
  for(i=0;i<(line-1);i++)pos+=arr[i].length;
  pos+=column+(line-1)-3;
  obj.setSelectionRange(pos,pos+error_subtext.length-3);
  _XDOC.scrollTop=pos;
  obj.focus();
  return false;
}
else return true;


}
 return true;
}

function checkEmail(obj){
    var str=obj.value;
    if(str=='') return true;
    if (/^([\w-~_]+\.)*[\w-~_]+@([\w-_]+\.){1,3}\w{2,4}$/.test(str))
        return true;
    else {
        alert("Неправильный e-mail адрес");
        obj.focus();
        return false;
    }
}

function IsDate(o)   {
   var dd=o.value;
if(dd=="") return true;
   var a=dd.split("-");
   if (a.length!=3 || a[2].length!=4 || a[1].length!=2 ||  a[0].length!=2 )
   {
     alert("Неверная дата");
     o.focus();
     return false;
   }
var ad=new Date(parseInt(a[2],10),parseInt(a[1],10)-1,parseInt(a[0],10));
if ((parseInt(a[0],10)==ad.getDate()) && ((parseInt(a[1],10)-1)==ad.getMonth()) && (parseInt(a[2],10)==ad.getFullYear()))   
{return true} 
else 
 {
     alert("Неверная дата");
     o.focus();
     return false
 }   
}

function SelectAll(f,mark,name)
{
  for (i = 0; i < f.elements.length; i++)
   {
    var item = f.elements[i];
    if (item.name == name)
     {
      item.checked = mark;
     };
   }
return true;
}

function dl()
{
return confirm('Подверждаете удаление?');
}

var ldr=null;

function add(sel,v,n){
var newOpt=sel.appendChild(document.createElement('option'));
newOpt.text=n;
newOpt.value=v;
}

function chan(f,name,qw,parm)
{
 if(ldr&&ldr.readyState!=0) { ldr.abort() }
 ldr=selector();
 if(ldr)
 {
        name.length = 0;
        var now = new Date();
//      alert("selector.plx?q="+parm+"&sel="+qw+"&t="+now.getSeconds());
        ldr.open("GET","selector.php?q="+parm+"&sel="+qw+"&t="+now.getSeconds(),true);
        ldr.onreadystatechange=function()
        {
        if(ldr.readyState==4 && ldr.responseText)
                {
                        eval(ldr.responseText);
                }
        };
        ldr.send(null)
 }
}


function selector()
{
        var A=null;
        try{A=new ActiveXObject("Msxml2.XMLHTTP")}
        catch(e){try{A=new ActiveXObject("Microsoft.XMLHTTP")}
        catch(oc){A=null}}
        if(!A&&typeof XMLHttpRequest!="undefined") {A=new XMLHttpRequest()}
        return A
}


nodes= new Array ();
function clickOnFolder(fid)
{
   var obj,obj1;
   obj=document.getElementById("F_"+fid); obj1=document.getElementById("I_"+fid);
   if(obj)
   {
   if(nodes[fid])
   {
    nodes[fid]=false;
    obj.style.display="none";
    if(obj1)obj1.src="i/plus.gif"
   }
   else
   {
    nodes[fid]=true;
    obj.style.display="block";
    if(obj1)obj1.src="i/minus.gif"
   }
   } 
   return false;
}

function psel(id,text,name)
{
  if(!name) name=__name;
  obj=opener.document.getElementById('f')[name];
  obj.value=id;
  obj=opener.document.getElementById('f')["v_"+name];
  obj.value=text;
  window.close();
  return false;
}

function DictPopUp_(name,fld){
        var p=window.open(name+'.php?_pop=y&_popfld='+fld,'dict_window',"width=610,height=710,top=0,left=0,location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,fullscreen=0");
        if(p)p.focus();
        return false;
}
function DictPopUp(name){
        var p=window.open(name,'dict_window',"width=810,height=710,top=0,left=0,location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,fullscreen=0");
        if(p)p.focus();
        return false;
}

function pSet(id,arr,win)
{
  obj=$('#'+field_activator);
  vobj=$('#v'+field_activator);
  if(arr[field_selector]){
	vobj.attr('value',arr[field_selector]);
	obj.attr('value',id);
	}
  win.close();
  return false;
}



function pSetM(aid,atx,win)
{
  obj=$('#'+field_activator);
  vobj=$('#v'+field_activator);
  vobj.attr('value',atx);
  obj.attr('value',aid);
  win.close();
  savePopUp();
  return false;
}




function treeO(id,level,chd)
{
if(level=='0')level='';else level=' level'+level;
chd = chd.parentNode;
if(AV[id]==0){AV[id]=1;ocT(id,'');chd.className="expanded"+level;}
else if(AV[id]==1){AV[id]=0;ocT(id,'none');chd.className="collapsed"+level;}
return false;
}

function ocT(id,disp)
{
if(!A[id]) return false;
var B = A[id];
for (var i=0;i<B.length;i++){
	if(AV[B[i]]==1)trO(B[i],disp);
	$('#tr'+B[i]).css({'display':disp});
}
}

function trO(id,disp)
{
if(!A[id]){$('#tr'+id).css({'display':disp}); return false;}
dT(id,disp);
return false;
}

function dT(id,disp)
{
var B = A[id];
for (var i=0;i<B.length;i++){	
	if(AV[B[i]]==1)trO(B[i],disp);
	$('#tr'+B[i]).css({'display':disp});
}
}

/* Таблица с данными (в переменную, для ускорения доступа) */
var $_payment_outman = false;
$(function(){ $_table_type2 = $('table.type-2'); });    
    
/* Обработчик выделения галочек с шифтом */
jQuery.fn.shiftSelect = function()
{
    var checkboxes = this;
    var lastSelected;

    jQuery(this).click(function(event)
    {
        if (!lastSelected)
        {
            lastSelected = this;
            return;
        }

        if (event.shiftKey)
        {
            var selIndex = checkboxes.index(this);
            var lastIndex = checkboxes.index(lastSelected);
            /*
            * if you find the "select/unselect" behavior unseemly,
            * remove this assignment and replace 'checkValue'
            * with 'true' below.
            */
            var checkValue = lastSelected.checked;
            if (selIndex == lastIndex)
            {
                return true;
            }

            var end = Math.max(selIndex, lastIndex);
            var start = Math.min(selIndex, lastIndex);
            for (i = start; i <= end; i++)
            {
                checkboxes[i].checked = checkValue;
            }
        }
        lastSelected = this;
    });
}

/* Вешаем обработчки на галочки */
$( function(){ $("input[type='checkbox']", $_table_type2).shiftSelect(); } );

/* *********************************************************** */