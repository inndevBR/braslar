#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BLTCD001 ³ Autor ³ Rodrigo Slisinski     ³ Data ³ 27/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO BRASIL COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BLTBB001()

LOCAL	aPergs := {}
PRIVATE lExec    := .F.           
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :="BLTBB001"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0

dbSelectArea("SE1")

criaSx1(cPerg)
Pergunte (cPerg,.F.)

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"' .And.E1_SALDO > 0 .And. "
cFilter		+= "E1_PREFIXO=='" + MV_PAR01 + "' .and."
cFilter		+= "E1_NUM >= '"+ MV_PAR02 + "'.And.  E1_NUM<='"+ MV_PAR03 +"'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR04 + "'.And.E1_PARCELA<='" + MV_PAR05 + "'"
//cFilter		+= "E1_PORTADO=='399'.And."
//ARFS - 19/10/10
//cFilter		+= "E1_PORTADO=='001'.And."
//cFilter		+= "!(E1_TIPO$MVABATIM)"


IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()
@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED

dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Rodrigo Slisinski     ³ Data ³ 27/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS			     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                     ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
"CNPJ: 04.016.420/0001-17"                                         ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit :={}
LOCAL aDadosBanco:={}
LOCAL aDatSacado:={}
LOCAL aBolText     := {	"JRS: Valor por dia de atraso - R$",;
						"NAO RECEBER APOS 90 DIA (S) DO VENCIMENTO.",;
						"///// ATENCAO ///// --> SEGUNDA-VIA",;
						"PROTESTO: ",;
						". A PARTIR DESSA, CONSULTE O BB P/ PGTO"}		

LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

dbGoTop()
ProcRegua(RecCount())
Do While !EOF()
	If Marked("E1_OK")
		
		If !Empty(SE1->E1_NUMBCO)
			cNroDoc := StrZero(Val(SubStr(AllTrim(SE1->E1_NUMBCO),1,10)),10)
		EndIF
			
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
		
		DbSelectArea("SE1")
		aDadosBanco  := {'001'                      ,;	// [1]Numero do Banco
						"BANCO DO BRASIL"           ,;  //[2]Nome do Banco
						"3406"                      ,; 	// [3]Agência
						"1945"					,; 	// [4]Conta Corrente
						"3"  						,; 	// [5]Dígito da conta corrente
						"17"                       	}	// [6]Codigo da Carteira

						//AllTrim(SA1->A1_ENDCOR )+" - "+AllTrim(SA1->A1_BAICOR),;      	// [3]Endereço
		aDatSacado   := {AllTrim(SA1->A1_NOME)           	,;      	// [1]Razão Social
						AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA           	,;      	// [2]Código
						AllTrim(SA1->A1_END )							,;      	// [3]Endereço
						AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
						SA1->A1_EST                                      ,;     		// [5]Estado
						SA1->A1_CEP                                      ,;      	// [6]CEP
						SA1->A1_CGC										    ,;  			// [7]CGC
						SA1->A1_PESSOA										}       				// [8]PESSOA

		nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		
		//Monta codigo de barras
		aCB_RN_NN    :=Ret_cBarra(	SE1->E1_PREFIXO	,SE1->E1_NUM	,SE1->E1_PARCELA	,SE1->E1_TIPO	,;
						Subs(aDadosBanco[1],1,3)	,aDadosBanco[3]	,aDadosBanco[4] ,aDadosBanco[5]	,;
						cNroDoc		,(E1_VALOR-nVlrAbat)	, "11"	,"9" ,alltrim(SEE->EE_CODEMP)	)
		
		//aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
		aDadosTit	:= {E1_NUM+E1_PARCELA		,;  // [1] Número do título + parcela		//WR 23/11/2010 - RETIRADO OS ESPAÇOS
						E1_EMISSAO              ,;  // [2] Data da emissão do título
						dDataBase               ,;  // [3] Data da emissão do boleto
						E1_VENCTO               ,;  // [4] Data do vencimento
						(E1_SALDO - nVlrAbat)   ,;  // [5] Valor do título
						alltrim(SE1->E1_NUMBCO) ,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO              ,;  // [7] Prefixo da NF
						E1_TIPO					,;	// [8] Tipo do Titulo
						E1_NUM}   					// [9] Numero do titulo	
		
		u_fPrintPDF(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN) 
		
		nX := nX + 1
	EndIf
	dbSkip()
	IncProc()
	nI := nI + 1
EndDo

Return nil

