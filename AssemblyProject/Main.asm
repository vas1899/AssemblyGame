INCLUDE Irvine32.inc

.data

; string on the for the console, there is 0 at the end to stop reading
ground BYTE "--------------------------------------------------------------------------------------------------", 0

; player position
xPos BYTE 20
yPos BYTE 20

inputChar BYTE ?

.code
; main functoin of the program
main PROC
	; Ground: 
	; move 29 rows downwards
	mov dl,0
	mov dh,29
	call Gotoxy

	; move to edx 32bit register, it is only 32bit, so we call WriteString again and again
	mov edx, OFFSET ground
	call WriteString
	;

	;Player
	call DrawPlayer

	; Infinite loop
	gameLoop:

	; Reads the user input and stores it in inputChar
	call ReadChar
	mov inputChar, al

	; compare inputChar to X
	cmp inputChar,"x"
	; if it is equal, jump to ExitGame
	je ExitGame

	cmp inputChar,"w"
	je moveUp

	cmp inputChar,"s"
	je moveDown
	
	cmp inputChar,"a"
	je moveLeft

	cmp inputChar,"d"
	je moveRight

	moveUp:
	call UpdatePlayer
	; decrease
	dec	yPos
	call DrawPlayer	
	jmp	gameLoop

	moveDown:
	call UpdatePlayer
	; increase
	inc yPos
	call DrawPlayer
	jmp	gameLoop

	moveLeft:
	call UpdatePlayer
	dec xPos
	call DrawPlayer	
	jmp	gameLoop

	moveRight:
	call UpdatePlayer
	inc xPos
	call DrawPlayer	

	jmp	gameLoop

	ExitGame:
	exit
main ENDP

DrawPlayer PROC	
	; Set the positoin of the player
	mov dl, xPos
	mov dh, yPos
	call Gotoxy 

	; Draw the player
	mov al,"X"
	call WriteChar
	ret	
DrawPlayer ENDP	

; Removes the player from the old position
UpdatePlayer PROC	
	mov dl, xPos
	mov dh, yPos
	call Gotoxy 
	mov al," "
	call WriteChar
	ret	
UpdatePlayer ENDP	

END main