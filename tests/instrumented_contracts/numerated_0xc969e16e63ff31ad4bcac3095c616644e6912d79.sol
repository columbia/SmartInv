1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title The SEEDVenture ERC20 Token
5  * 
6  * @author Fabio Pacchioni <fabio.pacchioni@gmail.com>
7  * @author Marco Vasapollo <ceo@metaring.com>
8  */
9 
10 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
11 
12 /**
13  * @title SafeMath
14  * @dev Unsigned math operations with safety checks that revert on error
15  */
16 library SafeMath {
17     /**
18     * @dev Multiplies two unsigned integers, reverts on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22         // benefit is lost if 'b' is also tested.
23         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b);
30 
31         return c;
32     }
33 
34     /**
35     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
36     */
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Solidity only automatically asserts when dividing by 0
39         require(b > 0);
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42 
43         return c;
44     }
45 
46     /**
47     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
48     */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     /**
57     * @dev Adds two unsigned integers, reverts on overflow.
58     */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a);
62 
63         return c;
64     }
65 
66     /**
67     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
68     * reverts when dividing by zero.
69     */
70     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b != 0);
72         return a % b;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value) external returns (bool);
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @title Basic ERC20 implementation
102  */
103 contract BasicERC20 is IERC20 {
104     using SafeMath for uint256;
105 
106     mapping (address => uint256) private _balances;
107 
108     mapping (address => mapping (address => uint256)) private _allowed;
109 
110     uint256 private _totalSupply;
111 
112     /**
113     * @dev Total number of tokens in existence
114     */
115     function totalSupply() public view returns (uint256) {
116         return _totalSupply;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param owner The address to query the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address owner) public view returns (uint256) {
125         return _balances[owner];
126     }
127 
128     /**
129      * @dev Function to check the amount of tokens that an owner allowed to a spender.
130      * @param owner address The address which owns the funds.
131      * @param spender address The address which will spend the funds.
132      * @return A uint256 specifying the amount of tokens still available for the spender.
133      */
134     function allowance(address owner, address spender) public view returns (uint256) {
135         return _allowed[owner][spender];
136     }
137 
138     /**
139     * @dev Transfer token for a specified address
140     * @param to The address to transfer to.
141     * @param value The amount to be transferred.
142     */
143     function transfer(address to, uint256 value) public returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     /**
149      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150      * Beware that changing an allowance with this method brings the risk that someone may use both the old
151      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      * @param spender The address which will spend the funds.
155      * @param value The amount of tokens to be spent.
156      */
157     function approve(address spender, uint256 value) public returns (bool) {
158         require(spender != address(0), "Invalid Address");
159 
160         _allowed[msg.sender][spender] = value;
161         emit Approval(msg.sender, spender, value);
162         return true;
163     }
164 
165     /**
166      * @dev Transfer tokens from one address to another.
167      * Note that while this function emits an Approval event, this is not required as per the specification,
168      * and other compliant implementations may not emit the event.
169      * @param from address The address which you want to send tokens from
170      * @param to address The address which you want to transfer to
171      * @param value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(address from, address to, uint256 value) public returns (bool) {
174         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
175         _transfer(from, to, value);
176         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
177         return true;
178     }
179 
180     /**
181      * @dev Increase the amount of tokens that an owner allowed to a spender.
182      * approve should be called when allowed_[_spender] == 0. To increment
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * Emits an Approval event.
187      * @param spender The address which will spend the funds.
188      * @param addedValue The amount of tokens to increase the allowance by.
189      */
190     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
191         require(spender != address(0), "Invalid Address");
192 
193         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
194         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
195         return true;
196     }
197 
198     /**
199      * @dev Decrease the amount of tokens that an owner allowed to a spender.
200      * approve should be called when allowed_[_spender] == 0. To decrement
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * Emits an Approval event.
205      * @param spender The address which will spend the funds.
206      * @param subtractedValue The amount of tokens to decrease the allowance by.
207      */
208     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
209         require(spender != address(0), "Invalid Address");
210 
211         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
212         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
213         return true;
214     }
215 
216     /**
217     * @dev Transfer token for a specified addresses
218     * @param from The address to transfer from.
219     * @param to The address to transfer to.
220     * @param value The amount to be transferred.
221     */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0), "Invalid Address");
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(_totalSupply == 0, "Cannot mint more tokens");
239         require(account != address(0), "Invalid Address");
240 
241         _totalSupply = _totalSupply.add(value);
242         _balances[account] = _balances[account].add(value);
243         emit Transfer(address(0), account, value);
244     }
245 }
246 
247 /**
248  * @title The SEED ERC20 Token
249  */
250 contract SEEDToken is BasicERC20 {
251 
252     string private _name;
253     string private _symbol;
254     uint8 private _decimals;
255     uint256 private _finalSupply;
256 
257     constructor() public {
258         _name = "SEED";
259         _symbol = "SEED";
260         _decimals = 18;
261         _finalSupply = 300000000;
262         uint multiplier = 10 ** uint(_decimals);
263         uint256 totalFinalSupply = _finalSupply.mul(uint256(multiplier));
264         _mint(msg.sender, totalFinalSupply);
265     }
266 
267     // ------------------------------------------------------------------------
268     // Don't accept ETH
269     // ------------------------------------------------------------------------
270     function () external payable {
271         revert("ETH not accepted");
272     }
273 
274     /**
275      * @return the name of the token.
276      */
277     function name() public view returns (string memory) {
278         return _name;
279     }
280 
281     /**
282      * @return the symbol of the token.
283      */
284     function symbol() public view returns (string memory) {
285         return _symbol;
286     }
287 
288     /**
289      * @return the number of decimals of the token.
290      */
291     function decimals() public view returns (uint8) {
292         return _decimals;
293     }
294 }