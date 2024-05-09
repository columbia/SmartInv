1 pragma solidity ^0.4.17;
2 
3 
4 //Clout Token version 0.3
5 //fixed totalSupply count for etherscan
6 
7 
8 contract SafeMath {
9   function safeMul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeDiv(uint a, uint b) internal returns (uint) {
16     assert(b > 0);
17     uint c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21 
22   function safeSub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function safeAdd(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c>=a && c>=b);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49   function assert(bool assertion) internal {
50     if (!assertion) {
51       throw;
52     }
53   }
54 }
55 
56 
57 
58 
59 contract ERC20 {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function allowance(address owner, address spender) constant returns (uint);
63 
64   function transfer(address to, uint value) returns (bool ok);
65   function transferFrom(address from, address to, uint value) returns (bool ok);
66   function approve(address spender, uint value) returns (bool ok);
67   event Transfer(address indexed from, address indexed to, uint value);
68   event Approval(address indexed owner, address indexed spender, uint value);
69 }
70 
71 
72 
73 
74 contract StandardToken is ERC20, SafeMath {
75 
76   /* Token supply got increased and a new owner received these tokens */
77   event Minted(address receiver, uint amount);
78 
79   /* Actual balances of token holders */
80   mapping(address => uint) balances;
81 
82   /* approve() allowances */
83   mapping (address => mapping (address => uint)) allowed;
84 
85   /* Interface declaration */
86   function isToken() public constant returns (bool weAre) {
87     return true;
88   }
89 
90   function transfer(address _to, uint _value) returns (bool success) {
91       
92     balances[msg.sender] = safeSub(balances[msg.sender], _value);
93     balances[_to] = safeAdd(balances[_to], _value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
99       
100     uint _allowance = allowed[_from][msg.sender];
101 
102     balances[_to] = safeAdd(balances[_to], _value);
103     balances[_from] = safeSub(balances[_from], _value);
104     allowed[_from][msg.sender] = safeSub(_allowance, _value);
105     Transfer(_from, _to, _value);
106     return true;
107   }
108 
109   function balanceOf(address _owner) constant returns (uint balance) {
110     return balances[_owner];
111   }
112 
113   function approve(address _spender, uint _value) returns (bool success) {
114 
115     // To change the approve amount you first have to reduce the addresses`
116     //  allowance to zero by calling `approve(_spender, 0)` if it is not
117     //  already 0 to mitigate the race condition described here:
118     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
120 
121     allowed[msg.sender][_spender] = _value;
122     Approval(msg.sender, _spender, _value);
123     return true;
124   }
125 
126   function allowance(address _owner, address _spender) constant returns (uint remaining) {
127     return allowed[_owner][_spender];
128   }
129 
130 }
131 
132 
133 
134 
135 
136 
137 
138 contract CloutToken is StandardToken {
139   
140     
141     uint256 public rate = 0;
142     uint256 public check = 0;
143     
144     address public owner = msg.sender;
145     address public Founder1 = 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E;  //sta
146     address public Founder2 = 0x00A591199F53907480E1f5A00958b93B43200Fe4;  //ste
147     address public Founder3 = 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D;  //cd
148     
149 	uint256 public tokenAmount;
150   
151     string public constant name = "Clout Token";
152     string public constant symbol = "CLOUT";
153     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
154 	
155 
156 
157   function mint(address receiver, uint amount) public {
158       
159       tokenAmount = ((msg.value/rate));
160     
161     if (tokenAmount != amount || amount == 0 || receiver != msg.sender)
162     {
163         revert();
164     }
165     
166 
167     totalSupply = totalSupply + (amount*1 ether);
168     balances[receiver] += (amount*1 ether);
169 
170     // This will make the mint transaction appear in EtherScan.io
171     // We can remove this after there is a standardized minting event
172     Transfer(0, receiver, (amount*1 ether));
173   }
174 
175   
176   
177 	//This function is called when Ether is sent to the contract address
178 	//Even if 0 ether is sent.
179     function () payable {
180             
181             totalSupply = (totalSupply/1 ether);
182 
183             //If all the tokens are gone, stop!
184             if (totalSupply > 999999)
185             {
186                 totalSupply = (totalSupply*1 ether);
187                 revert();
188             }
189             
190 
191             
192             //Set the price to 0.00034 ETH/CLOUT
193             //$0.10 per
194             if (totalSupply < 25000)
195             {
196                 rate = 0.00034*1 ether;
197             }
198             
199             //Set the price to 0.0017 ETH/CLOUT
200             //$0.50 per
201             if (totalSupply >= 25000)
202             {
203                 rate = 0.0017*1 ether;
204             }
205             
206             //Set the price to 0.0034 ETH/CLOUT
207             //$1.00 per
208             if (totalSupply >= 125000)
209             {
210                 rate = 0.0034*1 ether;
211             }
212             
213             //Set the price to 0.0068 ETH/CLOUT
214             //$2.00 per
215             if (totalSupply >= 525000)
216             {
217                 rate = 0.0068*1 ether;
218             }
219             
220             
221            
222             
223             tokenAmount = 0;
224             tokenAmount = ((msg.value/rate));
225             
226             
227             //Make sure they send enough to buy atleast 1 token.
228             if (tokenAmount < 0)
229             {
230                 totalSupply = (totalSupply*1 ether);
231                 revert();
232             }
233             
234             
235             //Make sure someone isn't buying more than the remaining supply
236             check = 0;
237             
238             check = safeAdd(totalSupply, tokenAmount);
239             
240             if (check > 1000000)
241             {
242                 totalSupply = (totalSupply*1 ether);
243                 revert();
244             }
245             
246             
247             //Make sure someone isn't buying more than the current tier
248             if (totalSupply < 25000 && check > 25000)
249             {
250                 totalSupply = (totalSupply*1 ether);
251                 revert();
252             }
253             
254             //Make sure someone isn't buying more than the current tier
255             if (totalSupply < 125000 && check > 125000)
256             {
257                 totalSupply = (totalSupply*1 ether);
258                 revert();
259             }
260             
261             //Make sure someone isn't buying more than the current tier
262             if (totalSupply < 525000 && check > 525000)
263             {
264                 totalSupply = (totalSupply*1 ether);
265                 revert();
266             }
267             
268             
269             //Prevent any ETH address from buying more than 50 CLOUT during the pre-sale
270             uint256 senderBalance = (balances[msg.sender]/1 ether);
271             if ((senderBalance + tokenAmount) > 200 && totalSupply < 25000)
272             {
273                 totalSupply = (totalSupply*1 ether);
274                 revert();
275             }
276             
277             totalSupply = (totalSupply*1 ether);
278         	mint(msg.sender, tokenAmount);
279         	tokenAmount = 0;							//set the 'amount' var back to zero
280         	check = 0;
281         	rate = 0;
282         		
283         		
284         	Founder1.transfer((msg.value/100)*49);					//Send the ETH 49%
285         	Founder2.transfer((msg.value/100)*2);					//Send the ETH  2%
286         	Founder3.transfer((msg.value/100)*49);					//Send the ETH 49%
287     
288     }
289 
290 
291     //Burn all remaining tokens.
292     //Only contract creator can do this.
293     function Burn () {
294         
295         if (msg.sender == owner)
296         {
297             totalSupply = (1000000*1 ether);
298         } else {throw;}
299 
300     }
301   
302   
303   
304 }