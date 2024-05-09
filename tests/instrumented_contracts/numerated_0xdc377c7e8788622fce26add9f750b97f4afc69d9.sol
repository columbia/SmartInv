1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ERC223/ERC223_receiving_contract.sol
4 
5 /**
6 * @title Contract that will work with ERC223 tokens.
7 */
8 
9 contract ERC223ReceivingContract {
10     /**
11      * @dev Standard ERC223 function that will handle incoming token transfers.
12      *
13      * @param _from  Token sender address.
14      * @param _value Amount of tokens.
15      * @param _data  Transaction metadata.
16      */
17     function tokenFallback(address _from, uint _value, bytes _data) public;
18 }
19 
20 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     emit OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 // File: zeppelin-solidity/contracts/math/SafeMath.sol
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
125 
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances.
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   uint256 totalSupply_;
136 
137   /**
138   * @dev total number of tokens in existence
139   */
140   function totalSupply() public view returns (uint256) {
141     return totalSupply_;
142   }
143 
144   /**
145   * @dev transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _value The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     emit Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     emit Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
282 
283 /**
284  * @title Mintable token
285  * @dev Simple ERC20 Token example, with mintable token creation
286  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
287  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
288  */
289 contract MintableToken is StandardToken, Ownable {
290   event Mint(address indexed to, uint256 amount);
291   event MintFinished();
292 
293   bool public mintingFinished = false;
294 
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     totalSupply_ = totalSupply_.add(_amount);
309     balances[_to] = balances[_to].add(_amount);
310     emit Mint(_to, _amount);
311     emit Transfer(address(0), _to, _amount);
312     return true;
313   }
314 
315   /**
316    * @dev Function to stop minting new tokens.
317    * @return True if the operation was successful.
318    */
319   function finishMinting() onlyOwner canMint public returns (bool) {
320     mintingFinished = true;
321     emit MintFinished();
322     return true;
323   }
324 }
325 
326 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
327 
328 /**
329  * @title Capped token
330  * @dev Mintable token with a token cap.
331  */
332 contract CappedToken is MintableToken {
333 
334   uint256 public cap;
335 
336   constructor(uint256 _cap) public {
337     require(_cap > 0);
338     cap = _cap;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     require(totalSupply_.add(_amount) <= cap);
349 
350     return super.mint(_to, _amount);
351   }
352 
353 }
354 
355 // File: contracts/SafeGuardsToken.sol
356 
357 contract SafeGuardsToken is CappedToken {
358 
359     string constant public name = "SafeGuards Coin";
360     string constant public symbol = "SGCT";
361     uint constant public decimals = 18;
362 
363     // address who can burn tokens
364     address public canBurnAddress;
365 
366     // list with frozen addresses
367     mapping (address => bool) public frozenList;
368 
369     // timestamp until investors in frozen list can't transfer tokens
370     uint256 public frozenPauseTime = now + 180 days;
371 
372     // timestamp until investors can't burn tokens
373     uint256 public burnPausedTime = now + 180 days;
374 
375 
376     constructor(address _canBurnAddress) CappedToken(61 * 1e6 * 1e18) public {
377         require(_canBurnAddress != 0x0);
378         canBurnAddress = _canBurnAddress;
379     }
380 
381 
382     // ===--- Presale frozen functionality ---===
383 
384     event ChangeFrozenPause(uint256 newFrozenPauseTime);
385 
386     /**
387      * @dev Function to mint frozen tokens
388      * @param _to The address that will receive the minted tokens.
389      * @param _amount The amount of tokens to mint.
390      * @return A boolean that indicates if the operation was successful.
391      */
392     function mintFrozen(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
393         frozenList[_to] = true;
394         return super.mint(_to, _amount);
395     }
396 
397     function changeFrozenTime(uint256 _newFrozenPauseTime) onlyOwner public returns (bool) {
398         require(_newFrozenPauseTime > now);
399 
400         frozenPauseTime = _newFrozenPauseTime;
401         emit ChangeFrozenPause(_newFrozenPauseTime);
402         return true;
403     }
404 
405 
406     // ===--- Override transfers with implementation of the ERC223 standard and frozen logic ---===
407 
408     event Transfer(address indexed from, address indexed to, uint value, bytes data);
409 
410     /**
411     * @dev transfer token for a specified address
412     * @param _to The address to transfer to.
413     * @param _value The amount to be transferred.
414     */
415     function transfer(address _to, uint _value) public returns (bool) {
416         bytes memory empty;
417         return transfer(_to, _value, empty);
418     }
419 
420     /**
421     * @dev transfer token for a specified address
422     * @param _to The address to transfer to.
423     * @param _value The amount to be transferred.
424     * @param _data Optional metadata.
425     */
426     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
427         require(now > frozenPauseTime || !frozenList[msg.sender]);
428 
429         super.transfer(_to, _value);
430 
431         if (isContract(_to)) {
432             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
433             receiver.tokenFallback(msg.sender, _value, _data);
434             emit Transfer(msg.sender, _to, _value, _data);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Transfer tokens from one address to another
442      * @param _from address The address which you want to send tokens from
443      * @param _to address The address which you want to transfer to
444      * @param _value uint the amount of tokens to be transferred
445      */
446     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
447         bytes memory empty;
448         return transferFrom(_from, _to, _value, empty);
449     }
450 
451     /**
452      * @dev Transfer tokens from one address to another
453      * @param _from address The address which you want to send tokens from
454      * @param _to address The address which you want to transfer to
455      * @param _value uint the amount of tokens to be transferred
456      * @param _data Optional metadata.
457      */
458     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
459         require(now > frozenPauseTime || !frozenList[msg.sender]);
460 
461         super.transferFrom(_from, _to, _value);
462 
463         if (isContract(_to)) {
464             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
465             receiver.tokenFallback(_from, _value, _data);
466         }
467 
468         emit Transfer(_from, _to, _value, _data);
469         return true;
470     }
471 
472     function isContract(address _addr) private view returns (bool) {
473         uint length;
474         assembly {
475         //retrieve the size of the code on target address, this needs assembly
476             length := extcodesize(_addr)
477         }
478         return (length>0);
479     }
480 
481 
482     // ===--- Burnable functionality ---===
483 
484     event Burn(address indexed burner, uint256 value);
485     event ChangeBurnPause(uint256 newBurnPauseTime);
486 
487     /**
488      * @dev Burns a specific amount of tokens.
489      * @param _value The amount of token to be burned.
490      */
491     function burn(uint256 _value) public {
492         require(burnPausedTime < now || msg.sender == canBurnAddress);
493 
494         require(_value <= balances[msg.sender]);
495 
496         address burner = msg.sender;
497         balances[burner] = balances[burner].sub(_value);
498         totalSupply_ = totalSupply_.sub(_value);
499         emit Burn(burner, _value);
500         emit Transfer(burner, address(0), _value);
501     }
502 
503     function changeBurnPausedTime(uint256 _newBurnPauseTime) onlyOwner public returns (bool) {
504         require(_newBurnPauseTime > burnPausedTime);
505 
506         burnPausedTime = _newBurnPauseTime;
507         emit ChangeBurnPause(_newBurnPauseTime);
508         return true;
509     }
510 }