1 pragma solidity ^0.5.2;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address private _owner;
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     constructor () internal {
17         _owner = msg.sender;
18         emit OwnershipTransferred(address(0), _owner);
19     }
20 
21     /**
22      * @return the address of the owner.
23      */
24     function owner() public view returns (address) {
25         return _owner;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(isOwner());
33         _;
34     }
35 
36     /**
37      * @return true if `msg.sender` is the owner of the contract.
38      */
39     function isOwner() public view returns (bool) {
40         return msg.sender == _owner;
41     }
42 
43     /**
44      * @dev Allows the current owner to relinquish control of the contract.
45      * It will not be possible to call the functions with the `onlyOwner`
46      * modifier anymore.
47      * @notice Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 /**
74  * @title SafeMath
75  * @dev Unsigned math operations with safety checks that revert on error.
76  */
77 library SafeMath {
78     /**
79      * @dev Multiplies two unsigned integers, reverts on overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b);
91 
92         return c;
93     }
94 
95     /**
96      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Solidity only automatically asserts when dividing by 0
100         require(b > 0);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     /**
108      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b <= a);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Adds two unsigned integers, reverts on overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a);
123 
124         return c;
125     }
126 
127     /**
128      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
129      * reverts when dividing by zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b != 0);
133         return a % b;
134     }
135 }
136 /**
137  * @title ERC20 interface
138  * @dev see https://eips.ethereum.org/EIPS/eip-20
139  */
140 interface IERC20 {
141     function transfer(address to, uint256 value) external returns (bool);
142 
143     function approve(address spender, uint256 value) external returns (bool);
144 
145     function transferFrom(address from, address to, uint256 value) external returns (bool);
146 
147     function totalSupply() external view returns (uint256);
148 
149     function balanceOf(address who) external view returns (uint256);
150 
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://eips.ethereum.org/EIPS/eip-20
163  * Originally based on code by FirstBlood:
164  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  *
166  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
167  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
168  * compliant implementations may not do it.
169  */
170 contract ERC20 is IERC20, Ownable {
171     using SafeMath for uint256;
172 
173     mapping (address => uint256) private _balances;
174 
175     mapping (address => mapping (address => uint256)) private _allowed;
176 
177     uint256 private _totalSupply;
178 
179     /**
180      * @dev Total number of tokens in existence.
181      */
182     function totalSupply() public view returns (uint256) {
183         return _totalSupply;
184     }
185 
186     /**
187      * @dev Gets the balance of the specified address.
188      * @param owner The address to query the balance of.
189      * @return A uint256 representing the amount owned by the passed address.
190      */
191     function balanceOf(address owner) public view returns (uint256) {
192         return _balances[owner];
193     }
194 
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param owner address The address which owns the funds.
198      * @param spender address The address which will spend the funds.
199      * @return A uint256 specifying the amount of tokens still available for the spender.
200      */
201     function allowance(address owner, address spender) public view returns (uint256) {
202         return _allowed[owner][spender];
203     }
204 
205     /**
206      * @dev Transfer token to a specified address.
207      * @param to The address to transfer to.
208      * @param value The amount to be transferred.
209      */
210     function transfer(address to, uint256 value) public returns (bool) {
211         _transfer(msg.sender, to, value);
212         return true;
213     }
214 
215     /**
216      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217      * Beware that changing an allowance with this method brings the risk that someone may use both the old
218      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      * @param spender The address which will spend the funds.
222      * @param value The amount of tokens to be spent.
223      */
224     function approve(address spender, uint256 value) public returns (bool) {
225         _approve(msg.sender, spender, value);
226         return true;
227     }
228 
229     /**
230      * @dev Transfer tokens from one address to another.
231      * Note that while this function emits an Approval event, this is not required as per the specification,
232      * and other compliant implementations may not emit the event.
233      * @param from address The address which you want to send tokens from
234      * @param to address The address which you want to transfer to
235      * @param value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(address from, address to, uint256 value) public returns (bool) {
238         _transfer(from, to, value);
239         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
240         return true;
241     }
242 
243     /**
244      * @dev Increase the amount of tokens that an owner allowed to a spender.
245      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * Emits an Approval event.
250      * @param spender The address which will spend the funds.
251      * @param addedValue The amount of tokens to increase the allowance by.
252      */
253     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
254         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
255         return true;
256     }
257 
258     /**
259      * @dev Decrease the amount of tokens that an owner allowed to a spender.
260      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
261      * allowed value is better to use this function to avoid 2 calls (and wait until
262      * the first transaction is mined)
263      * From MonolithDAO Token.sol
264      * Emits an Approval event.
265      * @param spender The address which will spend the funds.
266      * @param subtractedValue The amount of tokens to decrease the allowance by.
267      */
268     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
269         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
270         return true;
271     }
272 
273     /**
274      * @dev Transfer token for a specified addresses.
275      * @param from The address to transfer from.
276      * @param to The address to transfer to.
277      * @param value The amount to be transferred.
278      */
279     function _transfer(address from, address to, uint256 value) internal {
280         require(to != address(0));
281 
282         _balances[from] = _balances[from].sub(value);
283         _balances[to] = _balances[to].add(value);
284         emit Transfer(from, to, value);
285     }
286 
287     /**
288      * @dev Internal function that mints an amount of the token and assigns it to
289      * an account. This encapsulates the modification of balances such that the
290      * proper events are emitted.
291      * @param account The account that will receive the created tokens.
292      * @param value The amount that will be created.
293      */
294     function _mint(address account, uint256 value) internal {
295         require(account != address(0));
296 
297         _totalSupply = _totalSupply.add(value);
298         _balances[account] = _balances[account].add(value);
299         emit Transfer(address(0), account, value);
300     }
301 
302     /**
303      * @dev Internal function that burns an amount of the token of a given
304      * account.
305      * @param account The account whose tokens will be burnt.
306      * @param value The amount that will be burnt.
307      */
308     function _burn(address account, uint256 value) internal {
309         require(account != address(0));
310 
311         _totalSupply = _totalSupply.sub(value);
312         _balances[account] = _balances[account].sub(value);
313         emit Transfer(account, address(0), value);
314     }
315 
316     /**
317      * @dev Approve an address to spend another addresses' tokens.
318      * @param owner The address that owns the tokens.
319      * @param spender The address that will spend the tokens.
320      * @param value The number of tokens that can be spent.
321      */
322     function _approve(address owner, address spender, uint256 value) internal {
323         require(spender != address(0));
324         require(owner != address(0));
325 
326         _allowed[owner][spender] = value;
327         emit Approval(owner, spender, value);
328     }
329 
330     /**
331      * @dev Internal function that burns an amount of the token of a given
332      * account, deducting from the sender's allowance for said account. Uses the
333      * internal burn function.
334      * Emits an Approval event (reflecting the reduced allowance).
335      * @param account The account whose tokens will be burnt.
336      * @param value The amount that will be burnt.
337      */
338     function _burnFrom(address account, uint256 value) internal {
339         _burn(account, value);
340         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
341     }
342 }
343 
344 
345 /**
346  * @title ERC20Detailed token
347  * @dev The decimals are only for visualization purposes.
348  * All the operations are done using the smallest and indivisible token unit,
349  * just as on Ethereum all the operations are done in wei.
350  */
351 contract ERC20Detailed is ERC20 {
352     string constant private _name = "EZ365";
353     string constant private _symbol = "EZ365";
354     uint256 constant private _decimals = 18;
355 
356 
357     /**
358      * @return the name of the token.
359      */
360     function name() public pure returns (string memory) {
361         return _name;
362     }
363 
364     /**
365      * @return the symbol of the token.
366      */
367     function symbol() public pure returns (string memory) {
368         return _symbol;
369     }
370 
371     /**
372      * @return the number of decimals of the token.
373      */
374     function decimals() public pure returns (uint256) {
375         return _decimals;
376     }
377 }
378 contract EZ365Token is ERC20Detailed {
379     
380     uint256 public _releaseTime;
381     constructor() public {
382         uint256 totalSupply = 200000000 * (10 ** decimals()); 
383         _mint(msg.sender,totalSupply);
384         _releaseTime = block.timestamp + 365 days;
385     }
386      /**
387      * @dev Burns a specific amount of tokens.
388      * @param value The amount of token to be burned.
389      */
390     function burn(uint256 value) public {
391         _burn(msg.sender, value);
392     }
393 
394     /**
395      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
396      * @param from address The account whose tokens will be burned.
397      * @param value uint256 The amount of token to be burned.
398      */
399     function burnFrom(address from, uint256 value) public {
400         _burnFrom(from, value);
401     }
402     
403     
404     function updateReleaseTokenTime(uint256 tokenTime) public onlyOwner {
405         _releaseTime = tokenTime;
406     }
407     modifier isTokenReleased () {
408         if (isOwner()){
409            _;
410         }else{
411             require(block.timestamp >= _releaseTime);
412             _;
413         }
414     }
415     
416     function transfer(address _to, uint256 _value)  public isTokenReleased returns (bool)  {
417         super.transfer(_to,_value);
418     }
419 
420    function transferFrom(address _from, address _to, uint256 _value) public isTokenReleased returns (bool) {
421       super.transferFrom(_from, _to, _value);
422     }
423 
424 
425    function increaseAllowance(address _spender, uint _addedValue) public isTokenReleased returns (bool) {
426       super.increaseAllowance(_spender, _addedValue);
427     }
428 
429    function decreaseAllowance(address _spender, uint _subtractedValue) public isTokenReleased returns (bool) {
430      super.decreaseAllowance(_spender, _subtractedValue);
431     }
432 }