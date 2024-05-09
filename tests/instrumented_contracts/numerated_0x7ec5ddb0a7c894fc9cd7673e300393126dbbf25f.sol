1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4   function safeSub(uint256 a, uint256 b) public pure returns (uint256) {
5     require(b <= a);
6     return a - b;
7   }
8 
9   function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
10     uint256 c = a + b;
11     require(c>=a && c>=b);
12     return c;
13   }
14 }
15 
16 contract ERC20Interface {
17     function totalSupply() public constant returns (uint);
18     function balanceOf(address tokenOwner) public constant returns (uint balance);
19     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
20     function extendTotalSupply(uint256 tokens) public returns (bool success);
21     function transfer(address to, uint tokens) public returns (bool success);
22     function approve(address spender, uint tokens) public returns (bool success);
23     function transferFrom(address from, address to, uint tokens) public returns (bool success);
24 
25     event Transfer(address indexed from, address indexed to, uint tokens);
26     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
27 }
28 
29 contract VINA is ERC20Interface, SafeMath {
30     string public name;
31     string public symbol;
32     uint8 public decimals;
33     uint public _totalSupply;
34 	address public owner;
35 	
36     mapping(address => uint) balances;
37     mapping(address => mapping(address => uint)) allowed;
38 	mapping(address => uint256) freezes;
39 	
40     event Burn(address indexed from, uint256 value);
41 	
42     event Freeze(address indexed from, uint256 value);
43 	
44     event Unfreeze(address indexed from, uint256 value);
45 
46     constructor(uint initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) public {
47         symbol = tokenSymbol;
48         name = tokenName;
49         decimals = decimalUnits;
50         _totalSupply = initialSupply;
51 		owner = msg.sender;
52         balances[msg.sender] = _totalSupply;
53 
54         emit Transfer(address(0), msg.sender, _totalSupply);
55     }
56     
57     function freezeOf(address _tokenOwner) public constant returns (uint) {
58         return freezes[_tokenOwner];
59     }
60     
61     function totalSupply() public constant returns (uint) {
62         return _totalSupply;
63     }
64 
65     function balanceOf(address _tokenOwner) public constant returns (uint balance) {
66         return balances[_tokenOwner];
67     }
68 
69     function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {
70         return allowed[_tokenOwner][_spender];
71     }
72 
73     function extendTotalSupply(uint256 tokens) public returns (bool success) {
74 		require(tokens > 0); 
75         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
76         _totalSupply = safeAdd(_totalSupply, tokens);
77         return true;
78     }
79 
80     function transfer(address to, uint tokens) public returns (bool success) {
81         require(to != address(0));
82 		require(tokens > 0);
83         require(balances[msg.sender] >= tokens);
84         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
85         balances[to] = safeAdd(balances[to], tokens);
86         emit Transfer(msg.sender, to, tokens);
87         return true;
88     }
89 
90     function approve(address spender, uint tokens) public returns (bool success) {
91 		require(tokens > 0); 
92         allowed[msg.sender][spender] = tokens;
93         emit Approval(msg.sender, spender, tokens);
94         return true;
95     }
96 
97     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
98         require(to != address(0));                                      // Prevent transfer to 0x0 address. Use burn() instead
99 		require(tokens > 0); 
100         require(balances[from] >= tokens);                              // Check if the sender has enough
101         require(allowed[from][msg.sender] >= tokens);                   // Check allowance
102         balances[from] = safeSub(balances[from], tokens);
103         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);                   // Updates balance
105         emit Transfer(from, to, tokens);
106         return true;
107     }
108     
109 	function freeze(uint256 tokens) public returns (bool success) {
110         require(balances[msg.sender] >= tokens);                        // Check if the sender has enough
111 		require(tokens > 0); 
112         balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender
113         freezes[msg.sender] = safeAdd(freezes[msg.sender], tokens);     // Updates freeze
114         emit Freeze(msg.sender, tokens);
115         return true;
116     }
117 	
118 	function unfreeze(uint256 tokens) public returns (bool success) {
119         require(freezes[msg.sender] >= tokens);                        // Check if the sender has enough
120 		require(tokens > 0); 
121         freezes[msg.sender] = safeSub(freezes[msg.sender], tokens);     // Subtract from the sender
122 		balances[msg.sender] = safeAdd(balances[msg.sender], tokens);   // Updates balance
123         emit Unfreeze(msg.sender, tokens);
124         return true;
125     }
126     
127     function burn(uint256 tokens) public returns (bool success) {
128         require(balances[msg.sender] >= tokens);                        // Check if the sender has enough
129 		require(tokens > 0); 
130         balances[msg.sender] = safeSub(balances[msg.sender], tokens);   // Subtract from the sender
131         _totalSupply = safeSub(_totalSupply, tokens);                   // Updates totalSupply
132         emit Burn(msg.sender, tokens);
133         return true;
134     }
135 
136 	function() public payable {
137         revert();
138     }
139 }