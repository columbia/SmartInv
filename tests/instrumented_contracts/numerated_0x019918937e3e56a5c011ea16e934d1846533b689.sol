1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address who) external view returns (uint256);
10     function allowance(address owner, address spender) external view returns (uint256);
11     
12     function transfer(address to, uint256 value) external returns (bool);
13     function approve(address spender, uint256 value) external returns (bool);
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that revert on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, reverts on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (a == 0) {
34       return 0;
35     }
36 
37     uint256 c = a * b;
38     require(c / a == b);
39 
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     require(b > 0); // Solidity only automatically asserts when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51     return c;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b <= a);
59     uint256 c = a - b;
60 
61     return c;
62   }
63 
64   /**
65   * @dev Adds two numbers, reverts on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     require(c >= a);
70 
71     return c;
72   }
73 
74   /**
75   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
76   * reverts when dividing by zero.
77   */
78   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b != 0);
80     return a % b;
81   }
82 }
83 
84 /**
85  * @title Standard ERC20 token
86  *
87  * @dev Implementation of the basic standard token.
88  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
89  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
90  *
91  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
92  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
93  * compliant implementations may not do it.
94  */
95 contract ERC20 is IERC20 {
96     using SafeMath for uint256;
97 
98     mapping (address => uint256) private _balances;
99 
100     mapping (address => mapping (address => uint256)) private _allowed;
101 
102     uint256 private _totalSupply;
103 
104     /**
105     * @dev Total number of tokens in existence
106     */
107     function totalSupply() public view returns (uint256) {
108         return _totalSupply;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param owner The address to query the balance of.
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address owner) public view returns (uint256) {
117         return _balances[owner];
118     }
119 
120     /**
121      * @dev Function to check the amount of tokens that an owner allowed to a spender.
122      * @param owner address The address which owns the funds.
123      * @param spender address The address which will spend the funds.
124      * @return A uint256 specifying the amount of tokens still available for the spender.
125      */
126     function allowance(address owner, address spender) public view returns (uint256) {
127         return _allowed[owner][spender];
128     }
129 
130     /**
131     * @dev Transfer token for a specified address
132     * @param to The address to transfer to.
133     * @param value The amount to be transferred.
134     */
135     function transfer(address to, uint256 value) public returns (bool) {
136         _transfer(msg.sender, to, value);
137         return true;
138     }
139 
140     /**
141      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142      * Beware that changing an allowance with this method brings the risk that someone may use both the old
143      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      * @param spender The address which will spend the funds.
147      * @param value The amount of tokens to be spent.
148      */
149     function approve(address spender, uint256 value) public returns (bool) {
150         require(spender != address(0));
151 
152         _allowed[msg.sender][spender] = value;
153         emit Approval(msg.sender, spender, value);
154         return true;
155     }
156 
157     /**
158      * @dev Transfer tokens from one address to another.
159      * Note that while this function emits an Approval event, this is not required as per the specification,
160      * and other compliant implementations may not emit the event.
161      * @param from address The address which you want to send tokens from
162      * @param to address The address which you want to transfer to
163      * @param value uint256 the amount of tokens to be transferred
164      */
165     function transferFrom(address from, address to, uint256 value) public returns (bool) {
166         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
167         _transfer(from, to, value);
168         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
169         return true;
170     }
171 
172     /**
173      * @dev Increase the amount of tokens that an owner allowed to a spender.
174      * approve should be called when allowed_[_spender] == 0. To increment
175      * allowed value is better to use this function to avoid 2 calls (and wait until
176      * the first transaction is mined)
177      * From MonolithDAO Token.sol
178      * Emits an Approval event.
179      * @param spender The address which will spend the funds.
180      * @param addedValue The amount of tokens to increase the allowance by.
181      */
182     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
183         require(spender != address(0));
184 
185         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
186         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
187         return true;
188     }
189 
190     /**
191      * @dev Decrease the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To decrement
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param subtractedValue The amount of tokens to decrease the allowance by.
199      */
200     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209     * @dev Transfer token for a specified addresses
210     * @param from The address to transfer from.
211     * @param to The address to transfer to.
212     * @param value The amount to be transferred.
213     */
214     function _transfer(address from, address to, uint256 value) internal {
215         require(to != address(0));
216 
217         _balances[from] = _balances[from].sub(value);
218         _balances[to] = _balances[to].add(value);
219         emit Transfer(from, to, value);
220     }
221 
222     /**
223      * @dev Internal function that mints an amount of the token and assigns it to
224      * an account. This encapsulates the modification of balances such that the
225      * proper events are emitted.
226      * @param account The account that will receive the created tokens.
227      * @param value The amount that will be created.
228      */
229     function _mint(address account, uint256 value) internal {
230         require(account != address(0));
231 
232         _totalSupply = _totalSupply.add(value);
233         _balances[account] = _balances[account].add(value);
234         emit Transfer(address(0), account, value);
235     }
236 
237     /**
238      * @dev Internal function that burns an amount of the token of a given
239      * account.
240      * @param account The account whose tokens will be burnt.
241      * @param value The amount that will be burnt.
242      */
243     function _burn(address account, uint256 value) internal {
244         require(account != address(0));
245 
246         _totalSupply = _totalSupply.sub(value);
247         _balances[account] = _balances[account].sub(value);
248         emit Transfer(account, address(0), value);
249     }
250 
251     /**
252      * @dev Internal function that burns an amount of the token of a given
253      * account, deducting from the sender's allowance for said account. Uses the
254      * internal burn function.
255      * Emits an Approval event (reflecting the reduced allowance).
256      * @param account The account whose tokens will be burnt.
257      * @param value The amount that will be burnt.
258      */
259     function _burnFrom(address account, uint256 value) internal {
260         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
261         _burn(account, value);
262         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
263     }
264 }
265 
266 /**
267  * @title ERC20Detailed token
268  * @dev The decimals are only for visualization purposes.
269  * All the operations are done using the smallest and indivisible token unit,
270  * just as on Ethereum all the operations are done in wei.
271  */
272 contract ERC20Detailed is ERC20 {
273     string private _name;
274     string private _symbol;
275     uint8 private _decimals;
276 
277     constructor (string name, string symbol, uint8 decimals) public {
278         _name = name;
279         _symbol = symbol;
280         _decimals = decimals;
281     }
282 
283     /**
284      * @return the name of the token.
285      */
286     function name() public view returns (string) {
287         return _name;
288     }
289 
290     /**
291      * @return the symbol of the token.
292      */
293     function symbol() public view returns (string) {
294         return _symbol;
295     }
296 
297     /**
298      * @return the number of decimals of the token.
299      */
300     function decimals() public view returns (uint8) {
301         return _decimals;
302     }
303 }
304 
305 /**
306  * @title Ownable
307  * @dev The Ownable contract has an owner address, and provides basic authorization control
308  * functions, this simplifies the implementation of "user permissions". Modified from Open
309  * Zeppelin.
310  */
311 contract Ownable {
312   address private _owner;
313 
314   /**
315    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
316    * account.
317    */
318   constructor() public {
319     _owner = msg.sender;
320   }
321 
322   /**
323    * @return the address of the owner.
324    */
325   function owner() public view returns(address) {
326     return _owner;
327   }
328 
329   /**
330    * @dev Throws if called by any account other than the owner.
331    */
332   modifier onlyOwner() {
333     require(isOwner());
334     _;
335   }
336 
337   /**
338    * @return true if `msg.sender` is the owner of the contract.
339    */
340   function isOwner() public view returns(bool) {
341     return msg.sender == _owner;
342   }
343 
344   /**
345    * @dev Allows the current owner to transfer control of the contract to a newOwner.
346    * @param newOwner The address to transfer ownership to.
347    */
348   function transferOwnership(address newOwner) public onlyOwner {
349     require(newOwner != address(0));
350     _owner = newOwner;
351   }
352 }
353 
354 interface TransferAndCallFallBack {
355     function tokenFallback(address _from, 
356                            uint    _value, 
357                            bytes   _data) external returns (bool);
358 }
359 
360 interface ApproveAndCallFallBack {
361     function receiveApproval(address _owner, 
362                              uint256 _value, 
363                              bytes   _data) external returns (bool);
364 }
365 
366 contract AudioToken is ERC20Detailed, Ownable {
367     
368     uint256 public constant INITIAL_SUPPLY = 1500000000e18;
369 
370     /**
371     * @dev fixed supply of tokens.
372     */
373     constructor() public ERC20Detailed("AUDIO Token", "AUDIO", 18) {
374         _mint(owner(), INITIAL_SUPPLY);
375     }
376     
377     /**
378     * @dev transfers _value tokens to a contract at address _to and calls the function 
379     * tokenFallback(address, uint256, bytes) on that contract.
380     */
381     function transferAndCall(address _to, 
382                              uint    _value, 
383                              bytes   _data) public returns (bool) {
384         require(_to != address(this));
385 
386         transfer(_to, _value);
387     
388         require(TransferAndCallFallBack(_to).tokenFallback(
389             msg.sender, 
390             _value,
391             _data
392         ));
393         
394         return true;
395     }
396     
397     /**
398     * @dev transfers _value tokens from address _from to a contract 
399     * at address _to and calls the function tokenFallback(address, uint256, bytes) 
400     * on that contract.
401     */
402     function transferFromAndCall(address _from,
403                                  address _to, 
404                                  uint    _value, 
405                                  bytes   _data) public returns (bool) {
406         require(_to != address(this));
407 
408         transferFrom(_from, _to, _value);
409     
410         require(TransferAndCallFallBack(_to).tokenFallback(
411             _from, 
412             _value, 
413             _data
414         ));
415         
416         return true;
417     }
418     
419     /**
420     * @dev approves _value tokens to be transfered to a contract _spender
421     * and calls the function receiveApproval(address, uint256, bytes) 
422     * on that contract. Requires current approval to be 0 to avoid double spending.
423     */
424     function approveAndCall(address _spender, 
425                             uint    _value, 
426                             bytes   _data) public returns (bool) {
427         require(_spender != address(this));
428         require(_value == 0 || allowance(msg.sender, _spender) == 0);
429         
430         approve(_spender, _value);
431         
432         require(ApproveAndCallFallBack(_spender).receiveApproval(
433             msg.sender, 
434             _value,
435             _data
436         ));
437 
438         return true;
439     }
440     
441     /**
442     * @dev recover any mistakenly sent ERC-20 tokens (also works for ERC-721 tokens).
443     */
444     function recoverTokens(address _token, uint256 _value) onlyOwner public returns (bool) {
445         IERC20 erc20 = IERC20(_token);
446         return erc20.transfer(owner(), _value);
447     }
448     
449     /**
450     * @dev recover any mistakenly sent ETH.
451     */
452     function recoverEther() onlyOwner public {
453         owner().transfer(address(this).balance);
454     }
455 }