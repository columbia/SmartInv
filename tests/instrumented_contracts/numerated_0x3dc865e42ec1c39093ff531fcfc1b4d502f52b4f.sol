1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
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
32 }
33 
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public constant returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120 
121     uint256 _allowance = allowed[_from][msg.sender];
122 
123     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
124     // require (_value <= _allowance);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = _allowance.sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    *
136    * Beware that changing an allowance with this method brings the risk that someone may use both the old
137    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifying the amount of tokens still available for the spender.
154    */
155   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
156     return allowed[_owner][_spender];
157   }
158 
159   /**
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    */
165   function increaseApproval (address _spender, uint _addedValue)
166     returns (bool success) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval (address _spender, uint _subtractedValue)
173     returns (bool success) {
174     uint oldValue = allowed[msg.sender][_spender];
175     if (_subtractedValue > oldValue) {
176       allowed[msg.sender][_spender] = 0;
177     } else {
178       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179     }
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184 }
185 
186 
187 
188 contract DeepToken is StandardToken {
189 
190     using SafeMath for uint256;
191 
192     // data structures
193     enum States {
194     Initial, // deployment time
195     ValuationSet, // set ICO parameters
196     Ico, // whitelist addresses, accept funds, update balances
197     Operational, // manage contests
198     Paused // for contract upgrades
199     }
200 
201     string public constant name = "DeepToken";
202 
203     string public constant symbol = "DTA";
204 
205     uint8 public constant decimals = 18;
206 
207     uint256 public constant pointMultiplier = (10 ** uint256(decimals));
208 
209     mapping (address => bool) public whitelist;
210 
211     address public initialHolder;
212 
213     address public stateControl;
214 
215     address public whitelistControl;
216 
217     address public withdrawControl;
218 
219     address public usdCurrencyFunding;
220 
221     States public state;
222 
223     uint256 public tokenPriceInWei;
224 
225     uint256 public percentForSale;
226 
227     uint256 public totalNumberOfTokensForSale;
228 
229     uint256 public silencePeriod;
230 
231     uint256 public startAcceptingFundsBlock;
232 
233     uint256 public endBlock;
234 
235     uint256 public etherBalance;
236 
237     uint256 public usdCentsBalance;
238 
239     uint256 public tokensSold;
240 
241     //this creates the contract and stores the owner. it also passes in 3 addresses to be used later during the lifetime of the contract.
242     function DeepToken(address _stateControl, address _whitelistControl, address _withdraw, address _initialHolder, address _usdCurrencyFunding) {
243         require (_initialHolder != address(0));
244         require (_stateControl != address(0));
245         require (_whitelistControl != address(0));
246         require (_withdraw != address(0));
247         require (_usdCurrencyFunding != address(0));
248         initialHolder = _initialHolder;
249         stateControl = _stateControl;
250         whitelistControl = _whitelistControl;
251         withdrawControl = _withdraw;
252         usdCurrencyFunding = _usdCurrencyFunding;
253         moveToState(States.Initial);
254         totalSupply = 0;
255         tokenPriceInWei = 0;
256         percentForSale = 0;
257         totalNumberOfTokensForSale = 0;
258         silencePeriod = 0;
259         startAcceptingFundsBlock = uint256(int256(-1));
260         endBlock = 0;
261         etherBalance = 0;
262         usdCentsBalance = 0;
263         tokensSold = 0;
264         balances[initialHolder] = totalSupply;
265     }
266 
267     event Whitelisted(address addr);
268 
269     event Dewhitelisted(address addr);
270 
271     event Credited(address addr, uint balance, uint txAmount);
272 
273     event USDCentsBalance(uint balance);
274 
275     event TokenByFiatCredited(address addr, uint balance, uint txAmount, uint256 requestId);
276 
277     event StateTransition(States oldState, States newState);
278 
279     modifier onlyWhitelist() {
280         require(msg.sender == whitelistControl);
281         _;
282     }
283 
284     modifier onlyStateControl() {
285         require(msg.sender == stateControl);
286         _;
287     }
288 
289     modifier requireState(States _requiredState) {
290         require(state == _requiredState);
291         _;
292     }
293 
294     /**
295     BEGIN ICO functions
296     */
297 
298     //this is the main funding function, it updates the balances of DeepTokens during the ICO.
299     //no particular incentive schemes have been implemented here
300     //it is only accessible during the "ICO" phase.
301     function() payable
302     requireState(States.Ico)
303     {
304         require(msg.sender != whitelistControl);
305         require(whitelist[msg.sender] == true);
306         uint256 deepTokenIncrease = (msg.value * pointMultiplier) / tokenPriceInWei;
307         require(getTokensAvailableForSale() >= deepTokenIncrease);
308         require(block.number < endBlock);
309         require(block.number >= startAcceptingFundsBlock);
310         etherBalance = etherBalance.add(msg.value);
311         balances[initialHolder] = balances[initialHolder].sub(deepTokenIncrease);
312         balances[msg.sender] = balances[msg.sender].add(deepTokenIncrease);
313         tokensSold = tokensSold.add(deepTokenIncrease);
314         withdrawControl.transfer(msg.value);
315         Credited(msg.sender, balances[msg.sender], msg.value);
316     }
317 
318     function recordPayment(uint256 usdCentsAmount, uint256 tokenAmount, uint256 requestId)
319     onlyWhitelist
320     requireState(States.Ico)
321     {
322         require(getTokensAvailableForSale() >= tokenAmount);
323         require(block.number < endBlock);
324         require(block.number >= startAcceptingFundsBlock);
325 
326         usdCentsBalance = usdCentsBalance.add(usdCentsAmount);
327         balances[initialHolder] = balances[initialHolder].sub(tokenAmount);
328         balances[usdCurrencyFunding] = balances[usdCurrencyFunding].add(tokenAmount);
329         tokensSold = tokensSold.add(tokenAmount);
330 
331         USDCentsBalance(usdCentsBalance);
332         TokenByFiatCredited(usdCurrencyFunding, balances[usdCurrencyFunding], tokenAmount, requestId);
333     }
334 
335     function moveToState(States _newState)
336     internal
337     {
338         StateTransition(state, _newState);
339         state = _newState;
340     }
341 
342     function getTokensAvailableForSale()
343     constant
344     returns (uint256 tokensAvailableForSale)
345     {
346         return (totalNumberOfTokensForSale.sub(tokensSold));
347     }
348 
349     // ICO contract configuration function
350     // _newTotalSupply is the number of tokens available
351     // _newTokenPriceInWei is the token price in wei
352     // _newPercentForSale is the percentage of _newTotalSupply available for sale
353     // _newsilencePeriod is a number of blocks to wait after starting the ICO. No funds are accepted during the silence period. It can be set to zero.
354     // _newEndBlock is the absolute block number at which the ICO must stop. It must be set after now + silence period.
355     function updateEthICOThresholds(uint256 _newTotalSupply, uint256 _newTokenPriceInWei, uint256 _newPercentForSale, uint256 _newSilencePeriod, uint256 _newEndBlock)
356     onlyStateControl
357     {
358         require(state == States.Initial || state == States.ValuationSet);
359         require(_newTotalSupply > 0);
360         require(_newTokenPriceInWei > 0);
361         require(_newPercentForSale > 0);
362         require(_newPercentForSale <= 100);
363         require((_newTotalSupply * _newPercentForSale / 100) > 0);
364         require(block.number < _newEndBlock);
365         require(block.number + _newSilencePeriod < _newEndBlock);
366 
367         totalSupply = _newTotalSupply;
368         percentForSale = _newPercentForSale;
369         totalNumberOfTokensForSale = totalSupply.mul(percentForSale).div(100);
370         tokenPriceInWei = _newTokenPriceInWei;
371         silencePeriod = _newSilencePeriod;
372         endBlock = _newEndBlock;
373 
374         balances[initialHolder] = totalSupply;
375 
376         moveToState(States.ValuationSet);
377     }
378 
379     function startICO()
380     onlyStateControl
381     requireState(States.ValuationSet)
382     {
383         require(block.number < endBlock);
384         require(block.number + silencePeriod < endBlock);
385         startAcceptingFundsBlock = block.number + silencePeriod;
386         moveToState(States.Ico);
387     }
388 
389     function endICO()
390     onlyStateControl
391     requireState(States.Ico)
392     {
393         burnUnsoldCoins();
394         moveToState(States.Operational);
395     }
396 
397     function anyoneEndICO()
398     requireState(States.Ico)
399     {
400         require(block.number > endBlock);
401         burnUnsoldCoins();
402         moveToState(States.Operational);
403     }
404 
405     function burnUnsoldCoins()
406     internal
407     {
408         //slashing the initial supply, so that the ICO is selling percentForSale% total
409         totalSupply = tokensSold.mul(100).div(percentForSale);
410         balances[initialHolder] = totalSupply.sub(tokensSold);
411     }
412 
413     function addToWhitelist(address _whitelisted)
414     onlyWhitelist
415     {
416         whitelist[_whitelisted] = true;
417         Whitelisted(_whitelisted);
418     }
419 
420     function removeFromWhitelist(address _whitelisted)
421     onlyWhitelist
422     {
423         whitelist[_whitelisted] = false;
424         Dewhitelisted(_whitelisted);
425     }
426 
427     //emergency pause for the ICO
428     function pause()
429     onlyStateControl
430     requireState(States.Ico)
431     {
432         moveToState(States.Paused);
433     }
434 
435     //un-pause
436     function resumeICO()
437     onlyStateControl
438     requireState(States.Paused)
439     {
440         moveToState(States.Ico);
441     }
442     /**
443     END ICO functions
444     */
445 
446     /**
447     BEGIN ERC20 functions
448     */
449 
450     function transfer(address _to, uint256 _value)
451     returns (bool success) {
452         require((state == States.Ico) || (state == States.Operational));
453         return super.transfer(_to, _value);
454     }
455 
456     function transferFrom(address _from, address _to, uint256 _value)
457     returns (bool success) {
458         require((state == States.Ico) || (state == States.Operational));
459         return super.transferFrom(_from, _to, _value);
460     }
461 
462     function balanceOf(address _account)
463     constant
464     returns (uint256 balance) {
465         return balances[_account];
466     }
467 
468     /**
469     END ERC20 functions
470     */
471 }