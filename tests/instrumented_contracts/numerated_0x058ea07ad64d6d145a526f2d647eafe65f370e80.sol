1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender)
7     external view returns (uint256);
8   function transfer(address to, uint256 value) external returns (bool);
9   function approve(address spender, uint256 value)
10     external returns (bool);
11   function transferFrom(address from, address to, uint256 value)
12     external returns (bool);
13   event Transfer(
14     address indexed from,
15     address indexed to,
16     uint256 value
17   );
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     require(c / a == b);
31     return c;
32   }
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b > 0);
35     uint256 c = a / b;
36     return c;
37   }
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b <= a);
40     uint256 c = a - b;
41     return c;
42   }
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     require(c >= a);
46     return c;
47   }
48   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b != 0);
50     return a % b;
51   }
52 }
53 contract ERC20 is IERC20 {
54   using SafeMath for uint256;
55   mapping (address => uint256) private _balances;
56   mapping (address => mapping (address => uint256)) private _allowed;
57   uint256 private _totalSupply;
58   function totalSupply() public view returns (uint256) {
59     return _totalSupply;
60   }
61   function balanceOf(address owner) public view returns (uint256) {
62     return _balances[owner];
63   }
64   function allowance(
65     address owner,
66     address spender
67    )
68     public
69     view
70     returns (uint256)
71   {
72     return _allowed[owner][spender];
73   }
74   function transfer(address to, uint256 value) public returns (bool) {
75     require(value <= _balances[msg.sender]);
76     require(to != address(0));
77 
78     _balances[msg.sender] = _balances[msg.sender].sub(value);
79     _balances[to] = _balances[to].add(value);
80     emit Transfer(msg.sender, to, value);
81     return true;
82   }
83   function approve(address spender, uint256 value) public returns (bool) {
84     require(spender != address(0));
85     _allowed[msg.sender][spender] = value;
86     emit Approval(msg.sender, spender, value);
87     return true;
88   }
89   function transferFrom(
90     address from,
91     address to,
92     uint256 value
93   )
94     public
95     returns (bool)
96   {
97     require(value <= _balances[from]);
98     require(value <= _allowed[from][msg.sender]);
99     require(to != address(0));
100     _balances[from] = _balances[from].sub(value);
101     _balances[to] = _balances[to].add(value);
102     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
103     emit Transfer(from, to, value);
104     return true;
105   }
106   function increaseAllowance(
107     address spender,
108     uint256 addedValue
109   )
110     public
111     returns (bool)
112   {
113     require(spender != address(0));
114     _allowed[msg.sender][spender] = (
115       _allowed[msg.sender][spender].add(addedValue));
116     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
117     return true;
118   }
119   function decreaseAllowance(
120     address spender,
121     uint256 subtractedValue
122   )
123     public
124     returns (bool)
125   {
126     require(spender != address(0));
127     _allowed[msg.sender][spender] = (
128       _allowed[msg.sender][spender].sub(subtractedValue));
129     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
130     return true;
131   }
132   function _mint(address account, uint256 amount) internal {
133     require(account != 0);
134     _totalSupply = _totalSupply.add(amount);
135     _balances[account] = _balances[account].add(amount);
136     emit Transfer(address(0), account, amount);
137   }
138   function _burn(address account, uint256 amount) internal {
139     require(account != 0);
140     require(amount <= _balances[account]);
141     _totalSupply = _totalSupply.sub(amount);
142     _balances[account] = _balances[account].sub(amount);
143     emit Transfer(account, address(0), amount);
144   }
145   function _burnFrom(address account, uint256 amount) internal {
146     require(amount <= _allowed[account][msg.sender]);
147     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
148       amount);
149     _burn(account, amount);
150   }
151 }
152 contract DonateMe is ERC20 {
153   string public constant name = "Donate Me";
154   string public constant symbol = "DONATE";
155   uint8 public constant decimals = 18;
156   uint256 public constant INITIAL_SUPPLY = 999999999999999 * (10 ** uint256(decimals));
157   constructor() public {
158     _mint(msg.sender, INITIAL_SUPPLY);
159   }
160 }