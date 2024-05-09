1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-27
3 */
4 
5 // Copyright (C) Chromapolis Devcenter OU 2019
6 
7 
8 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
9 
10 pragma solidity ^0.5.2;
11 
12 /**
13  * @title ERC20 interface
14  * @dev see https://eips.ethereum.org/EIPS/eip-20
15  */
16 interface IERC20 {
17     function transfer(address to, uint256 value) external returns (bool);
18 
19     function approve(address spender, uint256 value) external returns (bool);
20 
21     function transferFrom(address from, address to, uint256 value) external returns (bool);
22 
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address who) external view returns (uint256);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
35 
36 pragma solidity ^0.5.2;
37 
38 /**
39  * @title SafeMath
40  * @dev Unsigned math operations with safety checks that revert on error
41  */
42 library SafeMath {
43     /**
44      * @dev Multiplies two unsigned integers, reverts on overflow.
45      */
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b);
56 
57         return c;
58     }
59 
60     /**
61      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
62      */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Solidity only automatically asserts when dividing by 0
65         require(b > 0);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74      */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Adds two unsigned integers, reverts on overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a);
88 
89         return c;
90     }
91 
92     /**
93      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
94      * reverts when dividing by zero.
95      */
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b != 0);
98         return a % b;
99     }
100 }
101 
102 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
103 
104 pragma solidity ^0.5.2;
105 
106 
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * https://eips.ethereum.org/EIPS/eip-20
113  * Originally based on code by FirstBlood:
114  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  *
116  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
117  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
118  * compliant implementations may not do it.
119  */
120 contract ERC20 is IERC20 {
121     using SafeMath for uint256;
122 
123     mapping (address => uint256) private _balances;
124 
125     mapping (address => mapping (address => uint256)) private _allowed;
126 
127     uint256 private _totalSupply;
128 
129     /**
130      * @dev Total number of tokens in existence
131      */
132     function totalSupply() public view returns (uint256) {
133         return _totalSupply;
134     }
135 
136     /**
137      * @dev Gets the balance of the specified address.
138      * @param owner The address to query the balance of.
139      * @return A uint256 representing the amount owned by the passed address.
140      */
141     function balanceOf(address owner) public view returns (uint256) {
142         return _balances[owner];
143     }
144 
145     /**
146      * @dev Function to check the amount of tokens that an owner allowed to a spender.
147      * @param owner address The address which owns the funds.
148      * @param spender address The address which will spend the funds.
149      * @return A uint256 specifying the amount of tokens still available for the spender.
150      */
151     function allowance(address owner, address spender) public view returns (uint256) {
152         return _allowed[owner][spender];
153     }
154 
155     /**
156      * @dev Transfer token to a specified address
157      * @param to The address to transfer to.
158      * @param value The amount to be transferred.
159      */
160     function transfer(address to, uint256 value) public returns (bool) {
161         _transfer(msg.sender, to, value);
162         return true;
163     }
164 
165     /**
166      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      * Beware that changing an allowance with this method brings the risk that someone may use both the old
168      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      * @param spender The address which will spend the funds.
172      * @param value The amount of tokens to be spent.
173      */
174     function approve(address spender, uint256 value) public returns (bool) {
175         _approve(msg.sender, spender, value);
176         return true;
177     }
178 
179     /**
180      * @dev Transfer tokens from one address to another.
181      * Note that while this function emits an Approval event, this is not required as per the specification,
182      * and other compliant implementations may not emit the event.
183      * @param from address The address which you want to send tokens from
184      * @param to address The address which you want to transfer to
185      * @param value uint256 the amount of tokens to be transferred
186      */
187     function transferFrom(address from, address to, uint256 value) public returns (bool) {
188         _transfer(from, to, value);
189         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
190         return true;
191     }
192 
193     /**
194      * @dev Increase the amount of tokens that an owner allowed to a spender.
195      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * Emits an Approval event.
200      * @param spender The address which will spend the funds.
201      * @param addedValue The amount of tokens to increase the allowance by.
202      */
203     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
204         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
220         return true;
221     }
222 
223     /**
224      * @dev Transfer token for a specified addresses
225      * @param from The address to transfer from.
226      * @param to The address to transfer to.
227      * @param value The amount to be transferred.
228      */
229     function _transfer(address from, address to, uint256 value) internal {
230         require(to != address(0));
231 
232         _balances[from] = _balances[from].sub(value);
233         _balances[to] = _balances[to].add(value);
234         emit Transfer(from, to, value);
235     }
236 
237     /**
238      * @dev Internal function that mints an amount of the token and assigns it to
239      * an account. This encapsulates the modification of balances such that the
240      * proper events are emitted.
241      * @param account The account that will receive the created tokens.
242      * @param value The amount that will be created.
243      */
244     function _mint(address account, uint256 value) internal {
245         require(account != address(0));
246 
247         _totalSupply = _totalSupply.add(value);
248         _balances[account] = _balances[account].add(value);
249         emit Transfer(address(0), account, value);
250     }
251 
252     /**
253      * @dev Internal function that burns an amount of the token of a given
254      * account.
255      * @param account The account whose tokens will be burnt.
256      * @param value The amount that will be burnt.
257      */
258     function _burn(address account, uint256 value) internal {
259         require(account != address(0));
260 
261         _totalSupply = _totalSupply.sub(value);
262         _balances[account] = _balances[account].sub(value);
263         emit Transfer(account, address(0), value);
264     }
265 
266     /**
267      * @dev Approve an address to spend another addresses' tokens.
268      * @param owner The address that owns the tokens.
269      * @param spender The address that will spend the tokens.
270      * @param value The number of tokens that can be spent.
271      */
272     function _approve(address owner, address spender, uint256 value) internal {
273         require(spender != address(0));
274         require(owner != address(0));
275 
276         _allowed[owner][spender] = value;
277         emit Approval(owner, spender, value);
278     }
279 
280     /**
281      * @dev Internal function that burns an amount of the token of a given
282      * account, deducting from the sender's allowance for said account. Uses the
283      * internal burn function.
284      * Emits an Approval event (reflecting the reduced allowance).
285      * @param account The account whose tokens will be burnt.
286      * @param value The amount that will be burnt.
287      */
288     function _burnFrom(address account, uint256 value) internal {
289         _burn(account, value);
290         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
291     }
292 }
293 
294 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
295 
296 pragma solidity ^0.5.2;
297 
298 
299 /**
300  * @title ERC20Detailed token
301  * @dev The decimals are only for visualization purposes.
302  * All the operations are done using the smallest and indivisible token unit,
303  * just as on Ethereum all the operations are done in wei.
304  */
305 contract ERC20Detailed is IERC20 {
306     string private _name;
307     string private _symbol;
308     uint8 private _decimals;
309 
310     constructor (string memory name, string memory symbol, uint8 decimals) public {
311         _name = name;
312         _symbol = symbol;
313         _decimals = decimals;
314     }
315 
316     /**
317      * @return the name of the token.
318      */
319     function name() public view returns (string memory) {
320         return _name;
321     }
322 
323     /**
324      * @return the symbol of the token.
325      */
326     function symbol() public view returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @return the number of decimals of the token.
332      */
333     function decimals() public view returns (uint8) {
334         return _decimals;
335     }
336 }
337 
338 // File: contracts/token/ERC20/Chromia.sol
339 
340 // Copyright (C) Chromapolis Devcenter OU 2019
341 
342 pragma solidity 0.5.8;
343 
344 
345 
346 contract Chromia is ERC20, ERC20Detailed {
347     uint8 public constant DECIMALS = 6;
348     address private _minter;
349     // one billion tokens with 6 decimals
350     uint256 private _cap = 1000000000 * 1000000;
351 
352     event MinterSet(address indexed account);
353     event TransferToChromia(address indexed from, bytes32 indexed to, uint256 value);
354     event TransferFromChromia(address indexed to, bytes32 indexed refID, uint256 value);
355 
356     /**
357      * @dev Constructor that gives msg.sender all of existing tokens.
358      * @param minter the multi-sig contract address
359      */
360     constructor(address minter, uint256 initialBalance) public ERC20Detailed("Chroma", "CHR", DECIMALS) {
361         _mint(msg.sender, initialBalance);
362         _setMinter(minter);
363     }
364 
365     modifier onlyMinter() {
366         require(isMinter(msg.sender), "caller is not a minter");
367         _;
368     }
369     
370     function cap() public view returns (uint256) {
371         return _cap;
372     }
373 
374     /**
375      * @dev Burns a specific amount of tokens and emit transfer event for Chromia
376      * @param to The address to transfer to in Chromia.
377      * @param value The amount of token to be burned.
378      */
379     function transferToChromia(bytes32 to, uint256 value) public {
380         _burn(msg.sender, value);
381         emit TransferToChromia(msg.sender, to, value);
382     }
383 
384     /**
385      * @dev Function to mint tokens
386      * @param to The address that will receive the minted tokens.
387      * @param value The amount of tokens to mint.
388      * @return A boolean that indicates if the operation was successful.
389      */
390     function transferFromChromia(address to, uint256 value, bytes32 refID) public onlyMinter returns (bool) {
391         _mint(to, value);
392         emit TransferFromChromia(to, refID, value);
393         return true;
394     }
395     
396     function _mint(address account, uint256 value) internal {
397         require(totalSupply().add(value) <= cap(), "ERC20Capped: cap exceeded");
398         super._mint(account, value);
399     }
400 
401     function isMinter(address account) public view returns (bool) {
402         return _minter == account;
403     }
404 
405     function _setMinter(address account) internal {
406         _minter = account;
407         emit MinterSet(account);
408     }
409     
410     function changeMinter(address newMinter) public onlyMinter {
411         _setMinter(newMinter);
412     }
413 }