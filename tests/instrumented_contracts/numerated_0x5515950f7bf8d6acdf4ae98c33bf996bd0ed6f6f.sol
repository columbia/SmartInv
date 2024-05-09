1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) public pure returns (uint256) {
5     uint256 c = a * b;
6     require(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) public pure returns (uint256) {
11     require(b > 0);
12     uint256 c = a / b;
13     require(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) public pure returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
23     uint256 c = a + b;
24     require(c>=a && c>=b);
25     return c;
26   }
27 }
28 
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 contract FNX is ERC20Interface, SafeMath {
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint public _totalSupply;
46 	address public owner;
47 	
48     mapping(address => uint) balances;
49     mapping(address => mapping(address => uint)) allowed;
50 	mapping(address => uint256) freezes;
51 	
52     event Burn(address indexed from, uint256 value);
53 	
54     event Freeze(address indexed from, uint256 value);
55 	
56     event Unfreeze(address indexed from, uint256 value);
57 
58     constructor(uint initialSupply, string tokenName,
59                 uint8 decimalUnits, string tokenSymbol) public {
60         symbol = tokenSymbol;
61         name = tokenName;
62         decimals = decimalUnits;
63         _totalSupply = initialSupply;
64 		owner = msg.sender;
65         balances[msg.sender] = _totalSupply;
66         emit Transfer(address(0), msg.sender, _totalSupply);
67     }
68     
69     function freezeOf(address _tokenOwner) public constant returns (uint) {
70         return freezes[_tokenOwner];
71     }
72     
73     function totalSupply() public constant returns (uint) {
74         return _totalSupply;
75     }
76 
77     function balanceOf(address _tokenOwner) public constant returns (uint balance) {
78         return balances[_tokenOwner];
79     }
80 
81     function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {
82         return allowed[_tokenOwner][_spender];
83     }
84 
85     function transfer(address to, uint tokens) public returns (bool success) {
86         require(to != address(0));
87 		require(tokens > 0);
88         require(balances[msg.sender] >= tokens);
89         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
90         balances[to] = safeAdd(balances[to], tokens);
91         emit Transfer(msg.sender, to, tokens);
92         return true;
93     }
94 
95     function approve(address spender, uint tokens) public returns (bool success) {
96 		require(tokens > 0); 
97         allowed[msg.sender][spender] = tokens;
98         emit Approval(msg.sender, spender, tokens);
99         return true;
100     }
101 
102     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
103         require(to != address(0));                                      // Prevent transfer to 0x0 address. Use burn() instead
104 		require(tokens > 0); 
105         require(balances[from] >= tokens);                              // Check if the sender has enough
106         require(allowed[from][msg.sender] >= tokens);                   // Check allowance
107         balances[from] = safeSub(balances[from], tokens);
108         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);                   // Updates balance
110         emit Transfer(from, to, tokens);
111         return true;
112     }
113     
114 	function freeze(uint256 tokens) public returns (bool success) {
115         require(balances[msg.sender] >= tokens);                        // Check if the sender has enough
116 		require(tokens > 0); 
117         balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender
118         freezes[msg.sender] = safeAdd(freezes[msg.sender], tokens);     // Updates freeze
119         emit Freeze(msg.sender, tokens);
120         return true;
121     }
122 	
123 	function unfreeze(uint256 tokens) public returns (bool success) {
124         require(balances[msg.sender] >= tokens);                        // Check if the sender has enough
125 		require(tokens > 0); 
126         freezes[msg.sender] = safeSub(freezes[msg.sender], tokens);     // Subtract from the sender
127 		balances[msg.sender] = safeAdd(balances[msg.sender], tokens);   // Updates balance
128         emit Unfreeze(msg.sender, tokens);
129         return true;
130     }
131     
132     function burn(uint256 tokens) public returns (bool success) {
133         require(balances[msg.sender] >= tokens);                        // Check if the sender has enough
134 		require(tokens > 0); 
135         balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender
136         _totalSupply = safeSub(_totalSupply, tokens);                   // Updates totalSupply
137         emit Burn(msg.sender, tokens);
138         return true;
139     }
140 
141 	function() public payable {
142         revert();
143     }
144 }