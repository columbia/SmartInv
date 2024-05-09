1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.6.10;
4 
5 /*
6  * ----------------------------------------------------------------------------
7  * Theuses Token Contract
8  * 
9  * Website		: https://www.theuses.one
10  * Telegram		: https://t.me/TheusToken
11  * Twitter		: https://twitter.com/TheusToken
12  * 
13  * Symbol		: THEUS
14  * Name			: THEUSES
15  * Total Supply	: 50
16  * ----------------------------------------------------------------------------
17  */
18 
19 library SafeMath{
20  
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24         return c;
25     }
26     
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30     
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34 
35         return c;
36     }
37     
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39        if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48     
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52     
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56 
57         return c;
58     }
59     
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         return mod(a, b, "SafeMath: modulo by zero");
62     }
63     
64     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b != 0, errorMessage);
66         return a % b;
67     }
68     
69     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
70 	    uint256 c = add(a,m);
71 	    uint256 d = sub(c,1);
72 	    return mul(div(d,m),m);
73 	  }
74 }
75 
76 interface ERC20Interface {
77     function totalSupply() external view returns (uint256);
78     function balanceOf(address tokenOwner) external view returns (uint256 balance);
79     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
80     function transfer(address to, uint256 tokens) external returns (bool success);
81     function approve(address spender, uint256 tokens) external returns (bool success);
82     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
83 
84     event Transfer(address indexed from, address indexed to, uint256 tokens);
85     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
86     event Burn(address indexed from, uint256 value);
87 }
88 
89 
90 contract TheusesToken is ERC20Interface {
91     
92     using SafeMath for uint256;
93     uint256 internal _totalSupply;
94     
95     string public _symbol;
96     string public _name;
97     uint8 public _decimals;
98 
99     mapping (address => uint256) internal _balances;
100     mapping (address => mapping (address => uint256)) internal allowed;
101     mapping (address => bool) internal _whitelist;
102     bool internal _globalWhitelist = true;
103     
104     uint256 public theusesBasePercent = 100;
105     
106      constructor (string memory name, string memory symbol) public {
107         _name = name;
108         _symbol = symbol;
109         _decimals = 18;
110         _totalSupply = 50000000000000000000;
111         _balances[msg.sender] = _totalSupply;
112         emit Transfer(address(0), msg.sender, _totalSupply);
113     }
114 
115     function name() public view returns (string memory) {
116         return _name;
117     }
118 
119     function symbol() public view returns (string memory) {
120         return _symbol;
121     }
122 
123     function decimals() public view returns (uint8) {
124         return _decimals;
125     }
126 
127     function totalSupply() public view override returns (uint256) {
128         return _totalSupply;
129     }
130     
131     function balanceOf(address tokenOwner) public view override returns (uint256 balance){
132         return _balances[tokenOwner];
133     }
134     
135     function allowance(address tokenOwner, address spender) public view override returns (uint256 remaining){
136         return allowed[tokenOwner][spender];
137     }
138     
139     function transfer(address to, uint256 tokens) public override returns (bool success){
140 
141         require(tokens <= _balances[msg.sender]);
142         require(to != address(0));
143 
144         uint256 tokensToBurn = theusesPercent(tokens);
145         uint256 tokensToTransfer = tokens.sub(tokensToBurn);
146     
147         _balances[msg.sender] = _balances[msg.sender].sub(tokens);
148         _balances[to] = _balances[to].add(tokensToTransfer);
149     
150         _totalSupply = _totalSupply.sub(tokensToBurn);
151     
152         emit Transfer(msg.sender, to, tokensToTransfer);
153         emit Transfer(msg.sender, address(0), tokensToBurn);
154         return true;
155     }
156     
157      function theusesPercent(uint256 value) public view returns (uint256)  {
158 	    uint256 roundValue = value.ceil(theusesBasePercent);
159 	    uint256 _theusesPercent = roundValue.mul(theusesBasePercent).div(10000);
160 	    return _theusesPercent;
161 	  }
162 	  
163     function approve(address spender, uint256 tokens) public override returns (bool success){
164         require(msg.sender != address(0), "ERC20: approve from the zero address");
165         require(spender != address(0), "ERC20: approve to the zero address");
166         allowed[msg.sender][spender] = tokens;
167         emit Approval(msg.sender, spender, tokens);
168         return true;
169     }
170     
171     function transferFrom(address from, address to, uint256 tokens) public override returns (bool success){
172         _balances[from] = SafeMath.sub(_balances[from], tokens, "ERC20: transfer amount exceeds balance");
173         allowed[from][msg.sender] = SafeMath.sub(allowed[from][msg.sender], tokens);
174         _balances[to] = SafeMath.add(_balances[to], tokens);
175         emit Transfer(from, to, tokens);
176         return true;
177     }
178 }