User Function fPrintPDF(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN) 
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
	
	Local cLocal          	:= "C:\BOLETO_PROTHEUS\"
	Local cFilePrint 		:= ""
	Local lRemoveOk 		:= .F.
     
	//SE EXISTIR, REMOVE E CRIA NOVAMENTE
	If ExistDir(cLocal)
		If !(DirRemove( cLocal ))
			//MsgStop( "Falha ao remover a pasta." )
		Else 
			MakeDir(cLocal)
		EndIf
	Else	
		//SE A PASTA NAO EXISTIR, CRIA A MESMA
		MakeDir(cLocal)	
	EndIf
	
	Private oPrinter 		:= FWMSPrinter():New(aDadosTit[7] + AllTrim(aDadosTit[9]) + '_' + dToS(dDatabase) + '_' + strTran(Time(), ':', '') +'.PD_', 6, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	
	Private oFont16 		:= TFontEx():New(oPrinter,"Times New Roman",10,10,.T.,.T.,.F.)
	Private oFont20N 		:= TFontEX():New(oPrinter,"Times New Roman",17,17,.T.,.T.,.F.)
	
	
	oPrinter:SayAlign( 025, 032,"[totvs.com.br] Boleto gerado pelo sistema - 2º VIA BOLETO. " + dToC(dDatabase) + " " + Time(),oFont20N:oFont, 450, 200, , 0, 2 )
	oPrinter:SayAlign( 070, 032,"INSTRUÇÕES:",oFont20N:oFont, 450, 200, , 0, 2 )
	oPrinter:SayAlign( 085, 032,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*(SE1->E1_PORCJUR/100))),"@E 99,999.99")) + " APOS " + StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 100, 032,aBolText[2],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 115, 032,aBolText[3] ,oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 130, 032,"PROCEDA OS AJUSTES DE VALORES PERTINENTES.",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 145, 032,aBolText[4] + StrZero(Day(aDadosTit[4]+15),2) +"/"+ StrZero(Month(aDadosTit[4]+15),2) +"/"+ Right(Str(Year(aDadosTit[4]+15)),4) + aBolText[5] + '...',oFont16:oFont, 350, 200, , 0, 2 )
	
	oPrinter:Line( 250, 030, 250, 550,, "-4")	//H
	oPrinter:SayAlign( 250,100,"Recibo do Pagador",oFont20N:oFont, 450, 200, , 1, 2 )
	
	oPrinter:SayBitmap( 265, 030, "\system\logo_BB.bmp", 085, 14)
	oPrinter:SayAlign( 265,170,"001-9",oFont20N:oFont, 450, 200, , 0, 2 )
	oPrinter:SayAlign( 265,100,aCB_RN_NN[2],oFont20n:oFont, 450, 200, , 1, 2 )
	oPrinter:Line( 265, 160, 280, 160,, "-4")	//V
	oPrinter:Line( 265, 205, 280, 205,, "-4")	//V
	oPrinter:Line( 280, 030, 280, 550,, "-4")	//H
	
	oPrinter:SayAlign( 280, 032,"Nome do Pagador / CPF / CNPJ / Endereço",oFont16:oFont, 350, 200, , 0, 2 )
	
	If aDatSacado[8] = "J"
		oPrinter:SayAlign( 295, 032, aDatSacado[1]+" CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont16:oFont, 600, 200, , 0, 2 )
	Else
		oPrinter:SayAlign( 295, 032, aDatSacado[1]+" CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont16:oFont, 600, 200, , 0, 2 )
	EndIf

	oPrinter:SayAlign( 310, 032, aDatSacado[3] + " - " + aDatSacado[4] + " - " + aDatSacado[5] + " CEP: " + aDatSacado[6] ,oFont16:oFont, 600, 200, , 0, 2 )
		
	oPrinter:Line( 283, 030, 325, 030,, "-4")	//V		
	oPrinter:Line( 325, 030, 325, 550,, "-4")	//H
			
	oPrinter:SayAlign( 325, 032,"Sacador/Avalista",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 328, 030, 355, 030,, "-4")	//V
	oPrinter:Line( 355, 030, 355, 550,, "-4")	//H
	
	oPrinter:SayAlign( 355, 032,"Nosso-Numero",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 370, 032,SubStr(aDadosTit[6],1,Len(aDadosTit[6])-1)+"-"+SubStr(aDadosTit[6],Len(aDadosTit[6]),1),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 355, 136,"Nr Documento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 370, 136,aDadosTit[7]+aDadosTit[1],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 355, 240,"Data de Vencimento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 370, 240,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 355, 344,"Valor do Documento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 370, 344,Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99")),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 355, 448,"(=)Valor Pago",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 370, 448,Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99")),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 358, 030, 385, 030,, "-4")	//V
	oPrinter:Line( 358, 134, 385, 134,, "-4")	//V
	oPrinter:Line( 358, 238, 385, 238,, "-4")	//V
	oPrinter:Line( 358, 342, 385, 342,, "-4")	//V
	oPrinter:Line( 358, 446, 385, 446,, "-4")	//V
	oPrinter:Line( 385, 030, 385, 550,, "-4")	//H
			
	oPrinter:SayAlign( 385, 032,"Nome do Beneficiário/CPF/CNPJ",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 400, 032,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 415, 032,AllTrim(aDadosEmp[2]) + " " + AllTrim(aDadosEmp[3]),oFont16:oFont, 550, 200, , 0, 2 )
	oPrinter:Line( 388, 030, 430, 030,, "-4")	//V
	oPrinter:Line( 430, 030, 430, 550,, "-4")	//H
	
	oPrinter:SayAlign( 430, 032,"Agência / Código do Beneficiário",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 445, 032,Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 430, 376,"Autenticação Mecânica",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 433, 030, 475, 030,, "-4")	//V
	oPrinter:Line( 433, 374, 475, 374,, "-4")	//V
	oPrinter:Line( 475, 030, 475, 550,, "-4")	//H
	
	oPrinter:SayBitmap( 485, 030, "\system\logo_BB.bmp", 085, 14)
	oPrinter:SayAlign( 485,170,"001-9",oFont20N:oFont, 400, 200, , 0, 2 )
	oPrinter:SayAlign( 485,100,aCB_RN_NN[2],oFont20N:oFont, 450, 200, , 1, 2 )
	oPrinter:Line( 485, 160, 500, 160,, "-4")	//V
	oPrinter:Line( 485, 205, 500, 205,, "-4")	//V
	oPrinter:Line( 500, 030, 500, 550,, "-4")	//H
	
	oPrinter:SayAlign( 505, 032,"Local de Pagamento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 520, 032,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 505, 430,"Data de Vencimento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 520, 430,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 508, 030, 535, 030,, "-4")	//V	
	oPrinter:Line( 508, 428, 535, 428,, "-4")	//V	
	oPrinter:Line( 535, 030, 535, 550,, "-4")	//H
	
	oPrinter:SayAlign( 535, 032,"Nome do Beneficiário/CPF/CNPJ",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 550, 032,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 535, 430,"Agência/Beneficiário",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 550, 430,Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 538, 030, 565, 030,, "-4")	//V	
	oPrinter:Line( 538, 428, 565, 428,, "-4")	//V	
	oPrinter:Line( 565, 030, 565, 550,, "-4")	//H
	
	oPrinter:SayAlign( 565, 032,"Data do Documento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 580, 032,StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 565, 122,"Nr. do Documento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 580, 122,aDadosTit[7]+aDadosTit[1],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 565, 202,"Espécie DOC",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 580, 202,"DM",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 565, 282,"Aceite",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 580, 282,"N",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 565, 322,"Data Processamento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 580, 322,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 565, 430,"Nosso-Numero",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 580, 430,SubStr(aDadosTit[6],1,Len(aDadosTit[6])-1)+"-"+SubStr(aDadosTit[6],Len(aDadosTit[6]),1),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 568, 030, 595, 030,, "-4")	//V	
	oPrinter:Line( 568, 120, 595, 120,, "-4")	//V	
	oPrinter:Line( 568, 200, 595, 200,, "-4")	//V	
	oPrinter:Line( 568, 280, 595, 280,, "-4")	//V	
	oPrinter:Line( 568, 320, 595, 320,, "-4")	//V	
	oPrinter:Line( 568, 428, 595, 428,, "-4")	//V	
	oPrinter:Line( 595, 030, 595, 550,, "-4")	//H
	
	oPrinter:SayAlign( 595, 032,"Uso do Banco",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 610, 032,aDadosTit[7]+aDadosTit[9],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 595, 122,"Carteira",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 610, 122,"17",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 595, 202,"Espécie",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 610, 202,"R$",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 595, 282,"Quant.",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 610, 282,"",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 595, 322,"xValor",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 610, 322,"",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 595, 430,"(=)Valor do Documento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 610, 430,Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99")),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 598, 030, 625, 030,, "-4")	//V	
	oPrinter:Line( 598, 120, 625, 120,, "-4")	//V	
	oPrinter:Line( 598, 200, 625, 200,, "-4")	//V	
	oPrinter:Line( 598, 280, 625, 280,, "-4")	//V	
	oPrinter:Line( 598, 320, 625, 320,, "-4")	//V	
	oPrinter:Line( 598, 428, 625, 428,, "-4")	//V	
	oPrinter:Line( 625, 030, 625, 550,, "-4")	//H
	
	oPrinter:SayAlign( 625, 032,"Informacoes de Responsabilidade do Beneficiário",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 640, 032,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*(SE1->E1_PORCJUR/100))),"@E 99,999.99")) + " APOS " + StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 655, 032,aBolText[2],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 670, 032,aBolText[3] ,oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 685, 032,"PROCEDA OS AJUSTES DE VALORES PERTINENTES.",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 700, 032,aBolText[4] + StrZero(Day(aDadosTit[4]+15),2) +"/"+ StrZero(Month(aDadosTit[4]+15),2) +"/"+ Right(Str(Year(aDadosTit[4]+15)),4) + aBolText[5],oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 625, 430,"(-)Desconto/Abatimento",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 640, 430,"",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 628, 428, 655, 428,, "-4")	//V	
	oPrinter:Line( 655, 428, 655, 550,, "-4")	//H
	
	oPrinter:SayAlign( 655, 430,"(+)Juros/Multa",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 670, 430,"",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 658, 428, 685, 428,, "-4")	//V	
	oPrinter:Line( 685, 428, 685, 550,, "-4")	//H
	
	oPrinter:SayAlign( 685, 430,"(=)Valor Cobrado",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:SayAlign( 700, 430,"",oFont16:oFont, 350, 200, , 0, 2 )
	oPrinter:Line( 688, 428, 715, 428,, "-4")	//V	
	oPrinter:Line( 715, 030, 715, 550,, "-4")	//H
	
	oPrinter:SayAlign( 715, 032,"Nome do Pagador / CPF / CNPJ / Endereço",oFont16:oFont, 350, 200, , 0, 2 )
	
	If aDatSacado[8] = "J"
		oPrinter:SayAlign( 730, 032, aDatSacado[1]+" CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont16:oFont, 600, 200, , 0, 2 )
	Else
		oPrinter:SayAlign( 730, 032, aDatSacado[1]+" CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont16:oFont, 600, 200, , 0, 2 )
	EndIf

	oPrinter:SayAlign( 745, 032, aDatSacado[3] + " - " + aDatSacado[4] + " - " + aDatSacado[5] + " CEP: " + aDatSacado[6] ,oFont16:oFont, 600, 200, , 0, 2 )
		
	//oPrinter:Line( 717, 030, 760, 030,, "-4")	//V		
	oPrinter:Line( 760, 030, 760, 550,, "-4")	//H
	
	oPrinter:SayAlign( 760, 032, "Sacador / Avalista" ,oFont16:oFont, 600, 200, , 0, 2 )
	oPrinter:SayAlign( 760, 100, "Autenticação Mecânica - Ficha de Compensação" ,oFont16:oFont, 450, 200, , 1, 2 )
	
	oPrinter:FWMSBAR("INT25" /*cTypeBar*/,64/*nRow*/ ,2.8/*nCol*/, aCB_RN_NN[1]/*cCode*/,oPrinter/*oPrint*/,.F./*lCheck*/,/*Color*/,.T./*lHorz*/,0.02/*nWidth*/,1.0/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/)
	
	cFilePrint := cLocal + aDadosTit[7] + AllTrim(aDadosTit[9]) + '_' + dToS(dDatabase) + '_' + strTran(Time(), ':', '')+'.PD_'
	
	File2Printer( cFilePrint, "PDF" )
    oPrinter:cPathPDF:= cLocal 
	oPrinter:Preview()
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetDados  ºAutor  ³Rodrigo Slisinski   º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera SE1                        					          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_cBarra(	cPrefixo	,cNumero	,cParcela	,cTipo	,;
cBanco		,cAgencia	,cConta		,cDacCC	,;
cNroDoc		,nValor		,cCart		,cMoeda,nCod	)

Local cNosso		:= ""
Local cDigNosso		:= ""
Local NNUM			:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		:= ""
Local cDigBarra		:= ""
Local cBarra		:= ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		:= ""
Local aRet			:= {}

//DEFAULT nValor := 0

cAgencia:=STRZERO(Val(cAgencia),4)

cNosso := ""
//NNUM   := nCod+cNroDoc
NNUM   := STRZERO(VAL(cNroDoc),11)
//STRZERO(Val(cNroDoc),11)
//Nosso Numero
cDigNosso  := CALC_di9(NNUM)
cNosso     := NNUM + cDigNosso

// campo livre			// verificar a conta e carteira
//			cCampoL := cNosso+substr(e1_agedep,1,4)+STRZERO(VAL(e1_conta),8)+'18'
cCampoL := NNUM + cAgencia + StrZero(Val(cConta),8) + "11"

//campo livre do codigo de barra                   // verificar a conta
If nValor > 0
	cFatorValor  := fator()+strzero(nValor*100,10)
Else
	cFatorValor  := fator()+strzero(SE1->E1_VALOR*100,10)
Endif

cLivre := cBanco+cMoeda+cFatorValor+cCampoL

// campo do codigo de barra
cDigBarra := CALC_5p( cLivre )
cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,40)

// composicao da linha digitavel
cParte1  := cBanco+cMoeda
cParte1  := cParte1 + SUBSTR(cCampoL,1,5)
cDig1    := DIGIT001( cParte1 )
cParte2  := SUBSTR(cCampoL,6,10)
cDig2    := DIGIT001( cParte2 )
cParte3  := SUBSTR(cCampoL,16,10)
cDig3    := DIGIT001( cParte3 )
cParte4  := cDigBarra + " "
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,4)+cDig1+" "+;
substr(cParte2,1,5)+"."+substr(cparte2,6,5)+cDig2+" "+;
substr(cParte3,1,5)+"."+substr(cparte3,6,5)+cDig3+" "+;
cParte4+;
cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)


Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_di9  ºAutor  ³Rodrigo Slisinski   º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para calculo do nosso numero do banco do brasil             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CALC_di9(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 9
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base == 1
		base := 9
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base - 1
	iDig   := iDig-1
EndDo
auxi := mod(Sumdig,11)
If auxi == 10
	auxi := "X"
Else
	auxi := str(auxi,1,0)
EndIf
Return(auxi)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DIGIT001  ºAutor  ³Rodrigo Slisinski   º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para calculo da linha digitavel do Banco do Brasil          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DIGIT001(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
umdois := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	auxi   := Val(SubStr(cBase, idig, 1)) * umdois
	sumdig := SumDig + If (auxi < 10, auxi, (auxi-9))
	if umdois == 2
		umdois := 1
	Else
		umdois := 2
	EndIF
	iDig:=iDig-1
EndDo
cValor:=AllTrim(STR(sumdig,12))
nDezena:=VAL(ALLTRIM(STR(VAL(SUBSTR(cvalor,1,1))+1,12))+"0")
auxi := nDezena - sumdig

If auxi >= 10
	auxi := 0
EndIf
Return(str(auxi,1,0))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FATOR		ºAutor  ³Rodrigo Slisinski   º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do FATOR  de vencimento para linha digitavel.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Fator()
If Len(ALLTRIM(SUBSTR(DTOC(SE1->E1_VENCTO),7,4))) = 4
	cData := SUBSTR(DTOC(SE1->E1_VENCTO),7,4)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
Else
	cData := "20"+SUBSTR(DTOC(SE1->E1_VENCTO),7,2)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
EndIf
cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
//cFator := STR(1000+(SE1->E1_VENCREA-STOD("20000703")),4)
Return(cFator)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_5p   ºAutor  ³Rodrigo Slisinski   º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do digito do nosso numero do                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CALC_5p(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base >= 10
		base := 2
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base + 1
	iDig   := iDig-1
EndDo
auxi := mod(sumdig,11)
If auxi == 0 .or. auxi == 1 .or. auxi >= 10
	auxi := 1
Else
	auxi := 11 - auxi
EndIf

Return(str(auxi,1,0))


Static Function criasx1(cPerg)

PutSX1(cPerg, "01", "De Prefixo"                , "", "", "mv_ch1", "C", 03, 0, 0, "G", "", ""   , "", "", "mv_par01", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "02", "Do Numero"                 , "", "", "mv_ch3", "C", 09, 0, 0, "G", "", ""   , "", "", "mv_par02", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Até Numero"                , "", "", "mv_ch4", "C", 09, 0, 0, "G", "", ""   , "", "", "mv_par03", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "04", "Da Parcela"                , "", "", "mv_ch5", "C", 02, 0, 0, "G", "", ""   , "", "", "mv_par04", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "05", "Até Parcela"               , "", "", "mv_ch6", "C", 02, 0, 0, "G", "", ""   , "", "", "mv_par05", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "06", "Sub Conta"                 , "", "", "mv_ch7", "C", 03, 0, 0, "G", "", ""   , "", "", "mv_par06", "","","","","","","","","","","","","","","","")
RETURN
