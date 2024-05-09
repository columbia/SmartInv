1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'CashTelex' CROWDSALE token contract
5 //
6 // Deployed to : 0x17F28BD2c1B22c07899cA7EF7Bf586B7A4e6fCf4
7 // Symbol      : CTLX
8 // Name        : Cash Telex 
9 // Total supply: 1 billion
10 // Total supply: Generated from contributions
11 // Decimals    : 18
12 //
13 //
14 //  by Cash Telex Team.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and assisted
98 // token transfers
99 // ----------------------------------------------------------------------------
100 contract CashTelexToken is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public _totalSupply;
105     uint public startDate;
106     uint public bonusEnds;
107     uint public endDate;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     function CashTelexToken() public {
117         symbol = "CTLX";
118         name = "Cash Telex Token";
119         decimals = 18;
120         bonusEnds = now + 3 weeks;
121         endDate = now + 21 weeks;
122 
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public constant returns (uint) {
130         return _totalSupply  - balances[address(0)];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Get the token balance for account `tokenOwner`
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public constant returns (uint balance) {
138         return balances[tokenOwner];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint tokens) public returns (bool success) {
148         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
149         balances[to] = safeAdd(balances[to], tokens);
150         Transfer(msg.sender, to, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Token owner can approve for `spender` to transferFrom(...) `tokens`
157     // from the token owner's account
158     //
159     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
160     // recommends that there are no checks for the approval double-spend attack
161     // as this should be implemented in user interfaces
162     // ------------------------------------------------------------------------
163     function approve(address spender, uint tokens) public returns (bool success) {
164         allowed[msg.sender][spender] = tokens;
165         Approval(msg.sender, spender, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Transfer `tokens` from the `from` account to the `to` account
172     //
173     // The calling account must already have sufficient tokens approve(...)-d
174     // for spending from the `from` account and
175     // - From account must have sufficient balance to transfer
176     // - Spender must have sufficient allowance to transfer
177     // - 0 value transfers are allowed
178     // ------------------------------------------------------------------------
179     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
180         balances[from] = safeSub(balances[from], tokens);
181         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
182         balances[to] = safeAdd(balances[to], tokens);
183         Transfer(from, to, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ------------------------------------------------------------------------
192     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Token owner can approve for `spender` to transferFrom(...) `tokens`
199     // from the token owner's account. The `spender` contract function
200     // `receiveApproval(...)` is then executed
201     // ------------------------------------------------------------------------
202     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
203         allowed[msg.sender][spender] = tokens;
204         Approval(msg.sender, spender, tokens);
205         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
206         return true;
207     }
208 
209     // ------------------------------------------------------------------------
210     // 5,100 CTLX Tokens per 1 ETH
211     // ------------------------------------------------------------------------
212     function () public payable {
213         require(now >= startDate && now <= endDate);
214         uint tokens;
215         if (now <= bonusEnds) {
216             tokens = msg.value * 11000;
217         } else {
218             tokens = msg.value * 5100;
219         }
220         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
221         _totalSupply = safeAdd(_totalSupply, tokens);
222         Transfer(address(0), msg.sender, tokens);
223         owner.transfer(msg.value);
224     }
225 
226 
227 
228     // ------------------------------------------------------------------------
229     // Owner can transfer out any accidentally sent ERC20 tokens
230     // ------------------------------------------------------------------------
231     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
232         return ERC20Interface(tokenAddress).transfer(owner, tokens);
233     }
234 }