% Export SVG to PDF
% Knjiga: Stajni trap letelica
% Autori: Danilo Petrasinovic, Aleksandar Grbovic,
%         Mirko Dinulovic, Milos Petrasinovic
% Masinski fakultet, Univerzitet u Beogradu
% Beograd, 2020
% GNU Octave 5.1.0
% ------------------------
clear all, close all, clc
% --- INPUTS ---
inkscapePath = ['C:\Program Files\Inkscape\bin']; % Absoulte path to Inkscape
% --------------------

disp([' --- ' mfilename ' --- ']);

%% Add folders to PATH
tic
folder = pwd;
setenv('PATH', [inkscapePath pathsep getenv('PATH')]) % add Inkscape to path

%% Select folder
disp(' @exportSVGtoPDF: Izaberite direktorijum...');
dirname = uigetdir(folder,'Izaberite direktorijum');
if(exist(dirname) == 7)
    svgFolder = dirname;
    fileList = {}; j = 0;
    files = dir(svgFolder);
    for i = 1:length(files)
      fileSplit = textscan(files(i).name,'%s','Delimiter','.');
      fileSplit = fileSplit{1};
      if(length(fileSplit) >= 2 && strcmpi(fileSplit(2),'svg'))
        j = j+1;
        fileList{j} = fileSplit{1};
      end
    end

    if(~j)
      errordlg('Nema SVG dokumenata!','GRESKA!');
      error(' @exportSVGtoPDF: Nema SVG dokumenata!');
    end
else
    errordlg('Nije validan direktorijum!','GRESKA!');
    error(' @exportSVGtoPDF: Nije validan direktorijum!');
end

%% Export as PDF
disp(' @exportSVGtoPDF: Exporting as PDF...');
cd(svgFolder);
for i=1:j
  disp([' Export as: ' fileList{i} '.pdf']);
  system(['inkscape ' fileList{i} '.svg  --export-area-drawing '...
    '--export-type=pdf ','--export-filename=' fileList{i} '.pdf']);
end

cd(folder);
disp(' --------------------');

msgbox('The program was executed successfully...','Success!');
disp(' @exportSVGtoPDF: The program was executed successfully... ');
disp([' @exportSVGtoPDF: Execution time: ' num2str(toc,'%.2f') ' seconds']);
disp(' -------------------- ');