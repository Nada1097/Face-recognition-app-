function varargout = GUIfig(varargin)
% GUIFIG MATLAB code for GUIfig.fig
%      GUIFIG, by itself, creates a new GUIFIG or raises the existing
%      singleton*.
%
%      H = GUIFIG returns the handle to a new GUIFIG or the handle to
%      the existing singleton*.
%
%      GUIFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFIG.M with the given input arguments.
%
%      GUIFIG('Property','Value',...) creates a new GUIFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIfig

% Last Modified by GUIDE v2.5 01-May-2020 07:13:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIfig_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIfig_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUIfig is made visible.
function GUIfig_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIfig (see VARARGIN)

% Choose default command line output for GUIfig
handles.output = hObject;
axes(handles.axes3);
imshow('a.png');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIfig_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(~, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a;
global filename;
global pathname;
[filename, pathname] = uigetfile({'*.pgm';'*.bmb';'*.jpg';'*.gif';'*.*'}, 'Pick an image file');
a = imread(strcat(pathname,filename));
axes(handles.axes1);
imshow(a);
title('Input Image');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%upload the data of images 
%DataSet = imageSet('dataset','recursive');
global a;
b = a;
b = reshape(b,size(b,1)*size(b,2),1);

images = load_database();
 
%choose random image to definy and other images save them in seprate
%varibale 
index = round(400*rand(1,1)); %create and choose index images for 400 images at 1D matrix 
%%%random_img = images(:,index); %one image to be choose to test 
random_img = b;
rest_imgs = images(:,[1:index-1 index+1:end]);

%to calcute mean value of images 

image_empty = uint8(ones(1,size(rest_imgs,2)));
mean_value = uint8(mean(rest_imgs,2));
mean_remove=rest_imgs-uint8(single(mean_value)*single(image_empty));
value=single(mean_remove)'*single(mean_remove); %define variable value as single as standard 
% get signture and eignvalues of each image to identify it 
[x,y] = eig(value); %calcute eignvalue 
x=single(mean_remove)*x;
image_sig=20;
x=x(:,end:-1:end-(image_sig-1));
rest_img_sig=zeros(size(rest_imgs,2),image_sig);
%loop for get signture of all images 
for i=1:size(rest_imgs,2)
    rest_img_sig(i,:)=single(mean_remove(:,i))'*x;
end

%%%subplot(121);
%%%imshow(reshape(random_img,112,92));
%%%title('test image','FontWeight','bold','Fontsize',18,'color','red');
%%%subplot(122);
axes(handles.axes2);

%remove mean value from random image 
diff=random_img-mean_value;
s=single(diff)'*x;
z=[];
for i=1:size(rest_imgs,2)
    z=[z,norm(rest_img_sig(i,:)-s,2)];
    if(rem(i,20)==0),imshow(reshape(rest_imgs(:,i),112,92)),end
    drawnow;
end
[a,i]=min(z);
%%%subplot(122);
%%%imshow(reshape(rest_imgs(:,i),112,92));
%%%title('Recognition image','FontWeight','bold','Fontsize',18,'color','red');

imshow(reshape(rest_imgs(:,i),112,92));
title('Matched face');
