1 pragma solidity ^0.4.20;
2  
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32   
33 }
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) constant returns (uint256);
43   function transfer(address to, uint256 value) returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) returns (bool);
54   function approve(address spender, uint256 value) returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract Ownable {
59     
60   address public owner;
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) onlyOwner {
83     require(newOwner != address(0));      
84     owner = newOwner;
85   }
86 
87 }
88 
89 
90 contract AGASCrowdsale is Ownable {
91     using SafeMath for uint;
92 
93     event Print(string _message, address _msgSender);
94 
95     address public multisig = 0x0A9465529653815E61E5187517392d9C10d0f9dd; 
96     address public addressOfERC20Tocken = 0xa7A1F840CF741B96F5A80D5856ae02F0f474251f;
97     ERC20 public token;
98     
99     
100     uint public startPreICO = 1521435600; //Mon, 19 Mar 2018 05:00:00 GMT 
101     uint public startICO = 1523854800; //Mon, 16 Apr 2018 05:00:00 GMT
102     uint public startProICO = 1526274000; //Mon, 14 May 2018 05:00:00 GMT
103     
104     uint public tokenDec = 1000000000000000000; //18
105     
106     uint public PreICOHardcap = 2000000*tokenDec;
107     uint public ICOHardcap = 6000000*tokenDec;
108     uint public ProICOHardcap = 8000000*tokenDec;
109     uint public tokensSold = 0;
110     
111     uint public bonusAmount = 200000*tokenDec;
112     uint public givenBonus = 0;
113     
114     uint public PreICOPrice = 1000000000000000; // 0.001 ETH 
115     uint public ICOPrice = 2000000000000000; // 0.002 ETH
116     uint public ProICOPrice = 4000000000000000; // 0.004 ETH
117     
118     
119     
120     function AGASCrowdsale(){
121         owner = msg.sender;
122         token = ERC20(addressOfERC20Tocken);
123     }    
124     
125     
126    
127     function tokenBalance() constant returns (uint256) {
128         return token.balanceOf(address(this));
129     } 
130     
131    
132     function setAddressOfERC20Tocken(address _addressOfERC20Tocken) onlyOwner {
133         addressOfERC20Tocken =  _addressOfERC20Tocken;
134         token = ERC20(addressOfERC20Tocken);
135         
136     }
137     
138 
139     function transferToken(address _to, uint _value) onlyOwner returns (bool) {
140         return token.transfer(_to,  _value);
141     }
142     
143     function() payable {
144         doPurchase();
145     }
146 
147 
148 
149     function doPurchase() payable {
150        
151         require(now >= startPreICO);
152         
153        
154         require(msg.value >= 100000000000000); 
155     
156         uint sum = msg.value;
157         uint rest = 0;
158         uint tokensAmount = 0;
159         
160         
161       
162         if(now >= startPreICO && now < startICO){
163            
164             require(PreICOHardcap > tokensSold);
165             
166            
167             tokensAmount = sum.mul(tokenDec).div(PreICOPrice);
168             
169             
170             if(tokensAmount.add(tokensSold) > PreICOHardcap) {
171               
172                 tokensAmount = PreICOHardcap.sub(tokensSold);
173                
174                 rest = sum.sub(tokensAmount.mul(PreICOPrice).div(tokenDec));
175             }
176                 
177           
178         } else if(now >= startICO && now < startProICO){
179             
180             require(ICOHardcap > tokensSold);
181             
182             
183             tokensAmount = sum.mul(tokenDec).div(ICOPrice);
184             
185              
186             if(tokensAmount.add(tokensSold) > ICOHardcap) {
187                 
188                 tokensAmount = ICOHardcap.sub(tokensSold);
189               
190                 rest = sum.sub(tokensAmount.mul(ICOPrice).div(tokenDec));
191             }
192         
193         
194         } else {
195             
196             require(ProICOHardcap > tokensSold);
197             
198             tokensAmount = sum.mul(tokenDec).div(ProICOPrice);
199             
200              
201             if(tokensAmount.add(tokensSold) > ProICOHardcap) {
202               
203                 tokensAmount = ProICOHardcap.sub(tokensSold);
204               
205                 rest = sum.sub(tokensAmount.mul(ProICOPrice).div(tokenDec));
206             }
207             
208         }         
209         
210       
211         tokensSold = tokensSold.add(tokensAmount);
212         
213 
214 
215         if(givenBonus < bonusAmount && tokensAmount >= 500*tokenDec){
216             
217             uint bonus = 0;
218             
219             
220             if(tokensAmount >= 500*tokenDec && tokensAmount <1000*tokenDec)
221             { 
222                
223                 bonus = 20*tokenDec;
224             
225             } else if ( tokensAmount >= 1000*tokenDec && tokensAmount <5000*tokenDec ) {
226               
227                 bonus = 100*tokenDec;
228             
229             } else if ( tokensAmount >= 5000*tokenDec && tokensAmount <10000*tokenDec ) {
230                
231                 bonus = 600*tokenDec;
232             
233             } else if ( tokensAmount >= 10000*tokenDec ) {
234             
235                 bonus = 1500*tokenDec;
236             }
237 
238             bonus = (bonus < (bonusAmount - givenBonus) ) ? bonus : (bonusAmount - givenBonus);
239             
240      
241             givenBonus = givenBonus.add(bonus);
242        
243             tokensAmount = tokensAmount.add(bonus);
244             
245         } 
246 
247         require(tokenBalance() > tokensAmount);
248         
249         require(token.transfer(msg.sender, tokensAmount));
250        
251         if(rest==0){
252 
253             multisig.transfer(msg.value);
254         }else{
255 
256             multisig.transfer(msg.value.sub(rest)); 
257 
258             msg.sender.transfer(rest);
259         }
260              
261     }
262 
263 }