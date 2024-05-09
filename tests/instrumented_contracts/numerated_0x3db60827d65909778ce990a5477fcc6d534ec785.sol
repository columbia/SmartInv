1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 
7         if (a == 0) {
8             return 0;
9         }
10 
11         uint256 c = a * b;
12         require(c / a == b);
13 
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0);
19         uint256 c = a / b;
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b <= a);
26         uint256 c = a - b;
27 
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 
45 interface IERC20 {
46     function transfer(address to, uint256 value) external returns (bool);
47 
48     function approve(address spender, uint256 value) external returns (bool);
49 
50     function transferFrom(address from, address to, uint256 value) external returns (bool);
51 
52     function totalSupply() external view returns (uint256);
53 
54     function balanceOf(address who) external view returns (uint256);
55 
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract ERC20 is IERC20 {
64     using SafeMath for uint256;
65 
66     mapping (address => uint256) private _balances;
67 
68     mapping (address => mapping (address => uint256)) private _allowed;
69 
70     uint256 private _totalSupply;
71 
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76     function balanceOf(address owner) public view returns (uint256) {
77         return _balances[owner];
78     }
79 
80     function allowance(address owner, address spender) public view returns (uint256) {
81         return _allowed[owner][spender];
82     }
83 
84     function transfer(address to, uint256 value) public returns (bool) {
85         _transfer(msg.sender, to, value);
86         return true;
87     }
88 
89     function approve(address spender, uint256 value) public returns (bool) {
90         _approve(msg.sender, spender, value);
91         return true;
92     }
93 
94     function transferFrom(address from, address to, uint256 value) public returns (bool) {
95         _transfer(from, to, value);
96         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
97         return true;
98     }
99 
100     function _transfer(address from, address to, uint256 value) internal {
101         require(to != address(0));
102 
103         _balances[from] = _balances[from].sub(value);
104         _balances[to] = _balances[to].add(value);
105         emit Transfer(from, to, value);
106     }
107 
108     function _mint(address account, uint256 value) internal {
109         require(account != address(0));
110 
111         _totalSupply = _totalSupply.add(value);
112         _balances[account] = _balances[account].add(value);
113         emit Transfer(address(0), account, value);
114     }
115 
116 
117     function _approve(address owner, address spender, uint256 value) internal {
118         require(spender != address(0));
119         require(owner != address(0));
120 
121         _allowed[owner][spender] = value;
122         emit Approval(owner, spender, value);
123     }
124 
125 }
126 
127 contract ERC20Detailed is IERC20 {
128     string private _name;
129     string private _symbol;
130     uint8 private _decimals;
131 
132     constructor (string memory name, string memory symbol, uint8 decimals) public {
133         _name = name;
134         _symbol = symbol;
135         _decimals = decimals;
136     }
137 
138     /**
139      * @return the name of the token.
140      */
141     function name() public view returns (string memory) {
142         return _name;
143     }
144 
145     /**
146      * @return the symbol of the token.
147      */
148     function symbol() public view returns (string memory) {
149         return _symbol;
150     }
151 
152     /**
153      * @return the number of decimals of the token.
154      */
155     function decimals() public view returns (uint8) {
156         return _decimals;
157     }
158 }
159 
160 contract Chairman is ERC20, ERC20Detailed {
161     uint8 public constant DECIMALS = 18;
162     uint256 public constant INITIAL_SUPPLY = 380000000 * (10 ** uint256(DECIMALS));
163     constructor () public ERC20Detailed("Chairman", "CEOB", DECIMALS) {
164         _mint(msg.sender, INITIAL_SUPPLY);
165     }
166 }