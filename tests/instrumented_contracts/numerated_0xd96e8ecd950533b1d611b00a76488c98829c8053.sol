1 pragma solidity ^0.5.2;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 /**
23  * @title Standard ERC20 token
24  *
25  * @dev Implementation of the basic standard token.
26  * https://eips.ethereum.org/EIPS/eip-20
27  * Originally based on code by FirstBlood:
28  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
29  *
30  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
31  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
32  * compliant implementations may not do it.
33  */
34 contract ERC20 is IERC20 {
35     using SafeMath for uint256;
36 
37     mapping (address => uint256) private _balances;
38 
39     mapping (address => mapping (address => uint256)) private _allowed;
40 
41     uint256 private _totalSupply;
42 
43     function totalSupply() public view returns (uint256) {
44         return _totalSupply;
45     }
46 
47     
48     function balanceOf(address owner) public view returns (uint256) {
49         return _balances[owner];
50     }
51 
52     /**
53      * @dev Function to check the amount of tokens that an owner allowed to a spender.
54      * @param owner address The address which owns the funds.
55      * @param spender address The address which will spend the funds.
56      * @return A uint256 specifying the amount of tokens still available for the spender.
57      */
58     function allowance(address owner, address spender) public view returns (uint256) {
59         return _allowed[owner][spender];
60     }
61 
62     /**
63      * @dev Transfer token to a specified address.
64      * @param to The address to transfer to.
65      * @param value The amount to be transferred.
66      */
67     function transfer(address to, uint256 value) public returns (bool) {
68         _transfer(msg.sender, to, value);
69         return true;
70     }
71 
72     /**
73      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
74      * Beware that changing an allowance with this method brings the risk that someone may use both the old
75      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
76      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      * @param spender The address which will spend the funds.
79      * @param value The amount of tokens to be spent.
80      */
81     function approve(address spender, uint256 value) public returns (bool) {
82         _approve(msg.sender, spender, value);
83         return true;
84     }
85 
86     /**
87      * @dev Transfer tokens from one address to another.
88      * Note that while this function emits an Approval event, this is not required as per the specification,
89      * and other compliant implementations may not emit the event.
90      * @param from address The address which you want to send tokens from
91      * @param to address The address which you want to transfer to
92      * @param value uint256 the amount of tokens to be transferred
93      */
94     function transferFrom(address from, address to, uint256 value) public returns (bool) {
95         _transfer(from, to, value);
96         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
97         return true;
98     }
99 
100     /**
101      * @dev Increase the amount of tokens that an owner allowed to a spender.
102      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
103      * allowed value is better to use this function to avoid 2 calls (and wait until
104      * the first transaction is mined)
105      * From MonolithDAO Token.sol
106      * Emits an Approval event.
107      * @param spender The address which will spend the funds.
108      * @param addedValue The amount of tokens to increase the allowance by.
109      */
110     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
111         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
112         return true;
113     }
114 
115     /**
116      * @dev Decrease the amount of tokens that an owner allowed to a spender.
117      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
118      * allowed value is better to use this function to avoid 2 calls (and wait until
119      * the first transaction is mined)
120      * From MonolithDAO Token.sol
121      * Emits an Approval event.
122      * @param spender The address which will spend the funds.
123      * @param subtractedValue The amount of tokens to decrease the allowance by.
124      */
125     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
126         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
127         return true;
128     }
129 
130     /**
131      * @dev Transfer token for a specified addresses.
132      * @param from The address to transfer from.
133      * @param to The address to transfer to.
134      * @param value The amount to be transferred.
135      */
136     function _transfer(address from, address to, uint256 value) internal {
137         require(to != address(0));
138 
139         _balances[from] = _balances[from].sub(value);
140         _balances[to] = _balances[to].add(value);
141         emit Transfer(from, to, value);
142     }
143 
144     /**
145      * @dev Internal function that mints an amount of the token and assigns it to
146      * an account. This encapsulates the modification of balances such that the
147      * proper events are emitted.
148      * @param account The account that will receive the created tokens.
149      * @param value The amount that will be created.
150      */
151     function _mint(address account, uint256 value) internal {
152         require(account != address(0));
153 
154         _totalSupply = _totalSupply.add(value);
155         _balances[account] = _balances[account].add(value);
156         emit Transfer(address(0), account, value);
157     }
158 
159     /**
160      * @dev Internal function that burns an amount of the token of a given
161      * account.
162      * @param account The account whose tokens will be burnt.
163      * @param value The amount that will be burnt.
164      */
165     function _burn(address account, uint256 value) internal {
166         require(account != address(0));
167 
168         _totalSupply = _totalSupply.sub(value);
169         _balances[account] = _balances[account].sub(value);
170         emit Transfer(account, address(0), value);
171     }
172 
173     /**
174      * @dev Approve an address to spend another addresses' tokens.
175      * @param owner The address that owns the tokens.
176      * @param spender The address that will spend the tokens.
177      * @param value The number of tokens that can be spent.
178      */
179     function _approve(address owner, address spender, uint256 value) internal {
180         require(spender != address(0));
181         require(owner != address(0));
182 
183         _allowed[owner][spender] = value;
184         emit Approval(owner, spender, value);
185     }
186 
187     /**
188      * @dev Internal function that burns an amount of the token of a given
189      * account, deducting from the sender's allowance for said account. Uses the
190      * internal burn function.
191      * Emits an Approval event (reflecting the reduced allowance).
192      * @param account The account whose tokens will be burnt.
193      * @param value The amount that will be burnt.
194      */
195     function _burnFrom(address account, uint256 value) internal {
196         _burn(account, value);
197         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
198     }
199 }
200 
201 
202 
203 /**
204  * @title Burnable Token
205  * @dev Token that can be irreversibly burned (destroyed).
206  */
207 contract ERC20Burnable is ERC20 {
208     /**
209      * @dev Burns a specific amount of tokens.
210      * @param value The amount of token to be burned.
211      */
212     function burn(uint256 value) public {
213         _burn(msg.sender, value);
214     }
215 
216     /**
217      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
218      * @param from address The account whose tokens will be burned.
219      * @param value uint256 The amount of token to be burned.
220      */
221     function burnFrom(address from, uint256 value) public {
222         _burnFrom(from, value);
223     }
224 }
225 
226 /**
227  * @title ERC20Detailed token
228  * @dev The decimals are only for visualization purposes.
229  * All the operations are done using the smallest and indivisible token unit,
230  * just as on Ethereum all the operations are done in wei.
231  */
232 contract ERC20Detailed is IERC20 {
233     string private _name;
234     string private _symbol;
235     uint8 private _decimals;
236 
237     constructor (string memory name, string memory symbol, uint8 decimals) public {
238         _name = name;
239         _symbol = symbol;
240         _decimals = decimals;
241     }
242 
243     /**
244      * @return the name of the token.
245      */
246     function name() public view returns (string memory) {
247         return _name;
248     }
249 
250     /**
251      * @return the symbol of the token.
252      */
253     function symbol() public view returns (string memory) {
254         return _symbol;
255     }
256 
257     /**
258      * @return the number of decimals of the token.
259      */
260     function decimals() public view returns (uint8) {
261         return _decimals;
262     }
263 }
264 
265 library SafeMath {
266     /**
267      * @dev Multiplies two unsigned integers, reverts on overflow.
268      */
269     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
270         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271         // benefit is lost if 'b' is also tested.
272         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
273         if (a == 0) {
274             return 0;
275         }
276 
277         uint256 c = a * b;
278         require(c / a == b);
279 
280         return c;
281     }
282 
283     /**
284      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
285      */
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         // Solidity only automatically asserts when dividing by 0
288         require(b > 0);
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291 
292         return c;
293     }
294 
295     /**
296      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
297      */
298     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
299         require(b <= a);
300         uint256 c = a - b;
301 
302         return c;
303     }
304 
305     /**
306      * @dev Adds two unsigned integers, reverts on overflow.
307      */
308     function add(uint256 a, uint256 b) internal pure returns (uint256) {
309         uint256 c = a + b;
310         require(c >= a);
311 
312         return c;
313     }
314 
315     /**
316      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
317      * reverts when dividing by zero.
318      */
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         require(b != 0);
321         return a % b;
322     }
323 }
324 
325 /**
326  * @title tranToken
327  * Note they can later distribute these tokens as they wish using `transfer` and other
328  * `ERC20` functions.
329  */
330 contract UCEToken is ERC20, ERC20Burnable, ERC20Detailed {
331     uint8 public constant DECIMALS = 18;
332     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS)); 
333 
334     /**
335      * @dev Constructor that gives msg.sender all of existing tokens.
336      */
337     constructor () public ERC20Detailed("uceToken", "UCE", 18) {
338         _mint(msg.sender, INITIAL_SUPPLY); 
339     }
340 }