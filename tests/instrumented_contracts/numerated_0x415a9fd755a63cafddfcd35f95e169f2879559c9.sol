1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 
93 
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100 
101   /**
102   * @dev Multiplies two numbers, throws on overflow.
103   */
104   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
106     // benefit is lost if 'b' is also tested.
107     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108     if (a == 0) {
109       return 0;
110     }
111 
112     c = a * b;
113     assert(c / a == b);
114     return c;
115   }
116 
117   /**
118   * @dev Integer division of two numbers, truncating the quotient.
119   */
120   function div(uint256 a, uint256 b) internal pure returns (uint256) {
121     // assert(b > 0); // Solidity automatically throws when dividing by 0
122     // uint256 c = a / b;
123     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124     return a / b;
125   }
126 
127   /**
128   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
129   */
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   /**
136   * @dev Adds two numbers, throws on overflow.
137   */
138   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
139     c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 }
144 
145 
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153 
154   mapping(address => uint256) balances;
155 
156   uint256 totalSupply_;
157 
158   /**
159   * @dev Total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   /**
166   * @dev Transfer token for a specified address
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[msg.sender]);
173 
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     emit Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public view returns (uint256) {
186     return balances[_owner];
187   }
188 
189 }
190 
191 
192 
193 
194 
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20 is ERC20Basic {
201   function allowance(address owner, address spender)
202     public view returns (uint256);
203 
204   function transferFrom(address from, address to, uint256 value)
205     public returns (bool);
206 
207   function approve(address spender, uint256 value) public returns (bool);
208   event Approval(
209     address indexed owner,
210     address indexed spender,
211     uint256 value
212   );
213 }
214 
215 
216 
217 /**
218  * @title Standard ERC20 token
219  *
220  * @dev Implementation of the basic standard token.
221  * @dev https://github.com/ethereum/EIPs/issues/20
222  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
223  */
224 contract StandardToken is ERC20, BasicToken {
225 
226   mapping (address => mapping (address => uint256)) internal allowed;
227 
228 
229   /**
230    * @dev Transfer tokens from one address to another
231    * @param _from address The address which you want to send tokens from
232    * @param _to address The address which you want to transfer to
233    * @param _value uint256 the amount of tokens to be transferred
234    */
235   function transferFrom(
236     address _from,
237     address _to,
238     uint256 _value
239   )
240     public
241     returns (bool)
242   {
243     require(_to != address(0));
244     require(_value <= balances[_from]);
245     require(_value <= allowed[_from][msg.sender]);
246 
247     balances[_from] = balances[_from].sub(_value);
248     balances[_to] = balances[_to].add(_value);
249     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250     emit Transfer(_from, _to, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
256    *
257    * Beware that changing an allowance with this method brings the risk that someone may use both the old
258    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261    * @param _spender The address which will spend the funds.
262    * @param _value The amount of tokens to be spent.
263    */
264   function approve(address _spender, uint256 _value) public returns (bool) {
265     allowed[msg.sender][_spender] = _value;
266     emit Approval(msg.sender, _spender, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Function to check the amount of tokens that an owner allowed to a spender.
272    * @param _owner address The address which owns the funds.
273    * @param _spender address The address which will spend the funds.
274    * @return A uint256 specifying the amount of tokens still available for the spender.
275    */
276   function allowance(
277     address _owner,
278     address _spender
279    )
280     public
281     view
282     returns (uint256)
283   {
284     return allowed[_owner][_spender];
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To increment
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _addedValue The amount of tokens to increase the allowance by.
296    */
297   function increaseApproval(
298     address _spender,
299     uint256 _addedValue
300   )
301     public
302     returns (bool)
303   {
304     allowed[msg.sender][_spender] = (
305       allowed[msg.sender][_spender].add(_addedValue));
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310   /**
311    * @dev Decrease the amount of tokens that an owner allowed to a spender.
312    *
313    * approve should be called when allowed[_spender] == 0. To decrement
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _subtractedValue The amount of tokens to decrease the allowance by.
319    */
320   function decreaseApproval(
321     address _spender,
322     uint256 _subtractedValue
323   )
324     public
325     returns (bool)
326   {
327     uint256 oldValue = allowed[msg.sender][_spender];
328     if (_subtractedValue > oldValue) {
329       allowed[msg.sender][_spender] = 0;
330     } else {
331       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
332     }
333     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337 }
338 
339 
340 
341 
342 /**
343  * @title Mintable token
344  * @dev Simple ERC20 Token example, with mintable token creation
345  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   modifier hasMintPermission() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will receive the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(
372     address _to,
373     uint256 _amount
374   )
375     hasMintPermission
376     canMint
377     public
378     returns (bool)
379   {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     emit Mint(_to, _amount);
383     emit Transfer(address(0), _to, _amount);
384     return true;
385   }
386 
387   /**
388    * @dev Function to stop minting new tokens.
389    * @return True if the operation was successful.
390    */
391   function finishMinting() onlyOwner canMint public returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 
399 
400 /**
401  * @title Capped token
402  * @dev Mintable token with a token cap.
403  */
404 contract CappedToken is MintableToken {
405 
406   uint256 public cap;
407 
408   constructor(uint256 _cap) public {
409     require(_cap > 0);
410     cap = _cap;
411   }
412   
413   function getCap() external returns(uint256 capToken) {
414       capToken = cap;
415   }
416 
417   /**
418    * @dev Function to mint tokens
419    * @param _to The address that will receive the minted tokens.
420    * @param _amount The amount of tokens to mint.
421    * @return A boolean that indicates if the operation was successful.
422    */
423   function mint(
424     address _to,
425     uint256 _amount
426   )
427     public
428     returns (bool)
429   {
430     require(totalSupply_.add(_amount) <= cap);
431 
432     return super.mint(_to, _amount);
433   }
434 
435 }
436 
437 
438 
439 /**
440  * @title FooToken
441  * @dev Very simple ERC20 Token that can be minted with Cap.
442  * Import contract CappedToken,MintableToken,StandardToken,ERC20,ERC20Basic,BasicToken,Ownable.
443  * Import library SafeMath.
444  */
445 contract FooToken is CappedToken {
446   string public constant version="1.0.0";
447   string public constant name = "Foo Token";
448   string public constant symbol = "FOO"; 
449   uint8 public constant decimals = 18; 
450   uint256 public closingTime;
451 
452   //set cap token
453   constructor(uint256 _closingTime) public CappedToken(uint256(100000000 * uint256(10 ** uint256(decimals)))) {
454     require(block.timestamp < _closingTime);
455     closingTime = _closingTime;
456   }
457   
458   /** 
459    * @dev Override mint for implement block mint when ICO finish
460    * @param _to The address that will receive the minted tokens.
461    * @param _amount The amount of tokens to mint.
462    * @return A boolean that indicates if the operation was successful.
463    */
464   function mint(
465     address _to,
466     uint256 _amount
467   )
468     public
469     returns (bool)
470   {
471     require(block.timestamp < closingTime);
472     return super.mint(_to, _amount);
473   }
474   /**
475   * @dev function for change date finish mint
476   * @param _closingTime date of closing mint
477   */
478   function changeClosingTime(uint256 _closingTime) public onlyOwner {
479     require(block.timestamp < _closingTime);
480     closingTime = _closingTime;
481   }
482   /**
483   * @dev override transferFrom for block transfer before ico finish
484   */
485   function transferFrom(address _from,address _to,uint256 _value) public returns (bool) {
486     require(block.timestamp >= closingTime);
487     return super.transferFrom(_from,_to,_value);
488   }
489   /**
490   * @dev override transfer for block transfer before ico finish
491   */
492   function transfer(address _to, uint256 _value) public returns (bool) {
493     require(block.timestamp >= closingTime);
494     return super.transfer(_to, _value);
495   }
496 }