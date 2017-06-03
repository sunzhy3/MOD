function [res] = isCovered(bbox1, bbox2)
% �ж��������ο��Ƿ����ص�����
% bbox1: bounding box 1
% bbox2: bounding box 2
% res: equals to 1 when the two bounding boxes covered.

p1 = int16([bbox1(1), bbox1(2)]);
p2 = int16([bbox1(1) + bbox1(3), bbox1(2)+ bbox1(4)]);
p3 = int16([bbox2(1), bbox2(2)]);
p4 = int16([bbox2(1) + bbox2(3), bbox2(2)+ bbox2(4)]);

if p2(2) >= p3(2) && p1(2) <= p4(2) && p2(1) >= p3(1) && p1(1) <= p4(1)
     res = 1;
else
     res = 0;
end

end

