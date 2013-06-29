<!--
var today = new Date();
var currMonth = today.getMonth();
var currYear = today.getFullYear();
var shownCalendarId = '';
var shownCalendarBtn = null;
var currField = null;
var currDate = new Date();
var monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'];
var monthNamesR = ['янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
var weekdayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
var weekdayInits = ['П', 'В', 'С', 'Ч', 'П', 'С', 'В'];

function setDate(dateSet, monthSet, yearSet) {
  monthSet+=1;
  var dateToSet = new Date(yearSet, monthSet, dateSet);
  if (currField) currField.value = yearSet + '-' + monthSet+'-'+dateSet;
  hideCurrCalendar();
  return false;
}

function showCalendar(btnElem, name) {
  var currCalBtn = shownCalendarBtn;
  if (shownCalendarId != '') hideCurrCalendar();
  if (currCalBtn != btnElem) {
  currField = btnElem.form.elements[name];
  currDate = new Date();
  shownCalendarBtn = btnElem;
  shownCalendarId = 'c_div_'+name;
  drawCalendar(shownCalendarId, 'c_anc_'+name);
  }
  return false;
}
function hideCurrCalendar() {
  if (shownCalendarId != '') hideLeer(shownCalendarId);
  if (shownCalendarBtn != null && shownCalendarBtn.style) shownCalendarBtn.style.borderStyle = 'outset';
  shownCalendarId = '';
  shownCalendarBtn = null;
  currField = null;
}
function drawCalendar(leerId, ancName, showYear, showMonth) {
  // insetting the button
  if (shownCalendarBtn != null) {
    if (shownCalendarBtn.style) shownCalendarBtn.style.borderStyle = 'inset';
  }
  var month = new Date();
  if (showMonth != null) month.setMonth(showMonth, 1);
  else month.setMonth(currDate.getMonth());
  if (showYear != null) month.setYear(showYear);
  else month.setYear(currDate.getFullYear());
  var thisMonth = month.getMonth();
  var nextMonth = (thisMonth == 11)? 0 : thisMonth + 1;
  var prevMonth = (thisMonth == 0)? 11 : thisMonth - 1;
  var thisYear = month.getFullYear();
  var nextYear = (thisMonth == 11)? thisYear + 1 : thisYear;
  var prevYear = (thisMonth == 0)? thisYear - 1 : thisYear;
  var isThisMonth = (month.getFullYear() == currDate.getFullYear() && month.getMonth() == currDate.getMonth())? true : false;
  // table starts
  var calendarHTML = '<table cellpadding="1" cellspacing="0" border="0" width="130"><tr bgcolor="#000000"><td><table cellpadding="1" cellspacing="0" border="0" width="100%"><tr bgcolor="#e9ebf1">';
  // link back
  calendarHTML += '<td><a href=""' +
  'onClick="return drawCalendar(\'' + leerId + '\', \'' + ancName + '\', ' + prevYear + ', ' + prevMonth +
  ');"><img src="i/c/p.gif" width="13" height="13" border="0" /><\/a><\/td>';
  // month, year row
  calendarHTML += '<td align="center" nowrap="nowrap"><span class="b">' + monthNames[month.getMonth()] + ', ' + month.getFullYear() + '</span><\/td>';
  // link fwd
  calendarHTML += '<td align="right"><a href="" onClick="return drawCalendar(\'' +
  leerId + '\', \'' + ancName + '\', ' + nextYear + ', ' +
  nextMonth + ');"><img src="i/c/n.gif" width="13" height="13" border="0" /><\/a><\/td><\/tr>' +
  '<tr><td colspan="3" align="center" bgcolor="#ffffff" style="padding: 0 10px; border-top: 1px solid #808080;">';
  // starting the calendar table...
  calendarHTML += '<table cellpadding="2" cellspacing="0" border="0" style="border-bottom: 1px solid #fff;"><tr align="right">'
  // appending day initials
  for (var i = 0; i < weekdayInits.length; i++) calendarHTML += '<td style="border-bottom: 1px solid #808080;"><span class="b">' + weekdayInits[i] + '</span><\/td>'
  calendarHTML += '<tr align="right">'
  // getting the first day of the month
  month.setDate(1);
  var daysToStart = (month.getDay() == 0)? 7 : month.getDay();
  // drawing empty cells
  for (var i = 0; i < daysToStart - 1; i++) calendarHTML += '<td> <\/td>';
  // drawing the calendar itself
  for (var i = 1; i < 33; i++) {
  month.setDate(i);
  if (month.getMonth() == thisMonth) {
  if (isThisMonth && currDate.getDate() == i) calendarHTML += '<td><a href="" onClick="setDate(' + i + ', ' + thisMonth + ', ' + thisYear + '); return false;" class="cal">' + i + '</a></small><\/td>';
  else calendarHTML += '<td><a href="" onClick="return setDate(' + i + ', ' + thisMonth + ', ' + thisYear + ');" class="b">' + i + '<\/a><\/td>';
  } else break;
  if (month.getDay() == 0) calendarHTML += '<\/tr><tr align="right">';
  }
  // drawing empty cells if any
  if (month.getDay() != 1) {
  var finalDay = (month.getDay() == 0)? 7 : month.getDay();
  var daysToEnd = 8 - finalDay;
  for (var i = 0; i < daysToEnd; i++) calendarHTML += '<td> <\/td>';
  }
  // tables ends
  calendarHTML += '<\/tr><\/table><\/td><\/tr><\/table><\/td><\/tr><\/table>';
  var leerPos = new getCalendarPosition(ancName);
  if (document.getElementById) {
    var leerElem = document.getElementById(leerId);
    leerElem.innerHTML = calendarHTML;
    leerElem.style.left = leerPos.x;
    leerElem.style.top = leerPos.y;
    leerElem.style.visibility = 'visible';
  } else if (document.all) {
    var leerElem = document.all[leerId];
    leerElem.innerHTML = calendarHTML;
    leerElem.style.left = leerPos.x;
    leerElem.style.top = leerPos.y;
    leerElem.style.visibility = 'visible';
  } else if (document.layers) {
    document.layers[leerId].left = leerPos.x;
    document.layers[leerId].top = leerPos.y;
    document.layers[leerId].document.open();
    document.layers[leerId].document.write(calendarHTML);
    document.layers[leerId].document.close();
    document.layers[leerId].visibility = 'show';
  }
  return false;
}

function hideLeer(leerId) { document.getElementById(leerId).style.visibility = 'hidden'; }

function ancPosX(anchorPtr) {
  if (document.layers) {
    return anchorPtr.x;
  } else if (document.getElementById || document.all) {
    var pos = anchorPtr.offsetLeft;
    while (anchorPtr.offsetParent != null) {
      anchorPtr = anchorPtr.offsetParent;
      pos += anchorPtr.offsetLeft;
    } return pos;
  }
}
function ancPosY(anchorPtr) {
  if (document.layers) {
    return anchorPtr.y;
  } else if (document.getElementById || document.all) {
    var pos = anchorPtr.offsetTop;
    while (anchorPtr.offsetParent != null) {
      anchorPtr = anchorPtr.offsetParent;
      pos += anchorPtr.offsetTop;
    }
    return pos;
  }
}

function getCalendarPosition(ancName) {
	var anc=document.getElementById(ancName);
    this.x = ancPosX(anc);
    this.y = ancPosY(anc);
    return this;
}

function isParent(elemPtr, parentId) {
  if (document.getElementById) {
  //	while (elemPtr.parentNode != null) {
  //	if //	}
  }
  return false;
}

function resizing() {
  if (document.layers) {
  if (window.innerWidth != origWidth || window.innerHeight != origHeight) location.reload();
  } else hideCurrCalendar();
}
window.onresize = resizing;
// -->