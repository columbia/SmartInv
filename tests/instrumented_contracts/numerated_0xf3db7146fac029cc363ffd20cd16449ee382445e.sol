1 pragma solidity ^0.5.0;
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
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 interface IERC20 {
69     function transfer(address to, uint256 value) external returns (bool);
70 
71     function approve(address spender, uint256 value) external returns (bool);
72 
73     function transferFrom(address from, address to, uint256 value) external returns (bool);
74 
75     function totalSupply() external view returns (uint256);
76 
77     function balanceOf(address who) external view returns (uint256);
78 
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 /**
87  * @title Standard ERC20 token
88  *
89  * @dev Implementation of the basic standard token.
90  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
91  * Originally based on code by FirstBlood:
92  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  *
94  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
95  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
96  * compliant implementations may not do it.
97  */
98 contract ERC20 is IERC20 {
99     using SafeMath for uint256;
100 
101     mapping (address => uint256) private _balances;
102 
103     mapping (address => mapping (address => uint256)) private _allowed;
104 
105     string private _name = "Bitcharge Coin";
106     string private _symbol = "BCC";
107     uint8 private _decimals = 18;
108     
109     //Total Supply is 3 Billion
110     uint256 private _totalSupply = 3000000000 ether;
111 
112     constructor () public {
113         _balances[msg.sender] = _totalSupply;
114         emit Transfer(address(0x0), msg.sender, _totalSupply);
115     }
116 
117     /**
118      * @return the name of the token.
119      */
120     function name() public view returns (string memory) {
121         return _name;
122     }
123 
124     /**
125      * @return the symbol of the token.
126      */
127     function symbol() public view returns (string memory) {
128         return _symbol;
129     }
130 
131     /**
132      * @return the number of decimals of the token.
133      */
134     function decimals() public view returns (uint8) {
135         return _decimals;
136     }
137 
138     /**
139     * @dev Total number of tokens in existence
140     */
141     function totalSupply() public view returns (uint256) {
142         return _totalSupply;
143     }
144 
145     /**
146     * @dev Gets the balance of the specified address.
147     * @param owner The address to query the balance of.
148     * @return An uint256 representing the amount owned by the passed address.
149     */
150     function balanceOf(address owner) public view returns (uint256) {
151         return _balances[owner];
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param owner address The address which owns the funds.
157      * @param spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address owner, address spender) public view returns (uint256) {
161         return _allowed[owner][spender];
162     }
163 
164     /**
165     * @dev Transfer token for a specified address
166     * @param to The address to transfer to.
167     * @param value The amount to be transferred.
168     */
169     function transfer(address to, uint256 value) public returns (bool) {
170         _transfer(msg.sender, to, value);
171         return true;
172     }
173 
174     /**
175      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176      * Beware that changing an allowance with this method brings the risk that someone may use both the old
177      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      * @param spender The address which will spend the funds.
181      * @param value The amount of tokens to be spent.
182      */
183     function approve(address spender, uint256 value) public returns (bool) {
184         require(spender != address(0));
185 
186         _allowed[msg.sender][spender] = value;
187         emit Approval(msg.sender, spender, value);
188         return true;
189     }
190 
191     /**
192      * @dev Transfer tokens from one address to another.
193      * Note that while this function emits an Approval event, this is not required as per the specification,
194      * and other compliant implementations may not emit the event.
195      * @param from address The address which you want to send tokens from
196      * @param to address The address which you want to transfer to
197      * @param value uint256 the amount of tokens to be transferred
198      */
199     function transferFrom(address from, address to, uint256 value) public returns (bool) {
200         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
201         _transfer(from, to, value);
202         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
203         return true;
204     }
205 
206     /**
207      * @dev Increase the amount of tokens that an owner allowed to a spender.
208      * approve should be called when allowed_[_spender] == 0. To increment
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * Emits an Approval event.
213      * @param spender The address which will spend the funds.
214      * @param addedValue The amount of tokens to increase the allowance by.
215      */
216     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
217         require(spender != address(0));
218 
219         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
220         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221         return true;
222     }
223 
224     /**
225      * @dev Decrease the amount of tokens that an owner allowed to a spender.
226      * approve should be called when allowed_[_spender] == 0. To decrement
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      * Emits an Approval event.
231      * @param spender The address which will spend the funds.
232      * @param subtractedValue The amount of tokens to decrease the allowance by.
233      */
234     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
235         require(spender != address(0));
236 
237         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
238         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
239         return true;
240     }
241 
242     /**
243     * @dev Transfer token for a specified addresses
244     * @param from The address to transfer from.
245     * @param to The address to transfer to.
246     * @param value The amount to be transferred.
247     */
248     function _transfer(address from, address to, uint256 value) internal {
249         require(to != address(0));
250 
251         _balances[from] = _balances[from].sub(value);
252         _balances[to] = _balances[to].add(value);
253         emit Transfer(from, to, value);
254     }
255 }