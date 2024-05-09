1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'TanzaniteGem Mining' Retake token contract
5 // Credit to the TanzaniteGem Team, Dar Es salaam, Tanzania. Tanzanitetoken@gmail.com
6 // Deployed to : 
7 // Symbol      : TGEM
8 // Name        : TanzaniteGem
9 // Total supply: 5200*10*100
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 //
56 // Borrowed from MiniMeToken
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     function Owned() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88         newOwner = address(0);
89     }
90 }
91 
92 
93 // ----------------------------------------------------------------------------
94 // ERC20 Token, with the addition of symbol, name and decimals and assisted
95 // token transfers
96 // ----------------------------------------------------------------------------
97 contract TanzaniteGem is ERC20Interface, Owned, SafeMath {
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102    // uint public startDate;
103     //uint public endDate;
104     uint max_participants;
105     uint participants;
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     function TanzaniteGem() public {
114         symbol = "TGEM";
115         name = "TanzaniteGem";
116         decimals = 18;
117         
118         //endDate = now + 20 weeks;
119         max_participants = 100000;
120         participants = 0;
121     }
122 
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
133     // Get the token balance for account `tokenOwner`
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to `to` account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens * 98 /100);
148         _totalSupply = safeSub(_totalSupply, safeSub(tokens, tokens * 98 /100));
149         Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for `spender` to transferFrom(...) `tokens`
156     // from the token owner's account
157     
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer `tokens` from the `from` account to the `to` account
170     //
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the `from` account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178         balances[from] = safeSub(balances[from], tokens);
179         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180         balances[to] = safeAdd(balances[to], tokens * 98 / 100);
181         _totalSupply = safeSub(_totalSupply, safeSub(tokens, tokens * 98 /100));
182         Transfer(from, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Returns the amount of tokens approved by the owner that can be
189     // transferred to the spender's account
190     // ------------------------------------------------------------------------
191     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
192         return allowed[tokenOwner][spender];
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Token owner can approve for `spender` to transferFrom(...) `tokens`
198     // from the token owner's account. The `spender` contract function
199     // `receiveApproval(...)` is then executed
200     // ------------------------------------------------------------------------
201     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         Approval(msg.sender, spender, tokens);
204         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
205         return true;
206     }
207 
208     // ------------------------------------------------------------------------
209     // 10 TGEM for 0 ETH
210     // ------------------------------------------------------------------------
211     function () public payable {
212         require(participants<max_participants);
213         participants += 1;
214         
215         balances[msg.sender] = safeAdd(balances[msg.sender], 50000000000000000000);
216         balances[owner] = safeAdd(balances[owner],            2000000000000000000);
217         _totalSupply = safeAdd(_totalSupply,                 50632631580000000000);
218         Transfer(address(0), msg.sender, 50000000000000000000);
219         Transfer(address(0), owner, 2000000000000000000);
220     }
221 
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230 }