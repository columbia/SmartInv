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
34 //nötig?
35 contract ApproveAndCallFallBack {
36     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
37 }
38 
39 contract Owned {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 contract BNT is ERC20Interface, Owned, SafeMath {
66     string public symbol;
67     string public  name;
68     uint8 public decimals;
69     uint public _totalSupply;
70 
71     mapping(address => uint) balances;
72     mapping(address => mapping(address => uint)) allowed;
73 
74 
75     constructor() public {
76         symbol = "BNT";
77         name = "bNet Token";
78         decimals = 0;
79         _totalSupply = 1000000;
80         balances[0xE7f73e9AB3b022eDFA25fe17392b646a0A081dA2] = _totalSupply;
81         emit Transfer(address(0), 0xE7f73e9AB3b022eDFA25fe17392b646a0A081dA2, _totalSupply);
82     }
83 
84     function totalSupply() public constant returns (uint) {
85         return _totalSupply  - balances[address(0)];
86     }
87 
88     function balanceOf(address tokenOwner) public constant returns (uint balance) {
89         return balances[tokenOwner];
90     }
91 
92     function transfer(address to, uint tokens) public returns (bool success) {
93         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
94         balances[to] = safeAdd(balances[to], tokens);
95         emit Transfer(msg.sender, to, tokens);
96         return true;
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Token owner can approve for spender to transferFrom(...) tokens
102     // from the token owner's account
103     //
104     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
105     // recommends that there are no checks for the approval double-spend attack
106     // as this should be implemented in user interfaces 
107     // ------------------------------------------------------------------------
108     function approve(address spender, uint tokens) public returns (bool success) {
109         allowed[msg.sender][spender] = tokens;
110         emit Approval(msg.sender, spender, tokens);
111         return true;
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Transfer tokens from the from account to the to account
117     // 
118     // The calling account must already have sufficient tokens approve(...)-d
119     // for spending from the from account and
120     // - From account must have sufficient balance to transfer
121     // - Spender must have sufficient allowance to transfer
122     // - 0 value transfers are allowed
123     // ------------------------------------------------------------------------
124     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
125         balances[from] = safeSub(balances[from], tokens);
126         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         emit Transfer(from, to, tokens);
129         return true;
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Returns the amount of tokens approved by the owner that can be
135     // transferred to the spender's account
136     // ------------------------------------------------------------------------
137     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
138         return allowed[tokenOwner][spender];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Token owner can approve for spender to transferFrom(...) tokens
144     // from the token owner's account. The spender contract function
145     // receiveApproval(...) is then executed
146     // ------------------------------------------------------------------------
147     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         emit Approval(msg.sender, spender, tokens);
150         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
151         return true;
152     }
153 }