IDEAL

MODEL small

MACRO NewLine
	push dx
	push ax
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
	pop ax
	pop dx
ENDM

STACK 256

;consts
PSIZE = 35
BMP_WIDTH = 320
BMP_HEIGHT = 200
BG_NAME_IN  equ 'BG.bmp'
REDP_NAME_IN equ 'RedP.bmp'
BLUEP_NAME_IN equ 'BlueP.bmp'
BALL_NAME_IN equ 'Ball.bmp'

DATASEG
;BMP Vars
BmpLeft dw 0
BmpTop dw 0
BmpColSize dw 0
BmpRowSize dw 0
OneBmpLine db BMP_WIDTH dup (0)  ; One Color line read buffer   
ScrLine db BMP_WIDTH dup (0)  ; One Color line read buffer
Header db 54 dup(0)
Palette db 400h dup (0)

BG_Name db BG_NAME_IN,0
BlueP_Name db BLUEP_NAME_IN,0
RedP_Name db REDP_NAME_IN,0
Ball_Name db BALL_NAME_IN,0

;game vars
BlueX dw 75
BlueY dw 75
RedX dw 200
RedY dw 75

c = 0ffh
BALL_SIZE  = 12  
Ball db 0,0,0,0,c,c,c,c,0,0,0,0
	 db 0,c,c,c,c,c,c,c,c,c,0,0
	 db 0,c,c,c,c,c,c,c,c,c,c,0
	 db c,c,c,c,c,c,c,c,c,c,c,c
	 db c,c,c,c,c,c,c,c,c,c,c,c
	 db c,c,c,c,c,c,c,c,c,c,c,c
	 db c,c,c,c,c,c,c,c,c,c,c,c
	 db c,c,c,c,c,c,c,c,c,c,c,c
	 db 0,c,c,c,c,c,c,c,c,c,c,0
	 db 0,c,c,c,c,c,c,c,c,c,c,0
	 db 0,0,c,c,c,c,c,c,c,c,0,0
	 db 0,0,0,0,c,c,c,c,0,0,0,0
	
	BallD db -1
	XBall dw ?
	YBall dw ?

;Arr to keep the blue BG
RedBG  db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0) 	
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)

;Arr to keep the blue BG
BlueBG db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)
	   db 35 dup (0)


;file vars
FileName db 'Scores.txt',0
NamesMSG1 db 'Write Player1 3 Letters Nickname:',13,10,'$'
NamesMSG2 db 'Write Player2 3 Letters Nickname:',13,10,'$'

P1 db '4XXXXX' 
P2 db '4XXXXX'

;next 5 vars will be the sum of the game in the file abc(tP1)-def(tP2) Score: 6(S1)-3(S2) CRLF  
tP1 db 4 dup (?)
tP2 db 4 dup (?)
scr db 'Score: '
S1 db 0,'-'
S2 db 0,13,10

FileHandle dw ?
FileData db 20 dup (?)

RndCurrentPos dw start

cnt dw 0
Line dw -1
Time db 180
EndGame db 0 ;bool for game live or done

counter db 6
lcnt dw 0

tens db ?
ones db ?
CODESEG
    
start:
	 mov ax, @data
	 mov ds,ax

	 ;tell to write first nickname
	 mov dx,offset NamesMSG1
	 mov ah,9
	 int 21h
	 
	 ;read first nickname and put in P1
	 mov ah,0ah
	 mov dx,offset P1
	 int 21h
	 ;move the 3 letters to new arr that will save the name and '-' to put between the 2 names
	 mov al,[P1+2]
	 mov [tP1],al
	 mov al,[P1+3]
	 mov [tP1+1],al
	 mov al,[P1+4]
	 mov [tP1+2],al
	 mov [tP1+3],'-'
	 
	 
	 NewLine
	 
	 ;tell to write second nickname
	 mov dx,offset NamesMSG2
	 mov ah,9
	 int 21h
	 
	 ;read second nickname and put in P2
	 mov ah,0ah
	 mov dx,offset P2
	 int 21h
	 mov al,[P2+2]
	 mov [tP2],al
	 mov al,[P2+3]
	 mov [tP2+1],al
	 mov al,[P2+4]
	 mov [tP2+2],al
	 mov [tP2+3],' '
	 
	 call SetGraphic
	 
	 ;put the background
	 mov dx, offset BG_Name
	 mov [BmpLeft],0
	 mov [BmpTop],0
	 mov [BmpColSize], 320
	 mov [BmpRowSize] ,200
	 call OpenShowBmp
	 
	 call SaveBBG
	 call SaveRBG
	 
	 ;put the red player                  ;Red top left :(200,75)
	 mov dx, offset RedP_Name
	 mov [BmpLeft],200
	 mov [BmpTop],75
	 mov [BmpColSize], PSIZE
	 mov [BmpRowSize] ,PSIZE
	 call OpenShowBmp
	 
	 ;put the blue player                 ;Blue top left :(75,75)
	 mov dx, offset BlueP_Name
	 mov [BmpLeft],75
	 mov [BmpTop],75
	 mov [BmpColSize], PSIZE
	 mov [BmpRowSize] ,PSIZE
	 call OpenShowBmp
	 
	 ;put the ball
	 mov [XBall],155
	 mov [YBall],90
	 call putBall

	 ;Put the starting scores (0-0) in the top corners
	 mov ah,2
	 mov bh,0
	 mov dh,0
	 mov dl,0
	 int 10h
	 mov dl,'0'
	 int 21h
	 mov dh,0
	 mov dl,39
	 int 10h
	 mov dl,'0'
	 int 21h
	 ;Game Starts
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@@MLoop:
	 ;make a modulo with the loop counter so the loop won't be too fast
	 inc [lcnt]
	 mov dx,0
	 mov ax,[lcnt]
	 mov bx,5000
	 div bx
	 cmp dx,0
	 jne @@MLoop
	 
	 ;check if a key was pressed
	 mov ah,1
	 int 16h
	 jz @@con
	 call ButtonPressed
