#include 'protheus.ch'
#DEFINE  __codBanco "001"
#DEFINE __nomBanco "Banco do Brasil"
#DEFINE nLarg  (605-35)
#DEFINE nAlt   842

/************************************************************************
	Impressão do Boleto - Banco do Brasil 
	Programador: Mario Araujo Oliveira  -  INNOVATE           25/10/17
*************************************************************************/
User Function RBol001(oBoleto)
	Local nBloco1 := 0
	Local nBloco2 := 0
	Local nBloco3 := 0
	Local lRet := .T.
	
	Private oArial06  := TFont():New('Arial',06,06,,.F.,,,,.T.,.F.,.F.)
	Private oArial09N := TFont():New('Arial',10,10,,.T.,,,,.T.,.F.,.F.)
	Private oArial09  := TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)
	Private oArial12N := TFont():New('Arial',12,12,,.T.,,,,.T.,.F.,.F.)
	Private oArial14  := TFont():New('Arial',16,16,,.F.,,,,.T.,.F.,.F.)
	Private oArial18N := TFont():New('Arial',21,21,,.T.,,,,.T.,.F.,.F.)


	Private aMensagens := {"","","",""}	//SEE->( { EE_FORMEN1, EE_FORMEN2, EE_FOREXT1, EE_FOREXT2} )

	Private nValor := SE1->E1_VALJUR

	//busca o valor
	Private nValorDocumento  := SE1->E1_SALDO//u_GetVlrBoleto()
	//nosso numero
	Private cNossoNumero := "" 
	//codigo de barras
	Private cCodigoBarra := BolCodBar(nValorDocumento, alltrim(strtran(SE1->E1_NUMBCO,"X","0")))
	Private cLinhaDigitavel := BolLinhaDigitavel(nValorDocumento, alltrim(strtran(SE1->E1_NUMBCO,"X","0")), cCodigoBarra)

	cNossoNumero := alltrim(SEE->EE_CODEMP) + alltrim(SE1->E1_NUMBCO)
	IF len(alltrim(SEE->EE_CODEMP)) = 6
		cNossoNumero := cNossoNumero + DigVerNossNum(cNossoNum)
	EndIF

	//inicia pagina
	oBoleto:StartPage()

	//imprime o bloco do recibo (menor)
	nBloco1 := ImprimeRecibo(oBoleto,0)
	nBloco1 += 10

	//pontilhado pra separar
	BOLPontilhado(oBoleto,nBloco1)

	//imprime o segundo bloco (igual o terceiro)
	nBloco1 := ImprimeBloco(oBoleto, nBloco1)
	nBloco1 += 50

	//pontilhado pra separar
	BOLPontilhado(oBoleto,nBloco1)

	//BLOCO 3
	nBloco1 := ImprimeBloco(oBoleto, nBloco1 )

	oBoleto:FWMSBAR("INT25", 64, 1.6, cCodigoBarra, oBoleto,.F.,,,,1.2,.F.,"Arial",NIL,.F.,1,1,.F.)

	//Finaliza pagina
	oBoleto:EndPage()

