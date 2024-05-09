1 /*
2  * SKYWAY TOKEN - A token, secured by the assets of the innovative SkyWay transport and infrastructure complex
3  * SKYWAY Group of Companies
4  * Copyright (C) 2019 SkyWay
5  */
6 pragma solidity 0.5.7;
7 
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         
12         if (a == 0) {
13             return 0;
14         }
15 
16         uint256 c = a * b;
17         require(c / a == b);
18 
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23 
24         require(b > 0);
25         uint256 c = a / b;
26 
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a);
32         uint256 c = a - b;
33 
34         return c;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a);
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b != 0);
46         return a % b;
47     }
48 }
49 
50 interface IERC20 {
51 
52     function transfer(address to, uint256 value) external returns (bool);
53 
54     function approve(address spender, uint256 value) external returns (bool);
55 
56     function transferFrom(address from, address to, uint256 value) external returns (bool);
57 
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address who) external view returns (uint256);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract ERC20 is IERC20 {
70 
71     using SafeMath for uint256;
72 
73     mapping (address => uint256) private _balances;
74 
75     mapping (address => mapping (address => uint256)) private _allowed;
76 
77     uint256 private _totalSupply;
78 
79     function totalSupply() public view returns (uint256) {
80         return _totalSupply;
81     }
82 
83     function balanceOf(address owner) public view returns (uint256) {
84         return _balances[owner];
85     }
86 
87     function allowance(address owner, address spender) public view returns (uint256) {
88         return _allowed[owner][spender];
89     }
90 
91     function transfer(address to, uint256 value) public returns (bool) {
92         _transfer(msg.sender, to, value);
93         return true;
94     }
95 
96     function approve(address spender, uint256 value) public returns (bool) {
97         require(spender != address(0));
98 
99         _allowed[msg.sender][spender] = value;
100         emit Approval(msg.sender, spender, value);
101         return true;
102     }
103 
104     function transferFrom(address from, address to, uint256 value) public returns (bool) {
105         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
106         _transfer(from, to, value);
107         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
108         return true;
109     }
110 
111     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
112         require(spender != address(0));
113 
114         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
115         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
116         return true;
117     }
118 
119     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
120         require(spender != address(0));
121 
122         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
123         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
124         return true;
125     }
126 
127     function _transfer(address from, address to, uint256 value) internal {
128         require(to != address(0));
129 
130         _balances[from] = _balances[from].sub(value);
131         _balances[to] = _balances[to].add(value);
132         emit Transfer(from, to, value);
133     }
134 
135     function _mint(address account, uint256 value) internal {
136         require(account != address(0));
137 
138         _totalSupply = _totalSupply.add(value);
139         _balances[account] = _balances[account].add(value);
140         emit Transfer(address(0), account, value);
141     }
142 
143     function _burn(address account, uint256 value) internal {
144         require(account != address(0));
145 
146         _totalSupply = _totalSupply.sub(value);
147         _balances[account] = _balances[account].sub(value);
148         emit Transfer(account, address(0), value);
149     }
150 
151     function _burnFrom(address account, uint256 value) internal {
152         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
153         _burn(account, value);
154         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
155     }
156 }
157 
158 contract ERC20Detailed is IERC20 {
159 
160     string private _name;
161     string private _symbol;
162     uint8 private _decimals;
163 
164     constructor (string memory name, string memory symbol, uint8 decimals) public {
165         _name = name;
166         _symbol = symbol;
167         _decimals = decimals;
168     }
169 
170     function name() public view returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public view returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public view returns (uint8) {
179         return _decimals;
180     }
181 }
182 
183 contract SkyWay is ERC20, ERC20Detailed {
184     uint public INITIAL_SUPPLY = 1000000000e18;
185     constructor () public
186     ERC20Detailed("SkyWay Token", "SWT", 18)
187     {
188         _mint(msg.sender, INITIAL_SUPPLY);
189     }
190 }