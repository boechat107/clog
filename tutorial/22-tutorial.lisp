(defpackage #:clog-user
  (:use #:cl #:clog)
  (:export start-tutorial))

(in-package :clog-user)

(defun on-file-count (body)
  ;; Clog-gui has two mode for handling moving and resizing clog-gui-windows.
  ;; The client-movement mode (as set here) specifies to jQuery-UI to manipulate
  ;; the window. This mode works well for website as the movement logic is done
  ;; on the client side. The on-file-drawing window uses the lisp based logic
  ;; and :client-movement is set to nil. This mode offers numerous events
  ;; for fine control and is best for local applications although will be a bit
  ;; more choppy cross continent or via satellite.
  (let ((win (create-gui-window body :title "Count" :client-movement t)))
    (dotimes (n 100)
      ;; window-content is the root element for the clog-gui
      ;; windows
      (create-div (window-content win) :content n))))

(defun on-file-browse (body)
  (let* ((win (create-gui-window body :title "Browse" :client-movement t))
	 (browser (create-child (window-content win)
	    "<iframe width=100% height=98% src='https://common-lisp.net/'></iframe>")))))

(defun on-file-drawing (body)
  (let* ((win (create-gui-window body :title "Drawing" :client-movement t))
	 (canvas (create-canvas (window-content win) :width 600 :height 400))
	 (cx     (create-context2d canvas)))
    (set-border canvas :thin :solid :black)    
    (fill-style cx :green)
    (fill-rect cx 10 10 150 100)
    (fill-style cx :blue)
    (font-style cx "bold 24px serif")
    (fill-text cx "Hello World" 10 150)
    (fill-style cx :red)
    (begin-path cx)
    (ellipse cx 200 200 50 7 0.78 0 6.29)
    (path-stroke cx)
    (path-fill cx)))

(defun on-file-movies (body)
  (let ((win (create-gui-window body :title "Movie" :client-movement t)))
    (create-video (window-content win) :source "https://www.w3schools.com/html/mov_bbb.mp4")))

(defun on-help-about (body)
  (let* ((about (create-gui-window body
				   :title   "About"
				   :content "<div class='w3-black'>
                                         <center><img src='/img/clogwicon.png'></center>
	                                 <center>CLOG</center>
	                                 <center>The Common Lisp Omnificent GUI</center></div>
			                 <div><p><center>Tutorial 22</center>
                                         <center>(c) 2021 - David Botton</center></p></div>"
				   :width   200
				   :height  200)))
    (set-on-window-can-size about (lambda (obj)
				    (declare (ignore obj))()))))

(defun on-new-window (body)
  (setf (title (html-document body)) "Tutorial 22")  
  (clog-gui-initialize body)
  (add-class body "w3-cyan")  
  (let* ((menu  (create-gui-menu-bar body))
	 (tmp   (create-gui-menu-icon menu :on-click #'on-help-about))
	 (file  (create-gui-menu-drop-down menu :content "File"))
	 (tmp   (create-gui-menu-item file :content "Count" :on-click #'on-file-count))
	 (tmp   (create-gui-menu-item file :content "Browse" :on-click #'on-file-browse))
	 (tmp   (create-gui-menu-item file :content "Drawing" :on-click #'on-file-drawing))
	 (tmp   (create-gui-menu-item file :content "Movie" :on-click #'on-file-movies))
	 (win   (create-gui-menu-drop-down menu :content "Window"))
	 (tmp   (create-gui-menu-window-select win))
	 (help  (create-gui-menu-drop-down menu :content "Help"))
	 (tmp   (create-gui-menu-item help :content "About" :on-click #'on-help-about))
	 (tmp   (create-gui-menu-full-screen menu))))

  (run body))

(defun start-tutorial ()
  "Start turtorial."
  (initialize #'on-new-window)
  (open-browser))
