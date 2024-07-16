package org.joget.marketplace;

import com.github.mfathi91.time.PersianDate;
import org.joget.apps.app.service.AppUtil;
import org.joget.apps.form.model.*;
import org.joget.apps.form.service.FormUtil;

import java.util.Map;

public class PersianDatePicker extends Element implements FormBuilderPaletteElement {

    private static final String DEFAULT_DISPLAY_FORMAT = "dd/MM/yyyy";
    private static final String DEFAULT_STORAGE_FORMAT = "yyyy/MM/dd";

    @Override
    public String renderTemplate(FormData formData, Map dataModel) {
        String template = "persianDatePicker.ftl";
        String value = FormUtil.getElementPropertyValue(this, formData);
        String dataFormat = getPropertyString("dataFormat");

        String displayFormat = getPropertyString("format");
        if (displayFormat == null || displayFormat.isEmpty()) {
            displayFormat = DEFAULT_DISPLAY_FORMAT;
        }
        if (dataFormat == null || dataFormat.isEmpty()) {
            dataFormat = DEFAULT_STORAGE_FORMAT;
        }
        if (value != null && !value.isEmpty()) {
            try {
                PersianDate persianDate = parsePersianDate(value, dataFormat);
                value = formatPersianDate(persianDate, displayFormat);
            } catch (Exception ex) {
            }
        }

        dataModel.put("value", value);
        dataModel.put("displayFormat", displayFormat);
        dataModel.put("dataFormat", dataFormat);

        String html = FormUtil.generateElementHtml(this, formData, template, dataModel);
        return html;
    }

    @Override
    public FormRowSet formatData(FormData formData) {
        FormRowSet rowSet = null;
        String id = getPropertyString(FormUtil.PROPERTY_ID);

        if (id != null) {
            String value = FormUtil.getElementPropertyValue(this, formData);
            String displayFormat = getPropertyString("format");
            String dataFormat = getPropertyString("dataFormat");

            if (displayFormat == null || displayFormat.isEmpty()) {
                displayFormat = DEFAULT_DISPLAY_FORMAT;
            }
            if (dataFormat == null || dataFormat.isEmpty()) {
                dataFormat = DEFAULT_STORAGE_FORMAT;
            }

            if (value != null && !value.isEmpty()) {
                try {
                    PersianDate persianDate = parsePersianDate(value, displayFormat);
                    String storedValue = formatPersianDate(persianDate, dataFormat);

                    FormRow result = new FormRow();
                    result.setProperty(id, storedValue);
                    rowSet = new FormRowSet();
                    rowSet.add(result);
                } catch (Exception ex) {
                    FormRow result = new FormRow();
                    result.setProperty(id, value);
                    rowSet = new FormRowSet();
                    rowSet.add(result);
                }
            }
        }
        return rowSet;
    }

    private PersianDate parsePersianDate(String dateStr, String format) {
        String[] dateParts = dateStr.split("[/\\-]");
        String[] formatParts = format.split("[/\\-]");

        if (dateParts.length != 3 || formatParts.length != 3) {
            throw new IllegalArgumentException("Invalid date or format: " + dateStr + ", " + format);
        }

        int year = 0, month = 0, day = 0;

        for (int i = 0; i < 3; i++) {
            int value = Integer.parseInt(dateParts[i]);
            switch (formatParts[i].toUpperCase()) {
                case "YYYY":
                    year = value;
                    break;
                case "MM":
                    month = value;
                    break;
                case "DD":
                    day = value;
                    break;
                default:
                    throw new IllegalArgumentException("Invalid format part: " + formatParts[i]);
            }
        }

        if (year < 100) {
            for (int value : new int[]{month, day}) {
                if (value > 1000) {
                    year = value;
                    if (month == value) {
                        month = year;
                    } else if (day == value) {
                        day = year;
                    }
                    break;
                }
            }
        }
        if (month < 1 || month > 12) {
            throw new IllegalArgumentException("Invalid month value: " + month);
        }
        if (day < 1 || day > 31) {
            throw new IllegalArgumentException("Invalid day value: " + day);
        }

        return PersianDate.of(year, month, day);
    }

    private String formatPersianDate(PersianDate date, String format) {
        String separator = format.contains("/") ? "/" : "-";
        if (format.startsWith("yyyy")) {
            return String.format("%04d%s%02d%s%02d", date.getYear(), separator, date.getMonthValue(), separator, date.getDayOfMonth());
        } else if (format.startsWith("MM")) {
            return String.format("%02d%s%02d%s%04d", date.getMonthValue(), separator, date.getDayOfMonth(), separator, date.getYear());
        } else {
            return String.format("%02d%s%02d%s%04d", date.getDayOfMonth(), separator, date.getMonthValue(), separator, date.getYear());
        }
    }

    @Override
    public String getName() {
        return "Persian Date Picker";
    }

    @Override
    public String getVersion() {
        return "8.0.0";
    }

    @Override
    public String getDescription() {
        return "Persian Date Picker Element";
    }

    @Override
    public String getLabel() {
        return "Persian Date Picker";
    }

    @Override
    public String getClassName() {
        return getClass().getName();
    }

    @Override
    public String getPropertyOptions() {
        return AppUtil.readPluginResource(getClass().getName(), "/properties/PersianDatePickerElement.json", null, true, "message/PersianDatePickerElement");
    }

    @Override
    public String getFormBuilderCategory() {
        return "Marketplace";
    }

    @Override
    public int getFormBuilderPosition() {
        return 200;
    }

    @Override
    public String getFormBuilderIcon() {
        return "<i class=\"fas fa-calendar-alt\"></i>";
    }

    @Override
    public String getFormBuilderTemplate() {
        return "<label class='label'>Persian Date Picker</label><input type='text' />";
    }
}
