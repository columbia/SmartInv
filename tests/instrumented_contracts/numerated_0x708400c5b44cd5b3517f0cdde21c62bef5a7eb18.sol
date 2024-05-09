1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 {
73   function totalSupply() public view returns (uint256);
74 
75   function balanceOf(address _who) public view returns (uint256);
76 
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transfer(address _to, uint256 _value) public returns (bool);
81 
82   function approve(address _spender, uint256 _value)
83     public returns (bool);
84 
85   function transferFrom(address _from, address _to, uint256 _value)
86     public returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) public balances;
113 
114   mapping (address => mapping (address => uint256)) public allowed;
115 
116   uint256 public totalSupply_;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return totalSupply_;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256) {
131     return balances[_owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address _owner,
142     address _spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_value <= balances[msg.sender]);
158     require(_to != address(0));
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
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
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(
188     address _from,
189     address _to,
190     uint256 _value
191   )
192     public
193     returns (bool)
194   {
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197     require(_to != address(0));
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     emit Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint256 _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(
238     address _spender,
239     uint256 _subtractedValue
240   )
241     public
242     returns (bool)
243   {
244     uint256 oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue >= oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Internal function that mints an amount of the token and assigns it to
256    * an account. This encapsulates the modification of balances such that the
257    * proper events are emitted.
258    * @param _account The account that will receive the created tokens.
259    * @param _amount The amount that will be created.
260    */
261   function _mint(address _account, uint256 _amount) internal {
262     require(_account != 0);
263     totalSupply_ = totalSupply_.add(_amount);
264     balances[_account] = balances[_account].add(_amount);
265     emit Transfer(address(0), _account, _amount);
266   }
267 
268   /**
269    * @dev Internal function that burns an amount of the token of a given
270    * account.
271    * @param _account The account whose tokens will be burnt.
272    * @param _amount The amount that will be burnt.
273    */
274   function _burn(address _account, uint256 _amount) internal {
275     require(_account != 0);
276     require(_amount <= balances[_account]);
277 
278     totalSupply_ = totalSupply_.sub(_amount);
279     balances[_account] = balances[_account].sub(_amount);
280     emit Transfer(_account, address(0), _amount);
281   }
282 
283   /**
284    * @dev Internal function that burns an amount of the token of a given
285    * account, deducting from the sender's allowance for said account. Uses the
286    * internal _burn function.
287    * @param _account The account whose tokens will be burnt.
288    * @param _amount The amount that will be burnt.
289    */
290   function _burnFrom(address _account, uint256 _amount) internal {
291     require(_amount <= allowed[_account][msg.sender]);
292 
293     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
294     // this function needs to emit an event with the updated approval.
295     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
296     _burn(_account, _amount);
297   }
298 }
299 
300 /**
301  * @title Burnable
302  *
303  * @dev Standard ERC20 token
304  */
305 contract Burnable is StandardToken {
306   using SafeMath for uint;
307 
308   /* This notifies clients about the amount burnt */
309   event Burn(address indexed from, uint value);
310 
311   function burn(uint _value) public returns (bool success) {
312     require(_value > 0 && balances[msg.sender] >= _value);
313     balances[msg.sender] = balances[msg.sender].sub(_value);
314     totalSupply_ = totalSupply_.sub(_value);
315     emit Burn(msg.sender, _value);
316     return true;
317   }
318 
319   function burnFrom(address _from, uint _value) public returns (bool success) {
320     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
321     require(_value <= allowed[_from][msg.sender]);
322     balances[_from] = balances[_from].sub(_value);
323     totalSupply_ = totalSupply_.sub(_value);
324     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
325     emit Burn(_from, _value);
326     return true;
327   }
328 
329   function transfer(address _to, uint _value) public returns (bool success) {
330     require(_to != 0x0); //use burn
331 
332     return super.transfer(_to, _value);
333   }
334 
335   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
336     require(_to != 0x0); //use burn
337 
338     return super.transferFrom(_from, _to, _value);
339   }
340 }
341 
342 /**
343  * @title Ownable
344  * @dev The Ownable contract has an owner address, and provides basic authorization control
345  * functions, this simplifies the implementation of "user permissions".
346  */
347 contract Ownable {
348   address public owner;
349 
350 
351   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
352 
353 
354   /**
355    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
356    * account.
357    */
358   constructor() public {
359     owner = msg.sender;
360   }
361 
362 
363   /**
364    * @dev Throws if called by any account other than the owner.
365    */
366   modifier onlyOwner() {
367     require(msg.sender == owner);
368     _;
369   }
370 
371 
372   /**
373    * @dev Allows the current owner to transfer control of the contract to a newOwner.
374    * @param newOwner The address to transfer ownership to.
375    */
376   function transferOwnership(address newOwner) public onlyOwner {
377     require(newOwner != address(0));
378     emit OwnershipTransferred(owner, newOwner);
379     owner = newOwner;
380   }
381 
382 }
383 
384 /**
385  * @title MyToken
386  *
387  * @dev Burnable Ownable ERC20 token
388  */
389 contract MyToken is Burnable, Ownable {
390 
391   string public constant name = "APS1 Token";
392   string public constant symbol = "APST1";
393   uint8 public constant decimals = 18;
394   uint256 public constant INITIAL_SUPPLY = 1000000000 * 1 ether;
395 
396   /* The finalizer contract that allows unlift the transfer limits on this token */
397   address public releaseAgent;
398 
399   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
400   bool public released = false; //false: lock up, true: free
401 
402   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
403   mapping (address => bool) public transferAgents;
404 
405   /**
406    * Limit token transfer until the crowdsale is over.
407    *
408    */
409   modifier canTransfer(address _sender) {
410     require(released || transferAgents[_sender]);
411     _;
412   }
413 
414   /** The function can be called only before or after the tokens have been released */
415   modifier inReleaseState(bool releaseState) {
416     require(releaseState == released);
417     _;
418   }
419 
420   /** The function can be called only by a whitelisted release agent. */
421   modifier onlyReleaseAgent() {
422     require(msg.sender == releaseAgent);
423     _;
424   }
425 
426 
427   /**
428    * @dev Constructor that gives msg.sender all of existing tokens.
429    */
430   constructor() public {
431     totalSupply_ = INITIAL_SUPPLY;
432     balances[msg.sender] = INITIAL_SUPPLY;
433     transferAgents[msg.sender] = true;
434     releaseAgent = msg.sender;
435   }
436 
437 
438   /**
439    * Set the contract that can call release and make the token transferable.
440    *
441    * Design choice. Allow reset the release agent to fix fat finger mistakes.
442    */
443   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
444     require(addr != 0x0);
445 
446     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
447     releaseAgent = addr;
448   }
449 
450   function release(bool releaseState) onlyReleaseAgent public {
451     released = releaseState;
452   }
453 
454   /**
455    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
456    */
457   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
458     require(addr != 0x0);
459     transferAgents[addr] = state;
460   }
461 
462   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
463     // Call Burnable.transfer()
464     return super.transfer(_to, _value);
465   }
466 
467   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {    
468     return super.transferFrom(_from, _to, _value);
469   }
470 
471   function burn(uint _value) public onlyOwner returns (bool success) {
472     return super.burn(_value);
473   }
474 
475   function burnFrom(address _from, uint _value) public onlyOwner returns (bool success) {
476     return super.burnFrom(_from, _value);
477   }
478 }