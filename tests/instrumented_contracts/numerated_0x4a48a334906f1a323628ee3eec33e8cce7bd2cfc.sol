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
67 /**
68  * @title ERC20 interface
69  * @dev see https://eips.ethereum.org/EIPS/eip-20
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
93  * https://eips.ethereum.org/EIPS/eip-20
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
120      * @return A uint256 representing the amount owned by the passed address.
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
137      * @dev Transfer token to a specified address
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
176      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
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
191      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
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
234      * @dev Approve an address to spend another addresses' tokens.
235      * @param owner The address that owns the tokens.
236      * @param spender The address that will spend the tokens.
237      * @param value The number of tokens that can be spent.
238      */
239     function _approve(address owner, address spender, uint256 value) internal {
240         require(spender != address(0));
241         require(owner != address(0));
242 
243         _allowed[owner][spender] = value;
244         emit Approval(owner, spender, value);
245     }
246 }
247 
248 /**
249  * @title MularPay ERC20 token smart contract
250  */
251 contract MularPay is ERC20 {
252     string private constant _name = "MularPay";
253     string private constant _symbol = "MP";
254     uint8 private constant _decimals = 18;
255 
256     /**
257      * @dev MularPay constructor method
258      */
259     constructor (address receiver) public {
260         //sending 1 bln tokens to the main wallet
261         //the number of tokens is fixed and cannot be minted in future
262         _mint(receiver, 1000000000 * 1 ether);
263     }
264 
265     /**
266      * @return the name of the token.
267      */
268     function name() public pure returns (string memory) {
269         return _name;
270     }
271 
272     /**
273      * @return the symbol of the token.
274      */
275     function symbol() public pure returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @return the number of decimals of the token.
281      */
282     function decimals() public pure returns (uint8) {
283         return _decimals;
284     }
285 }