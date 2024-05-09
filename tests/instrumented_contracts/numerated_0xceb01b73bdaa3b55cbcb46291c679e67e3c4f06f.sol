1 pragma solidity >=0.4.25 <0.6.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5     function approve(address spender, uint256 value) external returns (bool);
6     function transferFrom(address from, address to, uint256 value) external returns (bool);
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address who) external view returns (uint256);
9     function allowance(address owner, address spender) external view returns (uint256);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract ERC20 is IERC20 {
15     using SafeMath for uint256;
16     mapping (address => uint256) private _balances;
17     mapping (address => mapping (address => uint256)) private _allowed;
18     uint256 private _totalSupply;
19     function totalSupply() public view returns (uint256) {
20         return _totalSupply;
21     }
22     function balanceOf(address owner) public view returns (uint256) {
23         return _balances[owner];
24     }
25     function allowance(address owner, address spender) public view returns (uint256) {
26         return _allowed[owner][spender];
27     }
28     function transfer(address to, uint256 value) public returns (bool) {
29         _transfer(msg.sender, to, value);
30         return true;
31     }
32     function approve(address spender, uint256 value) public returns (bool) {
33         require(spender != address(0));
34         _allowed[msg.sender][spender] = value;
35         emit Approval(msg.sender, spender, value);
36         return true;
37     }
38     function transferFrom(address from, address to, uint256 value) public returns (bool) {
39         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
40         _transfer(from, to, value);
41         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
42         return true;
43     }
44     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
45         require(spender != address(0));
46         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
47         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
48         return true;
49     }
50     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
51         require(spender != address(0));
52         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
53         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
54         return true;
55     }
56     function _transfer(address from, address to, uint256 value) internal {
57         require(to != address(0));
58         _balances[from] = _balances[from].sub(value);
59         _balances[to] = _balances[to].add(value);
60         emit Transfer(from, to, value);
61     }
62     function _mint(address account, uint256 value) internal {
63         require(account != address(0));
64         _totalSupply = _totalSupply.add(value);
65         _balances[account] = _balances[account].add(value);
66         emit Transfer(address(0), account, value);
67     }
68     function _burn(address account, uint256 value) internal {
69         require(account != address(0));
70         _totalSupply = _totalSupply.sub(value);
71         _balances[account] = _balances[account].sub(value);
72         emit Transfer(account, address(0), value);
73     }
74     function _burnFrom(address account, uint256 value) internal {
75         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
76         _burn(account, value);
77         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
78     }
79 }
80 
81 contract ERC20Detailed is IERC20 {
82     string private _name;
83     string private _symbol;
84     uint8 private _decimals;
85     constructor (string memory name, string memory symbol, uint8 decimals) public {
86         _name = name;
87         _symbol = symbol;
88         _decimals = decimals;
89     }
90     function name() public view returns (string memory) {
91         return _name;
92     }
93     function symbol() public view returns (string memory) {
94         return _symbol;
95     }
96     function decimals() public view returns (uint8) {
97         return _decimals;
98     }
99 }
100 
101 library SafeMath {
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106         uint256 c = a * b;
107         require(c / a == b);
108         return c;
109     }
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b > 0);
112         uint256 c = a / b;
113         return c;
114     }
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b <= a);
117         uint256 c = a - b;
118         return c;
119     }
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a);
123         return c;
124     }
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b != 0);
127         return a % b;
128     }
129 }
130 
131 contract WINEToken is ERC20, ERC20Detailed {
132     uint8 public constant DECIMALS = 8;
133     uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(DECIMALS));
134     constructor () public ERC20Detailed("WINE", "WINE", DECIMALS) {
135         _mint(msg.sender, INITIAL_SUPPLY);
136     }
137 }