1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 /*
52  * ERC20Basic
53  * Simpler version of ERC20 interface
54  * see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20Basic {
57   uint public totalSupply;
58   function balanceOf(address who) constant returns (uint);
59   function transfer(address to, uint value);
60   event Transfer(address indexed from, address indexed to, uint value);
61 }
62 
63 /*
64  * ERC20 interface
65  * see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) constant returns (uint);
69   function transferFrom(address from, address to, uint value);
70   function approve(address spender, uint value);
71   event Approval(address indexed owner, address indexed spender, uint value);
72 }
73 
74 /*
75  * Basic token
76  * Basic version of StandardToken, with no allowances
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint;
80 
81   mapping(address => uint) balances;
82 
83   /*
84    * Fix for the ERC20 short address attack  
85    */
86   modifier onlyPayloadSize(uint size) {
87      if(msg.data.length < size + 4) {
88        throw;
89      }
90      _;
91   }
92 
93   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97   }
98 
99   function balanceOf(address _owner) constant returns (uint balance) {
100     return balances[_owner];
101   }
102   
103 }
104 
105 contract StandardToken is BasicToken, ERC20 {
106 
107   mapping (address => mapping (address => uint)) allowed;
108 
109   function transferFrom(address _from, address _to, uint _value) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // if (_value > _allowance) throw;
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119   }
120 
121   function approve(address _spender, uint _value) {
122     allowed[msg.sender][_spender] = _value;
123     Approval(msg.sender, _spender, _value);
124   }
125 
126   function allowance(address _owner, address _spender) constant returns (uint remaining) {
127     return allowed[_owner][_spender];
128   }
129 
130 }
131 
132 contract Ownable {
133   address public owner;
134 
135   function Ownable() {
136     owner = msg.sender;
137   }
138 
139   modifier onlyOwner() {
140     if (msg.sender != owner) {
141       throw;
142     }
143     _;
144   }
145 
146   function transferOwnership(address newOwner) onlyOwner {
147     if (newOwner != address(0)) {
148       owner = newOwner;
149     }
150   }
151 
152 }
153 
154 contract BITSDToken is StandardToken, Ownable {
155   using SafeMath for uint;
156 
157   event BITSDTokenInitialized(address _owner);
158   event OwnerTokensAllocated(uint _amount);
159   event TeamTokensAllocated(uint _amount);
160   event TokensCreated(address indexed _tokenHolder, uint256 _contributionAmount, uint256 _tokenAmount);
161   event SaleStarted(uint _saleStartime);
162 
163   string public name = "BITSDToken";
164   string public symbol = "BITSD";
165 
166   uint public decimals = 3;
167   uint public multiplier = 10**decimals;
168   uint public etherRatio = SafeMath.div(1 ether, multiplier);
169 
170   uint public TOTAL_SUPPLY = SafeMath.mul(7000000, multiplier);
171   uint public TEAM_SUPPLY = SafeMath.mul(700000, multiplier);
172   uint public PRICE = 300; //1 Ether buys 300 BITSD
173   uint public MIN_PURCHASE = 10**18; // 1 Ether
174 
175   uint256 public saleStartTime = 0;
176   bool public teamTokensAllocated = false;
177   bool public ownerTokensAllocated = false;
178 
179   function BITSDToken() {
180     BITSDTokenInitialized(msg.sender);
181   }
182 
183   function allocateTeamTokens() public {
184     if (teamTokensAllocated) {
185       throw;
186     }
187     balances[owner] = balances[owner].add(TEAM_SUPPLY);
188     totalSupply = totalSupply.add(TEAM_SUPPLY);
189     teamTokensAllocated = true;
190     TeamTokensAllocated(TEAM_SUPPLY);
191   }
192 
193   function canBuyTokens() constant public returns (bool) {
194     //Sale runs for 31 days
195     if (saleStartTime == 0) {
196       return false;
197     }
198     if (getNow() > SafeMath.add(saleStartTime, 31 days)) {
199       return false;
200     }
201     return true;
202   }
203 
204   function startSale() onlyOwner {
205     //Must allocate team tokens before starting sale, or you may lose the opportunity
206     //to do so if the whole supply is sold to the crowd.
207     if (!teamTokensAllocated) {
208       throw;
209     }
210     //Can only start once
211     if (saleStartTime != 0) {
212       throw;
213     }
214     saleStartTime = getNow();
215     SaleStarted(saleStartTime);
216   }
217 
218   function () payable {
219     createTokens(msg.sender);
220   }
221 
222   function createTokens(address recipient) payable {
223 
224     //Only allow purchases over the MIN_PURCHASE
225     if (msg.value < MIN_PURCHASE) {
226       throw;
227     }
228 
229     //Reject if sale has completed
230     if (!canBuyTokens()) {
231       throw;
232     }
233 
234     //Otherwise generate tokens
235     uint tokens = msg.value.mul(PRICE);
236 
237     //Add on any bonus
238     uint bonusPercentage = SafeMath.add(100, bonus());
239     if (bonusPercentage != 100) {
240       tokens = tokens.mul(percent(bonusPercentage)).div(percent(100));
241     }
242 
243     tokens = tokens.div(etherRatio);
244 
245     totalSupply = totalSupply.add(tokens);
246 
247     //Don't allow totalSupply to be larger than TOTAL_SUPPLY
248     if (totalSupply > TOTAL_SUPPLY) {
249       throw;
250     }
251 
252     balances[recipient] = balances[recipient].add(tokens);
253 
254     //Transfer Ether to owner
255     owner.transfer(msg.value);
256 
257     TokensCreated(recipient, msg.value, tokens);
258 
259   }
260 
261   //Function to assign team & bounty tokens to owner
262   function allocateOwnerTokens() public {
263 
264     //Can only be called once
265     if (ownerTokensAllocated) {
266       throw;
267     }
268 
269     //Can only be called after sale has completed
270     if ((saleStartTime == 0) || canBuyTokens()) {
271       throw;
272     }
273 
274     ownerTokensAllocated = true;
275 
276     uint amountToAllocate = SafeMath.sub(TOTAL_SUPPLY, totalSupply);
277     balances[owner] = balances[owner].add(amountToAllocate);
278     totalSupply = totalSupply.add(amountToAllocate);
279 
280     OwnerTokensAllocated(amountToAllocate);
281 
282   }
283 
284   function bonus() constant returns(uint) {
285 
286     uint elapsed = SafeMath.sub(getNow(), saleStartTime);
287 
288     if (elapsed < 1 weeks) return 10;
289     if (elapsed < 2 weeks) return 5;
290 
291     return 0;
292   }
293 
294   function percent(uint256 p) internal returns (uint256) {
295     return p.mul(10**16);
296   }
297 
298   //Function is mocked for tests
299   function getNow() internal constant returns (uint256) {
300     return now;
301   }
302 
303 }