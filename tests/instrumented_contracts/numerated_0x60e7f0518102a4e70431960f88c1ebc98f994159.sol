1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }
41 
42 
43 
44 contract Owned {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58 
59 
60 }
61 
62 
63 
64 contract Exenox is ERC20Interface, Owned, SafeMath {
65     string public symbol;
66     string public  name;
67     uint public decimals;
68     uint private _totalSupply;
69 
70     mapping(address => uint) balances;
71     mapping(address => mapping(address => uint)) allowed;
72 
73 
74     
75     constructor() public {
76         symbol = "EXNX";
77         name = "Exenox Mobile";
78         decimals = 6;
79         _totalSupply = 5000000;
80         _totalSupply = _totalSupply * 10 ** decimals;
81         balances[0x8bFa646B6bBdEd4f64c950caE884C22C1F0d38A9] = _totalSupply;
82         emit Transfer(address(0), owner, _totalSupply);
83     }
84 
85     
86     function totalSupply() public constant returns (uint) {
87         return _totalSupply;
88     }
89     
90     
91     function balanceOf(address tokenOwner) public constant returns (uint balance) {
92         return balances[tokenOwner];
93     }
94 
95 
96     
97     function transfer(address to, uint _tokens) public returns (bool success) {
98         
99         uint tokensBurn =  (_tokens/100);
100         uint readyTokens = safeSub(_tokens, tokensBurn);
101         burn(owner, tokensBurn);
102         
103         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
104         balances[to] = safeAdd(balances[to], readyTokens);
105         emit Transfer(msg.sender, to, readyTokens);
106         return true;
107     }
108 
109 
110     
111     function approve(address spender, uint tokens) public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         emit Approval(msg.sender, spender, tokens);
114         return true;
115     }
116 
117 
118     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
119         balances[from] = safeSub(balances[from], tokens);
120         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
121         balances[to] = safeAdd(balances[to], tokens);
122         emit Transfer(from, to, tokens);
123         return true;
124     }
125 
126 
127    
128     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
129         return allowed[tokenOwner][spender];
130     }
131 
132 
133     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
134         allowed[msg.sender][spender] = tokens;
135         emit Approval(msg.sender, spender, tokens);
136         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
137         return true;
138     }
139 
140 
141     function () public payable {
142         revert();
143     }
144 
145 
146     function transferOwnership(address _newOwner) public onlyOwner {
147         owner = _newOwner;
148     }
149 
150 
151     
152      
153     function burn(address account, uint256 value) private {
154         require(account != address(0)); 
155 
156         _totalSupply = safeSub(_totalSupply, value);
157         balances[account] = safeSub(balances[account], value);
158     }
159 }