1 pragma solidity ^0.5.4;
2 
3 contract Ownable {
4     
5     address public _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     /**
10      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11      * account.
12      */
13     constructor () internal {
14         _owner = 0x54cC607cEB124F161DdC8BEC63F83b0022F6fbDf;
15         emit OwnershipTransferred(address(0), _owner);
16     }
17 
18     /**
19      * @return the address of the owner.
20      */
21     function owner() public view returns (address) {
22         return _owner;
23     }
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == _owner);
30         _;
31     }
32 
33     /**
34      * @dev Transfers control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(_owner, newOwner);
40         _owner = newOwner;
41     }
42 }
43 
44 
45 
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that revert on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, reverts on overflow.
56   */
57   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (_a == 0) {
62       return 0;
63     }
64 
65     uint256 c = _a * _b;
66     require(c / _a == _b);
67 
68     return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
73   */
74   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     require(_b > 0); // Solidity only automatically asserts when dividing by 0
76     uint256 c = _a / _b;
77     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
78 
79     return c;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     require(_b <= _a);
87     uint256 c = _a - _b;
88 
89     return c;
90   }
91 
92   /**
93   * @dev Adds two numbers, reverts on overflow.
94   */
95   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     uint256 c = _a + _b;
97     require(c >= _a);
98 
99     return c;
100   }
101 
102   /**
103   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
104   * reverts when dividing by zero.
105   */
106   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b != 0);
108     return a % b;
109   }
110 }
111 
112 
113 
114 
115 
116 contract ERC20_Interface {
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address who) external view returns (uint256);
119     function allowance(address owner, address spender) external view returns (uint256);
120     function transfer(address to, uint256 value) external returns (bool);
121     function approve(address spender, uint256 value) external returns (bool);
122     function transferFrom(address from, address to, uint256 value) external returns (bool);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);   
125 }
126 
127 
128 
129 
130 contract SVS is ERC20_Interface, Ownable {
131     
132     using SafeMath for uint256;
133 
134     mapping (address => uint256) private _balances;
135 
136     mapping (address => mapping (address => uint256)) private _allowed;
137 
138     uint256 private _totalSupply;
139     uint8 private _decimals;
140     string private _name;
141     string private _symbol;
142     
143     constructor() public {
144         _totalSupply = 1000000000e18; 
145         _decimals = 18;
146         _name = "Salvus";
147         _symbol = "SVS";
148         
149         _balances[_owner] = 50000000e18;
150         emit Transfer(address(this), _owner, 50000000e18);
151         
152         _balances[0xa8336A32749BeEc90B96472f1aa3a6eD407faE46] = 700000000e18;
153         emit Transfer(address(this), 0xa8336A32749BeEc90B96472f1aa3a6eD407faE46, 700000000e18);
154         
155         _balances[0x575690EF2dcA0fD5c391a5F02280688Bd98717db] = 250000000e18;
156         emit Transfer(address(this), 0x575690EF2dcA0fD5c391a5F02280688Bd98717db, 250000000e18);
157     }
158 
159 
160     function totalSupply() public view returns (uint256) {
161         return _totalSupply;
162     }
163     
164 
165     function decimals() public view returns(uint8) {
166         return _decimals;
167     }
168     
169 
170     function name() public view returns(string memory) {
171         return _name;
172     }
173     
174     
175     function symbol() public view returns(string memory) {
176         return _symbol;
177     }
178 
179     function balanceOf(address owner) public view returns (uint256) {
180         return _balances[owner];
181     }
182 
183     function transfer(address to, uint256 value) public returns (bool) {
184         _transfer(msg.sender, to, value);
185         return true;
186     }
187     
188     function _transfer(address from, address to, uint256 value) internal {
189         require(to != address(0));
190         _balances[from] = _balances[from].sub(value);
191         _balances[to] = _balances[to].add(value);
192         emit Transfer(from, to, value);
193     }
194     
195     
196     function transferFrom(address from, address to, uint256 value) public returns (bool) {
197         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
198         _transfer(from, to, value);
199         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
200         return true;
201     }
202 
203 
204     function allowance(address owner, address spender) public view returns (uint256) {
205         return _allowed[owner][spender];
206     }
207 
208     function approve(address spender, uint256 value) public returns (bool) {
209         require(spender != address(0));
210         _allowed[msg.sender][spender] = value;
211         emit Approval(msg.sender, spender, value);
212         return true;
213     }
214 }