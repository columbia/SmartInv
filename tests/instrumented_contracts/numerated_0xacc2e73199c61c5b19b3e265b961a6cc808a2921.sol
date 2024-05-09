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
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // ERC20 Token, with the addition of symbol, name and decimals and assisted
70 // token transfers
71 // ----------------------------------------------------------------------------
72 contract Currytoken is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82     // ------------------------------------------------------------------------
83     // Constructor
84     // ------------------------------------------------------------------------
85     constructor() public {
86         symbol = "Curr";
87         name = "Curry Token";
88         decimals = 18;
89         _totalSupply = 1000000000000000000000000;
90         balances[0xb628cc9100e530eAc17968091E4E10c1Fd9698fe] = _totalSupply;
91         emit Transfer(address(0), 0xb628cc9100e530eAc17968091E4E10c1Fd9698fe, _totalSupply);
92     }
93 
94 
95     // ------------------------------------------------------------------------
96     // Total supply
97     // ------------------------------------------------------------------------
98     function totalSupply() public constant returns (uint) {
99         return _totalSupply  - balances[address(0)];
100     }
101 
102 
103     // ------------------------------------------------------------------------
104     // Get the token balance for account tokenOwner
105     // ------------------------------------------------------------------------
106     function balanceOf(address tokenOwner) public constant returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Transfer the balance from token owner's account to to account
113     // - Owner's account must have sufficient balance to transfer
114     // - 0 value transfers are allowed
115     // ------------------------------------------------------------------------
116     function transfer(address to, uint tokens) public returns (bool success) {
117         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
118         balances[to] = safeAdd(balances[to], tokens);
119         emit Transfer(msg.sender, to, tokens);
120         return true;
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Token owner can approve for spender to transferFrom(...) tokens
126     // from the token owner's account
127     //
128     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
129     // recommends that there are no checks for the approval double-spend attack
130     // as this should be implemented in user interfaces 
131     // ------------------------------------------------------------------------
132     function approve(address spender, uint tokens) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer tokens from the from account to the to account
141     // 
142     // The calling account must already have sufficient tokens approve(...)-d
143     // for spending from the from account and
144     // - From account must have sufficient balance to transfer
145     // - Spender must have sufficient allowance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
149         balances[from] = safeSub(balances[from], tokens);
150         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         emit Transfer(from, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Returns the amount of tokens approved by the owner that can be
159     // transferred to the spender's account
160     // ------------------------------------------------------------------------
161     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
162         return allowed[tokenOwner][spender];
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for spender to transferFrom(...) tokens
168     // from the token owner's account. The spender contract function
169     // receiveApproval(...) is then executed
170     // ------------------------------------------------------------------------
171     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender, spender, tokens);
174         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Don't accept ETH
181     // ------------------------------------------------------------------------
182     function () public payable {
183         revert();
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Owner can transfer out any accidentally sent ERC20 tokens
189     // ------------------------------------------------------------------------
190     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
191         return ERC20Interface(tokenAddress).transfer(owner, tokens);
192     }
193 }