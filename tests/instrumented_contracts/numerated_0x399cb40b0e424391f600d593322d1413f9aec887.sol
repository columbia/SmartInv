1 pragma solidity 0.6.0;
2 
3 abstract contract IERC20 {
4     function totalSupply() public view virtual returns (uint256);
5 
6     function balanceOf(address tokenOwner)
7         public
8         view
9         virtual
10         returns (uint256);
11 
12     function allowance(address tokenOwner, address spender)
13         public
14         view
15         virtual
16         returns (uint256);
17 
18     function transfer(address to, uint256 tokens) public virtual returns (bool);
19 
20     function approve(address spender, uint256 tokens)
21         public
22         virtual
23         returns (bool);
24 
25     function transferFrom(
26         address from,
27         address to,
28         uint256 tokens
29     ) public virtual returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 tokens);
32     event Approval(
33         address indexed tokenOwner,
34         address indexed spender,
35         uint256 tokens
36     );
37 }
38 
39 contract SafeMath {
40     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         uint256 c = a - b;
49         return c;
50     }
51 }
52 
53 contract cheerscoin is IERC20, SafeMath {
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57 
58     uint256 public _totalSupply;
59     address public owner = 0x39269FC3Ce8059dCfAF92138FcAe38bF2E326226;
60 
61     mapping(address => uint256) balances;
62     mapping(address => mapping(address => uint256)) allowed;
63 
64     constructor() public payable {
65         name = "cheerscoin";
66         symbol = "CHC";
67         decimals = 18;
68         _totalSupply = 2000000000 * 10**uint256(decimals);
69         balances[owner] = _totalSupply;
70         emit Transfer(address(0), owner, _totalSupply);
71     }
72 
73     function allowance(address tokenOwner, address spender)
74         public
75         view
76         virtual
77         override
78         returns (uint256 remaining)
79     {
80         return allowed[tokenOwner][spender];
81     }
82 
83     function approve(address spender, uint256 tokens)
84         public
85         virtual
86         override
87         returns (bool success)
88     {
89         require(tokens >= 0, "Invalid value");
90         allowed[msg.sender][spender] = tokens;
91         emit Approval(msg.sender, spender, tokens);
92         return true;
93     }
94 
95     function transfer(address to, uint256 tokens)
96         public
97         virtual
98         override
99         returns (bool success)
100     {
101         require(to != address(0), "Null address");
102         require(tokens > 0, "Invalid Value");
103         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         emit Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109     function transferFrom(
110         address from,
111         address to,
112         uint256 tokens
113     ) public virtual override returns (bool success) {
114         require(to != address(0), "Null address");
115         require(from != address(0), "Null address");
116         require(tokens > 0, "Invalid value");
117         require(tokens <= balances[from], "Insufficient balance");
118         require(tokens <= allowed[from][msg.sender], "Insufficient allowance");
119         balances[from] = safeSub(balances[from], tokens);
120         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
121         balances[to] = safeAdd(balances[to], tokens);
122         emit Transfer(from, to, tokens);
123         return true;
124     }
125 
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129 
130     function balanceOf(address tokenOwner)
131         public
132         view
133         virtual
134         override
135         returns (uint256 balance)
136     {
137         return balances[tokenOwner];
138     }
139 
140     function burn(uint256 _amount) public returns (bool) {
141         require(_amount >= 0, "Invalid amount");
142         require(owner == msg.sender, "UnAuthorized");
143         require(_amount <= balances[msg.sender], "Insufficient Balance");
144         _totalSupply = safeSub(_totalSupply, _amount);
145         balances[owner] = safeSub(balances[owner], _amount);
146         emit Transfer(owner, address(0), _amount);
147         return true;
148     }
149 }