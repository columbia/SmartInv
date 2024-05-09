1 pragma solidity 0.4.19;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18   using SafeMath for uint256;
19   mapping(address => uint256) balances;
20   uint256 totalSupply_;
21 
22   /**
23   * @dev total number of tokens in existence
24   */
25   function totalSupply() public view returns (uint256) {
26     return totalSupply_;
27   }
28 
29   /**
30   * @dev transfer token for a specified address
31   * @param _to The address to transfer to.
32   * @param _value The amount to be transferred.
33   */
34   function transfer(address _to, uint256 _value) public returns (bool) {
35     require(_to != address(0));
36     require(_value <= balances[msg.sender]);
37 
38     // SafeMath.sub will throw if there is not enough balance.
39     balances[msg.sender] = balances[msg.sender].sub(_value);
40     balances[_to] = balances[_to].add(_value);
41     Transfer(msg.sender, _to, _value);
42     return true;
43   }
44 
45   /**
46   * @dev Gets the balance of the specified address.
47   * @param _owner The address to query the the balance of.
48   * @return An uint256 representing the amount owned by the passed address.
49   */
50   function balanceOf(address _owner) public view returns (uint256 balance) {
51     return balances[_owner];
52   }
53 
54 }
55 contract StandardToken is ERC20, BasicToken {
56 
57   mapping (address => mapping (address => uint256)) internal allowed;
58 
59 
60   /**
61    * @dev Transfer tokens from one address to another
62    * @param _from address The address which you want to send tokens from
63    * @param _to address The address which you want to transfer to
64    * @param _value uint256 the amount of tokens to be transferred
65    */
66   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
67     require(_to != address(0));
68     require(_value <= balances[_from]);
69     require(_value <= allowed[_from][msg.sender]);
70 
71     balances[_from] = balances[_from].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
74     Transfer(_from, _to, _value);
75     return true;
76   }
77 
78   /**
79    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
80    *
81    * Beware that changing an allowance with this method brings the risk that someone may use both the old
82    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
83    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
84    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85    * @param _spender The address which will spend the funds.
86    * @param _value The amount of tokens to be spent.
87    */
88   function approve(address _spender, uint256 _value) public returns (bool) {
89     allowed[msg.sender][_spender] = _value;
90     Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   /**
95    * @dev Function to check the amount of tokens that an owner allowed to a spender.
96    * @param _owner address The address which owns the funds.
97    * @param _spender address The address which will spend the funds.
98    * @return A uint256 specifying the amount of tokens still available for the spender.
99    */
100   function allowance(address _owner, address _spender) public view returns (uint256) {
101     return allowed[_owner][_spender];
102   }
103 
104   /**
105    * @dev Increase the amount of tokens that an owner allowed to a spender.
106    *
107    * approve should be called when allowed[_spender] == 0. To increment
108    * allowed value is better to use this function to avoid 2 calls (and wait until
109    * the first transaction is mined)
110    * From MonolithDAO Token.sol
111    * @param _spender The address which will spend the funds.
112    * @param _addedValue The amount of tokens to increase the allowance by.
113    */
114   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
115     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
116     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120   /**
121    * @dev Decrease the amount of tokens that an owner allowed to a spender.
122    *
123    * approve should be called when allowed[_spender] == 0. To decrement
124    * allowed value is better to use this function to avoid 2 calls (and wait until
125    * the first transaction is mined)
126    * From MonolithDAO Token.sol
127    * @param _spender The address which will spend the funds.
128    * @param _subtractedValue The amount of tokens to decrease the allowance by.
129    */
130   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
131     uint oldValue = allowed[msg.sender][_spender];
132     if (_subtractedValue > oldValue) {
133       allowed[msg.sender][_spender] = 0;
134     } else {
135       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
136     }
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141 }
142 contract Ownable {
143   address public owner;
144 
145   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
146 
147   /**
148    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
149    * account.
150    */
151   function Ownable() public {
152     owner = msg.sender;
153   }
154 
155   /**
156    * @dev Throws if called by any account other than the owner.
157    */
158   modifier onlyOwner() {
159     require(msg.sender == owner);
160     _;
161   }
162 
163   /**
164    * @dev Allows the current owner to transfer control of the contract to a newOwner.
165    * @param newOwner The address to transfer ownership to.
166    */
167   function transferOwnership(address newOwner) public onlyOwner {
168     require(newOwner != address(0));
169     OwnershipTransferred(owner, newOwner);
170     owner = newOwner;
171   }
172 
173 }
174 contract MintableToken is StandardToken, Ownable {
175   event Mint(address indexed to, uint256 amount);
176   event MintFinished();
177 
178   bool public mintingFinished = false;
179 
180 
181   modifier canMint() {
182     require(!mintingFinished);
183     _;
184   }
185 
186   /**
187    * @dev Function to mint tokens
188    * @param _to The address that will receive the minted tokens.
189    * @param _amount The amount of tokens to mint.
190    * @return A boolean that indicates if the operation was successful.
191    */
192   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
193     totalSupply_ = totalSupply_.add(_amount);
194     balances[_to] = balances[_to].add(_amount);
195     Mint(_to, _amount);
196     Transfer(address(0), _to, _amount);
197     return true;
198   }
199 
200   /**
201    * @dev Function to stop minting new tokens.
202    * @return True if the operation was successful.
203    */
204   function finishMinting() onlyOwner canMint public returns (bool) {
205     mintingFinished = true;
206     MintFinished();
207     return true;
208   }
209 }
210 
211 contract CappedToken is MintableToken {
212 
213   uint256 public cap;
214 
215   function CappedToken(uint256 _cap) public {
216     require(_cap > 0);
217     cap = _cap;
218   }
219 
220   /**
221    * @dev Function to mint tokens
222    * @param _to The address that will receive the minted tokens.
223    * @param _amount The amount of tokens to mint.
224    * @return A boolean that indicates if the operation was successful.
225    */
226   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
227     require(totalSupply_.add(_amount) <= cap);
228 
229     return super.mint(_to, _amount);
230   }
231 
232 }
233 contract TokenTimelock {
234   using SafeERC20 for ERC20Basic;
235 
236   // ERC20 basic token contract being held
237   ERC20Basic public token;
238 
239   // beneficiary of tokens after they are released
240   address public beneficiary;
241 
242   // timestamp when token release is enabled
243   uint256 public releaseTime;
244 
245   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
246     require(_releaseTime > now);
247     token = _token;
248     beneficiary = _beneficiary;
249     releaseTime = _releaseTime;
250   }
251 
252   /**
253    * @notice Transfers tokens held by timelock to beneficiary.
254    */
255   function release() public {
256     require(now >= releaseTime);
257 
258     uint256 amount = token.balanceOf(this);
259     require(amount > 0);
260 
261     token.safeTransfer(beneficiary, amount);
262   }
263 }
264 contract TokenVesting is Ownable {
265   using SafeMath for uint256;
266   using SafeERC20 for ERC20Basic;
267 
268   event Released(uint256 amount);
269   event Revoked();
270 
271   // beneficiary of tokens after they are released
272   address public beneficiary;
273 
274   uint256 public cliff;
275   uint256 public start;
276   uint256 public duration;
277 
278   bool public revocable;
279 
280   mapping (address => uint256) public released;
281   mapping (address => bool) public revoked;
282 
283   /**
284    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
285    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
286    * of the balance will have vested.
287    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
288    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
289    * @param _duration duration in seconds of the period in which the tokens will vest
290    * @param _revocable whether the vesting is revocable or not
291    */
292   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
293     require(_beneficiary != address(0));
294     require(_cliff <= _duration);
295 
296     beneficiary = _beneficiary;
297     revocable = _revocable;
298     duration = _duration;
299     cliff = _start.add(_cliff);
300     start = _start;
301   }
302 
303   /**
304    * @notice Transfers vested tokens to beneficiary.
305    * @param token ERC20 token which is being vested
306    */
307   function release(ERC20Basic token) public {
308     uint256 unreleased = releasableAmount(token);
309 
310     require(unreleased > 0);
311 
312     released[token] = released[token].add(unreleased);
313 
314     token.safeTransfer(beneficiary, unreleased);
315 
316     Released(unreleased);
317   }
318 
319   /**
320    * @notice Allows the owner to revoke the vesting. Tokens already vested
321    * remain in the contract, the rest are returned to the owner.
322    * @param token ERC20 token which is being vested
323    */
324   function revoke(ERC20Basic token) public onlyOwner {
325     require(revocable);
326     require(!revoked[token]);
327 
328     uint256 balance = token.balanceOf(this);
329 
330     uint256 unreleased = releasableAmount(token);
331     uint256 refund = balance.sub(unreleased);
332 
333     revoked[token] = true;
334 
335     token.safeTransfer(owner, refund);
336 
337     Revoked();
338   }
339 
340   /**
341    * @dev Calculates the amount that has already vested but hasn't been released yet.
342    * @param token ERC20 token which is being vested
343    */
344   function releasableAmount(ERC20Basic token) public view returns (uint256) {
345     return vestedAmount(token).sub(released[token]);
346   }
347 
348   /**
349    * @dev Calculates the amount that has already vested.
350    * @param token ERC20 token which is being vested
351    */
352   function vestedAmount(ERC20Basic token) public view returns (uint256) {
353     uint256 currentBalance = token.balanceOf(this);
354     uint256 totalBalance = currentBalance.add(released[token]);
355 
356     if (now < cliff) {
357       return 0;
358     } else if (now >= start.add(duration) || revoked[token]) {
359       return totalBalance;
360     } else {
361       return totalBalance.mul(now.sub(start)).div(duration);
362     }
363   }
364 }
365 contract NebulaToken is CappedToken{
366     using SafeMath for uint256;
367     string public constant name = "Nebula AI Token";
368     string public constant symbol = "NBAI";
369     uint8 public constant decimals = 18;
370 
371     bool public pvt_plmt_set;
372     uint256 public pvt_plmt_max_in_Wei;
373     uint256 public pvt_plmt_remaining_in_Wei;
374     uint256 public pvt_plmt_token_generated;
375 
376     TokenVesting public foundation_vesting_contract;
377     uint256 public token_unlock_time = 1524887999; //April 27th 2018 23:59:59 GMT-4:00, 7 days after completion
378 
379     mapping(address => TokenTimelock[]) public time_locked_reclaim_addresses;
380 
381     //vesting starts on April 21th 2018 00:00 GMT-4:00
382     //vesting duration is 3 years
383     function NebulaToken() CappedToken(6700000000 * 1 ether) public{
384         uint256 foundation_held = cap.mul(55).div(100);//55% fixed for early investors, partners, nebula internal and foundation
385         address foundation_beneficiary_wallet = 0xD86FCe1890bf98fC086b264a66cA96C7E3B03B40;//multisig wallet
386         foundation_vesting_contract = new TokenVesting(foundation_beneficiary_wallet, 1524283200, 0, 3 years, false);
387         assert(mint(foundation_vesting_contract, foundation_held));
388         FoundationTokenGenerated(foundation_vesting_contract, foundation_beneficiary_wallet, foundation_held);
389     }
390 
391     //Crowdsale contract mints and stores tokens in time locked contracts during crowdsale.
392     //Ownership is transferred back to the owner of crowdsale contract once crowdsale is finished(finalize())
393     function create_public_sale_token(address _beneficiary, uint256 _token_amount) external onlyOwner returns(bool){
394         assert(mint_time_locked_token(_beneficiary, _token_amount) != address(0));
395         return true;
396     }
397 
398     //@dev Can only set once
399     function set_private_sale_total(uint256 _pvt_plmt_max_in_Wei) external onlyOwner returns(bool){
400         require(!pvt_plmt_set && _pvt_plmt_max_in_Wei >= 5000 ether);//_pvt_plmt_max_in_wei is minimum the soft cap
401         pvt_plmt_set = true;
402         pvt_plmt_max_in_Wei = _pvt_plmt_max_in_Wei;
403         pvt_plmt_remaining_in_Wei = pvt_plmt_max_in_Wei;
404         PrivateSalePlacementLimitSet(pvt_plmt_max_in_Wei);
405     }
406     /**
407      * Private sale distributor
408      * private sale total is set once, irreversible and not modifiable
409      * Once this amount in wei is reduced to 0, no more token can be generated as private sale!
410      * Maximum token generated by private sale is pvt_plmt_max_in_Wei * 125000 (discount upper limit)
411      * Note 1, Private sale limit is the balance of private sale fond wallet balance as of 23:59 UTC March 29th 2019
412      * Note 2, no ether is transferred to neither the crowdsale contract nor this one for private sale
413      * totalSupply_ = pvt_plmt_token_generated + foundation_held + weiRaised * 100000
414      * _beneficiary: private sale buyer address
415      * _wei_amount: amount in wei that the buyer bought
416      * _rate: rate that the private sale buyer has agreed with NebulaAi
417      */
418     function distribute_private_sale_fund(address _beneficiary, uint256 _wei_amount, uint256 _rate) public onlyOwner returns(bool){
419         require(pvt_plmt_set && _beneficiary != address(0) && pvt_plmt_remaining_in_Wei >= _wei_amount && _rate >= 100000 && _rate <= 125000);
420 
421         pvt_plmt_remaining_in_Wei = pvt_plmt_remaining_in_Wei.sub(_wei_amount);//remove from limit
422         uint256 _token_amount = _wei_amount.mul(_rate); //calculate token amount to be generated
423         pvt_plmt_token_generated = pvt_plmt_token_generated.add(_token_amount);//add generated amount to total private sale token
424 
425         //Mint token if unlocked time has been reached, directly mint to beneficiary, else create time locked contract
426         address _ret;
427         if(now < token_unlock_time) assert((_ret = mint_time_locked_token(_beneficiary, _token_amount))!=address(0));
428         else assert(mint(_beneficiary, _token_amount));
429 
430         PrivateSaleTokenGenerated(_ret, _beneficiary, _token_amount);
431         return true;
432     }
433     //used for private and public sale to create time locked contract before lock release time
434     //Note: TokenTimelock constructor will throw after token unlock time is reached
435     function mint_time_locked_token(address _beneficiary, uint256 _token_amount) internal returns(TokenTimelock _locked){
436         _locked = new TokenTimelock(this, _beneficiary, token_unlock_time);
437         time_locked_reclaim_addresses[_beneficiary].push(_locked);
438         assert(mint(_locked, _token_amount));
439     }
440 
441     //Release all tokens held by time locked contracts to the beneficiary address stored in the contract
442     //Note: requirement is checked in time lock contract
443     function release_all(address _beneficiary) external returns(bool){
444         require(time_locked_reclaim_addresses[_beneficiary].length > 0);
445         TokenTimelock[] memory _locks = time_locked_reclaim_addresses[_beneficiary];
446         for(uint256 i = 0 ; i < _locks.length; ++i) _locks[i].release();
447         return true;
448     }
449 
450     //override to add a checker
451     function finishMinting() onlyOwner canMint public returns (bool){
452         require(pvt_plmt_set && pvt_plmt_remaining_in_Wei == 0);
453         super.finishMinting();
454     }
455 
456     function get_time_locked_contract_size(address _owner) external view returns(uint256){
457         return time_locked_reclaim_addresses[_owner].length;
458     }
459 
460     event PrivateSaleTokenGenerated(address indexed _time_locked, address indexed _beneficiary, uint256 _amount);
461     event FoundationTokenGenerated(address indexed _vesting, address indexed _beneficiary, uint256 _amount);
462     event PrivateSalePlacementLimitSet(uint256 _limit);
463     function () public payable{revert();}//This contract is not payable
464 }
465 library SafeMath {
466 
467   /**
468   * @dev Multiplies two numbers, throws on overflow.
469   */
470   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
471     if (a == 0) {
472       return 0;
473     }
474     uint256 c = a * b;
475     assert(c / a == b);
476     return c;
477   }
478 
479   /**
480   * @dev Integer division of two numbers, truncating the quotient.
481   */
482   function div(uint256 a, uint256 b) internal pure returns (uint256) {
483     // assert(b > 0); // Solidity automatically throws when dividing by 0
484     uint256 c = a / b;
485     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
486     return c;
487   }
488 
489   /**
490   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
491   */
492   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
493     assert(b <= a);
494     return a - b;
495   }
496 
497   /**
498   * @dev Adds two numbers, throws on overflow.
499   */
500   function add(uint256 a, uint256 b) internal pure returns (uint256) {
501     uint256 c = a + b;
502     assert(c >= a);
503     return c;
504   }
505 }
506 library SafeERC20 {
507   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
508     assert(token.transfer(to, value));
509   }
510 
511   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
512     assert(token.transferFrom(from, to, value));
513   }
514 
515   function safeApprove(ERC20 token, address spender, uint256 value) internal {
516     assert(token.approve(spender, value));
517   }
518 }