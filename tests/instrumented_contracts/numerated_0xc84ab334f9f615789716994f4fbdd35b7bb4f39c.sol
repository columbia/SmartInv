1 pragma solidity^0.4.24;
2 
3 /**
4 * 
5 *    
6 *       ▄▄▄▄███▄▄▄▄    ▄██████▄  ▀█████████▄   ▄█  ███    █▄     ▄████████      
7 *     ▄██▀▀▀███▀▀▀██▄ ███    ███   ███    ███ ███  ███    ███   ███    ███      
8 *     ███   ███   ███ ███    ███   ███    ███ ███▌ ███    ███   ███    █▀       
9 *     ███   ███   ███ ███    ███  ▄███▄▄▄██▀  ███▌ ███    ███   ███             
10 *     ███   ███   ███ ███    ███ ▀▀███▀▀▀██▄  ███▌ ███    ███ ▀███████████      
11 *     ███   ███   ███ ███    ███   ███    ██▄ ███  ███    ███          ███      
12 *     ███   ███   ███ ███    ███   ███    ███ ███  ███    ███    ▄█    ███      
13 *      ▀█   ███   █▀   ▀██████▀  ▄█████████▀  █▀   ████████▀   ▄████████▀       
14 *                                                                               
15 *    ▀█████████▄   ▄█       ███    █▄     ▄████████                             
16 *      ███    ███ ███       ███    ███   ███    ███                             
17 *      ███    ███ ███       ███    ███   ███    █▀                              
18 *     ▄███▄▄▄██▀  ███       ███    ███  ▄███▄▄▄                                 
19 *    ▀▀███▀▀▀██▄  ███       ███    ███ ▀▀███▀▀▀                                 
20 *      ███    ██▄ ███       ███    ███   ███    █▄                              
21 *      ███    ███ ███▌    ▄ ███    ███   ███    ███                             
22 *    ▄█████████▀  █████▄▄██ ████████▀    ██████████                             
23 *                 ▀                                                             
24 *     
25 *   ////////     https://mobius.blue       \\\\\\\
26 *  //////// BLU Token Holders receive divs  \\\\\\\
27 * 
28 */
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipRenounced(address indexed previousOwner);
35   event OwnershipTransferred(
36     address indexed previousOwner,
37     address indexed newOwner
38   );
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   constructor() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to relinquish control of the contract.
59    * @notice Renouncing to ownership will leave the contract without an owner.
60    * It will not be possible to call the functions with the `onlyOwner`
61    * modifier anymore.
62    */
63   function renounceOwnership() public onlyOwner {
64     emit OwnershipRenounced(owner);
65     owner = address(0);
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param _newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address _newOwner) public onlyOwner {
73     _transferOwnership(_newOwner);
74   }
75 
76   /**
77    * @dev Transfers control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function _transferOwnership(address _newOwner) internal {
81     require(_newOwner != address(0));
82     emit OwnershipTransferred(owner, _newOwner);
83     owner = _newOwner;
84   }
85 }
86 
87 contract StandardToken  {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   mapping (address => mapping (address => uint256)) internal allowed;
93 
94   uint256 totalSupply_;
95 
96   event Transfer(
97     address indexed from,
98     address indexed to,
99     uint256 value
100   );
101 
102   event Approval(
103     address indexed owner,
104     address indexed spender,
105     uint256 value
106   );
107 
108   /**
109   * @dev Total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256) {
121     return balances[_owner];
122   }
123 
124   /**
125    * @dev Function to check the amount of tokens that an owner allowed to a spender.
126    * @param _owner address The address which owns the funds.
127    * @param _spender address The address which will spend the funds.
128    * @return A uint256 specifying the amount of tokens still available for the spender.
129    */
130   function allowance(
131     address _owner,
132     address _spender
133    )
134     public
135     view
136     returns (uint256)
137   {
138     return allowed[_owner][_spender];
139   }
140 
141   /**
142   * @dev Transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_value <= balances[msg.sender]);
148     require(_to != address(0));
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     emit Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(
178     address _from,
179     address _to,
180     uint256 _value
181   )
182     public
183     returns (bool)
184   {
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187     require(_to != address(0));
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     emit Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Increase the amount of tokens that an owner allowed to a spender.
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(
206     address _spender,
207     uint256 _addedValue
208   )
209     public
210     returns (bool)
211   {
212     allowed[msg.sender][_spender] = (
213       allowed[msg.sender][_spender].add(_addedValue));
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _subtractedValue The amount of tokens to decrease the allowance by.
226    */
227   function decreaseApproval(
228     address _spender,
229     uint256 _subtractedValue
230   )
231     public
232     returns (bool)
233   {
234     uint256 oldValue = allowed[msg.sender][_spender];
235     if (_subtractedValue >= oldValue) {
236       allowed[msg.sender][_spender] = 0;
237     } else {
238       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239     }
240     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244 }
245 
246 contract MintableToken is StandardToken, Ownable {
247     event Mint(address indexed to, uint256 amount);
248     event MintFinished();
249 
250     bool public mintingFinished = false;
251 
252 
253     modifier canMint() {
254         require(!mintingFinished);
255         _;
256     }
257 
258     modifier hasMintPermission() {
259         require(msg.sender == owner);
260         _;
261     }
262 
263     /**
264     * @dev Function to mint tokens
265     * @param _to The address that will receive the minted tokens.
266     * @param _amount The amount of tokens to mint.
267     * @return A boolean that indicates if the operation was successful.
268     */
269     function mint(
270         address _to,
271         uint256 _amount
272       )
273       public
274       hasMintPermission
275       canMint
276       returns (bool)
277     {
278         totalSupply_ = totalSupply_.add(_amount);
279         balances[_to] = balances[_to].add(_amount);
280         emit Mint(_to, _amount);
281         emit Transfer(address(0), _to, _amount);
282         return true;
283     }
284 
285     /**
286     * @dev Function to stop minting new tokens.
287     * @return True if the operation was successful.
288     */
289     function finishMinting() public onlyOwner canMint returns (bool) {
290         mintingFinished = true;
291         emit MintFinished();
292         return true;
293     }
294 }
295 
296 contract MobiusBlueToken is MintableToken {
297 
298     using SafeMath for uint;
299     address creator = msg.sender;
300     uint8 public decimals = 18;
301     string public name = "Möbius BLUE";
302     string public symbol = "BLU";
303 
304     uint public totalDividends;
305     uint public lastRevenueBnum;
306 
307     uint public unclaimedDividends;
308 
309     struct DividendAccount {
310         uint balance;
311         uint lastCumulativeDividends;
312         uint lastWithdrawnBnum;
313     }
314 
315     mapping (address => DividendAccount) public dividendAccounts;
316 
317     modifier onlyTokenHolders{
318         require(balances[msg.sender] > 0, "Not a token owner!");
319         _;
320     }
321     
322     modifier updateAccount(address _of) {
323         _updateDividends(_of);
324         _;
325     }
326 
327     event DividendsWithdrawn(address indexed from, uint value);
328     event DividendsTransferred(address indexed from, address indexed to, uint value);
329     event DividendsDisbursed(uint value);
330         
331     function mint(address _to, uint256 _amount) public 
332     returns (bool)
333     {   
334         // devs get 33.3% of all tokens. Much of this will be used for bounties and community incentives
335         super.mint(creator, _amount/2);
336         // When an investor gets 2 tokens, devs get 1
337         return super.mint(_to, _amount);
338     }
339 
340     function transfer(address _to, uint _value) public returns (bool success) {
341         
342         _transferDividends(msg.sender, _to, _value);
343         require(super.transfer(_to, _value), "Failed to transfer tokens!");
344         return true;
345     }
346     
347     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
348         
349         _transferDividends(_from, _to, _value);
350         require(super.transferFrom(_from, _to, _value), "Failed to transfer tokens!");
351         return true;
352     }
353 
354     // Devs can move tokens without dividends during the ICO for bounty purposes
355     function donate(address _to, uint _value) public returns (bool success) {
356         require(msg.sender == creator, "You can't do that!");
357         require(!mintingFinished, "ICO Period is over - use a normal transfer.");
358         return super.transfer(_to, _value);
359     }
360 
361     function withdrawDividends() public onlyTokenHolders {
362         uint amount = _getDividendsBalance(msg.sender);
363         require(amount > 0, "Nothing to withdraw!");
364         unclaimedDividends = unclaimedDividends.sub(amount);
365         dividendAccounts[msg.sender].balance = 0;
366         dividendAccounts[msg.sender].lastWithdrawnBnum = block.number;
367         msg.sender.transfer(amount);
368         emit DividendsWithdrawn(msg.sender, amount);
369     }
370 
371     function dividendsAvailable(address _for) public view returns(bool) {
372         return lastRevenueBnum >= dividendAccounts[_for].lastWithdrawnBnum;
373     }
374 
375     function getDividendsBalance(address _of) external view returns(uint) {
376         uint outstanding = _dividendsOutstanding(_of);
377         if (outstanding > 0) {
378             return dividendAccounts[_of].balance.add(outstanding);
379         }
380         return dividendAccounts[_of].balance;
381     }
382 
383     function disburseDividends() public payable {
384         if(msg.value == 0) {
385             return;
386         }
387         totalDividends = totalDividends.add(msg.value);
388         unclaimedDividends = unclaimedDividends.add(msg.value);
389         lastRevenueBnum = block.number;
390         emit DividendsDisbursed(msg.value);
391     }
392 
393     function () public payable {
394         disburseDividends();
395     }
396 
397     function _transferDividends(address _from, address _to, uint _tokensValue) internal 
398     updateAccount(_from)
399     updateAccount(_to) 
400     {
401         uint amount = dividendAccounts[_from].balance.mul(_tokensValue).div(balances[_from]);
402         if(amount > 0) {
403             dividendAccounts[_from].balance = dividendAccounts[_from].balance.sub(amount);
404             dividendAccounts[_to].balance = dividendAccounts[_to].balance.add(amount); 
405             dividendAccounts[_to].lastWithdrawnBnum = dividendAccounts[_from].lastWithdrawnBnum;
406             emit DividendsTransferred(_from, _to, amount);
407         }
408     }
409     
410     function _getDividendsBalance(address _holder) internal
411     updateAccount(_holder)
412     returns(uint) 
413     {
414         return dividendAccounts[_holder].balance;
415     }    
416 
417     function _updateDividends(address _holder) internal {
418         require(mintingFinished, "Can't calculate balances if still minting tokens!");
419         uint outstanding = _dividendsOutstanding(_holder);
420         if (outstanding > 0) {
421             dividendAccounts[_holder].balance = dividendAccounts[_holder].balance.add(outstanding);
422         }
423         dividendAccounts[_holder].lastCumulativeDividends = totalDividends;
424     }
425 
426     function _dividendsOutstanding(address _holder) internal view returns(uint) {
427         uint newDividends = totalDividends.sub(dividendAccounts[_holder].lastCumulativeDividends);
428         
429         if(newDividends == 0) {
430             return 0;
431         } else {
432             return newDividends.mul(balances[_holder]).div(totalSupply_);
433         }
434     }   
435 }
436 
437 library SafeMath {
438 
439   /**
440   * @dev Multiplies two numbers, reverts on overflow.
441   */
442   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
443     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
444     // benefit is lost if 'b' is also tested.
445     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
446     if (_a == 0) {
447       return 0;
448     }
449 
450     uint256 c = _a * _b;
451     require(c / _a == _b);
452 
453     return c;
454   }
455 
456   /**
457   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
458   */
459   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
460     require(_b > 0); // Solidity only automatically asserts when dividing by 0
461     uint256 c = _a / _b;
462     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
463 
464     return c;
465   }
466 
467   /**
468   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
469   */
470   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
471     require(_b <= _a);
472     uint256 c = _a - _b;
473 
474     return c;
475   }
476 
477   /**
478   * @dev Adds two numbers, reverts on overflow.
479   */
480   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
481     uint256 c = _a + _b;
482     require(c >= _a);
483 
484     return c;
485   }
486 
487   /**
488   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
489   * reverts when dividing by zero.
490   */
491   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
492     require(b != 0);
493     return a % b;
494   }
495 }