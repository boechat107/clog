(in-package :clog-tools)

(defparameter *import-types*
  (list '(:tag "label"
	  :control "label")
	'(:tag "input"
	  :control "input")
	'(:tag "form"
	  :control "form")
	'(:tag "button"
	  :control "button")
	'(:tag "a"
	  :control "link")
	'(:tag "img"
	  :control "image")
	'(:tag "meter"
	  :control "meter")
	'(:tag "progress"
	  :control "progress")
	'(:tag "ol"
	  :control "ol")
	'(:tag "ul"
	  :control "ul")
	'(:tag "li"
	  :control "li")
	'(:tag "li"
	  :control "li")
	'(:tag "table"
	  :control "table")
	'(:tag "tr"
	  :control "tr")
	'(:tag "td"
	  :control "td")
	'(:tag "th"
	  :control "th")
	'(:tag "thead"
	  :control "thead")
	'(:tag "tbody"
	  :control "tbody")
	'(:tag "tfoot"
	  :control "tfoot")
	'(:tag "caption"
	  :control "tcaption")
	'(:tag "colgroup"
	  :control "tcolgroup")
	'(:tag "col"
	  :control "tcol")
	'(:tag "span"
	  :control "span")
	'(:tag "style"
	  :control "style-block")
	'(:tag "fieldset"
	  :control "fieldset")
	'(:tag "legend"
	  :control "legend")
	'(:tag "div"
	  :control "div")))

(defparameter *props-location*
  `((:name "top"
     :get ,(lambda (control)
	     (if (equal (positioning control) "static")
		 "n/a"
		 (top control)))
     :set ,(lambda (control obj)
	     (setf (top control) (text obj))))
    (:name "left"
     :get  ,(lambda (control)
	      (if (equal (positioning control) "static")
		  "n/a"
		  (left control)))
     :set  ,(lambda (control obj)
	      (setf (left control) (text obj))))
    (:name "positioning"
     :setup ,(lambda (control td1 td2)
	       (declare (ignore td1))
	       (let ((dd (create-select td2))
		     (v  (string-downcase (positioning control))))
		 (add-select-options dd `(,v
					  "absolute"
					  "static"
					  "relative"
					  "sticky"
					  "fixed"))
		 (set-on-change dd (lambda (obj)
				     (declare (ignore obj))
				     (setf (positioning control) (value dd))
				     (set-geometry (get-placer control)
						   :top (position-top control)
						   :left (position-left control)
						   :width (client-width control)
						   :height (client-height control))
				     (on-populate-control-properties-win obj)))
		 nil)))))

(defparameter *props-with-height*
  '((:name "width"
     :setf clog:width)
    (:name "height"
     :setf clog:height)))

