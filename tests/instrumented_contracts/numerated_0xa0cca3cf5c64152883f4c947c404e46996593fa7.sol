1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-08
3 */
4 
5 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @title ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/20
12  */
13 interface IERC20 {
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address who) external view returns (uint256);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @title SafeMath
37  * @dev Unsigned math operations with safety checks that revert on error
38  */
39 library SafeMath {
40     /**
41      * @dev Multiplies two unsigned integers, reverts on overflow.
42      */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
59      */
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Solidity only automatically asserts when dividing by 0
62         require(b > 0);
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66         return c;
67     }
68 
69     /**
70      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         require(b <= a);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Adds two unsigned integers, reverts on overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a);
85 
86         return c;
87     }
88 
89     /**
90      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
91      * reverts when dividing by zero.
92      */
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b != 0);
95         return a % b;
96     }
97 }
98 
99 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
100 
101 pragma solidity ^0.5.0;
102 
103 
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
110  * Originally based on code by FirstBlood:
111  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  *
113  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
114  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
115  * compliant implementations may not do it.
116  */
117 contract ERC20 is IERC20 {
118     using SafeMath for uint256;
119 
120     mapping (address => uint256) private _balances;
121 
122     mapping (address => mapping (address => uint256)) private _allowed;
123 
124     uint256 private _totalSupply;
125 
126     /**
127      * @dev Total number of tokens in existence
128      */
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132 
133     /**
134      * @dev Gets the balance of the specified address.
135      * @param owner The address to query the balance of.
136      * @return An uint256 representing the amount owned by the passed address.
137      */
138     function balanceOf(address owner) public view returns (uint256) {
139         return _balances[owner];
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param owner address The address which owns the funds.
145      * @param spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address owner, address spender) public view returns (uint256) {
149         return _allowed[owner][spender];
150     }
151 
152     /**
153      * @dev Transfer token for a specified address
154      * @param to The address to transfer to.
155      * @param value The amount to be transferred.
156      */
157     function transfer(address to, uint256 value) public returns (bool) {
158         _transfer(msg.sender, to, value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param spender The address which will spend the funds.
169      * @param value The amount of tokens to be spent.
170      */
171     function approve(address spender, uint256 value) public returns (bool) {
172         _approve(msg.sender, spender, value);
173         return true;
174     }
175 
176     /**
177      * @dev Transfer tokens from one address to another.
178      * Note that while this function emits an Approval event, this is not required as per the specification,
179      * and other compliant implementations may not emit the event.
180      * @param from address The address which you want to send tokens from
181      * @param to address The address which you want to transfer to
182      * @param value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address from, address to, uint256 value) public returns (bool) {
185         _transfer(from, to, value);
186         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
202         return true;
203     }
204 
205     /**
206      * @dev Decrease the amount of tokens that an owner allowed to a spender.
207      * approve should be called when allowed_[_spender] == 0. To decrement
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      * Emits an Approval event.
212      * @param spender The address which will spend the funds.
213      * @param subtractedValue The amount of tokens to decrease the allowance by.
214      */
215     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
216         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
217         return true;
218     }
219 
220     /**
221      * @dev Transfer token for a specified addresses
222      * @param from The address to transfer from.
223      * @param to The address to transfer to.
224      * @param value The amount to be transferred.
225      */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Approve an address to spend another addresses' tokens.
265      * @param owner The address that owns the tokens.
266      * @param spender The address that will spend the tokens.
267      * @param value The number of tokens that can be spent.
268      */
269     function _approve(address owner, address spender, uint256 value) internal {
270         require(spender != address(0));
271         require(owner != address(0));
272 
273         _allowed[owner][spender] = value;
274         emit Approval(owner, spender, value);
275     }
276 
277     /**
278      * @dev Internal function that burns an amount of the token of a given
279      * account, deducting from the sender's allowance for said account. Uses the
280      * internal burn function.
281      * Emits an Approval event (reflecting the reduced allowance).
282      * @param account The account whose tokens will be burnt.
283      * @param value The amount that will be burnt.
284      */
285     function _burnFrom(address account, uint256 value) internal {
286         _burn(account, value);
287         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
288     }
289 }
290 
291 // File: contracts\ERC20\TokenMintERC20Token.sol
292 
293 pragma solidity ^0.5.0;
294 
295 
296 /**
297  * @title TokenMintERC20Token
298  * @author TokenMint (visit https://tokenmint.io)
299  *
300  * @dev Standard ERC20 token with optional functions implemented.
301  * For full specification of ERC-20 standard see:
302  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
303  */
304 contract TokenMintERC20Token is ERC20 {
305 
306     string private _name;
307     string private _symbol;
308     uint8 private _decimals;
309 
310     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
311       _name = name;
312       _symbol = symbol;
313       _decimals = decimals;
314 
315       // set tokenOwnerAddress as owner of all tokens
316       _mint(tokenOwnerAddress, totalSupply);
317 
318       // pay the service fee for contract deployment
319       feeReceiver.transfer(msg.value);
320     }
321 
322     // optional functions from ERC20 stardard
323 
324     /**
325      * @return the name of the token.
326      */
327     function name() public view returns (string memory) {
328       return _name;
329     }
330 
331     /**
332      * @return the symbol of the token.
333      */
334     function symbol() public view returns (string memory) {
335       return _symbol;
336     }
337 
338     /**
339      * @return the number of decimals of the token.
340      */
341     function decimals() public view returns (uint8) {
342       return _decimals;
343     }
344 }