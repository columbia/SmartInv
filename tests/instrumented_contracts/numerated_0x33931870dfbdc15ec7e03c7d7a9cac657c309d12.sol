1 pragma solidity ^0.5;
2 
3 /**
4  * @title ERC20 token
5  *
6  */
7  
8  /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     function transfer(address to, uint256 value) external returns (bool);
20 
21     function approve(address spender, uint256 value) external returns (bool);
22 
23     function transferFrom(address from, address to, uint256 value) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29  
30 library SafeMath {
31     /**
32     * @dev Multiplies two numbers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two numbers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 contract ERC20 is IERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowed;
96     uint256 private _totalSupply;
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 
101     constructor (string memory name, string memory symbol, uint256 totalSupply, uint8 decimals) public {
102         _name = name;
103         _symbol = symbol;
104         _decimals = decimals;
105         _totalSupply = totalSupply * (10 ** uint256(decimals));
106         _balances[msg.sender] = _totalSupply;
107         emit Transfer(address(0), msg.sender, _totalSupply);
108     }
109 
110     /**
111      * @return the name of the token.
112      */
113     function name() public view returns (string memory) {
114         return _name;
115     }
116 
117     /**
118      * @return the symbol of the token.
119      */
120     function symbol() public view returns (string memory) {
121         return _symbol;
122     }
123 
124     /**
125      * @return the number of decimals of the token.
126      */
127     function decimals() public view returns (uint8) {
128         return _decimals;
129     }
130 
131     /**
132     * @dev Total number of tokens in existence
133     */
134     function totalSupply() public view returns (uint256) {
135         return _totalSupply;
136     }
137 
138     /**
139     * @dev Total number of tokens in existence excluding the decimals
140     */
141     function totalSupplyWithoutDecimals() public view returns (uint256) {
142         return _totalSupply / (10**uint256(decimals()));
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