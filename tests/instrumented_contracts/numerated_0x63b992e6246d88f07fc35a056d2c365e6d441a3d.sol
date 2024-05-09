1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 contract Pausable is Ownable {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69 
70   /**
71    * @dev modifier to allow actions only when the contract IS paused
72    */
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   /**
79    * @dev modifier to allow actions only when the contract IS NOT paused
80    */
81   modifier whenPaused {
82     require(paused);
83     _;
84   }
85 
86   /**
87    * @dev called by the owner to pause, triggers stopped state
88    */
89   function pause() onlyOwner whenNotPaused returns (bool) {
90     paused = true;
91     Pause();
92     return true;
93   }
94 
95   /**
96    * @dev called by the owner to unpause, returns to normal state
97    */
98   function unpause() onlyOwner whenPaused returns (bool) {
99     paused = false;
100     Unpause();
101     return true;
102   }
103 }
104 
105 contract ERC20Basic {
106   uint256 public totalSupply;
107   function balanceOf(address who) constant returns (uint256);
108   function transfer(address to, uint256 value) returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) returns (bool) {
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of. 
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) constant returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) constant returns (uint256);
142   function transferFrom(address from, address to, uint256 value) returns (bool);
143   function approve(address spender, uint256 value) returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amout of tokens to be transfered
157    */
158   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
159     var _allowance = allowed[_from][msg.sender];
160 
161     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
162     // require (_value <= _allowance);
163 
164     balances[_to] = balances[_to].add(_value);
165     balances[_from] = balances[_from].sub(_value);
166     allowed[_from][msg.sender] = _allowance.sub(_value);
167     Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) returns (bool) {
177 
178     // To change the approve amount you first have to reduce the addresses`
179     //  allowance to zero by calling `approve(_spender, 0)` if it is not
180     //  already 0 to mitigate the race condition described here:
181     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
183 
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifing the amount of tokens still avaible for the spender.
194    */
195   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199 }
200 
201 contract PausableToken is StandardToken, Pausable {
202 
203   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
204     return super.transfer(_to, _value);
205   }
206 
207   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
208     return super.transferFrom(_from, _to, _value);
209   }
210 }
211 
212 contract SomaIco is PausableToken {
213     using SafeMath for uint256;
214 
215     string public name = "Soma Community Token";
216     string public symbol = "SCT";
217     uint8 public decimals = 18;
218 
219     address public liquidityReserveWallet; // address where liquidity reserve tokens will be delivered
220     address public wallet; // address where funds are collected
221     address public marketingWallet; // address which controls marketing token pool
222 
223     uint256 public icoStartTimestamp; // ICO start timestamp
224     uint256 public icoEndTimestamp; // ICO end timestamp
225 
226     uint256 public totalRaised = 0; // total amount of money raised in wei
227     uint256 public totalSupply; // total token supply with decimals precisoin
228     uint256 public marketingPool; // marketing pool with decimals precisoin
229     uint256 public tokensSold = 0; // total number of tokens sold
230 
231     bool public halted = false; //the owner address can set this to true to halt the crowdsale due to emergency
232 
233     uint256 public icoEtherMinCap; // should be specified as: 8000 * 1 ether
234     uint256 public icoEtherMaxCap; // should be specified as: 120000 * 1 ether
235     uint256 public rate = 450; // standard SCT/ETH rate
236 
237     event Burn(address indexed burner, uint256 value);
238 
239     function SomaIco(
240         address newWallet,
241         address newMarketingWallet,
242         address newLiquidityReserveWallet,
243         uint256 newIcoEtherMinCap,
244         uint256 newIcoEtherMaxCap,
245         uint256 totalPresaleRaised
246     ) {
247         require(newWallet != 0x0);
248         require(newMarketingWallet != 0x0);
249         require(newLiquidityReserveWallet != 0x0);
250         require(newIcoEtherMinCap <= newIcoEtherMaxCap);
251         require(newIcoEtherMinCap > 0);
252         require(newIcoEtherMaxCap > 0);
253 
254         pause();
255 
256         icoEtherMinCap = newIcoEtherMinCap;
257         icoEtherMaxCap = newIcoEtherMaxCap;
258         wallet = newWallet;
259         marketingWallet = newMarketingWallet;
260         liquidityReserveWallet = newLiquidityReserveWallet;
261 
262         // calculate marketingPool and totalSupply based on the max cap:
263         // totalSupply = rate * icoEtherMaxCap + marketingPool
264         // marketingPool = 10% * totalSupply
265         // hence:
266         // totalSupply = 10/9 * rate * icoEtherMaxCap
267         totalSupply = icoEtherMaxCap.mul(rate).mul(10).div(9);
268         marketingPool = totalSupply.div(10);
269 
270         // account for the funds raised during the presale
271         totalRaised = totalRaised.add(totalPresaleRaised);
272 
273         // assign marketing pool to marketing wallet
274         assignTokens(marketingWallet, marketingPool);
275     }
276 
277     /// fallback function to buy tokens
278     function () nonHalted nonZeroPurchase acceptsFunds payable {
279         address recipient = msg.sender;
280         uint256 weiAmount = msg.value;
281 
282         uint256 amount = weiAmount.mul(rate);
283 
284         assignTokens(recipient, amount);
285         totalRaised = totalRaised.add(weiAmount);
286 
287         forwardFundsToWallet();
288     }
289 
290     modifier acceptsFunds() {
291         bool hasStarted = icoStartTimestamp != 0 && now >= icoStartTimestamp;
292         require(hasStarted);
293 
294         // ICO is continued over the end date until the min cap is reached
295         bool isIcoInProgress = now <= icoEndTimestamp
296                 || (icoEndTimestamp == 0) // before dates are set
297                 || totalRaised < icoEtherMinCap;
298         require(isIcoInProgress);
299 
300         bool isBelowMaxCap = totalRaised < icoEtherMaxCap;
301         require(isBelowMaxCap);
302 
303         _;
304     }
305 
306     modifier nonHalted() {
307         require(!halted);
308         _;
309     }
310 
311     modifier nonZeroPurchase() {
312         require(msg.value > 0);
313         _;
314     }
315 
316     function forwardFundsToWallet() internal {
317         wallet.transfer(msg.value); // immediately send Ether to wallet address, propagates exception if execution fails
318     }
319 
320     function assignTokens(address recipient, uint256 amount) internal {
321         balances[recipient] = balances[recipient].add(amount);
322         tokensSold = tokensSold.add(amount);
323 
324         // sanity safeguard
325         if (tokensSold > totalSupply) {
326             // there is a chance that tokens are sold over the supply:
327             // a) when: total presale bonuses > (maxCap - totalRaised) * rate
328             // b) when: last payment goes over the maxCap
329             totalSupply = tokensSold;
330         }
331 
332         Transfer(0x0, recipient, amount);
333     }
334 
335     function setIcoDates(uint256 newIcoStartTimestamp, uint256 newIcoEndTimestamp) public onlyOwner {
336         require(newIcoStartTimestamp < newIcoEndTimestamp);
337         require(!isIcoFinished());
338         icoStartTimestamp = newIcoStartTimestamp;
339         icoEndTimestamp = newIcoEndTimestamp;
340     }
341 
342     function setRate(uint256 _rate) public onlyOwner {
343         require(!isIcoFinished());
344         rate = _rate;
345     }
346 
347     function haltFundraising() public onlyOwner {
348         halted = true;
349     }
350 
351     function unhaltFundraising() public onlyOwner {
352         halted = false;
353     }
354 
355     function isIcoFinished() public constant returns (bool icoFinished) {
356         return (totalRaised >= icoEtherMinCap && icoEndTimestamp != 0 && now > icoEndTimestamp) ||
357                (totalRaised >= icoEtherMaxCap);
358     }
359 
360     function prepareLiquidityReserve() public onlyOwner {
361         require(isIcoFinished());
362         
363         uint256 unsoldTokens = totalSupply.sub(tokensSold);
364         // make sure there are any unsold tokens to be assigned
365         require(unsoldTokens > 0);
366 
367         // try to allocate up to 10% of total sold tokens to Liquidity Reserve fund:
368         uint256 liquidityReserveTokens = tokensSold.div(10);
369         if (liquidityReserveTokens > unsoldTokens) {
370             liquidityReserveTokens = unsoldTokens;
371         }
372         assignTokens(liquidityReserveWallet, liquidityReserveTokens);
373         unsoldTokens = unsoldTokens.sub(liquidityReserveTokens);
374 
375         // if there are still unsold tokens:
376         if (unsoldTokens > 0) {
377             // decrease  (burn) total supply by the number of unsold tokens:
378             totalSupply = totalSupply.sub(unsoldTokens);
379         }
380 
381         // make sure there are no tokens left
382         assert(tokensSold == totalSupply);
383     }
384 
385     function manuallyAssignTokens(address recipient, uint256 amount) public onlyOwner {
386         require(tokensSold < totalSupply);
387         assignTokens(recipient, amount);
388     }
389 
390     /**
391      * @dev Burns a specific amount of tokens.
392      * @param _value The amount of token to be burned.
393      */
394     function burn(uint256 _value) public whenNotPaused {
395         require(_value > 0);
396 
397         address burner = msg.sender;
398         balances[burner] = balances[burner].sub(_value);
399         totalSupply = totalSupply.sub(_value);
400         Burn(burner, _value);
401     }
402 
403 }