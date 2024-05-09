1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) { 
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     } 
21 }
22 
23  library SafeMath8{
24      function add(uint8 a, uint8 b) internal pure returns (uint8) {
25         uint8 c = a + b;
26         require(c >= a);
27 
28         return c;
29     } 
30 
31     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
32         require(b <= a);
33         uint8 c = a - b;
34         return c;
35     }
36 
37  }
38 
39  library SafeMath16{
40      function add(uint16 a, uint16 b) internal pure returns (uint16) {
41         uint16 c = a + b;
42         require(c >= a);
43 
44         return c;
45     }
46 
47     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
48         require(b <= a);
49         uint16 c = a - b;
50         return c;
51     }
52 
53      function mul(uint16 a, uint16 b) internal pure returns (uint16) {
54         if (a == 0) {
55             return 0;
56         }
57         uint16 c = a * b;
58         require(c / a == b);
59         return c;
60     }
61 
62     function div(uint16 a, uint16 b) internal pure returns (uint16) {
63         require(b > 0);
64         uint16 c = a / b;
65         return c;
66     }
67  }
68 
69 library Address {
70 
71     function isContract(address account) internal view returns (bool) {
72         uint256 size;
73         assembly { size := extcodesize(account) }
74         return size > 0;
75     }
76 }
77 
78 interface master{
79     function inquire_location(address _address) external view returns(uint16, uint16);
80     function inquire_slave_address(uint16 _slave) external view returns(address);
81     function inquire_land_info(uint16 _city, uint16 _id) external view returns(uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8,uint8);
82     function domain_attribute(uint16 _city,uint16 _id, uint8 _index) external;
83     
84     function inquire_tot_attribute(uint16 _slave, uint16 _domain) external view returns(uint8[5]);
85      
86     function inquire_owner(uint16 _city, uint16 id) external view returns(address);
87     
88 }
89 
90  interface material{
91      function control_burn(uint8 boxIndex, uint8 materialIndex, address target, uint256 amount) external;
92  }
93  
94 
95 contract owned{
96 
97     address public manager;
98 
99     constructor() public{
100         manager = msg.sender;
101     }
102 
103     modifier onlymanager{
104         require(msg.sender == manager);
105         _;
106     } 
107 
108     function transferownership(address _new_manager) public onlymanager {
109         manager = _new_manager;
110     }
111 
112 }
113 
114 contract mix is owned{   
115     
116     event mix_result(address indexed player, bool result, uint16 rate); 
117 
118     address arina_address = 0xe6987cd613dfda0995a95b3e6acbabececd41376;
119     address master_address = 0x0ac10bf0342fa2724e93d250751186ba5b659303;
120     
121     address material_contract = 0x65844f2e98495b6c8780f689c5d13bb7f4975d65;  
122     
123     uint16[5] paramA;
124     uint16[5] paramB; 
125     uint16[5] paramC; 
126     uint16[5] paramD;
127     uint16[5] paramE; 
128     uint16[5] paramF;
129 
130     
131     constructor() public{
132         paramA=[50,30,10,5,1];
133         paramB=[100,50,30,10,5]; 
134         paramC=[200,100,50,30,10];
135         paramD=[300,150,100,50,30];
136         paramE=[400,200,150,100,50];
137         paramF=[500,300,200,150,100]; 
138 
139     } 
140      
141     using SafeMath for uint256;
142     using SafeMath16 for uint16;
143     using SafeMath8 for uint8;
144     using Address for address;
145     
146     function set_material_contract(address _material_contract) public onlymanager{
147         material_contract = _material_contract;
148     }
149     
150     function set_master(address _new_master) public onlymanager {
151         master_address = _new_master;
152     } 
153     
154      
155     
156     function materialMix(uint16 city,uint16 id,uint8 proIndex, uint8[] mixArray) public {
157     
158         require(msg.sender == master(master_address).inquire_owner(city,id));
159         (uint16 _city,uint16 _id) = master(master_address).inquire_location(msg.sender);
160         require(city == _city && id == _id);
161          
162         uint8 produce;        
163         uint8 attribute; 
164         uint8 index2;         
165         uint16 total = 0;     
166         uint16 random = uint16((keccak256(abi.encodePacked(now, mixArray.length))));
167   
168          
169         if(proIndex == 1){
170             (produce,,,,,,,,,) = master(master_address).inquire_land_info(city,id);
171              
172         }else if(proIndex == 2){
173             (,produce,,,,,,,,) = master(master_address).inquire_land_info(city,id);
174         }else if(proIndex == 3){
175             (,,produce,,,,,,,) = master(master_address).inquire_land_info(city,id);
176         }else if(proIndex == 4){
177             (,,,produce,,,,,,) = master(master_address).inquire_land_info(city,id);
178         }else{
179             (,,,,produce,,,,,) = master(master_address).inquire_land_info(city,id);
180         }
181 
182         attribute = produce.add(master(master_address).inquire_tot_attribute(city,id)[(proIndex-1)]);
183         
184         require(attribute>=0 && attribute < 10);
185          
186         
187         if( attribute < 2)
188             index2 = 0;
189         else if(attribute > 1 && attribute < 4)
190             index2 = 1; 
191         else if(attribute > 3 && attribute < 6)
192             index2 = 2;
193         else if(attribute > 5 && attribute < 8)
194             index2 = 3;
195         else
196             index2 = 4; 
197             
198         for( i=0;i<mixArray.length;i++){          
199             total = total.add(getParam(mixArray[i],index2));
200         }    
201   
202         for(uint8 i=0;i < mixArray.length; i++){                        
203             
204             if(proIndex == 2){
205                 mixArray[i] = mixArray[i]%30;
206             }else if(proIndex == 3){
207                 mixArray[i] = mixArray[i]%40;
208             }else if(proIndex == 4){
209                 mixArray[i] = mixArray[i]%60;
210             }else if(proIndex == 5){
211                 mixArray[i] = mixArray[i]%68;
212             }
213 
214 
215              material(material_contract).control_burn((proIndex-1),(mixArray[i]-1),msg.sender,1);
216         }  
217 
218         
219 
220 
221         if((random%1000) <= total){
222             
223             master(master_address).domain_attribute(city, id, (proIndex-1));
224             emit mix_result(msg.sender,true,total);
225             
226         } else{
227             emit mix_result(msg.sender,false,total);
228         }
229     
230     }
231     
232      
233     function getParam(uint index1,uint16 index2) private view returns(uint16){     
234            
235            if(index1<6 || index1==31 || index1==32 || (index1>40 && index1<46) || index1==61 || index1==62 || (index1>68 && index1<74)){
236                return paramA[index2];
237            }else if((index1>5 && index1<11) || index1==33 || index1==34 || (index1>45 && index1<51) || index1==63 || index1==64 || (index1>73 && index1<79)){
238                return paramB[index2];
239            }else if((index1>10 && index1<16) || index1==35 || index1==36 || (index1>50 && index1<56) || index1==65 || index1==66 || (index1>78 && index1<84)){
240                return paramC[index2];
241            }else if((index1>15 && index1<21) || index1==37 || index1==38 || (index1>55 && index1<61)|| (index1>83 && index1<89)){
242                return paramD[index2];
243            }else if((index1>25 && index1<31) || index1==39 || index1==40 || index1==67 || index1==68){
244                return paramF[index2];
245            }else{
246                return paramE[index2];
247            }
248     }
249     
250 
251     
252     
253     
254 }