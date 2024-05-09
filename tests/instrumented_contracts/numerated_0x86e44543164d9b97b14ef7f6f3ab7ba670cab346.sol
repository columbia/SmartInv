1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Pausable is Ownable {
107   event Pause();
108   event Unpause();
109 
110   bool public paused = false;
111 
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyOwner whenNotPaused {
133     paused = true;
134     emit Pause();
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyOwner whenPaused {
141     paused = false;
142     emit Unpause();
143   }
144 }
145 
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address _who) public view returns (uint256);
149   function transfer(address _to, uint256 _value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) internal balances;
157 
158   uint256 internal totalSupply_;
159 
160   /**
161   * @dev Total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev Transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_value <= balances[msg.sender]);
174     require(_to != address(0));
175 
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     emit Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 contract BurnableToken is BasicToken {
194 
195   event Burn(address indexed burner, uint256 value);
196 
197   /**
198    * @dev Burns a specific amount of tokens.
199    * @param _value The amount of token to be burned.
200    */
201   function burn(uint256 _value) public {
202     _burn(msg.sender, _value);
203   }
204 
205   function _burn(address _who, uint256 _value) internal {
206     require(_value <= balances[_who]);
207     // no need to require value <= totalSupply, since that would imply the
208     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
209 
210     balances[_who] = balances[_who].sub(_value);
211     totalSupply_ = totalSupply_.sub(_value);
212     emit Burn(_who, _value);
213     emit Transfer(_who, address(0), _value);
214   }
215 }
216 
217 contract ERC20 is ERC20Basic {
218   function allowance(address _owner, address _spender)
219     public view returns (uint256);
220 
221   function transferFrom(address _from, address _to, uint256 _value)
222     public returns (bool);
223 
224   function approve(address _spender, uint256 _value) public returns (bool);
225   event Approval(
226     address indexed owner,
227     address indexed spender,
228     uint256 value
229   );
230 }
231 
232 contract DetailedERC20 is ERC20 {
233   string public name;
234   string public symbol;
235   uint8 public decimals;
236 
237   constructor(string _name, string _symbol, uint8 _decimals) public {
238     name = _name;
239     symbol = _symbol;
240     decimals = _decimals;
241   }
242 }
243 
244 contract StandardToken is ERC20, BasicToken {
245 
246   mapping (address => mapping (address => uint256)) internal allowed;
247 
248 
249   /**
250    * @dev Transfer tokens from one address to another
251    * @param _from address The address which you want to send tokens from
252    * @param _to address The address which you want to transfer to
253    * @param _value uint256 the amount of tokens to be transferred
254    */
255   function transferFrom(
256     address _from,
257     address _to,
258     uint256 _value
259   )
260     public
261     returns (bool)
262   {
263     require(_value <= balances[_from]);
264     require(_value <= allowed[_from][msg.sender]);
265     require(_to != address(0));
266 
267     balances[_from] = balances[_from].sub(_value);
268     balances[_to] = balances[_to].add(_value);
269     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
270     emit Transfer(_from, _to, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
276    * Beware that changing an allowance with this method brings the risk that someone may use both the old
277    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280    * @param _spender The address which will spend the funds.
281    * @param _value The amount of tokens to be spent.
282    */
283   function approve(address _spender, uint256 _value) public returns (bool) {
284     allowed[msg.sender][_spender] = _value;
285     emit Approval(msg.sender, _spender, _value);
286     return true;
287   }
288 
289   /**
290    * @dev Function to check the amount of tokens that an owner allowed to a spender.
291    * @param _owner address The address which owns the funds.
292    * @param _spender address The address which will spend the funds.
293    * @return A uint256 specifying the amount of tokens still available for the spender.
294    */
295   function allowance(
296     address _owner,
297     address _spender
298    )
299     public
300     view
301     returns (uint256)
302   {
303     return allowed[_owner][_spender];
304   }
305 
306   /**
307    * @dev Increase the amount of tokens that an owner allowed to a spender.
308    * approve should be called when allowed[_spender] == 0. To increment
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _addedValue The amount of tokens to increase the allowance by.
314    */
315   function increaseApproval(
316     address _spender,
317     uint256 _addedValue
318   )
319     public
320     returns (bool)
321   {
322     allowed[msg.sender][_spender] = (
323       allowed[msg.sender][_spender].add(_addedValue));
324     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
325     return true;
326   }
327 
328   /**
329    * @dev Decrease the amount of tokens that an owner allowed to a spender.
330    * approve should be called when allowed[_spender] == 0. To decrement
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param _spender The address which will spend the funds.
335    * @param _subtractedValue The amount of tokens to decrease the allowance by.
336    */
337   function decreaseApproval(
338     address _spender,
339     uint256 _subtractedValue
340   )
341     public
342     returns (bool)
343   {
344     uint256 oldValue = allowed[msg.sender][_spender];
345     if (_subtractedValue >= oldValue) {
346       allowed[msg.sender][_spender] = 0;
347     } else {
348       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
349     }
350     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351     return true;
352   }
353 
354 }
355 
356 contract PausableToken is StandardToken, Pausable {
357 
358   function transfer(
359     address _to,
360     uint256 _value
361   )
362     public
363     whenNotPaused
364     returns (bool)
365   {
366     return super.transfer(_to, _value);
367   }
368 
369   function transferFrom(
370     address _from,
371     address _to,
372     uint256 _value
373   )
374     public
375     whenNotPaused
376     returns (bool)
377   {
378     return super.transferFrom(_from, _to, _value);
379   }
380 
381   function approve(
382     address _spender,
383     uint256 _value
384   )
385     public
386     whenNotPaused
387     returns (bool)
388   {
389     return super.approve(_spender, _value);
390   }
391 
392   function increaseApproval(
393     address _spender,
394     uint _addedValue
395   )
396     public
397     whenNotPaused
398     returns (bool success)
399   {
400     return super.increaseApproval(_spender, _addedValue);
401   }
402 
403   function decreaseApproval(
404     address _spender,
405     uint _subtractedValue
406   )
407     public
408     whenNotPaused
409     returns (bool success)
410   {
411     return super.decreaseApproval(_spender, _subtractedValue);
412   }
413 }
414 
415 contract StandardBurnableToken is BurnableToken, StandardToken {
416 
417   /**
418    * @dev Burns a specific amount of tokens from the target address and decrements allowance
419    * @param _from address The address which you want to send tokens from
420    * @param _value uint256 The amount of token to be burned
421    */
422   function burnFrom(address _from, uint256 _value) public {
423     require(_value <= allowed[_from][msg.sender]);
424     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
425     // this function needs to emit an event with the updated approval.
426     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
427     _burn(_from, _value);
428   }
429 }
430 
431 contract QuinadsToken is DetailedERC20, StandardToken, Ownable, PausableToken, StandardBurnableToken {
432     uint256 public marketplace   = 2000000000000000000000000000;
433     uint256 public devSupply     = 3000000000000000000000000000;
434     uint256 public advisorSupply = 1000000000000000000000000000;
435     uint256 public airdropSupply = 1280000000000000000000000000;
436     uint256 public icoSupply     = 12000000000000000000000000000;
437     uint256 public icoBonus      = 720000000000000000000000000;
438     uint256 public airdropDist;
439 
440     bool public icoClosed = false;
441     bool public airdropFinish = false;
442 
443     event tokenDelivered(address indexed receiver, uint256 amount);
444 
445     constructor(
446         string _name,
447         string _symbol,
448         uint8 _decimals,
449         uint256 _amount,
450         address _dev,
451         address _marketplace,
452         address _advisor
453     )
454     DetailedERC20(_name, _symbol, _decimals)
455     public {
456         require(_amount > 0, "amount has to be greater than 0");
457         totalSupply_ = _amount;
458         balances[msg.sender] = totalSupply_;
459         emit Transfer(address(0), msg.sender, totalSupply_);
460         // transfer to another account
461         transfer(_dev, devSupply);
462         transfer(_marketplace, marketplace);
463         transfer(_advisor, advisorSupply);
464     }
465 
466     modifier canDistrAirdrop() {
467         require(!airdropFinish);
468         _;
469     }
470 
471     modifier icoFinished() {
472         require(icoClosed);
473         _;
474     }
475 
476     function closeICO(bool status) public onlyOwner {
477         icoClosed = status;
478     }
479 
480     /** ICO has closed only */
481     function addAirdropSupply(uint256 _amount) public onlyOwner icoFinished {
482         _addAirdropSupply(_amount);
483     }
484     function _addAirdropSupply(uint256 _amount) internal {
485         airdropSupply = airdropSupply.add(_amount);
486     }
487 
488     function doAirdrop(address _beneficiary, uint256 _tokenAmount) internal {
489         require(_tokenAmount > 0);
490         require(airdropDist.add(_tokenAmount) <= airdropSupply);
491         airdropDist = airdropDist.add(_tokenAmount);
492         if (airdropDist >= airdropSupply) {
493             airdropFinish = true;
494         }
495         transfer(_beneficiary ,_tokenAmount);
496         emit tokenDelivered(_beneficiary, _tokenAmount);
497     }
498 
499     function adminClaimAirdrop(address _beneficiary, uint _amount) public onlyOwner icoFinished canDistrAirdrop {        
500         doAirdrop(_beneficiary, _amount);
501     }
502 
503     function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner icoFinished canDistrAirdrop {        
504         for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i], _amount);
505     }
506 }