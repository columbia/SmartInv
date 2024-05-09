1 pragma solidity ^0.5.10;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      * @notice Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 /**
76  * @title SafeMath
77  * @dev Unsigned math operations with safety checks that revert on error.
78  */
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b);
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a);
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0);
135         return a % b;
136     }
137 }
138 /**
139  * @title ERC20 interface
140  * @dev see https://eips.ethereum.org/EIPS/eip-20
141  */
142 interface IERC20 {
143     function transfer(address to, uint256 value) external returns (bool);
144 
145     function approve(address spender, uint256 value) external returns (bool);
146 
147     function transferFrom(address from, address to, uint256 value) external returns (bool);
148 
149     function totalSupply() external view returns (uint256);
150 
151     function balanceOf(address who) external view returns (uint256);
152 
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * https://eips.ethereum.org/EIPS/eip-20
165  * Originally based on code by FirstBlood:
166  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  *
168  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
169  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
170  * compliant implementations may not do it.
171  */
172 contract ERC20 is IERC20, Ownable {
173     using SafeMath for uint256;
174 
175     mapping (address => uint256) private _balances;
176 
177     mapping (address => mapping (address => uint256)) private _allowed;
178 
179     uint256 private _totalSupply;
180 
181     /**
182      * @dev Total number of tokens in existence.
183      */
184     function totalSupply() public view returns (uint256) {
185         return _totalSupply;
186     }
187 
188     /**
189      * @dev Gets the balance of the specified address.
190      * @param owner The address to query the balance of.
191      * @return A uint256 representing the amount owned by the passed address.
192      */
193     function balanceOf(address owner) public view returns (uint256) {
194         return _balances[owner];
195     }
196 
197     /**
198      * @dev Function to check the amount of tokens that an owner allowed to a spender.
199      * @param owner address The address which owns the funds.
200      * @param spender address The address which will spend the funds.
201      * @return A uint256 specifying the amount of tokens still available for the spender.
202      */
203     function allowance(address owner, address spender) public view returns (uint256) {
204         return _allowed[owner][spender];
205     }
206 
207     /**
208      * @dev Transfer token to a specified address.
209      * @param to The address to transfer to.
210      * @param value The amount to be transferred.
211      */
212     function transfer(address to, uint256 value) public returns (bool) {
213         _transfer(msg.sender, to, value);
214         return true;
215     }
216 
217     /**
218      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param spender The address which will spend the funds.
224      * @param value The amount of tokens to be spent.
225      */
226     function approve(address spender, uint256 value) public returns (bool) {
227         _approve(msg.sender, spender, value);
228         return true;
229     }
230 
231     /**
232      * @dev Transfer tokens from one address to another.
233      * Note that while this function emits an Approval event, this is not required as per the specification,
234      * and other compliant implementations may not emit the event.
235      * @param from address The address which you want to send tokens from
236      * @param to address The address which you want to transfer to
237      * @param value uint256 the amount of tokens to be transferred
238      */
239     function transferFrom(address from, address to, uint256 value) public returns (bool) {
240         _transfer(from, to, value);
241         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
242         return true;
243     }
244 
245     /**
246      * @dev Increase the amount of tokens that an owner allowed to a spender.
247      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * Emits an Approval event.
252      * @param spender The address which will spend the funds.
253      * @param addedValue The amount of tokens to increase the allowance by.
254      */
255     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
256         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
257         return true;
258     }
259 
260     /**
261      * @dev Decrease the amount of tokens that an owner allowed to a spender.
262      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
263      * allowed value is better to use this function to avoid 2 calls (and wait until
264      * the first transaction is mined)
265      * From MonolithDAO Token.sol
266      * Emits an Approval event.
267      * @param spender The address which will spend the funds.
268      * @param subtractedValue The amount of tokens to decrease the allowance by.
269      */
270     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
271         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
272         return true;
273     }
274 
275     /**
276      * @dev Transfer token for a specified addresses.
277      * @param from The address to transfer from.
278      * @param to The address to transfer to.
279      * @param value The amount to be transferred.
280      */
281     function _transfer(address from, address to, uint256 value) internal {
282         require(to != address(0));
283 
284         _balances[from] = _balances[from].sub(value);
285         _balances[to] = _balances[to].add(value);
286         emit Transfer(from, to, value);
287     }
288 
289     /**
290      * @dev Internal function that mints an amount of the token and assigns it to
291      * an account. This encapsulates the modification of balances such that the
292      * proper events are emitted.
293      * @param account The account that will receive the created tokens.
294      * @param value The amount that will be created.
295      */
296     function _mint(address account, uint256 value) internal {
297         require(account != address(0));
298 
299         _totalSupply = _totalSupply.add(value);
300         _balances[account] = _balances[account].add(value);
301         emit Transfer(address(0), account, value);
302     }
303 
304     /**
305      * @dev Internal function that burns an amount of the token of a given
306      * account.
307      * @param account The account whose tokens will be burnt.
308      * @param value The amount that will be burnt.
309      */
310     function _burn(address account, uint256 value) internal {
311         require(account != address(0));
312 
313         _totalSupply = _totalSupply.sub(value);
314         _balances[account] = _balances[account].sub(value);
315         emit Transfer(account, address(0), value);
316     }
317 
318     /**
319      * @dev Approve an address to spend another addresses' tokens.
320      * @param owner The address that owns the tokens.
321      * @param spender The address that will spend the tokens.
322      * @param value The number of tokens that can be spent.
323      */
324     function _approve(address owner, address spender, uint256 value) internal {
325         require(spender != address(0));
326         require(owner != address(0));
327 
328         _allowed[owner][spender] = value;
329         emit Approval(owner, spender, value);
330     }
331 
332     /**
333      * @dev Internal function that burns an amount of the token of a given
334      * account, deducting from the sender's allowance for said account. Uses the
335      * internal burn function.
336      * Emits an Approval event (reflecting the reduced allowance).
337      * @param account The account whose tokens will be burnt.
338      * @param value The amount that will be burnt.
339      */
340     function _burnFrom(address account, uint256 value) internal {
341         _burn(account, value);
342         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
343     }
344 }
345 
346 
347 /**
348  * @title ERC20Detailed token
349  * @dev The decimals are only for visualization purposes.
350  * All the operations are done using the smallest and indivisible token unit,
351  * just as on Ethereum all the operations are done in wei.
352  */
353 contract ERC20Detailed is ERC20 {
354     string constant private _name = "INGRAM";
355     string constant private _symbol = "INGRAM";
356     uint256 constant private _decimals = 18;
357 
358 
359     /**
360      * @return the name of the token.
361      */
362     function name() public pure returns (string memory) {
363         return _name;
364     }
365 
366     /**
367      * @return the symbol of the token.
368      */
369     function symbol() public pure returns (string memory) {
370         return _symbol;
371     }
372 
373     /**
374      * @return the number of decimals of the token.
375      */
376     function decimals() public pure returns (uint256) {
377         return _decimals;
378     }
379 }
380 contract Token is ERC20Detailed {
381     
382     uint256 public _releaseTime;
383     constructor() public {
384         uint256 totalSupply = 21300000000 * (10 ** decimals()); 
385         _mint(msg.sender,totalSupply);
386     }
387      /**
388      * @dev Burns a specific amount of tokens.
389      * @param value The amount of token to be burned.
390      */
391     function burn(uint256 value) public {
392         _burn(msg.sender, value);
393     }
394 
395     /**
396      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
397      * @param from address The account whose tokens will be burned.
398      * @param value uint256 The amount of token to be burned.
399      */
400     function burnFrom(address from, uint256 value) public {
401         _burnFrom(from, value);
402     }
403     
404     
405 
406 }