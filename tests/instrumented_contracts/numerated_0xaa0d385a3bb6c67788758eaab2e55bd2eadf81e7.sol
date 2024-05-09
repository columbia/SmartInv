1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'BDS' token contract
5 //
6 // Deployed to : 0xABEb755d1d86e6043c92fbc0085094eb44DD6F6B
7 // Symbol      : BDS
8 // Name        : BDS Token
9 // Total supply: 1000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by phuongnv
15 // ----------------------------------------------------------------------------
16 
17 
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 contract BDSToken is ERC20Interface, Owned, SafeMath {
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92     
93     constructor() public {
94         symbol = "BDS";
95         name = "BDS Token";
96         decimals = 18;
97         _totalSupply = 1000000000000000000000000000;
98         balances[0xABEb755d1d86e6043c92fbc0085094eb44DD6F6B] = _totalSupply;
99         emit Transfer(address(0), 0xABEb755d1d86e6043c92fbc0085094eb44DD6F6B, _totalSupply);
100     }
101 
102 
103     function totalSupply() public constant returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107 
108     function balanceOf(address tokenOwner) public constant returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112 
113  
114     function transfer(address to, uint tokens) public returns (bool success) {
115         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
116         balances[to] = safeAdd(balances[to], tokens);
117         emit Transfer(msg.sender, to, tokens);
118         return true;
119     }
120 
121 
122 
123     function approve(address spender, uint tokens) public returns (bool success) {
124         allowed[msg.sender][spender] = tokens;
125         emit Approval(msg.sender, spender, tokens);
126         return true;
127     }
128 
129 
130    
131     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
132         balances[from] = safeSub(balances[from], tokens);
133         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
134         balances[to] = safeAdd(balances[to], tokens);
135         emit Transfer(from, to, tokens);
136         return true;
137     }
138 
139 
140 
141     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
142         return allowed[tokenOwner][spender];
143     }
144 
145 
146 
147     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         emit Approval(msg.sender, spender, tokens);
150         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
151         return true;
152     }
153 
154 
155     function () public payable {
156         revert();
157     }
158 
159 
160     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
161         return ERC20Interface(tokenAddress).transfer(owner, tokens);
162     }
163 }