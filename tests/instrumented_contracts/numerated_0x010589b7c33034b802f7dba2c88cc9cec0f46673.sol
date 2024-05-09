1 pragma solidity 0.5.4;
2 
3 /* CBSNews, 12/02/2019: National debt tops $22 trillion for first time in U.S. history */
4 
5 library SafeMath {
6     /**
7     * @dev Multiplies two unsigned integers, reverts on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13 
14         uint256 c = a * b;
15         require(c / a == b);
16 
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b > 0);
25         uint256 c = a / b;
26 
27         return c;
28     }
29 
30     /**
31     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b <= a);
35         uint256 c = a - b;
36 
37         return c;
38     }
39 
40     /**
41     * @dev Adds two unsigned integers, reverts on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a);
46 
47         return c;
48     }
49 
50     /**
51     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
52     * reverts when dividing by zero.
53     */
54     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b != 0);
56         return a % b;
57     }
58 }
59 
60 contract ERC20 {
61     using SafeMath for uint256;
62 
63     mapping (address => uint256) private _balances;
64     mapping (address => mapping (address => uint256)) private _allowed;
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69     uint256 private _totalSupply;
70 
71     function totalSupply() public view returns (uint256) {
72         return _totalSupply;
73     }
74 
75     function balanceOf(address owner) public view returns (uint256) {
76         return _balances[owner];
77     }
78 
79     function allowance(address owner, address spender) public view returns (uint256) {
80         return _allowed[owner][spender];
81     }
82 
83     function transfer(address to, uint256 value) public returns (bool) {
84         _transfer(msg.sender, to, value);
85         return true;
86     }
87 
88     function approve(address spender, uint256 value) public returns (bool) {
89         require(spender != address(0));
90 
91         _allowed[msg.sender][spender] = value;
92         emit Approval(msg.sender, spender, value);
93         return true;
94     }
95 
96     function transferFrom(address from, address to, uint256 value) public returns (bool) {
97         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
98         _transfer(from, to, value);
99         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
100         return true;
101     }
102 
103     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
104         require(spender != address(0));
105 
106         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
107         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
108         return true;
109     }
110 
111     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
112         require(spender != address(0));
113 
114         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
115         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
116         return true;
117     }
118 
119     function _transfer(address from, address to, uint256 value) internal {
120         require(to != address(0));
121 
122         _balances[from] = _balances[from].sub(value);
123         _balances[to] = _balances[to].add(value);
124         emit Transfer(from, to, value);
125     }
126 
127     function _mint(address account, uint256 value) internal {
128         require(account != address(0));
129 
130         _totalSupply = _totalSupply.add(value);
131         _balances[account] = _balances[account].add(value);
132         emit Transfer(address(0), account, value);
133     }
134 }
135 
136 
137 contract SoundMoneyCoin is ERC20 {
138 
139   /* Sound money and store of value on the Ethereum blockchain. */
140 
141   uint256 constant public MINING_REWARD = 5000000;
142   uint256 constant public DEV_FUND = 100000;
143   uint256 constant public MAX_SUPPLY = 2100000000000000;
144 
145   string public name = "SoundMoneyCoin";
146   string public symbol = "SOV";
147   uint8 public decimals = 8;
148   uint256 public lastMinedAt;
149   address public treasury;
150 
151   constructor() public {
152     treasury = msg.sender;
153   }
154 
155   function mint() public {
156 
157      uint256 blockNumber = block.number;
158      require(blockNumber > lastMinedAt);
159      require(totalSupply() < MAX_SUPPLY);
160 
161      lastMinedAt = blockNumber;
162 
163      _mint(msg.sender, MINING_REWARD);
164      _mint(treasury, DEV_FUND);
165   }
166 }