@@con:
	 
	 call MoveBall
	 
	 call CheckHits
	 
	 call CheckGoal
	 
	 ;end the game if score is 9/game time is done/'esc' button was pressed
	 cmp [S1],9
	 je @@GameOver
	 cmp [S2],9
	 je @@GameOver
@@dect:
	 cmp [Time],0
	 je @@GameOver
	 ;check if a sec passed by doing two modulos with the game loop
	 cmp [counter],9
	 jne @@coonter
	 mov [counter],0
	 mov dx,0
	 mov ax,[lcnt]
	 mov bx,65535
	 div bx
	 cmp dx,0
	 jne @@check
	 call DecShowTime
	 jmp @@check
@@GameOver:
	 mov [EndGame],1
@@coonter:
	inc [counter]
@@check:
	 cmp [EndGame],1
	 jne @@MLoop
	 
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 ;Game Ends
	 
	 ;switch score to readable numbers in file
	 add [S1],30h
	 add [S2],30h
	 ;try to open scores file
	 mov ah,3dh
	 mov al,2 ; 2 is for read and write in the file
	 mov dx, offset FileName
	 int 21h
	 
	 jc @@create
	 mov [FileHandle],ax
	 jmp @@update
@@create:
	 call CreateFile
	 jmp closef
@@update:
	 call UpdateFile
	 
closef:

	 ;close the file after updating him
     mov ah,3eh
	 mov bx,[FileHandle]
	 int 21h
	 
	 ;go back to text mode
	 mov ax,3
	 int 10h
EXIT:
    
	mov ax, 4C00h ; returns control to dos
  	int 21h
	
	; put some data in Code segment in order to have enough bytes to xor with 
	SomeRNDData	    db 227	,111	,105	,1		,127
					db 234	,6		,117	,101	,220
					db 92	,60		,21		,228	,22
					db 220	,63		,216	,208	,146
					db 60	,182	,60		,80		,30
					db 23	,85		,67		,157	,131
					db 120	,111	,105	,49		,107
					db 148	,15		,141	,32		,225
					db 113	,163	,174	,23		,19
					db 143	,28		,234	,56		,74
					db 223	,88		,214	,122	,138
					db 100	,214	,161	,41		,230
					db 8	,93		,125	,132	,129
					db 175	,235	,228	,6		,226
					db 202	,223	,2		,6		,143
					db 8	,147	,214	,39		,88
					db 130	,253	,106	,153	,147
					db 73	,140	,251	,32		,59
					db 92	,224	,138	,118	,200
					db 244	,4		,45		,181	,62
;---------------------------
; Procudures area
;---------------------------
;---------------------------
;Description: Prints ax decimal value
;Input: ax
;Output: screen
;---------------------------
proc ShowAxDecimal
       push ax
       push bx
       push cx
       push dx

PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider

put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
       ; dl is the current LSB digit 
       ; we cant push only dl so we push all dx
       push dx
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

       cmp ax,0
       jz pop_next  ; jump if ax was totally 0
       add al,30h
       mov dl, al
         mov ah, 2h
       int 21h        ; show first digit MSB

pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
       mov dl, al
       mov ah, 2h
       int 21h        ; show all rest digits
       loop pop_next


       pop dx
       pop cx
       pop bx
       pop ax

       ret
endp ShowAxDecimal


;---------------------------
;Description: Decrease a second and prints the time
;Input: [Time]
;Output: Screen
;---------------------------
proc DecShowTime
	dec [Time]
	;set cursor position to the wanted place
	mov ah,2
	mov bh,0
	mov dh,0
	mov dl,18
	int 10h
	;find the time 
	mov ah,0
	mov al,[Time]
	mov bl,60
	div bl
	;print the minutes
	mov bl,ah
	mov ah,0
	call ShowAxDecimal
	;print : after the minutes
	mov dl,':'
	mov ah,2
	int 21h
	;put the tens in the var and the ones in the var
	mov ah,0
	mov al,bl
	mov bl,10
	div bl
	mov [tens],al
	mov [ones],ah
	;print the seconds
	mov ah,0
	mov al,[tens]
	call ShowAxDecimal
	mov ah,0
	mov al,[ones]
	call ShowAxDecimal
	
@@ret:
	ret
