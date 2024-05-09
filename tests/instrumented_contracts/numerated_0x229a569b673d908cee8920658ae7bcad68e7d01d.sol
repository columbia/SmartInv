1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // KORIS Token contract
5 // Symbol      : KRS
6 // Name        : KORIS
7 // Decimals    : 18
8 // ----------------------------------------------------------------------------
9 
10 interface ERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender)
16         external view returns (uint256);
17 
18     function transfer(address to, uint256 value) external returns (bool);
19 
20     function approve(address spender, uint256 value)
21         external returns (bool);
22 
23     function transferFrom(address from, address to, uint256 value)
24         external returns (bool);
25 
26     function burn(uint256 value) external;
27 
28     event Transfer(
29         address indexed from,
30         address indexed to,
31         uint256 value
32         );
33 
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38         );
39 }
40 
41 library SafeMath {
42 
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b > 0);
56     uint256 c = a / b;
57 
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b <= a);
63     uint256 c = a - b;
64 
65     return c;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     require(c >= a);
71 
72     return c;
73   }
74 
75   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76     require(b != 0);
77     return a % b;
78   }
79 }
80 
81 contract KORISToken is ERC20 {
82     using SafeMath for uint256;
83     mapping (address => uint256) private _balances;
84     mapping (address => mapping (address => uint256)) private _allowed;
85 
86     uint256 private _totalSupply;
87     string public name;
88     uint8 public decimals;
89     string public symbol;
90 
91     constructor() public {
92         decimals = 18;
93         _totalSupply = 82000000000 * 10 ** uint(decimals);
94         _balances[msg.sender] = _totalSupply;
95         name = "KORIS";
96         symbol = "KRS";
97     }
98 
99     function totalSupply() public view returns (uint256) {
100         return _totalSupply;
101     }
102 
103     function balanceOf(address owner) public view returns (uint256) {
104         return _balances[owner];
105     }
106 
107     function allowance(
108         address owner,
109         address spender
110         )
111         public
112         view
113         returns (uint256)
114     {
115         return _allowed[owner][spender];
116     }
117 
118     function transfer(address to, uint256 value) public returns (bool) {
119         _transfer(msg.sender, to, value);
120         return true;
121     }
122 
123     function approve(address spender, uint256 value) public returns (bool) {
124         require(spender != address(0));
125 
126         _allowed[msg.sender][spender] = value;
127         emit Approval(msg.sender, spender, value);
128         return true;
129     }
130 
131     function transferFrom(
132         address from,
133         address to,
134         uint256 value
135         )
136         public
137         returns (bool)
138     {
139         require(value <= _allowed[from][msg.sender]);
140 
141         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
142         _transfer(from, to, value);
143         return true;
144     }
145 
146     function _transfer(address from, address to, uint256 value) internal {
147         require(value <= _balances[from]);
148         require(to != address(0));
149 
150         _balances[from] = _balances[from].sub(value);
151         _balances[to] = _balances[to].add(value);
152         emit Transfer(from, to, value);
153     }
154 
155     function burn(uint256 value) public {
156         require(value <= _balances[msg.sender]);
157 
158         _totalSupply = _totalSupply.sub(value);
159         _balances[msg.sender] = _balances[msg.sender].sub(value);
160         emit Transfer(msg.sender, address(0), value);
161     }
162 
163 }