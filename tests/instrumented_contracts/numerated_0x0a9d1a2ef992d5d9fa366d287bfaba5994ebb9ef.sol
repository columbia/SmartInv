1 pragma solidity ^0.4.16;
2 
3 
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 
53 
54 
55 contract ERC20 {
56   uint256 public totalSupply = 1000000;
57   function balanceOf(address who) constant returns (uint);
58   function allowance(address owner, address spender) constant returns (uint);
59 
60   function transfer(address to, uint value) returns (bool ok);
61   function transferFrom(address from, address to, uint value) returns (bool ok);
62   function approve(address spender, uint value) returns (bool ok);
63   event Transfer(address indexed from, address indexed to, uint value);
64   event Approval(address indexed owner, address indexed spender, uint value);
65 }
66 
67 
68 
69 
70 contract StandardToken is ERC20, SafeMath {
71 
72   /* Token supply got increased and a new owner received these tokens */
73   event Minted(address receiver, uint amount);
74 
75   /* Actual balances of token holders */
76   mapping(address => uint) balances;
77 
78   /* approve() allowances */
79   mapping (address => mapping (address => uint)) allowed;
80 
81   /* Interface declaration */
82   function isToken() public constant returns (bool weAre) {
83     return true;
84   }
85 
86   function transfer(address _to, uint _value) returns (bool success) {
87       
88       if (_value < 0) {
89           revert();
90       }
91       
92     balances[msg.sender] = safeSub(balances[msg.sender], _value);
93     balances[_to] = safeAdd(balances[_to], _value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
99       
100       if (_value < 0) {
101           revert();
102       }
103       
104     uint _allowance = allowed[_from][msg.sender];
105 
106     balances[_to] = safeAdd(balances[_to], _value);
107     balances[_from] = safeSub(balances[_from], _value);
108     allowed[_from][msg.sender] = safeSub(_allowance, _value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   function balanceOf(address _owner) constant returns (uint balance) {
114     return balances[_owner];
115   }
116 
117   function approve(address _spender, uint _value) returns (bool success) {
118 
119     // To change the approve amount you first have to reduce the addresses`
120     //  allowance to zero by calling `approve(_spender, 0)` if it is not
121     //  already 0 to mitigate the race condition described here:
122     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
124 
125     allowed[msg.sender][_spender] = _value;
126     Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   function allowance(address _owner, address _spender) constant returns (uint remaining) {
131     return allowed[_owner][_spender];
132   }
133 
134 }
135 
136 
137 
138 
139 
140 
141 
142 contract CTest1 is StandardToken {
143   
144     // Set the contract controller address
145     // Set the 3 Founder addresses
146     address public owner = msg.sender;
147     address public Founder1 = 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E;
148     address public Founder2 = 0x00A591199F53907480E1f5A00958b93B43200Fe4;
149     address public Founder3 = 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D;
150 
151   
152     function name() constant returns (string) { return "CTest1 Token"; }
153     function symbol() constant returns (string) { return "CTest1"; }
154     function decimals() constant returns (uint) { return 18; }
155     
156 
157     
158     
159     function () payable {
160         
161         
162         //If all the tokens are gone, stop!
163         if (totalSupply < 1)
164         {
165             throw;
166         }
167         
168         
169         uint256 rate = 0;
170         address receiver = msg.sender;
171         
172         
173         //Set the price to 0.0003 ETH/CTest1
174         //$0.10 per
175         if (totalSupply > 975000)
176         {
177             rate = 3340;
178         }
179         
180         //Set the price to 0.0015 ETH/CTest1
181         //$0.50 per
182         if (totalSupply < 975001)
183         {
184             rate = 668;
185         }
186         
187         //Set the price to 0.0030 ETH/CTest1
188         //$1.00 per
189         if (totalSupply < 875001)
190         {
191             rate = 334;
192         }
193         
194         //Set the price to 0.0075 ETH/CTest1
195         //$2.50 per
196         if (totalSupply < 475001)
197         {
198             rate = 134;
199         }
200         
201         
202        
203 
204         
205         uint256 tokens = (safeMul(msg.value, rate))/1 ether;
206         
207         
208         //Make sure they send enough to buy atleast 1 token.
209         if (tokens < 1)
210         {
211             throw;
212         }
213         
214         
215         //Make sure someone isn't buying more than the remaining supply
216         uint256 check = safeSub(totalSupply, tokens);
217         if (check < 0)
218         {
219             throw;
220         }
221         
222         
223         //Make sure someone isn't buying more than the current tier
224         if (totalSupply > 975000 && check < 975000)
225         {
226             throw;
227         }
228         
229         //Make sure someone isn't buying more than the current tier
230         if (totalSupply > 875000 && check < 875000)
231         {
232             throw;
233         }
234         
235         //Make sure someone isn't buying more than the current tier
236         if (totalSupply > 475000 && check < 475000)
237         {
238             throw;
239         }
240         
241         
242         //Prevent any ETH address from buying more than 50 CTest1 during the pre-sale
243         if ((balances[receiver] + tokens) > 50 && totalSupply > 975000)
244         {
245             throw;
246         }
247         
248         
249         balances[receiver] = safeAdd(balances[receiver], tokens);
250         
251         totalSupply = safeSub(totalSupply, tokens);
252         
253         Transfer(0, receiver, tokens);
254 
255 
256 
257 	    Founder1.transfer((msg.value/3));					//Send the ETH
258 	    Founder2.transfer((msg.value/3));					//Send the ETH
259 	    Founder3.transfer((msg.value/3));					//Send the ETH
260         
261     }
262     
263     
264     
265     //Burn all remaining tokens.
266     //Only contract creator can do this.
267     function Burn () {
268         
269         if (msg.sender == owner && totalSupply > 0)
270         {
271             totalSupply = 0;
272         } else {throw;}
273 
274     }
275   
276   
277   
278 }