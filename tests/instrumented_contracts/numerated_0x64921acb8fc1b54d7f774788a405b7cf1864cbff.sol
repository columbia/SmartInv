1 pragma solidity 0.5.6;
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
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://eips.ethereum.org/EIPS/eip-20
144  */
145 interface IERC20 {
146     function transfer(address to, uint256 value) external returns (bool);
147 
148     function approve(address spender, uint256 value) external returns (bool);
149 
150     function transferFrom(address from, address to, uint256 value) external returns (bool);
151 
152     function totalSupply() external view returns (uint256);
153 
154     function balanceOf(address who) external view returns (uint256);
155 
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * https://eips.ethereum.org/EIPS/eip-20
168  * Originally based on code by FirstBlood:
169  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  *
171  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
172  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
173  * compliant implementations may not do it.
174  */
175 contract ERC20 is IERC20, Ownable {
176     using SafeMath for uint256;
177 
178     mapping (address => uint256) private _balances;
179 
180     mapping (address => mapping (address => uint256)) private _allowed;
181 
182     uint256 private _totalSupply;
183 
184     /**
185      * @dev Total number of tokens in existence
186      */
187     function totalSupply() public view returns (uint256) {
188         return _totalSupply;
189     }
190 
191     /**
192      * @dev Gets the balance of the specified address.
193      * @param owner The address to query the balance of.
194      * @return A uint256 representing the amount owned by the passed address.
195      */
196     function balanceOf(address owner) public view returns (uint256) {
197         return _balances[owner];
198     }
199 
200     /**
201      * @dev Function to check the amount of tokens that an owner allowed to a spender.
202      * @param owner address The address which owns the funds.
203      * @param spender address The address which will spend the funds.
204      * @return A uint256 specifying the amount of tokens still available for the spender.
205      */
206     function allowance(address owner, address spender) public view returns (uint256) {
207         return _allowed[owner][spender];
208     }
209 
210     /**
211      * @dev Transfer token to a specified address
212      * @param to The address to transfer to.
213      * @param value The amount to be transferred.
214      */
215     function transfer(address to, uint256 value) public returns (bool) {
216         _transfer(msg.sender, to, value);
217         return true;
218     }
219 
220     /**
221      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222      * Beware that changing an allowance with this method brings the risk that someone may use both the old
223      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226      * @param spender The address which will spend the funds.
227      * @param value The amount of tokens to be spent.
228      */
229     function approve(address spender, uint256 value) public returns (bool) {
230         _approve(msg.sender, spender, value);
231         return true;
232     }
233 
234 
235     /**
236      * @dev Transfer tokens from one address to another.
237      * Note that while this function emits an Approval event, this is not required as per the specification,
238      * and other compliant implementations may not emit the event.
239      * @param from address The address which you want to send tokens from
240      * @param to address The address which you want to transfer to
241      * @param value uint256 the amount of tokens to be transferred
242      */
243     function transferFrom(address from, address to, uint256 value) public returns (bool) {
244         _transfer(from, to, value);
245         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
246         return true;
247     }
248 
249     /**
250      * @dev Increase the amount of tokens that an owner allowed to a spender.
251      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * Emits an Approval event.
256      * @param spender The address which will spend the funds.
257      * @param addedValue The amount of tokens to increase the allowance by.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
260         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
261         return true;
262     }
263 
264     /**
265      * @dev Decrease the amount of tokens that an owner allowed to a spender.
266      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
267      * allowed value is better to use this function to avoid 2 calls (and wait until
268      * the first transaction is mined)
269      * From MonolithDAO Token.sol
270      * Emits an Approval event.
271      * @param spender The address which will spend the funds.
272      * @param subtractedValue The amount of tokens to decrease the allowance by.
273      */
274     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
275         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
276         return true;
277     }
278 
279     /**
280      * @dev Transfer token for a specified addresses
281      * @param from The address to transfer from.
282      * @param to The address to transfer to.
283      * @param value The amount to be transferred.
284      */
285     function _transfer(address from, address to, uint256 value) internal {
286         require(to != address(0));
287 
288         _balances[from] = _balances[from].sub(value);
289         _balances[to] = _balances[to].add(value);
290         emit Transfer(from, to, value);
291     }
292 
293     /**
294      * @dev Internal function that mints an amount of the token and assigns it to
295      * an account. This encapsulates the modification of balances such that the
296      * proper events are emitted.
297      * @param account The account that will receive the created tokens.
298      * @param value The amount that will be created.
299      */
300     function _mint(address account, uint256 value) internal {
301         require(account != address(0));
302 
303         _totalSupply = _totalSupply.add(value);
304         _balances[account] = _balances[account].add(value);
305         emit Transfer(address(0), account, value);
306     }
307 
308     /**
309      * @dev Internal function that burns an amount of the token of a given
310      * account.
311      * @param account The account whose tokens will be burnt.
312      * @param value The amount that will be burnt.
313      */
314     function _burn(address account, uint256 value) internal {
315         require(account != address(0));
316 
317         _totalSupply = _totalSupply.sub(value);
318         _balances[account] = _balances[account].sub(value);
319         emit Transfer(account, address(0), value);
320     }
321 
322 
323     /**
324      * @dev Approve an address to spend another addresses' tokens.
325      * @param owner The address that owns the tokens.
326      * @param spender The address that will spend the tokens.
327      * @param value The number of tokens that can be spent.
328      */
329     function _approve(address owner, address spender, uint256 value) internal {
330         require(spender != address(0));
331         require(owner != address(0));
332 
333         _allowed[owner][spender] = value;
334         emit Approval(owner, spender, value);
335     }
336 
337     /**
338      * @dev Internal function that burns an amount of the token of a given
339      * account, deducting from the sender's allowance for said account. Uses the
340      * internal burn function.
341      * Emits an Approval event (reflecting the reduced allowance).
342      * @param account The account whose tokens will be burnt.
343      * @param value The amount that will be burnt.
344      */
345     function _burnFrom(address account, uint256 value) internal {
346         _burn(account, value);
347         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
348     }
349 }
350 
351 /**
352  * @title Burnable Token
353  * @dev Token that can be irreversibly burned (destroyed).
354  */
355 contract ERC20Burnable is ERC20 {
356     /**
357      * @dev Burns a specific amount of tokens.
358      * @param value The amount of token to be burned.
359      */
360     function burn(uint256 value) public {
361         _burn(msg.sender, value);
362     }
363 
364     /**
365      * @dev Burns a specific amount of tokens from the target address and decrements allowance
366      * @param from address The account whose tokens will be burned.
367      * @param value uint256 The amount of token to be burned.
368      */
369     function burnFrom(address from, uint256 value) public {
370         _burnFrom(from, value);
371     }
372 }
373 
374 /**
375  * @title ERC20Mintable
376  * @dev ERC20 minting logic
377  */
378 contract ERC20Mintable is ERC20 {
379     /**
380      * @dev Function to mint tokens
381      * @param to The address that will receive the minted tokens.
382      * @param value The amount of tokens to mint.
383      * @return A boolean that indicates if the operation was successful.
384      */
385     function mint(address to, uint256 value) public onlyOwner returns (bool) {
386         _mint(to, value);
387         return true;
388     }
389 }
390 
391 interface tokenRecipient { 
392     function receiveApproval(address _from, uint256 _value, bytes calldata _extraData) external;
393 }
394 
395 contract ADC is ERC20Mintable, ERC20Burnable {
396     string public constant name = "AFRICAN DIGITAL CURRENCY";
397     string public constant symbol = "ADC";
398     uint256 public constant decimals = 18;
399 
400     // there is no problem in using * here instead of .mul()
401     uint256 public initialSupply = 20000000000 * (10 ** decimals);
402 
403     constructor () public {
404         _mint(msg.sender, initialSupply);
405     }
406 
407     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
408         external
409         returns (bool success) 
410     {
411         tokenRecipient spender = tokenRecipient(_spender);
412         if (approve(_spender, _value)) {
413             spender.receiveApproval(msg.sender, _value, _extraData);
414             return true;
415         }
416     }
417 }