1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b, "SafeMath: multiplication overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a, "SafeMath: subtraction overflow");
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 
67 pragma solidity ^0.5.0;
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://eips.ethereum.org/EIPS/eip-20
72  */
73 interface IERC20 {
74     function transfer(address to, uint256 value) external returns (bool);
75 
76     function approve(address spender, uint256 value) external returns (bool);
77 
78     function transferFrom(
79         address from,
80         address to,
81         uint256 value
82     ) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender)
89         external
90         view
91         returns (uint256);
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     event Approval(
96         address indexed owner,
97         address indexed spender,
98         uint256 value
99     );
100 }
101 
102 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
103 
104 pragma solidity ^0.5.0;
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://eips.ethereum.org/EIPS/eip-20
111  * Originally based on code by FirstBlood:
112  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  *
114  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
115  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
116  * compliant implementations may not do it.
117  */
118 contract ERC20 is IERC20 {
119     using SafeMath for uint256;
120 
121     mapping(address => uint256) private _balances;
122 
123     mapping(address => mapping(address => uint256)) private _allowances;
124 
125     uint256 private _totalSupply;
126 
127     /**
128      * @dev Total number of tokens in existence.
129      */
130     function totalSupply() public view returns (uint256) {
131         return _totalSupply;
132     }
133 
134     /**
135      * @dev Gets the balance of the specified address.
136      * @param owner The address to query the balance of.
137      * @return A uint256 representing the amount owned by the passed address.
138      */
139     function balanceOf(address owner) public view returns (uint256) {
140         return _balances[owner];
141     }
142 
143     /**
144      * @dev Function to check the amount of tokens that an owner allowed to a spender.
145      * @param owner address The address which owns the funds.
146      * @param spender address The address which will spend the funds.
147      * @return A uint256 specifying the amount of tokens still available for the spender.
148      */
149     function allowance(address owner, address spender)
150         public
151         view
152         returns (uint256)
153     {
154         return _allowances[owner][spender];
155     }
156 
157     /**
158      * @dev Transfer token to a specified address.
159      * @param to The address to transfer to.
160      * @param value The amount to be transferred.
161      */
162     function transfer(address to, uint256 value) public returns (bool) {
163         _transfer(msg.sender, to, value);
164         return true;
165     }
166 
167     /**
168      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169      * Beware that changing an allowance with this method brings the risk that someone may use both the old
170      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      * @param spender The address which will spend the funds.
174      * @param value The amount of tokens to be spent.
175      */
176     function approve(address spender, uint256 value) public returns (bool) {
177         _approve(msg.sender, spender, value);
178         return true;
179     }
180 
181     /**
182      * @dev Transfer tokens from one address to another.
183      * Note that while this function emits an Approval event, this is not required as per the specification,
184      * and other compliant implementations may not emit the event.
185      * @param from address The address which you want to send tokens from
186      * @param to address The address which you want to transfer to
187      * @param value uint256 the amount of tokens to be transferred
188      */
189     function transferFrom(
190         address from,
191         address to,
192         uint256 value
193     ) public returns (bool) {
194         _transfer(from, to, value);
195         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
196         return true;
197     }
198 
199     /**
200      * @dev Increase the amount of tokens that an owner allowed to a spender.
201      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param addedValue The amount of tokens to increase the allowance by.
208      */
209     function increaseAllowance(address spender, uint256 addedValue)
210         public
211         returns (bool)
212     {
213         _approve(
214             msg.sender,
215             spender,
216             _allowances[msg.sender][spender].add(addedValue)
217         );
218         return true;
219     }
220 
221     /**
222      * @dev Decrease the amount of tokens that an owner allowed to a spender.
223      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * Emits an Approval event.
228      * @param spender The address which will spend the funds.
229      * @param subtractedValue The amount of tokens to decrease the allowance by.
230      */
231     function decreaseAllowance(address spender, uint256 subtractedValue)
232         public
233         returns (bool)
234     {
235         _approve(
236             msg.sender,
237             spender,
238             _allowances[msg.sender][spender].sub(subtractedValue)
239         );
240         return true;
241     }
242 
243     /**
244      * @dev Transfer token for a specified addresses.
245      * @param from The address to transfer from.
246      * @param to The address to transfer to.
247      * @param value The amount to be transferred.
248      */
249     function _transfer(
250         address from,
251         address to,
252         uint256 value
253     ) internal {
254         require(to != address(0), "ERC20: transfer to the zero address");
255 
256         _balances[from] = _balances[from].sub(value);
257         _balances[to] = _balances[to].add(value);
258         emit Transfer(from, to, value);
259     }
260 
261     /**
262      * @dev Internal function that mints an amount of the token and assigns it to
263      * an account. This encapsulates the modification of balances such that the
264      * proper events are emitted.
265      * @param account The account that will receive the created tokens.
266      * @param value The amount that will be created.
267      */
268     function _mint(address account, uint256 value) internal {
269         require(account != address(0), "ERC20: mint to the zero address");
270 
271         _totalSupply = _totalSupply.add(value);
272         _balances[account] = _balances[account].add(value);
273         emit Transfer(address(0), account, value);
274     }
275 
276     /**
277      * @dev Internal function that burns an amount of the token of a given
278      * account.
279      * @param account The account whose tokens will be burnt.
280      * @param value The amount that will be burnt.
281      */
282     function _burn(address account, uint256 value) internal {
283         require(account != address(0), "ERC20: burn from the zero address");
284 
285         _totalSupply = _totalSupply.sub(value);
286         _balances[account] = _balances[account].sub(value);
287         emit Transfer(account, address(0), value);
288     }
289 
290     /**
291      * @dev Approve an address to spend another addresses' tokens.
292      * @param owner The address that owns the tokens.
293      * @param spender The address that will spend the tokens.
294      * @param value The number of tokens that can be spent.
295      */
296     function _approve(
297         address owner,
298         address spender,
299         uint256 value
300     ) internal {
301         require(owner != address(0), "ERC20: approve from the zero address");
302         require(spender != address(0), "ERC20: approve to the zero address");
303 
304         _allowances[owner][spender] = value;
305         emit Approval(owner, spender, value);
306     }
307 
308     /**
309      * @dev Internal function that burns an amount of the token of a given
310      * account, deducting from the sender's allowance for said account. Uses the
311      * internal burn function.
312      * Emits an Approval event (reflecting the reduced allowance).
313      * @param account The account whose tokens will be burnt.
314      * @param value The amount that will be burnt.
315      */
316     function _burnFrom(address account, uint256 value) internal {
317         _burn(account, value);
318         _approve(
319             account,
320             msg.sender,
321             _allowances[account][msg.sender].sub(value)
322         );
323     }
324 }
325 
326 // File: @openzeppelin/contracts/token/ERC20/ERC20detailed.sol
327 
328 pragma solidity ^0.5.0;
329 
330 /**
331  * @title ERC20Detailed token
332  * @dev The decimals are only for visualization purposes.
333  * All the operations are done using the smallest and indivisible token unit,
334  * just as on Ethereum all the operations are done in wei.
335  */
336 contract ERC20Detailed is IERC20 {
337     string private _name;
338     string private _symbol;
339     uint8 private _decimals;
340 
341     constructor(
342         string memory name,
343         string memory symbol,
344         uint8 decimals
345     ) public {
346         _name = name;
347         _symbol = symbol;
348         _decimals = decimals;
349     }
350 
351     /**
352      * @return the name of the token.
353      */
354     function name() public view returns (string memory) {
355         return _name;
356     }
357 
358     /**
359      * @return the symbol of the token.
360      */
361     function symbol() public view returns (string memory) {
362         return _symbol;
363     }
364 
365     /**
366      * @return the number of decimals of the token.
367      */
368     function decimals() public view returns (uint8) {
369         return _decimals;
370     }
371 }
372 
373 // File: MarsX.sol
374 
375 //SPDX-License-Identifier: MIT
376 pragma solidity ^0.5.0;
377 
378 contract MarsX is ERC20, ERC20Detailed {
379     uint8 public constant DECIMALS = 18;
380     uint256 public constant INITIAL_SUPPLY =
381         227936637 * (10**uint256(DECIMALS));
382 
383     /**
384      * @dev Constructor that gives msg.sender all of existing tokens.
385      */
386     constructor() public ERC20Detailed("MarsX", "MX", DECIMALS) {
387         _mint(msg.sender, INITIAL_SUPPLY);
388     }
389 }