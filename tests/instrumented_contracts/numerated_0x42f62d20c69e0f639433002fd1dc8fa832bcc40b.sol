1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22     require(_value <= balances[msg.sender]);
23 
24     // SafeMath.sub will throw if there is not enough balance.
25     balances[msg.sender] = balances[msg.sender].sub(_value);
26     balances[_to] = balances[_to].add(_value);
27     Transfer(msg.sender, _to, _value);
28     return true;
29   }
30 
31   /**
32   * @dev Gets the balance of the specified address.
33   * @param _owner The address to query the the balance of.
34   * @return An uint256 representing the amount owned by the passed address.
35   */
36   function balanceOf(address _owner) public view returns (uint256 balance) {
37     return balances[_owner];
38   }
39 
40 }
41 
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public view returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 contract LANCCrowdsale is Ownable {
87   using SafeMath for uint256;
88 
89   address public fundDepositAddress = 0xE700569B98D4BF25E05c64C96560f77bCD44565E;
90 
91   uint256 public currentPeriod = 0;
92   bool public isFinalized = false;
93   // 0 = Not Started
94   // 1 = PrePresale
95   // 2 = Presale
96   // 3 = Round 1
97   // 4 = Round 2
98   // 5 = Finished
99 
100   mapping (uint256 => uint256) public rateMap;
101   mapping (address => uint256) powerDayAddressLimits;
102 
103   uint256 public powerDayRate; 
104   uint256 public powerDayEthPerPerson = 10;
105   uint256 public presaleStartTime;
106   uint256 public powerDayEndTime;
107 
108   uint256 public constant capPresale =  57 * (10**5) * 10**18;
109   uint256 public constant capRound1 =  (288 * (10**5) * 10**18);
110   uint256 public constant capRound2 =  (484 * (10**5) * 10**18);
111 
112   uint256 public rate = 0; // LANC per ETH
113 
114   // The token being sold
115   LANCToken public token;
116 
117   /**
118    * event for token purchase logging
119    * @param purchaser who paid for the tokens
120    * @param beneficiary who got the tokens
121    * @param value weis paid for purchase
122    * @param amount amount of tokens purchased
123    */
124   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
125 
126 
127   function LANCCrowdsale() public {
128     
129     // Initilize with rates.
130 
131     rateMap[1] = 2100; // PrePresale rate
132     powerDayRate = 2000; // Powerday rate in presale.
133     rateMap[2] = 1900;  // Presale rate
134     rateMap[3] = 1650;  // Round 1 rate
135     rateMap[4] = 1400;  // Round 2 rate
136     rateMap[5] = 0; 
137   }
138 
139   function setTokenContract(address _token) public onlyOwner {
140         require(_token != address(0) && token == address(0));
141         require(LANCToken(_token).owner() == address(this));
142         require(LANCToken(_token).totalSupply() == 0);
143         require(!LANCToken(_token).mintingFinished());
144 
145         token = LANCToken(_token);
146    }
147 
148    function mint(address _to, uint256 _amount) public onlyOwner {
149        require(token != address(0));
150        require(!LANCToken(token).mintingFinished());
151        require(LANCToken(token).owner() == address(this));
152 
153        token.mint(_to, _amount);
154    }
155 
156    // Backup function in case of ETH price fluctuations
157 
158   function updateRates(uint256 rateIdx, uint256 newRate) public onlyOwner {
159     require(rateIdx > 0 && rateIdx < 5);
160     require(newRate > 0);
161 
162     rateMap[rateIdx] = newRate;
163 
164     if (rateIdx == currentPeriod) {
165       rate = newRate;
166     }
167   }
168 
169   function updatePowerDayRate(uint256 newRate) public onlyOwner {
170       powerDayRate = newRate;
171   }
172 
173   function switchSaleState() public onlyOwner {
174     require(token != address(0));
175 
176     if (currentPeriod > 4) {
177       revert(); // Finished, last state is 4
178     }
179 
180     currentPeriod = currentPeriod + 1;
181 
182     if (currentPeriod == 2) {
183       presaleStartTime = now;
184       powerDayEndTime = (presaleStartTime + 1 days);
185     }
186 
187     rate = rateMap[currentPeriod];
188   }
189 
190   function () external payable {
191     buyTokens(msg.sender);
192   }
193 
194   // low level token purchase function
195   function buyTokens(address beneficiary) public payable {
196     require(token != address(0));
197     require(beneficiary != address(0));
198     require(validPurchase());
199 
200     uint256 weiAmount = msg.value;
201     uint256 currentRate = rate;
202     uint256 tokens;
203     bool inPowerDay = saleInPowerDay();
204 
205     // calculate token amount to be created   
206     
207     // Assign power day rate if in power day.
208     if (inPowerDay == true) {
209       tokens = weiAmount.mul(powerDayRate);      
210     } else {
211       tokens = weiAmount.mul(currentRate);      
212     }
213     
214     // calculate supply after potential token mint
215     uint256 checkedSupply = token.totalSupply().add(tokens);
216     require(willFitInCap(checkedSupply));
217     // check if new supply fits within current cap.
218 
219     if (inPowerDay == true) {
220       uint256 newWeiAmountPerSender = powerDayAddressLimits[msg.sender].add(weiAmount);
221 
222       // Check if the person has reached their power day limit.
223       if (newWeiAmountPerSender > powerDayPerPersonCapInWei()) {
224         revert();
225       } else {
226         powerDayAddressLimits[msg.sender] = newWeiAmountPerSender;
227       }
228     }
229 
230     // Generate the tokens by using MintableToken's mint method.
231     
232     token.mint(beneficiary, tokens);
233 
234     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
235 
236     forwardFunds();
237   }
238 
239   function saleInPowerDay() internal view returns (bool) {
240     bool inPresale = (currentPeriod == 2);
241     bool inPowerDayPeriod = (now >= presaleStartTime && now <= powerDayEndTime);
242 
243     return inPresale && inPowerDayPeriod;
244   }
245 
246   function powerDayPerPersonCapInWei() public view returns (uint) {
247     require(token != address(0));
248       // Calculate per-person cap in wei during power day.
249 
250     return powerDayEthPerPerson * (10**token.decimals()); 
251   }
252   
253 
254   function willFitInCap(uint256 checkedSupply) internal view returns (bool) {
255     if (currentPeriod == 1 || currentPeriod == 2) {
256       return (checkedSupply <= capPresale);
257     } else if (currentPeriod == 3) {
258       return (checkedSupply <= capRound1);
259     } else if (currentPeriod == 4) {
260       return (checkedSupply <= capRound2);
261     }
262 
263     return false;
264   }
265 
266   // @return true if the transaction can buy tokens
267   function validPurchase() internal view returns (bool) {
268     bool tokenAssigned = (token != address(0));
269     bool inStartedState = (currentPeriod > 0 && currentPeriod < 5);
270     bool nonZeroPurchase = msg.value != 0;
271 
272     return tokenAssigned && inStartedState && nonZeroPurchase && !isFinalized;
273   }
274 
275   // Finalize the sale and calculate final token supply and distribute amounts.
276   function finalizeSale() public onlyOwner {
277     if (isFinalized == true) {
278       revert();
279     }
280 
281     uint newTokens = token.totalSupply();
282 
283     // Raise the remaining amounts
284     token.mint(fundDepositAddress, newTokens);
285 
286     token.finishMinting();
287     token.transferOwnership(owner);
288 
289     isFinalized = true;
290   }
291 
292   // @return true if crowdsale event has ended
293   function hasEnded() public view returns (bool) {
294     return currentPeriod > 4;
295   }
296 
297   // send ether to the fund collection wallet
298   // override to create custom fund forwarding mechanisms
299   function forwardFunds() internal {
300     fundDepositAddress.transfer(msg.value);
301   }
302 
303   function powerDayRemainingLimitOf(address _owner) public view returns (uint256 balance) {
304     return powerDayAddressLimits[_owner];
305   }
306 
307 }
308 
309 library SafeMath {
310   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311     if (a == 0) {
312       return 0;
313     }
314     uint256 c = a * b;
315     assert(c / a == b);
316     return c;
317   }
318 
319   function div(uint256 a, uint256 b) internal pure returns (uint256) {
320     // assert(b > 0); // Solidity automatically throws when dividing by 0
321     uint256 c = a / b;
322     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
323     return c;
324   }
325 
326   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
327     assert(b <= a);
328     return a - b;
329   }
330 
331   function add(uint256 a, uint256 b) internal pure returns (uint256) {
332     uint256 c = a + b;
333     assert(c >= a);
334     return c;
335   }
336 }
337 
338 contract StandardToken is ERC20, BasicToken {
339 
340   mapping (address => mapping (address => uint256)) internal allowed;
341 
342 
343   /**
344    * @dev Transfer tokens from one address to another
345    * @param _from address The address which you want to send tokens from
346    * @param _to address The address which you want to transfer to
347    * @param _value uint256 the amount of tokens to be transferred
348    */
349   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
350     require(_to != address(0));
351     require(_value <= balances[_from]);
352     require(_value <= allowed[_from][msg.sender]);
353 
354     balances[_from] = balances[_from].sub(_value);
355     balances[_to] = balances[_to].add(_value);
356     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
357     Transfer(_from, _to, _value);
358     return true;
359   }
360 
361   /**
362    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
363    *
364    * Beware that changing an allowance with this method brings the risk that someone may use both the old
365    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
366    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
367    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368    * @param _spender The address which will spend the funds.
369    * @param _value The amount of tokens to be spent.
370    */
371   function approve(address _spender, uint256 _value) public returns (bool) {
372     allowed[msg.sender][_spender] = _value;
373     Approval(msg.sender, _spender, _value);
374     return true;
375   }
376 
377   /**
378    * @dev Function to check the amount of tokens that an owner allowed to a spender.
379    * @param _owner address The address which owns the funds.
380    * @param _spender address The address which will spend the funds.
381    * @return A uint256 specifying the amount of tokens still available for the spender.
382    */
383   function allowance(address _owner, address _spender) public view returns (uint256) {
384     return allowed[_owner][_spender];
385   }
386 
387   /**
388    * @dev Increase the amount of tokens that an owner allowed to a spender.
389    *
390    * approve should be called when allowed[_spender] == 0. To increment
391    * allowed value is better to use this function to avoid 2 calls (and wait until
392    * the first transaction is mined)
393    * From MonolithDAO Token.sol
394    * @param _spender The address which will spend the funds.
395    * @param _addedValue The amount of tokens to increase the allowance by.
396    */
397   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
398     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
399     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
400     return true;
401   }
402 
403   /**
404    * @dev Decrease the amount of tokens that an owner allowed to a spender.
405    *
406    * approve should be called when allowed[_spender] == 0. To decrement
407    * allowed value is better to use this function to avoid 2 calls (and wait until
408    * the first transaction is mined)
409    * From MonolithDAO Token.sol
410    * @param _spender The address which will spend the funds.
411    * @param _subtractedValue The amount of tokens to decrease the allowance by.
412    */
413   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
414     uint oldValue = allowed[msg.sender][_spender];
415     if (_subtractedValue > oldValue) {
416       allowed[msg.sender][_spender] = 0;
417     } else {
418       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
419     }
420     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
421     return true;
422   }
423 
424 }
425 
426 contract MintableToken is StandardToken, Ownable {
427   event Mint(address indexed to, uint256 amount);
428   event MintFinished();
429 
430   bool public mintingFinished = false;
431 
432 
433   modifier canMint() {
434     require(!mintingFinished);
435     _;
436   }
437 
438   /**
439    * @dev Function to mint tokens
440    * @param _to The address that will receive the minted tokens.
441    * @param _amount The amount of tokens to mint.
442    * @return A boolean that indicates if the operation was successful.
443    */
444   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
445     totalSupply = totalSupply.add(_amount);
446     balances[_to] = balances[_to].add(_amount);
447     Mint(_to, _amount);
448     Transfer(address(0), _to, _amount);
449     return true;
450   }
451 
452   /**
453    * @dev Function to stop minting new tokens.
454    * @return True if the operation was successful.
455    */
456   function finishMinting() onlyOwner canMint public returns (bool) {
457     mintingFinished = true;
458     MintFinished();
459     return true;
460   }
461 }
462 
463 contract LANCToken is MintableToken {
464 
465   string public name = "LanceChain Token";
466   string public symbol = "LANC";
467   uint public decimals = 18;
468   
469 }