1 pragma solidity 0.5.7;
2 
3 interface AddrMInterface {
4      function getAddr(string calldata name_) external view returns(address);
5 }
6 
7 interface ERC20 {
8   function balanceOf(address) external view returns (uint256);
9   function transferFrom(address, address, uint256) external returns (bool);
10   function transfer(address _to, uint256 _value) external returns (bool success);
11   function ticketGet() external ;
12   function allowance(address _owner, address _spender) external view returns (uint256 remaining);
13 }
14 
15 interface mPoolInterface{
16     function setAmbFlag(address ply_) external;
17 }
18 
19 
20 
21 contract Ticket{
22     
23     //address manager 
24     AddrMInterface public addrM;
25     bool public fristTime;
26     address public owner;
27     
28     ERC20 tokenADC;
29     
30     // change rule
31     
32     mapping(uint8 => uint256) private changeRatio;
33     mapping(uint8 => uint256) public RemainAmount; // changeAmount - this lava cost
34     uint256 public totalCheckOut; // already check out ADC acount
35     uint8 public curentLevel;
36    
37     // constant set 
38     uint256 constant public totalBalance = 153000000*10**18;
39     uint256 constant public minInPay  = 5*10**16;// 1 * 5% eth
40     uint256 constant public OutPay  =   1*10**17;// 1 * 10% eth
41     address payable constant public  teamAddr = address(0x1d13502CfB73FCa360d1af7703cD3F47abA809b5);//
42     
43     
44     
45     
46     constructor(address AddrManager_) public{
47         owner = msg.sender;
48         addrM = AddrMInterface(AddrManager_);
49         tokenADC = ERC20(addrM.getAddr("ADC"));
50         
51         fristTime = false;
52         
53         curentLevel = 1;
54         totalCheckOut = 0;
55         
56         RemainAmount[1] =  1000000000000000000000000;
57         RemainAmount[2] =  2000000000000000000000000;
58         RemainAmount[3] =  3000000000000000000000000;
59         RemainAmount[4] =  4000000000000000000000000;
60         RemainAmount[5] =  5000000000000000000000000;
61         RemainAmount[6] =  6000000000000000000000000;
62         RemainAmount[7] =  7000000000000000000000000;
63         RemainAmount[8] =  8000000000000000000000000;
64         RemainAmount[9] =  9000000000000000000000000;
65         RemainAmount[10] = 10000000000000000000000000;
66         RemainAmount[11] = 11000000000000000000000000;
67         RemainAmount[12] = 12000000000000000000000000;
68         RemainAmount[13] = 13000000000000000000000000;
69         RemainAmount[14] = 14000000000000000000000000;
70         RemainAmount[15] = 15000000000000000000000000;
71         RemainAmount[16] = 16000000000000000000000000;
72         RemainAmount[17] = 17000000000000000000000000;
73         
74         changeRatio[1] = 7000000000000000000000;
75         changeRatio[2] = 6000000000000000000000;
76         changeRatio[3] = 5000000000000000000000;
77         changeRatio[4] = 4000000000000000000000;
78         changeRatio[5] = 3000000000000000000000;
79         changeRatio[6] = 2000000000000000000000;
80         changeRatio[7] = 1000000000000000000000;
81         changeRatio[8] = 500000000000000000000;
82         changeRatio[9] = 250000000000000000000;
83         changeRatio[10] = 125000000000000000000;
84         changeRatio[11] = 60000000000000000000;
85         changeRatio[12] = 30000000000000000000;
86         changeRatio[13] = 15000000000000000000;
87         changeRatio[14] = 8000000000000000000;
88         changeRatio[15] = 4000000000000000000;
89         changeRatio[16] = 2000000000000000000;
90         changeRatio[17] = 1000000000000000000;
91  
92     }
93     
94 
95     function buyADC() public payable{
96         uint256 msgValue = msg.value;
97         uint256 adcAmount;
98         uint256 saleADC;
99         
100         if(!fristTime){
101             tokenADC.ticketGet();
102             fristTime = true;
103         }
104         require(msgValue >= minInPay," value to smail buyADC");
105         require((totalBalance-totalCheckOut) == tokenADC.balanceOf(address(this)),"balance not right");
106         
107         saleADC = (msgValue* changeRatio[curentLevel])/10**18; //msgValue.div(10**18).mul(changeRatio[curentLevel]);
108         
109         teamAddr.transfer(msgValue);
110         adcAmount = CrossLevel(saleADC,msgValue);
111         
112         tokenADC.transfer(msg.sender,adcAmount);
113         
114         if(msgValue >= 100*10**18){
115             mPoolInterface(addrM.getAddr("MAINPOOL")).setAmbFlag(msg.sender);
116         }
117         
118         totalCheckOut += adcAmount;
119         
120     }
121     
122     function calDeductionADC(uint256 _value,bool isIn_) public view returns(uint256 disADC_){
123         
124         uint256 ticketValue ;
125         uint256 tempAdc;
126         disADC_ = 0;
127         if(isIn_){
128            ticketValue = _value * 5 /100; 
129         }else{
130            ticketValue = _value * 5 /100; 
131         }
132     
133         //require(_value >= 1*10**17,"_value to smail calDeductionADC");
134         
135         tempAdc = (ticketValue*changeRatio[curentLevel])/10**18;
136         disADC_ = calcDistroy(tempAdc,ticketValue);
137     }
138     
139     function getTickeInfo() public view returns(uint256 curLevel_,uint256 distroyADCAmount_){
140         curLevel_ = curentLevel;
141         distroyADCAmount_ = totalCheckOut;
142     }
143     
144     function CrossLevel(uint256 saleADC_,uint256 buyValue_) internal  returns(uint256 disAdc){
145         if(RemainAmount[curentLevel] > saleADC_){
146             RemainAmount[curentLevel] -=saleADC_;
147             disAdc = saleADC_;
148             return disAdc;
149         }else{
150             disAdc = RemainAmount[curentLevel];
151             uint256 newLevelRemian;
152             uint256 value = buyValue_;
153             uint256 subValue;
154             for(uint8 i=curentLevel+1; i<17; i++){
155                 curentLevel = i;
156                 subValue = (RemainAmount[i-1]*10**18)/changeRatio[i-1];
157                 newLevelRemian = ((value- subValue)*changeRatio[i])/10**18;
158                 if(newLevelRemian < RemainAmount[i]){
159                     disAdc += newLevelRemian;
160                     RemainAmount[i] -= newLevelRemian;
161                     return disAdc;
162                 }
163                 disAdc += RemainAmount[i];
164                 value -= subValue;
165             }
166         }
167     }
168     
169     function calcDistroy(uint256 saleADC_,uint256 buyValue_) internal view returns(uint256 disAdc){
170         if(RemainAmount[curentLevel] > saleADC_){
171             
172             disAdc = saleADC_;
173            return disAdc;
174         }else{
175             disAdc = RemainAmount[curentLevel];
176             uint256 newLevelRemian;
177             uint256 value = buyValue_;
178             uint256 subValue;
179             for(uint8 i=curentLevel+1; i<17; i++){
180                 subValue = (RemainAmount[i-1]*10**18)/changeRatio[i-1];
181                 newLevelRemian = ((value- subValue)*changeRatio[i])/10**18;
182                 if(newLevelRemian < RemainAmount[i]){
183                     disAdc += newLevelRemian;
184                     return disAdc;
185                 }
186                 disAdc += RemainAmount[i];
187                 value -= subValue;
188             }
189         }
190     }
191 
192 }