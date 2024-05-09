1 pragma solidity^0.4.24;
2 
3 /**
4 * 
5 *   //////// https://mobius.red/ \\\\\\\
6 *  //////// Holders receive divs  \\\\\\\
7 * //////// on any game we develop! \\\\\\\
8 * 
9 */
10 
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 contract StandardToken  {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   mapping (address => mapping (address => uint256)) internal allowed;
74 
75   uint256 totalSupply_;
76 
77   event Transfer(
78     address indexed from,
79     address indexed to,
80     uint256 value
81   );
82 
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 
89   /**
90   * @dev Total number of tokens in existence
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105   /**
106    * @dev Function to check the amount of tokens that an owner allowed to a spender.
107    * @param _owner address The address which owns the funds.
108    * @param _spender address The address which will spend the funds.
109    * @return A uint256 specifying the amount of tokens still available for the spender.
110    */
111   function allowance(
112     address _owner,
113     address _spender
114    )
115     public
116     view
117     returns (uint256)
118   {
119     return allowed[_owner][_spender];
120   }
121 
122   /**
123   * @dev Transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_value <= balances[msg.sender]);
129     require(_to != address(0));
130 
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     emit Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     emit Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(
159     address _from,
160     address _to,
161     uint256 _value
162   )
163     public
164     returns (bool)
165   {
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168     require(_to != address(0));
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     emit Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(
187     address _spender,
188     uint256 _addedValue
189   )
190     public
191     returns (bool)
192   {
193     allowed[msg.sender][_spender] = (
194       allowed[msg.sender][_spender].add(_addedValue));
195     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(
209     address _spender,
210     uint256 _subtractedValue
211   )
212     public
213     returns (bool)
214   {
215     uint256 oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue >= oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 contract MintableToken is StandardToken, Ownable {
228     event Mint(address indexed to, uint256 amount);
229     event MintFinished();
230 
231     bool public mintingFinished = false;
232 
233 
234     modifier canMint() {
235         require(!mintingFinished);
236         _;
237     }
238 
239     modifier hasMintPermission() {
240         require(msg.sender == owner);
241         _;
242     }
243 
244     /**
245     * @dev Function to mint tokens
246     * @param _to The address that will receive the minted tokens.
247     * @param _amount The amount of tokens to mint.
248     * @return A boolean that indicates if the operation was successful.
249     */
250     function mint(
251         address _to,
252         uint256 _amount
253       )
254       public
255       hasMintPermission
256       canMint
257       returns (bool)
258     {
259         totalSupply_ = totalSupply_.add(_amount);
260         balances[_to] = balances[_to].add(_amount);
261         emit Mint(_to, _amount);
262         emit Transfer(address(0), _to, _amount);
263         return true;
264     }
265 
266     /**
267     * @dev Function to stop minting new tokens.
268     * @return True if the operation was successful.
269     */
270     function finishMinting() public onlyOwner canMint returns (bool) {
271         mintingFinished = true;
272         emit MintFinished();
273         return true;
274     }
275 }
276 
277 contract MobiusRedToken is MintableToken {
278 
279     using SafeMath for uint;
280     address creator = msg.sender;
281     uint8 public decimals = 18;
282     string public name = "Möbius RED";
283     string public symbol = "MRD";
284 
285     uint public totalDividends;
286     uint public lastRevenueBnum;
287 
288     uint public unclaimedDividends;
289 
290     struct DividendAccount {
291         uint balance;
292         uint lastCumulativeDividends;
293         uint lastWithdrawnBnum;
294     }
295 
296     mapping (address => DividendAccount) public dividendAccounts;
297 
298     modifier onlyTokenHolders{
299         require(balances[msg.sender] > 0, "Not a token owner!");
300         _;
301     }
302     
303     modifier updateAccount(address _of) {
304         _updateDividends(_of);
305         _;
306     }
307 
308     event DividendsWithdrawn(address indexed from, uint value);
309     event DividendsTransferred(address indexed from, address indexed to, uint value);
310     event DividendsDisbursed(uint value);
311         
312     function mint(address _to, uint256 _amount) public 
313     returns (bool)
314     {   
315         // devs get 33.3% of all tokens. Much of this will be used for bounties and community incentives
316         super.mint(creator, _amount/2);
317         // When an investor gets 2 tokens, devs get 1
318         return super.mint(_to, _amount);
319     }
320 
321     function transfer(address _to, uint _value) public returns (bool success) {
322         
323         _transferDividends(msg.sender, _to, _value);
324         require(super.transfer(_to, _value), "Failed to transfer tokens!");
325         return true;
326     }
327     
328     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
329         
330         _transferDividends(_from, _to, _value);
331         require(super.transferFrom(_from, _to, _value), "Failed to transfer tokens!");
332         return true;
333     }
334 
335     // Devs can move tokens without dividends during the ICO for bounty purposes
336     function donate(address _to, uint _value) public returns (bool success) {
337         require(msg.sender == creator, "You can't do that!");
338         require(!mintingFinished, "ICO Period is over - use a normal transfer.");
339         return super.transfer(_to, _value);
340     }
341 
342     function withdrawDividends() public onlyTokenHolders {
343         uint amount = _getDividendsBalance(msg.sender);
344         require(amount > 0, "Nothing to withdraw!");
345         unclaimedDividends = unclaimedDividends.sub(amount);
346         dividendAccounts[msg.sender].balance = 0;
347         dividendAccounts[msg.sender].lastWithdrawnBnum = block.number;
348         msg.sender.transfer(amount);
349         emit DividendsWithdrawn(msg.sender, amount);
350     }
351 
352     function dividendsAvailable(address _for) public view returns(bool) {
353         return lastRevenueBnum >= dividendAccounts[_for].lastWithdrawnBnum;
354     }
355 
356     function getDividendsBalance(address _of) external view returns(uint) {
357         uint outstanding = _dividendsOutstanding(_of);
358         if (outstanding > 0) {
359             return dividendAccounts[_of].balance.add(outstanding);
360         }
361         return dividendAccounts[_of].balance;
362     }
363 
364     function disburseDividends() public payable {
365         if(msg.value == 0) {
366             return;
367         }
368         totalDividends = totalDividends.add(msg.value);
369         unclaimedDividends = unclaimedDividends.add(msg.value);
370         lastRevenueBnum = block.number;
371         emit DividendsDisbursed(msg.value);
372     }
373 
374     function () public payable {
375         disburseDividends();
376     }
377 
378     function _transferDividends(address _from, address _to, uint _tokensValue) internal 
379     updateAccount(_from)
380     updateAccount(_to) 
381     {
382         uint amount = dividendAccounts[_from].balance.mul(_tokensValue).div(balances[_from]);
383         if(amount > 0) {
384             dividendAccounts[_from].balance = dividendAccounts[_from].balance.sub(amount);
385             dividendAccounts[_to].balance = dividendAccounts[_to].balance.add(amount); 
386             dividendAccounts[_to].lastWithdrawnBnum = dividendAccounts[_from].lastWithdrawnBnum;
387             emit DividendsTransferred(_from, _to, amount);
388         }
389     }
390     
391     function _getDividendsBalance(address _holder) internal
392     updateAccount(_holder)
393     returns(uint) 
394     {
395         return dividendAccounts[_holder].balance;
396     }    
397 
398     function _updateDividends(address _holder) internal {
399         require(mintingFinished, "Can't calculate balances if still minting tokens!");
400         uint outstanding = _dividendsOutstanding(_holder);
401         if (outstanding > 0) {
402             dividendAccounts[_holder].balance = dividendAccounts[_holder].balance.add(outstanding);
403         }
404         dividendAccounts[_holder].lastCumulativeDividends = totalDividends;
405     }
406 
407     function _dividendsOutstanding(address _holder) internal view returns(uint) {
408         uint newDividends = totalDividends.sub(dividendAccounts[_holder].lastCumulativeDividends);
409         
410         if(newDividends == 0) {
411             return 0;
412         } else {
413             return newDividends.mul(balances[_holder]).div(totalSupply_);
414         }
415     }   
416 }
417 
418 library SafeMath {
419 
420   /**
421   * @dev Multiplies two numbers, reverts on overflow.
422   */
423   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
424     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
425     // benefit is lost if 'b' is also tested.
426     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
427     if (_a == 0) {
428       return 0;
429     }
430 
431     uint256 c = _a * _b;
432     require(c / _a == _b);
433 
434     return c;
435   }
436 
437   /**
438   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
439   */
440   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
441     require(_b > 0); // Solidity only automatically asserts when dividing by 0
442     uint256 c = _a / _b;
443     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
444 
445     return c;
446   }
447 
448   /**
449   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
450   */
451   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
452     require(_b <= _a);
453     uint256 c = _a - _b;
454 
455     return c;
456   }
457 
458   /**
459   * @dev Adds two numbers, reverts on overflow.
460   */
461   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
462     uint256 c = _a + _b;
463     require(c >= _a);
464 
465     return c;
466   }
467 
468   /**
469   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
470   * reverts when dividing by zero.
471   */
472   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
473     require(b != 0);
474     return a % b;
475   }
476 }