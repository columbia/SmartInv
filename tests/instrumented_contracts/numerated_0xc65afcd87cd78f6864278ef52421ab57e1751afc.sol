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
100     uint256 private _totalSupply;
101     uint public decimals = 0;
102     uint public INITIAL_SUPPLY = 9999;
103     address public admin;
104     bool public transferEnabled = false;
105 
106     mapping (address => bool) public whiteList;
107     mapping (address => uint256) private _balances;
108     mapping (address => mapping (address => uint256)) private _allowed;
109 
110     modifier canTransfer() {
111         require(transferEnabled || msg.sender == admin || whiteList[msg.sender] == true);
112         _;
113     }
114 
115     modifier onlyAdmin() {
116         require(msg.sender == admin);
117         _;
118     }
119 
120     function addToWhiteList(address a) public onlyAdmin {
121         whiteList[a] = true;
122     }
123 
124     function removeFromWhiteList(address a) public onlyAdmin {
125         whiteList[a] = false;
126     }
127 
128     function enableTransfer() public onlyAdmin {
129         transferEnabled = true;
130     }
131 
132     function totalSupply() public view returns (uint256) {
133         return _totalSupply;
134     }
135 
136     function balanceOf(address owner) public view returns (uint256) {
137         return _balances[owner];
138     }
139 
140     function allowance(address owner, address spender) public view returns (uint256) {
141         return _allowed[owner][spender];
142     }
143 
144     function approve(address spender, uint256 value) public returns (bool) {
145         require(spender != address(0));
146 
147         _allowed[msg.sender][spender] = value;
148         emit Approval(msg.sender, spender, value);
149         return true;
150     }
151 
152     function transfer(address to, uint256 value) public canTransfer returns (bool) {
153         _transfer(msg.sender, to, value);
154         return true;
155     }
156 
157     function transferFrom(address from, address to, uint256 value) public canTransfer returns (bool) {
158         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
159         _transfer(from, to, value);
160         return true;
161     }
162 
163     function _transfer(address from, address to, uint256 value) internal {
164         require(to != address(0));
165 
166         _balances[from] = _balances[from].sub(value);
167         _balances[to] = _balances[to].add(value);
168         emit Transfer(from, to, value);
169     }
170 
171     constructor() public {
172         admin = msg.sender;
173 
174         _totalSupply = INITIAL_SUPPLY;
175         _balances[msg.sender] = INITIAL_SUPPLY;
176         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
177     }
178 }