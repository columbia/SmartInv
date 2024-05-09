1 pragma solidity ^0.4.16;
2 
3 
4 
5 
6 
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 
57 
58 contract ERC20 {
59   uint public totalSupply;
60   function balanceOf(address who) constant returns (uint);
61   function allowance(address owner, address spender) constant returns (uint);
62 
63   function transfer(address to, uint value) returns (bool ok);
64   function transferFrom(address from, address to, uint value) returns (bool ok);
65   function approve(address spender, uint value) returns (bool ok);
66   event Transfer(address indexed from, address indexed to, uint value);
67   event Approval(address indexed owner, address indexed spender, uint value);
68 }
69 
70 
71 
72 
73 contract StandardToken is ERC20, SafeMath {
74 
75   /* Token supply got increased and a new owner received these tokens */
76   event Minted(address receiver, uint amount);
77 
78   /* Actual balances of token holders */
79   mapping(address => uint) balances;
80 
81   /* approve() allowances */
82   mapping (address => mapping (address => uint)) allowed;
83 
84   /* Interface declaration */
85   function isToken() public constant returns (bool weAre) {
86     return true;
87   }
88 
89   function transfer(address _to, uint _value) returns (bool success) {
90       
91     balances[msg.sender] = safeSub(balances[msg.sender], _value);
92     balances[_to] = safeAdd(balances[_to], _value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
98       
99     uint _allowance = allowed[_from][msg.sender];
100 
101     balances[_to] = safeAdd(balances[_to], _value);
102     balances[_from] = safeSub(balances[_from], _value);
103     allowed[_from][msg.sender] = safeSub(_allowance, _value);
104     Transfer(_from, _to, _value);
105     return true;
106   }
107 
108   function balanceOf(address _owner) constant returns (uint balance) {
109     return balances[_owner];
110   }
111 
112   function approve(address _spender, uint _value) returns (bool success) {
113 
114     // To change the approve amount you first have to reduce the addresses`
115     //  allowance to zero by calling `approve(_spender, 0)` if it is not
116     //  already 0 to mitigate the race condition described here:
117     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
119 
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   function allowance(address _owner, address _spender) constant returns (uint remaining) {
126     return allowed[_owner][_spender];
127   }
128 
129 }
130 
131 
132 
133 
134 
135 
136 
137 contract CloutToken is StandardToken {
138   
139     
140     uint256 public rate = 0;
141     uint256 public check = 0;
142     
143     address public owner = msg.sender;
144     address public Founder1 = 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E;
145     address public Founder2 = 0x00A591199F53907480E1f5A00958b93B43200Fe4;
146     address public Founder3 = 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D;
147     
148 	uint256 public tokenAmount;
149   
150     string public constant name = "Clout Token";
151     string public constant symbol = "CLOUT";
152     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
153 	
154 
155 
156   function mint(address receiver, uint amount) public {
157       
158       tokenAmount = ((msg.value*rate)/(1 ether));
159     
160     if (tokenAmount != amount || amount == 0 || receiver != msg.sender)
161     {
162         revert();
163     }
164     
165 
166     totalSupply = totalSupply + (amount*1 ether);
167     balances[receiver] += (amount*1 ether);
168 
169     // This will make the mint transaction appear in EtherScan.io
170     // We can remove this after there is a standardized minting event
171     Transfer(0, receiver, (amount*1 ether));
172   }
173 
174   
175   
176 	//This function is called when Ether is sent to the contract address
177 	//Even if 0 ether is sent.
178     function () payable {
179              
180             
181             uint256 oldSupply = totalSupply;
182             totalSupply = (totalSupply/1 ether);
183             
184             
185             
186             //If all the tokens are gone, stop!
187             if (totalSupply > 999999)
188             {
189                 revert();
190             }
191             
192 
193             
194             //Set the price to 0.0003 ETH/CLOUT
195             //$0.10 per
196             if (totalSupply < 25000)
197             {
198                 rate = 3340;
199             }
200             
201             //Set the price to 0.0015 ETH/CLOUT
202             //$0.50 per
203             if (totalSupply >= 25000)
204             {
205                 rate = 668;
206             }
207             
208             //Set the price to 0.0030 ETH/CLOUT
209             //$1.00 per
210             if (totalSupply >= 125000)
211             {
212                 rate = 334;
213             }
214             
215             //Set the price to 0.0075 ETH/CLOUT
216             //$2.50 per
217             if (totalSupply >= 525000)
218             {
219                 rate = 134;
220             }
221             
222             
223            
224             
225             tokenAmount = 0;
226             tokenAmount = ((msg.value*rate)/(1 ether));
227             
228             
229             //Make sure they send enough to buy atleast 1 token.
230             if (tokenAmount < 0)
231             {
232                 revert();
233             }
234             
235             
236             //Make sure someone isn't buying more than the remaining supply
237             check = 0;
238             
239             check = safeAdd(totalSupply, tokenAmount);
240             
241             if (check > 1000000)
242             {
243                 revert();
244             }
245             
246             
247             //Make sure someone isn't buying more than the current tier
248             if (totalSupply < 25000 && check > 25000)
249             {
250                 revert();
251             }
252             
253             //Make sure someone isn't buying more than the current tier
254             if (totalSupply < 125000 && check > 125000)
255             {
256                 revert();
257             }
258             
259             //Make sure someone isn't buying more than the current tier
260             if (totalSupply < 525000 && check > 525000)
261             {
262                 revert();
263             }
264             
265             
266             //Prevent any ETH address from buying more than 50 CLOUT during the pre-sale
267             uint256 senderBalance = (balances[msg.sender]/1 ether);
268             if ((senderBalance + tokenAmount) > 50 && totalSupply < 25000)
269             {
270                 revert();
271             }
272             
273     
274             totalSupply = oldSupply;
275         	mint(msg.sender, tokenAmount);
276         	tokenAmount = 0;							//set the 'amount' var back to zero
277         	check = 0;
278         	rate = 0;
279         		
280         		
281         	Founder1.transfer((msg.value/3));					//Send the ETH
282         	Founder2.transfer((msg.value/3));					//Send the ETH
283         	Founder3.transfer((msg.value/3));					//Send the ETH
284     
285     }
286 
287 
288     //Burn all remaining tokens.
289     //Only contract creator can do this.
290     function Burn () {
291         
292         if (msg.sender == owner)
293         {
294             totalSupply = (1000000*1 ether);
295         } else {throw;}
296 
297     }
298   
299   
300   
301 }