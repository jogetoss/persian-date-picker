<div class="form-cell" ${elementMetaData!}>
      <#if !(request.getAttribute("org.joget.marketplace.persiandatepicker.PersianDatePicker_EDITABLE")??)>
          <link rel="stylesheet" href="${request.contextPath}/plugin/org.joget.marketplace.PersianDatePicker/others/persian-datepicker.min.css"/>
          <script src="${request.contextPath}/plugin/org.joget.marketplace.PersianDatePicker/others/persian-date.min.js"></script>
          <script src="${request.contextPath}/plugin/org.joget.marketplace.PersianDatePicker/others/persian-datepicker.min.js"></script>
      </#if>
  
      <label class="label" for="${elementParamName!}_${element.properties.elementUniqueKey!}">
          ${element.properties.label} <span class="form-cell-validator">${decoration}</span>
          <#if error??> <span class="form-error-message">${error}</span></#if>
      </label>
  
      <#if (element.properties.readonly! == 'true' && element.properties.readonlyLabel! == 'true')>
          <div class="form-cell-value"><span>${value!?html}</span></div>
          <input id="${elementParamName!}" name="${elementParamName!}" class="textfield_${element.properties.elementUniqueKey!}" type="hidden" value="${value!?html}" />
      <#else>
          <div style="position:relative;">
            <input id="${elementParamName!}_${element.properties.elementUniqueKey!}" 
                     name="${elementParamName!}" 
                     autocomplete="off" 
                     <#if (element.properties.readonly! != 'true' || element.properties.readonlyLabel! != 'true')>
                     style="background-image: url('/jw/css/images/calendar.png'); background-position: calc(100% - 10px) center; background-origin: border-box; background-repeat: no-repeat; padding-right: 30px;"
                     </#if>
                     class="textfield_${element.properties.elementUniqueKey!} <#if error??>form-error-cell</#if>" 
                     type="text" 
                     value="${value!?html}" 
                     maxlength="100" 
                     <#if error??>class="form-error-cell"</#if> 
    <#if element.properties.readonly! == 'true'>readonly
    </#if> placeholder="<#if (element.properties.placeholder! != '')>${element.properties.placeholder!?html}<#else>${displayFormat!?html}</#if>" />  
          </div>
      </#if>
  
  <#if element.properties.readonly! != 'true'>
  
      <script type="text/javascript">
      function persianToUnix(dateString, format) {
  
          let formatParts = format.split(/[/\-]/);
          let dateParts = dateString.split(/[/\-]/);
  
          if (formatParts.length !== dateParts.length) {
              return null;
          }
  
          let year, month, day;
  
          formatParts.forEach((part, index) => {
              switch(part.toUpperCase()) {
                  case 'YYYY':
                      year = parseInt(dateParts[index]);
                      break;
                  case 'MM':
                      month = parseInt(dateParts[index]);
                      break;
                  case 'DD':
                      day = parseInt(dateParts[index]);
                      break;
              }
          });
  
          if (isNaN(year) || isNaN(month) || isNaN(day)) {
              return null;
          }
  
          try {
  if (year < 1000) {
              year += 1300; 
          }
  
              const pDate = new persianDate([year, month, day]);
              const gDate = pDate.toCalendar('gregorian');
              const unixTime = gDate.valueOf();
              return unixTime;
          } catch (error) {
              return null;
          }
      }
  
      function calculateDateRange(startDateFieldId, endDateFieldId, displayFormat) {
          var today = new persianDate();
      var todayUnix = today.valueOf();
          var minDateUnix, maxDateUnix;
         
          if (startDateFieldId) {
              var startDateElement = $("[name='" + startDateFieldId + "']");
              var startDateValue = startDateElement.val();
              if (startDateValue) {
                  try {
                      minDateUnix = persianToUnix(startDateValue, displayFormat);
                  } catch (error) {
                      minDateUnix = todayUnix;
                  }
              } else {
                  minDateUnix = todayUnix;
              }
          } else {
              minDateUnix = todayUnix;
          }
          if (endDateFieldId) {
              var endDateElement = $("[name='" + endDateFieldId + "']");
              var endDateValue = endDateElement.val();
              if (endDateValue) {
                  try {
                      maxDateUnix = persianToUnix(endDateValue, displayFormat);
                  } catch (error) {
                      maxDateUnix = todayUnix;
                  }
              } else {
                  maxDateUnix = todayUnix;
              }
          } else {
              maxDateUnix = todayUnix;
          }
          
  
          return { minDateUnix, maxDateUnix };
      }
  
      $(document).ready(function() {
          try {
              var $datepicker = $("#${elementParamName!}_${element.properties.elementUniqueKey!}");
              var displayFormat = "${displayFormat!'YYYY/MM/DD'}";
              var dataFormat = "${dataFormat!'YYYY-MM-DD'}"; 
              var today = new Date();
              var todayUnix = today.getTime();
              var startDateFieldId = "${element.properties.startDateFieldId!}";
              var endDateFieldId = "${element.properties.endDateFieldId!}";
              var minDateUnix, maxDateUnix;
  
              if (startDateFieldId && endDateFieldId) {
                  var dateRange = calculateDateRange(startDateFieldId, endDateFieldId, displayFormat);
                  minDateUnix = dateRange.minDateUnix;
                  maxDateUnix = dateRange.maxDateUnix;

              } else if (startDateFieldId) { 
              var dateRange = calculateDateRange(startDateFieldId, null, displayFormat);
              minDateUnix = dateRange.minDateUnix;
              maxDateUnix = todayUnix; 
              
              } else if (endDateFieldId) { 
              var dateRange = calculateDateRange(null, endDateFieldId, displayFormat);
              minDateUnix = todayUnix; 
              maxDateUnix = dateRange.maxDateUnix;
              
              }
  
  
             function updateRangeDatepicker() {

              if (startDateFieldId && endDateFieldId) {
                  var newDateRange = calculateDateRange(startDateFieldId, endDateFieldId, displayFormat);
                  $datepicker.pDatepicker('setOption', 'minDate', newDateRange.minDateUnix);
                  $datepicker.pDatepicker('setOption', 'maxDate', newDateRange.maxDateUnix);

              } else if (startDateFieldId) { 

                  var newDateRange = calculateDateRange(startDateFieldId, null, displayFormat);
                  $datepicker.pDatepicker('setOption', 'minDate', newDateRange.minDateUnix);

              } else if (endDateFieldId) { 
                  var newDateRange = calculateDateRange(null, endDateFieldId, displayFormat);
                  $datepicker.pDatepicker('setOption', 'maxDate', newDateRange.maxDateUnix);
              }
            }
  
              var $startDatePicker = $("[name='" + startDateFieldId + "']");
              var $endDatePicker = $("[name='" + endDateFieldId + "']");
  
        $datepicker.one('focus click', function() {
  
              $datepicker.pDatepicker({
                  format: displayFormat,
                  altField: '#alternateField',
                  altFormat: dataFormat,
                  observer: true,
                  autoClose: true,
                  inline: false,
                  onlySelectOnDate: true,
                  initialValue: false,
                  initialValueType:'persian',
                  toolbox: {
                      enabled: true,
                      calendarSwitch: {
                          enabled: false,
                          format: "MMMM"
                      }
                  },
                  responsive: false,
                  <#if element.properties.currentDateAs?? && element.properties.currentDateAs == "minDate">
                  minDate: todayUnix,
                  <#elseif element.properties.currentDateAs?? && element.properties.currentDateAs == "maxDate">
                  maxDate: todayUnix,
                  <#else>
                      <#if element.properties.startDateFieldId?? && element.properties.startDateFieldId != "" && element.properties.endDateFieldId?? && element.properties.endDateFieldId != "">
                      minDate: minDateUnix,
                      maxDate: maxDateUnix,
                      <#elseif element.properties.startDateFieldId?? && element.properties.startDateFieldId != "">
                      minDate: minDateUnix,
                      <#elseif element.properties.endDateFieldId?? && element.properties.endDateFieldId != "">
                      maxDate: maxDateUnix,
                      <#else>
                      </#if>
                  </#if>
                  formatter: function formatter(unixDate) {
                      var self = this,
                      pdate = this.model.PersianDate.date(unixDate);
                      pdate.formatPersian = false;
                      var originalFormat = self.format;
                      var format = self.format.toUpperCase();
                      var separator = format.includes('/') ? '/' : '-';
                      var patterns = ['MM' + separator + 'DD' + separator + 'YYYY',
                                      'DD' + separator + 'MM' + separator + 'YYYY',
                                      'YYYY' + separator + 'DD' + separator + 'MM',
                                      'YYYY' + separator + 'MM' + separator + 'DD'];
                      if (patterns.some(pattern => format === pattern)) {
                          var parts = pdate.format('YYYY' + separator + 'MM' + separator + 'DD').split(separator);
                          var result;
                          switch(format) {
                              case 'MM' + separator + 'DD' + separator + 'YYYY':
                                  result = parts[1] + separator + parts[2] + separator + parts[0];
                                  break;
                              case 'DD' + separator + 'MM' + separator + 'YYYY':
                                  result = parts[2] + separator + parts[1] + separator + parts[0];
                                  break;
                              case 'YYYY' + separator + 'DD' + separator + 'MM':
                                  result = parts[0] + separator + parts[2] + separator + parts[1];
                                  break;
                              case 'YYYY' + separator + 'MM' + separator + 'DD':
                                  result = parts.join(separator);
                                  break;
                          }
                          return result.split(separator).map((part, index) => {
                              var formatPart = originalFormat.split(separator)[index];
                              return formatPart === formatPart.toLowerCase() ? part.toLowerCase() :
                                  formatPart === formatPart.toUpperCase() ? part.toUpperCase() :
                                  part;
                          }).join(separator);
                      }
                      return pdate.format(originalFormat);
                  },
  
                  onShow: function() {

                  if (startDateFieldId && endDateFieldId) {
                      var dateRange = calculateDateRange(startDateFieldId, endDateFieldId, displayFormat);
                      this.model.options.minDate = dateRange.minDateUnix;
                      this.model.options.maxDate = dateRange.maxDateUnix;
                      this.model.view.reRender();                      
                      
                    } else if (startDateFieldId) {
                      var dateRange = calculateDateRange(startDateFieldId, null, displayFormat);
                      this.model.options.minDate = dateRange.minDateUnix;
                      this.model.view.reRender();
                   
                  } else if (endDateFieldId) {
                      var dateRange = calculateDateRange(endDateFieldId, null, displayFormat);
                      this.model.options.maxDate = dateRange.minDateUnix;
                      this.model.view.reRender();
                    }
              
                 }
  
              });
  
   });
          } catch (error) {
          }
      });
      </script>
  </#if>
  </div>