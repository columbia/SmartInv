1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 contract ERC223ReceiverMixin {
251   function tokenFallback(address _from, uint256 _value, bytes memory _data) public;
252 }
253 
254 /// @title Custom implementation of ERC223 
255 /// @author Mai Abha <maiabha82@gmail.com>
256 contract ERC223Mixin is StandardToken {
257   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
258 
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   ) public returns (bool) 
264   {
265     bytes memory empty;
266     return transferFrom(
267       _from, 
268       _to,
269       _value,
270       empty);
271   }
272 
273   function transferFrom(
274     address _from,
275     address _to,
276     uint256 _value,
277     bytes memory _data
278   ) public returns (bool)
279   {
280     require(_value <= allowed[_from][msg.sender], "Reached allowed value");
281     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282     if (isContract(_to)) {
283       return transferToContract(
284         _from, 
285         _to, 
286         _value, 
287         _data);
288     } else {
289       return transferToAddress(
290         _from, 
291         _to, 
292         _value, 
293         _data); 
294     }
295   }
296 
297   function transfer(address _to, uint256 _value, bytes memory _data) public returns (bool success) {
298     if (isContract(_to)) {
299       return transferToContract(
300         msg.sender,
301         _to,
302         _value,
303         _data); 
304     } else {
305       return transferToAddress(
306         msg.sender,
307         _to,
308         _value,
309         _data);
310     }
311   }
312 
313   function transfer(address _to, uint256 _value) public returns (bool success) {
314     bytes memory empty;
315     return transfer(_to, _value, empty);
316   }
317 
318   function isContract(address _addr) internal view returns (bool) {
319     uint256 length;
320     // solium-disable-next-line security/no-inline-assembly
321     assembly {
322       //retrieve the size of the code on target address, this needs assembly
323       length := extcodesize(_addr)
324     }  
325     return (length>0);
326   }
327 
328   function moveTokens(address _from, address _to, uint256 _value) internal returns (bool success) {
329     if (balanceOf(_from) < _value) {
330       revert();
331     }
332     balances[_from] = balanceOf(_from).sub(_value);
333     balances[_to] = balanceOf(_to).add(_value);
334 
335     return true;
336   }
337 
338   function transferToAddress(
339     address _from,
340     address _to,
341     uint256 _value,
342     bytes memory _data
343   ) internal returns (bool success) 
344   {
345     require(moveTokens(_from, _to, _value), "Move is not successful");
346     emit Transfer(_from, _to, _value);
347     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
348     return true;
349   }
350   
351   //function that is called when transaction target is a contract
352   function transferToContract(
353     address _from,
354     address _to,
355     uint256 _value,
356     bytes memory _data
357   ) internal returns (bool success) 
358   {
359     require(moveTokens(_from, _to, _value), "Move is not successful");
360     ERC223ReceiverMixin(_to).tokenFallback(_from, _value, _data);
361     emit Transfer(_from, _to, _value);
362     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
363     return true;
364   }
365 }
366 
367 /// @title Role based access control mixin for Vinci Platform
368 /// @author Mai Abha <maiabha82@gmail.com>
369 /// @dev Ignore DRY approach to achieve readability
370 contract RBACMixin {
371   /// @notice Constant string message to throw on lack of access
372   string constant FORBIDDEN = "Doesn't have enough rights";
373   string constant DUPLICATE = "Requirement already satisfied";
374 
375   /// @notice Public owner
376   address public owner;
377 
378   /// @notice Public map of minters
379   mapping (address => bool) public minters;
380 
381   /// @notice The event indicates a set of a new owner
382   /// @param who is address of added owner
383   event SetOwner(address indexed who);
384 
385   /// @notice The event indicates the addition of a new minter
386   /// @param who is address of added minter
387   event AddMinter(address indexed who);
388   /// @notice The event indicates the deletion of a minter
389   /// @param who is address of deleted minter
390   event DeleteMinter(address indexed who);
391 
392   constructor () public {
393     _setOwner(msg.sender);
394   }
395 
396   /// @notice The functional modifier rejects the interaction of sender who is not an owner
397   modifier onlyOwner() {
398     require(isOwner(msg.sender), FORBIDDEN);
399     _;
400   }
401 
402   /// @notice Functional modifier for rejecting the interaction of senders that are not minters
403   modifier onlyMinter() {
404     require(isMinter(msg.sender), FORBIDDEN);
405     _;
406   }
407 
408   /// @notice Look up for the owner role on providen address
409   /// @param _who is address to look up
410   /// @return A boolean of owner role
411   function isOwner(address _who) public view returns (bool) {
412     return owner == _who;
413   }
414 
415   /// @notice Look up for the minter role on providen address
416   /// @param _who is address to look up
417   /// @return A boolean of minter role
418   function isMinter(address _who) public view returns (bool) {
419     return minters[_who];
420   }
421 
422   /// @notice Adds the owner role to provided address
423   /// @dev Requires owner role to interact
424   /// @param _who is address to add role
425   /// @return A boolean that indicates if the operation was successful.
426   function setOwner(address _who) public onlyOwner returns (bool) {
427     require(_who != address(0));
428     _setOwner(_who);
429   }
430 
431   /// @notice Adds the minter role to provided address
432   /// @dev Requires owner role to interact
433   /// @param _who is address to add role
434   /// @return A boolean that indicates if the operation was successful.
435   function addMinter(address _who) public onlyOwner returns (bool) {
436     _setMinter(_who, true);
437   }
438 
439   /// @notice Deletes the minter role to provided address
440   /// @dev Requires owner role to interact
441   /// @param _who is address to delete role
442   /// @return A boolean that indicates if the operation was successful.
443   function deleteMinter(address _who) public onlyOwner returns (bool) {
444     _setMinter(_who, false);
445   }
446 
447   /// @notice Changes the owner role to provided address
448   /// @param _who is address to change role
449   /// @param _flag is next role status after success
450   /// @return A boolean that indicates if the operation was successful.
451   function _setOwner(address _who) private returns (bool) {
452     require(owner != _who, DUPLICATE);
453     owner = _who;
454     emit SetOwner(_who);
455     return true;
456   }
457 
458   /// @notice Changes the minter role to provided address
459   /// @param _who is address to change role
460   /// @param _flag is next role status after success
461   /// @return A boolean that indicates if the operation was successful.
462   function _setMinter(address _who, bool _flag) private returns (bool) {
463     require(minters[_who] != _flag, DUPLICATE);
464     minters[_who] = _flag;
465     if (_flag) {
466       emit AddMinter(_who);
467     } else {
468       emit DeleteMinter(_who);
469     }
470     return true;
471   }
472 }
473 
474 contract RBACMintableTokenMixin is StandardToken, RBACMixin {
475   /// @notice Total issued tokens
476   uint256 totalIssued_;
477 
478   event Mint(address indexed to, uint256 amount);
479   event MintFinished();
480 
481   bool public mintingFinished = false;
482 
483   modifier canMint() {
484     require(!mintingFinished, "Minting is finished");
485     _;
486   }
487 
488   /**
489    * @dev Function to mint tokens
490    * @param _to The address that will receive the minted tokens.
491    * @param _amount The amount of tokens to mint.
492    * @return A boolean that indicates if the operation was successful.
493    */
494   function mint(
495     address _to,
496     uint256 _amount
497   )
498     onlyMinter
499     canMint
500     public
501     returns (bool)
502   {
503     totalIssued_ = totalIssued_.add(_amount);
504     totalSupply_ = totalSupply_.add(_amount);
505     balances[_to] = balances[_to].add(_amount);
506     emit Mint(_to, _amount);
507     emit Transfer(address(0), _to, _amount);
508     return true;
509   }
510 
511   /**
512    * @dev Function to stop minting new tokens.
513    * @return True if the operation was successful.
514    */
515   function finishMinting() onlyOwner canMint public returns (bool) {
516     mintingFinished = true;
517     emit MintFinished();
518     return true;
519   }
520 }
521 
522 /**
523  * @title Burnable Token
524  * @dev Token that can be irreversibly burned (destroyed).
525  */
526 contract BurnableToken is BasicToken {
527 
528   event Burn(address indexed burner, uint256 value);
529 
530   /**
531    * @dev Burns a specific amount of tokens.
532    * @param _value The amount of token to be burned.
533    */
534   function burn(uint256 _value) public {
535     _burn(msg.sender, _value);
536   }
537 
538   function _burn(address _who, uint256 _value) internal {
539     require(_value <= balances[_who]);
540     // no need to require value <= totalSupply, since that would imply the
541     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
542 
543     balances[_who] = balances[_who].sub(_value);
544     totalSupply_ = totalSupply_.sub(_value);
545     emit Burn(_who, _value);
546     emit Transfer(_who, address(0), _value);
547   }
548 }
549 
550 /**
551  * @title Standard Burnable Token
552  * @dev Adds burnFrom method to ERC20 implementations
553  */
554 contract StandardBurnableToken is BurnableToken, StandardToken {
555 
556   /**
557    * @dev Burns a specific amount of tokens from the target address and decrements allowance
558    * @param _from address The address which you want to send tokens from
559    * @param _value uint256 The amount of token to be burned
560    */
561   function burnFrom(address _from, uint256 _value) public {
562     require(_value <= allowed[_from][msg.sender]);
563     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
564     // this function needs to emit an event with the updated approval.
565     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
566     _burn(_from, _value);
567   }
568 }
569 
570 /// @title Vinci token implementation
571 /// @author Mai Abha <maiabha82@gmail.com>
572 /// @dev Implements ERC20, ERC223 and MintableToken interfaces
573 contract VinciToken is StandardBurnableToken, RBACMintableTokenMixin, ERC223Mixin {
574   /// @notice Constant field with token full name
575   // solium-disable-next-line uppercase
576   string constant public name = "Vinci"; 
577   /// @notice Constant field with token symbol
578   string constant public symbol = "VINCI"; // solium-disable-line uppercase
579   /// @notice Constant field with token precision depth
580   uint256 constant public decimals = 18; // solium-disable-line uppercase
581   /// @notice Constant field with token cap (total supply limit)
582   uint256 constant public cap = 1500 * (10 ** 6) * (10 ** decimals); // solium-disable-line uppercase
583 
584   /// @notice Overrides original mint function from MintableToken to limit minting over cap
585   /// @param _to The address that will receive the minted tokens.
586   /// @param _amount The amount of tokens to mint.
587   /// @return A boolean that indicates if the operation was successful.
588   function mint(
589     address _to,
590     uint256 _amount
591   )
592     public
593     returns (bool) 
594   {
595     require(totalIssued_.add(_amount) <= cap, "Cap is reached");
596     return super.mint(_to, _amount);
597   }
598 }