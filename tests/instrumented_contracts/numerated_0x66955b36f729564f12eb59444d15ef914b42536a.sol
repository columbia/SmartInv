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
52 contract FOODToken is ERC20Interface, SafeMath {
53     string public symbol;
54     string public  name;
55     uint8 public decimals;
56     uint public _totalSupply;
57 
58     mapping(address => uint) balances;
59     mapping(address => mapping(address => uint)) allowed;
60 
61     constructor() public {
62         symbol = "FOOD";
63         name = "FOOD FOR DEGENS";
64         decimals = 18;
65         _totalSupply = 11000000000 * 10**18;
66         balances[0x76B42699819cE0a183fa71404eC25Ffa9baA243E] = _totalSupply;
67         emit Transfer(address(0),0x76B42699819cE0a183fa71404eC25Ffa9baA243E, _totalSupply);
68     }
69 
70     function totalSupply() public constant returns (uint) {
71         return _totalSupply  - balances[address(0)];
72     }
73 
74     function balanceOf(address tokenOwner) public constant returns (uint balance) {
75         return balances[tokenOwner];
76     }
77 
78     function transfer(address to, uint tokens) public returns (bool success) {
79         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
80         balances[to] = safeAdd(balances[to], tokens);
81         emit Transfer(msg.sender, to, tokens);
82         return true;
83     }
84 
85     function approve(address spender, uint tokens) public returns (bool success) {
86         allowed[msg.sender][spender] = tokens;
87         emit Approval(msg.sender, spender, tokens);
88         return true;
89     }
90 
91     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
92         balances[from] = safeSub(balances[from], tokens);
93         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
94         balances[to] = safeAdd(balances[to], tokens);
95         emit Transfer(from, to, tokens);
96         return true;
97     }
98 
99     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
100         return allowed[tokenOwner][spender];
101     }
102 
103     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
104         allowed[msg.sender][spender] = tokens;
105         emit Approval(msg.sender, spender, tokens);
106         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
107         return true;
108     }
109 
110     function () public payable {
111         revert();
112     }
113 }