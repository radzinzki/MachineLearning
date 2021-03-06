function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 06-Apr-2014 22:04:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in showGraphs.
function showGraphs_Callback(hObject, eventdata, handles)
% hObject    handle to showGraphs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in takePictureButton.
function takePictureButton_Callback(hObject, eventdata, handles)
% hObject    handle to takePictureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if(webcamUpsideDown == 1)
    global vid;
    imageSnapshot = getsnapshot(vid);
    inputImage = im2double(imrotate(rgb2gray(imageSnapshot), 0));
%else
%    inputImage = im2double(getsnapshot(vid));
%end
    stop(vid);
    faceDetect = vision.CascadeObjectDetector;
    boundingBox = step(faceDetect, inputImage);
    [row, column] = size(boundingBox);
    imageArray = zeros(10000,row);
    hold on
    title('Face Detection');
    hold off;
    for i = 1:size(boundingBox,1)
        rectangle('Position', boundingBox(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
        imageBeforeReshape = histeq(imresize(imcrop(inputImage, boundingBox(i,:)), [100 100]));
        figure(); imshow(imageBeforeReshape, []);
        imwrite(imageBeforeReshape, strcat('test',num2str(i),'.jpg'));
        imageArray(:,i) = reshape(imageBeforeReshape,[],1);
    end
    imageReturn = webcamProcessing(imageSnapshot, imageArray);
% --- Executes on button press in openCameraButton.
function openCameraButton_Callback(hObject, eventdata, handles)
% hObject    handle to openCameraButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    info = imaqhwinfo('winvideo', 1);
    global vid;
    vid = videoinput('winvideo', 1, info.DefaultFormat);
    preview(vid);
    start(vid);
    set(vid, 'ReturnedColorSpace', 'rgb');
