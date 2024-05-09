1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'oskcoin' token contract
5 //
6 // Deployed to : 0x30FC7cbb3e0AFcfF52B230503F5ED4E49dD8cdf0
7 // Symbol      : OSK
8 // Name        : OSK Coin
9 // Total supply: 100000000000000
10 // Decimals    : 5
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract OSKCoin is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     constructor() public {
116         symbol = "OSK";
117         name = "OSK Coin";
118         decimals = 5;
119         _totalSupply = 100000000000000;
120         balances[0x30FC7cbb3e0AFcfF52B230503F5ED4E49dD8cdf0] = _totalSupply;
121         emit Transfer(address(0), 0x30FC7cbb3e0AFcfF52B230503F5ED4E49dD8cdf0, _totalSupply);
122     }
123 
124     // ------------------------------------------------------------------------
125     // Total supply
126     // ------------------------------------------------------------------------
127     function totalSupply() public constant returns (uint) {
128         return _totalSupply  - balances[address(0)];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account tokenOwner
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to to account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         emit Transfer(msg.sender, to, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for spender to transferFrom(...) tokens
155     // from the token owner's account
156     //
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer tokens from the from account to the to account
170     //
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the from account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178         balances[from] = safeSub(balances[from], tokens);
179         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180         balances[to] = safeAdd(balances[to], tokens);
181         emit Transfer(from, to, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Returns the amount of tokens approved by the owner that can be
188     // transferred to the spender's account
189     // ------------------------------------------------------------------------
190     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
191         return allowed[tokenOwner][spender];
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Token owner can approve for spender to transferFrom(...) tokens
197     // from the token owner's account. The spender contract function
198     // receiveApproval(...) is then executed
199     // ------------------------------------------------------------------------
200     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
201         allowed[msg.sender][spender] = tokens;
202         emit Approval(msg.sender, spender, tokens);
203         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Don't accept ETH
210     // ------------------------------------------------------------------------
211     function () public payable {
212         revert();
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Owner can transfer out any accidentally sent ERC20 tokens
218     // ------------------------------------------------------------------------
219     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
220         return ERC20Interface(tokenAddress).transfer(owner, tokens);
221     }
222 }