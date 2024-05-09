1 pragma solidity ^0.4.25;
2 
3 interface StandardERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) { return 0; }
18     uint256 c = a * b;
19     require(c / a == b);
20     return c;
21   }
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b > 0);
24     uint256 c = a / b;
25     return c;
26   }
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     require(b <= a);
29     uint256 c = a - b;
30     return c;
31   }
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     require(c >= a);
35     return c;
36   }
37   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b != 0);
39     return a % b;
40   }
41 }
42 
43 contract GJM is StandardERC20 {
44   using SafeMath for uint256;
45   mapping (address => uint256) private _balances;
46   mapping (address => mapping (address => uint256)) private _allowed;
47 
48   uint256 private _totalSupply;
49 
50   string public name;
51   uint8  public decimals;
52   string public symbol;
53   string public version;
54 
55   function () public { revert(); }
56 
57   constructor() public {
58     name = "Gold Jewelry Mining";
59     decimals = 18;
60     symbol = "GJM";
61     version = "V1.0";
62     _totalSupply = 1500 * 10**uint(6) * 10**uint(decimals);
63     _balances[msg.sender] = _totalSupply;
64   }
65 
66   function totalSupply() public view returns (uint256) {
67     return _totalSupply;
68   }
69   function balanceOf(address owner) public view returns (uint256) {
70     return _balances[owner];
71   }
72   function allowance(address owner, address spender) public view returns (uint256) {
73     return _allowed[owner][spender];
74   }
75   function transfer(address to, uint256 value) public returns (bool) {
76     _transfer(msg.sender, to, value);
77     return true;
78   }
79   function approve(address spender, uint256 value) public returns (bool) {
80     require(spender != address(0));
81     _allowed[msg.sender][spender] = value;
82     emit Approval(msg.sender, spender, value);
83     return true;
84   }
85   function transferFrom(address from, address to, uint256 value) public returns (bool) {
86     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
87     _transfer(from, to, value);
88     return true;
89   }
90   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
91     require(spender != address(0));
92     _allowed[msg.sender][spender] = (
93     _allowed[msg.sender][spender].add(addedValue));
94     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
95     return true;
96   }
97   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
98     require(spender != address(0));
99     _allowed[msg.sender][spender] = (
100     _allowed[msg.sender][spender].sub(subtractedValue));
101     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
102     return true;
103   }
104   function _transfer(address from, address to, uint256 value) internal {
105     require(to != address(0));
106     _balances[from] = _balances[from].sub(value);
107     _balances[to] = _balances[to].add(value);
108     emit Transfer(from, to, value);
109   }
110   function _mint(address account, uint256 value) internal {
111     require(account != address(0));
112     _totalSupply = _totalSupply.add(value);
113     _balances[account] = _balances[account].add(value);
114     emit Transfer(address(0), account, value);
115   }
116   function _burn(address account, uint256 value) internal {
117     require(account != address(0));
118     _totalSupply = _totalSupply.sub(value);
119     _balances[account] = _balances[account].sub(value);
120     emit Transfer(account, address(0), value);
121   }
122   function _burnFrom(address account, uint256 value) internal {
123     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
124     _burn(account, value);
125   }
126 }