1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, reverts on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15 
16         uint256 c = a * b;
17         require(c / a == b);
18 
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0); // Solidity only automatically asserts when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two numbers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 interface IERC20 {
67     function totalSupply() external view returns (uint256);
68 
69     function balanceOf(address who) external view returns (uint256);
70 
71     function allowance(address owner, address spender)
72     external view returns (uint256);
73 
74     function transfer(address to, uint256 value) external returns (bool);
75 
76     function approve(address spender, uint256 value)
77     external returns (bool);
78 
79     function transferFrom(address from, address to, uint256 value)
80     external returns (bool);
81 
82     event Transfer(
83         address indexed from,
84         address indexed to,
85         uint256 value
86     );
87 
88     event Approval(
89         address indexed owner,
90         address indexed spender,
91         uint256 value
92     );
93 }
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
99  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
132     function allowance(
133         address owner,
134         address spender
135     )
136     public
137     view
138     returns (uint256)
139     {
140         return _allowed[owner][spender];
141     }
142 
143     /**
144     * @dev Transfer token for a specified address
145     * @param to The address to transfer to.
146     * @param value The amount to be transferred.
147     */
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
163         require(spender != address(0));
164 
165         _allowed[msg.sender][spender] = value;
166         emit Approval(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another
172      * @param from address The address which you want to send tokens from
173      * @param to address The address which you want to transfer to
174      * @param value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(
177         address from,
178         address to,
179         uint256 value
180     )
181     public
182     returns (bool)
183     {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         return true;
187     }
188 
189     /**
190      * @dev Increase the amount of tokens that an owner allowed to a spender.
191      * approve should be called when allowed_[_spender] == 0. To increment
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * @param spender The address which will spend the funds.
196      * @param addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseAllowance(
199         address spender,
200         uint256 addedValue
201     )
202     public
203     returns (bool)
204     {
205         require(spender != address(0));
206 
207         _allowed[msg.sender][spender] = (
208         _allowed[msg.sender][spender].add(addedValue));
209         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
210         return true;
211     }
212 
213     /**
214      * @dev Decrease the amount of tokens that an owner allowed to a spender.
215      * approve should be called when allowed_[_spender] == 0. To decrement
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * @param spender The address which will spend the funds.
220      * @param subtractedValue The amount of tokens to decrease the allowance by.
221      */
222     function decreaseAllowance(
223         address spender,
224         uint256 subtractedValue
225     )
226     public
227     returns (bool)
228     {
229         require(spender != address(0));
230 
231         _allowed[msg.sender][spender] = (
232         _allowed[msg.sender][spender].sub(subtractedValue));
233         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
234         return true;
235     }
236 
237     /**
238     * @dev Transfer token for a specified addresses
239     * @param from The address to transfer from.
240     * @param to The address to transfer to.
241     * @param value The amount to be transferred.
242     */
243     function _transfer(address from, address to, uint256 value) internal {
244         require(to != address(0));
245 
246         _balances[from] = _balances[from].sub(value);
247         _balances[to] = _balances[to].add(value);
248         emit Transfer(from, to, value);
249     }
250 
251     /**
252      * @dev Internal function that mints an amount of the token and assigns it to
253      * an account. This encapsulates the modification of balances such that the
254      * proper events are emitted.
255      * @param account The account that will receive the created tokens.
256      * @param value The amount that will be created.
257      */
258     function _mint(address account, uint256 value) internal {
259         require(account != address(0));
260 
261         _totalSupply = _totalSupply.add(value);
262         _balances[account] = _balances[account].add(value);
263         emit Transfer(address(0), account, value);
264     }
265 
266     /**
267      * @dev Internal function that burns an amount of the token of a given
268      * account.
269      * @param account The account whose tokens will be burnt.
270      * @param value The amount that will be burnt.
271      */
272     function _burn(address account, uint256 value) internal {
273         require(account != address(0));
274 
275         _totalSupply = _totalSupply.sub(value);
276         _balances[account] = _balances[account].sub(value);
277         emit Transfer(account, address(0), value);
278     }
279 
280     /**
281      * @dev Internal function that burns an amount of the token of a given
282      * account, deducting from the sender's allowance for said account. Uses the
283      * internal burn function.
284      * @param account The account whose tokens will be burnt.
285      * @param value The amount that will be burnt.
286      */
287     function _burnFrom(address account, uint256 value) internal {
288         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
289         // this function needs to emit an event with the updated approval.
290         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
291             value);
292         _burn(account, value);
293     }
294 }
295 
296 contract ERC20Detailed is IERC20 {
297     string private _name;
298     string private _symbol;
299     uint256 private _decimals;
300 
301     constructor(string name, string symbol, uint8 decimals) public {
302         _name = name;
303         _symbol = symbol;
304         _decimals = decimals;
305     }
306 
307     /**
308      * @return the name of the token.
309      */
310     function name() public view returns(string) {
311         return _name;
312     }
313 
314     /**
315      * @return the symbol of the token.
316      */
317     function symbol() public view returns(string) {
318         return _symbol;
319     }
320 
321     /**
322      * @return the number of decimals of the token.
323      */
324     function decimals() public view returns(uint256) {
325         return _decimals;
326     }
327 }
328 
329 contract HumanStandardToken is ERC20, ERC20Detailed {
330     uint256 public constant INITIAL_SUPPLY = 2100000000000000;
331 
332     /**
333      * @dev Constructor that gives msg.sender all of existing tokens.
334      */
335     constructor() public ERC20Detailed("FileCash coin", "FCC", 8) {
336         _mint(msg.sender, INITIAL_SUPPLY);
337     }
338 }