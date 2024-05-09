1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, reverts on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (a == 0) {
42       return 0;
43     }
44 
45     uint256 c = a * b;
46     require(c / a == b);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b > 0); // Solidity only automatically asserts when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   /**
73   * @dev Adds two numbers, reverts on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     require(c >= a);
78 
79     return c;
80   }
81 
82   /**
83   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84   * reverts when dividing by zero.
85   */
86   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b != 0);
88     return a % b;
89   }
90 }
91 
92 contract Owned {
93     address public owner;
94     address public newOwner;
95     modifier onlyOwner {
96         require(msg.sender == owner);
97         _;
98     }
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         owner = newOwner;
105     }
106 }
107 
108 contract IWAY is IERC20, Owned {
109     using SafeMath for uint256;
110     
111     // Constructor - Sets the token Owner
112     constructor() public {
113         owner = 0x95cc7e685De21Fd004778A241EcC3DEEE93321f7;
114         _balances[0x95cc7e685De21Fd004778A241EcC3DEEE93321f7] = supply;
115         emit Transfer(address(0), owner, supply);
116     }
117     
118     // Token Setup
119     string public constant name = "InfluWay";
120     string public constant symbol = "IWAY";
121     uint256 public constant decimals = 8;
122     uint256 public supply = 1500000000 * 10 ** decimals;
123     
124     // Balances for each account
125     mapping(address => uint256) _balances;
126  
127     // Owner of account approves the transfer of an amount to another account
128     mapping(address => mapping (address => uint256)) public _allowed;
129  
130     // Get the total supply of tokens
131     function totalSupply() public view returns (uint) {
132         return supply;
133     }
134  
135     // Get the token balance for account `tokenOwner`
136     function balanceOf(address tokenOwner) public view returns (uint balance) {
137         return _balances[tokenOwner];
138     }
139  
140     // Get the allowance of funds beteen a token holder and a spender
141     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
142         return _allowed[tokenOwner][spender];
143     }
144  
145     // Transfer the balance from owner's account to another account
146     function transfer(address to, uint value) public returns (bool success) {
147         require(_balances[msg.sender] >= value);
148         require(to != address(this));
149         _balances[msg.sender] = _balances[msg.sender].sub(value);
150         _balances[to] = _balances[to].add(value);
151         emit Transfer(msg.sender, to, value);
152         return true;
153     }
154     
155     // Sets how much a sender is allowed to use of an owners funds
156     function approve(address spender, uint value) public returns (bool success) {
157         _allowed[msg.sender][spender] = value;
158         emit Approval(msg.sender, spender, value);
159         return true;
160     }
161     
162     // Transfer from function, pulls from allowance
163     function transferFrom(address from, address to, uint value) public returns (bool success) {
164         require(to != address(this));
165         require(value <= balanceOf(from));
166         require(value <= allowance(from, to));
167         _balances[from] = _balances[from].sub(value);
168         _balances[to] = _balances[to].add(value);
169         _allowed[from][to] = _allowed[from][to].sub(value);
170         emit Transfer(from, to, value);
171         return true;
172     }
173     
174     // No acidental ETH transfers to the contract.
175     function () external payable {
176         revert();
177     }
178     
179     // Mint
180     function mint(address to, uint256 value) public onlyOwner {
181         _balances[to] = _balances[to].add(value);
182         supply = supply.add(value);
183         emit Transfer(address(0), to, value);
184     }
185     
186     // Burn
187     function burn(address from, uint256 value) public onlyOwner {
188         require(_balances[from] <= value);
189         _balances[from] = _balances[from].sub(value);
190         supply = supply.sub(value);
191         emit Transfer(from, address(0), value);
192     }
193 }