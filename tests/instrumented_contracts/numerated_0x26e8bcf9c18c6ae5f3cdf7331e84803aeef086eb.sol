1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-15
3 */
4 
5 pragma solidity ^0.5.2;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Unsigned math operations with safety checks that revert on error
11  */
12 library SafeMath {
13     /**
14      * @dev Multiplies two unsigned integers, reverts on overflow.
15      */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b);
26 
27         return c;
28     }
29 
30     /**
31      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
32      */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39         return c;
40     }
41 
42     /**
43      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Adds two unsigned integers, reverts on overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a);
58 
59         return c;
60     }
61 
62     /**
63      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
64      * reverts when dividing by zero.
65      */
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b != 0);
68         return a % b;
69     }
70 }
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://eips.ethereum.org/EIPS/eip-20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * https://eips.ethereum.org/EIPS/eip-20
101  * Originally based on code by FirstBlood:
102  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  *
104  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
105  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
106  * compliant implementations may not do it.
107  */
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowed;
114 
115     uint256 private _totalSupply;
116 
117     /**
118      * @dev Total number of tokens in existence
119      */
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125      * @dev Gets the balance of the specified address.
126      * @param owner The address to query the balance of.
127      * @return A uint256 representing the amount owned by the passed address.
128      */
129     function balanceOf(address owner) public view returns (uint256) {
130         return _balances[owner];
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param owner address The address which owns the funds.
136      * @param spender address The address which will spend the funds.
137      * @return A uint256 specifying the amount of tokens still available for the spender.
138      */
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowed[owner][spender];
141     }
142 
143     /**
144      * @dev Transfer token to a specified address
145      * @param to The address to transfer to.
146      * @param value The amount to be transferred.
147      */
148     function transfer(address to, uint256 value) public returns (bool) {
149         _transfer(msg.sender, to, value);
150         return true;
151     }
152 
153     /**
154      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155      * Beware that changing an allowance with this method brings the risk that someone may use both the old
156      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      * @param spender The address which will spend the funds.
160      * @param value The amount of tokens to be spent.
161      */
162     function approve(address spender, uint256 value) public returns (bool) {
163         _approve(msg.sender, spender, value);
164         return true;
165     }
166 
167     /**
168      * @dev Transfer tokens from one address to another.
169      * Note that while this function emits an Approval event, this is not required as per the specification,
170      * and other compliant implementations may not emit the event.
171      * @param from address The address which you want to send tokens from
172      * @param to address The address which you want to transfer to
173      * @param value uint256 the amount of tokens to be transferred
174      */
175     function transferFrom(address from, address to, uint256 value) public returns (bool) {
176         _transfer(from, to, value);
177         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
178         return true;
179     }
180 
181     /**
182      * @dev Increase the amount of tokens that an owner allowed to a spender.
183      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * Emits an Approval event.
188      * @param spender The address which will spend the funds.
189      * @param addedValue The amount of tokens to increase the allowance by.
190      */
191     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
192         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
193         return true;
194     }
195 
196     /**
197      * @dev Decrease the amount of tokens that an owner allowed to a spender.
198      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * Emits an Approval event.
203      * @param spender The address which will spend the funds.
204      * @param subtractedValue The amount of tokens to decrease the allowance by.
205      */
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
207         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
208         return true;
209     }
210 
211     /**
212      * @dev Transfer token for a specified addresses
213      * @param from The address to transfer from.
214      * @param to The address to transfer to.
215      * @param value The amount to be transferred.
216      */
217     function _transfer(address from, address to, uint256 value) internal {
218         require(to != address(0));
219 
220         _balances[from] = _balances[from].sub(value);
221         _balances[to] = _balances[to].add(value);
222         emit Transfer(from, to, value);
223     }
224 
225     /**
226      * @dev Internal function that mints an amount of the token and assigns it to
227      * an account. This encapsulates the modification of balances such that the
228      * proper events are emitted.
229      * @param account The account that will receive the created tokens.
230      * @param value The amount that will be created.
231      */
232     function _mint(address account, uint256 value) internal {
233         require(account != address(0));
234 
235         _totalSupply = _totalSupply.add(value);
236         _balances[account] = _balances[account].add(value);
237         emit Transfer(address(0), account, value);
238     }
239 
240     /**
241      * @dev Internal function that burns an amount of the token of a given
242      * account.
243      * @param account The account whose tokens will be burnt.
244      * @param value The amount that will be burnt.
245      */
246     function _burn(address account, uint256 value) internal {
247         require(account != address(0));
248 
249         _totalSupply = _totalSupply.sub(value);
250         _balances[account] = _balances[account].sub(value);
251         emit Transfer(account, address(0), value);
252     }
253 
254     /**
255      * @dev Approve an address to spend another addresses' tokens.
256      * @param owner The address that owns the tokens.
257      * @param spender The address that will spend the tokens.
258      * @param value The number of tokens that can be spent.
259      */
260     function _approve(address owner, address spender, uint256 value) internal {
261         require(spender != address(0));
262         require(owner != address(0));
263 
264         _allowed[owner][spender] = value;
265         emit Approval(owner, spender, value);
266     }
267 
268     /**
269      * @dev Internal function that burns an amount of the token of a given
270      * account, deducting from the sender's allowance for said account. Uses the
271      * internal burn function.
272      * Emits an Approval event (reflecting the reduced allowance).
273      * @param account The account whose tokens will be burnt.
274      * @param value The amount that will be burnt.
275      */
276     function _burnFrom(address account, uint256 value) internal {
277         _burn(account, value);
278         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
279     }
280 }
281 
282 
283 contract ERC20Detailed is IERC20 {
284     string private _name;
285     string private _symbol;
286     uint8 private _decimals;
287 
288     constructor (string memory name, string memory symbol, uint8 decimals) public {
289         _name = name;
290         _symbol = symbol;
291         _decimals = decimals;
292     }
293 
294     /**
295      * @return the name of the token.
296      */
297     function name() public view returns (string memory) {
298         return _name;
299     }
300 
301     /**
302      * @return the symbol of the token.
303      */
304     function symbol() public view returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @return the number of decimals of the token.
310      */
311     function decimals() public view returns (uint8) {
312         return _decimals;
313     }
314 }
315 
316 
317 contract USDM is ERC20, ERC20Detailed {
318     string private _name = "USDM";
319     string private _symbol = "USDM";
320     uint8 private _decimals = 18;
321     uint256 public initialSupply = 500000000 * (10 ** uint256(_decimals));
322    
323     constructor() public ERC20Detailed(_name, _symbol, _decimals) {
324         _mint(msg.sender, initialSupply);
325     }
326 }