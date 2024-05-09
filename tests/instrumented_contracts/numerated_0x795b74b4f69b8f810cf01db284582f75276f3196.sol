1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5         require(b <= a, "SafeMath: subtraction overflow");
6         uint256 c = a - b;
7 
8         return c;
9     }
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13 
14         return c;
15     }
16 }
17 
18 interface IERC20 {
19     function transfer(address to, uint256 value) external returns (bool);
20 
21     function approve(address spender, uint256 value) external returns (bool);
22 
23     function transferFrom(address from, address to, uint256 value) external returns (bool);
24 
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address who) external view returns (uint256);
28 
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 contract UPAYTokenERC20 is IERC20 {
37     using SafeMath for uint256;
38     
39     string private _name = "UPAY";
40     string private _symbol = "UPAY";
41     uint8 private _decimals = 8;
42     uint256 private _totalSupply = 50000000000000000;
43 		address public _owner;
44 
45     mapping (address => uint256) private _balances;
46     mapping (address => mapping (address => uint256)) private _allowances;
47     
48     constructor () public {
49 				_owner = msg.sender;
50         _balances[msg.sender] = _totalSupply;
51         emit Transfer(address(0), msg.sender, _totalSupply);
52     }
53     
54     function name() public view returns (string memory) {
55         return _name;
56     }
57     function symbol() public view returns (string memory) {
58         return _symbol;
59     }
60     function decimals() public view returns (uint8) {
61         return _decimals;
62     }
63     function totalSupply() public view returns (uint256) {
64         return _totalSupply;
65     }
66 
67     function balanceOf(address owner) public view returns (uint256) {
68         return _balances[owner];
69     }
70 
71     function allowance(address owner, address spender) public view returns (uint256) {
72         return _allowances[owner][spender];
73     }
74 
75     function transfer(address to, uint256 value) public returns (bool) {
76         _transfer(msg.sender, to, value);
77         return true;
78     }
79 
80     function approve(address spender, uint256 value) public returns (bool) {
81         _approve(msg.sender, spender, value);
82         return true;
83     }
84 
85     function transferFrom(address from, address to, uint256 value) public returns (bool) {
86         _transfer(from, to, value);
87         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
88         return true;
89     }
90 
91     function _transfer(address from, address to, uint256 value) internal {
92         require(from != address(0), "ERC20: transfer from the zero address");
93         require(to != address(0), "ERC20: transfer to the zero address");
94 
95         _balances[from] = _balances[from].sub(value);
96         _balances[to] = _balances[to].add(value);
97         emit Transfer(from, to, value);
98     }
99 
100     function _approve(address owner, address spender, uint256 value) internal {
101         require(owner != address(0), "ERC20: approve from the zero address");
102         require(spender != address(0), "ERC20: approve to the zero address");
103 
104         _allowances[owner][spender] = value;
105         emit Approval(owner, spender, value);
106     }
107 		
108 		function burn(uint256 value) public {
109         require(msg.sender != address(0), "ERC20: burn from the zero address");
110         require(_owner == msg.sender, "ERC20: burn only owner address");
111 
112         _totalSupply = _totalSupply.sub(value);
113         _balances[msg.sender] = _balances[msg.sender].sub(value);
114         emit Transfer(msg.sender, address(0), value);
115     }
116 		
117 		function mint(uint256 value) public {
118         require(msg.sender != address(0), "ERC20: mint to the zero address");
119         require(_owner == msg.sender, "ERC20: mint only owner address");
120 
121         _totalSupply = _totalSupply.add(value);
122         _balances[msg.sender] = _balances[msg.sender].add(value);
123         emit Transfer(address(0), msg.sender, value);
124     }
125 }