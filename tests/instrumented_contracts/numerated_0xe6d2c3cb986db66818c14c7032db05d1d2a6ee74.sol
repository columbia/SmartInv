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
73 //www.finexbox.com is a great exchange.
74 contract FinexboxToken is IERC20 {
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
86     constructor() public {
87         decimals = 8;
88         _totalSupply = 33500000 * 10 ** uint(decimals);
89         _balances[msg.sender] = _totalSupply;
90         name = "FinexboxToken";
91         symbol = "FNB";
92     }
93 
94     function totalSupply() public view returns (uint256) {
95         return _totalSupply;
96     }
97 
98     function balanceOf(address owner) public view returns (uint256) {
99         return _balances[owner];
100     }
101 
102     function allowance(
103         address owner,
104         address spender
105         )
106         public
107         view
108         returns (uint256)
109     {
110         return _allowed[owner][spender];
111     }
112 
113     function transfer(address to, uint256 value) public returns (bool) {
114         _transfer(msg.sender, to, value);
115         return true;
116     }
117 
118     function approve(address spender, uint256 value) public returns (bool) {
119         require(spender != address(0));
120 
121         _allowed[msg.sender][spender] = value;
122         emit Approval(msg.sender, spender, value);
123         return true;
124     }
125 
126     function transferFrom(
127         address from,
128         address to,
129         uint256 value
130         )
131         public
132         returns (bool)
133     {
134         require(value <= _allowed[from][msg.sender]);
135 
136         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
137         _transfer(from, to, value);
138         return true;
139     }
140 
141     function _transfer(address from, address to, uint256 value) internal {
142         require(value <= _balances[from]);
143         require(to != address(0));
144 
145         _balances[from] = _balances[from].sub(value);
146         _balances[to] = _balances[to].add(value);
147         emit Transfer(from, to, value);
148     }
149 
150     function burn(uint256 value) public {
151         require(value <= _balances[msg.sender]);
152 
153         _totalSupply = _totalSupply.sub(value);
154         _balances[msg.sender] = _balances[msg.sender].sub(value);
155         emit Transfer(msg.sender, address(0), value);
156     }
157 }