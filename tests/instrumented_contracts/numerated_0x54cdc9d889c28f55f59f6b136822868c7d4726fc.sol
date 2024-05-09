1 pragma solidity^0.4.24;
2  //////// https://M2D.win \\\\\\\
3 ////////   Laughing Man   \\\\\\\
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    * @notice Renouncing to ownership will leave the contract without an owner.
35    * It will not be possible to call the functions with the `onlyOwner`
36    * modifier anymore.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract StandardToken  {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   mapping (address => mapping (address => uint256)) internal allowed;
68 
69   uint256 totalSupply_;
70 
71   event Transfer(
72     address indexed from,
73     address indexed to,
74     uint256 value
75   );
76 
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 
83   /**
84   * @dev Total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256) {
96     return balances[_owner];
97   }
98 
99   /**
100    * @dev Function to check the amount of tokens that an owner allowed to a spender.
101    * @param _owner address The address which owns the funds.
102    * @param _spender address The address which will spend the funds.
103    * @return A uint256 specifying the amount of tokens still available for the spender.
104    */
105   function allowance(
106     address _owner,
107     address _spender
108    )
109     public
110     view
111     returns (uint256)
112   {
113     return allowed[_owner][_spender];
114   }
115 
116   /**
117   * @dev Transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121   function transfer(address _to, uint256 _value) public returns (bool) {
122     require(_value <= balances[msg.sender]);
123     require(_to != address(0));
124 
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     emit Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     emit Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(
153     address _from,
154     address _to,
155     uint256 _value
156   )
157     public
158     returns (bool)
159   {
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162     require(_to != address(0));
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     emit Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Increase the amount of tokens that an owner allowed to a spender.
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(
181     address _spender,
182     uint256 _addedValue
183   )
184     public
185     returns (bool)
186   {
187     allowed[msg.sender][_spender] = (
188       allowed[msg.sender][_spender].add(_addedValue));
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _subtractedValue The amount of tokens to decrease the allowance by.
201    */
202   function decreaseApproval(
203     address _spender,
204     uint256 _subtractedValue
205   )
206     public
207     returns (bool)
208   {
209     uint256 oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue >= oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 contract MintableToken is StandardToken, Ownable {
222     event Mint(address indexed to, uint256 amount);
223     event MintFinished();
224 
225     bool public mintingFinished = false;
226 
227 
228     modifier canMint() {
229         require(!mintingFinished);
230         _;
231     }
232 
233     modifier hasMintPermission() {
234         require(msg.sender == owner);
235         _;
236     }
237 
238     /**
239     * @dev Function to mint tokens
240     * @param _to The address that will receive the minted tokens.
241     * @param _amount The amount of tokens to mint.
242     * @return A boolean that indicates if the operation was successful.
243     */
244     function mint(
245         address _to,
246         uint256 _amount
247       )
248       public
249       hasMintPermission
250       canMint
251       returns (bool)
252     {
253         totalSupply_ = totalSupply_.add(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         emit Mint(_to, _amount);
256         emit Transfer(address(0), _to, _amount);
257         return true;
258     }
259 
260     /**
261     * @dev Function to stop minting new tokens.
262     * @return True if the operation was successful.
263     */
264     function finishMinting() public onlyOwner canMint returns (bool) {
265         mintingFinished = true;
266         emit MintFinished();
267         return true;
268     }
269 }
270 
271 contract MobiusToken is MintableToken {
272 
273     using SafeMath for uint;
274     address creator = msg.sender;
275     uint8 public decimals = 18;
276     string public name = "Möbius 2D";
277     string public symbol = "M2D";
278 
279     uint public totalDividends;
280     uint public lastRevenueBnum;
281 
282     uint public unclaimedDividends;
283 
284     struct DividendAccount {
285         uint balance;
286         uint lastCumulativeDividends;
287         uint lastWithdrawnBnum;
288     }
289 
290     mapping (address => DividendAccount) public dividendAccounts;
291 
292     modifier onlyTokenHolders{
293         require(balances[msg.sender] > 0, "Not a token owner!");
294         _;
295     }
296     
297     modifier updateAccount(address _of) {
298         _updateDividends(_of);
299         _;
300     }
301 
302     event DividendsWithdrawn(address indexed from, uint value);
303     event DividendsTransferred(address indexed from, address indexed to, uint value);
304     event DividendsDisbursed(uint value);
305         
306     function mint(address _to, uint256 _amount) public 
307     returns (bool)
308     {   
309         // devs get 33.3% of all tokens. Much of this will be used for bounties and community incentives
310         super.mint(creator, _amount/2);
311         // When an investor gets 2 tokens, devs get 1
312         return super.mint(_to, _amount);
313     }
314 
315     function transfer(address _to, uint _value) public returns (bool success) {
316         
317         _transferDividends(msg.sender, _to, _value);
318         require(super.transfer(_to, _value), "Failed to transfer tokens!");
319         return true;
320     }
321     
322     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
323         
324         _transferDividends(_from, _to, _value);
325         require(super.transferFrom(_from, _to, _value), "Failed to transfer tokens!");
326         return true;
327     }
328 
329     // Devs can move tokens without dividends during the ICO for bounty purposes
330     function donate(address _to, uint _value) public returns (bool success) {
331         require(msg.sender == creator, "You can't do that!");
332         require(!mintingFinished, "ICO Period is over - use a normal transfer.");
333         return super.transfer(_to, _value);
334     }
335 
336     function withdrawDividends() public onlyTokenHolders {
337         uint amount = _getDividendsBalance(msg.sender);
338         require(amount > 0, "Nothing to withdraw!");
339         unclaimedDividends = unclaimedDividends.sub(amount);
340         dividendAccounts[msg.sender].balance = 0;
341         dividendAccounts[msg.sender].lastWithdrawnBnum = block.number;
342         msg.sender.transfer(amount);
343         emit DividendsWithdrawn(msg.sender, amount);
344     }
345 
346     function dividendsAvailable(address _for) public view returns(bool) {
347         return lastRevenueBnum >= dividendAccounts[_for].lastWithdrawnBnum;
348     }
349 
350     function getDividendsBalance(address _of) external view returns(uint) {
351         uint outstanding = _dividendsOutstanding(_of);
352         if (outstanding > 0) {
353             return dividendAccounts[_of].balance.add(outstanding);
354         }
355         return dividendAccounts[_of].balance;
356     }
357 
358     function disburseDividends() public payable {
359         if(msg.value == 0) {
360             return;
361         }
362         totalDividends = totalDividends.add(msg.value);
363         unclaimedDividends = unclaimedDividends.add(msg.value);
364         lastRevenueBnum = block.number;
365         emit DividendsDisbursed(msg.value);
366     }
367 
368     function () public payable {
369         disburseDividends();
370     }
371 
372     function _transferDividends(address _from, address _to, uint _tokensValue) internal 
373     updateAccount(_from)
374     updateAccount(_to) 
375     {
376         uint amount = dividendAccounts[_from].balance.mul(_tokensValue).div(balances[_from]);
377         if(amount > 0) {
378             dividendAccounts[_from].balance = dividendAccounts[_from].balance.sub(amount);
379             dividendAccounts[_to].balance = dividendAccounts[_to].balance.add(amount); 
380             dividendAccounts[_to].lastWithdrawnBnum = dividendAccounts[_from].lastWithdrawnBnum;
381             emit DividendsTransferred(_from, _to, amount);
382         }
383     }
384     
385     function _getDividendsBalance(address _holder) internal
386     updateAccount(_holder)
387     returns(uint) 
388     {
389         return dividendAccounts[_holder].balance;
390     }    
391 
392     function _updateDividends(address _holder) internal {
393         require(mintingFinished, "Can't calculate balances if still minting tokens!");
394         uint outstanding = _dividendsOutstanding(_holder);
395         if (outstanding > 0) {
396             dividendAccounts[_holder].balance = dividendAccounts[_holder].balance.add(outstanding);
397         }
398         dividendAccounts[_holder].lastCumulativeDividends = totalDividends;
399     }
400 
401     function _dividendsOutstanding(address _holder) internal view returns(uint) {
402         uint newDividends = totalDividends.sub(dividendAccounts[_holder].lastCumulativeDividends);
403         
404         if(newDividends == 0) {
405             return 0;
406         } else {
407             return newDividends.mul(balances[_holder]).div(totalSupply_);
408         }
409     }   
410 }
411 
412 library SafeMath {
413 
414   /**
415   * @dev Multiplies two numbers, reverts on overflow.
416   */
417   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
418     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
419     // benefit is lost if 'b' is also tested.
420     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
421     if (_a == 0) {
422       return 0;
423     }
424 
425     uint256 c = _a * _b;
426     require(c / _a == _b);
427 
428     return c;
429   }
430 
431   /**
432   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
433   */
434   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
435     require(_b > 0); // Solidity only automatically asserts when dividing by 0
436     uint256 c = _a / _b;
437     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
438 
439     return c;
440   }
441 
442   /**
443   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
444   */
445   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
446     require(_b <= _a);
447     uint256 c = _a - _b;
448 
449     return c;
450   }
451 
452   /**
453   * @dev Adds two numbers, reverts on overflow.
454   */
455   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
456     uint256 c = _a + _b;
457     require(c >= _a);
458 
459     return c;
460   }
461 
462   /**
463   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
464   * reverts when dividing by zero.
465   */
466   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
467     require(b != 0);
468     return a % b;
469   }
470 }