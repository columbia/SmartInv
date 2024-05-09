1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
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
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two unsigned integers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two unsigned integers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
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
111     * @dev Total number of tokens in existence
112     */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param owner The address to query the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
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
137     * @dev Transfer token for a specified address
138     * @param to The address to transfer to.
139     * @param value The amount to be transferred.
140     */
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
156         require(spender != address(0));
157 
158         _allowed[msg.sender][spender] = value;
159         emit Approval(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from address The address which you want to send tokens from
168      * @param to address The address which you want to transfer to
169      * @param value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
173         _transfer(from, to, value);
174         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
175         return true;
176     }
177 
178     /**
179      * @dev Increase the amount of tokens that an owner allowed to a spender.
180      * approve should be called when allowed_[_spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param addedValue The amount of tokens to increase the allowance by.
187      */
188     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
189         require(spender != address(0));
190 
191         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
192         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
193         return true;
194     }
195 
196     /**
197      * @dev Decrease the amount of tokens that an owner allowed to a spender.
198      * approve should be called when allowed_[_spender] == 0. To decrement
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * Emits an Approval event.
203      * @param spender The address which will spend the funds.
204      * @param subtractedValue The amount of tokens to decrease the allowance by.
205      */
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
207         require(spender != address(0));
208 
209         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
210         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
211         return true;
212     }
213 
214     /**
215     * @dev Transfer token for a specified addresses
216     * @param from The address to transfer from.
217     * @param to The address to transfer to.
218     * @param value The amount to be transferred.
219     */
220     function _transfer(address from, address to, uint256 value) internal {
221         require(to != address(0));
222 
223         _balances[from] = _balances[from].sub(value);
224         _balances[to] = _balances[to].add(value);
225         emit Transfer(from, to, value);
226     }
227 
228     /**
229      * @dev Internal function that mints an amount of the token and assigns it to
230      * an account. This encapsulates the modification of balances such that the
231      * proper events are emitted.
232      * @param account The account that will receive the created tokens.
233      * @param value The amount that will be created.
234      */
235     function _mint(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.add(value);
239         _balances[account] = _balances[account].add(value);
240         emit Transfer(address(0), account, value);
241     }
242 
243     /**
244      * @dev Internal function that burns an amount of the token of a given
245      * account.
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burn(address account, uint256 value) internal {
250         require(account != address(0));
251 
252         _totalSupply = _totalSupply.sub(value);
253         _balances[account] = _balances[account].sub(value);
254         emit Transfer(account, address(0), value);
255     }
256 
257     /**
258      * @dev Internal function that burns an amount of the token of a given
259      * account, deducting from the sender's allowance for said account. Uses the
260      * internal burn function.
261      * Emits an Approval event (reflecting the reduced allowance).
262      * @param account The account whose tokens will be burnt.
263      * @param value The amount that will be burnt.
264      */
265     function _burnFrom(address account, uint256 value) internal {
266         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
267         _burn(account, value);
268         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
269     }
270 }
271 
272 contract BitherToken is ERC20 {
273 
274     string public name = "BitherToken";
275     string public symbol = "BTR";
276     uint256 public decimals = 18;
277 
278     constructor() public {
279         _mint(msg.sender, 47000000 * (10 ** decimals));
280     }
281 }