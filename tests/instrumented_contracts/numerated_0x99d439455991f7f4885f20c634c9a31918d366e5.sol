1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value);
13   function approve(address spender, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract FinalizableToken {
18     bool public isFinalized = false;
19 }
20 
21 contract BasicToken is FinalizableToken, ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   /**
27   * @dev transfer token for a specified address
28   * @param _to The address to transfer to.
29   * @param _value The amount to be transferred.
30   */
31   function transfer(address _to, uint256 _value) {
32     if (!isFinalized) revert();
33 
34     balances[msg.sender] = balances[msg.sender].sub(_value);
35     balances[_to] = balances[_to].add(_value);
36     Transfer(msg.sender, _to, _value);
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of. 
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) constant returns (uint256 balance) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 contract StandardToken is ERC20, BasicToken {
51 
52   mapping (address => mapping (address => uint256)) allowed;
53 
54 
55   /**
56    * @dev Transfer tokens from one address to another
57    * @param _from address The address which you want to send tokens from
58    * @param _to address The address which you want to transfer to
59    * @param _value uint256 the amout of tokens to be transfered
60    */
61   function transferFrom(address _from, address _to, uint256 _value) {
62     if (!isFinalized) revert();
63 
64     var _allowance = allowed[_from][msg.sender];
65 
66     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
67     // if (_value > _allowance) throw;
68 
69     balances[_to] = balances[_to].add(_value);
70     balances[_from] = balances[_from].sub(_value);
71     allowed[_from][msg.sender] = _allowance.sub(_value);
72     Transfer(_from, _to, _value);
73   }
74 
75   /**
76    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
77    * @param _spender The address which will spend the funds.
78    * @param _value The amount of tokens to be spent.
79    */
80   function approve(address _spender, uint256 _value) {
81 
82     // To change the approve amount you first have to reduce the addresses`
83     //  allowance to zero by calling `approve(_spender, 0)` if it is not
84     //  already 0 to mitigate the race condition described here:
85     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
87 
88     allowed[msg.sender][_spender] = _value;
89     Approval(msg.sender, _spender, _value);
90   }
91 
92   /**
93    * @dev Function to check the amount of tokens that an owner allowed to a spender.
94    * @param _owner address The address which owns the funds.
95    * @param _spender address The address which will spend the funds.
96    * @return A uint256 specifing the amount of tokens still avaible for the spender.
97    */
98   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99     return allowed[_owner][_spender];
100   }
101 
102 }
103 
104 contract SimpleToken is StandardToken {
105 
106   string public name = "SimpleToken";
107   string public symbol = "SIM";
108   uint256 public decimals = 18;
109   uint256 public INITIAL_SUPPLY = 10000;
110 
111   /**
112    * @dev Contructor that gives msg.sender all of existing tokens. 
113    */
114   function SimpleToken() {
115     totalSupply = INITIAL_SUPPLY;
116     balances[msg.sender] = INITIAL_SUPPLY;
117   }
118 
119 }
120 
121 
122 
123 
124 contract Ownable {
125   address public owner;
126 
127 
128   /** 
129    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
130    * account.
131    */
132   function Ownable() {
133     owner = msg.sender;
134   }
135 
136 
137   /**
138    * @dev Throws if called by any account other than the owner. 
139    */
140   modifier onlyOwner() {
141     if (msg.sender != owner) {
142       revert();
143     }
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to. 
151    */
152   function transferOwnership(address newOwner) onlyOwner {
153     if (newOwner != address(0)) {
154       owner = newOwner;
155     }
156   }
157 
158 }
159 
160 library SafeMath {
161   function mul(uint256 a, uint256 b) internal returns (uint256) {
162     uint256 c = a * b;
163     assert(a == 0 || c / a == b);
164     return c;
165   }
166 
167   function div(uint256 a, uint256 b) internal returns (uint256) {
168     // assert(b > 0); // Solidity automatically throws when dividing by 0
169     uint256 c = a / b;
170     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171     return c;
172   }
173 
174   function sub(uint256 a, uint256 b) internal returns (uint256) {
175     assert(b <= a);
176     return a - b;
177   }
178 
179   function add(uint256 a, uint256 b) internal returns (uint256) {
180     uint256 c = a + b;
181     assert(c >= a);
182     return c;
183   }
184 }
185 
186 library Math {
187   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
188     return a >= b ? a : b;
189   }
190 
191   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
192     return a < b ? a : b;
193   }
194 
195   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
196     return a >= b ? a : b;
197   }
198 
199   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
200     return a < b ? a : b;
201   }
202 }
203 
204 
205 contract RexToken is StandardToken, Ownable {
206 
207   function version() constant returns (bytes32) {
208       return "0.1.1";
209   }
210 
211   string public constant name = "REX - Real Estate tokens";
212   string public constant symbol = "REX";
213   uint256 public constant decimals = 18;
214 
215   uint256 constant BASE_RATE = 700;
216   uint256 constant ETH_RATE = 225; 
217   uint256 constant USD_RAISED_CAP = 30*10**6; 
218   uint256 constant ETHER_RAISED_CAP = USD_RAISED_CAP / ETH_RATE;
219   uint256 public constant WEI_RAISED_CAP = ETHER_RAISED_CAP * 1 ether;
220   uint256 constant DURATION = 4 weeks;
221 
222 
223   uint256 TOTAL_SHARE = 1000;
224   uint256 CROWDSALE_SHARE = 500;
225 
226   address ANGELS_ADDRESS = 0x00998eba0E5B83018a0CFCdeCc5304f9f167d27a;
227   uint256 ANGELS_SHARE = 50;
228 
229   address CORE_1_ADDRESS = 0x4aD48BE9bf6E2d35277Bd33C100D283C29C7951F;
230   uint256 CORE_1_SHARE = 75;
231   address CORE_2_ADDRESS = 0x2a62609c6A6bDBE25Da4fb05980e85db9A479C5e;
232   uint256 CORE_2_SHARE = 75;
233 
234   address PARTNERSHIP_ADDRESS = 0x53B8fFBe35AE548f22d5a3b31D6E5e0C04f0d2DF;
235   uint256 PARTNERSHIP_SHARE = 70;
236 
237   address REWARDS_ADDRESS = 0x43F1aa047D3241B7DD250EB37b25fc509085fDf9;
238   uint256 REWARDS_SHARE = 200;
239 
240   address AFFILIATE_ADDRESS = 0x64ea62A8080eD1C2b8d996ACC7a82108975e5361;
241   uint256 AFFILIATE_SHARE = 30;
242 
243   // state variables
244   address vault;
245   uint256 public startTime;
246   uint256 public weiRaised;
247 
248   event TokenCreated(address indexed investor, uint256 amount);
249 
250   function RexToken(uint256 _start, address _vault) {
251     startTime = _start;
252     vault = _vault;
253     isFinalized = false;
254   }
255 
256   function () payable {
257     createTokens(msg.sender);
258   }
259 
260   function createTokens(address recipient) payable {
261     if (tokenSaleOnHold) revert();
262     if (msg.value == 0) revert();
263     if (now < startTime) revert();
264     if (now > startTime + DURATION) revert();
265 
266     uint256 weiAmount = msg.value;
267 
268     if (weiRaised >= WEI_RAISED_CAP) revert();
269 
270     //if funder sent more than the remaining amount then send them a refund of the difference
271     if ((weiRaised + weiAmount) > WEI_RAISED_CAP) {
272       weiAmount = WEI_RAISED_CAP - weiRaised;
273       if (!msg.sender.send(msg.value - weiAmount)) 
274         revert();
275     }
276 
277     // calculate token amount to be created
278     uint256 tokens = weiAmount.mul(getRate());
279 
280     // update totals
281     totalSupply = totalSupply.add(tokens);
282     weiRaised = weiRaised.add(weiAmount);
283 
284     balances[recipient] = balances[recipient].add(tokens);
285     TokenCreated(recipient, tokens);
286 
287     // send ether to the vault
288     if (!vault.send(weiAmount)) revert();
289   }
290 
291   // return dynamic pricing
292   function getRate() constant returns (uint256) {
293     uint256 bonus = 0;
294     if (now < (startTime + 1 weeks)) {
295       bonus = 300;
296     } else if (now < (startTime + 2 weeks)) {
297       bonus = 200;
298     } else if (now < (startTime + 3 weeks)) {
299       bonus = 100;
300     }
301     return BASE_RATE.add(bonus);
302   }
303 
304   function tokenAmount(uint256 share, uint256 finalSupply) constant returns (uint) {
305     if (share > TOTAL_SHARE) revert();
306 
307     return share.mul(finalSupply).div(TOTAL_SHARE);
308   }
309 
310   // grant regular tokens by share
311   function grantTokensByShare(address to, uint256 share, uint256 finalSupply) internal {
312     uint256 tokens = tokenAmount(share, finalSupply);
313     balances[to] = balances[to].add(tokens);
314     TokenCreated(to, tokens);
315     totalSupply = totalSupply.add(tokens);
316   }
317 
318   function getFinalSupply() constant returns (uint256) {
319     return TOTAL_SHARE.mul(totalSupply).div(CROWDSALE_SHARE);
320   }
321 
322 
323   // do final token distribution
324   function finalize() onlyOwner() {
325     if (isFinalized) revert();
326 
327     //if we are under the cap and not hit the duration then throw
328     if (weiRaised < WEI_RAISED_CAP && now <= startTime + DURATION) revert();
329 
330     uint256 finalSupply = getFinalSupply();
331 
332     grantTokensByShare(ANGELS_ADDRESS, ANGELS_SHARE, finalSupply);
333     grantTokensByShare(CORE_1_ADDRESS, CORE_1_SHARE, finalSupply);
334     grantTokensByShare(CORE_2_ADDRESS, CORE_2_SHARE, finalSupply);
335 
336     grantTokensByShare(PARTNERSHIP_ADDRESS, PARTNERSHIP_SHARE, finalSupply);
337     grantTokensByShare(REWARDS_ADDRESS, REWARDS_SHARE, finalSupply);
338     grantTokensByShare(AFFILIATE_ADDRESS, AFFILIATE_SHARE, finalSupply);
339     
340     isFinalized = true;
341   }
342 
343   bool public tokenSaleOnHold;
344 
345   function toggleTokenSaleOnHold() onlyOwner() {
346     if (tokenSaleOnHold)
347       tokenSaleOnHold = false;
348     else
349       tokenSaleOnHold = true;
350   }
351 
352   bool public migrateDisabled;
353 
354   struct structMigrate {
355     uint dateTimeCreated;
356     uint amount;
357   }
358 
359   mapping(address => structMigrate) pendingMigrations;
360 
361   function toggleMigrationStatus() onlyOwner() {
362     if (migrateDisabled)
363       migrateDisabled = false;
364     else
365       migrateDisabled = true;
366   }
367 
368   function migrate(uint256 amount) {
369 
370     //dont allow migrations until crowdfund is done
371     if (!isFinalized) 
372       revert();
373 
374     //dont proceed if migrate is disabled
375     if (migrateDisabled) 
376       revert();
377 
378     //dont proceed if there is pending value
379     if (pendingMigrations[msg.sender].amount > 0)
380       revert();
381 
382     //amount parameter is in Wei
383     //old rex token is only 4 decimal places
384     //i.e. to migrate 8 old REX (80000) user inputs 8, ui converts to 8**18 (wei), then we divide by 14dp to get the original 80000.
385     uint256 amount_4dp = amount / (10**14);
386 
387     //this will throw if they dont have the balance/allowance
388     StandardToken(0x0042a689f1ebfca404e13c29cb6d01e00059ba9dbc).transferFrom(msg.sender, this, amount_4dp);
389 
390     //store time and amount in pending mapping
391     pendingMigrations[msg.sender].dateTimeCreated = now;
392     pendingMigrations[msg.sender].amount = amount;
393   }
394 
395   function claimMigrate() {
396 
397     //dont allow if migrations are disabled
398     if (migrateDisabled) 
399       revert();
400 
401     //dont proceed if no value
402     if (pendingMigrations[msg.sender].amount == 0)
403       revert();
404 
405     //can only claim after a week has passed
406     if (now < pendingMigrations[msg.sender].dateTimeCreated + 1 weeks)
407       revert();
408 
409     //credit the balances
410     balances[msg.sender] += pendingMigrations[msg.sender].amount;
411     totalSupply += pendingMigrations[msg.sender].amount;
412 
413     //remove the pending migration from the mapping
414     delete pendingMigrations[msg.sender];
415   }
416 
417   function transferOwnCoins(address _to, uint _value) onlyOwner() {
418     if (!isFinalized) revert();
419 
420     balances[this] = balances[this].sub(_value);
421     balances[_to] = balances[_to].add(_value);
422     Transfer(this, _to, _value);
423   }
424 
425 }