; [it is an example of a template for the rss2fido]
; In line template to use no more than 80 characters
;
              
 @description,1,[78]

 Date: @pubDate,0,[78]
 Link: @link,0,[50]...

; Description about the format template
; Is any tags, for example: <title> </title>,
; conversion macros
; each macro have to be at @
; thus you specify that the value, rather than the text
; Format: [value],[formatting (0,1,2)],[[length]]:[url_format]
; Formatting text:
; 0) Write only one line
; example: @description,0,[75]:0...
; result: 
; 
; All day in my head got anything thought, well that by the evening of...
;
; 1) Move the text on the words
; example: @description,1,[75]:0
; result: 
;
; All day in my head got anything thought, well that by the evening of
; moving the ropes. S., yes you psychologist, Pasiba! :)
; 
; 2) Just to transfer to another line
; example: @description,2,[75]:0
; result: 
;
; All day in my head got anything thought, well that by the evening of mo
; ving the ropes. S., yes you psychologist, Pasiba! :)
; 
;
; ---------------------------
; And finally, what exactly is url_format?
; Who could have three different meanings:
; 1) example: @description,1,[79]:0
; (without the hyperlinks)
;-------------------------------------------------------------
;   Secret scientist :))
;
;
;
;  There is all the fun..                                        
;
;
;
;  Even popalu ready its work.. :))
;-------------------------------------------------------------
; 2) example: @description,1,[79]:1
; (with hyperlinks in the text)
;-------------------------------------------------------------
;   Secret scientist :))                                                         
;
;  [http://img299.imageshack.us/img299/2748/dsc00004ou3.jpg]                    
;
;  There is all the fun..                                        
;
;  [http://img299.imageshack.us/img299/6639/dsc00008mu7.jpg]                    
;
;  Even popalu ready its work.. :))                                           
;
;  [http://img391.imageshack.us/img391/3210/dsc00007zs2.jpg]                    
;-------------------------------------------------------------
; 3) example: @description,1,[79]:2
; (with hyperlinks in end the text)
;-------------------------------------------------------------
;  Secret scientist :))                                                         
;
;  [1]                                                                          
;
;  There is all the fun..                                        
;
;  [2]                                                                          
;
;  Even popalu ready its work.. :))                                           
;
;  [3]                                                                          
;
;  [1]: http://img299.imageshack.us/img299/2748/dsc00004ou3.jpg
;       ( Secret scientist)
;  [2]: http://img299.imageshack.us/img299/6639/dsc00008mu7.jpg
;       (The same bunker)
;  [3]: http://img391.imageshack.us/img391/3210/dsc00007zs2.jpg
;       (Even popalu ready its work)
;-------------------------------------------------------------
;
;