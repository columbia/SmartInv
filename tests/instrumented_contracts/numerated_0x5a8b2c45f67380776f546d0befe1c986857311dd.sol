1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-29
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 // ----------------------------------------------------------------------------
8 // KORIS Token contract
9 // Symbol      : GSH
10 // Name        : GSH HubCoin
11 // Decimals    : 18
12 // ----------------------------------------------------------------------------
13 
14 interface ERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address who) external view returns (uint256);
18 
19     function allowance(address owner, address spender)
20         external view returns (uint256);
21 
22     function transfer(address to, uint256 value) external returns (bool);
23 
24     function approve(address spender, uint256 value)
25         external returns (bool);
26 
27     function transferFrom(address from, address to, uint256 value)
28         external returns (bool);
29 
30     function burn(uint256 value) external;
31 
32     event Transfer(
33         address indexed from,
34         address indexed to,
35         uint256 value
36         );
37 
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42         );
43 }
44 
45 library SafeMath {
46 
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51 
52     uint256 c = a * b;
53     require(c / a == b);
54 
55     return c;
56   }
57 
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b > 0);
60     uint256 c = a / b;
61 
62     return c;
63   }
64 
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     require(c >= a);
75 
76     return c;
77   }
78 
79   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80     require(b != 0);
81     return a % b;
82   }
83 }
84 
85 contract GSHHubCoin is ERC20 {
86     using SafeMath for uint256;
87     mapping (address => uint256) private _balances;
88     mapping (address => mapping (address => uint256)) private _allowed;
89 
90     uint256 private _totalSupply;
91     string public name;
92     uint8 public decimals;
93     string public symbol;
94 
95     constructor() public {
96         decimals = 18;
97         _totalSupply = 50000000 * 10 ** uint(decimals);
98         _balances[msg.sender] = _totalSupply;
99         name = "GSH HubCoin";
100         symbol = "GSH";
101     }
102 
103     function totalSupply() public view returns (uint256) {
104         return _totalSupply;
105     }
106 
107     function balanceOf(address owner) public view returns (uint256) {
108         return _balances[owner];
109     }
110 
111     function allowance(
112         address owner,
113         address spender
114         )
115         public
116         view
117         returns (uint256)
118     {
119         return _allowed[owner][spender];
120     }
121 
122     function transfer(address to, uint256 value) public returns (bool) {
123         _transfer(msg.sender, to, value);
124         return true;
125     }
126 
127     function approve(address spender, uint256 value) public returns (bool) {
128         require(spender != address(0));
129 
130         _allowed[msg.sender][spender] = value;
131         emit Approval(msg.sender, spender, value);
132         return true;
133     }
134 
135     function transferFrom(
136         address from,
137         address to,
138         uint256 value
139         )
140         public
141         returns (bool)
142     {
143         require(value <= _allowed[from][msg.sender]);
144 
145         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
146         _transfer(from, to, value);
147         return true;
148     }
149 
150     function _transfer(address from, address to, uint256 value) internal {
151         require(value <= _balances[from]);
152         require(to != address(0));
153 
154         _balances[from] = _balances[from].sub(value);
155         _balances[to] = _balances[to].add(value);
156         emit Transfer(from, to, value);
157     }
158 
159     function burn(uint256 value) public {
160         require(value <= _balances[msg.sender]);
161 
162         _totalSupply = _totalSupply.sub(value);
163         _balances[msg.sender] = _balances[msg.sender].sub(value);
164         emit Transfer(msg.sender, address(0), value);
165     }
166 
167 }