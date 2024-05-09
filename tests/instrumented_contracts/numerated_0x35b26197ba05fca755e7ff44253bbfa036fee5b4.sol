1 pragma solidity ^0.5.8;
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
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     constructor () internal {
83         _owner = msg.sender;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86 
87     /**
88      * @return the address of the owner.
89      */
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if called by any account other than the owner.
96      */
97     modifier onlyOwner() {
98         require(isOwner());
99         _;
100     }
101 
102     /**
103      * @return true if `msg.sender` is the owner of the contract.
104      */
105     function isOwner() public view returns (bool) {
106         return msg.sender == _owner;
107     }
108 
109     /**
110      * @dev Allows the current owner to relinquish control of the contract.
111      * It will not be possible to call the functions with the `onlyOwner`
112      * modifier anymore.
113      * @notice Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 
121     /**
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferOwnership(address newOwner) public onlyOwner {
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers control of the contract to a newOwner.
131      * @param newOwner The address to transfer ownership to.
132      */
133     function _transferOwnership(address newOwner) internal {
134         require(newOwner != address(0));
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://eips.ethereum.org/EIPS/eip-20
143  */
144 interface IERC20 {
145     function transfer(address to, uint256 value) external returns (bool);
146 
147     function approve(address spender, uint256 value) external returns (bool);
148 
149     function transferFrom(address from, address to, uint256 value) external returns (bool);
150 
151     function totalSupply() external view returns (uint256);
152 
153     function balanceOf(address who) external view returns (uint256);
154 
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * https://eips.ethereum.org/EIPS/eip-20
167  * Originally based on code by FirstBlood:
168  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  *
170  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
171  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
172  * compliant implementations may not do it.
173  */
174 contract ERC20 is IERC20, Ownable {
175     using SafeMath for uint256;
176 
177     mapping (address => uint256) private _balances;
178 
179     mapping (address => mapping (address => uint256)) private _allowed;
180 
181     uint256 private _totalSupply;
182 
183     /**
184      * @dev Total number of tokens in existence
185      */
186     function totalSupply() public view returns (uint256) {
187         return _totalSupply;
188     }
189 
190     /**
191      * @dev Gets the balance of the specified address.
192      * @param owner The address to query the balance of.
193      * @return A uint256 representing the amount owned by the passed address.
194      */
195     function balanceOf(address owner) public view returns (uint256) {
196         return _balances[owner];
197     }
198 
199     /**
200      * @dev Function to check the amount of tokens that an owner allowed to a spender.
201      * @param owner address The address which owns the funds.
202      * @param spender address The address which will spend the funds.
203      * @return A uint256 specifying the amount of tokens still available for the spender.
204      */
205     function allowance(address owner, address spender) public view returns (uint256) {
206         return _allowed[owner][spender];
207     }
208 
209     /**
210      * @dev Transfer token to a specified address
211      * @param to The address to transfer to.
212      * @param value The amount to be transferred.
213      */
214     function transfer(address to, uint256 value) public returns (bool) {
215         _transfer(msg.sender, to, value);
216         return true;
217     }
218 
219     /**
220      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221      * Beware that changing an allowance with this method brings the risk that someone may use both the old
222      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225      * @param spender The address which will spend the funds.
226      * @param value The amount of tokens to be spent.
227      */
228     function approve(address spender, uint256 value) public returns (bool) {
229         _approve(msg.sender, spender, value);
230         return true;
231     }
232 
233     /**
234      * @dev Transfer tokens from one address to another.
235      * Note that while this function emits an Approval event, this is not required as per the specification,
236      * and other compliant implementations may not emit the event.
237      * @param from address The address which you want to send tokens from
238      * @param to address The address which you want to transfer to
239      * @param value uint256 the amount of tokens to be transferred
240      */
241     function transferFrom(address from, address to, uint256 value) public returns (bool) {
242         _transfer(from, to, value);
243         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
244         return true;
245     }
246 
247     /**
248      * @dev Increase the amount of tokens that an owner allowed to a spender.
249      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * Emits an Approval event.
254      * @param spender The address which will spend the funds.
255      * @param addedValue The amount of tokens to increase the allowance by.
256      */
257     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
258         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
259         return true;
260     }
261 
262     /**
263      * @dev Decrease the amount of tokens that an owner allowed to a spender.
264      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * Emits an Approval event.
269      * @param spender The address which will spend the funds.
270      * @param subtractedValue The amount of tokens to decrease the allowance by.
271      */
272     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
273         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
274         return true;
275     }
276 
277     /**
278      * @dev Transfer token for a specified addresses
279      * @param from The address to transfer from.
280      * @param to The address to transfer to.
281      * @param value The amount to be transferred.
282      */
283     function _transfer(address from, address to, uint256 value) internal {
284         require(to != address(0));
285 
286         _balances[from] = _balances[from].sub(value);
287         _balances[to] = _balances[to].add(value);
288         emit Transfer(from, to, value);
289     }
290 
291     /**
292      * @dev Internal function that mints an amount of the token and assigns it to
293      * an account. This encapsulates the modification of balances such that the
294      * proper events are emitted.
295      * @param account The account that will receive the created tokens.
296      * @param value The amount that will be created.
297      */
298     function _mint(address account, uint256 value) internal {
299         require(account != address(0));
300 
301         _totalSupply = _totalSupply.add(value);
302         _balances[account] = _balances[account].add(value);
303         emit Transfer(address(0), account, value);
304     }
305 
306     /**
307      * @dev Internal function that burns an amount of the token of a given
308      * account.
309      * @param account The account whose tokens will be burnt.
310      * @param value The amount that will be burnt.
311      */
312     function _burn(address account, uint256 value) internal {
313         require(account != address(0));
314 
315         _totalSupply = _totalSupply.sub(value);
316         _balances[account] = _balances[account].sub(value);
317         emit Transfer(account, address(0), value);
318     }
319 
320     /**
321      * @dev Approve an address to spend another addresses' tokens.
322      * @param owner The address that owns the tokens.
323      * @param spender The address that will spend the tokens.
324      * @param value The number of tokens that can be spent.
325      */
326     function _approve(address owner, address spender, uint256 value) internal {
327         require(spender != address(0));
328         require(owner != address(0));
329 
330         _allowed[owner][spender] = value;
331         emit Approval(owner, spender, value);
332     }
333 
334     /**
335      * @dev Internal function that burns an amount of the token of a given
336      * account, deducting from the sender's allowance for said account. Uses the
337      * internal burn function.
338      * Emits an Approval event (reflecting the reduced allowance).
339      * @param account The account whose tokens will be burnt.
340      * @param value The amount that will be burnt.
341      */
342     function _burnFrom(address account, uint256 value) internal {
343         _burn(account, value);
344         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
345     }
346 }
347 
348 /**
349  * @title Burnable Token
350  * @dev Token that can be irreversibly burned (destroyed).
351  */
352 contract ERC20Burnable is ERC20 {
353     /**
354      * @dev Burns a specific amount of tokens.
355      * @param value The amount of token to be burned.
356      */
357     function burn(uint256 value) public {
358         _burn(msg.sender, value);
359     }
360 
361     /**
362      * @dev Burns a specific amount of tokens from the target address and decrements allowance
363      * @param from address The account whose tokens will be burned.
364      * @param value uint256 The amount of token to be burned.
365      */
366     function burnFrom(address from, uint256 value) public {
367         _burnFrom(from, value);
368     }
369 }
370 
371 /**
372  * @title ERC20Mintable
373  * @dev ERC20 minting logic
374  */
375 contract ERC20Mintable is ERC20 {
376     /**
377      * @dev Function to mint tokens
378      * @param to The address that will receive the minted tokens.
379      * @param value The amount of tokens to mint.
380      * @return A boolean that indicates if the operation was successful.
381      */
382     function mint(address to, uint256 value) public onlyOwner returns (bool) {
383         _mint(to, value);
384         return true;
385     }
386 }
387 
388 interface tokenRecipient { 
389     function receiveApproval(address _from, uint256 _value, bytes calldata _extraData) external;
390 }
391 
392 contract BFECoin is ERC20Mintable, ERC20Burnable {
393     string public constant name = "BFE Coin";
394     string public constant symbol = "BFE";
395     uint256 public constant decimals = 18;
396 
397     // there is no problem in using * here instead of .mul()
398     uint256 public initialSupply = 100000000 * (10 ** decimals);
399 
400     constructor () public {
401         _mint(msg.sender, initialSupply);
402     }
403 
404     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
405         external
406         returns (bool success) 
407     {
408         tokenRecipient spender = tokenRecipient(_spender);
409         if (approve(_spender, _value)) {
410             spender.receiveApproval(msg.sender, _value, _extraData);
411             return true;
412         }
413     }
414 }