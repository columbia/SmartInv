1 /**
2  * https://www.eatalico.it
3  * 
4 */
5 
6 pragma solidity ^0.4.24;
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address who) external view returns (uint256);
12 
13     function allowance(address owner, address spender)
14         external view returns (uint256);
15 
16     function transfer(address to, uint256 value) external returns (bool);
17 
18     function approve(address spender, uint256 value)
19         external returns (bool);
20 
21     function transferFrom(address from, address to, uint256 value)
22         external returns (bool);
23 
24 
25 
26     event Transfer(
27         address indexed from,
28         address indexed to,
29         uint256 value
30         );
31 
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36         );
37 }
38 
39 library SafeMath {
40 
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45 
46     uint256 c = a * b;
47     require(c / a == b);
48 
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     require(b > 0);
54     uint256 c = a / b;
55 
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b <= a);
61     uint256 c = a - b;
62 
63     return c;
64   }
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     require(c >= a);
69 
70     return c;
71   }
72 
73   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b != 0);
75     return a % b;
76   }
77 }
78 
79 contract EAT is IERC20 {
80     using SafeMath for uint256;
81     mapping (address => uint256) private _balances;
82 
83     mapping (address => mapping (address => uint256)) private _allowed;
84 
85     uint256 private _totalSupply;
86 
87     string public name;
88     uint8 public decimals;
89     string public symbol;
90 
91     constructor() public {
92         decimals = 18;
93         _totalSupply = 100000000 * 10 ** uint(decimals);
94         _balances[msg.sender] = _totalSupply;
95         name = "Eatalico";
96         symbol = "EAT";
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
155 
156 
157 }