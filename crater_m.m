function [ImageDot]=creater_m(ImageInput,thres,area,bin)
    ima=double(ImageInput);
    bind=double(bin);
    %ima=ImageInput.*bind;
    imshow(ima,[]);
    p=numel(ImageInput)/sum(sum(bind));
    imb=ima.*bind;
    imb(imb>mean(mean(imb))*p)=mean(mean(imb))*p;
    ima=ima./(mean(mean(imb))*p*2);
    imshow(ima,[0,1]);
    sedge=ImageEdgeFind(ima);
    bb=zeros(size(sedge));
    bb(2:end-1,2:end-1)=sedge(2:end-1,2:end-1);
    nn=imbinarize(bb,thres);
    nn=nn&bin;
    nn=bwareaopen(nn,area);
    imshow(nn);
    uy=bwboundaries(nn);
    ImageDot=zeros(4,size(uy,1));
    for i=1:size(uy,1)
            ImageDot(1,i)=mean(uy{i}(:,1));
            ImageDot(2,i)=mean(uy{i}(:,2));
            ImageDot(3,i)=(max(uy{i}(:,1))-min(uy{i}(:,1))+1)*(max(uy{i}(:,2))-min(uy{i}(:,2))+1);
    end
    ImageDot=ImageDot';
    ImageDot(:,4)=sqrt(ImageDot(:,3))/2048*1738/180*pi*0.85;
end
function [ImageEdge]=ImageEdgeFind(InputImage)
%     OperatorX=[
%         -1	0	1
%         -2	0	2
%         -1	0	1
%         ];
%     OperatorY=[
%         1	2	1
%         0	0	0
%         -1	-2	-1
%         ];
    InitImgSize=size(InputImage);
%     EdgeX=zeros(InitImgSize(1)-2,InitImgSize(2)-2);
%     EdgeY=zeros(InitImgSize(1)-2,InitImgSize(2)-2);
%     for i=1:InitImgSize(1)-2
%         for j=1:InitImgSize(2)-2
%             EdgeX(i,j)=sum(sum(InputImage(i:i+2,j:j+2).*OperatorX));
%             EdgeY(i,j)=sum(sum(InputImage(i:i+2,j:j+2).*OperatorY));
%         end
%     end
    
    ImgPlus=zeros(InitImgSize+[2 2]);
    ImgPlus(2:InitImgSize(1)+1,2:InitImgSize(2)+1)=InputImage;
    ImgUL=ImgPlus(1:InitImgSize(1),1:InitImgSize(2));
    ImgUM=ImgPlus(2:InitImgSize(1)+1,1:InitImgSize(2));
    ImgUR=ImgPlus(3:InitImgSize(1)+2,1:InitImgSize(2));
    ImgML=ImgPlus(1:InitImgSize(1),2:InitImgSize(2)+1);
    ImgMR=ImgPlus(3:InitImgSize(1)+2,2:InitImgSize(2)+1);
    ImgDL=ImgPlus(1:InitImgSize(1),3:InitImgSize(2)+2);
    ImgDM=ImgPlus(2:InitImgSize(1)+1,3:InitImgSize(2)+2);
    ImgDR=ImgPlus(3:InitImgSize(1)+2,3:InitImgSize(2)+2);
    EdgeX=-ImgUL-2*ImgML-ImgDL+ImgUR+2*ImgMR+ImgDR;
    EdgeY=ImgUL+2*ImgUM+ImgUR-ImgDL-2*ImgDM-ImgDR;
    
%     i=1:InitImgSize(1)-2;
%     j=1:InitImgSize(2)-2;
%             EdgeX(i,j)=sum(sum(InputImage(i:i+2,j:j+2).*OperatorX));
%             EdgeY(i,j)=sum(sum(InputImage(i:i+2,j:j+2).*OperatorY));
    ImageEdge=sqrt(EdgeX.^2+EdgeY.^2); 
%     ImageEdge=zeros(InitImgSize);
%     ImageEdge(1:InitImgSize(1)+1,2:InitImgSize(2)+1)=ImageEdgeTemp;
end
