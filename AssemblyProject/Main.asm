INCLUDE Irvine32.inc

.data

; string on the for the console, there is 0 at the end to stop reading
ground BYTE "-------------------------------------------------------------------------------------------------------------------", 0

strScore BYTE "Score: ", 0
score BYTE 0

; player position
xPos BYTE 20
yPos BYTE 20

; ? - unknown
xCoinPos BYTE ?
yCoinPos BYTE ?


inputChar BYTE ?

.code
; main functoin of the program
main PROC
	; Ground: 
	; move 29 rows downwards
	mov dl,0
	mov dh,29
	call Gotoxy

	; move to edx 32bit register, and call it hit hit 0
	mov edx, OFFSET ground
	call WriteString
	;

	;Player
	call DrawPlayer

	call CreateRandomCoin 
	call DrawCoin 

	call Randomize

	; Infinite loop
	gameLoop:

		; if score is 10 end the game
		cmp score,10
		je ExitGame

		; getting points:
		; compare xPos and xCoinPos
		mov bl,xPos
		cmp bl,xCoinPos	
		jne	notCollecting ; if true just to this
		mov bl,yPos
		cmp bl,yCoinPos	
		jne	notCollecting
		; player hits the coin
		inc score 
		call CreateRandomCoin	
		call DrawCoin	

		notCollecting:

		; set the color to normal, otherwise makes everything the color of the coin
		mov eax, white (black *16)
		call SetTextColor

		; draw Score :
		; set position to the top left
		mov dh,0
		mov dl,0
		call Gotoxy
		; move to edx 32bit register, it is only 32bit, so we call WriteString again and again till hit 0
		mov edx,OFFSET	strScore
		call WriteString
		mov al, score
		add al, '0' ; int into char
		call WriteChar
		; while the player's position is greater to the ground
		gravity:
		cmp yPos,27
		jg onGround
		;make player fall
		call UpdatePlayer	
		inc yPos
		call DrawPlayer	
		; Delay the fall of the player
		mov eax,80
		call Delay

		jmp	gravity

		onGround:
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
		; change to ecx register so we can loop
		mov ecx,1
		jumpLoop:
			call UpdatePlayer
			; decrease
			dec	yPos
			call DrawPlayer	
			mov eax,90 
			call Delay
			loop jumpLoop
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

DrawCoin PROC
	; set Coin color
	mov eax, yellow (yellow *16)
	call SetTextColor
	; dl  - x position register
	mov dl,xCoinPos
	; dl  - y position register
	mov dh,yCoinPos
	call Gotoxy
	mov al, "O"
	call WriteChar
	; return
	ret
DrawCoin ENDP


; random positoin of the coin, it does not draw it
CreateRandomCoin PROC 
	mov eax,35
	inc eax ; so coins are not generated outside of the screen
	call RandomRange
	; al is 8 bit, that is why it is used
	mov xCoinPos,al
	; ground starts at 28, so the coints must be above it
	mov yCoinPos,27
	ret	
CreateRandomCoin ENDP

END main