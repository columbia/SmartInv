1 pragma solidity ^0.5.0;
2 
3 /**
4  * @notes All the credits go to the fantastic OpenZeppelin project and its community, see 
5 
6 https://github.com/OpenZeppelin/openzeppelin-solidity
7  * This contract was generated and deployed using https://tokens.kawatta.com
8  */
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://eips.ethereum.org/EIPS/eip-20
13  */
14 interface IERC20 {
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address who) external view returns (uint256);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error.
35  */
36 library SafeMath {
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater 
39 
40 than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 }
59 
60 /**
61  * @title Standard ERC20 token
62  *
63  * @dev Implementation of the basic standard token.
64  * https://eips.ethereum.org/EIPS/eip-20
65  * Originally based on code by FirstBlood:
66  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
67  *
68  * This implementation emits additional Approval events, allowing applications to reconstruct the 
69 
70 allowance status for
71  * all accounts just by listening to said events. Note that this isn't required by the 
72 
73 specification, and other
74  * compliant implementations may not do it.
75  */
76 contract ERC20 is IERC20 {
77     using SafeMath for uint256;
78 
79     mapping (address => uint256) private _balances;
80 
81     mapping (address => mapping (address => uint256)) private _allowances;
82 
83     uint256 private _totalSupply;
84 
85     /**
86      * @dev Total number of tokens in existence.
87      */
88     function totalSupply() public view returns (uint256) {
89         return _totalSupply;
90     }
91 
92     /**
93      * @dev Gets the balance of the specified address.
94      * @param owner The address to query the balance of.
95      * @return A uint256 representing the amount owned by the passed address.
96      */
97     function balanceOf(address owner) public view returns (uint256) {
98         return _balances[owner];
99     }
100 
101     /**
102      * @dev Function to check the amount of tokens that an owner allowed to a spender.
103      * @param owner address The address which owns the funds.
104      * @param spender address The address which will spend the funds.
105      * @return A uint256 specifying the amount of tokens still available for the spender.
106      */
107     function allowance(address owner, address spender) public view returns (uint256) {
108         return _allowances[owner][spender];
109     }
110 
111     /**
112      * @dev Transfer token to a specified address.
113      * @param to The address to transfer to.
114      * @param value The amount to be transferred.
115      */
116     function transfer(address to, uint256 value) public returns (bool) {
117         _transfer(msg.sender, to, value);
118         return true;
119     }
120 
121     /**
122      * @dev Approve the passed address to spend the specified amount of tokens on behalf of 
123 
124 msg.sender.
125      * Beware that changing an allowance with this method brings the risk that someone may use 
126 
127 both the old
128      * and the new allowance by unfortunate transaction ordering. One possible solution to 
129 
130 mitigate this
131      * race condition is to first reduce the spender's allowance to 0 and set the desired value 
132 
133 afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      * @param spender The address which will spend the funds.
136      * @param value The amount of tokens to be spent.
137      */
138     function approve(address spender, uint256 value) public returns (bool) {
139         _approve(msg.sender, spender, value);
140         return true;
141     }
142 
143     /**
144      * @dev Transfer tokens from one address to another.
145      * Note that while this function emits an Approval event, this is not required as per the 
146 
147 specification,
148      * and other compliant implementations may not emit the event.
149      * @param from address The address which you want to send tokens from
150      * @param to address The address which you want to transfer to
151      * @param value uint256 the amount of tokens to be transferred
152      */
153     function transferFrom(address from, address to, uint256 value) public returns (bool) {
154         _transfer(from, to, value);
155         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
156         return true;
157     }
158 
159     /**
160      * @dev Increase the amount of tokens that an owner allowed to a spender.
161      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
162      * allowed value is better to use this function to avoid 2 calls (and wait until
163      * the first transaction is mined)
164      * From MonolithDAO Token.sol
165      * Emits an Approval event.
166      * @param spender The address which will spend the funds.
167      * @param addedValue The amount of tokens to increase the allowance by.
168      */
169     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
170         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
171         return true;
172     }
173 
174     /**
175      * @dev Decrease the amount of tokens that an owner allowed to a spender.
176      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param subtractedValue The amount of tokens to decrease the allowance by.
183      */
184     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
186         return true;
187     }
188 
189     /**
190      * @dev Transfer token for a specified addresses.
191      * @param from The address to transfer from.
192      * @param to The address to transfer to.
193      * @param value The amount to be transferred.
194      */
195     function _transfer(address from, address to, uint256 value) internal {
196         require(to != address(0), "ERC20: transfer to the zero address");
197 
198         _balances[from] = _balances[from].sub(value);
199         _balances[to] = _balances[to].add(value);
200         emit Transfer(from, to, value);
201     }
202 
203     /**
204      * @dev Internal function that mints an amount of the token and assigns it to
205      * an account. This encapsulates the modification of balances such that the
206      * proper events are emitted.
207      * @param account The account that will receive the created tokens.
208      * @param value The amount that will be created.
209      */
210     function _mint(address account, uint256 value) internal {
211         require(account != address(0), "ERC20: mint to the zero address");
212 
213         _totalSupply = _totalSupply.add(value);
214         _balances[account] = _balances[account].add(value);
215         emit Transfer(address(0), account, value);
216     }
217 
218     /**
219      * @dev Internal function that burns an amount of the token of a given
220      * account.
221      * @param account The account whose tokens will be burnt.
222      * @param value The amount that will be burnt.
223      */
224     function _burn(address account, uint256 value) internal {
225         require(account != address(0), "ERC20: burn from the zero address");
226 
227         _totalSupply = _totalSupply.sub(value);
228         _balances[account] = _balances[account].sub(value);
229         emit Transfer(account, address(0), value);
230     }
231 
232     /**
233      * @dev Approve an address to spend another addresses' tokens.
234      * @param owner The address that owns the tokens.
235      * @param spender The address that will spend the tokens.
236      * @param value The number of tokens that can be spent.
237      */
238     function _approve(address owner, address spender, uint256 value) internal {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241 
242         _allowances[owner][spender] = value;
243         emit Approval(owner, spender, value);
244     }
245 
246     /**
247      * @dev Internal function that burns an amount of the token of a given
248      * account, deducting from the sender's allowance for said account. Uses the
249      * internal burn function.
250      * Emits an Approval event (reflecting the reduced allowance).
251      * @param account The account whose tokens will be burnt.
252      * @param value The amount that will be burnt.
253      */
254     function _burnFrom(address account, uint256 value) internal {
255         _burn(account, value);
256         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
257     }
258 }
259 
260 
261 
262 /**
263  * @title Ownable
264  * @dev The Ownable contract has an owner address, and provides basic authorization control
265  * functions, this simplifies the implementation of "user permissions".
266  */
267 contract Ownable {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
274      * account.
275      */
276     constructor () internal {
277         _owner = msg.sender;
278         emit OwnershipTransferred(address(0), _owner);
279     }
280 
281     /**
282      * @return the address of the owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(isOwner(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @return true if `msg.sender` is the owner of the contract.
298      */
299     function isOwner() public view returns (bool) {
300         return msg.sender == _owner;
301     }
302 
303     /**
304      * @dev Allows the current owner to relinquish control of the contract.
305      * It will not be possible to call the functions with the `onlyOwner`
306      * modifier anymore.
307      * @notice Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     /**
316      * @dev Allows the current owner to transfer control of the contract to a newOwner.
317      * @param newOwner The address to transfer ownership to.
318      */
319     function transferOwnership(address newOwner) public onlyOwner {
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers control of the contract to a newOwner.
325      * @param newOwner The address to transfer ownership to.
326      */
327     function _transferOwnership(address newOwner) internal {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 
335 
336 /**
337  * @title ERC20Detailed token
338  * @dev The decimals are only for visualization purposes.
339  * All the operations are done using the smallest and indivisible token unit,
340  * just as on Ethereum all the operations are done in wei.
341  */
342 contract ERC20Detailed is IERC20 {
343     string private _name;
344     string private _symbol;
345     uint8 private _decimals;
346 
347     constructor (string memory name, string memory symbol, uint8 decimals) public {
348         _name = name;
349         _symbol = symbol;
350         _decimals = decimals;
351     }
352 
353     /**
354      * @return the name of the token.
355      */
356     function name() public view returns (string memory) {
357         return _name;
358     }
359 
360     /**
361      * @return the symbol of the token.
362      */
363     function symbol() public view returns (string memory) {
364         return _symbol;
365     }
366 
367     /**
368      * @return the number of decimals of the token.
369      */
370     function decimals() public view returns (uint8) {
371         return _decimals;
372     }
373 }
374 
375 /**
376  * @title ERC20 token contract of 777 COIN
377  */
378 contract ERC20Token is ERC20, ERC20Detailed, Ownable {
379   uint8 public constant DECIMALS = 18;
380   uint256 public constant INITIAL_SUPPLY = 9000000000000000000 * (10 ** uint256(DECIMALS));
381 
382   /**
383     * @dev Constructor that gives msg.sender all of existing tokens.
384     */
385   constructor () public ERC20Detailed("777 COIN", "777", DECIMALS) {
386       _mint(msg.sender, INITIAL_SUPPLY);
387   }
388 }