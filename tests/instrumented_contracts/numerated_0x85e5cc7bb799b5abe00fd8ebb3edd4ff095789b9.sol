1 pragma solidity 0.5.9;
2 
3 /**
4  * @title Claimable
5  * @dev Claimable contract, where the ownership needs to be claimed.
6  * This allows the new owner to accept the transfer.
7  */
8 contract Claimable {
9     address public owner;
10     address public pendingOwner;
11 
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16 
17     /**
18     * @dev The Claimable constructor sets the original `owner` of the contract to the sender
19     * account.
20     */
21     constructor() public {
22         owner = msg.sender;
23     }
24 
25     /**
26     * @dev Throws if called by any account other than the owner.
27     */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     /**
34     * @dev Modifier throws if called by any account other than the pendingOwner.
35     */
36     modifier onlyPendingOwner() {
37         require(msg.sender == pendingOwner);
38         _;
39     }
40 
41     /**
42     * @dev Allows the current owner to set the pendingOwner address.
43     * @param newOwner The address to transfer ownership to.
44     */
45     function transferOwnership(address newOwner) public onlyOwner {
46         pendingOwner = newOwner;
47     }
48 
49     /**
50     * @dev Allows the pendingOwner address to finalize the transfer.
51     */
52     function claimOwnership() public onlyPendingOwner {
53         emit OwnershipTransferred(owner, pendingOwner);
54         owner = pendingOwner;
55         pendingOwner = address(0);
56     }
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://eips.ethereum.org/EIPS/eip-20
62  */
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool);
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @title SafeMath
83  * @dev Unsigned math operations with safety checks that revert on error
84  */
85 library SafeMath {
86     /**
87      * @dev Multiplies two unsigned integers, reverts on overflow.
88      */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91         // benefit is lost if 'b' is also tested.
92         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b);
99 
100         return c;
101     }
102 
103     /**
104      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Solidity only automatically asserts when dividing by 0
108         require(b > 0);
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112         return c;
113     }
114 
115     /**
116      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a);
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Adds two unsigned integers, reverts on overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a);
131 
132         return c;
133     }
134 
135     /**
136      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
137      * reverts when dividing by zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b != 0);
141         return a % b;
142     }
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://eips.ethereum.org/EIPS/eip-20
150  * Originally based on code by FirstBlood:
151  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  *
153  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
154  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
155  * compliant implementations may not do it.
156  */
157 contract ERC20 is IERC20 {
158     using SafeMath for uint256;
159 
160     mapping (address => uint256) private _balances;
161 
162     mapping (address => mapping (address => uint256)) private _allowed;
163 
164     uint256 private _totalSupply;
165 
166     /**
167      * @dev Total number of tokens in existence
168      */
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     /**
174      * @dev Gets the balance of the specified address.
175      * @param owner The address to query the balance of.
176      * @return A uint256 representing the amount owned by the passed address.
177      */
178     function balanceOf(address owner) public view returns (uint256) {
179         return _balances[owner];
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param owner address The address which owns the funds.
185      * @param spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address owner, address spender) public view returns (uint256) {
189         return _allowed[owner][spender];
190     }
191 
192     /**
193      * @dev Transfer token to a specified address
194      * @param to The address to transfer to.
195      * @param value The amount to be transferred.
196      */
197     function transfer(address to, uint256 value) public returns (bool) {
198         _transfer(msg.sender, to, value);
199         return true;
200     }
201 
202     /**
203      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param spender The address which will spend the funds.
209      * @param value The amount of tokens to be spent.
210      */
211     function approve(address spender, uint256 value) public returns (bool) {
212         _approve(msg.sender, spender, value);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another.
218      * Note that while this function emits an Approval event, this is not required as per the specification,
219      * and other compliant implementations may not emit the event.
220      * @param from address The address which you want to send tokens from
221      * @param to address The address which you want to transfer to
222      * @param value uint256 the amount of tokens to be transferred
223      */
224     function transferFrom(address from, address to, uint256 value) public returns (bool) {
225         _transfer(from, to, value);
226         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
227         return true;
228     }
229 
230     /**
231      * @dev Increase the amount of tokens that an owner allowed to a spender.
232      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param addedValue The amount of tokens to increase the allowance by.
239      */
240     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner allowed to a spender.
247      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * Emits an Approval event.
252      * @param spender The address which will spend the funds.
253      * @param subtractedValue The amount of tokens to decrease the allowance by.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
256         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
257         return true;
258     }
259 
260     /**
261      * @dev Transfer token for a specified addresses
262      * @param from The address to transfer from.
263      * @param to The address to transfer to.
264      * @param value The amount to be transferred.
265      */
266     function _transfer(address from, address to, uint256 value) internal {
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273 
274     /**
275      * @dev Internal function that mints an amount of the token and assigns it to
276      * an account. This encapsulates the modification of balances such that the
277      * proper events are emitted.
278      * @param account The account that will receive the created tokens.
279      * @param value The amount that will be created.
280      */
281     function _mint(address account, uint256 value) internal {
282         require(account != address(0));
283 
284         _totalSupply = _totalSupply.add(value);
285         _balances[account] = _balances[account].add(value);
286         emit Transfer(address(0), account, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account.
292      * @param account The account whose tokens will be burnt.
293      * @param value The amount that will be burnt.
294      */
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 
303     /**
304      * @dev Approve an address to spend another addresses' tokens.
305      * @param owner The address that owns the tokens.
306      * @param spender The address that will spend the tokens.
307      * @param value The number of tokens that can be spent.
308      */
309     function _approve(address owner, address spender, uint256 value) internal {
310         require(spender != address(0));
311         require(owner != address(0));
312 
313         _allowed[owner][spender] = value;
314         emit Approval(owner, spender, value);
315     }
316 
317     /**
318      * @dev Internal function that burns an amount of the token of a given
319      * account, deducting from the sender's allowance for said account. Uses the
320      * internal burn function.
321      * Emits an Approval event (reflecting the reduced allowance).
322      * @param account The account whose tokens will be burnt.
323      * @param value The amount that will be burnt.
324      */
325     function _burnFrom(address account, uint256 value) internal {
326         _burn(account, value);
327         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
328     }
329 }
330 
331 /**
332  * @title Burnable Token
333  * @dev Token that can be irreversibly burned (destroyed).
334  */
335 contract ERC20Burnable is ERC20 {
336     /**
337      * @dev Burns a specific amount of tokens.
338      * @param value The amount of token to be burned.
339      */
340     function burn(uint256 value) public {
341         _burn(msg.sender, value);
342     }
343 
344     /**
345      * @dev Burns a specific amount of tokens from the target address and decrements allowance
346      * @param from address The account whose tokens will be burned.
347      * @param value uint256 The amount of token to be burned.
348      */
349     function burnFrom(address from, uint256 value) public {
350         _burnFrom(from, value);
351     }
352 }
353 
354 contract SwgToken is ERC20, ERC20Burnable, Claimable {
355     string public name = "SkyWay Global Token";
356     string public symbol = "SWG";
357     uint8 public decimals = 8;
358 
359     /**
360      * @dev Function to mint tokens
361      * @param to The address that will receive the minted tokens.
362      * @param value The amount of tokens to mint.
363      * @return A boolean that indicates if the operation was successful.
364      */
365     function mint(address to, uint256 value) public onlyOwner returns (bool) {
366         require(value > 0);
367         _mint(to, value);
368         return true;
369     }
370 }