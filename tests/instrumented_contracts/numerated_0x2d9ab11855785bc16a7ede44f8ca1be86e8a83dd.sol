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
22 
23 
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
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
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 
71 
72 contract CitodelProject is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82     
83     constructor() public {
84         symbol = "CTP";
85         name = "Citodel Project";
86         decimals = 2;
87         _totalSupply = 50000000000;
88         balances[0x6e3c741447B6CD379ac42B9eC274c4d26D0e605D] = _totalSupply;
89         emit Transfer(address(0), 0x6e3c741447B6CD379ac42B9eC274c4d26D0e605D, _totalSupply);
90     }
91 
92 
93     
94     function totalSupply() public constant returns (uint) {
95         return _totalSupply  - balances[address(0)];
96     }
97 
98 
99     
100     function balanceOf(address tokenOwner) public constant returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104 
105     
106     function transfer(address to, uint tokens) public returns (bool success) {
107         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
108         balances[to] = safeAdd(balances[to], tokens);
109         emit Transfer(msg.sender, to, tokens);
110         return true;
111     }
112 
113     function approve(address spender, uint tokens) public returns (bool success) {
114         allowed[msg.sender][spender] = tokens;
115         emit Approval(msg.sender, spender, tokens);
116         return true;
117     }
118 
119 
120     
121     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
122         balances[from] = safeSub(balances[from], tokens);
123         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
124         balances[to] = safeAdd(balances[to], tokens);
125         emit Transfer(from, to, tokens);
126         return true;
127     }
128 
129 
130     
131     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
132         return allowed[tokenOwner][spender];
133     }
134 
135 
136     
137     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
138         allowed[msg.sender][spender] = tokens;
139         emit Approval(msg.sender, spender, tokens);
140         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
141         return true;
142     }
143 
144 
145     
146     function () public payable {
147         revert();
148     }
149 
150 
151     
152     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
153         return ERC20Interface(tokenAddress).transfer(owner, tokens);
154     }
155 }