(defparameter *props-form-values*
  `((:name "value"
     :setf clog:value)
    (:name "name on form"
     :setf clog:name)
    (:name "size"
     :prop "size")
    (:name "place holder"
     :prop "placeholder")
    (:name "default value"
     :prop "defaultValue")
    (:name "image url"
     :prop "src")
    (:name "image alt"
     :prop "alt")
    (:name "checked"
     :get  ,(lambda (control)
	      (property control "checked"))
     :set  ,(lambda (control obj)
	     (if (equalp (text obj) "true")
		 (setf (checkedp control) t)
		 (setf (checkedp control) nil))
	      (property control "required")))
    (:name "read only"
     :get  ,(lambda (control)
	      (property control "readonly"))
     :set  ,(lambda (control obj)
	     (if (equalp (text obj) "true")
		 (setf (read-only-p control) t)
		 (setf (read-only-p control) nil))
	     (property control "readonly")))
    (:name "disabled"
     :get  ,(lambda (control)
	      (property control "disabled"))
     :set  ,(lambda (control obj)
	     (if (equalp (text obj) "true")
		 (setf (disabledp control) t)
		 (setf (disabledp control) nil))
	     (property control "disabled")))
    (:name "required"
     :get  ,(lambda (control)
	      (property control "required"))
     :set  ,(lambda (control obj)
	     (if (equalp (text obj) "true")
		 (setf (requiredp control) t)
		 (setf (requiredp control) nil))
	      (property control "required")))
    (:name "pattern"
     :prop "pattern")
    (:name "minimum"
     :prop "min")
    (:name "maximum"
     :prop "max")
    (:name "element step"
     :prop "step")
    (:name "minimum length"
     :prop "minlength")
    (:name "maximum length"
     :prop "maxlength")
    (:name "multiple"
     :get  ,(lambda (control)
	      (property control "multiple"))
     :set  ,(lambda (control obj)
	      (if (equalp (text obj) "true")
		 (setf (multiplep control) t)
		 (setf (multiplep control) nil))
	      (property control "multiple")))
    (:name "files accepted"
     :prop "accept")))

(defparameter *props-colors*
  `((:name "color"
     :setup ,(lambda (control td1 td2)
	       (declare (ignore td1))
	       (let ((d1 (create-form-element td2 :text  :value (color control)))
		     (dd (create-form-element td2 :color :value (color control))))
		 (make-data-list dd '("#ffffff"
				      "#ff0000"
				      "#00ff00"
				      "#0000ff"
				      "#ff00ff"))
		 (set-on-change dd (lambda (obj)
				     (declare (ignore obj))
				     (setf (value d1) (value dd))
				     (setf (color control) (value d1))))
		 (set-on-change d1 (lambda (obj)
				     (declare (ignore obj))
				     (setf (color control) (value d1)))))
	       nil))
    (:name "opacity"
     :style "opacity")
    (:name "background color"
     :setup ,(lambda (control td1 td2)
	       (declare (ignore td1))
	       (let ((d1 (create-form-element td2 :text  :value (background-color control)))
		     (dd (create-form-element td2 :color :value (background-color control))))
		 (make-data-list dd '("#ffffff"
				      "#ff0000"
				      "#00ff00"
				      "#0000ff"
				      "#ff00ff"))
		 (set-on-change dd (lambda (obj)
				     (declare (ignore obj))
				     (setf (value d1) (value dd))
				     (setf (background-color control) (value d1))))
		 (set-on-change d1 (lambda (obj)
				     (declare (ignore obj))
				     (setf (background-color control) (value d1))))
		 nil)))
    (:name "background attachment"
     :style "background-attachment")
    (:name "background image"
     :style "background-image")
    (:name "background position"
     :style "background-position")
    (:name "background origin"
     :style "background-origin")
    (:name "background repeat"
     :style "background-repeat")
    (:name "background clip"
     :style "background-clip")
    (:name "background size"
     :style "background-size")
    (:name "border"
     :style "border")
    (:name "border radius"
     :style "border-radius")
    (:name "box shadow"
     :style "box-shadow")
    (:name "text shadow"
     :style "text-shadow")
    (:name "outline"
     :style "outline")
    (:name "margin"
     :style "margin")
    (:name "padding"
     :style "padding")
    (:name "cursor"
     :style "cursor")
    (:name "font"
     :style "font")
    (:name "text alignment"
     :style "text-align")
    (:name "vertical align"
     :style "vertical-align")))

(defparameter *props-text*
  `((:name "contents"
     :setup ,(lambda (control td1 td2)
	       (declare (ignore td1))
	       (let ((d1 (create-text-area td2 :value (inner-html control))))
		 (set-on-change d1 (lambda (obj)
				     (declare (ignore obj))
				     (setf (inner-html control) (value d1)))))
	       nil))))

(defparameter *props-css*
  `((:name "css classes"
     :prop "className")))

