@echo off
call %OSGEO4W_ROOT%\bin\o4w_env.bat
path %OSGEO4W_ROOT%\apps\qgis-ltr\bin;%PATH%
set QGIS_PREFIX_PATH=%OSGEO4W_ROOT:\=/%/apps/qgis-ltr
set GDAL_FILENAME_IS_UTF8=YES
set VSI_CACHE=TRUE
set VSI_CACHE_SIZE=1000000
set QT_PLUGIN_PATH=%OSGEO4W_ROOT%\apps\qgis-ltr\qtplugins;%OSGEO4W_ROOT%\apps\qt5\plugins
set PYTHONPATH=%PYTHONPATH%;^
%OSGEO4W_ROOT%\apps\qgis-ltr\python;^
%OSGEO4W_ROOT%\apps\qgis-ltr\python\plugins
cd %EMB_DIR%
cmd.exe