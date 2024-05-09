1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-14
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, reverts on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
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
63     
64     return a % b;
65   }
66 }
67 
68 
69 contract Ownable {
70   address private _owner;
71 
72   event OwnershipTransferred(
73     address indexed previousOwner,
74     address indexed newOwner
75   );
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   constructor() internal {
82     _owner = msg.sender;
83     emit OwnershipTransferred(address(0), _owner);
84   }
85 
86   /**
87    * @return the address of the owner.
88    */
89   function owner() public view returns(address) {
90     return _owner;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(isOwner());
98     _;
99   }
100 
101   /**
102    * @return true if `msg.sender` is the owner of the contract.
103    */
104   function isOwner() public view returns(bool) {
105     return msg.sender == _owner;
106   }
107 
108   /**
109    * @dev Allows the current owner to relinquish control of the contract.
110    * @notice Renouncing to ownership will leave the contract without an owner.
111    * It will not be possible to call the functions with the `onlyOwner`
112    * modifier anymore.
113    */
114   function renounceOwnership() public onlyOwner {
115     emit OwnershipTransferred(_owner, address(0));
116     _owner = address(0);
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     _transferOwnership(newOwner);
125   }
126 
127   /**
128    * @dev Transfers control of the contract to a newOwner.
129    * @param newOwner The address to transfer ownership to.
130    */
131   function _transferOwnership(address newOwner) internal {
132     require(newOwner != address(0));
133     emit OwnershipTransferred(_owner, newOwner);
134     _owner = newOwner;
135   }
136 }
137 
138 /**
139  * @title ERC20 Basic
140  * @dev Simpler version of ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/179
142  */
143 contract IERC20Basic {
144   uint256 public totalSupply;
145   function transfer(address to, uint256 value) public returns (bool);
146   function balanceOf(address who) public view returns (uint256);
147   
148   event Transfer(address indexed from, address indexed to, uint256 value);
149 }
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract IERC20 is IERC20Basic {
156   function allowance(address owner, address spender) public view returns (uint256);
157   function approve(address spender, uint256 value) public returns (bool);
158   function transferFrom(address from, address to, uint256 value) public returns (bool);
159   
160   event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 /**
164  * @title ERC677 interface
165  */
166 contract IERC677 is IERC20 {
167   function transferAndCall(address to, uint value, bytes memory data) public returns (bool success);
168 
169   event Transfer(address indexed from, address indexed to, uint value, bytes data);
170 }
171 
172 contract ERC677Receiver {
173   function onTokenTransfer(address _sender, uint _value, bytes memory _data) public;
174 }
175 
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances. 
179  */
180 contract BasicToken is IERC20Basic {
181     
182   using SafeMath for uint256;
183   mapping(address => uint256) balances;
184 
185   /**
186   * @dev transfer token for a specified address
187   * @param _to The address to transfer to.
188   * @param _value The amount to be transferred.
189   */
190   function transfer(address _to, uint256 _value) public returns (bool) {
191     balances[msg.sender] = balances[msg.sender].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     emit Transfer(msg.sender, _to, _value);
194     return true;
195   }
196 
197   /**
198   * @dev Gets the balance of the specified address.
199   * @param _owner The address to query the the balance of. 
200   * @return An uint256 representing the amount owned by the passed address.
201   */
202   function balanceOf(address _owner) public view returns (uint256 balance) {
203     return balances[_owner];
204   }
205 
206 }
207 
208 
209 /**
210  * @title Standard ERC20 token
211  *
212  * @dev Implementation of the basic standard token.
213  * @dev https://github.com/ethereum/EIPs/issues/20
214  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
215  */
216 contract StandardToken is IERC20, BasicToken {
217 
218   mapping (address => mapping (address => uint256)) allowed;
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param _from address The address which you want to send tokens from
223    * @param _to address The address which you want to transfer to
224    * @param _value uint256 the amount of tokens to be transferred
225    */
226   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
227     uint256 _allowance = allowed[_from][msg.sender];
228 
229     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
230     // require (_value <= _allowance);
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = _allowance.sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     emit Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
257     return allowed[_owner][_spender];
258   }
259   
260     /*
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until 
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    */
266   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
267     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 /**
286  * @title ERC677Token
287  */
288 contract ERC677Token is IERC677 {
289 
290   /**
291   * @dev transfer token to a contract address with additional data if the recipient is a contact.
292   * @param _to The address to transfer to.
293   * @param _value The amount to be transferred.
294   * @param _data The extra data to be passed to the receiving contract.
295   */
296   function transferAndCall(address _to, uint _value, bytes memory _data)
297     public
298     returns (bool success)
299   {
300     transfer(_to, _value);
301     //super.transfer(_to, _value);
302     emit Transfer(msg.sender, _to, _value, _data);
303     if (isContract(_to)) {
304       contractFallback(_to, _value, _data);
305     }
306     return true;
307   }
308 
309   // PRIVATE
310 
311   function contractFallback(address _to, uint _value, bytes memory _data)
312     private
313   {
314     ERC677Receiver receiver = ERC677Receiver(_to);
315     receiver.onTokenTransfer(msg.sender, _value, _data);
316   }
317 
318   function isContract(address _addr) 
319     private view 
320     returns (bool hasCode)
321   {
322     uint length;
323     assembly { length := extcodesize(_addr) }
324     return length > 0;
325   }
326 
327 }
328 
329 
330 /**
331  * @title DetailContract
332  */
333 contract DetailContract is StandardToken, ERC677Token,Ownable {
334    using SafeMath for uint256;
335   string public constant name = 'GES';
336   string public constant symbol = 'GES';
337   uint8 public constant decimals = 18;
338   uint256 public  totalSupply = 500*10**24; // 
339 
340   constructor () Ownable() public
341   {
342     balances[msg.sender] = totalSupply;
343   }
344 
345   // MODIFIERS
346   modifier validRecipient(address _recipient) {
347     require(_recipient != address(0) && _recipient != address(this));
348     _;
349   }
350 
351   /**
352   * @dev transfer token to a specified address.
353   * @param _to The address to transfer to.
354   * @param _value The amount to be transferred.
355   */
356   function transfer(address _to, uint _value)
357     public
358     validRecipient(_to)
359     returns (bool success)
360   {
361     return super.transfer(_to, _value);
362   }
363 
364   /**
365    * @dev Transfer tokens from one address to another
366    * @param _from address The address which you want to send tokens from
367    * @param _to address The address which you want to transfer to
368    * @param _value uint256 the amount of tokens to be transferred
369    */
370   function transferFrom(address _from, address _to, uint256 _value)
371     public
372     validRecipient(_to)
373     returns (bool)
374   {
375     return super.transferFrom(_from, _to, _value);
376   }
377 
378   /**
379    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
380    * @param _spender The address which will spend the funds.
381    * @param _value The amount of tokens to be spent.
382    */
383   function approve(address _spender, uint256 _value)
384     public
385     validRecipient(_spender)
386     returns (bool)
387   {
388     return super.approve(_spender,  _value);
389   }
390 
391   /**
392   * @dev transfer token to a specified address with additional data if the recipient is a contract.
393   * @param _to The address to transfer to.
394   * @param _value The amount to be transferred.
395   * @param _data The extra data to be passed to the receiving contract.
396   */
397   function transferAndCall(address _to, uint _value, bytes memory _data)
398     public
399     validRecipient(_to)
400     returns (bool success)
401   {
402     return super.transferAndCall(_to, _value, _data);
403   }
404   function mint(address account, uint256 amount) public onlyOwner {
405         _mint(account, amount);
406     }
407 
408     function burn(address account, uint256 amount) public onlyOwner {
409         _burn(account, amount);
410     }
411     
412      function _mint(address account, uint256 amount) internal  {
413         require(account != address(0), "ERC20: mint to the zero address");
414 
415         totalSupply = totalSupply.add(amount);
416         balances[account] = balances[account].add(amount);
417        
418     }
419 
420     /**
421      * @dev Destroys `amount` tokens from `account`, reducing the
422      * total supply.
423      *
424      * Emits a {Transfer} event with `to` set to the zero address.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      * - `account` must have at least `amount` tokens.
430      */
431     function _burn(address account, uint256 amount) internal  {
432         require(account != address(0), "ERC20: burn from the zero address");
433 
434         balances[account] = balances[account].sub(amount);
435         totalSupply = totalSupply.sub(amount);
436        
437     }
438 
439 }