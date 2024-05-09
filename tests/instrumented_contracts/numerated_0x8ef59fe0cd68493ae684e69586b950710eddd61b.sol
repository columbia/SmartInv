1 pragma solidity 0.4.25;
2 // Symbol      : EXG
3 // Name        : Exchain Global
4 // Total supply: 100.000.000
5 // Decimals    : 18
6 contract IERC20 {
7     function transfer(address to, uint256 value) public returns (bool);
8 
9     function approve(address spender, uint256 value) public returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12 
13     function balanceOf(address who) public view returns (uint256);
14 
15     function allowance(address owner, address spender) public view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 library SafeMath {
24   
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29     if (a == 0) {
30       return 0;
31     }
32 
33     uint256 c = a * b;
34     require(c / a == b);
35 
36     return c;
37   }
38 
39  
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // Solidity only automatically asserts when dividing by 0
42     require(b > 0);
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46     return c;
47   }
48 
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     require(b <= a);
52     uint256 c = a - b;
53 
54     return c;
55   }
56 
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     require(c >= a);
60 
61     return c;
62   }
63 
64   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65     require(b != 0);
66     return a % b;
67   }
68 }
69 
70 
71 contract ERC20 is IERC20 {
72     using SafeMath for uint256;
73 
74     mapping (address => uint256) internal _balances;
75 
76     mapping (address => mapping (address => uint256)) private _allowed;
77 
78 
79     function balanceOf(address owner) public view returns (uint256) {
80         return _balances[owner];
81     }
82 
83 
84     function allowance(address owner, address spender) public view returns (uint256) {
85         return _allowed[owner][spender];
86     }
87 
88 
89     function transfer(address to, uint256 value) public returns (bool) {
90         _transfer(msg.sender, to, value);
91         return true;
92     }
93 
94 
95     function approve(address spender, uint256 value) public returns (bool) {
96         _approve(msg.sender, spender, value);
97         return true;
98     }
99 
100 
101     function transferFrom(address from, address to, uint256 value) public returns (bool) {
102         _transfer(from, to, value);
103         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
104         return true;
105     }
106 
107 
108     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
109         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
110         return true;
111     }
112 
113 
114     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
115         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
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
127     function _approve(address owner, address spender, uint256 value) internal {
128         require(spender != address(0));
129         require(owner != address(0));
130 
131         _allowed[owner][spender] = value;
132         emit Approval(owner, spender, value);
133     }
134 
135 }
136 
137 contract EXG is ERC20 {
138   string public constant name = 'Exchain Global';
139   string public constant symbol = 'EXG';
140   uint8 public constant decimals = 6;
141   uint256 public constant totalSupply = (100 * 1e6) * (10 ** uint256(decimals));
142 
143   constructor(address _EXG) public {
144     _balances[_EXG] = totalSupply;
145     emit Transfer(address(0x0), _EXG, totalSupply);
146   }
147 }