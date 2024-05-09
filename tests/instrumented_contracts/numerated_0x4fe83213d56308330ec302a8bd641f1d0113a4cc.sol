1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 pragma solidity ^0.7.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
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
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 interface IERC20 {
75     function transfer(address to, uint256 value) external returns (bool);
76 
77     function approve(address spender, uint256 value) external returns (bool);
78 
79     function transferFrom(address from, address to, uint256 value) external returns (bool);
80 
81     function totalSupply() external view returns (uint256);
82 
83     function balanceOf(address who) external view returns (uint256);
84 
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
98  * Originally based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  *
101  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
102  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
103  * compliant implementations may not do it.
104  */
105 contract ERC20 is IERC20 {
106     using SafeMath for uint256;
107 
108     mapping (address => uint256) private _balances;
109 
110     mapping (address => mapping (address => uint256)) private _allowed;
111 
112     uint256 private _totalSupply;
113 
114     /**
115      * @dev Total number of tokens in existence
116      */
117     function totalSupply() public view override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     /**
122      * @dev Gets the balance of the specified address.
123      * @param owner The address to query the balance of.
124      * @return An uint256 representing the amount owned by the passed address.
125      */
126     function balanceOf(address owner) public view override returns (uint256) {
127         return _balances[owner];
128     }
129 
130     /**
131      * @dev Function to check the amount of tokens that an owner allowed to a spender.
132      * @param owner address The address which owns the funds.
133      * @param spender address The address which will spend the funds.
134      * @return A uint256 specifying the amount of tokens still available for the spender.
135      */
136     function allowance(address owner, address spender) public view override returns (uint256) {
137         return _allowed[owner][spender];
138     }
139 
140     /**
141      * @dev Transfer token for a specified address
142      * @param to The address to transfer to.
143      * @param value The amount to be transferred.
144      */
145     function transfer(address to, uint256 value) public override returns (bool) {
146         _transfer(msg.sender, to, value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      * Beware that changing an allowance with this method brings the risk that someone may use both the old
153      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      * @param spender The address which will spend the funds.
157      * @param value The amount of tokens to be spent.
158      */
159     function approve(address spender, uint256 value) public override returns (bool) {
160 
161         // To change the approve amount you first have to reduce the addresses`
162         //  allowance to zero by calling `approve(_spender, 0)` if it is not
163         //  already 0 to mitigate the race condition described here:
164         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165         require(value == 0 || _allowed[msg.sender][spender] == 0);
166 
167         _approve(msg.sender, spender, value);
168         return true;
169     }
170 
171     /**
172      * @dev Transfer tokens from one address to another.
173      * Note that while this function emits an Approval event, this is not required as per the specification,
174      * and other compliant implementations may not emit the event.
175      * @param from address The address which you want to send tokens from
176      * @param to address The address which you want to transfer to
177      * @param value uint256 the amount of tokens to be transferred
178      */
179     function transferFrom(address from, address to, uint256 value) public override returns (bool) {
180         _transfer(from, to, value);
181         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
182         return true;
183     }
184 
185     /**
186      * @dev Increase the amount of tokens that an owner allowed to a spender.
187      * approve should be called when allowed_[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * Emits an Approval event.
192      * @param spender The address which will spend the funds.
193      * @param addedValue The amount of tokens to increase the allowance by.
194      */
195     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
196         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
197         return true;
198     }
199 
200     /**
201      * @dev Decrease the amount of tokens that an owner allowed to a spender.
202      * approve should be called when allowed_[_spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * Emits an Approval event.
207      * @param spender The address which will spend the funds.
208      * @param subtractedValue The amount of tokens to decrease the allowance by.
209      */
210     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
211         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
212         return true;
213     }
214 
215     /**
216      * @dev Transfer token for a specified addresses
217      * @param from The address to transfer from.
218      * @param to The address to transfer to.
219      * @param value The amount to be transferred.
220      */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Internal function that mints an amount of the token and assigns it to
231      * an account. This encapsulates the modification of balances such that the
232      * proper events are emitted.
233      * @param account The account that will receive the created tokens.
234      * @param value The amount that will be created.
235      */
236     function _mint(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.add(value);
240         _balances[account] = _balances[account].add(value);
241         emit Transfer(address(0), account, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Approve an address to spend another addresses' tokens.
260      * @param owner The address that owns the tokens.
261      * @param spender The address that will spend the tokens.
262      * @param value The number of tokens that can be spent.
263      */
264     function _approve(address owner, address spender, uint256 value) internal {
265         require(spender != address(0));
266         require(owner != address(0));
267 
268         _allowed[owner][spender] = value;
269         emit Approval(owner, spender, value);
270     }
271 
272     /**
273      * @dev Internal function that burns an amount of the token of a given
274      * account, deducting from the sender's allowance for said account. Uses the
275      * internal burn function.
276      * Emits an Approval event (reflecting the reduced allowance).
277      * @param account The account whose tokens will be burnt.
278      * @param value The amount that will be burnt.
279      */
280     function _burnFrom(address account, uint256 value) internal {
281         _burn(account, value);
282         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
283     }
284 
285 }
286 
287 
288 /**
289  * @title ERC20Detailed token
290  * @dev The decimals are only for visualization purposes.
291  * All the operations are done using the smallest and indivisible token unit,
292  * just as on Ethereum all the operations are done in wei.
293  */
294 abstract contract ERC20Detailed is IERC20 {
295     string private _name;
296     string private _symbol;
297     uint8 private _decimals;
298 
299     constructor (string memory name, string memory symbol, uint8 decimals) {
300         _name = name;
301         _symbol = symbol;
302         _decimals = decimals;
303     }
304 
305     /**
306      * @return the name of the token.
307      */
308     function name() public view returns (string memory) {
309         return _name;
310     }
311 
312     /**
313      * @return the symbol of the token.
314      */
315     function symbol() public view returns (string memory) {
316         return _symbol;
317     }
318 
319     /**
320      * @return the number of decimals of the token.
321      */
322     function decimals() public view returns (uint8) {
323         return _decimals;
324     }
325 }
326 
327 
328 /**
329 * @dev Interface to use the receiveApproval method
330 */
331 interface TokenRecipient {
332 
333     /**
334     * @notice Receives a notification of approval of the transfer
335     * @param _from Sender of approval
336     * @param _value  The amount of tokens to be spent
337     * @param _tokenContract Address of the token contract
338     * @param _extraData Extra data
339     */
340     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes calldata _extraData) external;
341 
342 }
343 
344 
345 /**
346 * @title NuCypher token
347 * @notice ERC20 token
348 * @dev Optional approveAndCall() functionality to notify a contract if an approve() has occurred.
349 */
350 contract NuCypherToken is ERC20, ERC20Detailed('NuCypher', 'NU', 18) {
351 
352     /**
353     * @notice Set amount of tokens
354     * @param _totalSupplyOfTokens Total number of tokens
355     */
356     constructor (uint256 _totalSupplyOfTokens) {
357         _mint(msg.sender, _totalSupplyOfTokens);
358     }
359 
360     /**
361     * @notice Approves and then calls the receiving contract
362     *
363     * @dev call the receiveApproval function on the contract you want to be notified.
364     * receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
365     */
366     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
367         external returns (bool success)
368     {
369         approve(_spender, _value);
370         TokenRecipient(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
371         return true;
372     }
373 
374 }