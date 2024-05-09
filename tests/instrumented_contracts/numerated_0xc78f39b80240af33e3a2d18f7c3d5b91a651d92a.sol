1 pragma solidity ^0.4.13;
2 
3 /**
4 * GoldGate Token Contract
5 * Copyright © 2017 by GoldGate https://goldgate.io
6 */
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) constant returns (uint256);
16   function transfer(address to, uint256 value) returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   function approve(address spender, uint256 value) returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * @title Basic token
33  * @dev Basic version of StandardToken, with no allowances. 
34  */
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37 
38   mapping(address => uint256) balances;
39 
40   /**
41   * @dev transfer token for a specified address
42   * @param _to The address to transfer to.
43   * @param _value The amount to be transferred.
44   */
45   function transfer(address _to, uint256 _value) returns (bool) {
46     require(_to != address(0));
47 
48     // SafeMath.sub will throw if there is not enough balance.
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   /**
56   * @dev Gets the balance of the specified address.
57   * @param _owner The address to query the the balance of. 
58   * @return An uint256 representing the amount owned by the passed address.
59   */
60   function balanceOf(address _owner) constant returns (uint256 balance) {
61     return balances[_owner];
62   }
63 
64 }
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) onlyOwner {
101     require(newOwner != address(0));      
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106 }
107 
108 /**
109  * @title Pausable
110  * @dev Base contract which allows children to implement an emergency stop mechanism.
111  */
112 contract Pausable is Ownable {
113   event Pause();
114   event Unpause();
115 
116   bool public paused = false;
117 
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is not paused.
121    */
122   modifier whenNotPaused() {
123     require(!paused);
124     _;
125   }
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is paused.
129    */
130   modifier whenPaused() {
131     require(paused);
132     _;
133   }
134 
135   /**
136    * @dev called by the owner to pause, triggers stopped state
137    */
138   function pause() onlyOwner whenNotPaused {
139     paused = true;
140     Pause();
141   }
142 
143   /**
144    * @dev called by the owner to unpause, returns to normal state
145    */
146   function unpause() onlyOwner whenPaused {
147     paused = false;
148     Unpause();
149   }
150 }
151 
152 /**
153  * @title Ownable
154  */
155 contract BOwnable is Ownable {
156 
157   address public newOwner;
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to an otherOwner.
161    * @param otherOwner The address to transfer ownership to.
162    */
163   function transferOwnership(address otherOwner) onlyOwner {
164     require(otherOwner != address(0));      
165     newOwner = otherOwner;
166   }
167 
168   /**
169    * @dev Finish ownership transfer.
170    */
171   function approveOwnership() {
172     require(msg.sender == newOwner);
173     OwnershipTransferred(owner, newOwner);
174     owner = newOwner;
175     newOwner = address(0);
176   }
177 }
178 
179 
180 /**
181  * @title Moderated
182  * @dev Moderator can make transfers from and to any account (including frozen).
183  */
184 contract GGModerated is BOwnable {
185 
186   address public moderator;
187   address public newModerator;
188 
189   /**
190    * @dev Throws if called by any account other than the moderator.
191    */
192   modifier onlyModerator() {
193     require(msg.sender == moderator);
194     _;
195   }
196 
197   /**
198    * @dev Throws if called by any account other than the owner or moderator.
199    */
200   modifier onlyOwnerOrModerator() {
201     require((msg.sender == moderator) || (msg.sender == owner));
202     _;
203   }
204 
205   /**
206    * @dev Moderator same as owner
207    */
208   function GGModerated(){
209     moderator = msg.sender;
210   }
211 
212   /**
213    * @dev Allows the current moderator to transfer control of the contract to an otherModerator.
214    * @param otherModerator The address to transfer moderatorship to.
215    */
216   function transferModeratorship(address otherModerator) onlyModerator {
217     newModerator = otherModerator;
218   }
219 
220   /**
221    * @dev Complete moderatorship transfer.
222    */
223   function approveModeratorship() {
224     require(msg.sender == newModerator);
225     moderator = newModerator;
226     newModerator = address(0);
227   }
228 
229   /**
230    * @dev Removes moderator from the contract.
231    * After this point, moderator role will be eliminated completly.
232    */
233   function removeModeratorship() onlyOwner {
234       moderator = address(0);
235   }
236 
237   function hasModerator() constant returns(bool) {
238       return (moderator != address(0));
239   }
240 }
241 
242 
243 /**
244  * @title Pausable
245  */
246 contract GGPausable is Pausable, GGModerated {
247   /**
248    * @dev called by the owner or moderator to pause, triggers stopped state
249    */
250   function pause() onlyOwnerOrModerator whenNotPaused {
251     paused = true;
252     Pause();
253   }
254 
255   /**
256    * @dev called by the owner or moderator to unpause, returns to normal state
257    */
258   function unpause() onlyOwnerOrModerator whenPaused {
259     paused = false;
260     Unpause();
261   }
262 }
263 
264 /**
265  * @title Standard ERC20 token
266  *
267  * @dev Implementation of the basic standard token.
268  * @dev https://github.com/ethereum/EIPs/issues/20
269  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
270  */
271 contract StandardToken is ERC20, BasicToken {
272 
273   mapping (address => mapping (address => uint256)) allowed;
274 
275 
276   /**
277    * @dev Transfer tokens from one address to another
278    * @param _from address The address which you want to send tokens from
279    * @param _to address The address which you want to transfer to
280    * @param _value uint256 the amount of tokens to be transferred
281    */
282   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
283     require(_to != address(0));
284 
285     var _allowance = allowed[_from][msg.sender];
286 
287     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
288     // require (_value <= _allowance);
289 
290     balances[_from] = balances[_from].sub(_value);
291     balances[_to] = balances[_to].add(_value);
292     allowed[_from][msg.sender] = _allowance.sub(_value);
293     Transfer(_from, _to, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
299    * @param _spender The address which will spend the funds.
300    * @param _value The amount of tokens to be spent.
301    */
302   function approve(address _spender, uint256 _value) returns (bool) {
303 
304     // To change the approve amount you first have to reduce the addresses`
305     //  allowance to zero by calling `approve(_spender, 0)` if it is not
306     //  already 0 to mitigate the race condition described here:
307     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
309 
310     allowed[msg.sender][_spender] = _value;
311     Approval(msg.sender, _spender, _value);
312     return true;
313   }
314 
315   /**
316    * @dev Function to check the amount of tokens that an owner allowed to a spender.
317    * @param _owner address The address which owns the funds.
318    * @param _spender address The address which will spend the funds.
319    * @return A uint256 specifying the amount of tokens still available for the spender.
320    */
321   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
322     return allowed[_owner][_spender];
323   }
324   
325   /**
326    * approve should be called when allowed[_spender] == 0. To increment
327    * allowed value is better to use this function to avoid 2 calls (and wait until 
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    */
331   function increaseApproval (address _spender, uint _addedValue) 
332     returns (bool success) {
333     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
334     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338   function decreaseApproval (address _spender, uint _subtractedValue) 
339     returns (bool success) {
340     uint oldValue = allowed[msg.sender][_spender];
341     if (_subtractedValue > oldValue) {
342       allowed[msg.sender][_spender] = 0;
343     } else {
344       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
345     }
346     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
347     return true;
348   }
349 
350 }
351 
352 
353 /**
354  * @title SafeMath
355  * @dev Math operations with safety checks that throw on error
356  */
357 library SafeMath {
358   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
359     uint256 c = a * b;
360     assert(a == 0 || c / a == b);
361     return c;
362   }
363 
364   function div(uint256 a, uint256 b) internal constant returns (uint256) {
365     // assert(b > 0); // Solidity automatically throws when dividing by 0
366     uint256 c = a / b;
367     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
368     return c;
369   }
370 
371   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
372     assert(b <= a);
373     return a - b;
374   }
375 
376   function add(uint256 a, uint256 b) internal constant returns (uint256) {
377     uint256 c = a + b;
378     assert(c >= a);
379     return c;
380   }
381 }
382 
383 /**
384  * Pausable token with moderator role and freeze address implementation
385  *
386  **/
387 contract ModToken is StandardToken, GGPausable {
388 
389   mapping(address => bool) frozen;
390 
391   /**
392    * @dev Check if given address is frozen. Freeze works only if moderator role is active
393    * @param _addr address Address to check
394    */
395   function isFrozen(address _addr) constant returns (bool){
396       return frozen[_addr] && hasModerator();
397   }
398 
399   /**
400    * @dev Freezes address (no transfer can be made from or to this address).
401    * @param _addr address Address to be frozen
402    */
403   function freeze(address _addr) onlyModerator {
404       frozen[_addr] = true;
405   }
406 
407   /**
408    * @dev Unfreezes frozen address.
409    * @param _addr address Address to be unfrozen
410    */
411   function unfreeze(address _addr) onlyModerator {
412       frozen[_addr] = false;
413   }
414 
415   /**
416    * @dev Declines transfers from/to frozen addresses.
417    * @param _to address The address which you want to transfer to
418    * @param _value uint256 the amout of tokens to be transfered
419    */
420   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
421     require(!isFrozen(msg.sender));
422     require(!isFrozen(_to));
423     return super.transfer(_to, _value);
424   }
425 
426   /**
427    * @dev Declines transfers from/to/by frozen addresses.
428    * @param _from address The address which you want to send tokens from
429    * @param _to address The address which you want to transfer to
430    * @param _value uint256 the amout of tokens to be transfered
431    */
432   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
433     require(!isFrozen(msg.sender));
434     require(!isFrozen(_from));
435     require(!isFrozen(_to));
436     return super.transferFrom(_from, _to, _value);
437   }
438 
439   /**
440    * @dev Allows moderator to transfer tokens from one address to another.
441    * @param _from address The address which you want to send tokens from
442    * @param _to address The address which you want to transfer to
443    * @param _value uint256 the amout of tokens to be transfered
444    */
445   function moderatorTransferFrom(address _from, address _to, uint256 _value) onlyModerator returns (bool) {
446     balances[_to] = balances[_to].add(_value);
447     balances[_from] = balances[_from].sub(_value);
448     Transfer(_from, _to, _value);
449     return true;
450   }
451 }
452 
453 contract CreateToken is ModToken {
454   string public constant version = "1.10";
455   string public constant name = "TheRam";
456   string public constant symbol = "TRR";
457   uint256 public constant decimals = 8;
458 
459   /**
460    * @dev Constructor that gives msg.sender all of existing tokens. 
461    */
462   function CreateToken(uint256 _initialSupply) {   
463     totalSupply = _initialSupply;
464     balances[msg.sender] = _initialSupply;
465   }
466 }