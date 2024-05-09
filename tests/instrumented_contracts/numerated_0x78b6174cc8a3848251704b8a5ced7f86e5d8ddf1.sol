1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 
35 contract ApproveAndCallFallBack {
36     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
37 }
38 
39 
40 contract Owned {
41     address public owner;
42     address public newOwner;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         newOwner = _newOwner;
57     }
58     function acceptOwnership() public {
59         require(msg.sender == newOwner);
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 
67 contract Wider is ERC20Interface, Owned, SafeMath {
68     string public symbol;
69     string public  name;
70     uint8 public decimals;
71     uint public _totalSupply;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76 
77     constructor() public {
78         symbol = "WDR";
79         name = "Wider";
80         decimals = 8;
81         _totalSupply = 2100000000000000000;
82         balances[0x6B1C392Caa5747ea50A3BD6B08F8b5e7B6D5E9d2] = _totalSupply;
83         emit Transfer(address(0), 0x6B1C392Caa5747ea50A3BD6B08F8b5e7B6D5E9d2, _totalSupply);
84     }
85 
86 
87     function totalSupply() public constant returns (uint) {
88         return _totalSupply  - balances[address(0)];
89     }
90 
91 
92     function balanceOf(address tokenOwner) public constant returns (uint balance) {
93         return balances[tokenOwner];
94     }
95 
96 
97     function transfer(address to, uint tokens) public returns (bool success) {
98         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
99         balances[to] = safeAdd(balances[to], tokens);
100         emit Transfer(msg.sender, to, tokens);
101         return true;
102     }
103 
104 
105     function approve(address spender, uint tokens) public returns (bool success) {
106         allowed[msg.sender][spender] = tokens;
107         emit Approval(msg.sender, spender, tokens);
108         return true;
109     }
110 
111 
112     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
113         balances[from] = safeSub(balances[from], tokens);
114         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
115         balances[to] = safeAdd(balances[to], tokens);
116         emit Transfer(from, to, tokens);
117         return true;
118     }
119 
120 
121     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
122         return allowed[tokenOwner][spender];
123     }
124 
125 
126     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
130         return true;
131     }
132 
133 
134  
135     function () public payable {
136         revert();
137     }
138 
139 
140     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
141         return ERC20Interface(tokenAddress).transfer(owner, tokens);
142     }
143 }