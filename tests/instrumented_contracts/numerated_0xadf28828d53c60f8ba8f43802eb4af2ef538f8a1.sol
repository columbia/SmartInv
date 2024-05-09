1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87   modifier onlyPayloadSize(uint256 numwords) {
88     assert(msg.data.length >= numwords * 32 + 4);
89     _;
90   }
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     // SafeMath.sub will throw if there is not enough balance.
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256 balance) {
121     return balances[_owner];
122   }
123 
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  * @dev Implementation of the basic standard token.
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     emit Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     emit Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /**
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   constructor() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     emit OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 /**
255  * @title Pausable
256  * @dev Base contract which allows children to implement an emergency stop mechanism.
257  */
258 contract Pausable is Ownable {
259   event Pause();
260   event Unpause();
261 
262   bool public paused = false;
263 
264 
265   /**
266    * @dev Modifier to make a function callable only when the contract is not paused.
267    */
268   modifier whenNotPaused() {
269     require(!paused);
270     _;
271   }
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is paused.
275    */
276   modifier whenPaused() {
277     require(paused);
278     _;
279   }
280 
281   /**
282    * @dev called by the owner to pause, triggers stopped state
283    */
284   function pause() onlyOwner whenNotPaused public {
285     paused = true;
286     emit Pause();
287   }
288 
289   /**
290    * @dev called by the owner to unpause, returns to normal state
291    */
292   function unpause() onlyOwner whenPaused public {
293     paused = false;
294     emit Unpause();
295   }
296 }
297 
298 /**
299  * @title Pausable token
300  * @dev StandardToken modified with pausable transfers.
301  **/
302 contract PausableToken is StandardToken, Pausable {
303 
304   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
305     return super.transfer(_to, _value);
306   }
307 
308   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
309     return super.transferFrom(_from, _to, _value);
310   }
311 
312   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
313     return super.approve(_spender, _value);
314   }
315 
316   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
317     return super.increaseApproval(_spender, _addedValue);
318   }
319 
320   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
321     return super.decreaseApproval(_spender, _subtractedValue);
322   }
323 }
324 
325 
326 /**
327  * @title Claimable
328  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
329  * This allows the new owner to accept the transfer.
330  */
331 contract Claimable is Ownable {
332   address public pendingOwner;
333 
334   /**
335    * @dev Modifier throws if called by any account other than the pendingOwner.
336    */
337   modifier onlyPendingOwner() {
338     require(msg.sender == pendingOwner);
339     _;
340   }
341 
342   /**
343    * @dev Allows the current owner to set the pendingOwner address.
344    * @param newOwner The address to transfer ownership to.
345    */
346   function transferOwnership(address newOwner) onlyOwner public {
347     pendingOwner = newOwner;
348   }
349 
350   /**
351    * @dev Allows the pendingOwner address to finalize the transfer.
352    */
353   function claimOwnership() onlyPendingOwner public {
354     emit OwnershipTransferred(owner, pendingOwner);
355     owner = pendingOwner;
356     pendingOwner = address(0);
357   }
358 }
359 
360 /**
361  * @title Mintable token
362  * @dev Simple ERC20 Token example, with mintable token creation
363  */
364 contract MintableToken is PausableToken {
365 
366   event Mint(address indexed to, uint256 amount);
367   event MintFinished();
368 
369   bool public mintingFinished = false;
370   
371   modifier canMint() {
372     require(!mintingFinished);
373     _;
374   }
375 
376   address public saleAgent = address(0);
377   address public saleAgent2 = address(0);
378 
379   function setSaleAgent(address newSaleAgent) onlyOwner public {
380     saleAgent = newSaleAgent;
381   }
382 
383   function setSaleAgent2(address newSaleAgent) onlyOwner public {
384     saleAgent2 = newSaleAgent;
385   }
386 
387   /**
388    * @dev Function to mint tokens
389    * @param _to The address that will receive the minted tokens.
390    * @param _amount The amount of tokens to mint.
391    * @return A boolean that indicates if the operation was successful.
392    */
393   function mint(address _to, uint256 _amount) canMint public returns (bool) {
394     require(msg.sender == saleAgent || msg.sender == saleAgent2 || msg.sender == owner);
395     totalSupply_ = totalSupply_.add(_amount);
396     balances[_to] = balances[_to].add(_amount);
397     emit Mint(_to, _amount);
398     emit Transfer(address(this), _to, _amount);
399     
400     return true;
401   }   
402   
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
416 contract LEAD is MintableToken, Claimable {
417     string public constant name = "LEADEX"; 
418     string public constant symbol = "LEAD";
419     uint public constant decimals = 8;
420 }