1 pragma solidity ^0.5.0;
2 
3 //
4 // Copyright (c) 2019 BOS Platform Foundation
5 //
6 // https://github.com/bpfkorea/bosagora-erc20
7 //
8 
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     /**
29      * @dev Multiplies two unsigned integers, reverts on overflow.
30      */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41 
42         return c;
43     }
44 
45     /**
46      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
47      */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0, "SafeMath: division by zero");
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54         return c;
55     }
56 
57     /**
58      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b <= a, "SafeMath: subtraction overflow");
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Adds two unsigned integers, reverts on overflow.
69      */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
79      * reverts when dividing by zero.
80      */
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b != 0, "SafeMath: modulo by zero");
83         return a % b;
84     }
85 }
86 
87 contract ERC20 is IERC20 {
88     using SafeMath for uint256;
89 
90     mapping (address => uint256) private _balances;
91 
92     mapping (address => mapping (address => uint256)) private _allowances;
93 
94     uint256 private _totalSupply;
95 
96     /**
97      * @dev Total number of tokens in existence.
98      */
99     function totalSupply() public view returns (uint256) {
100         return _totalSupply;
101     }
102 
103     /**
104      * @dev Gets the balance of the specified address.
105      * @param owner The address to query the balance of.
106      * @return A uint256 representing the amount owned by the passed address.
107      */
108     function balanceOf(address owner) public view returns (uint256) {
109         return _balances[owner];
110     }
111 
112     /**
113      * @dev Function to check the amount of tokens that an owner allowed to a spender.
114      * @param owner address The address which owns the funds.
115      * @param spender address The address which will spend the funds.
116      * @return A uint256 specifying the amount of tokens still available for the spender.
117      */
118     function allowance(address owner, address spender) public view returns (uint256) {
119         return _allowances[owner][spender];
120     }
121 
122     /**
123      * @dev Transfer token to a specified address.
124      * @param to The address to transfer to.
125      * @param value The amount to be transferred.
126      */
127     function transfer(address to, uint256 value) public returns (bool) {
128         _transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     /**
133      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param spender The address which will spend the funds.
139      * @param value The amount of tokens to be spent.
140      */
141     function approve(address spender, uint256 value) public returns (bool) {
142         _approve(msg.sender, spender, value);
143         return true;
144     }
145 
146     /**
147      * @dev Transfer tokens from one address to another.
148      * Note that while this function emits an Approval event, this is not required as per the specification,
149      * and other compliant implementations may not emit the event.
150      * @param from address The address which you want to send tokens from
151      * @param to address The address which you want to transfer to
152      * @param value uint256 the amount of tokens to be transferred
153      */
154     function transferFrom(address from, address to, uint256 value) public returns (bool) {
155         _transfer(from, to, value);
156         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
157         return true;
158     }
159 
160     /**
161      * @dev Increase the amount of tokens that an owner allowed to a spender.
162      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
163      * allowed value is better to use this function to avoid 2 calls (and wait until
164      * the first transaction is mined)
165      * From MonolithDAO Token.sol
166      * Emits an Approval event.
167      * @param spender The address which will spend the funds.
168      * @param addedValue The amount of tokens to increase the allowance by.
169      */
170     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
171         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
172         return true;
173     }
174 
175     /**
176      * @dev Decrease the amount of tokens that an owner allowed to a spender.
177      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
178      * allowed value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      * Emits an Approval event.
182      * @param spender The address which will spend the funds.
183      * @param subtractedValue The amount of tokens to decrease the allowance by.
184      */
185     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
186         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
187         return true;
188     }
189 
190     /**
191      * @dev Transfer token for a specified addresses.
192      * @param from The address to transfer from.
193      * @param to The address to transfer to.
194      * @param value The amount to be transferred.
195      */
196     function _transfer(address from, address to, uint256 value) internal {
197         require(to != address(0), "ERC20: transfer to the zero address");
198 
199         _balances[from] = _balances[from].sub(value);
200         _balances[to] = _balances[to].add(value);
201         emit Transfer(from, to, value);
202     }
203 
204     /**
205      * @dev Internal function that mints an amount of the token and assigns it to
206      * an account. This encapsulates the modification of balances such that the
207      * proper events are emitted.
208      * @param account The account that will receive the created tokens.
209      * @param value The amount that will be created.
210      */
211     function _mint(address account, uint256 value) internal {
212         require(account != address(0), "ERC20: mint to the zero address");
213 
214         _totalSupply = _totalSupply.add(value);
215         _balances[account] = _balances[account].add(value);
216         emit Transfer(address(0), account, value);
217     }
218 
219     /**
220      * @dev Internal function that burns an amount of the token of a given
221      * account.
222      * @param account The account whose tokens will be burnt.
223      * @param value The amount that will be burnt.
224      */
225     function _burn(address account, uint256 value) internal {
226         require(account != address(0), "ERC20: burn from the zero address");
227 
228         _totalSupply = _totalSupply.sub(value);
229         _balances[account] = _balances[account].sub(value);
230         emit Transfer(account, address(0), value);
231     }
232 
233     /**
234      * @dev Approve an address to spend another addresses' tokens.
235      * @param owner The address that owns the tokens.
236      * @param spender The address that will spend the tokens.
237      * @param value The number of tokens that can be spent.
238      */
239     function _approve(address owner, address spender, uint256 value) internal {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242 
243         _allowances[owner][spender] = value;
244         emit Approval(owner, spender, value);
245     }
246 
247     /**
248      * @dev Internal function that burns an amount of the token of a given
249      * account, deducting from the sender's allowance for said account. Uses the
250      * internal burn function.
251      * Emits an Approval event (reflecting the reduced allowance).
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burnFrom(address account, uint256 value) internal {
256         _burn(account, value);
257         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
258     }
259 }
260 
261 contract ERC20Detailed is IERC20 {
262     string private _name;
263     string private _symbol;
264     uint8 private _decimals;
265 
266     constructor (string memory name, string memory symbol, uint8 decimals) public {
267         _name = name;
268         _symbol = symbol;
269         _decimals = decimals;
270     }
271 
272     /**
273      * @return the name of the token.
274      */
275     function name() public view returns (string memory) {
276         return _name;
277     }
278 
279     /**
280      * @return the symbol of the token.
281      */
282     function symbol() public view returns (string memory) {
283         return _symbol;
284     }
285 
286     /**
287      * @return the number of decimals of the token.
288      */
289     function decimals() public view returns (uint8) {
290         return _decimals;
291     }
292 }
293 
294 contract BOSAGORA is ERC20, ERC20Detailed {
295     uint8 public constant DECIMALS = 7;
296     uint256 public constant INITIAL_SUPPLY = 5421301301958463;
297 
298     constructor () public ERC20Detailed("BOSAGORA", "BOA", DECIMALS) {
299         _mint(msg.sender, INITIAL_SUPPLY);
300     }
301 }