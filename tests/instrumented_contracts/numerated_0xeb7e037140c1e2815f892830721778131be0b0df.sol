1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface InterfaceERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error.
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two unsigned integers, reverts on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b);
43         return c;
44     }
45 
46     /**
47      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54         return c;
55     }
56 
57     /**
58      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b <= a);
62         uint256 c = a - b;
63         return c;
64     }
65 
66     /**
67      * @dev Adds two unsigned integers, reverts on overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a);
72         return c;
73     }
74 
75     /**
76      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77      * reverts when dividing by zero.
78      */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 
86 /**
87  * @title Standard ERC20 token
88  *
89  * @dev Implementation of the basic standard token.
90  * https://eips.ethereum.org/EIPS/eip-20
91  * Originally based on code by FirstBlood:
92  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  *
94  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
95  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
96  * compliant implementations may not do it.
97  */
98 contract ERC20 is InterfaceERC20 {
99     using SafeMath for uint256;
100 
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => mapping(address => uint256)) private _allowed;
104 
105     uint256 private _totalSupply;
106 
107     address private _manager;
108 
109 
110     function manager() public view returns (address) {
111         return _manager;
112     }
113 
114     /**
115      * @dev Total number of tokens in existence.
116      */
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     /**
122      * @dev Gets the balance of the specified address.
123      * @param owner The address to query the balance of.
124      * @return A uint256 representing the amount owned by the passed address.
125      */
126     function balanceOf(address owner) public view returns (uint256) {
127         return _balances[owner];
128     }
129 
130 
131     /**
132      * @dev Function to check the amount of tokens that an owner allowed to a spender.
133      * @param owner address The address which owns the funds.
134      * @param spender address The address which will spend the funds.
135      * @return A uint256 specifying the amount of tokens still available for the spender.
136      */
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowed[owner][spender];
139     }
140 
141     /**
142      * @dev Transfer token to a specified address.
143      * @param to The address to transfer to.
144      * @param value The amount to be transferred.
145      */
146     function transfer(address to, uint256 value) public isBalance(value) returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param spender The address which will spend the funds.
158      * @param value The amount of tokens to be spent.
159      */
160     function approve(address spender, uint256 value) public returns (bool) {
161         _approve(msg.sender, spender, value);
162         return true;
163     }
164 
165     /**
166      * @dev Transfer tokens from one address to another.
167      * Note that while this function emits an Approval event, this is not required as per the specification,
168      * and other compliant implementations may not emit the event.
169      * @param from address The address which you want to send tokens from
170      * @param to address The address which you want to transfer to
171      * @param value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(address from, address to, uint256 value) public returns (bool){
174         _transfer(from, to, value);
175         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
191         return true;
192     }
193 
194     /**
195      * @dev Decrease the amount of tokens that an owner allowed to a spender.
196      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param subtractedValue The amount of tokens to decrease the allowance by.
203      */
204     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
205         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
206         return true;
207     }
208 
209     function mint(uint256 value) public onlyOwner returns (bool) {
210         _totalSupply = _totalSupply.add(value);
211         _balances[_manager] = _balances[_manager].add(value);
212         emit Transfer(address(0), _manager, value);
213         return true;
214     }
215     
216     function setManager(address account) onlyOwner public {
217         require(account != address(0));
218         _manager = account;
219     }
220 
221     /**
222      * @dev Transfer token for a specified addresses.
223      * @param from The address to transfer from.
224      * @param to The address to transfer to.
225      * @param value The amount to be transferred.
226      */
227     function _transfer(address from, address to, uint256 value) internal  {
228         require(to != address(0));
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
241     function _mintInit(address account, uint256 value) internal {
242         require(account != address(0));
243         _totalSupply = _totalSupply.add(value);
244         _balances[account] = _balances[account].add(value);
245 
246         _manager = account;
247         emit Transfer(address(0), account, value);
248     }
249 
250     /**
251      * @dev Approve an address to spend another addresses' tokens.
252      * @param owner The address that owns the tokens.
253      * @param spender The address that will spend the tokens.
254      * @param value The number of tokens that can be spent.
255      */
256     function _approve(address owner, address spender, uint256 value) internal {
257         require(spender != address(0));
258         require(owner != address(0));
259 
260         _allowed[owner][spender] = value;
261         emit Approval(owner, spender, value);
262     }
263 
264     modifier onlyOwner {
265         require(_manager == msg.sender);
266         _;
267     }
268 
269     modifier isBalance (uint256 value) {
270         require (_balances[msg.sender] >= value && value > 0);
271         _;
272     }
273 
274 }
275 
276 /**
277  * @title ERC20Detailed token
278  * @dev The decimals are only for visualization purposes.
279  * All the operations are done using the smallest and indivisible token unit,
280  * just as on Ethereum all the operations are done in wei.
281  */
282 contract ERC20Detailed is InterfaceERC20 {
283     string private _name;
284     string private _symbol;
285     uint8 private _decimals;
286 
287     constructor (string memory name, string memory symbol, uint8 decimals) public {
288         _name = name;
289         _symbol = symbol;
290         _decimals = decimals;
291     }
292 
293     /**
294      * @return the name of the token.
295      */
296     function name() public view returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @return the symbol of the token.
302      */
303     function symbol() public view returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @return the number of decimals of the token.
309      */
310     function decimals() public view returns (uint8) {
311         return _decimals;
312     }
313 }
314 
315 contract WCDS is ERC20, ERC20Detailed {
316     constructor(string memory name, string memory symbol, uint8 decimals) ERC20Detailed(name, symbol, decimals) ERC20() public {
317         _mintInit(msg.sender, 21000000* (10 ** 18));
318     }
319 }