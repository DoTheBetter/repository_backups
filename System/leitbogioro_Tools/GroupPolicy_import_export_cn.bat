@echo off

::������ɫ
color DE

echo ������Ա���...
net session >nul 2>&1
if %errorLevel% == 0 (
        goto continue
) else (
        echo,
        echo ���Թ���Ա������иýű���
        echo ��������˳�...
        pause > nul
        exit
)

:continue

::�����ӳٱ���
SetLocal EnableDelayedExpansion

::��ȡϵͳ�汾
for /f "tokens=1* delims=[" %%a in ('ver') do (
    set b=%%b
)

::���汾��Ϣ��ֵ������b
set b=%b:* =%

::����ϵͳ�汾���������ļ���
for /f "tokens=1,3 delims=*." %%a in ("%b%") do (
    set ver1=!ver1!_%%a
    set ver3=!ver3!_%%b
)

for /f "tokens=2 delims=*." %%a in ("%b%") do (
    set ver2=!ver2!_%%a
)

set version=!ver1!!ver2!!ver3!

:: ����
set db_name=%set
set gp_name="%UserProfile%\Desktop\gp_config%version%\%db_name%.inf"
set gp_folder="%UserProfile%\Desktop\gp_config%version%\"
set gp_file="%Windir%\System32\GroupPolicy"
set gp_export_file="%UserProfile%\Desktop\GroupPolicy"
set logs="%WinDir%\security\logs\scesetup.log"

echo,
echo   ��____��
echo   (���ء�)�ĩ� ��..*��
echo  ��     ��
echo * * * ��ӭ��������Թ����� copyright by Molly Lau * * *
echo * ���`�`��                                              *     
echo *                                                       *
echo *   ʹ����֪��                                          *
echo *                                                       *
echo *   �� ֻ֧�ֵ����ɱ��ű�Ԥ�ȵ�����������ļ�           *
echo *   �� ����������ļ���ϵͳ�ڲ��汾���ϸ��Ӧ           *
echo *   �� ��֧�ֵ����뵱ǰ�汾ϵͳ��ͬ������������ļ�     *
echo *   �� ����ע��������ļ����̲����棬����˼��������     *
echo *   �� ������֧�����¹��ܣ�                             *
echo *                                                       *
echo *                    1. ���������                      *
echo *                                                       *
echo *                    2. ���������                      *
echo *                                                       *
echo *                      �س����˳�                       *
echo *                                                       *
echo *                                                       *
echo * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
echo,
set /p ask1=��ѡ������Ҫ�Ĳ���(1/2/�س���)��
if "%ask1%"=="1" (
    goto export_gp
) else (
    if "%ask1%"=="2" (
        goto import_gp
    ) else (
          exit
    )
)

::���������
:export_gp
if exist %gp_folder% (
    rd /s /Q %gp_folder%
)
mkdir %gp_folder%
echo,
echo ���ڵ�����һ���ֵİ�ȫ����...
secedit /export /cfg %gp_name%
echo,
echo ���ڵ������а�ȫ���������...
xcopy /e /h /r /y %gp_file% %gp_export_file%\
echo,
echo ���ڹ鵵�ļ�...
attrib -h %gp_export_file%
move %gp_export_file% %gp_folder%
echo,
echo ����������ѵ�����%gp_folder%�ļ��У�
echo,
echo ����������־...
if exist logs del %logs%
echo,
set /p ask2=�Ƿ���Ҫ�򿪲鿴��y �鿴/n �˳�����
if /i "%ask2%"=="n" exit
if /i "%ask2%"=="y" explorer %gp_folder%
exit

::���������
:import_gp
echo,
if exist %gp_folder% (
    if exist %gp_name% (
        if exist %gp_folder%GroupPolicy (
            echo ���ڵ����һ���ֵİ�ȫ����...
            secedit /configure /db %db_name%.sdb /CFG %gp_name%
            echo,
            echo ���ڵ������а�ȫ���������...
            xcopy /e /h /r /y %gp_folder%GroupPolicy %gp_file%
            echo,
            echo ˢ�������...
            gpupdate /force
            echo ����������ѵ����ɹ���
            echo,
            echo ����������ʱ�ļ�����־...
            del %db_name%.jfm
            del %db_name%.sdb
            if exist logs del %logs%
            echo,
            echo ���س����˳�...           
            pause > nul
            exit     
        ) else (
              echo ��GroupPolicy���ļ��в����ڣ�
              pause 
        )
    ) else (
          echo ��%db_name%.inf���ļ������ڣ�
          pause    
    )
) else (
    echo ��¼����Թ�����ļ��в����ڻ�����������ϵͳ��
    pause
)