endp DecShowTime
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Take the 2 lines you move into, and put them in the bg array
;---------------------------
;Description: Saves in the BG array the 2 lines above the player 
;Input: [BlueX],[BlueY]
;Output: [BlueBG]
;---------------------------
proc Blue2Up
	mov ah,0Dh
	mov bx,0
	mov dx,[BlueY]
	sub dx,2 ;2 lines above
	mov cx,[BlueX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[BlueX]
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [byte ptr BlueBG+bx],al 
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Blue2Up


;---------------------------
;Description: Saves in the BG array the 2 lines above the player 
;Input: [RedX],[RedY]
;Output: [RedBG]
;---------------------------
proc Red2Up
	mov ah,0Dh
	mov bx,0
	mov dx,[RedY]
	sub dx,2 ;2 lines above
	mov cx,[RedX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[RedX]
@@nextpixel:
	;al has the screen color at (cx,dx) after 0D,int 10h
	int 10h
	mov [byte ptr RedBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Red2Up


;---------------------------
;Description: Saves in the BG array the 2 lines on the player's left 
;Input: [BlueX],[BlueY]
;Output: [BlueBG]
;---------------------------
proc Blue2Left
	mov ah,0Dh
	mov bx,0
	mov dx,[BlueY]
	mov cx,[BlueX]
	sub cx,2 ;2 cols to the left
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[BlueX]
	sub cx,2
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [BlueBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Blue2Left


;---------------------------
;Description: Saves in the BG array the 2 lines on the player's left 
;Input: [RedX],[RedY]
;Output: [RedBG]
;---------------------------
proc Red2Left
	mov ah,0Dh
	mov bx,0
	mov dx,[RedY]
	mov cx,[RedX]
	sub cx,2 ;2 cols to the left
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[RedX]
	sub cx,2
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [RedBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Red2Left


;---------------------------
;Description: Saves in the BG array the 2 lines on the player's right 
;Input: [RedX],[RedY]
;Output: [RedBG]
;---------------------------
proc Red2Right
	mov ah,0Dh
	mov bx,33
	mov dx,[RedY]
	add cx,PSIZE
	mov cx,[RedX]
	sub cx,2
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[RedX]
	add cx,PSIZE
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [RedBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Red2Right


;---------------------------
;Description: Saves in the BG array the 2 lines on the player's right 
;Input: [BlueX],[BlueY]
;Output: [BlueBG]
;---------------------------
proc Blue2Right
	mov ah,0Dh
	mov bx,33
	mov dx,[BlueY]
	add cx,PSIZE
	mov cx,[BlueX]
	sub cx,2
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[BlueX]
	add cx,PSIZE
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [BlueBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Blue2Right


;---------------------------
;Description: Saves in the BG array the 2 lines below the player
;Input: [BlueX],[BlueY]
;Output: [BlueBG]
;---------------------------
proc Blue2Down
	mov ah,0Dh
	mov bx,PSIZE*PSIZE-PSIZE-PSIZE
	mov dx,[BlueY]
	add dx,PSIZE
	mov cx,[BlueX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[BlueX]
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [BlueBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Blue2Down


;---------------------------
;Description: Saves in the BG array the 2 lines below the player
;Input: [RedX],[RedY]
;Output: [RedBG]
;---------------------------
proc Red2Down
	mov ah,0Dh
	mov bx,PSIZE*PSIZE-PSIZE-PSIZE
	mov dx,[RedY]
	add dx,PSIZE
	mov cx,[RedX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[RedX]
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [RedBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp Red2Down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Put the 2 lines you moved from
;---------------------------
;Description: print 2 lines of the BG above the player
;Input: [BlueX], [BlueY], [BlueBG]
;Output: Screen
;---------------------------
proc PBlue2Up
	mov ah,0Ch
	mov bx,0
	mov dx,[BlueY]
	mov cx,[BlueX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[BlueX]
@@nextpixel:
	
	mov al,[BlueBG+bx]
	int 10h
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PBlue2Up

;---------------------------
;Description: print 2 lines of the BG above the player
;Input: [RedX], [RedY], [RedBG]
;Output: Screen
;---------------------------
proc PRed2Up
	mov ah,0Ch
	mov bx,0
	mov dx,[RedY]
	mov cx,[RedX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[RedX]
@@nextpixel:
	
	mov al,[RedBG+bx]
	int 10h
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PRed2Up


;---------------------------
;Description: print 2 lines of the BG on the players left
;Input: [BlueX], [BlueY], [BlueBG]
;Output: Screen
;---------------------------
proc PBlue2Left
	mov ah,0Ch
	mov bx,0
	mov dx,[BlueY]
	mov cx,[BlueX]
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[BlueX]
@@nextpixel:
	
	mov al,[BlueBG+bx]
	int 10h
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PBlue2Left


;---------------------------
;Description: print 2 lines of the BG on the players left
;Input: [RedX], [RedY], [RedBG]
;Output: Screen
;---------------------------
proc PRed2Left
	mov ah,0Ch
	mov bx,0
	mov dx,[RedY]
	mov cx,[RedX]
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[RedX]
@@nextpixel:
	
	mov al,[RedBG+bx]
	int 10h
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PRed2Left


;---------------------------
;Description: print 2 lines of the BG on the players right
;Input: [RedX], [RedY], [RedBG]
;Output: Screen
;---------------------------
proc PRed2Right
	mov ah,0Ch
	mov bx,33
	mov dx,[RedY]
	mov cx,[RedX]
	add cx,PSIZE
	sub cx,2
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[RedX]
	add cx,PSIZE
	sub cx,2
@@nextpixel:
	mov al,[RedBG+bx]
	int 10h
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PRed2Right


;---------------------------
;Description: print 2 lines of the BG on the players right
;Input: [BlueX], [BlueY], [BlueBG]
;Output: Screen
;---------------------------
proc PBlue2Right
	mov ah,0Ch
	mov bx,33
	mov dx,[BlueY]
	mov cx,[BlueX]
	add cx,PSIZE-2
	mov si,PSIZE
@@nextrow:
	mov di,2
	mov cx,[BlueX]
	add cx,PSIZE-2
@@nextpixel:
	mov al,[BlueBG+bx]
	int 10h
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	add bx,33
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PBlue2Right


;---------------------------
;Description: print 2 lines of the BG below the player
;Input: [RedX], [RedY], [RedBG]
;Output: Screen
;---------------------------
proc PRed2Down
	mov ah,0Ch
	mov bx,PSIZE*PSIZE-PSIZE-PSIZE
	mov dx,[RedY]
	add dx,PSIZE
	sub dx,2
	mov cx,[RedX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[RedX]
@@nextpixel:
	mov al,[RedBG+bx]
	int 10h
	
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PRed2Down


;---------------------------
;Description: print 2 lines of the BG below the player
;Input: [BlueX], [BlueY], [BlueBG]
;Output: Screen
;---------------------------
proc PBlue2Down
	mov ah,0Ch
	mov bx,PSIZE*PSIZE-PSIZE-PSIZE
	mov dx,[BlueY]
	;get to the down and go up by 2
	add dx,PSIZE
	sub dx,2
	mov cx,[BlueX]
	mov si,2
@@nextrow:
	mov di,PSIZE
	mov cx,[BlueX]
@@nextpixel:
	mov al,[BlueBG+bx]
	int 10h
	
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret

endp PBlue2Down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Shifts
;input: bx will be the offset to the array start
;---------------------------
;Description: shift left the BG arr
;Input: bx = BG offset
;Output: the BG arr
;---------------------------
proc SHLBG
	mov cx,PSIZE
@@nextrow:
	push bx
	push cx
	mov cx,PSIZE-2
@@nextpixel:
	;move [bx] to [bx-2]
	mov al,[bx+2]
	mov [bx],al
	inc bx
	loop @@nextpixel
	pop cx
	pop bx
	add bx,PSIZE
	loop @@nextrow
	ret
endp SHLBG


;---------------------------
;Description: shift right the BG arr
;Input: bx = BG offset
;Output: the BG arr
;---------------------------
proc SHRBG
	mov cx,PSIZE
@@nextrow:
	push bx
	push cx
	mov cx,PSIZE-2
	add bx,PSIZE
@@nextpixel:
	;at the start bx will be the offset of the last place in the BG array
	;move [bx-2] to [bx]
	dec bx
	mov al,[bx-2]
	mov [bx],al
	loop @@nextpixel
	pop cx
	pop bx
	add bx,PSIZE
	loop @@nextrow
	ret
endp SHRBG


;---------------------------
;Description: shift down the BG arr
;Input: bx = BG offset
;Output: the BG arr
;---------------------------
proc SHDBG
;PSIZE*2 is the 2nd row
	mov cx,PSIZE*PSIZE-PSIZE-PSIZE
	add bx,PSIZE*PSIZE
@@nextpixel:
	dec bx
	mov al,[bx-PSIZE*2]
	mov [byte ptr bx],al
	loop @@nextpixel
	ret
endp SHDBG

;---------------------------
;Description: shift up the BG arr
;Input: bx = BG offset
;Output: the BG arr
;---------------------------
proc SHUBG
	mov si,PSIZE*2
	mov cx,PSIZE*PSIZE
	sub cx,PSIZE*2
@@nextpixel:
	;mov [bx],[bx+PSIZE*2]
	mov al,[bx+si]
	mov [bx],al
	inc bx
	loop @@nextpixel
	ret
endp SHUBG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Save backgrounds procs
;---------------------------
;Description: Saves the BG at the start before putting the Blue player
;Input: [BlueX], [BlueY]
;Output: [BlueBG]
;---------------------------
proc SaveBBG
	mov ah,0Dh
	mov bx,0
	mov dx,[BlueY]
	mov cx,[BlueX]
	mov si,PSIZE
@@nextrow:
	mov di,PSIZE
	mov cx,[BlueX]
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [BlueBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret
endp SaveBBG


;---------------------------
;Description: Saves the BG at the start before putting the Red player
;Input: [RedX], [RedY]
;Output: [RedBG]
;---------------------------
proc SaveRBG
	mov ah,0Dh
	mov bx,0
	mov dx,[RedY]
	mov cx,[RedX]
	mov si,PSIZE
@@nextrow:
	mov di,PSIZE
	mov cx,[RedX]
@@nextpixel:
	int 10h
	;al has the screen color at (cx,dx) after 0D,int 10h
	mov [RedBG+bx],al
	inc bx
	inc cx ;next pixel
	dec di
	cmp di,0
	jne @@nextpixel
	
	inc dx ;next line

	dec si
	cmp si,0
	jne @@nextrow

	ret
endp SaveRBG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;---------------------------
;Description:;if hit the blue player random dirction for the side it hit
	         ;if hit the red player random dirction for the side it hit
	         ;if hit the wall get the other side dirction from
	         ;if hit the goal update score reset ball and move to ball direction -1
;Input: [XBall], [YBall], [RedY], [RedX], [BlueY], [BlueX]
;Output: [BallD]
;---------------------------
proc CheckHits
	
@@BlueCheck:
	;push Ball top left and low right x,y
	mov ax,[Xball]
	dec ax
	push ax
	mov ax,[Yball]
	dec ax
	push ax
	mov ax,[Xball]
	add ax,13
	push ax
	mov ax,[Yball]
	add ax,13
	push ax
	;push Blue top left and low right x,y
	push [BlueX]
	push [BlueY]
	mov ax,[BlueX]
	add ax,PSIZE
	push ax
	mov ax,[BlueY]
	add ax,PSIZE
	push ax
	call aabb
	cmp ax,1
	jne @@RedCheck
	;check if the ball hits the player from left or right
	mov dx,[XBall]
	add dx,12
	cmp dx,[BlueX]
	ja @@BlueRight
	;if left rnd direction on the left
	mov bl,5
	mov bh,7	 
	call RandomByCs
	mov [BallD],al
	jmp @@ret
	;if right rnd direction on the right
@@BlueRight:
	mov bl,1
	mov bh,3	 
	call RandomByCs
	mov [BallD],al
	jmp @@ret
	
@@RedCheck:
	;push Ball top left and low right x,y
	mov ax,[Xball]
	dec ax
	push ax
	mov ax,[Yball]
	dec ax
	push ax
	mov ax,[Xball]
	add ax,13
	push ax
	mov ax,[Yball]
	add ax,13
	push ax
	;push Red top left and low right x,y
	push [RedX]
	push [RedY]
	mov ax,[RedX]
	add ax,PSIZE
	push ax
	mov ax,[RedY]
	add ax,PSIZE
	push ax
	call aabb
	cmp ax,1
	jne @@WallsCheck
	;check if the ball hits the player from left or right
	mov dx,[RedX]
	add dx,17
	cmp dx,[XBall]
	jb @@RedRight
	;if left rnd direction on the left
	mov bl,5
	mov bh,7	 
	call RandomByCs
	mov [BallD],al
	jmp @@ret
	;if right rnd direction on the right
@@RedRight:
	mov bl,1
	mov bh,3	 
	call RandomByCs
	mov [BallD],al
	jmp @@ret
	
@@WallsCheck:
@@up:
	;Check if the ball hit the top
	;If yes change to the opposite direction (1-3,5-7)
	cmp [YBall],8
	ja @@down
	cmp [BallD],1
	jne @@3
	mov [BallD],3
	jmp @@ret
@@3:
	cmp [BallD],3
	jne @@5
	mov [BallD],1
	jmp @@ret
@@5:
	cmp [BallD],5
	jne @@7
	mov [BallD],7
	jmp @@ret
@@7:
	cmp [BallD],7
	jne @@down
	mov [BallD],5
	jmp @@ret
@@down:
	;Check if the ball hit the down
	;If yes change to the opposite direction (1-3,5-7)
	cmp [YBall],180 ;200-(12+8)
	jb @@leftU
	cmp [BallD],1
	jne @@3d
	mov [BallD],3
	jmp @@ret
@@3d:
	cmp [BallD],3
	jne @@5d
	mov [BallD],1
	jmp @@ret
@@5d:
	cmp [BallD],5
	jne @@7d
	mov [BallD],7
	jmp @@ret
@@7d:
	cmp [BallD],7
	jne @@leftU
	mov [BallD],5
	jmp @@ret
@@leftU:
	;Check if the ball hit the left wall
	;If yes change the direction to 2
	cmp [Xball],3
	ja @@RightU
	cmp [YBall],60
	ja @@leftD
	mov [BallD],2
	jmp @@ret
@@leftD:
	cmp [YBall],138
	jb @@RightU
	mov [BallD],2
@@RightU:
	;Check if the ball hit the right wall
	;If yes change the direction to 6
	cmp [Xball],304
	jb @@ret
	cmp [YBall],60
	ja @@RightD
	mov [BallD],6
	jmp @@ret
@@RightD:
	cmp [YBall],138
	jb @@ret
	mov [BallD],6
@@ret:
	ret
endp CheckHits


;---------------------------
;Description: checks if there was a goal
;Input: [XBall], [YBall]
;Output: [S1]/[S2]
;---------------------------
proc CheckGoal
	;Left goal position is between (3,60),(3,138)
	cmp [Yball],60
	jb @@ret
	cmp [YBall],138
	ja @@ret
	cmp [XBall],3
	ja @@RightGoalCheck
	;inc the score
	inc [S2]
	;set the curser to the scoe position and print the score
	mov ah,2
	mov bh,0
	mov dh,0
	mov dl,39
	int 10h
	mov ah,0
	mov al,[S2]
	call ShowAxDecimal
	;reset the ball after there was a goal
	call ResetBall
	jmp @@ret
@@RightGoalCheck:
	;Right goal position is between (316,60),(316,138)
	cmp [XBall],316
	jb @@ret
	;inc the score
	inc [S1]
	;set the curser to the scoe position and print the score
	mov ah,2
	mov bh,0
	mov dh,0
	mov dl,0
	int 10h
	mov ah,0
	mov al,[S1]
	call ShowAxDecimal
	;reset the ball after there was a goal
	call ResetBall
@@ret:
	ret
endp CheckGoal


;---------------------------
;Description: Resets ball location and ball direction
;Input: -
;Output: Screen, [BallD], [XBall], [YBall]
;---------------------------
proc ResetBall
	mov [BallD],-1;stop mooving the ball
	call putball
	mov [XBall],155;;middle of the plot
	mov [YBall],90
	call putball
	ret
endp ResetBall
;-----------------------------------------------------------------------
; Check whether 2 rectangels are overlapping   
; input on stack for 2 items  x1 y1 x2 y2 
; Output: ax = 1 it is true ax=0 it is not
; Reg Use : Ax
;if (rect1.x2 < rect2.x1 OR
;    rect2.x2 < rect1.x1 OR
;    rect1.y2 < rect2.y1 OR
;    rect2.y2 < rect1.y1 
;     not collision !
;}
;-----------------------------------------------------------------------
ParamAX1 equ   [word bp+18]
ParamAY1 equ   [word bp+16]
ParamAX2 equ   [word bp+14]
ParamAY2 equ   [word bp+12]

ParamBX1 equ   [word bp+10]
ParamBY1 equ   [word bp+8]
ParamBX2 equ   [word bp+6]
ParamBY2 equ   [word bp+4]

proc aabb 
	
	push bp     ; save bp
	mov bp,sp   ; parameters and locals pointer
	
	push dx
	 
	
	mov ax ,1
	
	mov dx , ParamAX2
	cmp dx, ParamBX1
	jb @@NotCollision
	
	mov dx , ParamBX2
	cmp dx, ParamAX1
	jb @@NotCollision
	
	mov dx , ParamAY2
	cmp dx, ParamBY1
	jb @@NotCollision
	
	mov dx , ParamBY2
	cmp dx, ParamAY1
	jb @@NotCollision
	jmp @@ret
@@NotCollision:
	mov ax ,0

@@ret:
	pop dx 
	pop bp     
	ret 16
endp aabb


;---------------------------
;Description: Checks what button was pressed and moves the player by the one pressed
;Input: Keyboard
;Output: Screen
;---------------------------
proc ButtonPressed
	 mov ah,0
	 int 16h
	 ;Blue player moves with W,A,S,D
	 cmp al,'w'
	 je w
	 cmp al,'a'
	 je a
	 cmp al,'s'
	 je s
	 cmp al,'d'
	 je d
	 
	 ;Red player moves with the arrows
	 cmp ah,48h ;Up Arrow scan code is 4800 
	 je up
	 cmp ah,4Bh ;Left Arrow scan code is 4B00 
	 je left
	 cmp ah,50h ;Down Arrow scan code is 5000
	 je down
	 cmp ah,4Dh;Right Arrow sacn code is 4D00 
	 je right
	 
	 cmp ah,01h ;scan code of 'esc' button
	 jne @@ret
	 mov [EndGame],1
	 jmp @@ret
	 
	 ;Blue Moving
w:
	cmp [BlueY],8
	jb @@ret
	call MoveBUp
	jmp @@ret
	
a:
	cmp [BlueX],8
	jb @@ret
	call MoveBLeft
	jmp @@ret
	
s:
	cmp [BlueY],156 ;200-(35+9)
	ja @@ret
	call MoveBDown
	jmp @@ret
	
d:
	cmp [BlueX],122 ;158-35
	ja @@ret
	call MoveBRight
	jmp @@ret
	 
	;Red Moving
	
up:
	cmp [RedY],8
	jb @@ret
	call MoveRUp
	jmp @@ret
	
left:	
	cmp [RedX],165
	jb @@ret
	call MoveRLeft
	jmp @@ret
	
down:
	cmp [RedY],156 ;200-(35+9)
	ja @@ret
	call MoveRDown
	jmp @@ret
	
right:
	cmp [RedX],278 ;313-35
	ja @@ret
	call MoveRRight
	jmp @@ret
	
@@ret:
	ret
endp ButtonPressed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ball procs
;---------------------------
;Description: puts the ball byy xoring it with the background
;Input: [XBall], [YBall], [ball]
;Output: Screen
;---------------------------
proc putBall
	
	
	push si
	push di
	push ax
	push bx
	push cx
	push dx
	
    
	xor si,si
	xor bx,bx
	mov dx,[YBall]
nextR:
	
		mov di,0
		mov cx,[XBall]
	nextC:
		 
			mov ah,0dh
			int 10h
			
			xor al,[byte ball + bx ]
			
			mov ah,0ch	
			int 10h    ; put pixel	
			inc cx
			inc di
			inc bx

		cmp di,BALL_SIZE
		jb nextC
		inc dx
		inc si
	
	cmp si, BALL_SIZE
	jb nextR


	
	 
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	pop si
	


	ret
endp putBall


;---------------------------
;Description: moves the ball by its direction
;Input: [BallD]
;Output: Screen
;---------------------------
;Ball Movement Procs
proc MoveBall
	cmp [BallD],-1
	je @@ret
	;up
	cmp [BallD],0
	jne @@1
	call MoveBallU
	jmp @@ret
@@1:
	;up right
	cmp [BallD],1
	jne @@2
	call MoveBallU
	call MoveBallR
	jmp @@ret
@@2:
	;right
	cmp [BallD],2
	jne @@3
	call MoveBallR
	jmp @@ret
@@3:
	;down right
	cmp [BallD],3
	jne @@4
	call MoveBallD
	call MoveBallR
	jmp @@ret
@@4:
	;down
	cmp [BallD],4
	jne @@5
	call MoveBallD
	jmp @@ret
@@5:
	;down left
	cmp [BallD],5
	jne @@6
	call MoveBallD
	call MoveBallL
	jmp @@ret
@@6:
	;left
	cmp [BallD],6
	jne @@7
	call MoveBallL
	jmp @@ret
@@7:
	;up left
	cmp [BallD],7
	jne @@ret
	call MoveBallU
	call MoveBallL
@@ret:
	ret
endp MoveBall


;---------------------------
;Description: moves the ball 1 pixel down
;Input: [YBall]
;Output: Screen
;---------------------------
proc MoveBallD
	;draw the ball again so itll make a xor back to the background color
	call putBall
	add [YBall],1
	call putball
	ret
endp MoveBallD

;---------------------------
;Description: moves the ball 1 pixel up
;Input: [YBall]
;Output: Screen
;---------------------------
proc MoveBallU
	;draw the ball again so itll make a xor back to the background color
	call putBall
	sub [YBall],1
	call putball
	ret
endp MoveBallU

;---------------------------
;Description: moves the ball 1 pixel right
;Input: [XBall]
;Output: Screen
;---------------------------
proc MoveBallR
	;draw the ball again so itll make a xor back to the background color
	call putBall
	add [XBall],1
	call putball
	ret
endp MoveBallR

;---------------------------
;Description: moves the ball 1 pixel left
;Input: [XBall]
;Output: Screen
;---------------------------
proc MoveBallL
	;draw the ball again so itll make a xor back to the background color
	call putBall 
	sub [XBall],1
	call putball
	ret
endp MoveBallL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Players Movement Procs
;---------------------------
;Description: moves red player 2 pixels up
;Input: [RedX],[RedY]
;Output: Screen
;---------------------------
proc MoveRUp
	call PRed2Down
	mov bx,offset RedBG
	call SHDBG
	call Red2Up

	mov ax,[RedX]
	mov [BmpLeft],ax
	sub [RedY],2
	mov ax,[RedY]
	mov [BmpTop],ax
	mov dx,offset RedP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	ret
endp MoveRUp


;---------------------------
;Description: moves blue player 2 pixels up
;Input: [BlueX],[BlueY]
;Output: Screen
;---------------------------
proc MoveBUp
	call PBlue2Down
	mov bx,offset BlueBG
	call SHDBG
	call Blue2Up
	mov ax,[BlueX]
	mov [BmpLeft],ax
	sub [BlueY],2
	mov ax,[BlueY]
	mov [BmpTop],ax
	mov dx,offset BlueP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	
	ret
endp MoveBUp


;---------------------------
;Description: moves red player 2 pixels left
;Input: [RedX],[RedY]
;Output: Screen
;---------------------------
proc MoveRLeft	
	call PRed2Right
	mov bx,offset RedBG
	call SHRBG
	call Red2Left

	sub [RedX],2
	mov ax,[RedX]
	mov [BmpLeft],ax
	mov ax,[RedY]
	mov [BmpTop],ax
	mov dx,offset RedP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	ret
endp MoveRLeft


;---------------------------
;Description: moves blue player 2 pixels left
;Input: [BlueX],[BlueY]
;Output: Screen
;---------------------------
proc MoveBLeft
	call PBlue2Right
	mov bx,offset BlueBG
	call SHRBG
	call Blue2Left
	
	sub [BlueX],2
	mov ax,[BlueX]
	mov [BmpLeft],ax
	mov ax,[BlueY]
	mov [BmpTop],ax
	mov dx,offset BlueP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	ret
endp MoveBLeft


;---------------------------
;Description: moves red player 2 pixels down
;Input: [RedX],[RedY]
;Output: Screen
;---------------------------
proc MoveRDown	 
	call PRed2Up
	mov bx,offset RedBG
	call SHUBG
	call Red2Down
	
	mov ax,[RedX]
	mov [BmpLeft],ax
	add [RedY],2
	mov ax,[RedY]
	mov [BmpTop],ax
	mov dx,offset RedP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	ret
endp MoveRDown


;---------------------------
;Description: moves blue player 2 pixels down
;Input: [BlueX],[BlueY]
;Output: Screen
;---------------------------
proc MoveBDown
	call PBlue2Up
	mov bx,offset BlueBG
	call SHUBG
	call Blue2Down
	
	mov ax,[BlueX]
	mov [BmpLeft],ax
	add [BlueY],2
	mov ax,[BlueY]
	mov [BmpTop],ax
	mov dx,offset BlueP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	ret
endp MoveBDown


;---------------------------
;Description: moves red player 2 pixels right
;Input: [RedX],[RedY]
;Output: Screen
;---------------------------
proc MoveRRight	
	call PRed2Left
	mov bx,offset RedBG
	call SHLBG
	call Red2Right

	add [RedX],2
	mov ax,[RedX]
	mov [BmpLeft],ax
	mov ax,[RedY]
	mov [BmpTop],ax
	mov dx,offset RedP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	ret
endp MoveRRight


;---------------------------
;Description: moves blue player 2 pixels right
;Input: [BlueX],[BlueY]
;Output: Screen
;---------------------------
proc MoveBRight
	call PBlue2Left
	mov bx,offset BlueBG
	call SHLBG
	call Blue2Right

	add [BlueX],2
	mov ax,[BlueX]
	mov [BmpLeft],ax
	mov ax,[BlueY]
	mov [BmpTop],ax
	mov dx,offset BlueP_Name
	mov [BmpColSize],PSIZE
	mov [BmpRowSize],PSIZE
	call OpenShowBMP
	ret
endp MoveBRight
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;---------------------------
;Description: Turn it to graphic mode
;Input: -
;Output: -
;---------------------------
proc  SetGraphic
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BMP Procs
proc OpenShowBmp near

	call OpenBmpFile
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBmp
	
	call CloseBmpFile


	ret
endp OpenShowBmp
proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	dec di
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	
	;small read one line
	mov ah,3fh
	mov cx,[BmpColSize]
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	mov cx,[BmpColSize]
	mov si,offset ScrLine
@@NextP:
	cmp [byte ptr si],251
	jne @@ok
	
	inc si
	inc di
	jmp @@next
@@ok:
	cld ; Clear direction flag, for movsb
	movsb ;copy 1 pixel to screen
@@next:
	loop @@NextP
	
	pop dx
	pop cx
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP 
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette
proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	mov [FileHandle], ax
	ret
endp OpenBmpFile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MY Files Procs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if the file doesnt exist make a new one and put in it this game info
proc CreateFile

	;Create a file for the scores
	mov dx, offset FileName
	mov cx,0
	mov ah,3ch
	int 21h
	
	;the new file handle goes into ax
	mov [FileHandle],ax
	
	mov bx,[FileHandle]
	mov cx,20 ;abc(P1)-def(P2) Score: 6(S1)-3(S2)CRLF  
	mov dx,offset tP1 ;has all the vars with the value to write in the file
	mov ah,40h
	int 21h
	
	ret
	
endp CreateFile

;Read every line in the file until you find the line with the players names or untill the file ends
proc ReadFromFile
@@next:
	mov bx,[FileHandle]
	mov cx,20
	mov dx,offset FileData
	mov ah,3fh
	int 21h
	cmp ax,20 ;if there are no more lines to read
	jne @@ret
	call CompareLines
	cmp [Line],-1
	je @@next	
@@ret:
	ret
endp ReadFromFile

;Compare the readen line and the names from this game
proc CompareLines
	mov cx,7
@@ag:
	;di and si will have the index to the bytes we need to compare
	mov di,offset FileData
	add di,7
	sub di,cx
	mov si,offset tP1
	add si,7
	sub si,cx
	mov al,[si]
	cmp [di],al
	jne @@ret
	loop @@ag
	
	mov si,[cnt]
	mov [Line],si
@@ret:
	inc [cnt]
	ret
endp CompareLines

;if you didnt find the names write them in the end of the file
proc AddToFileEnd
	;Make the place to write the last place in the file
	mov bx,[FileHandle]
	mov al,2;end of file
	mov cx,0
	mov dx,0
	mov ah,42h
	int 21h
	
	mov bx,[FileHandle]
	mov cx,20 ;abc(P1)-def(P2) Score: 6(S1)-3(S2)CRLF  
	mov dx,offset tP1 ;has all the vars with the value to write in the file
	mov ah,40h
	int 21h
	
	ret
endp AddToFileEnd
proc UpdateFile
	call ReadFromFile
	cmp [Line],-1
	je AddToEnd
	
	;move the curser to the line we want to replace
	mov cx,0
	mov dx,[Line]
	mov ax,[Line]
	shl dx,4;Line number * 16
	shl ax,2;Line number * 4
	add dx,ax ;Line number *20 because every line has 20 bytes
	mov ah,42h
	int 21h
	
	;write the new game info and replace the old
	mov bx,[FileHandle]
	mov cx,20 ;abc(P1)-def(P2) Score: 6(S1)-3(S2)CRLF  
	mov dx,offset tP1 ;has all the vars with the value to write in the file
	mov ah,40h
	int 21h
	jmp @@ret
	
AddToEnd:
	call AddToFileEnd
@@ret:
	ret
endp UpdateFile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the mask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs
; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask
;---------------------------
 
EndOfCsLbl:
END start