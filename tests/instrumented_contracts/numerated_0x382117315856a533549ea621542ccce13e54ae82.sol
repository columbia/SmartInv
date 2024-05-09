1 pragma solidity ^0.4.18;
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
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // Contract function to receive approval and execute function in one call
42 //
43 // Borrowed from MiniMeToken
44 // ----------------------------------------------------------------------------
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Owned contract
52 // ----------------------------------------------------------------------------
53 contract Owned {
54     address public owner;
55     address public newOwner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     function Owned() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         newOwner = _newOwner;
70     }
71     function acceptOwnership() public {
72         require(msg.sender == newOwner);
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75         newOwner = address(0);
76     }
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 // ERC20 Token, with the addition of symbol, name and decimals and assisted
82 // token transfers
83 // ----------------------------------------------------------------------------
84 contract BitBall is ERC20Interface, Owned, SafeMath {
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94     // ------------------------------------------------------------------------
95     // Constructor
96     // ------------------------------------------------------------------------
97     function BitBall() public {
98         symbol = "BTB";
99         name = "BitBall";
100         decimals = 18;
101         _totalSupply = 1000000000000000000000000000;
102         balances[0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992] = _totalSupply;
103         Transfer(address(0), 0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992, _totalSupply);
104     }
105 
106 
107     // ------------------------------------------------------------------------
108     // Total supply
109     // ------------------------------------------------------------------------
110     function totalSupply() public constant returns (uint) {
111         return _totalSupply  - balances[address(0)];
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Get the token balance for account tokenOwner
117     // ------------------------------------------------------------------------
118     function balanceOf(address tokenOwner) public constant returns (uint balance) {
119         return balances[tokenOwner];
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Transfer the balance from token owner's account to to account
125     // - Owner's account must have sufficient balance to transfer
126     // - 0 value transfers are allowed
127     // ------------------------------------------------------------------------
128     function transfer(address to, uint tokens) public returns (bool success) {
129         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
130         balances[to] = safeAdd(balances[to], tokens);
131         Transfer(msg.sender, to, tokens);
132         return true;
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Token owner can approve for spender to transferFrom(...) tokens
138     // from the token owner's account
139     //
140     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
141     // recommends that there are no checks for the approval double-spend attack
142     // as this should be implemented in user interfaces 
143     // ------------------------------------------------------------------------
144     function approve(address spender, uint tokens) public returns (bool success) {
145         allowed[msg.sender][spender] = tokens;
146         Approval(msg.sender, spender, tokens);
147         return true;
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Transfer tokens from the from account to the to account
153     // 
154     // The calling account must already have sufficient tokens approve(...)-d
155     // for spending from the from account and
156     // - From account must have sufficient balance to transfer
157     // - Spender must have sufficient allowance to transfer
158     // - 0 value transfers are allowed
159     // ------------------------------------------------------------------------
160     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
161         balances[from] = safeSub(balances[from], tokens);
162         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
163         balances[to] = safeAdd(balances[to], tokens);
164         Transfer(from, to, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Returns the amount of tokens approved by the owner that can be
171     // transferred to the spender's account
172     // ------------------------------------------------------------------------
173     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Token owner can approve for spender to transferFrom(...) tokens
180     // from the token owner's account. The spender contract function
181     // receiveApproval(...) is then executed
182     // ------------------------------------------------------------------------
183     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
184         allowed[msg.sender][spender] = tokens;
185         Approval(msg.sender, spender, tokens);
186         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Don't accept ETH
193     // ------------------------------------------------------------------------
194     function () public payable {
195         revert();
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Owner can transfer out any accidentally sent ERC20 tokens
201     // ------------------------------------------------------------------------
202     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
203         return ERC20Interface(tokenAddress).transfer(owner, tokens);
204     }
205 }