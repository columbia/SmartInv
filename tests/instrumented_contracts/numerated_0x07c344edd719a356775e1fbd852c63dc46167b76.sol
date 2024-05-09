1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23     
24     event GeneratedToken(address indexed requester);
25 }
26 
27 /**
28  * @title ERC20 token with user-minting feature.
29  *
30  * @dev Implementation of the basic standard token.
31  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
32  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
33  */
34 contract ColumbusToken is IERC20 {
35     using SafeMath for uint256;
36 
37     mapping (address => uint256) private _balances;
38 
39     mapping (address => mapping (address => uint256)) private _allowed;
40     
41     mapping (address => bool) private _requested;
42 
43     uint256 private _totalSupply;
44     
45     string public constant name = "Columbus Token";
46     string public constant symbol = "CBUS";
47     // 18 Decimals is standard for ERC20
48     uint8 public constant decimals = 18;
49     // Columbus population 2018: 879,170
50     uint256 public constant max_supply = 879170 * 10**uint(decimals); 
51     
52     constructor() public {
53         _totalSupply = _tokens(1);
54         _balances[msg.sender] = _tokens(1);
55     }
56     
57     function getToken() public {
58         // Don't allow more tokens to be created than the maximum supply
59         require(_totalSupply < max_supply);
60         // Don't allow the requesting address to request more than one token.
61         require(_requested[msg.sender] == false);
62         
63         _requested[msg.sender] = true;
64         _balances[msg.sender] += _tokens(1);
65         _totalSupply += _tokens(1);
66         
67         emit GeneratedToken(msg.sender);
68     }
69     
70     function _tokens(uint256 token) internal pure returns (uint256) {
71         return token * 10**uint(decimals);
72     }
73     
74     /**
75     * @dev Total number of tokens in existence
76     */
77     function totalSupply() public view returns (uint256) {
78         return _totalSupply;
79     }
80 
81     /**
82     * @dev Gets the balance of the specified address.
83     * @param owner The address to query the balance of.
84     * @return An uint256 representing the amount owned by the passed address.
85     */
86     function balanceOf(address owner) public view returns (uint256) {
87         return _balances[owner];
88     }
89 
90     /**
91     * @dev Gets the balance of the caller's address.
92     * @return An uint256 representing the amount owned by the caller address.
93     */
94     function getBalance() public view returns (uint256) {
95         return balanceOf(msg.sender);
96     }
97 
98     /**
99      * @dev Function to check the amount of tokens that an owner allowed to a spender.
100      * @param owner address The address which owns the funds.
101      * @param spender address The address which will spend the funds.
102      * @return A uint256 specifying the amount of tokens still available for the spender.
103      */
104     function allowance(address owner, address spender) public view returns (uint256) {
105         return _allowed[owner][spender];
106     }
107 
108     /**
109     * @dev Transfer token for a specified address
110     * @param to The address to transfer to.
111     * @param value The amount to be transferred.
112     */
113     function transfer(address to, uint256 value) public returns (bool) {
114         _transfer(msg.sender, to, value);
115         return true;
116     }
117 
118     /**
119      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120      * Beware that changing an allowance with this method brings the risk that someone may use both the old
121      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      * @param spender The address which will spend the funds.
125      * @param value The amount of tokens to be spent.
126      */
127     function approve(address spender, uint256 value) public returns (bool) {
128         require(spender != address(0));
129 
130         _allowed[msg.sender][spender] = value;
131         emit Approval(msg.sender, spender, value);
132         return true;
133     }
134 
135     /**
136      * @dev Transfer tokens from one address to another
137      * @param from address The address which you want to send tokens from
138      * @param to address The address which you want to transfer to
139      * @param value uint256 the amount of tokens to be transferred
140      */
141     function transferFrom(address from, address to, uint256 value) public returns (bool) {
142         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
143         _transfer(from, to, value);
144         return true;
145     }
146 
147     /**
148      * @dev Increase the amount of tokens that an owner allowed to a spender.
149      * approve should be called when allowed_[_spender] == 0. To increment
150      * allowed value is better to use this function to avoid 2 calls (and wait until
151      * the first transaction is mined)
152      * From MonolithDAO Token.sol
153      * @param spender The address which will spend the funds.
154      * @param addedValue The amount of tokens to increase the allowance by.
155      */
156     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
157         require(spender != address(0));
158 
159         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
160         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
161         return true;
162     }
163 
164     /**
165      * @dev Decrease the amount of tokens that an owner allowed to a spender.
166      * approve should be called when allowed_[_spender] == 0. To decrement
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      * @param spender The address which will spend the funds.
171      * @param subtractedValue The amount of tokens to decrease the allowance by.
172      */
173     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
174         require(spender != address(0));
175 
176         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
177         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178         return true;
179     }
180 
181     /**
182     * @dev Transfer token for a specified addresses
183     * @param from The address to transfer from.
184     * @param to The address to transfer to.
185     * @param value The amount to be transferred.
186     */
187     function _transfer(address from, address to, uint256 value) internal {
188         require(to != address(0));
189 
190         _balances[from] = _balances[from].sub(value);
191         _balances[to] = _balances[to].add(value);
192         emit Transfer(from, to, value);
193     }
194 
195     /**
196      * @dev Internal function that mints an amount of the token and assigns it to
197      * an account. This encapsulates the modification of balances such that the
198      * proper events are emitted.
199      * @param account The account that will receive the created tokens.
200      * @param value The amount that will be created.
201      */
202     function _mint(address account, uint256 value) internal {
203         require(account != address(0));
204 
205         _totalSupply = _totalSupply.add(value);
206         _balances[account] = _balances[account].add(value);
207         emit Transfer(address(0), account, value);
208     }
209 
210     /**
211      * @dev Internal function that burns an amount of the token of a given
212      * account.
213      * @param account The account whose tokens will be burnt.
214      * @param value The amount that will be burnt.
215      */
216     function _burn(address account, uint256 value) internal {
217         require(account != address(0));
218 
219         _totalSupply = _totalSupply.sub(value);
220         _balances[account] = _balances[account].sub(value);
221         emit Transfer(account, address(0), value);
222     }
223 
224     /**
225      * @dev Internal function that burns an amount of the token of a given
226      * account, deducting from the sender's allowance for said account. Uses the
227      * internal burn function.
228      * @param account The account whose tokens will be burnt.
229      * @param value The amount that will be burnt.
230      */
231     function _burnFrom(address account, uint256 value) internal {
232         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
233         // this function needs to emit an event with the updated approval.
234         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
235         _burn(account, value);
236     }
237 }
238 
239 /**
240  * @title SafeMath
241  * @dev Math operations with safety checks that revert on error
242  */
243 library SafeMath {
244     /**
245     * @dev Multiplies two numbers, reverts on overflow.
246     */
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
249         // benefit is lost if 'b' is also tested.
250         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
251         if (a == 0) {
252             return 0;
253         }
254 
255         uint256 c = a * b;
256         require(c / a == b);
257 
258         return c;
259     }
260 
261     /**
262     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
263     */
264     function div(uint256 a, uint256 b) internal pure returns (uint256) {
265         // Solidity only automatically asserts when dividing by 0
266         require(b > 0);
267         uint256 c = a / b;
268         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
269 
270         return c;
271     }
272 
273     /**
274     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
275     */
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         require(b <= a);
278         uint256 c = a - b;
279 
280         return c;
281     }
282 
283     /**
284     * @dev Adds two numbers, reverts on overflow.
285     */
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         uint256 c = a + b;
288         require(c >= a);
289 
290         return c;
291     }
292 
293     /**
294     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
295     * reverts when dividing by zero.
296     */
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         require(b != 0);
299         return a % b;
300     }
301 }