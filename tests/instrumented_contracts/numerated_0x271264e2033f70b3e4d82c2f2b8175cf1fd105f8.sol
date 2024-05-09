1 /**
2 
3                                                             
4                                                                                                                                    
5                                                                                                                                                               
6 */
7 
8 pragma solidity ^0.5.0;
9 
10 // Standar ERC Token Interface
11 contract ERC20Interface {
12     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
13    
14     function approve(address spender, uint tokens) public returns (bool success);
15     function totalSupply() public view returns (uint);
16    
17     function balanceOf(address tokenOwner) public view returns (uint balance);
18     function transfer(address to, uint tokens) public returns (bool success);
19     function transferFrom(address from, address to, uint tokens) public returns (bool success);
20      
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22     event Transfer(address indexed from, address indexed to, uint tokens);
23     
24 }
25 
26 // ----------------------------------------------------------------------------
27 // Safe Math Library 
28 // ----------------------------------------------------------------------------
29 library SafeMath {
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33       }
34     
35       function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39       }
40     
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43           return 0;
44         }
45         uint256 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49     
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a / b;
52         return c;
53     }
54     
55     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
56         uint256 c = add(a,m);
57         uint256 d = sub(c,1);
58         return mul(div(d,m),m);
59     }
60 }
61 
62 
63 contract SUS is ERC20Interface {
64     
65     using SafeMath for uint256;
66     string public name;
67     string public symbol;
68     uint8 public decimals; // 18 standard decimal place
69     
70     uint256 public basePercent = 230;
71     uint256 public _totalSupply;
72     
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76     constructor() public {
77         name = "sus.finance";
78         symbol = "SUS";
79         decimals = 18;
80         _totalSupply = 10000000000000000000000;
81         
82         balances[msg.sender] = _totalSupply;
83         emit Transfer(address(0), msg.sender, _totalSupply);
84     }
85     
86     function balanceOf(address tokenOwner) public view returns (uint balance) {
87         return balances[tokenOwner];
88     }
89     
90     function approve(address spender, uint tokens) public returns (bool success) {
91         allowed[msg.sender][spender] = tokens;
92         emit Approval(msg.sender, spender, tokens);
93         return true;
94     }
95     
96     
97     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
98         balances[from] = balances[from].sub(tokens);
99         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
100         balances[to] = balances[to].add(tokens);
101         emit Transfer(from, to, tokens);
102         return true;
103     }
104     
105     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
106         return allowed[tokenOwner][spender];
107     }
108     
109     function findBurnPercent(uint256 value) public view returns (uint256)  {
110         uint256 roundValue = value.ceil(basePercent);
111         uint256 onePercent = roundValue.mul(basePercent).div(10000); // 2 percent burn
112         return onePercent;
113       }
114     
115     function transfer(address to, uint value) public returns (bool success) {
116         // balances[msg.sender] = safeSub(balances[msg.sender], tokens);
117         // balances[to] = safeAdd(balances[to], tokens);
118         // emit Transfer(msg.sender, to, tokens);
119         // return true;
120         
121         require(value <= balances[msg.sender]);
122         require(to != address(0));
123     
124         uint256 tokensToBurn = findBurnPercent(value);
125         uint256 tokensToTransfer = value.sub(tokensToBurn);
126     
127         balances[msg.sender] = balances[msg.sender].sub(value);
128         balances[to] = balances[to].add(tokensToTransfer);
129     
130         _totalSupply = _totalSupply.sub(tokensToBurn);
131     
132         emit Transfer(msg.sender, to, tokensToTransfer);
133         emit Transfer(msg.sender, address(0), tokensToBurn);
134         return true;
135     }
136     
137     function totalSupply() public view returns (uint) {
138         return _totalSupply  - balances[address(0)];
139     }
140     
141 }