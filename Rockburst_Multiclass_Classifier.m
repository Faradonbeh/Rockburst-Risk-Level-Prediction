function result = gepModel(d)

%Constant values for the class Light 
G1C2 = 8.85433515427107;
G2C6 = 3.81878109073153;
G2C5 = 6.03137302774133;
G3C6 = -1.40766624958037; 

%Constant values for the class Moderate 
G2C6_2 = -3.29264198736534;
G2C8 = 2.89651173436689;
G3C6_2 = -7.30521561326945;
G3C8 = -6.58314767906735;

%Constant values for the class Severe 
G1C3 = 3.2281655323954;
G2C6_3 = -0.61860103152562;
G2C8_3 = 3.4934537797174;
G2C1 = 6.96214789269692;

d=[48 94.7 5.26 2.96]; %Input values 

d = Normalize_01(d);

y = 0.0;

% Probability of class Light
y = ((d(4)-((10^d(2))+G1C2))+(tan(d(2))+sin(d(4))));
y = y * ((((G2C5-d(4))*d(2))*(d(4)+G2C6))-((d(3)^3)*gep3Rt(d(2))));
y = y * tan(((G3C6+((((d(1)*d(2))^2)+((d(1)*d(3))+d(1)))/2.0))/2.0));
SLOPE = 0.202999260626246;
INTERCEPT = -13.7154548292569;
Light = 1.0 / (1.0 + exp(-(SLOPE * y + INTERCEPT)))

% Probability of class Moderate
y = 0.0;
y = atan(d(3));
y = y * (((atan((d(4)-G2C8))+(d(1)^3))+((d(1)^4)-(G2C6_2*d(2))))/2.0);
y = y * (((cos(d(1))+(G3C8^3))-(d(1)+G3C6_2))-((G3C8-d(1))^4));
SLOPE = 4.64044202196121E-03;
INTERCEPT = 0.011916313375671;
Moderate = 1.0 / (1.0 + exp(-(SLOPE * y + INTERCEPT)))

% Probability of class Severe
y = 0.0;
y = (((((d(3)+d(3))/2.0)^4)-gep3Rt(d(3)))+((G1C3+d(4))+sin(d(1))));
y = y * gep3Rt(((((d(1)-G2C6_3)+sin(G2C8_3))*atan((G2C1-d(2))))^4));
y = y * reallog(exp((asin(sin((exp(d(2))-(d(1)-d(1)))))^3)));
SLOPE = 1.40623422254726;
INTERCEPT = -14.3565928871206;
Severe = 1.0 / (1.0 + exp(-(SLOPE * y + INTERCEPT)))

%Final output
components = [Light, Moderate, Severe];
[maxValue, maxIndex] = max(components);
switch maxIndex
    case 1
        label = 'Light';
    case 2
        label = 'Moderate';
    case 3
        label = 'Severe';
end
disp(['Maximum Probability= ' num2str(maxValue) ' & Predicted Risk Level= ' label]);

%gep3Rt(x) function
function result = gep3Rt(x)
if (x < 0.0),
    result = -((-x)^(1.0/3.0));
else
    result = x^(1.0/3.0);
end

% Normalization function
function result = Normalize_01(inputData)
MIN_1 = 2.6;
MAX_1 = 127.6;  
inputData(1) = (inputData(1) - MIN_1) / (MAX_1 - MIN_1);
MIN_2 = 20.0;
MAX_2 = 263.0;
inputData(2) = (inputData(2) - MIN_2) / (MAX_2 - MIN_2);
MIN_3 = 1.3;
MAX_3 = 22.6;
inputData(3) = (inputData(3) - MIN_3) / (MAX_3 - MIN_3);
MIN_4 = 0.81;
MAX_4 = 10.9;
inputData(4) = (inputData(4) - MIN_4) / (MAX_4 - MIN_4);
result = inputData;

