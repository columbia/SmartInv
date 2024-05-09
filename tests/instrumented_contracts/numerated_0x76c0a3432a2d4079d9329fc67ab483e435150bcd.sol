1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, February 28, 2019
3  (UTC) */
4 
5 pragma solidity 0.4.25;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two unsigned integers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 interface IERC20 {
67     function totalSupply() external view returns (uint256);
68 
69     function balanceOf(address who) external view returns (uint256);
70 
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Standard ERC20 token
86  *
87  * @dev Implementation of the basic standard token.
88  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
89  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
90  *
91  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
92  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
93  * compliant implementations may not do it.
94  */
95 contract ERC20 is IERC20 {
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) private _balances;
99 
100     mapping(address => mapping(address => uint256)) private _allowed;
101 
102     uint256 private _totalSupply;
103 
104     /**
105     * @dev Total number of tokens in existence
106     */
107     function totalSupply() public view returns (uint256) {
108         return _totalSupply;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param owner The address to query the balance of.
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address owner) public view returns (uint256) {
117         return _balances[owner];
118     }
119 
120     /**
121      * @dev Function to check the amount of tokens that an owner allowed to a spender.
122      * @param owner address The address which owns the funds.
123      * @param spender address The address which will spend the funds.
124      * @return A uint256 specifying the amount of tokens still available for the spender.
125      */
126     function allowance(address owner, address spender) public view returns (uint256) {
127         return _allowed[owner][spender];
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      * Beware that changing an allowance with this method brings the risk that someone may use both the old
133      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      * @param spender The address which will spend the funds.
137      * @param value The amount of tokens to be spent.
138      */
139     function approve(address spender, uint256 value) public returns (bool) {
140         require(spender != address(0));
141         require((value == 0) || (_allowed[msg.sender][spender] == 0));
142 
143         _allowed[msg.sender][spender] = value;
144         emit Approval(msg.sender, spender, value);
145         return true;
146     }
147 
148     /**
149      * @dev Transfer tokens from one address to another.
150      * Note that while this function emits an Approval event, this is not required as per the specification,
151      * and other compliant implementations may not emit the event.
152      * @param from address The address which you want to send tokens from
153      * @param to address The address which you want to transfer to
154      * @param value uint256 the amount of tokens to be transferred
155      */
156     function transferFrom(address from, address to, uint256 value) public returns (bool) {
157         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
158         _transfer(from, to, value);
159         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
160         return true;
161     }
162 
163     /**
164      * @dev Increase the amount of tokens that an owner allowed to a spender.
165      * approve should be called when allowed_[_spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * From MonolithDAO Token.sol
169      * Emits an Approval event.
170      * @param spender The address which will spend the funds.
171      * @param addedValue The amount of tokens to increase the allowance by.
172      */
173     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
174         require(spender != address(0));
175 
176         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
177         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178         return true;
179     }
180 
181     /**
182      * @dev Decrease the amount of tokens that an owner allowed to a spender.
183      * approve should be called when allowed_[_spender] == 0. To decrement
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * Emits an Approval event.
188      * @param spender The address which will spend the funds.
189      * @param subtractedValue The amount of tokens to decrease the allowance by.
190      */
191     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
192         require(spender != address(0));
193 
194         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
195         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
196         return true;
197     }
198 
199     /**
200     * @dev Transfer token for a specified addresses
201     * @param from The address to transfer from.
202     * @param to The address to transfer to.
203     * @param value The amount to be transferred.
204     */
205     function _transfer(address from, address to, uint256 value) internal {
206         require(to != address(0));
207 
208         _balances[from] = _balances[from].sub(value);
209         _balances[to] = _balances[to].add(value);
210         emit Transfer(from, to, value);
211     }
212 
213     /**
214      * @dev Internal function that mints an amount of the token and assigns it to
215      * an account. This encapsulates the modification of balances such that the
216      * proper events are emitted.
217      * @param account The account that will receive the created tokens.
218      * @param value The amount that will be created.
219      */
220     function _mint(address account, uint256 value) internal {
221         require(account != address(0));
222 
223         _totalSupply = _totalSupply.add(value);
224         _balances[account] = _balances[account].add(value);
225         emit Transfer(address(0), account, value);
226     }
227 
228     /**
229      * @dev Internal function that burns an amount of the token of a given
230      * account.
231      * @param account The account whose tokens will be burnt.
232      * @param value The amount that will be burnt.
233      */
234     function _burn(address account, uint256 value) internal {
235         require(account != address(0));
236 
237         _totalSupply = _totalSupply.sub(value);
238         _balances[account] = _balances[account].sub(value);
239         emit Transfer(account, address(0), value);
240     }
241 }
242 
243 /**
244  * @title ERC20Detailed token
245  * @dev The decimals are only for visualization purposes.
246  * All the operations are done using the smallest and indivisible token unit,
247  * just as on Ethereum all the operations are done in wei.
248  */
249 contract ERC20Detailed is ERC20 {
250     string private _name = 'Ethereum Message Search';
251     string private _symbol = 'EMS';
252     uint8 private _decimals = 18;
253 
254     /**
255      * @return the name of the token.
256      */
257     function name() public view returns (string) {
258         return _name;
259     }
260 
261     /**
262      * @return the symbol of the token.
263      */
264     function symbol() public view returns (string) {
265         return _symbol;
266     }
267 
268     /**
269      * @return the number of decimals of the token.
270      */
271     function decimals() public view returns (uint8) {
272         return _decimals;
273     }
274 }
275 
276 contract EMS is ERC20Detailed {
277     using SafeMath for uint;
278 
279     uint private DEC = 1000000000000000000;
280     uint public msgCount = 0;
281 
282     struct Message {
283         bytes data;
284         uint sum;
285         uint time;
286         address addressUser;
287     }
288 
289     mapping(uint => Message) public messages;
290 
291     constructor() public {
292         _mint(msg.sender, 5000000 * DEC);
293         _mint(address(this), 5000000 * DEC);
294     }
295 
296     function cost(uint availableTokens) private view returns (uint) {
297         if (availableTokens <= 5000000 * DEC && availableTokens > 4000000 * DEC) {
298             //1token = 0.01 ETH
299             return 1;
300         } else if (availableTokens <= 4000000 * DEC && availableTokens > 3000000 * DEC) {
301             //1token = 0.02 ETH
302             return 2;
303         } else if (availableTokens <= 3000000 * DEC && availableTokens > 2000000 * DEC) {
304             //1token = 0.03 ETH
305             return 3;
306         } else if (availableTokens <= 2000000 * DEC && availableTokens > 1000000 * DEC) {
307             //1token = 0.04 ETH
308             return 4;
309         } else if (availableTokens <= 1000000 * DEC) {
310             //1token = 0.05 ETH
311             return 5;
312         }
313     }
314 
315     function() external payable {
316         require(msg.value > 0, "Wrong ETH value");
317 
318         uint availableTokens = balanceOf(address(this));
319 
320         if (availableTokens > 0) {
321             uint tokens = msg.value.mul(100).div(cost(availableTokens));
322 
323             if (availableTokens < tokens) tokens = availableTokens;
324 
325             _transfer(address(this), msg.sender, tokens);
326         }
327 
328         messages[msgCount].data = msg.data;
329         messages[msgCount].sum = msg.value;
330         messages[msgCount].time = now;
331         messages[msgCount].addressUser = msg.sender;
332 
333         msgCount++;
334     }
335 
336     function sellTokens(uint tokens) public {
337         uint value = address(this).balance.mul(tokens).div(totalSupply());
338 
339         _burn(msg.sender, tokens);
340 
341         msg.sender.transfer(value);
342     }
343 
344     function transfer(address to, uint256 value) public returns (bool) {
345         if (to == address(this)) {
346             sellTokens(value);
347         } else {
348             _transfer(msg.sender, to, value);
349         }
350 
351         return true;
352     }
353 }