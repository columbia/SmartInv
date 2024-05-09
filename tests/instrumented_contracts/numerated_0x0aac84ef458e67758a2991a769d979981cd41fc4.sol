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
132 /*
133 
134 LimitedTransferToken defines the generic interface and the implementation
135 to limit token transferability for different events.
136 
137 It is intended to be used as a base class for other token contracts.
138 
139 Overwriting transferableTokens(address holder, uint64 time) is the way to provide
140 the specific logic for limiting token transferability for a holder over time.
141 
142 LimitedTransferToken has been designed to allow for different limiting factors,
143 this can be achieved by recursively calling super.transferableTokens() until the
144 base class is hit. For example:
145 
146 function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
147   return min256(unlockedTokens, super.transferableTokens(holder, time));
148 }
149 
150 A working example is VestedToken.sol:
151 https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
152 
153 */
154 
155 contract LimitedTransferToken is ERC20 {
156   // Checks whether it can transfer or otherwise throws.
157   modifier canTransfer(address _sender, uint _value) {
158    if (_value > transferableTokens(_sender, uint64(now))) throw;
159    _;
160   }
161 
162   // Checks modifier and allows transfer if tokens are not locked.
163   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
164    return super.transfer(_to, _value);
165   }
166 
167   // Checks modifier and allows transfer if tokens are not locked.
168   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
169    return super.transferFrom(_from, _to, _value);
170   }
171 
172   // Default transferable tokens function returns all tokens for a holder (no limit).
173   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
174     return balanceOf(holder);
175   }
176 }
177 
178 contract Ownable {
179   address public owner;
180 
181   function Ownable() {
182     owner = msg.sender;
183   }
184 
185   modifier onlyOwner() {
186     if (msg.sender != owner) {
187       throw;
188     }
189     _;
190   }
191 
192   function transferOwnership(address newOwner) onlyOwner {
193     if (newOwner != address(0)) {
194       owner = newOwner;
195     }
196   }
197 
198 }
199 
200 /*
201  * Destructible
202  * Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
203  */
204 contract Destructible is Ownable {
205   function destroy() onlyOwner {
206     selfdestruct(owner);
207   }
208 }
209 
210 contract OxToken is StandardToken, LimitedTransferToken, Ownable, Destructible {
211   using SafeMath for uint;
212 
213   event OxTokenInitialized(address _owner);
214   event OwnerTokensAllocated(uint _amount);
215   event SaleStarted(uint _saleEndTime);
216 
217   string public name = "OxToken";
218   string public symbol = "OX";
219 
220   uint public decimals = 3;
221   uint public multiplier = 10**decimals;
222   uint public etherRatio = SafeMath.div(1 ether, multiplier);
223 
224   uint public MAX_SUPPLY = SafeMath.mul(700000000, multiplier); //50% (public) + 20% (corporate)
225   uint public CORPORATE_SUPPLY = SafeMath.mul(200000000, multiplier); //20%
226   uint public BOUNTY_SUPPLY = SafeMath.mul(200000000, multiplier); //20%
227   uint public TEAM_SUPPLY = SafeMath.mul(100000000, multiplier); //10%
228   uint public PRICE = 3000; //1 Ether buys 3000 OX
229   uint public MIN_PURCHASE = 10**17; // 0.1 Ether
230 
231   uint256 public saleStartTime = 0;
232   bool public ownerTokensAllocated = false;
233   bool public balancesInitialized = false;
234 
235   function OxToken() {
236     OxTokenInitialized(msg.sender);
237   }
238 
239   function initializeBalances() public {
240     if (balancesInitialized) {
241       throw;
242     }
243     balances[owner] = CORPORATE_SUPPLY;
244     totalSupply = CORPORATE_SUPPLY;
245     balancesInitialized = true;
246     Transfer(0x0, msg.sender, CORPORATE_SUPPLY);
247   }
248 
249   function canBuyTokens() constant public returns (bool) {
250     //Sale runs for 31 days
251     if (saleStartTime == 0) {
252       return false;
253     }
254     if (getNow() > SafeMath.add(saleStartTime, 31 days)) {
255       return false;
256     }
257     return true;
258   }
259 
260   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
261     //Owner can always transfer balance
262     //If sale has completed, everyone can transfer full balance
263     if (holder == owner) {
264       return balanceOf(holder);
265     }
266     if ((saleStartTime == 0) || canBuyTokens()) {
267       return 0;
268     }
269     return balanceOf(holder);
270   }
271 
272   function startSale() onlyOwner {
273     //Can only start once
274     if (saleStartTime != 0) {
275       throw;
276     }
277     //Can't start unless balances have been initialized
278     if (!balancesInitialized) {
279       throw;
280     }
281     saleStartTime = getNow();
282     SaleStarted(saleStartTime);
283   }
284 
285   function () payable {
286     createTokens(msg.sender);
287   }
288 
289   function createTokens(address recipient) payable {
290 
291     //Only allow purchases over the MIN_PURCHASE
292     if (msg.value < MIN_PURCHASE) {
293       throw;
294     }
295 
296     //Reject if sale has completed
297     if (!canBuyTokens()) {
298       throw;
299     }
300 
301     //Otherwise generate tokens
302     uint tokens = msg.value.mul(PRICE);
303 
304     //Add on any bonus
305     uint bonusPercentage = SafeMath.add(100, bonus());
306     if (bonusPercentage != 100) {
307       tokens = tokens.mul(percent(bonusPercentage)).div(percent(100));
308     }
309 
310     tokens = tokens.div(etherRatio);
311 
312     totalSupply = totalSupply.add(tokens);
313 
314     //Don't allow totalSupply to be larger than MAX_SUPPLY
315     if (totalSupply > MAX_SUPPLY) {
316       throw;
317     }
318 
319     balances[recipient] = balances[recipient].add(tokens);
320 
321     //Transfer Ether to owner
322     owner.transfer(msg.value);
323 
324   }
325 
326   //Function to assign team & bounty tokens to owner
327   function allocateOwnerTokens() public {
328 
329     //Can only be called once
330     if (ownerTokensAllocated) {
331       throw;
332     }
333 
334     //Can only be called after sale has completed
335     if ((saleStartTime == 0) || canBuyTokens()) {
336       throw;
337     }
338 
339     ownerTokensAllocated = true;
340 
341     uint amountToAllocate = SafeMath.add(BOUNTY_SUPPLY, TEAM_SUPPLY);
342     balances[msg.sender] = balances[msg.sender].add(amountToAllocate);
343     totalSupply = totalSupply.add(amountToAllocate);
344 
345     Transfer(0x0, msg.sender, amountToAllocate);
346     OwnerTokensAllocated(amountToAllocate);
347 
348   }
349 
350   function bonus() constant returns(uint) {
351 
352     uint elapsed = SafeMath.sub(getNow(), saleStartTime);
353 
354     if (elapsed < 1 days) return 25;
355     if (elapsed < 1 weeks) return 20;
356     if (elapsed < 2 weeks) return 15;
357     if (elapsed < 3 weeks) return 10;
358     if (elapsed < 4 weeks) return 5;
359 
360     return 0;
361   }
362 
363   function percent(uint256 p) internal returns (uint256) {
364     return p.mul(10**16);
365   }
366 
367   //Function is mocked for tests
368   function getNow() internal constant returns (uint256) {
369     return now;
370   }
371 
372 }