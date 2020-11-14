@echo off
::==============================================
::OVH MULTI-DDNS RECORD UPDATER
::Author: Brain System S.r.l.
::Rev 2
::==============================================

GOTO START

:PARAM
:: ############## Parametrizzazione Stringhe e Indirizzi ##################

SET USER=riva.re-test
SET PWD=01Pinguino

SET HOSTN1=nc2.riva.re
SET IPPROD1=1.1.1.1
SET IPBKP1=1.1.1.2

SET HOSTN2=sql.riva.re
SET IPPROD2=2.2.2.1
SET IPBKP2=2.2.2.2

SET HOSTN3=spc.riva.re
SET IPPROD3=3.3.3.1
SET IPBKP3=3.3.3.2

SET HOSTN4=subnet.riva.re
SET IPPROD4=4.4.4.1
SET IPBKP4=4.4.4.2

:: IP PRODUZIONE e BACKUP

SET PRODIP=79.54.88.215
SET BKPIP=79.54.88.213

:: ########################################################################
GOTO CASE

:: Recupero file contenente attuale IP Pubblico, Salvato in temp e poi in variabile PUBIP. Se L'IP attuale è uguale al precedente esco e non aggiorno i record
:START
wget --timeout=10 -q -O %temp%\MyIP http://myexternalip.com/raw
set /p PUBIP=<%temp%\MyIP
set /p ACTIP=<ActiveIP

IF %PUBIP%==%ACTIP% GOTO END
echo %PUBIP% > ActiveIP
GOTO PARAM

:: Case
:CASE
IF %PUBIP%==%PRODIP% GOTO PROD
IF %PUBIP%==%BKPIP% GOTO BKP
GOTO END

:: Setto Record OVH, salvo in temp l'ultima modifica

:PROD
::RECORD1
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN1%&myip=%IPPROD1%"
wget -O %temp%\lastmod %WSTRING%
::RECORD2
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN2%&myip=%IPPROD2%"
wget -O %temp%\lastmod %WSTRING%
::RECORD3
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN3%&myip=%IPPROD3%"
wget -O %temp%\lastmod %WSTRING%
::RECORD4
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN4%&myip=%IPPROD4%"
wget -O %temp%\lastmod %WSTRING%
GOTO END

:BKP
::RECORD1
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN1%&myip=%IPBKP1%"
wget -O %temp%\lastmod %WSTRING%
::RECORD2
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN2%&myip=%IPBKP2%"
wget -O %temp%\lastmod %WSTRING%
::RECORD3
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN3%&myip=%IPBKP3%"
wget -O %temp%\lastmod %WSTRING%
::RECORD4
SET WSTRING="http://%USER%:%PWD%@www.ovh.com/nic/update?system=dyndns&hostname=%HOSTN4%&myip=%IPBKP4%"
wget -O %temp%\lastmod %WSTRING%
GOTO END

:: Pulizia temp e uscita

:END
if exist %temp%\MyIP del %temp%\MyIP
if exist %temp%\lastmod del %temp%\lastmod
exit