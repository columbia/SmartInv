1 pragma solidity ^0.4.24;
2 
3 //Safe Math Interface
4 
5 contract SafeMath {
6 
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11 
12     function safeSub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16 
17     function safeMul(uint a, uint b) public pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21 
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 //ERC Token Standard #20 Interface
30 
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 //Contract function to receive approval and execute function in one call
45 
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 //Actual token contract
51 
52 contract FrakToken is ERC20Interface, SafeMath {
53     string public symbol;
54     string public  name;
55     uint8 public decimals;
56     uint public _totalSupply;
57 
58     mapping(address => uint) balances;
59     mapping(address => mapping(address => uint)) allowed;
60 
61     constructor() public {
62         symbol = "FRAK";
63         name = "Fraktal";
64         decimals = 18;
65         _totalSupply = 1000000000000000000000000000;
66         balances[0x80EEa8803120a4Aa95FD0d291E1CBe6Ce7c315A8] = 3000000000000000000000000;
67         balances[0x362BFCE30b3DA37bf43cF8E50e177EE87B79d236] = 6000000000000000000000000;
68         balances[0xbA7Ca3f921eAfE0De5B4C024A714067D28Da3fb3] = 2500000000000000000000000;
69         balances[0x4C1596FBA63Fe1157E90cCC51d5548E0C78E9CB8] = 3500000000000000000000000;
70         balances[0xA31b92E81318248958d8eaa691Cc8919ad7Af68F] = 7500000000000000000000000;
71         balances[0xeCc90e132a4BBdd1e6165149437a95a6133F9A4a] = 14000000000000000000000000;
72         balances[0x04BaEe1c44A982EAA7DaA6F63a7Bbc26cdc8D0C4] = 1500000000000000000000000;
73         balances[0x71924C4A7fB2B9796C3f9125DA66a6F17f905667] = 4750000000000000000000000;
74         balances[0x80943f01d7DA4Dc657eaeE1AFFB98CB7981E644d] = 7250000000000000000000000;
75         balances[0xfe94655fe300C4961b05985FDE83c02672D3A8f1] = 950000000000000000000000000;
76         emit Transfer(address(0), 0x80EEa8803120a4Aa95FD0d291E1CBe6Ce7c315A8 , 3000000000000000000000000);
77         emit Transfer(address(1), 0x362BFCE30b3DA37bf43cF8E50e177EE87B79d236 , 6000000000000000000000000);
78         emit Transfer(address(2), 0xbA7Ca3f921eAfE0De5B4C024A714067D28Da3fb3 , 2500000000000000000000000);
79         emit Transfer(address(3), 0x4C1596FBA63Fe1157E90cCC51d5548E0C78E9CB8 , 3500000000000000000000000);
80         emit Transfer(address(4), 0xA31b92E81318248958d8eaa691Cc8919ad7Af68F , 7500000000000000000000000);
81         emit Transfer(address(5), 0xeCc90e132a4BBdd1e6165149437a95a6133F9A4a , 14000000000000000000000000);
82         emit Transfer(address(6), 0x04BaEe1c44A982EAA7DaA6F63a7Bbc26cdc8D0C4 , 1500000000000000000000000);
83         emit Transfer(address(7), 0x71924C4A7fB2B9796C3f9125DA66a6F17f905667 , 4750000000000000000000000);
84         emit Transfer(address(8), 0x80943f01d7DA4Dc657eaeE1AFFB98CB7981E644d , 7250000000000000000000000);
85         emit Transfer(address(9), 0xfe94655fe300C4961b05985FDE83c02672D3A8f1 , 950000000000000000000000000);
86 
87     }
88 
89     function totalSupply() public constant returns (uint) {
90         return _totalSupply  - balances[address(0)];
91     }
92 
93     function balanceOf(address tokenOwner) public constant returns (uint balance) {
94         return balances[tokenOwner];
95     }
96 
97     function transfer(address to, uint tokens) public returns (bool success) {
98         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
99         balances[to] = safeAdd(balances[to], tokens);
100         emit Transfer(msg.sender, to, tokens);
101         return true;
102     }
103 
104     function approve(address spender, uint tokens) public returns (bool success) {
105         allowed[msg.sender][spender] = tokens;
106         emit Approval(msg.sender, spender, tokens);
107         return true;
108     }
109 
110     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
111         balances[from] = safeSub(balances[from], tokens);
112         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
113         balances[to] = safeAdd(balances[to], tokens);
114         emit Transfer(from, to, tokens);
115         return true;
116     }
117 
118     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
119         return allowed[tokenOwner][spender];
120     }
121 
122     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         emit Approval(msg.sender, spender, tokens);
125         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
126         return true;
127     }
128 
129     function () public payable {
130         revert();
131     }
132 }