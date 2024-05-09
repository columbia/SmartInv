1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address who) external view returns (uint256);
9 
10     function allowance(address owner, address spender)
11         external view returns (uint256);
12 
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value)
16         external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value)
19         external returns (bool);
20 
21     event Transfer(
22         address indexed from,
23         address indexed to,
24         uint256 value
25     );
26 
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 library SafeMath {
35 
36     /**
37     * @dev Multiplies two numbers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b > 0); // Solidity only automatically asserts when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     /**
65     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66     */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75     * @dev Adds two numbers, reverts on overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a);
80 
81         return c;
82     }
83 
84     /**
85     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
86     * reverts when dividing by zero.
87     */
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b != 0);
90         return a % b;
91     }
92 }
93 
94 contract ERC20 is IERC20 {
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) private _balances;
98 
99     mapping (address => mapping (address => uint256)) private _allowed;
100 
101     uint256 private _totalSupply;
102 
103     /**
104     * @dev Total number of tokens in existence
105     */
106     function totalSupply() public view returns (uint256) {
107         return _totalSupply;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param owner The address to query the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address owner) public view returns (uint256) {
116         return _balances[owner];
117     }
118 
119     /**
120      * @dev Function to check the amount of tokens that an owner allowed to a spender.
121      * @param owner address The address which owns the funds.
122      * @param spender address The address which will spend the funds.
123      * @return A uint256 specifying the amount of tokens still available for the spender.
124      */
125     function allowance(
126         address owner,
127         address spender
128      )
129         public
130         view
131         returns (uint256)
132     {
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
164      * @dev Transfer tokens from one address to another
165      * @param from address The address which you want to send tokens from
166      * @param to address The address which you want to transfer to
167      * @param value uint256 the amount of tokens to be transferred
168      */
169     function transferFrom(
170         address from,
171         address to,
172         uint256 value
173     )
174         public
175         returns (bool)
176     {
177         require(value <= _allowed[from][msg.sender]);
178 
179         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
180         _transfer(from, to, value);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param spender The address which will spend the funds.
191      * @param addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseAllowance(
194         address spender,
195         uint256 addedValue
196     )
197         public
198         returns (bool)
199     {
200         require(spender != address(0));
201 
202         _allowed[msg.sender][spender] = (
203             _allowed[msg.sender][spender].add(addedValue));
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * @param spender The address which will spend the funds.
215      * @param subtractedValue The amount of tokens to decrease the allowance by.
216      */
217     function decreaseAllowance(
218         address spender,
219         uint256 subtractedValue
220     )
221         public
222         returns (bool)
223     {
224         require(spender != address(0));
225 
226         _allowed[msg.sender][spender] = (
227             _allowed[msg.sender][spender].sub(subtractedValue));
228         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
229         return true;
230     }
231 
232     /**
233     * @dev Transfer token for a specified addresses
234     * @param from The address to transfer from.
235     * @param to The address to transfer to.
236     * @param value The amount to be transferred.
237     */
238     function _transfer(address from, address to, uint256 value) internal {
239         require(value <= _balances[from]);
240         require(to != address(0));
241 
242         _balances[from] = _balances[from].sub(value);
243         _balances[to] = _balances[to].add(value);
244         emit Transfer(from, to, value);
245     }
246 
247     /**
248      * @dev Internal function that mints an amount of the token and assigns it to
249      * an account. This encapsulates the modification of balances such that the
250      * proper events are emitted.
251      * @param account The account that will receive the created tokens.
252      * @param value The amount that will be created.
253      */
254     function _mint(address account, uint256 value) internal {
255         require(account != 0);
256         _totalSupply = _totalSupply.add(value);
257         _balances[account] = _balances[account].add(value);
258         emit Transfer(address(0), account, value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account.
264      * @param account The account whose tokens will be burnt.
265      * @param value The amount that will be burnt.
266      */
267     function _burn(address account, uint256 value) internal {
268         require(account != 0);
269         require(value <= _balances[account]);
270 
271         _totalSupply = _totalSupply.sub(value);
272         _balances[account] = _balances[account].sub(value);
273         emit Transfer(account, address(0), value);
274     }
275 
276     /**
277      * @dev Internal function that burns an amount of the token of a given
278      * account, deducting from the sender's allowance for said account. Uses the
279      * internal burn function.
280      * @param account The account whose tokens will be burnt.
281      * @param value The amount that will be burnt.
282      */
283     function _burnFrom(address account, uint256 value) internal {
284         require(value <= _allowed[account][msg.sender]);
285 
286         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
287         // this function needs to emit an event with the updated approval.
288         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
289             value);
290         _burn(account, value);
291     }
292 }
293 
294 contract TCPToken is ERC20 {
295 
296   string public constant name = "TCP";
297   string public constant symbol = "TCP";
298   uint8 public constant decimals = 8;
299 
300   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
301 
302   /**
303    * @dev Constructor that gives msg.sender all of existing tokens.
304    */
305   constructor() public {
306     _mint(msg.sender, INITIAL_SUPPLY);
307   }
308 
309 }