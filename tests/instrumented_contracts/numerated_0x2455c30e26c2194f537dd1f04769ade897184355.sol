1 pragma solidity ^0.5.0;
2 
3 /**
4  * @notes All the credits go to the fantastic OpenZeppelin project and its community, see https://github.com/OpenZeppelin/openzeppelin-solidity
5  * This contract was generated and deployed using https://tokens.kawatta.com
6  */
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://eips.ethereum.org/EIPS/eip-20
11  */
12 interface IERC20 {
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value) external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address who) external view returns (uint256);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Unsigned math operations with safety checks that revert on error.
33  */
34 library SafeMath {
35     /**
36      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a, "SafeMath: subtraction overflow");
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46      * @dev Adds two unsigned integers, reverts on overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 }
55 
56 /**
57  * @title Standard ERC20 token
58  *
59  * @dev Implementation of the basic standard token.
60  * https://eips.ethereum.org/EIPS/eip-20
61  * Originally based on code by FirstBlood:
62  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
63  *
64  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
65  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
66  * compliant implementations may not do it.
67  */
68 contract ERC20 is IERC20 {
69     using SafeMath for uint256;
70 
71     mapping (address => uint256) private _balances;
72 
73     mapping (address => mapping (address => uint256)) private _allowances;
74 
75     uint256 private _totalSupply;
76 
77     /**
78      * @dev Total number of tokens in existence.
79      */
80     function totalSupply() public view returns (uint256) {
81         return _totalSupply;
82     }
83 
84     /**
85      * @dev Gets the balance of the specified address.
86      * @param owner The address to query the balance of.
87      * @return A uint256 representing the amount owned by the passed address.
88      */
89     function balanceOf(address owner) public view returns (uint256) {
90         return _balances[owner];
91     }
92 
93     /**
94      * @dev Function to check the amount of tokens that an owner allowed to a spender.
95      * @param owner address The address which owns the funds.
96      * @param spender address The address which will spend the funds.
97      * @return A uint256 specifying the amount of tokens still available for the spender.
98      */
99     function allowance(address owner, address spender) public view returns (uint256) {
100         return _allowances[owner][spender];
101     }
102 
103     /**
104      * @dev Transfer token to a specified address.
105      * @param to The address to transfer to.
106      * @param value The amount to be transferred.
107      */
108     function transfer(address to, uint256 value) public returns (bool) {
109         _transfer(msg.sender, to, value);
110         return true;
111     }
112 
113     /**
114      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
115      * Beware that changing an allowance with this method brings the risk that someone may use both the old
116      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
117      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
118      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119      * @param spender The address which will spend the funds.
120      * @param value The amount of tokens to be spent.
121      */
122     function approve(address spender, uint256 value) public returns (bool) {
123         _approve(msg.sender, spender, value);
124         return true;
125     }
126 
127     /**
128      * @dev Transfer tokens from one address to another.
129      * Note that while this function emits an Approval event, this is not required as per the specification,
130      * and other compliant implementations may not emit the event.
131      * @param from address The address which you want to send tokens from
132      * @param to address The address which you want to transfer to
133      * @param value uint256 the amount of tokens to be transferred
134      */
135     function transferFrom(address from, address to, uint256 value) public returns (bool) {
136         _transfer(from, to, value);
137         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
138         return true;
139     }
140 
141     /**
142      * @dev Increase the amount of tokens that an owner allowed to a spender.
143      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
144      * allowed value is better to use this function to avoid 2 calls (and wait until
145      * the first transaction is mined)
146      * From MonolithDAO Token.sol
147      * Emits an Approval event.
148      * @param spender The address which will spend the funds.
149      * @param addedValue The amount of tokens to increase the allowance by.
150      */
151     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
152         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
153         return true;
154     }
155 
156     /**
157      * @dev Decrease the amount of tokens that an owner allowed to a spender.
158      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
159      * allowed value is better to use this function to avoid 2 calls (and wait until
160      * the first transaction is mined)
161      * From MonolithDAO Token.sol
162      * Emits an Approval event.
163      * @param spender The address which will spend the funds.
164      * @param subtractedValue The amount of tokens to decrease the allowance by.
165      */
166     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
167         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
168         return true;
169     }
170 
171     /**
172      * @dev Transfer token for a specified addresses.
173      * @param from The address to transfer from.
174      * @param to The address to transfer to.
175      * @param value The amount to be transferred.
176      */
177     function _transfer(address from, address to, uint256 value) internal {
178         require(to != address(0), "ERC20: transfer to the zero address");
179 
180         _balances[from] = _balances[from].sub(value);
181         _balances[to] = _balances[to].add(value);
182         emit Transfer(from, to, value);
183     }
184 
185     /**
186      * @dev Internal function that mints an amount of the token and assigns it to
187      * an account. This encapsulates the modification of balances such that the
188      * proper events are emitted.
189      * @param account The account that will receive the created tokens.
190      * @param value The amount that will be created.
191      */
192     function _mint(address account, uint256 value) internal {
193         require(account != address(0), "ERC20: mint to the zero address");
194 
195         _totalSupply = _totalSupply.add(value);
196         _balances[account] = _balances[account].add(value);
197         emit Transfer(address(0), account, value);
198     }
199 
200     /**
201      * @dev Internal function that burns an amount of the token of a given
202      * account.
203      * @param account The account whose tokens will be burnt.
204      * @param value The amount that will be burnt.
205      */
206     function _burn(address account, uint256 value) internal {
207         require(account != address(0), "ERC20: burn from the zero address");
208 
209         _totalSupply = _totalSupply.sub(value);
210         _balances[account] = _balances[account].sub(value);
211         emit Transfer(account, address(0), value);
212     }
213 
214     /**
215      * @dev Approve an address to spend another addresses' tokens.
216      * @param owner The address that owns the tokens.
217      * @param spender The address that will spend the tokens.
218      * @param value The number of tokens that can be spent.
219      */
220     function _approve(address owner, address spender, uint256 value) internal {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223 
224         _allowances[owner][spender] = value;
225         emit Approval(owner, spender, value);
226     }
227 
228     /**
229      * @dev Internal function that burns an amount of the token of a given
230      * account, deducting from the sender's allowance for said account. Uses the
231      * internal burn function.
232      * Emits an Approval event (reflecting the reduced allowance).
233      * @param account The account whose tokens will be burnt.
234      * @param value The amount that will be burnt.
235      */
236     function _burnFrom(address account, uint256 value) internal {
237         _burn(account, value);
238         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
239     }
240 }
241 
242 
243 
244 /**
245  * @title Ownable
246  * @dev The Ownable contract has an owner address, and provides basic authorization control
247  * functions, this simplifies the implementation of "user permissions".
248  */
249 contract Ownable {
250     address private _owner;
251 
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254     /**
255      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
256      * account.
257      */
258     constructor () internal {
259         _owner = msg.sender;
260         emit OwnershipTransferred(address(0), _owner);
261     }
262 
263     /**
264      * @return the address of the owner.
265      */
266     function owner() public view returns (address) {
267         return _owner;
268     }
269 
270     /**
271      * @dev Throws if called by any account other than the owner.
272      */
273     modifier onlyOwner() {
274         require(isOwner(), "Ownable: caller is not the owner");
275         _;
276     }
277 
278     /**
279      * @return true if `msg.sender` is the owner of the contract.
280      */
281     function isOwner() public view returns (bool) {
282         return msg.sender == _owner;
283     }
284 
285     /**
286      * @dev Allows the current owner to relinquish control of the contract.
287      * It will not be possible to call the functions with the `onlyOwner`
288      * modifier anymore.
289      * @notice Renouncing ownership will leave the contract without an owner,
290      * thereby removing any functionality that is only available to the owner.
291      */
292     function renounceOwnership() public onlyOwner {
293         emit OwnershipTransferred(_owner, address(0));
294         _owner = address(0);
295     }
296 
297     /**
298      * @dev Allows the current owner to transfer control of the contract to a newOwner.
299      * @param newOwner The address to transfer ownership to.
300      */
301     function transferOwnership(address newOwner) public onlyOwner {
302         _transferOwnership(newOwner);
303     }
304 
305     /**
306      * @dev Transfers control of the contract to a newOwner.
307      * @param newOwner The address to transfer ownership to.
308      */
309     function _transferOwnership(address newOwner) internal {
310         require(newOwner != address(0), "Ownable: new owner is the zero address");
311         emit OwnershipTransferred(_owner, newOwner);
312         _owner = newOwner;
313     }
314 }
315 
316 
317 
318 /**
319  * @title ERC20Detailed token
320  * @dev The decimals are only for visualization purposes.
321  * All the operations are done using the smallest and indivisible token unit,
322  * just as on Ethereum all the operations are done in wei.
323  */
324 contract ERC20Detailed is IERC20 {
325     string private _name;
326     string private _symbol;
327     uint8 private _decimals;
328 
329     constructor (string memory name, string memory symbol, uint8 decimals) public {
330         _name = name;
331         _symbol = symbol;
332         _decimals = decimals;
333     }
334 
335     /**
336      * @return the name of the token.
337      */
338     function name() public view returns (string memory) {
339         return _name;
340     }
341 
342     /**
343      * @return the symbol of the token.
344      */
345     function symbol() public view returns (string memory) {
346         return _symbol;
347     }
348 
349     /**
350      * @return the number of decimals of the token.
351      */
352     function decimals() public view returns (uint8) {
353         return _decimals;
354     }
355 }
356 
357 /**
358  * @title ERC20 token contract of TRIUNE
359  */
360 contract ERC20Token is ERC20, ERC20Detailed, Ownable {
361   uint8 public constant DECIMALS = 18;
362   uint256 public constant INITIAL_SUPPLY = 999000000000000000000 * (10 ** uint256(DECIMALS));
363 
364   /**
365     * @dev Constructor that gives msg.sender all of existing tokens.
366     */
367   constructor () public ERC20Detailed("TRIUNE", "RIX", DECIMALS) {
368       _mint(msg.sender, INITIAL_SUPPLY);
369   }
370 }