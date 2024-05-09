1 pragma solidity ^0.5.0;
2 
3 /**
4  * @notes ERC20 token for RANLYTICS Fund raising. Each token represents 1 share in RANLYTICS HOLDING Company
5  */
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://eips.ethereum.org/EIPS/eip-20
10  */
11 interface IERC20 {
12     function transfer(address to, uint256 value) external returns (bool);
13 
14     function approve(address spender, uint256 value) external returns (bool);
15 
16     function transferFrom(address from, address to, uint256 value) external returns (bool);
17 
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address who) external view returns (uint256);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error.
32  */
33 library SafeMath {
34     /**
35      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36      */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a, "SafeMath: subtraction overflow");
39         uint256 c = a - b;
40 
41         return c;
42     }
43 
44     /**
45      * @dev Adds two unsigned integers, reverts on overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 }
54 
55 /**
56  * @title Standard ERC20 token
57  *
58  * @dev Implementation of the basic standard token.
59  * https://eips.ethereum.org/EIPS/eip-20
60  * Originally based on code by FirstBlood:
61  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
62  *
63  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
64  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
65  * compliant implementations may not do it.
66  */
67 contract ERC20 is IERC20 {
68     using SafeMath for uint256;
69 
70     mapping (address => uint256) private _balances;
71 
72     mapping (address => mapping (address => uint256)) private _allowances;
73 
74     uint256 private _totalSupply;
75 
76     /**
77      * @dev Total number of tokens in existence.
78      */
79     function totalSupply() public view returns (uint256) {
80         return _totalSupply;
81     }
82 
83     /**
84      * @dev Gets the balance of the specified address.
85      * @param owner The address to query the balance of.
86      * @return A uint256 representing the amount owned by the passed address.
87      */
88     function balanceOf(address owner) public view returns (uint256) {
89         return _balances[owner];
90     }
91 
92     /**
93      * @dev Function to check the amount of tokens that an owner allowed to a spender.
94      * @param owner address The address which owns the funds.
95      * @param spender address The address which will spend the funds.
96      * @return A uint256 specifying the amount of tokens still available for the spender.
97      */
98     function allowance(address owner, address spender) public view returns (uint256) {
99         return _allowances[owner][spender];
100     }
101 
102     /**
103      * @dev Transfer token to a specified address.
104      * @param to The address to transfer to.
105      * @param value The amount to be transferred.
106      */
107     function transfer(address to, uint256 value) public returns (bool) {
108         _transfer(msg.sender, to, value);
109         return true;
110     }
111 
112     /**
113      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
114      * Beware that changing an allowance with this method brings the risk that someone may use both the old
115      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
116      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      * @param spender The address which will spend the funds.
119      * @param value The amount of tokens to be spent.
120      */
121     function approve(address spender, uint256 value) public returns (bool) {
122         _approve(msg.sender, spender, value);
123         return true;
124     }
125 
126     /**
127      * @dev Transfer tokens from one address to another.
128      * Note that while this function emits an Approval event, this is not required as per the specification,
129      * and other compliant implementations may not emit the event.
130      * @param from address The address which you want to send tokens from
131      * @param to address The address which you want to transfer to
132      * @param value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address from, address to, uint256 value) public returns (bool) {
135         _transfer(from, to, value);
136         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
137         return true;
138     }
139 
140     /**
141      * @dev Increase the amount of tokens that an owner allowed to a spender.
142      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
143      * allowed value is better to use this function to avoid 2 calls (and wait until
144      * the first transaction is mined)
145      * From MonolithDAO Token.sol
146      * Emits an Approval event.
147      * @param spender The address which will spend the funds.
148      * @param addedValue The amount of tokens to increase the allowance by.
149      */
150     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
151         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
152         return true;
153     }
154 
155     /**
156      * @dev Decrease the amount of tokens that an owner allowed to a spender.
157      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
158      * allowed value is better to use this function to avoid 2 calls (and wait until
159      * the first transaction is mined)
160      * From MonolithDAO Token.sol
161      * Emits an Approval event.
162      * @param spender The address which will spend the funds.
163      * @param subtractedValue The amount of tokens to decrease the allowance by.
164      */
165     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
166         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
167         return true;
168     }
169 
170     /**
171      * @dev Transfer token for a specified addresses.
172      * @param from The address to transfer from.
173      * @param to The address to transfer to.
174      * @param value The amount to be transferred.
175      */
176     function _transfer(address from, address to, uint256 value) internal {
177         require(to != address(0), "ERC20: transfer to the zero address");
178 
179         _balances[from] = _balances[from].sub(value);
180         _balances[to] = _balances[to].add(value);
181         emit Transfer(from, to, value);
182     }
183 
184     /**
185      * @dev Internal function that mints an amount of the token and assigns it to
186      * an account. This encapsulates the modification of balances such that the
187      * proper events are emitted.
188      * @param account The account that will receive the created tokens.
189      * @param value The amount that will be created.
190      */
191     function _mint(address account, uint256 value) internal {
192         require(account != address(0), "ERC20: mint to the zero address");
193 
194         _totalSupply = _totalSupply.add(value);
195         _balances[account] = _balances[account].add(value);
196         emit Transfer(address(0), account, value);
197     }
198 
199     /**
200      * @dev Internal function that burns an amount of the token of a given
201      * account.
202      * @param account The account whose tokens will be burnt.
203      * @param value The amount that will be burnt.
204      */
205     function _burn(address account, uint256 value) internal {
206         require(account != address(0), "ERC20: burn from the zero address");
207 
208         _totalSupply = _totalSupply.sub(value);
209         _balances[account] = _balances[account].sub(value);
210         emit Transfer(account, address(0), value);
211     }
212 
213     /**
214      * @dev Approve an address to spend another addresses' tokens.
215      * @param owner The address that owns the tokens.
216      * @param spender The address that will spend the tokens.
217      * @param value The number of tokens that can be spent.
218      */
219     function _approve(address owner, address spender, uint256 value) internal {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222 
223         _allowances[owner][spender] = value;
224         emit Approval(owner, spender, value);
225     }
226 
227     /**
228      * @dev Internal function that burns an amount of the token of a given
229      * account, deducting from the sender's allowance for said account. Uses the
230      * internal burn function.
231      * Emits an Approval event (reflecting the reduced allowance).
232      * @param account The account whose tokens will be burnt.
233      * @param value The amount that will be burnt.
234      */
235     function _burnFrom(address account, uint256 value) internal {
236         _burn(account, value);
237         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
238     }
239 }
240 
241 
242 /**
243  * @title Burnable Token
244  * @dev Token that can be irreversibly burned (destroyed).
245  */
246 contract ERC20Burnable is ERC20 {
247     /**
248      * @dev Burns a specific amount of tokens.
249      * @param value The amount of token to be burned.
250      */
251     function burn(uint256 value) public {
252         _burn(msg.sender, value);
253     }
254 
255     /**
256      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
257      * @param from address The account whose tokens will be burned.
258      * @param value uint256 The amount of token to be burned.
259      */
260     function burnFrom(address from, uint256 value) public {
261         _burnFrom(from, value);
262     }
263 }
264 
265 
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of "user permissions".
270  */
271 contract Ownable {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
278      * account.
279      */
280     constructor () internal {
281         _owner = msg.sender;
282         emit OwnershipTransferred(address(0), _owner);
283     }
284 
285     /**
286      * @return the address of the owner.
287      */
288     function owner() public view returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         require(isOwner(), "Ownable: caller is not the owner");
297         _;
298     }
299 
300     /**
301      * @return true if `msg.sender` is the owner of the contract.
302      */
303     function isOwner() public view returns (bool) {
304         return msg.sender == _owner;
305     }
306 
307     /**
308      * @dev Allows the current owner to relinquish control of the contract.
309      * It will not be possible to call the functions with the `onlyOwner`
310      * modifier anymore.
311      * @notice Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public onlyOwner {
315         emit OwnershipTransferred(_owner, address(0));
316         _owner = address(0);
317     }
318 
319     /**
320      * @dev Allows the current owner to transfer control of the contract to a newOwner.
321      * @param newOwner The address to transfer ownership to.
322      */
323     function transferOwnership(address newOwner) public onlyOwner {
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers control of the contract to a newOwner.
329      * @param newOwner The address to transfer ownership to.
330      */
331     function _transferOwnership(address newOwner) internal {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         emit OwnershipTransferred(_owner, newOwner);
334         _owner = newOwner;
335     }
336 }
337 
338 
339 
340 /**
341  * @title ERC20Detailed token
342  * @dev The decimals are only for visualization purposes.
343  * All the operations are done using the smallest and indivisible token unit,
344  * just as on Ethereum all the operations are done in wei.
345  */
346 contract ERC20Detailed is IERC20 {
347     string private _name;
348     string private _symbol;
349     uint8 private _decimals;
350 
351     constructor (string memory name, string memory symbol, uint8 decimals) public {
352         _name = name;
353         _symbol = symbol;
354         _decimals = decimals;
355     }
356 
357     /**
358      * @return the name of the token.
359      */
360     function name() public view returns (string memory) {
361         return _name;
362     }
363 
364     /**
365      * @return the symbol of the token.
366      */
367     function symbol() public view returns (string memory) {
368         return _symbol;
369     }
370 
371     /**
372      * @return the number of decimals of the token.
373      */
374     function decimals() public view returns (uint8) {
375         return _decimals;
376     }
377 }
378 
379 /**
380  * @title ERC20 token contract of RANLYTICS
381  */
382 contract ERC20Token is ERC20, ERC20Detailed, Ownable, ERC20Burnable {
383   uint8 public constant DECIMALS = 18;
384   uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(DECIMALS));
385 
386   /**
387     * @dev Constructor that gives msg.sender all of existing tokens.
388     */
389   constructor () public ERC20Detailed("RANLYTICS", "RAN", DECIMALS) {
390       _mint(msg.sender, INITIAL_SUPPLY);
391   }
392 }