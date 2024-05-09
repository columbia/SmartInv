1 pragma solidity ^0.4.11;
2 
3 //
4 // SafeMath
5 //
6 // Ownable
7 // Destructible
8 // Pausable
9 //
10 // ERC20Basic
11 // ERC20 : ERC20Basic
12 // BasicToken : ERC20Basic
13 // StandardToken : ERC20, BasicToken
14 // MintableToken : StandardToken, Ownable
15 // PausableToken : StandardToken, Pausable
16 //
17 // CAToken : MintableToken, PausableToken
18 //
19 // Crowdsale
20 // PausableCrowdsale
21 // BonusCrowdsale
22 // TokensCappedCrowdsale
23 // FinalizableCrowdsale
24 //
25 // CATCrowdsale
26 //
27 
28 // Date.now()/1000+3600,  Date.now()/1000+3600*2, 4700, "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4"
29 // 1508896220, 1509899832, 4700, "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4"
30 // 1507909923, 1508514723, 4700, "0x0b8e27013dfA822bF1cc01b6Ae394B76DA230a03", "0x5F85A0e9DD5Bd2F11a54b208427b286e9B0B519F", "0x7F781d08FD165DBEE1D573Bdb79c43045442eac4", "0x98bf67b6a03DA7AcF2Ee7348FdB3F9c96425a130"
31 // 1509120669, 1519120669, 3000, "0x06E58BD5DeEC639d9a79c9cD3A653655EdBef820", "0x06E58BD5DeEC639d9a79c9cD3A653655EdBef820", "0x06E58BD5DeEC639d9a79c9cD3A653655EdBef820"
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) onlyOwner public {
98     require(newOwner != address(0));
99     OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 
103 }
104 
105 /**
106  * @title Destructible
107  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
108  */
109 contract Destructible is Ownable {
110 
111   function Destructible() public payable { }
112 
113   /**
114    * @dev Transfers the current balance to the owner and terminates the contract.
115    */
116   function destroy() onlyOwner public {
117     selfdestruct(owner);
118   }
119 
120   function destroyAndSend(address _recipient) onlyOwner public {
121     selfdestruct(_recipient);
122   }
123 }
124 
125 /**
126  * @title Pausable
127  * @dev Base contract which allows children to implement an emergency stop mechanism.
128  */
129 contract Pausable is Ownable {
130   event Pause();
131   event Unpause();
132 
133   bool public paused = false;
134 
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is not paused.
138    */
139   modifier whenNotPaused() {
140     require(!paused);
141     _;
142   }
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is paused.
146    */
147   modifier whenPaused() {
148     require(paused);
149     _;
150   }
151 
152   /**
153    * @dev called by the owner to pause, triggers stopped state
154    */
155   function pause() onlyOwner whenNotPaused public {
156     paused = true;
157     Pause();
158   }
159 
160   /**
161    * @dev called by the owner to unpause, returns to normal state
162    */
163   function unpause() onlyOwner whenPaused public {
164     paused = false;
165     Unpause();
166   }
167 }
168 
169 /**
170  * @title ERC20Basic
171  * @dev Simpler version of ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/179
173  */
174 contract ERC20Basic {
175   uint256 public totalSupply;
176   function balanceOf(address who) public constant returns (uint256);
177   function transfer(address to, uint256 value) public returns (bool);
178   event Transfer(address indexed from, address indexed to, uint256 value);
179 }
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender) public constant returns (uint256);
187   function transferFrom(address from, address to, uint256 value) public returns (bool);
188   function approve(address spender, uint256 value) public returns (bool);
189   event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 /**
193  * @title Basic token
194  * @dev Basic version of StandardToken, with no allowances.
195  */
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) balances;
200 
201   /**
202   * @dev transfer token for a specified address
203   * @param _to The address to transfer to.
204   * @param _value The amount to be transferred.
205   */
206   function transfer(address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208 
209     // SafeMath.sub will throw if there is not enough balance.
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     Transfer(msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) public constant returns (uint256 balance) {
222     return balances[_owner];
223   }
224 
225 }
226 
227 /**
228  * @title Standard ERC20 token
229  *
230  * @dev Implementation of the basic standard token.
231  * @dev https://github.com/ethereum/EIPs/issues/20
232  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  */
234 contract StandardToken is ERC20, BasicToken {
235 
236   mapping (address => mapping (address => uint256)) allowed;
237 
238 
239   /**
240    * @dev Transfer tokens from one address to another
241    * @param _from address The address which you want to send tokens from
242    * @param _to address The address which you want to transfer to
243    * @param _value uint256 the amount of tokens to be transferred
244    */
245   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
246     require(_to != address(0));
247 
248     uint256 _allowance = allowed[_from][msg.sender];
249 
250     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
251     // require (_value <= _allowance);
252 
253     balances[_from] = balances[_from].sub(_value);
254     balances[_to] = balances[_to].add(_value);
255     allowed[_from][msg.sender] = _allowance.sub(_value);
256     Transfer(_from, _to, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262    *
263    * Beware that changing an allowance with this method brings the risk that someone may use both the old
264    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267    * @param _spender The address which will spend the funds.
268    * @param _value The amount of tokens to be spent.
269    */
270   function approve(address _spender, uint256 _value) public returns (bool) {
271     allowed[msg.sender][_spender] = _value;
272     Approval(msg.sender, _spender, _value);
273     return true;
274   }
275 
276   /**
277    * @dev Function to check the amount of tokens that an owner allowed to a spender.
278    * @param _owner address The address which owns the funds.
279    * @param _spender address The address which will spend the funds.
280    * @return A uint256 specifying the amount of tokens still available for the spender.
281    */
282   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
283     return allowed[_owner][_spender];
284   }
285 
286   /**
287    * approve should be called when allowed[_spender] == 0. To increment
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    */
292   function increaseApproval (address _spender, uint _addedValue) public
293     returns (bool success) {
294     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
295     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299   function decreaseApproval (address _spender, uint _subtractedValue) public
300     returns (bool success) {
301     uint oldValue = allowed[msg.sender][_spender];
302     if (_subtractedValue > oldValue) {
303       allowed[msg.sender][_spender] = 0;
304     } else {
305       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
306     }
307     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311 }
312 
313 /**
314  * @title Mintable token
315  * @dev Simple ERC20 Token example, with mintable token creation
316  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
317  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
318  */
319 
320 contract MintableToken is StandardToken, Ownable {
321   event Mint(address indexed to, uint256 amount);
322   event MintFinished();
323 
324   bool public mintingFinished = false;
325 
326 
327   modifier canMint() {
328     require(!mintingFinished);
329     _;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
339     totalSupply = totalSupply.add(_amount);
340     balances[_to] = balances[_to].add(_amount);
341     Mint(_to, _amount);
342     Transfer(0x0, _to, _amount);
343     return true;
344   }
345 
346   /**
347    * @dev Function to stop minting new tokens.
348    * @return True if the operation was successful.
349    */
350   function finishMinting() onlyOwner public returns (bool) {
351     mintingFinished = true;
352     MintFinished();
353     return true;
354   }
355 }
356 
357 /**
358  * @title Pausable token
359  *
360  * @dev StandardToken modified with pausable transfers.
361  **/
362 
363 contract PausableToken is StandardToken, Pausable {
364 
365   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
366     return super.transfer(_to, _value);
367   }
368 
369   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
370     return super.transferFrom(_from, _to, _value);
371   }
372 
373   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
374     return super.approve(_spender, _value);
375   }
376 
377   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
378     return super.increaseApproval(_spender, _addedValue);
379   }
380 
381   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
382     return super.decreaseApproval(_spender, _subtractedValue);
383   }
384 }
385 
386 /**
387 * @dev Pre main Bitcalve BTL token ERC20 contract
388 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
389 * 
390 */
391 contract CATToken is MintableToken, PausableToken, Destructible {
392     
393     // Metadata
394     string public constant symbol = "PreCAT";
395     string public constant name = "Pre CAT Token";
396     uint8 public constant decimals = 18;
397     string public constant version = "1.0";
398 
399     /**
400     * @dev Override MintableTokenn.finishMinting() to add canMint modifier
401     */
402     function finishMinting() onlyOwner canMint public returns(bool) {
403         return super.finishMinting();
404     }
405 
406 }