1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address who) external view returns (uint256);
7 
8     function allowance(address owner, address spender)
9         external view returns (uint256);
10 
11     function transfer(address to, uint256 value) external returns (bool);
12 
13     function approve(address spender, uint256 value)
14         external returns (bool);
15 
16     function transferFrom(address from, address to, uint256 value)
17         external returns (bool);
18 
19     function burn(uint256 value) external;
20 
21     event Transfer(
22         address indexed from,
23         address indexed to,
24         uint256 value
25         );
26 
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31         );
32 }
33 
34 library SafeMath {
35 
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40 
41     uint256 c = a * b;
42     require(c / a == b);
43 
44     return c;
45   }
46 
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b > 0);
49     uint256 c = a / b;
50 
51     return c;
52   }
53 
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b <= a);
56     uint256 c = a - b;
57 
58     return c;
59   }
60 
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     require(c >= a);
64 
65     return c;
66   }
67 
68   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b != 0);
70     return a % b;
71   }
72 }
73 
74 contract CSToken is IERC20 {
75     using SafeMath for uint256;
76     mapping (address => uint256) private _balances;
77 
78     mapping (address => mapping (address => uint256)) private _allowed;
79 
80     uint256 private _totalSupply;
81 
82     string public name;
83     uint8 public decimals;
84     string public symbol;
85 
86     constructor(uint256 initialSupply,
87         uint8 decimalUnits,
88         string tokenName,
89         string tokenSymbol) public {
90         decimals = decimalUnits;
91         _totalSupply = initialSupply * 10 ** uint(decimals);
92         _balances[msg.sender] = _totalSupply;
93         name = tokenName;
94         symbol = tokenSymbol;
95     }
96 
97     function totalSupply() public view returns (uint256) {
98         return _totalSupply;
99     }
100 
101     function balanceOf(address owner) public view returns (uint256) {
102         return _balances[owner];
103     }
104 
105     function allowance(
106         address owner,
107         address spender
108         )
109         public
110         view
111         returns (uint256)
112     {
113         return _allowed[owner][spender];
114     }
115 
116     function transfer(address to, uint256 value) public returns (bool) {
117         _transfer(msg.sender, to, value);
118         return true;
119     }
120 
121     function approve(address spender, uint256 value) public returns (bool) {
122         require(spender != address(0));
123 
124         _allowed[msg.sender][spender] = value;
125         emit Approval(msg.sender, spender, value);
126         return true;
127     }
128 
129     function transferFrom(
130         address from,
131         address to,
132         uint256 value
133         )
134         public
135         returns (bool)
136     {
137         require(value <= _allowed[from][msg.sender]);
138 
139         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
140         _transfer(from, to, value);
141         return true;
142     }
143 
144     function _transfer(address from, address to, uint256 value) internal {
145         require(value <= _balances[from]);
146         require(to != address(0));
147 
148         _balances[from] = _balances[from].sub(value);
149         _balances[to] = _balances[to].add(value);
150         emit Transfer(from, to, value);
151     }
152 
153     function burn(uint256 value) public {
154         require(value <= _balances[msg.sender]);
155 
156         _totalSupply = _totalSupply.sub(value);
157         _balances[msg.sender] = _balances[msg.sender].sub(value);
158         emit Transfer(msg.sender, address(0), value);
159     }
160 
161 }