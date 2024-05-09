1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
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
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
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
41         require(b <= a);
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
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood:
95  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  *
97  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
98  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
99  * compliant implementations may not do it.
100  */
101 contract ERC20 is IERC20 {
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowed;
107 
108     uint256 private _totalSupply;
109 
110     /**
111      * @dev Total number of tokens in existence
112      */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118      * @dev Gets the balance of the specified address.
119      * @param owner The address to query the balance of.
120      * @return An uint256 representing the amount owned by the passed address.
121      */
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param owner address The address which owns the funds.
129      * @param spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowed[owner][spender];
134     }
135 
136     /**
137      * @dev Transfer token for a specified address
138      * @param to The address to transfer to.
139      * @param value The amount to be transferred.
140      */
141     function transfer(address to, uint256 value) public returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param spender The address which will spend the funds.
153      * @param value The amount of tokens to be spent.
154      */
155     function approve(address spender, uint256 value) public returns (bool) {
156         _approve(msg.sender, spender, value);
157         return true;
158     }
159 
160     /**
161      * @dev Transfer tokens from one address to another.
162      * Note that while this function emits an Approval event, this is not required as per the specification,
163      * and other compliant implementations may not emit the event.
164      * @param from address The address which you want to send tokens from
165      * @param to address The address which you want to transfer to
166      * @param value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address from, address to, uint256 value) public returns (bool) {
169         _transfer(from, to, value);
170         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
171         return true;
172     }
173 
174     /**
175      * @dev Increase the amount of tokens that an owner allowed to a spender.
176      * approve should be called when allowed_[_spender] == 0. To increment
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param addedValue The amount of tokens to increase the allowance by.
183      */
184     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
186         return true;
187     }
188 
189     /**
190      * @dev Decrease the amount of tokens that an owner allowed to a spender.
191      * approve should be called when allowed_[_spender] == 0. To decrement
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * Emits an Approval event.
196      * @param spender The address which will spend the funds.
197      * @param subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
200         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
201         return true;
202     }
203 
204     /**
205      * @dev Transfer token for a specified addresses
206      * @param from The address to transfer from.
207      * @param to The address to transfer to.
208      * @param value The amount to be transferred.
209      */
210     function _transfer(address from, address to, uint256 value) internal {
211         require(to != address(0));
212     
213         _balances[from] = _balances[from].sub(value);
214         _balances[to] = _balances[to].add(value);
215         emit Transfer(from, to, value);
216     }
217 
218     /**
219      * @dev Internal function that mints an amount of the token and assigns it to
220      * an account. This encapsulates the modification of balances such that the
221      * proper events are emitted.
222      * @param account The account that will receive the created tokens.
223      * @param value The amount that will be created.
224      */
225     function _mint(address account, uint256 value) internal {
226         require(account != address(0));
227 
228         _totalSupply = _totalSupply.add(value);
229         _balances[account] = _balances[account].add(value);
230         emit Transfer(address(0), account, value);
231     }
232 
233     /**
234      * @dev Internal function that burns an amount of the token of a given
235      * account.
236      * @param account The account whose tokens will be burnt.
237      * @param value The amount that will be burnt.
238      */
239     function _burn(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.sub(value);
243         _balances[account] = _balances[account].sub(value);
244         emit Transfer(account, address(0), value);
245     }
246 
247     /**
248      * @dev Approve an address to spend another addresses' tokens.
249      * @param owner The address that owns the tokens.
250      * @param spender The address that will spend the tokens.
251      * @param value The number of tokens that can be spent.
252      */
253     function _approve(address owner, address spender, uint256 value) internal {
254         require(spender != address(0));
255         require(owner != address(0));
256 
257         _allowed[owner][spender] = value;
258         emit Approval(owner, spender, value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account, deducting from the sender's allowance for said account. Uses the
264      * internal burn function.
265      * Emits an Approval event (reflecting the reduced allowance).
266      * @param account The account whose tokens will be burnt.
267      * @param value The amount that will be burnt.
268      */
269     function _burnFrom(address account, uint256 value) internal {
270         _burn(account, value);
271         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
272     }
273 }
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281     address[2] private _owners = [address(0), address(0)];
282 
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     /**
286      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
287      * account.
288      */
289     constructor () internal {
290         _owners[0] = msg.sender;
291         emit OwnershipTransferred(address(0), _owners[0]);
292     }
293 
294     /**
295      * @return the address of the owner.
296      */
297     function owners() public view returns (address[2] memory) {
298         return _owners;
299     }
300 
301     /**
302      * @dev Throws if called by any account other than the owner.
303      */
304     modifier onlyOwner() {
305         require(isOwner());
306         _;
307     }
308 
309     /**
310      * @return true if `msg.sender` is the owner of the contract.
311      */
312     function isOwner() public view returns (bool) {
313         for (uint8 i = 0; i < _owners.length; i++) {
314             if (_owners[i] == msg.sender) {
315                 return true;
316             }
317         }
318         return false;
319     }
320 
321     /**
322      * @dev Allows the current owner to relinquish control of the contract.
323      * @notice Renouncing to ownership will leave the contract without an owner.
324      * It will not be possible to call the functions with the `onlyOwner`
325      * modifier anymore.
326      */
327     function renounceOwnership(uint8 i) public onlyOwner {
328         require(i < _owners.length);
329         emit OwnershipTransferred(_owners[i], address(0));
330         _owners[i] = address(0);
331     }
332 
333     /**
334      * @dev Allows the current owner to transfer control of the contract to a newOwner.
335      * @param newOwner The address to transfer ownership to.
336      */
337     function transferOwnership(address newOwner, uint8 i) public onlyOwner {
338         _transferOwnership(newOwner, i);
339     }
340 
341     /**
342      * @dev Transfers control of the contract to a newOwner.
343      * @param newOwner The address to transfer ownership to.
344      */
345     function _transferOwnership(address newOwner, uint8 i) internal {
346         require(newOwner != address(0));
347         emit OwnershipTransferred(_owners[i], newOwner);
348         _owners[i] = newOwner;
349     }
350 }
351 
352 /**
353  * @title BasicToken
354  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
355  * Note they can later distribute these tokens as they wish using `transfer` and other
356  * `ERC20` functions.
357  */
358 contract BasicToken is ERC20, Ownable {
359     mapping(address => bool) public frozens;
360     
361     event Frozen(address indexed _address, bool _value);
362     
363     function transfer(address to, uint256 value) public returns (bool) {
364         require(frozens[to] == false);
365         return super.transfer(to, value);
366     }
367 
368     function transferFrom(address from, address to, uint256 value) public returns (bool) {
369         require(frozens[from] == false);
370         return super.transferFrom(from, to, value);
371     }
372     
373     function freeze(address[] memory _targets, bool _value) public onlyOwner {
374         require(_targets.length > 0);
375         require(_targets.length <= 255);
376         
377         for (uint8 i = 0; i < _targets.length; i++) {
378             address addressElement = _targets[i];
379             
380             assert(addressElement != address(0));
381             frozens[addressElement] = _value;
382             emit Frozen(addressElement, _value);
383         }
384     }
385 }
386 
387 contract UCToken is BasicToken {
388     uint8 public constant DECIMALS = 18;
389     string public name = "Unity Chain Token";
390     string public symbol = "UCT";
391     uint8 public decimals = DECIMALS;
392     
393     uint256 public constant INITIAL_FACTOR = (10 ** 6) * (10 ** uint256(DECIMALS));
394     
395     constructor() public {
396         _mint(0x490657f65380fe9e47ab46671B9CE7d02a06dF40, 1500 * INITIAL_FACTOR);
397         _mint(0xA0d5366E74E56Be39542BD6125897E30775C7bd8, 1500 * INITIAL_FACTOR);
398         _mint(0xfdE4884AD60012b80c1E57cCf4526d38746899a0, 250 * INITIAL_FACTOR);
399         _mint(0xf5Cfb87CAe4bC2D314D824De5B1B7a9F00Ef30Ee, 250 * INITIAL_FACTOR);
400         _mint(0xDdb844341f70DC7FB45Ca27E26cB5a131823AE74, 1000 * INITIAL_FACTOR);
401         
402         _mint(0x93e307CaCC969A6506E53F5Cb279f23D325d563d, 470573904 * (10 ** uint256(DECIMALS)));
403         _mint(0x2EAdc466b18bAb66369C52CF8F37DAf383F793a7, 29426096 * (10 ** uint256(DECIMALS)));
404     }
405 }