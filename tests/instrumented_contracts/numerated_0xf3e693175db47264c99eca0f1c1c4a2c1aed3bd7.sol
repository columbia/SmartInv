1 pragma solidity ^0.4.13;
2 
3 library AddressUtils {
4 
5   /**
6    * Returns whether the target address is a contract
7    * @dev This function will return false if invoked during the constructor of a contract,
8    *  as the code is not actually created until after the constructor finishes.
9    * @param addr address to check
10    * @return whether the target address is a contract
11    */
12   function isContract(address addr) internal view returns (bool) {
13     uint256 size;
14     // XXX Currently there is no better way to check if there is a contract in an address
15     // than to check the size of the code at that address.
16     // See https://ethereum.stackexchange.com/a/14016/36603
17     // for more details about how this works.
18     // TODO Check this again before the Serenity release, because all addresses will be
19     // contracts then.
20     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
21     return size > 0;
22   }
23 
24 }
25 
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     if (a == 0) {
33       return 0;
34     }
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return a / b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
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
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     emit OwnershipTransferred(owner, newOwner);
98     owner = newOwner;
99   }
100 
101 }
102 
103 contract Pausable is Ownable {
104   event Pause();
105   event Unpause();
106 
107   bool public paused = false;
108 
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is not paused.
112    */
113   modifier whenNotPaused() {
114     require(!paused);
115     _;
116   }
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is paused.
120    */
121   modifier whenPaused() {
122     require(paused);
123     _;
124   }
125 
126   /**
127    * @dev called by the owner to pause, triggers stopped state
128    */
129   function pause() onlyOwner whenNotPaused public {
130     paused = true;
131     emit Pause();
132   }
133 
134   /**
135    * @dev called by the owner to unpause, returns to normal state
136    */
137   function unpause() onlyOwner whenPaused public {
138     paused = false;
139     emit Unpause();
140   }
141 }
142 
143 contract ERC20Basic {
144   function totalSupply() public view returns (uint256);
145   function balanceOf(address who) public view returns (uint256);
146   function transfer(address to, uint256 value) public returns (bool);
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   uint256 totalSupply_;
156 
157   /**
158   * @dev total number of tokens in existence
159   */
160   function totalSupply() public view returns (uint256) {
161     return totalSupply_;
162   }
163 
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[msg.sender]);
172 
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     emit Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 contract ERC20 is ERC20Basic {
191   function allowance(address owner, address spender) public view returns (uint256);
192   function transferFrom(address from, address to, uint256 value) public returns (bool);
193   function approve(address spender, uint256 value) public returns (bool);
194   event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     emit Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
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
285 contract MintableToken is StandardToken, Ownable {
286   event Mint(address indexed to, uint256 amount);
287   event MintFinished();
288 
289   bool public mintingFinished = false;
290 
291 
292   modifier canMint() {
293     require(!mintingFinished);
294     _;
295   }
296 
297   /**
298    * @dev Function to mint tokens
299    * @param _to The address that will receive the minted tokens.
300    * @param _amount The amount of tokens to mint.
301    * @return A boolean that indicates if the operation was successful.
302    */
303   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
304     totalSupply_ = totalSupply_.add(_amount);
305     balances[_to] = balances[_to].add(_amount);
306     emit Mint(_to, _amount);
307     emit Transfer(address(0), _to, _amount);
308     return true;
309   }
310 
311   /**
312    * @dev Function to stop minting new tokens.
313    * @return True if the operation was successful.
314    */
315   function finishMinting() onlyOwner canMint public returns (bool) {
316     mintingFinished = true;
317     emit MintFinished();
318     return true;
319   }
320 }
321 
322 contract PausableToken is StandardToken, Pausable {
323 
324   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
325     return super.transfer(_to, _value);
326   }
327 
328   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
329     return super.transferFrom(_from, _to, _value);
330   }
331 
332   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
333     return super.approve(_spender, _value);
334   }
335 
336   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
337     return super.increaseApproval(_spender, _addedValue);
338   }
339 
340   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
341     return super.decreaseApproval(_spender, _subtractedValue);
342   }
343 }
344 
345 contract TokenReceiver {
346   function onTokenReceived(address _from, uint256 _value, bytes _data) public returns(bytes4);
347 }
348 
349 contract TVToken is PausableToken, MintableToken {
350   using AddressUtils for address;
351   string public name = 'TV Token';
352   string public symbol = 'TV';
353   uint8 public decimals = 18;
354   bytes4 constant TOKEN_RECEIVED = bytes4(keccak256("onTokenReceived(address,uint256,bytes)"));
355 
356   constructor() public {}
357 
358   function revertFunds(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
359     require(_to != address(0));
360     require(_value <= balances[_from]);
361 
362     balances[_from] = balances[_from].sub(_value);
363     balances[_to] = balances[_to].add(_value);
364     Transfer(_from, _to, _value);
365     return true;
366   }
367 
368   function safeTransfer(address _to, uint256 _value, bytes _data) public {
369     super.transfer(_to, _value);
370     require(checkAndCallSafeTransfer(msg.sender, _to, _value, _data));
371   }
372 
373   function safeTransferFrom(address _from, address _to, uint256 _value, bytes _data) public {
374     super.transferFrom(_from, _to, _value);
375     require(checkAndCallSafeTransfer(_from, _to, _value, _data));
376   }
377 
378   function checkAndCallSafeTransfer(address _from, address _to, uint256 _value, bytes _data) internal returns (bool) {
379     if (!_to.isContract()) {
380       return true;
381     }
382     bytes4 retval = TokenReceiver(_to).onTokenReceived(_from, _value, _data);
383     return (retval == TOKEN_RECEIVED);
384   }
385 }