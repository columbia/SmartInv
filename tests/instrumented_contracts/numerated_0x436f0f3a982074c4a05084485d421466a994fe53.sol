1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 
253 
254 
255 
256 
257 
258 /**
259  * @title Pausable
260  * @dev Base contract which allows children to implement an emergency stop mechanism.
261  */
262 contract Pausable is Ownable {
263   event Pause();
264   event Unpause();
265 
266   bool public paused = false;
267 
268 
269   /**
270    * @dev Modifier to make a function callable only when the contract is not paused.
271    */
272   modifier whenNotPaused() {
273     require(!paused);
274     _;
275   }
276 
277   /**
278    * @dev Modifier to make a function callable only when the contract is paused.
279    */
280   modifier whenPaused() {
281     require(paused);
282     _;
283   }
284 
285   /**
286    * @dev called by the owner to pause, triggers stopped state
287    */
288   function pause() onlyOwner whenNotPaused public {
289     paused = true;
290     Pause();
291   }
292 
293   /**
294    * @dev called by the owner to unpause, returns to normal state
295    */
296   function unpause() onlyOwner whenPaused public {
297     paused = false;
298     Unpause();
299   }
300 }
301 
302 
303 /**
304  * @title Whitelisted Pausable token
305  * @dev StandardToken modified with pausable transfers. Enables a whitelist to enable transfers
306  * only for certain addresses such as crowdsale contract, issuing account etc.
307  **/
308 contract WhitelistedPausableToken is StandardToken, Pausable {
309 
310   mapping(address => bool) public whitelist;
311 
312   /**
313    * @dev Reverts if the message sender requesting for transfer is not whitelisted when token
314    * transfers are paused
315    * @param _sender check transaction sender address
316    */
317   modifier whenNotPausedOrWhitelisted(address _sender) {
318     require(whitelist[_sender] || !paused);
319     _;
320   }
321 
322   /**
323    * @dev Adds single address to whitelist.
324    * @param _whitelistAddress Address to be added to the whitelist
325    */
326   function addToWhitelist(address _whitelistAddress) external onlyOwner {
327     whitelist[_whitelistAddress] = true;
328   }
329 
330   /**
331    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
332    * @param _whitelistAddresses Addresses to be added to the whitelist
333    */
334   function addManyToWhitelist(address[] _whitelistAddresses) external onlyOwner {
335     for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
336       whitelist[_whitelistAddresses[i]] = true;
337     }
338   }
339 
340   /**
341    * @dev Removes single address from whitelist.
342    * @param _whitelistAddress Address to be removed to the whitelist
343    */
344   function removeFromWhitelist(address _whitelistAddress) external onlyOwner {
345     whitelist[_whitelistAddress] = false;
346   }
347 
348   // Adding modifier to transfer/approval functions
349   function transfer(address _to, uint256 _value) public whenNotPausedOrWhitelisted(msg.sender) returns (bool) {
350     return super.transfer(_to, _value);
351   }
352 
353   function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrWhitelisted(msg.sender) returns (bool) {
354     return super.transferFrom(_from, _to, _value);
355   }
356 
357   function approve(address _spender, uint256 _value) public whenNotPausedOrWhitelisted(msg.sender) returns (bool) {
358     return super.approve(_spender, _value);
359   }
360 
361   function increaseApproval(address _spender, uint _addedValue) public whenNotPausedOrWhitelisted(msg.sender) returns (bool success) {
362     return super.increaseApproval(_spender, _addedValue);
363   }
364 
365   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPausedOrWhitelisted(msg.sender) returns (bool success) {
366     return super.decreaseApproval(_spender, _subtractedValue);
367   }
368 }
369 
370 
371 /**
372  * @title RTEToken
373  * @dev ERC20 token implementation
374  * Pausable
375  */
376 contract RTEToken is WhitelistedPausableToken {
377   string public constant name = "Rate3";
378   string public constant symbol = "RTE";
379   uint8 public constant decimals = 18;
380 
381   // 1 billion initial supply of RTE tokens
382   // Taking into account 18 decimals
383   uint256 public constant INITIAL_SUPPLY = (10 ** 9) * (10 ** 18);
384 
385   /**
386    * @dev RTEToken Constructor
387    * Mints the initial supply of tokens, this is the hard cap, no more tokens will be minted.
388    * Allocate the tokens to the foundation wallet, issuing wallet etc.
389    */
390   function RTEToken() public {
391     // Mint initial supply of tokens. All further minting of tokens is disabled
392     totalSupply_ = INITIAL_SUPPLY;
393 
394     // Transfer all initial tokens to msg.sender
395     balances[msg.sender] = INITIAL_SUPPLY;
396     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
397   }
398 }