Return lRet
/****************************************************
****************************************************/
Static Function ImprimeRecibo(oBoleto, nBloco)
	nBloco := BOLImpTitulo(oBoleto, nBloco, .F.)

	//nome da empresa
	oBoleto:Say(nBloco+=6 ,25 ,"Nome do Pagador/CNPJ/CPF/Endereço",oArial06)
	oBoleto:Say(nBloco+=10,25 ,SA1->A1_NOME + " - CNPJ: " + transform(SA1->A1_CGC,"@R 99.999.999/9999-99") ,oArial09N)
	oBoleto:Say(nBloco+=10,25 ,SA1->A1_END + " - " + SA1->A1_BAIRRO ,oArial09N)
	oBoleto:Say(nBloco+=10,25 ,transform(SA1->A1_CEP,"@R 99999-999")+ " - " + alltrim(SA1->A1_MUN)+"/"+SA1->A1_EST ,oArial09N)

	oBoleto:Line(nBloco+=4,  20,nBloco   ,nLarg,,"01")
	oBoleto:Line(nBloco   , 144,nBloco+20,144  ,,"01")
	oBoleto:Line(nBloco   , 244,nBloco+20,244  ,,"01")
	oBoleto:Line(nBloco   , 344,nBloco+20,344  ,,"01")
	oBoleto:Line(nBloco   , 444,nBloco+20,444  ,,"01")

	oBoleto:Say(nBloco+=6,25 ,"Nosso-Número",oArial06)
	oBoleto:Say(nBloco   ,150,"Nr do Documento",oArial06)
	oBoleto:Say(nBloco   ,250,"Data de Vencimento",oArial06)
	oBoleto:Say(nBloco   ,350,"Valor do Documento",oArial06)
	oBoleto:Say(nBloco   ,450,"( = ) Valor Pago",oArial06)

	oBoleto:Say(nBloco+=10,25 ,cNossoNumero ,oArial09N)
	oBoleto:Say(nBloco   ,150,alltrim(SE1->(E1_NUM+" / "+E1_PARCELA))				,oArial09N) //Prefixo +Numero+Parcela
	oBoleto:Say(nBloco   ,250,FormDate(SE1->E1_VENCTO)						,oArial09N)
	oBoleto:Say(nBloco   ,350,Transform(nValorDocumento,"@E 999,999,999.99"),oArial09N)

	//nome da empresa
	oBoleto:Line(nBloco+=4 ,20 ,nBloco ,nLarg ,,"01")
	oBoleto:Say (nBloco+=6 ,25 ,"Nome do Beneficiário/CNPJ/CPF/Endereço"							,oArial06)
	oBoleto:Say (nBloco+=10,25 ,alltrim(SM0->M0_NOMECOM) + " - CNPJ: " + transform(SM0->M0_CGC,"@R 99.999.999/9999-99")			,oArial09N)
	oBoleto:Say (nBloco+=10,25 ,SM0->M0_ENDCOB + " - " + SM0->M0_BAIRCOB + ' ' + SM0->M0_COMPCOB	,oArial09N)
	oBoleto:Say (nBloco+=10,25 ,transform(SM0->M0_CEPCOB,"@R 99999-999")+ " - " + alltrim(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB	,oArial09N)

	//linhas horizontais
	oBoleto:Line(nBloco+=4 , 20,nBloco ,nLarg ,,"01")
	oBoleto:Say (nBloco+=6 , 25,"Agência / Código Beneficiário",oArial06)
	oBoleto:Say (nBloco    ,420, "Autenticação Mecânica" , oArial06)
	oBoleto:Say (nBloco+=10, 25,alltrim(SEE->EE_AGENCIA)+"-"+SEE->EE_DVAGE+"/"+ALLTRIM(SEE->EE_CONTA)+"-"+SEE->EE_DVCTA ,oArial09N)

Return nBloco
/****************************************************
****************************************************/
Static Function ImprimeBloco(oBoleto, nBloco)

	Local nIniB

	nBloco := nIniB := BOLImpTitulo(oBoleto,nBloco)

	//bloco 2 linha 1 ->
	oBoleto:Say(nBloco+=6,25 ,"Local de pagamento",oArial06)
	oBoleto:Say(nBloco   ,425 ,"Data de Vencimento",oArial06)

	oBoleto:Say(nBloco+=10,25 ,"PAGÁVEL EM QUALQUER BANCO",oArial09N)
	oBoleto:Say(nBloco    ,435 ,FormDate(SE1->E1_VENCTO),oArial09N)

	//bloco 2 linha 2 ->
	oBoleto:Line(nBloco+=4,  20, nBloco,nLarg,,"01")
	oBoleto:Say (nBloco+=6,25 , "Beneficiário",oArial06)
	oBoleto:Say (nBloco   ,425 ,"Agência / Código Beneficiário",oArial06)

	oBoleto:Say(nBloco+=10,25 , SM0->M0_NOMECOM + " - CNPJ: " + transform(SM0->M0_CGC,"@R 99.999.999/9999-99") ,oArial09N)
	oBoleto:Say(nBloco    ,435 ,alltrim(SEE->EE_AGENCIA)+"-"+SEE->EE_DVAGE+"/"+ALLTRIM(SEE->EE_CONTA)+"-"+SEE->EE_DVCTA,oArial09N)

	//bloco 2 linha 4 ->
	oBoleto:Line(nBloco+=4,  20, nBloco   ,nLarg,,"01")
	oBoleto:Line(nBloco   , 110, nBloco+20,110,,"01")
	oBoleto:Line(nBloco   , 232, nBloco+20,232,,"01")
	oBoleto:Line(nBloco   , 293, nBloco+20,293,,"01")
	oBoleto:Line(nBloco   , 339, nBloco+20,339,,"01")

	oBoleto:Say(nBloco+=6,25, "Data do Documento"	,oArial06)
	oBoleto:Say(nBloco   ,115, "Nr do Documento"	,oArial06)
	oBoleto:Say(nBloco   ,237, "Espécie DOC"		,oArial06)
	oBoleto:Say(nBloco   ,298, "Aceite"				,oArial06)
	oBoleto:Say(nBloco   ,344, "Data Processamento"	,oArial06)
	oBoleto:Say(nBloco   ,425 ,"Nosso-Número"		,oArial06)

	oBoleto:Say(nBloco+=10,25, FormDate(SE1->E1_EMISSAO)			, oArial09N)
	oBoleto:Say(nBloco    ,115, alltrim(SE1->(E1_NUM+" / "+E1_PARCELA))	,oArial09N)
	oBoleto:Say(nBloco    ,237, "DM"								,oArial09N) //Tipo do Titulo
	oBoleto:Say(nBloco    ,298, "N"									,oArial09N)
	oBoleto:Say(nBloco    ,344, FormDate(Date())					,oArial09N) // Data impressao
	oBoleto:Say(nBloco    ,435 ,cNossoNumero,oArial09N)

	//bloco 2 linha 5 ->
	oBoleto:Line(nBloco+=4, 20, nBloco   ,nLarg	,,"01")
	oBoleto:Line(nBloco   ,110, nBloco+20,110	,,"01")
	oBoleto:Line(nBloco   ,171, nBloco+20,171	,,"01")
	oBoleto:Line(nBloco   ,232, nBloco+20,232	,,"01")
	oBoleto:Line(nBloco   ,339, nBloco+20,339	,,"01")

	oBoleto:Say(nBloco+=6,25,"Uso do Banco"					,oArial06)
	oBoleto:Say(nBloco   ,115 ,"Carteira"					,oArial06)
	oBoleto:Say(nBloco   ,176 ,"Espécie"					,oArial06)
	oBoleto:Say(nBloco   ,237,"Quantidade"					,oArial06)
	oBoleto:Say(nBloco   ,344,"Valor"						,oArial06)
	oBoleto:Say(nBloco   ,425 ,"( = ) Valor do Documento"	,oArial06)

	oBoleto:Say(nBloco+=10,115 ,SEE->EE_CODCART+"/027"				,oArial09N)
	oBoleto:Say(nBloco    ,176 ,"R$"								,oArial09N)
	oBoleto:SayAlign(nBloco-10,435, Transform(nValorDocumento,"@E 999,999,999.99")	,oArial09N,100,,,1)

	//bloco 2 linha 6 ->
	oBoleto:Line(nBloco+=4,  20, nBloco,nLarg,,"01")
	oBoleto:Say(nBloco+=6 ,25, "Instruções de responsabilidade do beneficiário"	,oArial06)
	oBoleto:Say(nBloco    ,425,"( - ) Desconto / Abatimento"					,oArial06)
	oBoleto:SayAlign(nBloco,435, IIF(SE1->E1_DECRESC>0,TransForm(SE1->E1_DECRESC,"@E 999,999.99"),'')	,oArial09,100,,,1)
	nBloco+=10


	//oBoleto:Say(nBloco ,0025,"ORIGEM: " +SE1->E1_FILIAL+ " ("+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")+") "+ALLTRIM(FWFILNAME(CEMPANT,SE1->E1_FILIAL)),oArial09N)

	//mensagens
	aMensagens[1] := AllTrim(StrTran(SEE->EE_FORMEN1,"'"," "))
	aMensagens[2] := AllTrim(StrTran(SEE->EE_FORMEN2,"'"," "))
	aMensagens[3] := AllTrim(StrTran(SEE->EE_FOREXT1,"'"," "))
	aMensagens[4] := AllTrim(StrTran(SEE->EE_FOREXT2,"'"," "))

	oBoleto:Say(nBloco+10,0025,aMensagens[1] ,oArial09N)
	oBoleto:Say(nBloco+20,0025,aMensagens[2] ,oArial09N)
	oBoleto:Say(nBloco+30,0025,aMensagens[3] ,oArial09N)
	oBoleto:Say(nBloco+40,0025,aMensagens[4] ,oArial09N)
	//oBoleto:Say(nBloco+50,0025,If(SE1->E1_TIPO=="FT ","FAT: "+Alltrim(SE1->E1_NUM),If(SE1->E1_TIPO=="CE ","CTE: "+Alltrim(SE1->E1_NUMNOTA),"")),oArial09N)

	//bloco 2 linha 7 ->
	oBoleto:Line(nBloco+=4,420, nBloco,nLarg,,"01")
	oBoleto:Say (nBloco+=6,425,"( - ) Outras Deduções",oArial06)
	nBloco += 10

	//bloco 2 linha 8 ->
	oBoleto:Line(nBloco+=4,420, nBloco,nLarg,,"01")
	oBoleto:Say (nBloco+=6,425,"( + ) Juros / Multa",oArial06)
	nBloco += 10

	//bloco 2 linha 9 ->
	oBoleto:Line(nBloco+=4,420, nBloco,nLarg,,"01")
	oBoleto:Say (nBloco+=6,425,"( + ) Outros Acréscimos",oArial06)
	//oBoleto:SayAlign(nBloco,435, IIF(!Empty(SE1->E1_ACRESC),TransForm(SE1->E1_ACRESC,"@E 999,999.99"),''), oArial09,100,,,1)
	nBloco+=10

	//bloco 2 linha 10 ->
	oBoleto:Line(nBloco+=4,420, nBloco,nLarg,,"01")
	oBoleto:Say (nBloco+=6,425,"( = ) Valor Cobrado",oArial06)
	nBloco += 10

	oBoleto:Line( nIniB,420, nBloco+4,420,,"01")

	//bloco 2 pagardor ->
	oBoleto:Line(nBloco+=4 , 20, nBloco,nLarg,,"01")
	oBoleto:Say (nBloco+=6 ,25 ,"Pagador",oArial06)
	oBoleto:Say (nBloco+=10,25 ,SA1->A1_NOME + " - CNPJ: " + transform(SA1->A1_CGC,"@R 99.999.999/9999-99") ,oArial09N)
	oBoleto:Say (nBloco+=10,25 ,SA1->A1_END + " - " + SA1->A1_BAIRRO ,oArial09N)
	oBoleto:Say (nBloco+=10,25 ,transform(SA1->A1_CEP,"@R 99999-999")+ " - " + alltrim(SA1->A1_MUN)+"/"+SA1->A1_EST ,oArial09N)

	//bloco 2 Sacador - autenticação ->
	oBoleto:Say(nBloco+=20, 25, "Sacador/Avalista" , oArial06)
	oBoleto:Line(nBloco+=4,  20, nBloco,nLarg,,"01")
	oBoleto:Say(nBloco +=6,450, "Autenticação Mecânica - Ficha de compensação" , oArial06)

Return nBloco
/****************************************************
****************************************************/
Static Function BolCodBar(nValor, cNossoNumero)

	//6 posições (numeração de 0010000 até 0999999)
	//7 posições (numeração de 1000000 até 9999999)
	/*
	+==================================================================+
	| FORMATO DO CÓDIGO DE BARRAS PARA CONVÊNIOS DE 6 POSIÇÕES         |
	| 01 a 03 - Código do Banco na Câmara de Compensação = ‘001’       |
	| 04 a 04 - Código da Moeda = '9'                                  |
	| 05 a 05 - DV do Código de Barras (Anexo 10)                      |
	| 06 a 09 - Fator de Vencimento (Anexo 8)                          |
	| 10 a 19 - Valor                                                  |
	| 20 a 25 - zeros                                                  |
	| 26 a 42 - Nosso-Número, sem o DV, sendo:                         |
	|           20 a 25 - Número do Convênio                           |
	|           26 a 30 - Número Sequencial                            |
	| 43 a 44 - Tipo de Carteira/Modalidade de Cobrança                |
	+==================================================================+
	*/
	//Ou
	/*
	+==================================================================+
	| FORMATO DO CÓDIGO DE BARRAS PARA CONVÊNIOS DE 7 POSIÇÕES         |
	| 01 a 03 - Código do Banco na Câmara de Compensação = ‘001’       |
	| 04 a 04 - Código da Moeda = '9'                                  |
	| 05 a 05 - DV do Código de Barras (Anexo 10)                      |
	| 06 a 09 - Fator de Vencimento (Anexo 8)                          |
	| 10 a 19 - Valor                                                  |
	| 20 a 25 - zeros                                                  |
	| 26 a 42 - Nosso-Número, sem o DV, sendo:                         |
	|           26 a 32 - Número do Convênio   (CCCCCCC)               |
	|           33 a 42 - Número Sequencial, sem DV (NNNNNNNNNN)       |
	| 43 a 44 - Tipo de Carteira/Modalidade de Cobrança                |
	+==================================================================+
	*/

	Local cRetorno := ''
	Local nPeso := 2
	Local nSoma := 0
	Local nX

	cValor := strZero(nValor * 100, 10)

	cCodigoBarras := '001'
	cCodigoBarras += '9'
	cCodigoBarras += GetFator()
	cCodigoBarras += cValor

	IF len(alltrim(SEE->EE_CODEMP)) >= 7 //Convenio de 7 digitos
		cCodigoBarras += replicate("0",6)
		cCodigoBarras += alltrim(SEE->EE_CODEMP) + cNossoNumero//SUBSTR(cNossoNumero,1,len(cNossoNumero)-1)
	Else                        //Convenio de 6 digitos
		cNossoNumero := alltrim(SEE->EE_CODEMP) + cNossoNumero
		cNossoNumero := DigVerNossNum(cNossoNum,.T.)
		cCodigoBarras += cNossoNumero //SUBSTR(cNossoNumero,1,len(cNossoNumero)-1)
		cCodigoBarras += strzero(val(SEE->EE_AGENCIA),4)
		cCodigoBarras += strzero(val(SEE->EE_CONTA),8)
	EndIF
	cCodigoBarras += alltrim(SEE->EE_CODCART)

	For nX := len(cCodigoBarras) to 1 step -1
		nSoma += (val(substr(cCodigoBarras, nX, 1)) * nPeso)
		nPeso++
		IF nPeso > 9
			nPeso := 2
		EndIF
	Next nX

	nDigito := 11 - mod(nSoma, 11)

	IF nDigito == 0 .or. nDigito > 9
		nDigito := 1
	EndIF

	cRetorno := ALLTRIM(substr(cCodigoBarras,1,4) + cValToChar(nDigito) + substr(cCodigoBarras,5))

Return cRetorno
/****************************************************
****************************************************/
Static Function BolLinhaDigitavel()

	Local cLinha := ""
	Local cCodigo := ""
	Local cCodigo1 := SEE->EE_CODIGO + IIF(SE1->E1_MOEDA==1,"9","0")

	cLinha  := cCodigo1+ SubSTR(cCodigoBarra,20,5)+Modulo10(cCodigo1+ SubSTR(cCodigoBarra,20,5))+;
					    SubSTR(cCodigoBarra,25,10)+Modulo10(SubSTR(cCodigoBarra,25,10))+;
					    SubSTR(cCodigoBarra,35,10)+Modulo10(SubSTR(cCodigoBarra,35,10))+;
					    SubSTR(cCodigoBarra,5,1)+;
					    SubSTR(cCodigoBarra,6,4)+ SubSTR(cCodigoBarra,10,10)
	cLinha  :=	Transform(cLinha, "@R 99999.99999  99999.999999  99999.999999  9  99999999999999")

Return cLinha
/****************************************************
****************************************************/
Static Function GetFator()

	Local cFator := ""

	cFator := alltrim(str(1000+(SE1->E1_VENCTO-STOD("20000703")),4))

Return cFator
/****************************************************
****************************************************/
User Function b001NossoNum()
	Local cNossoNum := ""
	Local cDig      := ""
	
	cNossoNum := strzero(val(SE1->E1_NUMBCO), IIF(len(alltrim(SEE->EE_CODEMP)) >= 7,10,5) )
	
	/* Atualizado pela MAG_IMPBOL
	IF len(alltrim(SEE->EE_CODEMP)) >= 7
		IF !Empty(SEE->EE_FAXATU)
			cNossoNum := strzero(val(SEE->EE_FAXATU)+1,10)
		Else
			cNossoNum := "0000000001"
		EndIF
	Else
		IF !Empty(SEE->EE_FAXATU)
			cNossoNum := strzero(val(SEE->EE_FAXATU)+1,5)
		Else
			cNossoNum := "00001"
		EndIF
	EndIF
	
	IF !Empty(cNossoNum)
		IF RecLock("SEE",.F.)
			SEE->EE_FAXATU := cNossoNum
			SEE->(MsUnlock())
		EndIF
		IF RecLock("SE1",.F.)
			IF len(alltrim(SEE->EE_CODEMP)) >= 7
				SE1->E1_NUMBCO := cNossoNum
			Else
				SE1->E1_NUMBCO := cNossoNum
			EndIF
			SE1->(MsUnlock())
		EndIF
	EndIF
	*/
Return
/****************************************************
****************************************************/
Static Function DigVerNossNum(cNossoNum,lZero)
	Local cRetorno  := ""
	Local nPeso     := 9
	Local nSoma     := 0
	Local nX

	default lZero := .F.

	For nX := len(cNossoNum) to 1 step -1
		nSoma += val(substr(cNossoNum, nX, 1)) * nPeso
		nPeso--
		IF nPeso < 2
			nPeso := 9
		EndIF
	Next nX

	nDig := Mod(nSoma, 11)

	IF nDig < 10
		cRetorno := cValToChar(nDig)
	ElseIF nDig == 10
		IF lZero
			cRetorno := '0'
		Else
			cRetorno := 'X'
		EndIF
	EndIf

Return cRetorno
/****************************************************
****************************************************/
User Function b001DVNN(cNumero)
default cNumero := alltrim(SE1->E1_NUMBCO)
Return DigVerNossNum( cNumero )
/****************************************************
	Pontilhado para separar os blocos
****************************************************/
Static Function BOLPontilhado(oBoleto, nBloco)
	Local nPont
	//Pontilhado separador
	For nPont := 10 to nLarg+10 Step 4
		oBoleto:Line(nBloco, nPont,nBloco, nPont+2,,)
	Next nPont
Return
/****************************************************
Faz a impressão do titulo, com nome e logo do banco
****************************************************/
Static Function BOLImpTitulo(oBoleto, nBloco, lLinhaDigitavel)
	Local cLogo := "\system\logo-banco-"+SEE->EE_CODIGO+".jpg"
	Default lLinhaDigitavel := .T.

	IF ! File(cLogo)
		//Nome do Banco
		oBoleto:Say(nBloco+33,25,SA6->A6_NREDUZ,oArial12N )
	Else
		//logo
		oBoleto:SayBitmap(nBloco+20, 20, cLogo, 75, 20)
	EndIF
	//Line(linha_inicial, coluna_inicial, linha final, coluna final)
	oBoleto:Line( nBloco+20,  95, nBloco+40,  95,,"01")
	oBoleto:Line( nBloco+20, 146, nBloco+40, 146,,"01")

	//Numero do Banco
	IF SEE->EE_CODIGO == '748' //sicredi
		oBoleto:Say(nBloco+35,99,SEE->EE_CODIGO+'-X' , oArial18N )
	Else
		oBoleto:Say(nBloco+35,99,SEE->EE_CODIGO+'-' + Modulo11(SEE->EE_CODIGO), oArial18N )
	EndIF

	//linha digitavel
	IF lLinhaDigitavel
		oBoleto:SayAlign(nBloco+23,155,cLinhaDigitavel,oArial14,400,,,1)
	Else
		oBoleto:Say(nBloco+35,455,"Recibo do Pagador",oArial09N)
	EndIF
	oBoleto:Line(nBloco+ 40,  20,nBloco+ 40,nLarg,,"01")

Return (nBloco+40)