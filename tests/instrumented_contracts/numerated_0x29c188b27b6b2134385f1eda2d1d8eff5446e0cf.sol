1 // File: contracts/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address who) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18 }
19 
20 // File: contracts/SafeMath.sol
21 
22 pragma solidity ^0.5.0;
23 
24 /**
25  * @title SafeMath
26  * @dev Unsigned math operations with safety checks that revert on error.
27  */
28 library SafeMath {
29     /**
30      * @dev Multiplies two unsigned integers, reverts on overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46     /**
47      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0, "SafeMath: division by zero");
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a, "SafeMath: subtraction overflow");
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Adds two unsigned integers, reverts on overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
80      * reverts when dividing by zero.
81      */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0, "SafeMath: modulo by zero");
84         return a % b;
85     }
86 }
87 
88 // File: contracts/ERC20.sol
89 
90 pragma solidity ^0.5.0;
91 
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://eips.ethereum.org/EIPS/eip-20
99  * Originally based on code by FirstBlood:
100  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  *
102  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
103  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
104  * compliant implementations may not do it.
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     address public _minter;
110 
111     mapping (address => uint256) private _balances;
112 
113     uint256 private _totalSupply;
114 
115     /**
116      * @dev Total number of tokens in existence.
117      */
118     function totalSupply() public view returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123      * @dev Gets the balance of the specified address.
124      * @param owner The address to query the balance of.
125      * @return A uint256 representing the amount owned by the passed address.
126      */
127     function balanceOf(address owner) public view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     /**
132      * @dev Transfer token to a specified address.
133      * @param to The address to transfer to.
134      * @param value The amount to be transferred.
135      */
136     function transfer(address to, uint256 value) public returns (bool) {
137         _transfer(msg.sender, to, value);
138         return true;
139     }
140 
141     /**
142      * @dev Transfer token for a specified addresses.
143      * @param from The address to transfer from.
144      * @param to The address to transfer to.
145      * @param value The amount to be transferred.
146      */
147     function _transfer(address from, address to, uint256 value) internal {
148         require(from != address(0), "ERC20: transfer from the zero address");
149         require(to != address(0), "ERC20: transfer to the zero address");
150         require(value <= _balances[from], "Insufficient balance.");
151 
152         _balances[from] = _balances[from].sub(value);
153         _balances[to] = _balances[to].add(value);
154         emit Transfer(from, to, value);
155     }
156 
157     /**
158      * @dev Internal function that mints an amount of the token and assigns it to
159      * an account. This encapsulates the modification of balances such that the
160      * proper events are emitted.
161      * @param account The account that will receive the created tokens.
162      * @param value The amount that will be created.
163      */
164     function _mint(address account, uint256 value) internal {
165         require(account != address(0), "ERC20: mint to the zero address");
166         require(msg.sender == _minter);
167         require(value < 1e60);
168 
169         _totalSupply = _totalSupply.add(value);
170         _balances[account] = _balances[account].add(value);
171         emit Transfer(address(0), account, value);
172     }
173 }
174 
175 // File: contracts/ERC20Detailed.sol
176 
177 pragma solidity ^0.5.0;
178 
179 
180 /**
181  * @title ERC20Detailed token
182  * @dev The decimals are only for visualization purposes.
183  * All the operations are done using the smallest and indivisible token unit,
184  * just as on Ethereum all the operations are done in wei.
185  */
186 contract ERC20Detailed is IERC20 {
187     string private _name;
188     string private _symbol;
189     uint8 private _decimals;
190 
191     constructor (string memory name, string memory symbol, uint8 decimals) public {
192         _name = name;
193         _symbol = symbol;
194         _decimals = decimals;
195     }
196 
197     /**
198      * @return the name of the token.
199      */
200     function name() public view returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @return the symbol of the token.
206      */
207     function symbol() public view returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @return the number of decimals of the token.
213      */
214     function decimals() public view returns (uint8) {
215         return _decimals;
216     }
217 }
218 
219 // File: contracts/PB0.sol
220 
221 pragma solidity ^0.5.0;
222 
223 
224 
225 /**
226  * @title PB0
227  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
228  * Note they can later distribute these tokens as they wish using `transfer` and other
229  * `ERC20` functions.
230  */
231 contract PB0 is ERC20, ERC20Detailed {
232     uint8 public constant DECIMALS = 18;
233     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(DECIMALS));
234     string public legalDocument;
235 
236     /**
237      * @dev Constructor that gives msg.sender all of existing tokens.
238      */
239     constructor (string memory document) public ERC20Detailed("PB0", "PB0", DECIMALS) {
240         legalDocument = document;
241         _minter = msg.sender;
242         _mint(msg.sender, INITIAL_SUPPLY);
243     }
244 }