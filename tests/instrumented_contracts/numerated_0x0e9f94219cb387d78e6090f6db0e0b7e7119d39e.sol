1 pragma solidity ^0.4.24;
2 
3 //import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
4 //import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
5 
6 interface IERC20 {
7   function totalSupply() external view returns (uint256);
8 
9   function balanceOf(address who) external view returns (uint256);
10 
11   function allowance(address owner, address spender)
12     external view returns (uint256);
13 
14   function transfer(address to, uint256 value) external returns (bool);
15 
16   function approve(address spender, uint256 value)
17     external returns (bool);
18 
19   function transferFrom(address from, address to, uint256 value)
20     external returns (bool);
21 
22   event Transfer(
23     address indexed from,
24     address indexed to,
25     uint256 value
26   );
27 
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, reverts on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (a == 0) {
45       return 0;
46     }
47 
48     uint256 c = a * b;
49     require(c / a == b);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b > 0); // Solidity only automatically asserts when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62     return c;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b <= a);
70     uint256 c = a - b;
71 
72     return c;
73   }
74 
75   /**
76   * @dev Adds two numbers, reverts on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     require(c >= a);
81 
82     return c;
83   }
84 
85   /**
86   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
87   * reverts when dividing by zero.
88   */
89   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90     require(b != 0);
91     return a % b;
92   }
93 }
94 
95 contract DdexAngelToken is IERC20 {
96     using SafeMath for uint256;
97 
98     string public name = "DDEX Angel Token";
99     string public symbol = "DDEXANGEL";
100     uint public decimals = 0;
101     uint public INITIAL_SUPPLY = 9999;
102     address public admin;
103     bool public transferEnabled = false;
104 
105     mapping (address => uint256) private _balances;
106     mapping (address => mapping (address => uint256)) private _allowed;
107 
108     modifier canTransfer() {
109         require(transferEnabled || msg.sender == admin);
110         _;
111     }
112 
113     modifier onlyAdmin() {
114         require(msg.sender == admin);
115         _;
116     }
117 
118     function enableTransfer() public onlyAdmin {
119         transferEnabled = true;
120     }
121 
122     uint256 private _totalSupply;
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     function balanceOf(address owner) public view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     function allowance(address owner, address spender) public view returns (uint256) {
132         return _allowed[owner][spender];
133     }
134 
135     function approve(address spender, uint256 value) public returns (bool) {
136         require(spender != address(0));
137 
138         _allowed[msg.sender][spender] = value;
139         emit Approval(msg.sender, spender, value);
140         return true;
141     }
142 
143     function transfer(address to, uint256 value) public canTransfer returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     function transferFrom(address from, address to, uint256 value) public canTransfer returns (bool) {
149         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
150         _transfer(from, to, value);
151         return true;
152     }
153 
154     function _transfer(address from, address to, uint256 value) internal {
155         require(to != address(0));
156 
157         _balances[from] = _balances[from].sub(value);
158         _balances[to] = _balances[to].add(value);
159         emit Transfer(from, to, value);
160     }
161 
162     constructor() public {
163         admin = msg.sender;
164 
165         _totalSupply = INITIAL_SUPPLY;
166         _balances[msg.sender] = INITIAL_SUPPLY;
167         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
168     }
169 }