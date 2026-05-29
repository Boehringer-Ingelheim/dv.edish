# the app displays the correct plot data after selections (snapshot test)__spec_ids{plot_specs$data}

    Code
      app_vals
    Output
      $input
      $input$`edish-arm_id`
      [1] "arm1" "arm2"
      
      $input$`edish-base_incl`
      [1] "ALL"
      
      $input$`edish-by_visit`
      [1] TRUE
      
      $input$`edish-plot_options`
      [1] 0
      attr(,"class")
      [1] "shinyActionButtonValue" "integer"               
      
      $input$`edish-plot_options_dropmenu`
      [1] FALSE
      
      $input$`edish-plot_type`
      [1] "Baseline"
      
      $input$`edish-uln_multiple`
      [1] NA
      
      $input$`edish-window_days`
      [1] 10
      
      $input$`edish-x_abs`
      [1] FALSE
      
      $input$`edish-x_axis`
      [1] "ast"
      
      $input$`edish-x_options`
      [1] 0
      attr(,"class")
      [1] "shinyActionButtonValue" "integer"               
      
      $input$`edish-x_options_dropmenu`
      [1] FALSE
      
      $input$`edish-x_ref`
      [1] NA
      
      $input$`edish-x_rng`
      NULL
      
      $input$`edish-y_abs`
      [1] FALSE
      
      $input$`edish-y_axis`
      [1] "tbili"
      
      $input$`edish-y_options`
      [1] 0
      attr(,"class")
      [1] "shinyActionButtonValue" "integer"               
      
      $input$`edish-y_options_dropmenu`
      [1] FALSE
      
      $input$`edish-y_ref`
      [1] NA
      
      $input$`edish-y_rng`
      NULL
      
      
      $output
      $output$`edish-plot`
      {"x":{"html":"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='ggiraph-svg' role='graphics-document' id='svg_CONST' viewBox='0 0 576 383.76'>
       <defs id='svg_CONST'>
        <clipPath id='svg_CONST'>
         <rect x='0' y='0' width='576' height='383.76'/>
        <\/clipPath>
        <clipPath id='svg_CONST'>
         <rect x='28.8' y='4.48' width='486.65' height='354.02'/>
        <\/clipPath>
       <\/defs>
       <g id='svg_CONST' class='ggiraph-svg-rootg'>
        <g clip-path='url(#svg_CONST)'>
         <rect x='0' y='0' width='576' height='383.76' fill='#FFFFFF' fill-opacity='1' stroke='#FFFFFF' stroke-opacity='1' stroke-width='0.75' stroke-linejoin='round' stroke-linecap='round' class='ggiraph-svg-bg'/>
        <\/g>
        <g clip-path='url(#svg_CONST)'>
         <polyline points='28.80,352.60 515.46,352.60' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='28.80,309.53 515.46,309.53' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='28.80,271.54 515.46,271.54' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='28.80,237.55 515.46,237.55' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='28.80,13.97 515.46,13.97' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='243.89,358.51 243.89,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='301.81,358.51 301.81,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='335.69,358.51 335.69,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='359.73,358.51 359.73,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='378.38,358.51 378.38,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='393.62,358.51 393.62,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='406.50,358.51 406.50,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='417.66,358.51 417.66,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='427.50,358.51 427.50,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='436.30,358.51 436.30,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline points='494.22,358.51 494.22,4.48' fill='none' stroke='#EBEBEB' stroke-opacity='1' stroke-width='0.87' stroke-linejoin='round' stroke-linecap='butt'/>
         <polyline id='svg_CONST' points='493.33,124.55 335.88,20.58' fill='none' stroke='#F8766D' stroke-opacity='0.3' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt' data-id='01'/>
         <polyline id='svg_CONST' points='394.22,269.26 50.92,342.41' fill='none' stroke='#00BFC4' stroke-opacity='0.3' stroke-width='1.07' stroke-linejoin='round' stroke-linecap='butt' data-id='02'/>
         <circle id='svg_CONST' cx='493.33' cy='124.55' r='1.6pt' fill='#F8766D' fill-opacity='0.8' stroke='#F8766D' stroke-opacity='0.8' title='&amp;lt;div style=&amp;#39;background-color:#F8766D; color:white; border:1px solid white; padding:2px;&amp;#39;&amp;gt;Subject: 01&amp;lt;br&amp;gt;Arm: arm1&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;ast (× Baseline): 1.979&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 2&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-02-14 (1st)&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;ALP/Baseline ≤ 2 (0.146)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;tbili (× Baseline): 1.420&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 2&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-02-14 (2nd)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;Time between peaks: 0 days&amp;lt;/div&amp;gt;' data-id='01'/>
         <circle id='svg_CONST' cx='335.88' cy='20.58' r='1.6pt' fill='#F8766D' fill-opacity='0.8' stroke='#F8766D' stroke-opacity='0.8' title='&amp;lt;div style=&amp;#39;background-color:#F8766D; color:white; border:1px solid white; padding:2px;&amp;#39;&amp;gt;Subject: 01&amp;lt;br&amp;gt;Arm: arm1&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;ast (× Baseline): 0.301&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 3&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-03-04 (1st)&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;ALP/Baseline ≤ 2 (0.300)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;tbili (× Baseline): 1.959&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 3&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-03-04 (2nd)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;Time between peaks: 0 days&amp;lt;/div&amp;gt;' data-id='01'/>
         <circle id='svg_CONST' cx='394.22' cy='269.26' r='1.6pt' fill='#00BFC4' fill-opacity='0.8' stroke='#00BFC4' stroke-opacity='0.8' title='&amp;lt;div style=&amp;#39;background-color:#00BFC4; color:white; border:1px solid white; padding:2px;&amp;#39;&amp;gt;Subject: 02&amp;lt;br&amp;gt;Arm: arm2&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;ast (× Baseline): 0.604&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 2&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-02-14 (1st)&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;ALP/Baseline ≤ 2 (0.364)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;tbili (× Baseline): 0.906&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 2&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-02-14 (2nd)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;Time between peaks: 0 days&amp;lt;/div&amp;gt;' data-id='02'/>
         <circle id='svg_CONST' cx='50.92' cy='342.41' r='1.6pt' fill='#00BFC4' fill-opacity='0.8' stroke='#00BFC4' stroke-opacity='0.8' title='&amp;lt;div style=&amp;#39;background-color:#00BFC4; color:white; border:1px solid white; padding:2px;&amp;#39;&amp;gt;Subject: 02&amp;lt;br&amp;gt;Arm: arm2&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;ast (× Baseline): 0.010&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 3&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-03-04 (1st)&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;ALP/Baseline ≤ 2 (0.359)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;tbili (× Baseline): 0.722&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Visit: visit 3&amp;lt;br&amp;gt;&amp;amp;nbsp;&amp;amp;nbsp;Date: 2025-03-04 (2nd)&amp;lt;br&amp;gt;---&amp;lt;br&amp;gt;Time between peaks: 0 days&amp;lt;/div&amp;gt;' data-id='02'/>
        <\/g>
        <g clip-path='url(#svg_CONST)'>
         <text x='14.78' y='355.08' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.7<\/text>
         <text x='14.78' y='312' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.8<\/text>
         <text x='14.78' y='274.01' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.9<\/text>
         <text x='20.77' y='240.02' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>1<\/text>
         <text x='20.77' y='16.44' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>2<\/text>
         <text x='238.9' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.1<\/text>
         <text x='296.82' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.2<\/text>
         <text x='330.7' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.3<\/text>
         <text x='354.74' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.4<\/text>
         <text x='373.39' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.5<\/text>
         <text x='388.62' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.6<\/text>
         <text x='401.5' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.7<\/text>
         <text x='412.66' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.8<\/text>
         <text x='422.5' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>0.9<\/text>
         <text x='434.3' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>1<\/text>
         <text x='492.23' y='367.49' font-size='5.4pt' font-family='Liberation Sans' fill='#4D4D4D' fill-opacity='1'>2<\/text>
         <text x='240.74' y='377.41' font-size='6.75pt' font-family='Liberation Sans'>ast (× Baseline)<\/text>
         <text transform='translate(10.68,213.63) rotate(-90.00)' font-size='6.75pt' font-family='Liberation Sans'>tbili (× Baseline)<\/text>
         <circle cx='537.54' cy='179.12' r='1.6pt' fill='#F8766D' fill-opacity='0.8' stroke='#F8766D' stroke-opacity='0.8'/>
         <circle cx='537.54' cy='196.4' r='1.6pt' fill='#00BFC4' fill-opacity='0.8' stroke='#00BFC4' stroke-opacity='0.8'/>
         <text x='550.67' y='181.6' font-size='5.4pt' font-family='Liberation Sans'>arm1<\/text>
         <text x='550.67' y='198.88' font-size='5.4pt' font-family='Liberation Sans'>arm2<\/text>
        <\/g>
       <\/g>
      <\/svg>","js":null,"uid":"svg_CONST","ratio":1.50093808630394,"settings":{"tooltip":{"css":".tooltip_SVGID_ { border:none; padding:0px; ; position:absolute;pointer-events:none;z-index:999;}","placement":"doc","opacity":0.9,"offx":10,"offy":0,"use_cursor_pos":true,"use_fill":false,"use_stroke":false,"delay_over":200,"delay_out":500},"hover":{"css":".hover_data_SVGID_ { stroke: blue; stroke-width: 1px; fill-opacity: 0.8; }","reactive":false,"nearest_distance":null},"hover_inv":{"css":""},"hover_key":{"css":".hover_key_SVGID_ { fill:orange;stroke:black;cursor:pointer; }
      text.hover_key_SVGID_ { stroke:none;fill:orange; }
      circle.hover_key_SVGID_ { fill:orange;stroke:black; }
      line.hover_key_SVGID_, polyline.hover_key_SVGID_ { fill:none;stroke:orange; }
      rect.hover_key_SVGID_, polygon.hover_key_SVGID_, path.hover_key_SVGID_ { fill:orange;stroke:none; }
      image.hover_key_SVGID_ { stroke:orange; }","reactive":true},"hover_theme":{"css":".hover_theme_SVGID_ { fill:orange;stroke:black;cursor:pointer; }
      text.hover_theme_SVGID_ { stroke:none;fill:orange; }
      circle.hover_theme_SVGID_ { fill:orange;stroke:black; }
      line.hover_theme_SVGID_, polyline.hover_theme_SVGID_ { fill:none;stroke:orange; }
      rect.hover_theme_SVGID_, polygon.hover_theme_SVGID_, path.hover_theme_SVGID_ { fill:orange;stroke:none; }
      image.hover_theme_SVGID_ { stroke:orange; }","reactive":true},"select":{"css":".select_data_SVGID_ { stroke: black; stroke-width: 1px; }","type":"single","only_shiny":true,"selected":[]},"select_inv":{"css":""},"select_key":{"css":".select_key_SVGID_ { fill:red;stroke:black;cursor:pointer; }
      text.select_key_SVGID_ { stroke:none;fill:red; }
      circle.select_key_SVGID_ { fill:red;stroke:black; }
      line.select_key_SVGID_, polyline.select_key_SVGID_ { fill:none;stroke:red; }
      rect.select_key_SVGID_, polygon.select_key_SVGID_, path.select_key_SVGID_ { fill:red;stroke:none; }
      image.select_key_SVGID_ { stroke:red; }","type":"single","only_shiny":true,"selected":[]},"select_theme":{"css":".select_theme_SVGID_ { fill:red;stroke:black;cursor:pointer; }
      text.select_theme_SVGID_ { stroke:none;fill:red; }
      circle.select_theme_SVGID_ { fill:red;stroke:black; }
      line.select_theme_SVGID_, polyline.select_theme_SVGID_ { fill:none;stroke:red; }
      rect.select_theme_SVGID_, polygon.select_theme_SVGID_, path.select_theme_SVGID_ { fill:red;stroke:none; }
      image.select_theme_SVGID_ { stroke:red; }","type":"single","only_shiny":true,"selected":[]},"zoom":{"min":1,"max":5,"duration":300,"default_on":false},"toolbar":{"position":"topright","pngname":"diagram","tooltips":null,"fixed":false,"hidden":[],"delay_over":200,"delay_out":500},"sizing":{"rescale":true,"width":1}}},"evals":[],"jsHooks":[],"deps":[]} 
      
      

