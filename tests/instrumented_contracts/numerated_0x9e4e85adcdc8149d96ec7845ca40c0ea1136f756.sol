1 pragma solidity 0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'TIXI' token contract
5 //
6 // Deployed to : 0x01DC0e734D17b1F0Faa24addc3480dCDEbeDbEDF
7 // Symbol      : TXI
8 // Name        : TIXI
9 // Total supply: 3000000000
10 // Decimals    : 18
11 //
12 // (c) by Tixeet
13 // ----------------------------------------------------------------------------
14 
15 
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
77     function Owned() public {
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
91         OwnershipTransferred(owner, newOwner);
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
102 contract TIXIToken is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function TIXIToken() public {
116         symbol = "TXI";
117         name = "TIXI";
118         decimals = 18;
119         _totalSupply = 3000000000 * 10 ** (decimals);
120         balances[0x01DC0e734D17b1F0Faa24addc3480dCDEbeDbEDF] = _totalSupply;
121         Transfer(address(0), 0x01DC0e734D17b1F0Faa24addc3480dCDEbeDbEDF, _totalSupply);
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Total supply
127     // ------------------------------------------------------------------------
128     function totalSupply() public constant returns (uint) {
129         return _totalSupply  - balances[address(0)];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Get the token balance for account tokenOwner
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public constant returns (uint balance) {
137         return balances[tokenOwner];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to to account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public returns (bool success) {
147         require(to != address(0));
148         require(tokens > 0);
149         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
150         balances[to] = safeAdd(balances[to], tokens);
151         Transfer(msg.sender, to, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for spender to transferFrom(...) tokens
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces
163     // ------------------------------------------------------------------------
164     function approve(address spender, uint tokens) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         Approval(msg.sender, spender, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Transfer tokens from the from account to the to account
173     //
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the from account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
181         require(from != address(0));
182         require(to != address(0));
183         require(tokens > 0);
184         balances[from] = safeSub(balances[from], tokens);
185         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
186         balances[to] = safeAdd(balances[to], tokens);
187         Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for spender to transferFrom(...) tokens
203     // from the token owner's account. The spender contract function
204     // receiveApproval(...) is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
207         require(spender != address(0));
208         require(tokens > 0);
209         allowed[msg.sender][spender] = tokens;
210         Approval(msg.sender, spender, tokens);
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Don't accept ETH
218     // ------------------------------------------------------------------------
219     function () public payable {
220         revert();
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230 }