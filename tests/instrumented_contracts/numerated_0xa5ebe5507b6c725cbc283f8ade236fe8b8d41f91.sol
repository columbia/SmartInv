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
29 
30 //ERC Token Standard #20 Interface
31  
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39  
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43  
44  
45 //Contract function to receive approval and execute function in one call
46  
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50  
51 //Actual token contract
52  
53 contract FourTwentyCHAN is ERC20Interface, SafeMath {
54     string public symbol;
55     string public  name;
56     uint8 public decimals;
57     uint public _totalSupply;
58  
59     mapping(address => uint) balances;
60     mapping(address => mapping(address => uint)) allowed;
61  
62     constructor() public {
63         symbol = "$420CHAN";
64         name = "420CHAN";
65         decimals = 18;
66         _totalSupply = 420000000000000000000000000000000;
67         balances[0xa57682abFf4E3FA3FbF3dEaA16a82c64f861033F] = _totalSupply;
68         emit Transfer(address(0), 0xa57682abFf4E3FA3FbF3dEaA16a82c64f861033F, _totalSupply);
69     }
70  
71     function totalSupply() public constant returns (uint) {
72         return _totalSupply  - balances[address(0)];
73     }
74  
75     function balanceOf(address tokenOwner) public constant returns (uint balance) {
76         return balances[tokenOwner];
77     }
78  
79     function transfer(address to, uint tokens) public returns (bool success) {
80         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
81         balances[to] = safeAdd(balances[to], tokens);
82         emit Transfer(msg.sender, to, tokens);
83         return true;
84     }
85  
86     function approve(address spender, uint tokens) public returns (bool success) {
87         allowed[msg.sender][spender] = tokens;
88         emit Approval(msg.sender, spender, tokens);
89         return true;
90     }
91  
92     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
93         balances[from] = safeSub(balances[from], tokens);
94         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
95         balances[to] = safeAdd(balances[to], tokens);
96         emit Transfer(from, to, tokens);
97         return true;
98     }
99  
100     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
101         return allowed[tokenOwner][spender];
102     }
103  
104     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
105         allowed[msg.sender][spender] = tokens;
106         emit Approval(msg.sender, spender, tokens);
107         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
108         return true;
109     }
110  
111     function () public payable {
112         revert();
113     }
114 }