(defparameter *props-base*
  `((:name "hidden"
     :get  ,(lambda (control)
	      (property control "hidden"))
     :set  ,(lambda (control obj)
	      (if (equalp (text obj) "true")
		 (setf (hiddenp control) t)
		 (setf (hiddenp control) nil))
	      (property control "hidden")))
    (:name "visible"
     :get  ,(lambda (control)
	      (style control "visibility"))
     :set  ,(lambda (control obj)
	      (if (or (equalp (text obj) "true")
		      (equalp (text obj) "visible"))
		 (setf (visiblep control) t)
		 (setf (visiblep control) nil))
	      (style control "visibility")))
    (:name "editable"
     :prop "contenteditable")
    (:name "spell check"
     :prop "spellcheck")
    (:name "text direction"
     :prop "test-direction")
    (:name "language code"
     :prop "lang")
    (:name "overflow"
     :style "overflow")
    (:name "resizable"
     :style "resize")
    (:name "minimum width"
     :style "min-width")
    (:name "minimum height"
     :style "min-height")
    (:name "maximum width"
     :style "max-width")
    (:name "maximum height"
     :style "max-height")))

(defparameter *props-nav*
  '((:name "access key"
     :prop "access key")
    (:name "tool tip"
     :prop "title")
    (:name "tab index"
     :prop "tabindex")
    (:name "z index"
     :style "z-index")))

(defparameter *props-base*
  `(,@*props-location*
    ,@*props-with-height*
    ,@*props-css*
    ,@*props-colors*
    ,@*props-base*
    ,@*props-nav*))

