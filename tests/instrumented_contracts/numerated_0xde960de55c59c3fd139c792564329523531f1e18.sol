1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
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
41 
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44 
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0, "SafeMath: division by zero");
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a, "SafeMath: subtraction overflow");
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82      * reverts when dividing by zero.
83      */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0, "SafeMath: modulo by zero");
86         return a % b;
87     }
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * https://eips.ethereum.org/EIPS/eip-20
95  * Originally based on code by FirstBlood:
96  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  *
98  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
99  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
100  * compliant implementations may not do it.
101  */
102 contract ERC20 is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowed;
108 
109     uint256 private _totalSupply;
110 
111     /**
112      * @dev Total number of tokens in existence.
113      */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119      * @dev Gets the balance of the specified address.
120      * @param owner The address to query the balance of.
121      * @return A uint256 representing the amount owned by the passed address.
122      */
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens that an owner allowed to a spender.
129      * @param owner address The address which owns the funds.
130      * @param spender address The address which will spend the funds.
131      * @return A uint256 specifying the amount of tokens still available for the spender.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138      * @dev Transfer token to a specified address.
139      * @param to The address to transfer to.
140      * @param value The amount to be transferred.
141      */
142     function transfer(address to, uint256 value) public returns (bool) {
143         _transfer(msg.sender, to, value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param spender The address which will spend the funds.
154      * @param value The amount of tokens to be spent.
155      */
156     function approve(address spender, uint256 value) public returns (bool) {
157         _approve(msg.sender, spender, value);
158         return true;
159     }
160 
161     /**
162      * @dev Transfer tokens from one address to another.
163      * Note that while this function emits an Approval event, this is not required as per the specification,
164      * and other compliant implementations may not emit the event.
165      * @param from address The address which you want to send tokens from
166      * @param to address The address which you want to transfer to
167      * @param value uint256 the amount of tokens to be transferred
168      */
169     function transferFrom(address from, address to, uint256 value) public returns (bool) {
170         _transfer(from, to, value);
171         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
172         return true;
173     }
174 
175     /**
176      * @dev Increase the amount of tokens that an owner allowed to a spender.
177      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
178      * allowed value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      * Emits an Approval event.
182      * @param spender The address which will spend the funds.
183      * @param addedValue The amount of tokens to increase the allowance by.
184      */
185     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
186         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
187         return true;
188     }
189 
190     /**
191      * @dev Decrease the amount of tokens that an owner allowed to a spender.
192      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param subtractedValue The amount of tokens to decrease the allowance by.
199      */
200     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
201         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
202         return true;
203     }
204 
205     /**
206      * @dev Transfer token for a specified addresses.
207      * @param from The address to transfer from.
208      * @param to The address to transfer to.
209      * @param value The amount to be transferred.
210      */
211     function _transfer(address from, address to, uint256 value) internal {
212         require(to != address(0), "ERC20: transfer to the zero address");
213 
214         _balances[from] = _balances[from].sub(value);
215         _balances[to] = _balances[to].add(value);
216         emit Transfer(from, to, value);
217     }
218 
219     /**
220      * @dev Internal function that mints an amount of the token and assigns it to
221      * an account. This encapsulates the modification of balances such that the
222      * proper events are emitted.
223      * @param account The account that will receive the created tokens.
224      * @param value The amount that will be created.
225      */
226     function _mint(address account, uint256 value) internal {
227         require(account != address(0), "ERC20: mint to the zero address");
228 
229         _totalSupply = _totalSupply.add(value);
230         _balances[account] = _balances[account].add(value);
231         emit Transfer(address(0), account, value);
232     }
233 
234     /**
235      * @dev Internal function that burns an amount of the token of a given
236      * account.
237      * @param account The account whose tokens will be burnt.
238      * @param value The amount that will be burnt.
239      */
240     function _burn(address account, uint256 value) internal {
241         require(account != address(0), "ERC20: burn from the zero address");
242 
243         _totalSupply = _totalSupply.sub(value);
244         _balances[account] = _balances[account].sub(value);
245         emit Transfer(account, address(0), value);
246     }
247 
248     /**
249      * @dev Approve an address to spend another addresses' tokens.
250      * @param owner The address that owns the tokens.
251      * @param spender The address that will spend the tokens.
252      * @param value The number of tokens that can be spent.
253      */
254     function _approve(address owner, address spender, uint256 value) internal {
255         require(owner != address(0), "ERC20: approve from the zero address");
256         require(spender != address(0), "ERC20: approve to the zero address");
257 
258         _allowed[owner][spender] = value;
259         emit Approval(owner, spender, value);
260     }
261 
262     /**
263      * @dev Internal function that burns an amount of the token of a given
264      * account, deducting from the sender's allowance for said account. Uses the
265      * internal burn function.
266      * Emits an Approval event (reflecting the reduced allowance).
267      * @param account The account whose tokens will be burnt.
268      * @param value The amount that will be burnt.
269      */
270     function _burnFrom(address account, uint256 value) internal {
271         _burn(account, value);
272         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
273     }
274 }
275 
276 
277 contract RookieCoinX is ERC20 {
278     string public name = "RookieCoinX";
279     string public symbol = "RKCX";
280     uint public decimals = 16;
281     uint public INITIAL_SUPPLY = 7500000 * (10 ** decimals);
282     constructor() public {
283         _mint(msg.sender, INITIAL_SUPPLY);
284     }
285 }