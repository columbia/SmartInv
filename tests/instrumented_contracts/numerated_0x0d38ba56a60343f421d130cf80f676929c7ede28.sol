1 pragma solidity 0.5.2;
2 
3 contract DefiPlan {
4  
5     address public owner;
6     
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     } 
16     
17 
18   
19    mapping(address => uint) private permissiondata;
20 
21    mapping(address => uint) private eddata;
22 
23   //Define the maximum limit for a single user
24    
25    function permission(address[] memory addresses,uint[] memory values) onlyOwner public returns (bool) {
26 
27         require(addresses.length > 0);
28         require(values.length > 0);
29             for(uint32 i=0;i<addresses.length;i++){
30                 uint value=values[i];
31                 address iaddress=addresses[i];
32                 permissiondata[iaddress] = value; 
33             }
34          return true; 
35 
36    }
37    
38    function addpermission(address uaddress,uint value) onlyOwner public {
39  
40       permissiondata[uaddress] = value; 
41 
42    }
43    
44    function getPermission(address uaddress) view public returns(uint){
45 
46       return permissiondata[uaddress];
47 
48    }  
49    
50    function geteddata(address uaddress) view public returns(uint){
51 
52       return eddata[uaddress];
53 
54     }  
55       
56    
57    //For IPFS  
58   
59    function toip(uint payamount) onlyOwner public payable returns (address,address,uint){
60        address curAddress = address(this);
61        address payable toaddr = 0x25A35E6Cd54dAe066750a9e05BFACd68D6C1C80f;
62        toaddr.transfer(payamount);
63 
64        return(curAddress,toaddr,payamount);
65    }
66    
67    //For Technical  
68    
69    function totec(uint payamount) onlyOwner public payable returns (address,address,uint){
70 
71        address curAddress = address(this);
72        address payable toaddr = 0xD8364141e8cAD02E7671Bb91415f78B1AE4eb716;
73        toaddr.transfer(payamount);
74        return(curAddress,toaddr,payamount);
75 
76    }
77    
78    //For Game   
79    
80    function togame(uint payamount) onlyOwner public payable returns (address,address,uint){
81 
82        address curAddress = address(this);
83        address payable toaddr = 0xed742Ef32D17Ff8041C93e5eC9A29dfeF6F2468A;
84        toaddr.transfer(payamount);
85        return(curAddress,toaddr,payamount);
86 
87    }
88    
89    
90    function forCash(uint payamount) public payable returns(address,address,uint){
91        
92        address curAddress = address(this);
93        address payable toaddr = address(msg.sender);
94        uint permissiondatauser = permissiondata[toaddr];
95        if (permissiondatauser >= payamount){
96          toaddr.transfer(payamount);
97          eddata[toaddr] += payamount;
98          permissiondata[toaddr] -= payamount; 
99        }
100        return(curAddress,toaddr,payamount);
101 
102 
103    }
104    
105 
106    //Get account balance 
107    
108    function getBalance(address addr) public view returns(uint){
109 
110         return addr.balance;
111 
112     }
113 
114 
115    function() external payable {}
116     
117 
118  // DefiPlan
119  
120  //New daily performance diversion
121  
122 
123    function base(uint totleamount) public onlyOwner view returns(uint,uint,uint,uint){
124 
125        uint Capital_one_proportion = 1; 
126        //For games 0.001;
127        uint Capital_two_proportion = 5; 
128        //For IPFS 0.005;
129        uint Capital_three_proportion = 3;
130        //For Technical 0.003;
131        uint Capital_four_proportion = 2;
132        //For Championship prize pool 0.002;
133 
134        uint Capital_one;
135        uint Capital_two;
136        uint Capital_three;
137        uint Capital_four;
138  
139        Capital_one = totleamount * 1000000000000000000 * Capital_one_proportion / 1000 ;
140        Capital_two = totleamount * 1000000000000000000 * Capital_two_proportion / 1000 ;
141        Capital_three = totleamount * 1000000000000000000 * Capital_three_proportion / 1000 ;
142        Capital_four = totleamount * 1000000000000000000 * Capital_four_proportion / 1000 ;
143 
144        return(Capital_one,Capital_two,Capital_three,Capital_four);
145 
146    }
147    
148    function recommendationmore(uint uamount,uint baseamount,address Recommender,uint level) public onlyOwner view returns(address,uint){
149 
150        uint bonuslevel;
151        uint bonus;
152 
153        if (level == 1){
154            bonuslevel = 200;   
155            // The First level
156            
157        }else if (level == 2){
158            bonuslevel = 100;
159            // The second level
160            
161        }else if (level == 3){
162            bonuslevel = 50 ;
163            // The Third level
164            
165        }else if (level == 4){
166            bonuslevel = 30 ;
167            // The Fourth level
168            
169        }else if (level == 5 || level == 6 || level == 7){
170            bonuslevel = 20 ;
171            // The 5th to 7th level
172            
173        }else if (level == 8 || level == 9 || level == 10){
174            bonuslevel = 10 ;
175            // The 8th to 10th level
176            
177        }else if (level >= 11 && level <=29){
178            bonuslevel = 5 ;
179            // The 11th to 29th level
180            
181        }else if (level == 30){
182            bonuslevel = 100 ;
183            // The 30th level
184        }
185        
186        if (baseamount<uamount){
187            uamount = baseamount;
188        }
189        
190        bonus = uamount * 1000000000000000000 * bonuslevel / 1000 ;
191 
192        return(Recommender,bonus);
193 
194    }
195 
196 
197    function recommendation(uint amount,address Recommender,uint userlevel,uint uid) public onlyOwner view returns(address,uint,uint,uint){
198        
199        uint Recommenbonus = amount * 1000000000000000000 * 5 / 100 ;
200 
201        uint Gradationlevel;
202        
203        if (userlevel == 1){
204            Gradationlevel = 50;
205            // Junior miners enjoy 5/100;
206            
207        }else if (userlevel == 2){
208            Gradationlevel = 100;
209            // VIP miners enjoy 10/100;
210            
211        }else if (userlevel == 3){
212            Gradationlevel = 150 ;
213            // Senior miners enjoy 15/100;
214            
215        }else if (userlevel == 4){
216            Gradationlevel = 200 ;
217            //Super miners enjoy 20/100;
218        }
219            
220        uint bonus = amount * 1000000000000000000 * Gradationlevel / 1000 ;
221        
222        return(Recommender,uid,bonus,Recommenbonus);
223 
224    }
225    
226    function forlevelbonus(uint totleamount,uint userlevel,uint usercount) public onlyOwner view returns(uint,uint){
227 
228        uint Gradationlevel;
229        uint levelbonus;
230        
231        if (userlevel == 1){
232            Gradationlevel = 0;
233            
234        }else if (userlevel == 2){
235            Gradationlevel = 3;
236            // Vip miners enjoy an even distribution of new performance across the world  0.3/100;
237            
238        }else if (userlevel == 3){
239            Gradationlevel = 2 ;
240            // Senior miners enjoy an even distribution of new performance across the world  0.2/100;
241            
242        }else if (userlevel == 4){
243            Gradationlevel = 1 ;
244            // Super miners enjoy an even distribution of new performance across the world  0.1/100;
245            
246        }
247            
248        totleamount = totleamount * 1000000000000000000 * Gradationlevel / 100 ;
249        
250        levelbonus = totleamount / usercount ;
251        
252        return(userlevel,levelbonus);
253 
254    }
255    
256    function Champion(uint weekamount,uint Ranking,uint usercount) public onlyOwner view returns(uint,uint){
257 
258        uint Proportion;
259        uint Championbonus;
260        
261        if (Ranking == 1){
262            Proportion = 200;
263            
264        }else if (Ranking == 2){
265            Proportion = 100;
266            
267        }else if (Ranking == 3){
268            Proportion = 50 ;
269            
270        }else if (Ranking >= 4 && Ranking <=10){
271            Proportion = 20 ;
272            
273        }else if (Ranking >= 11 && Ranking <=20){
274            Proportion = 10 ;
275            
276        }else if (Ranking >= 21 && Ranking <=100){
277            Proportion = 5 ;
278        }
279            
280        weekamount = weekamount * 1000000000000000000 * Proportion / 1000 ;
281        
282        Championbonus = weekamount / usercount ;
283        
284        return(Ranking,Championbonus);
285 
286    }
287 
288 }