(defparameter *props-element*
  `(,@*props-location*
    ,@*props-with-height*
    ,@*props-text*
    ,@*props-css*
    ,@*props-colors*
    ,@*props-base*
    ,@*props-nav*))

(defparameter *props-form-element*
  `(,@*props-location*
    ,@*props-with-height*
    (:name "type"
     :setup ,(lambda (control td1 td2)
	       (declare (ignore td1))
	       (let ((dd (create-select td2))
		     (v  (string-downcase (attribute control "type"))))
		 (add-select-options dd `(,v
					  "button" "checkbox" "color" "date"
					  "datetime" "datetime-local" "email"
					  "image" "file" "hidden" "image"
					  "month" "number" "password" "radio"
					  "range" "reset" "search" "submit"
					  "tel" "text" "time" "url" "week"))
		 (set-on-change dd (lambda (obj)
				   (declare (ignore obj))
				   (setf (attribute control "type") (value dd))
				   (set-geometry (get-placer control)
						 :top (position-top control)
						 :left (position-left control)
						 :width (client-width control)
						 :height (client-height control))))
		 nil)))
    ,@*props-form-values*
    ,@*props-css*
    ,@*props-colors*
    ,@*props-base*
    ,@*props-nav*))

(defparameter *supported-controls*
  (list
   '(:name           "select"
     :description    "Selection Tool"
     :create         nil
     :create-type    nil
     :properties     nil
     :positioning    nil)
   `(:name           "label"
     :description    "Label"
     :clog-type      clog:clog-label
     :create         clog:create-label
     :create-type    :element
     :create-content "Label"
     :properties     ((:name "for"
		       :get ,(lambda (control)
			       (clog::js-query control (format nil "$('#~A').attr('data-clog-name')"
							       (attribute control "for"))))
		       :set ,(lambda (control obj)
			       (setf (attribute control "for")
				     (clog::js-query control (format nil "$(\"[data-clog-name='~A']\").attr('id')"
										     (text obj))))))
		      ,@*props-element*))
   `(:name           "button"
     :description    "Button"
     :clog-type      clog:clog-button
     :create         clog:create-button
     :create-type    :element
     :create-content "Button"
     :properties     (,@*props-element*))
   `(:name           "div"
     :description    "Div"
     :clog-type      clog:clog-div
     :create         clog:create-div
     :create-type    :element
     :create-content ""
     :properties     (,@*props-element*))
   `(:name           "fieldset"
     :description    "Fieldset"
     :clog-type      clog:clog-fieldset
     :create         clog:create-fieldset
     :create-type    :base
     :properties     (,@*props-base*))
   `(:name           "legend"
     :description    "Fieldset Legend"
     :clog-type      clog:clog-legend
     :create         clog:create-legend
     :create-content "Legend here"
     :create-type    :element
     :properties     (,@*props-element*))
   `(:name           "span"
     :description    "Span"
     :clog-type      clog:clog-span
     :create         clog:create-span
     :create-type    :element
     :create-content "text here"
     :properties     (,@*props-element*))
   `(:name           "link"
     :description    "Link"
     :clog-type      clog:clog-a
     :create         clog:create-a
     :create-type    :element
     :create-content "HTML Link"
     :properties     ((:name "href link"
		       :prop "href")
		      (:name "target"
		       :prop "target")
		      ,@*props-element*))
   `(:name           "image"
     :description    "Image"
     :clog-type      clog:clog-img
     :create         clog:create-img
     :create-type    :base
     :setup          ,(lambda (control content control-record)
			(declare (ignore content) (ignore control-record))
			(setf (url-src control) "/img/clogicon.png")
			(setf (alt-text control) "Add image url"))
     :properties     ((:name "image url"
		       :prop "src")
		      (:name "alternative text"
		       :prop "alt")
		      ,@*props-base*))
   `(:name           "meter"
     :description    "Meter"
     :clog-type      clog:clog-meter
     :create         clog:create-meter
     :create-type    :base
     :properties     ((:name "value"
		       :prop "value")
		      (:name "high"
		       :prop "high")
		      (:name "low"
		       :prop "low")
		      (:name "maximum"
		       :prop "max")
		      (:name "minimum"
		       :prop "min")
		      (:name "optimum"
		       :prop "optimum")
		      ,@*props-base*))
   `(:name           "progress"
     :description    "Progress Bar"
     :clog-type      clog:clog-progress-bar
     :create         clog:create-progress-bar
     :create-type    :base
     :properties     ((:name "value"
		       :prop "value")
		      (:name "maximum"
		       :prop "max")
		      ,@*props-base*))
   `(:name           "ol"
     :description    "Ordered List"
     :clog-type      clog:clog-ordered-list
     :create         clog:create-ordered-list
     :create-type    :base
     :properties     ((:name "list kind"
		       :prop "list-style-type")
		      (:name "list location"
		       :prop "list-style-position")
		      ,@*props-element*))
   `(:name           "ul"
     :description    "Unordered List"
     :clog-type      clog:clog-unordered-list
     :create         clog:create-unordered-list
     :create-type    :base
     :properties     ((:name "value"
		       :prop "value")
		      ,@*props-element*))
   `(:name           "li"
     :description    "List Item"
     :clog-type      clog:clog-list-item
     :create         clog:create-list-item
     :create-type    :base
     :properties     (,@*props-element*))
   `(:name           "table"
     :description    "Table"
     :clog-type      clog:clog-table
     :create         clog:create-table
     :create-type    :base
     :properties     (,@*props-base*))
   `(:name           "tr"
     :description    "Table Row"
     :clog-type      clog:clog-table-row
     :create         clog:create-table-row
     :create-type    :base
     :properties     (,@*props-base*))
   `(:name           "td"
     :description    "Table Column"
     :clog-type      clog:clog-table-column
     :create         clog:create-table-column
     :create-type    :element
     :create-content "Column"
     :properties     ((:name "column span"
		       :attr "colspan")
		      (:name "row span"
		       :attr "rowspan")
		      ,@*props-element*))
   `(:name           "th"
     :description    "Table Heading"
     :clog-type      clog:clog-table-heading
     :create         clog:create-table-heading
     :create-type    :element
     :create-content "Heading"
     :properties     ((:name "column span"
		       :attr "colspan")
		      (:name "row span"
		       :attr "rowspan")
		      (:name "abbreviated version"
		       :attr "abbr")
		      (:name "scope"
		       :attr "rowspan")
		      ,@*props-element*))
   `(:name           "tcolgroup"
     :description    "Table Column Group"
     :clog-type      clog:clog-table-column-group
     :create         clog:create-table-column-group
     :create-type    :base
     :properties     ((:name "span"
		       :attr "span")
		      ,@*props-base*))
   `(:name           "tcol"
     :description    "Table Column Group Item"
     :clog-type      clog:clog-table-column-group-item
     :create         clog:create-table-column-group-item
     :create-type    :base
     :create-content "Column Group Item"
     :properties     ((:name "span"
		       :attr "span")
		      ,@*props-base*))
   `(:name           "thead"
     :description    "Table Head"
     :clog-type      clog:clog-table-head
     :create         clog:create-table-head
     :create-type    :base
     :properties     (,@*props-base*))
   `(:name           "tbody"
     :description    "Table Body"
     :clog-type      clog:clog-table-body
     :create         clog:create-table-body
     :create-type    :base
     :properties     (,@*props-base*))
   `(:name           "tfoot"
     :description    "Table Footer"
     :clog-type      clog:clog-table-footer
     :create         clog:create-table-footer
     :create-type    :base
     :properties     (,@*props-base*))
   `(:name           "tcaption"
     :description    "Table Caption"
     :clog-type      clog:clog-table-caption
     :create         clog:create-table-caption
     :create-type    :element
     :create-content "Caption"
     :properties     ((:name "caption side"
		       :style "caption-side")
		      ,@*props-element*))
   `(:name           "form"
     :description    "Form"
     :clog-type      clog:clog-form
     :create         clog:create-form
     :create-type    :base
     :properties     ((:name "method"
		       :attr "method")
		      (:name "encoding"
		       :prop "encoding")
		      (:name "form element count"
		       :get ,(lambda (control) (form-element-count control)))))
   `(:name           "input"
     :description    "Form Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :text
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "fbutton"
     :description    "Form Button"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :button
     :create-value   "Button"
     :properties     (,@*props-form-element*))
   `(:name           "reset"
     :description    "Form Reset"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :reset
     :create-value   "Reset"
     :properties     (,@*props-form-element*))
   `(:name           "submit"
     :description    "Form Submit"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :submit
     :create-value   "Submit"
     :properties     (,@*props-form-element*))
   `(:name           "checkbox"
     :description    "Form Checkbox"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :checkbox
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "radio"
     :description    "Form Radio Button"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :radio
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "color"
     :description    "Form Color Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :color
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "date"
     :description    "Form Date Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :date
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "datetime"
     :description    "Form Datetime Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :datetime
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "datetime-local"
     :description    "Form Datetime Local Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :datetime-local
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "email"
     :description    "Form Email Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :email
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "file"
     :description    "Form File Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :file
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "hidden"
     :description    "Form Hidden Value"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :hidden
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "fimage"
     :description    "Form Image Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :image
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "month"
     :description    "Form Month and Year Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :month
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "number"
     :description    "Form Number Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :number
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "password"
     :description    "Form Password Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :password
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "range"
     :description    "Form Range Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :range
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "search"
     :description    "Form Search Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :search
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "tel"
     :description    "Form Tel Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :tel
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "time"
     :description    "Form Time Picker"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :time
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "url"
     :description    "Form URL Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :url
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "week"
     :description    "Form Week Input"
     :clog-type      clog:clog-form-element
     :create         clog:create-form-element
     :create-type    :form
     :create-param   :week
     :create-value   ""
     :properties     (,@*props-form-element*))
   `(:name           "audio"
     :description    "Audio Player"
     :clog-type      clog:clog-audio
     :create         clog:create-audio
     :create-type    :base
     :properties     ((:name "media url"
		       :prop "src")
		      (:name "volume"
		       :prop "volume")
		      (:name "controls"
		       :attr "controls")
		      (:name "preload"
		       :attr "preload")
		      (:name "autoplay"
		       :attr "autoplay")
		      (:name "muted"
		       :prop "muted")
		      (:name "loop"
		       :prop "loop")
		      ,@*props-base*))
   `(:name           "video"
     :description    "Video Player"
     :clog-type      clog:clog-video
     :create         clog:create-video
     :create-type    :base
     :properties     ((:name "media url"
		       :prop "src")
		      (:name "volume"
		       :prop "volume")
		      (:name "controls"
		       :attr "controls")
		      (:name "preload"
		       :attr "preload")
		      (:name "autoplay"
		       :attr "autoplay")
		      (:name "muted"
		       :prop "muted")
		      (:name "loop"
		       :prop "loop")
		      ,@*props-base*))
   `(:name           "canvas"
     :description    "Canvas"
     :clog-type      clog:clog-canvas
     :create         clog:create-canvas
     :create-type    :base
     :properties     (,@*props-base*))
   `(:name           "style-block"
     :description    "Style"
     :clog-type      clog:clog-style-block
     :create         clog:create-style-block
     :create-type    :base
     :properties     ((:name "media"
		       :attr "media")
		      (:name "type"
		       :prop "type")
		      ,@*props-text*))))
