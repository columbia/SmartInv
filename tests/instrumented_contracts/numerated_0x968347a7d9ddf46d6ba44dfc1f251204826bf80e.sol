1 pragma solidity ^0.4.23;
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
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender)
91     public view returns (uint256);
92 
93   function transferFrom(address from, address to, uint256 value)
94     public returns (bool);
95 
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 
105 
106 /**
107  * @title DetailedERC20 token
108  * @dev The decimals are only for visualization purposes.
109  * All the operations are done using the smallest and indivisible token unit,
110  * just as on Ethereum all the operations are done in wei.
111  */
112 contract DetailedERC20 is ERC20 {
113   string public name;
114   string public symbol;
115   uint8 public decimals;
116 
117   constructor(string _name, string _symbol, uint8 _decimals) public {
118     name = _name;
119     symbol = _symbol;
120     decimals = _decimals;
121   }
122 }
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 
134 
135 /**
136  * @title SafeMath
137  * @dev Math operations with safety checks that throw on error
138  */
139 library SafeMath {
140 
141   /**
142   * @dev Multiplies two numbers, throws on overflow.
143   */
144   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
145     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
146     // benefit is lost if 'b' is also tested.
147     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148     if (a == 0) {
149       return 0;
150     }
151 
152     c = a * b;
153     assert(c / a == b);
154     return c;
155   }
156 
157   /**
158   * @dev Integer division of two numbers, truncating the quotient.
159   */
160   function div(uint256 a, uint256 b) internal pure returns (uint256) {
161     // assert(b > 0); // Solidity automatically throws when dividing by 0
162     // uint256 c = a / b;
163     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164     return a / b;
165   }
166 
167   /**
168   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
169   */
170   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171     assert(b <= a);
172     return a - b;
173   }
174 
175   /**
176   * @dev Adds two numbers, throws on overflow.
177   */
178   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
179     c = a + b;
180     assert(c >= a);
181     return c;
182   }
183 }
184 
185 
186 
187 /**
188  * @title Basic token
189  * @dev Basic version of StandardToken, with no allowances.
190  */
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   uint256 totalSupply_;
197 
198   /**
199   * @dev total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return totalSupply_;
203   }
204 
205   /**
206   * @dev transfer token for a specified address
207   * @param _to The address to transfer to.
208   * @param _value The amount to be transferred.
209   */
210   function transfer(address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[msg.sender]);
213 
214     balances[msg.sender] = balances[msg.sender].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     emit Transfer(msg.sender, _to, _value);
217     return true;
218   }
219 
220   /**
221   * @dev Gets the balance of the specified address.
222   * @param _owner The address to query the the balance of.
223   * @return An uint256 representing the amount owned by the passed address.
224   */
225   function balanceOf(address _owner) public view returns (uint256) {
226     return balances[_owner];
227   }
228 
229 }
230 
231 
232 
233 
234 /**
235  * @title Standard ERC20 token
236  *
237  * @dev Implementation of the basic standard token.
238  * @dev https://github.com/ethereum/EIPs/issues/20
239  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
240  */
241 contract StandardToken is ERC20, BasicToken {
242 
243   mapping (address => mapping (address => uint256)) internal allowed;
244 
245 
246   /**
247    * @dev Transfer tokens from one address to another
248    * @param _from address The address which you want to send tokens from
249    * @param _to address The address which you want to transfer to
250    * @param _value uint256 the amount of tokens to be transferred
251    */
252   function transferFrom(
253     address _from,
254     address _to,
255     uint256 _value
256   )
257     public
258     returns (bool)
259   {
260     require(_to != address(0));
261     require(_value <= balances[_from]);
262     require(_value <= allowed[_from][msg.sender]);
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    *
274    * Beware that changing an allowance with this method brings the risk that someone may use both the old
275    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278    * @param _spender The address which will spend the funds.
279    * @param _value The amount of tokens to be spent.
280    */
281   function approve(address _spender, uint256 _value) public returns (bool) {
282     allowed[msg.sender][_spender] = _value;
283     emit Approval(msg.sender, _spender, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Function to check the amount of tokens that an owner allowed to a spender.
289    * @param _owner address The address which owns the funds.
290    * @param _spender address The address which will spend the funds.
291    * @return A uint256 specifying the amount of tokens still available for the spender.
292    */
293   function allowance(
294     address _owner,
295     address _spender
296    )
297     public
298     view
299     returns (uint256)
300   {
301     return allowed[_owner][_spender];
302   }
303 
304   /**
305    * @dev Increase the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To increment
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _addedValue The amount of tokens to increase the allowance by.
313    */
314   function increaseApproval(
315     address _spender,
316     uint _addedValue
317   )
318     public
319     returns (bool)
320   {
321     allowed[msg.sender][_spender] = (
322       allowed[msg.sender][_spender].add(_addedValue));
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   /**
328    * @dev Decrease the amount of tokens that an owner allowed to a spender.
329    *
330    * approve should be called when allowed[_spender] == 0. To decrement
331    * allowed value is better to use this function to avoid 2 calls (and wait until
332    * the first transaction is mined)
333    * From MonolithDAO Token.sol
334    * @param _spender The address which will spend the funds.
335    * @param _subtractedValue The amount of tokens to decrease the allowance by.
336    */
337   function decreaseApproval(
338     address _spender,
339     uint _subtractedValue
340   )
341     public
342     returns (bool)
343   {
344     uint oldValue = allowed[msg.sender][_spender];
345     if (_subtractedValue > oldValue) {
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
356 
357 
358 
359 /**
360  * @title Mintable token
361  * @dev Simple ERC20 Token example, with mintable token creation
362  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
363  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
364  */
365 contract MintableToken is StandardToken, Ownable {
366   event Mint(address indexed to, uint256 amount);
367   event MintFinished();
368 
369   bool public mintingFinished = false;
370 
371 
372   modifier canMint() {
373     require(!mintingFinished);
374     _;
375   }
376 
377   modifier hasMintPermission() {
378     require(msg.sender == owner);
379     _;
380   }
381 
382   /**
383    * @dev Function to mint tokens
384    * @param _to The address that will receive the minted tokens.
385    * @param _amount The amount of tokens to mint.
386    * @return A boolean that indicates if the operation was successful.
387    */
388   function mint(
389     address _to,
390     uint256 _amount
391   )
392     hasMintPermission
393     canMint
394     public
395     returns (bool)
396   {
397     totalSupply_ = totalSupply_.add(_amount);
398     balances[_to] = balances[_to].add(_amount);
399     emit Mint(_to, _amount);
400     emit Transfer(address(0), _to, _amount);
401     return true;
402   }
403 
404   /**
405    * @dev Function to stop minting new tokens.
406    * @return True if the operation was successful.
407    */
408   function finishMinting() onlyOwner canMint public returns (bool) {
409     mintingFinished = true;
410     emit MintFinished();
411     return true;
412   }
413 }
414 
415 
416 
417 
418 
419 
420 
421 /**
422  * @title Pausable
423  * @dev Base contract which allows children to implement an emergency stop mechanism.
424  */
425 contract Pausable is Ownable {
426   event Pause();
427   event Unpause();
428 
429   bool public paused = false;
430 
431 
432   /**
433    * @dev Modifier to make a function callable only when the contract is not paused.
434    */
435   modifier whenNotPaused() {
436     require(!paused);
437     _;
438   }
439 
440   /**
441    * @dev Modifier to make a function callable only when the contract is paused.
442    */
443   modifier whenPaused() {
444     require(paused);
445     _;
446   }
447 
448   /**
449    * @dev called by the owner to pause, triggers stopped state
450    */
451   function pause() onlyOwner whenNotPaused public {
452     paused = true;
453     emit Pause();
454   }
455 
456   /**
457    * @dev called by the owner to unpause, returns to normal state
458    */
459   function unpause() onlyOwner whenPaused public {
460     paused = false;
461     emit Unpause();
462   }
463 }
464 
465 
466 contract HiwayToken is MintableToken, DetailedERC20, Pausable {
467     constructor(string _name, string _symbol, uint8 _decimals, uint _totalSupply) 
468         DetailedERC20(_name, _symbol,  _decimals)
469 
470         public {
471         _totalSupply = _totalSupply * 10**uint(decimals);
472         balances[owner] = _totalSupply;
473         emit Transfer(address(0), owner, _totalSupply);
474 
475     }
476 }