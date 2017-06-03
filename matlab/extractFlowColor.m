function [ H ] = extractFlowColor( flow_img, imBw )
%EXTRACTFLOWCOLOR Summary of this function goes here
%   Detailed explanation goes here

bins=10;
gaps=256/bins;

A=flow_img(:,:,1);
B=flow_img(:,:,2);
C=flow_img(:,:,3);

A(~imBw)=0;
B(~imBw)=0;
C(~imBw)=0;

% out=cat(3,A,B,C);

% D=[A(:),B(:),C(:)];
% D=[A(:),C(:),B(:)];
% D=[B(:),A(:),C(:)];
% D=[B(:),C(:),A(:)];
% D=[C(:),B(:),A(:)];
% D=[C(:),A(:),B(:)];
A1=A(imBw);
B1=B(imBw);
C1=C(imBw);
A1=std(double(A1));
B1=std(double(B1));
C1=std(double(C1));

[~,ind]=sort([A1,B1,C1]);
D=[A(:),B(:),C(:)];
D=[D(:,ind(1)),D(:,ind(2)),D(:,ind(3))];

D=floor(double(D)/gaps);
E=uint16((D(:,1)*100+D(:,2)*10+D(:,3)));

H=zeros(bins*bins*bins,1);

for i=1:length(E)
    if E(i)==0
        continue;
    end
    H(E(i))=H(E(i))+1;
end

end

