1 pragma solidity ^0.5.2;
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
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 
21   
22    mapping(address => uint) private permissiondata;
23 
24    mapping(address => uint) private eddata;
25 
26   //Define the maximum limit for a single user
27    
28    function permission(address[] memory addresses,uint[] memory values) onlyOwner public returns (bool) {
29 
30         require(addresses.length > 0);
31         require(values.length > 0);
32             for(uint32 i=0;i<addresses.length;i++){
33                 uint value=values[i];
34                 address iaddress=addresses[i];
35                 permissiondata[iaddress] = value; 
36             }
37          return true; 
38 
39    }
40    
41    function addpermission(address uaddress,uint value) onlyOwner public {
42  
43       permissiondata[uaddress] = value; 
44 
45    }
46    
47    function getPermission(address uaddress) view public returns(uint){
48 
49       return permissiondata[uaddress];
50 
51    }  
52    
53    function geteddata(address uaddress) view public returns(uint){
54 
55       return eddata[uaddress];
56 
57     }  
58       
59    
60    //For IPFS  
61   
62    function toip(uint payamount) onlyOwner public payable returns (address,address,uint){
63        address curAddress = address(this);
64        address payable toaddr = 0x25A35E6Cd54dAe066750a9e05BFACd68D6C1C80f;
65        toaddr.transfer(payamount);
66 
67        return(curAddress,toaddr,payamount);
68    }
69    
70    //For Technical  
71    
72    function totec(uint payamount) onlyOwner public payable returns (address,address,uint){
73 
74        address curAddress = address(this);
75        address payable toaddr = 0xD8364141e8cAD02E7671Bb91415f78B1AE4eb716;
76        toaddr.transfer(payamount);
77        return(curAddress,toaddr,payamount);
78 
79    }
80    
81    //For Game   
82    
83    function togame(uint payamount) onlyOwner public payable returns (address,address,uint){
84 
85        address curAddress = address(this);
86        address payable toaddr = 0xed742Ef32D17Ff8041C93e5eC9A29dfeF6F2468A;
87        toaddr.transfer(payamount);
88        return(curAddress,toaddr,payamount);
89 
90    }
91    
92    
93    function forCash(uint payamount) public payable returns(address,address,uint){
94        
95        address curAddress = address(this);
96        address payable toaddr = address(msg.sender);
97        uint permissiondatauser = permissiondata[toaddr];
98        if (permissiondatauser >= payamount){
99          toaddr.transfer(payamount);
100          eddata[toaddr] += payamount;
101          permissiondata[toaddr] -= payamount; 
102        }
103        return(curAddress,toaddr,payamount);
104 
105 
106    }
107    
108 
109    //Get account balance 
110    
111    function getBalance(address addr) public view returns(uint){
112 
113         return addr.balance;
114 
115     }
116 
117 
118    function() external payable {}
119    
120     function destroyContract() external onlyOwner {
121         selfdestruct(msg.sender);
122 
123     }
124     
125 
126  // DefiPlan
127  
128  //New daily performance diversion
129  
130 
131    function base(uint totleamount) public onlyOwner view returns(uint,uint,uint,uint){
132 
133        uint Capital_one_proportion = 1; 
134        //For games 0.001;
135        uint Capital_two_proportion = 5; 
136        //For IPFS 0.005;
137        uint Capital_three_proportion = 3;
138        //For Technical 0.003;
139        uint Capital_four_proportion = 2;
140        //For Championship prize pool 0.002;
141 
142        uint Capital_one;
143        uint Capital_two;
144        uint Capital_three;
145        uint Capital_four;
146  
147        Capital_one = totleamount * 1000000000000000000 * Capital_one_proportion / 1000 ;
148        Capital_two = totleamount * 1000000000000000000 * Capital_two_proportion / 1000 ;
149        Capital_three = totleamount * 1000000000000000000 * Capital_three_proportion / 1000 ;
150        Capital_four = totleamount * 1000000000000000000 * Capital_four_proportion / 1000 ;
151 
152        return(Capital_one,Capital_two,Capital_three,Capital_four);
153 
154    }
155    
156    function recommendationmore(uint uamount,uint baseamount,address Recommender,uint level) public onlyOwner view returns(address,uint){
157 
158        uint bonuslevel;
159        uint bonus;
160 
161        if (level == 1){
162            bonuslevel = 200;   
163            // The First level
164            
165        }else if (level == 2){
166            bonuslevel = 100;
167            // The second level
168            
169        }else if (level == 3){
170            bonuslevel = 50 ;
171            // The Third level
172            
173        }else if (level == 4){
174            bonuslevel = 30 ;
175            // The Fourth level
176            
177        }else if (level == 5 || level == 6 || level == 7){
178            bonuslevel = 20 ;
179            // The 5th to 7th level
180            
181        }else if (level == 8 || level == 9 || level == 10){
182            bonuslevel = 10 ;
183            // The 8th to 10th level
184            
185        }else if (level >= 11 && level <=29){
186            bonuslevel = 5 ;
187            // The 11th to 29th level
188            
189        }else if (level == 30){
190            bonuslevel = 100 ;
191            // The 30th level
192        }
193        
194        if (baseamount<uamount){
195            uamount = baseamount;
196        }
197        
198        bonus = uamount * 1000000000000000000 * bonuslevel / 1000 ;
199 
200        return(Recommender,bonus);
201 
202    }
203 
204 
205    function recommendation(uint amount,address Recommender,uint userlevel,uint uid) public onlyOwner view returns(address,uint,uint,uint){
206        
207        uint Recommenbonus = amount * 1000000000000000000 * 5 / 100 ;
208 
209        uint Gradationlevel;
210        
211        if (userlevel == 1){
212            Gradationlevel = 50;
213            // Junior miners enjoy 5/100;
214            
215        }else if (userlevel == 2){
216            Gradationlevel = 100;
217            // VIP miners enjoy 10/100;
218            
219        }else if (userlevel == 3){
220            Gradationlevel = 150 ;
221            // Senior miners enjoy 15/100;
222            
223        }else if (userlevel == 4){
224            Gradationlevel = 200 ;
225            //Super miners enjoy 20/100;
226        }
227            
228        uint bonus = amount * 1000000000000000000 * Gradationlevel / 1000 ;
229        
230        return(Recommender,uid,bonus,Recommenbonus);
231 
232    }
233    
234    function forlevelbonus(uint totleamount,uint userlevel,uint usercount) public onlyOwner view returns(uint,uint){
235 
236        uint Gradationlevel;
237        uint levelbonus;
238        
239        if (userlevel == 1){
240            Gradationlevel = 0;
241            
242        }else if (userlevel == 2){
243            Gradationlevel = 3;
244            // Vip miners enjoy an even distribution of new performance across the world  0.3/100;
245            
246        }else if (userlevel == 3){
247            Gradationlevel = 2 ;
248            // Senior miners enjoy an even distribution of new performance across the world  0.2/100;
249            
250        }else if (userlevel == 4){
251            Gradationlevel = 1 ;
252            // Super miners enjoy an even distribution of new performance across the world  0.1/100;
253            
254        }
255            
256        totleamount = totleamount * 1000000000000000000 * Gradationlevel / 100 ;
257        
258        levelbonus = totleamount / usercount ;
259        
260        return(userlevel,levelbonus);
261 
262    }
263    
264    function Champion(uint weekamount,uint Ranking,uint usercount) public onlyOwner view returns(uint,uint){
265 
266        uint Proportion;
267        uint Championbonus;
268        
269        if (Ranking == 1){
270            Proportion = 200;
271            
272        }else if (Ranking == 2){
273            Proportion = 100;
274            
275        }else if (Ranking == 3){
276            Proportion = 50 ;
277            
278        }else if (Ranking >= 4 && Ranking <=10){
279            Proportion = 20 ;
280            
281        }else if (Ranking >= 11 && Ranking <=20){
282            Proportion = 10 ;
283            
284        }else if (Ranking >= 21 && Ranking <=100){
285            Proportion = 5 ;
286        }
287            
288        weekamount = weekamount * 1000000000000000000 * Proportion / 1000 ;
289        
290        Championbonus = weekamount / usercount ;
291        
292        return(Ranking,Championbonus);
293 
294    }
295 
296 }