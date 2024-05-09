1 pragma solidity ^0.4.2;
2 
3 //  import "./IERC20.sol"; 
4 //  import "./SafeMath.sol";
5 
6 pragma solidity ^0.4.2;
7 
8 
9 
10 library SafeMath {
11 
12    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14        // benefit is lost if 'b' is also tested.
15        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16        if (a == 0) {
17            return 0;
18        }
19 
20        uint256 c = a * b;
21        require(c / a == b);
22 
23        return c;
24    }
25 
26  
27    function div(uint256 a, uint256 b) internal pure returns (uint256) {
28        // Solidity only automatically asserts when dividing by 0
29        require(b > 0);
30        uint256 c = a / b;
31        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33        return c;
34    }
35 
36  
37    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38        require(b <= a);
39        uint256 c = a - b;
40 
41        return c;
42    }
43 
44    /**
45    * @dev Adds two unsigned integers, reverts on overflow.
46    */
47    function add(uint256 a, uint256 b) internal pure returns (uint256) {
48        uint256 c = a + b;
49        require(c >= a);
50 
51        return c;
52    }
53 
54  
55    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56        require(b != 0);
57        return a % b;
58    }
59 }
60 interface IERC20 {
61    function transfer(address to, uint256 value) external returns (bool);
62 
63    function approve(address spender, uint256 value) external returns (bool);
64 
65    function transferFrom(address from, address to, uint256 value) external returns (bool);
66 
67    function totalSupply() external view returns (uint256);
68 
69    function balanceOf(address who) external view returns (uint256);
70 
71    function allowance(address owner, address spender) external view returns (uint256);
72 
73    event Transfer(address indexed from, address indexed to, uint256 value);
74 
75    event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 contract ERC20 is IERC20 {
78    using SafeMath for uint256;
79 
80    mapping (address => uint256) private _balances;
81 
82    mapping (address => mapping (address => uint256)) private _allowed;
83 
84    uint256 private _totalSupply;
85 
86 
87    function totalSupply() public view returns (uint256) {
88        return _totalSupply;
89    }
90 
91  
92    function balanceOf(address owner) public view returns (uint256) {
93        return _balances[owner];
94    }
95 
96  
97    function allowance(address owner, address spender) public view returns (uint256) {
98        return _allowed[owner][spender];
99    }
100 
101 
102    function transfer(address to, uint256 value) public returns (bool) {
103        _transfer(msg.sender, to, value);
104        return true;
105    }
106 
107 
108    function approve(address spender, uint256 value) public returns (bool) {
109        require(spender != address(0));
110 
111        _allowed[msg.sender][spender] = value;
112        emit Approval(msg.sender, spender, value);
113        return true;
114    }
115 
116 
117    function transferFrom(address from, address to, uint256 value) public returns (bool) {
118        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
119        _transfer(from, to, value);
120        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
121        return true;
122    }
123 
124    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
125        require(spender != address(0));
126 
127        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
128        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
129        return true;
130    }
131 
132 
133    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
134        require(spender != address(0));
135 
136        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
137        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
138        return true;
139    }
140 
141 
142    function _transfer(address from, address to, uint256 value) internal {
143        require(to != address(0));
144 
145        _balances[from] = _balances[from].sub(value);
146        _balances[to] = _balances[to].add(value);
147        emit Transfer(from, to, value);
148    }
149 
150 
151    function _mint(address account, uint256 value) internal {
152        require(account != address(0));
153 
154        _totalSupply = _totalSupply.add(value);
155        _balances[account] = _balances[account].add(value);
156        emit Transfer(address(0), account, value);
157    }
158 
159    function _burn(address account, uint256 value) internal {
160        require(account != address(0));
161 
162        _totalSupply = _totalSupply.sub(value);
163        _balances[account] = _balances[account].sub(value);
164        emit Transfer(account, address(0), value);
165    }
166 
167 
168    function _burnFrom(address account, uint256 value) internal {
169        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
170        _burn(account, value);
171        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
172    }
173 }
174 
175 // import "./IERC20.sol";
176 
177 
178 contract ERC20Detailed is IERC20 {
179    string private _name;
180    string private _symbol;
181    uint8 private _decimals;
182 
183    constructor (string memory name, string memory symbol, uint8 decimals) public {
184        _name = name;
185        _symbol = symbol;
186        _decimals = decimals;
187    }
188 
189    /**
190     * @return the name of the token.
191     */
192    function name() public view returns (string memory) {
193        return _name;
194    }
195 
196    /**
197     * @return the symbol of the token.
198     */
199    function symbol() public view returns (string memory) {
200        return _symbol;
201    }
202 
203    /**
204     * @return the number of decimals of the token.
205     */
206    function decimals() public view returns (uint8) {
207        return _decimals;
208    }
209 }
210 pragma solidity ^0.4.2;
211 
212 // import "./ERC20.sol";
213 
214 /**
215 * @title Burnable Token
216 * @dev Token that can be irreversibly burned (destroyed).
217 */
218 contract ERC20Burnable is ERC20 {
219    /**
220     * @dev Burns a specific amount of tokens.
221     * @param value The amount of token to be burned.
222     */
223    function burn(uint256 value) public {
224        _burn(msg.sender, value);
225    }
226 
227    /**
228     * @dev Burns a specific amount of tokens from the target address and decrements allowance
229     * @param from address The address which you want to send tokens from
230     * @param value uint256 The amount of token to be burned
231     */
232    function burnFrom(address from, uint256 value) public {
233        _burnFrom(from, value);
234    }
235 }
236 pragma solidity ^0.4.2;
237 
238 /**
239 * @title ERC20 interface
240 * @dev see https://github.com/ethereum/EIPs/issues/20
241 */
242 pragma solidity ^0.4.2;
243 
244 // import "./ERC20.sol";
245 // import "./ERC20Detailed.sol";
246 // import "./ERC20Burnable.sol";
247 
248 
249 contract BettingZone is ERC20, ERC20Detailed, ERC20Burnable {
250    uint8 public constant DECIMALS = 18;
251    uint256 public constant INITIAL_SUPPLY = 150000000 * (10 ** uint256(DECIMALS));
252 
253    /**
254     * @dev Constructor that gives msg.sender all of existing tokens.
255     */
256    constructor () public ERC20Detailed("BettingZone", "BZT", 18) {
257        _mint(msg.sender, INITIAL_SUPPLY);
258    }
259 }