1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool);
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85 
86     mapping (address => mapping (address => uint256)) private _allowed;
87 
88     uint256 private _totalSupply;
89 
90     /**
91     * @dev Total number of tokens in existence
92     */
93     function totalSupply() public view returns (uint256) {
94         return _totalSupply;
95     }
96 
97     /**
98     * @dev Gets the balance of the specified address.
99     * @param owner The address to query the balance of.
100     * @return An uint256 representing the amount owned by the passed address.
101     */
102     function balanceOf(address owner) public view returns (uint256) {
103         return _balances[owner];
104     }
105 
106     /**
107      * @dev Function to check the amount of tokens that an owner allowed to a spender.
108      * @param owner address The address which owns the funds.
109      * @param spender address The address which will spend the funds.
110      * @return A uint256 specifying the amount of tokens still available for the spender.
111      */
112     function allowance(address owner, address spender) public view returns (uint256) {
113         return _allowed[owner][spender];
114     }
115 
116     /**
117     * @dev Transfer token for a specified address
118     * @param to The address to transfer to.
119     * @param value The amount to be transferred.
120     */
121     function transfer(address to, uint256 value) public returns (bool) {
122         _transfer(msg.sender, to, value);
123         return true;
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param spender The address which will spend the funds.
133      * @param value The amount of tokens to be spent.
134      */
135     function approve(address spender, uint256 value) public returns (bool) {
136         require(spender != address(0));
137 
138         _allowed[msg.sender][spender] = value;
139         emit Approval(msg.sender, spender, value);
140         return true;
141     }
142 
143     
144     /**
145      * @dev Transfer tokens from one address to another.
146      * Note that while this function emits an Approval event, this is not required as per the specification,
147      * and other compliant implementations may not emit the event.
148      * @param from address The address which you want to send tokens from
149      * @param to address The address which you want to transfer to
150      * @param value uint256 the amount of tokens to be transferred
151      */
152     function transferFrom(address from, address to, uint256 value) public returns (bool) {
153         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
154         _transfer(from, to, value);
155         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
156         return true;
157     }
158 
159     /**
160      * @dev Increase the amount of tokens that an owner allowed to a spender.
161      * approve should be called when allowed_[_spender] == 0. To increment
162      * allowed value is better to use this function to avoid 2 calls (and wait until
163      * the first transaction is mined)
164      * From MonolithDAO Token.sol
165      * Emits an Approval event.
166      * @param spender The address which will spend the funds.
167      * @param addedValue The amount of tokens to increase the allowance by.
168      */
169     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
170         require(spender != address(0));
171 
172         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
173         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
174         return true;
175     }
176 
177     /**
178      * @dev Decrease the amount of tokens that an owner allowed to a spender.
179      * approve should be called when allowed_[_spender] == 0. To decrement
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param subtractedValue The amount of tokens to decrease the allowance by.
186      */
187     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
188         require(spender != address(0));
189 
190         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
191         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
192         return true;
193     }
194 
195     /**
196     * @dev Transfer token for a specified addresses
197     * @param from The address to transfer from.
198     * @param to The address to transfer to.
199     * @param value The amount to be transferred.
200     */
201     function _transfer(address from, address to, uint256 value) internal {
202         require(to != address(0));
203 
204         _balances[from] = _balances[from].sub(value);
205         _balances[to] = _balances[to].add(value);
206         emit Transfer(from, to, value);
207     }
208 
209     /**
210      * @dev Internal function that mints an amount of the token and assigns it to
211      * an account. This encapsulates the modification of balances such that the
212      * proper events are emitted.
213      * @param account The account that will receive the created tokens.
214      * @param value The amount that will be created.
215      */
216     function _mint(address account, uint256 value) internal {
217         require(account != address(0));
218 
219         _totalSupply = _totalSupply.add(value);
220         _balances[account] = _balances[account].add(value);
221         emit Transfer(address(0), account, value);
222     }
223 
224     /**
225      * @dev Internal function that burns an amount of the token of a given
226      * account.
227      * @param account The account whose tokens will be burnt.
228      * @param value The amount that will be burnt.
229      */
230     function _burn(address account, uint256 value) internal {
231         require(account != address(0));
232 
233         _totalSupply = _totalSupply.sub(value);
234         _balances[account] = _balances[account].sub(value);
235         emit Transfer(account, address(0), value);
236     }
237 
238     /**
239      * @dev Internal function that burns an amount of the token of a given
240      * account, deducting from the sender's allowance for said account. Uses the
241      * internal burn function.
242      * Emits an Approval event (reflecting the reduced allowance).
243      * @param account The account whose tokens will be burnt.
244      * @param value The amount that will be burnt.
245      */
246     function _burnFrom(address account, uint256 value) internal {
247         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
248         _burn(account, value);
249         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
250     }
251 }
252 
253 contract ERC20Detailed is IERC20 {
254     string private _name;
255     string private _symbol;
256     uint8 private _decimals;
257 
258     constructor (string memory name, string memory symbol, uint8 decimals) public {
259         _name = name;
260         _symbol = symbol;
261         _decimals = decimals;
262     }
263 
264     /**
265      * @return the name of the token.
266      */
267     function name() public view returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @return the symbol of the token.
273      */
274     function symbol() public view returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @return the number of decimals of the token.
280      */
281     function decimals() public view returns (uint8) {
282         return _decimals;
283     }
284 }
285 contract Resonance {
286     function participantFission(address sender, address inviterAddress) public returns(bool);
287 }
288 contract EMBToken is ERC20, ERC20Detailed {
289     uint256 public burned; // Burned EMB.
290 
291     string private constant NAME = "Euler Money Blockchain";
292     string private constant SYMBOL = "EMB";
293     uint8 private constant DECIMALS = 18;
294     uint256 private constant INITIAL_SUPPLY = 105976366*10**20;
295 
296     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
297         _mint(msg.sender, INITIAL_SUPPLY);
298     }
299     
300     function isContract(address _addr) private view returns (bool) {
301         uint256 length;
302         assembly {
303             //retrieve the size of the code on target address, this needs assembly
304             length := extcodesize(_addr)
305         }
306         return (length > 0);
307     }
308     
309     function burn(uint256 value) public returns(bool) {
310         burned = burned.add(value);
311         _burn(msg.sender, value);
312         return true;
313     }
314 
315     function burnFrom(address from, uint256 value) public returns(bool) {
316         burned = burned.add(value);
317         _burnFrom(from, value);
318         return true;
319     }
320     
321     // ------------------------------------------------------------------------
322     // Token holder can notify a contract that it has been approved
323     // to spend _value of tokens
324     // @param to The Resonance contract address
325     // @param value: The constant of 100 * 10**18
326     // @param inviterAddress The inviter
327     // ------------------------------------------------------------------------
328     function participantFission(address to, uint256 value, address inviterAddress) public returns (bool) {
329         require(to != address(0) && to != address(this), "invalid contract address!");
330         require(balanceOf(msg.sender) >= value, "have no enough token!");
331 
332         if(approve(to, value) && isContract(to)) {
333             Resonance receiver = Resonance(to);
334             receiver.participantFission(msg.sender, inviterAddress);
335         }
336         return true;
337     }
338 }