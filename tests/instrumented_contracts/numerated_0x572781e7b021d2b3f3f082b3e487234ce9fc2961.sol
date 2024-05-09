1 pragma solidity ^0.4.16;
2 
3 
4 //Clout Token version 0.2
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
144     address public Founder1 = 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E;  //sta
145     address public Founder2 = 0x00A591199F53907480E1f5A00958b93B43200Fe4;  //ste
146     address public Founder3 = 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D;  //cd
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
158       tokenAmount = ((msg.value/rate));
159     
160     if (tokenAmount != amount || amount == 0 || receiver != msg.sender)
161     {
162         revert();
163     }
164     
165 
166     totalSupply = totalSupply + amount;
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
181             //If all the tokens are gone, stop!
182             if (totalSupply > 999999)
183             {
184                 revert();
185             }
186             
187 
188             
189             //Set the price to 0.00034 ETH/CLOUT
190             //$0.10 per
191             if (totalSupply < 25000)
192             {
193                 rate = 0.00034*1 ether;
194             }
195             
196             //Set the price to 0.0017 ETH/CLOUT
197             //$0.50 per
198             if (totalSupply >= 25000)
199             {
200                 rate = 0.0017*1 ether;
201             }
202             
203             //Set the price to 0.0034 ETH/CLOUT
204             //$1.00 per
205             if (totalSupply >= 125000)
206             {
207                 rate = 0.0034*1 ether;
208             }
209             
210             //Set the price to 0.0068 ETH/CLOUT
211             //$2.00 per
212             if (totalSupply >= 525000)
213             {
214                 rate = 0.0068*1 ether;
215             }
216             
217             
218            
219             
220             tokenAmount = 0;
221             tokenAmount = ((msg.value/rate));
222             
223             
224             //Make sure they send enough to buy atleast 1 token.
225             if (tokenAmount < 0)
226             {
227                 revert();
228             }
229             
230             
231             //Make sure someone isn't buying more than the remaining supply
232             check = 0;
233             
234             check = safeAdd(totalSupply, tokenAmount);
235             
236             if (check > 1000000)
237             {
238                 revert();
239             }
240             
241             
242             //Make sure someone isn't buying more than the current tier
243             if (totalSupply < 25000 && check > 25000)
244             {
245                 revert();
246             }
247             
248             //Make sure someone isn't buying more than the current tier
249             if (totalSupply < 125000 && check > 125000)
250             {
251                 revert();
252             }
253             
254             //Make sure someone isn't buying more than the current tier
255             if (totalSupply < 525000 && check > 525000)
256             {
257                 revert();
258             }
259             
260             
261             //Prevent any ETH address from buying more than 50 CLOUT during the pre-sale
262             uint256 senderBalance = (balances[msg.sender]/1 ether);
263             if ((senderBalance + tokenAmount) > 200 && totalSupply < 25000)
264             {
265                 revert();
266             }
267             
268     
269         	mint(msg.sender, tokenAmount);
270         	tokenAmount = 0;							//set the 'amount' var back to zero
271         	check = 0;
272         	rate = 0;
273         		
274         		
275         	Founder1.transfer((msg.value/100)*49);					//Send the ETH 49%
276         	Founder2.transfer((msg.value/100)*2);					//Send the ETH  2%
277         	Founder3.transfer((msg.value/100)*49);					//Send the ETH 49%
278     
279     }
280 
281 
282     //Burn all remaining tokens.
283     //Only contract creator can do this.
284     function Burn () {
285         
286         if (msg.sender == owner)
287         {
288             totalSupply = 1000000;
289         } else {throw;}
290 
291     }
292   
293   
294   
295 }