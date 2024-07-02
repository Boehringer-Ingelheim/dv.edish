# the app displays the correct plot at app launch (snapshot test)__spec_ids{plot_specs$data}

    Code
      app$get_values(input = TRUE, output = TRUE)
    Output
      $input
      $input$`.clientValue-default-plotlyCrosstalkOpts`
      $input$`.clientValue-default-plotlyCrosstalkOpts`$on
      [1] "plotly_click"
      
      $input$`.clientValue-default-plotlyCrosstalkOpts`$persistent
      [1] FALSE
      
      $input$`.clientValue-default-plotlyCrosstalkOpts`$dynamic
      [1] FALSE
      
      $input$`.clientValue-default-plotlyCrosstalkOpts`$selectize
      [1] FALSE
      
      $input$`.clientValue-default-plotlyCrosstalkOpts`$opacityDim
      [1] 0.2
      
      $input$`.clientValue-default-plotlyCrosstalkOpts`$selected
      $input$`.clientValue-default-plotlyCrosstalkOpts`$selected$opacity
      [1] 1
      
      
      $input$`.clientValue-default-plotlyCrosstalkOpts`$debounce
      [1] 0
      
      $input$`.clientValue-default-plotlyCrosstalkOpts`$color
      list()
      
      
      $input$`edish-arm_id`
      [1] "arm1"
      
      $input$`edish-x_axis`
      [1] "test 1"
      
      $input$`edish-x_plot_type`
      [1] "x ULN (eDISH)"
      
      $input$`edish-x_ref`
      [1] 3
      
      $input$`edish-y_axis`
      [1] "test 2"
      
      $input$`edish-y_plot_type`
      [1] "x ULN (eDISH)"
      
      $input$`edish-y_ref`
      [1] 2
      
      $input$`plotly_afterplot-A`
      [1] "\"edish-plot\""
      
      
      $output
      $output$`edish-noplot`
      $output$`edish-noplot`$src
      [1] "data:image/png;base64,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"
      
      $output$`edish-noplot`$width
      [1] 631.3281
      
      $output$`edish-noplot`$height
      [1] 400
      
      $output$`edish-noplot`$alt
      [1] "Plot object"
      
      $output$`edish-noplot`$coordmap
      $output$`edish-noplot`$coordmap$panels
      $output$`edish-noplot`$coordmap$panels[[1]]
      $output$`edish-noplot`$coordmap$panels[[1]]$domain
      $output$`edish-noplot`$coordmap$panels[[1]]$domain$left
      [1] -0.04
      
      $output$`edish-noplot`$coordmap$panels[[1]]$domain$right
      [1] 1.04
      
      $output$`edish-noplot`$coordmap$panels[[1]]$domain$bottom
      [1] -0.04
      
      $output$`edish-noplot`$coordmap$panels[[1]]$domain$top
      [1] 1.04
      
      
      $output$`edish-noplot`$coordmap$panels[[1]]$range
      $output$`edish-noplot`$coordmap$panels[[1]]$range$left
      [1] 0
      
      $output$`edish-noplot`$coordmap$panels[[1]]$range$right
      [1] 631.3281
      
      $output$`edish-noplot`$coordmap$panels[[1]]$range$bottom
      [1] 399
      
      $output$`edish-noplot`$coordmap$panels[[1]]$range$top
      [1] -1
      
      
      $output$`edish-noplot`$coordmap$panels[[1]]$log
      $output$`edish-noplot`$coordmap$panels[[1]]$log$x
      NULL
      
      $output$`edish-noplot`$coordmap$panels[[1]]$log$y
      NULL
      
      
      $output$`edish-noplot`$coordmap$panels[[1]]$mapping
      named list()
      
      
      
      $output$`edish-noplot`$coordmap$dims
      $output$`edish-noplot`$coordmap$dims$width
      [1] 631.3281
      
      $output$`edish-noplot`$coordmap$dims$height
      [1] 400
      
      
      
      
      $output$`edish-plot`
      {"x":{"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"test 1/ULN"},"yaxis":{"domain":[0,1],"automargin":true,"title":"test 2/ULN"},"shapes":[{"type":"line","y0":0,"y1":1,"yref":"paper","x0":3,"x1":3,"line":{"color":"gray","dash":"dot"}},{"type":"line","x0":0,"x1":1,"xref":"paper","y0":2,"y1":2,"line":{"color":"gray","dash":"dot"}}],"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"mode":"markers","type":"scatter","name":"arm1","marker":{"color":"rgba(252,141,98,1)","line":{"color":"rgba(252,141,98,1)"}},"textfont":{"color":"rgba(252,141,98,1)"},"error_y":{"color":"rgba(252,141,98,1)"},"error_x":{"color":"rgba(252,141,98,1)"},"line":{"color":"rgba(252,141,98,1)"},"xaxis":"x","yaxis":"y","frame":null},{"mode":"markers","type":"scatter","x":[0.34734910411925335,0.54197535764588034,0.29432554882307305],"y":[0.74028746015250968,0.82460470462819024,0.03048746625449824],"hovertext":["Subject: 01<br>Arm: arm1<br>Visit: visit 1<br>x-axis: 0.347<br>y-axis: 0.74","Subject: 01<br>Arm: arm1<br>Visit: visit 2<br>x-axis: 0.542<br>y-axis: 0.825","Subject: 01<br>Arm: arm1<br>Visit: visit 3<br>x-axis: 0.294<br>y-axis: 0.03"],"hoverinfo":["text","text","text"],"name":"arm1","marker":{"color":"rgba(252,141,98,1)","line":{"color":"rgba(252,141,98,1)"}},"textfont":{"color":"rgba(252,141,98,1)"},"error_y":{"color":"rgba(252,141,98,1)"},"error_x":{"color":"rgba(252,141,98,1)"},"line":{"color":"rgba(252,141,98,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[],"deps":[{"name":"setprototypeof","version":"0.1","src":{"href":"setprototypeof-0.1"},"meta":null,"script":"setprototypeof.js","stylesheet":null,"head":null,"attachment":null,"all_files":false},{"name":"typedarray","version":"0.1","src":{"href":"typedarray-0.1"},"meta":null,"script":"typedarray.min.js","stylesheet":null,"head":null,"attachment":null,"all_files":false},{"name":"jquery","version":"3.5.1","src":{"href":"jquery-3.5.1"},"meta":null,"script":"jquery.min.js","stylesheet":null,"head":null,"attachment":null,"all_files":true},{"name":"crosstalk","version":"1.2.0","src":{"href":"crosstalk-1.2.0"},"meta":null,"script":"js/crosstalk.min.js","stylesheet":"css/crosstalk.min.css","head":null,"attachment":null,"all_files":true},{"name":"plotly-htmlwidgets-css","version":"2.11.1","src":{"href":"plotly-htmlwidgets-css-2.11.1"},"meta":null,"script":null,"stylesheet":"plotly-htmlwidgets.css","head":null,"attachment":null,"all_files":false},{"name":"plotly-main","version":"2.11.1","src":{"href":"plotly-main-2.11.1"},"meta":null,"script":"plotly-latest.min.js","stylesheet":null,"head":null,"attachment":null,"all_files":false}]} 
      
      

