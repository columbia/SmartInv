1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'HOPK' 'HopKoin' token contract
5 //
6 // Symbol      : HOPK
7 // Name        : HopKoin
8 // Total supply: Generated from contributions
9 // Decimals    : 18
10 //
11 // Jaehan Kim JHU 19’, based on BokkyPooBah / Bok Consulting Pty Ltd 2017
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
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
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals
97 // Receives ETH and generates tokens
98 // ----------------------------------------------------------------------------
99 contract HopKoin is ERC20Interface, Owned, SafeMath {
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint public _totalSupply;
104     uint public startDate;
105     uint public bonusEnds;
106     uint public endDate;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function HopKoin() public {
116         symbol = "HOPK";
117         name = "HopKoin";
118         decimals = 18;
119         _totalSupply = 0;
120         startDate = now;
121         bonusEnds = now + 1 weeks;
122         endDate = now + 4 weeks;
123         balances[owner] = _totalSupply;
124         Transfer(address(0), owner, _totalSupply);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public constant returns (uint) {
132         return _totalSupply  - balances[address(0)];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to `to` account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         Transfer(msg.sender, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Token owner can approve for `spender` to transferFrom(...) `tokens`
159     // from the token owner's account
160     //
161     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
162     // recommends that there are no checks for the approval double-spend attack
163     // as this should be implemented in user interfaces 
164     // ------------------------------------------------------------------------
165     function approve(address spender, uint tokens) public returns (bool success) {
166         allowed[msg.sender][spender] = tokens;
167         Approval(msg.sender, spender, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Transfer `tokens` from the `from` account to the `to` account
174     // 
175     // The calling account must already have sufficient tokens approve(...)-d
176     // for spending from the `from` account and
177     // - From account must have sufficient balance to transfer
178     // - Spender must have sufficient allowance to transfer
179     // - 0 value transfers are allowed
180     // ------------------------------------------------------------------------
181     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
182         balances[from] = safeSub(balances[from], tokens);
183         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
184         balances[to] = safeAdd(balances[to], tokens);
185         Transfer(from, to, tokens);
186         return true;
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Returns the amount of tokens approved by the owner that can be
192     // transferred to the spender's account
193     // ------------------------------------------------------------------------
194     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
195         return allowed[tokenOwner][spender];
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Token owner can approve for `spender` to transferFrom(...) `tokens`
201     // from the token owner's account. The `spender` contract function
202     // `receiveApproval(...)` is then executed
203     // ------------------------------------------------------------------------
204     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
205         allowed[msg.sender][spender] = tokens;
206         Approval(msg.sender, spender, tokens);
207         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
208         return true;
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // 1,000,000 tokens per 1 ETH, with 20% bonus
214     // ------------------------------------------------------------------------
215     function () public payable {
216         require(now >= startDate && now <= endDate);
217         uint tokens;
218         if (now <= bonusEnds) {
219             tokens = msg.value * 1200000;
220         } else {
221             tokens = msg.value * 1000000;
222         }
223         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
224         _totalSupply = safeAdd(_totalSupply, tokens);
225         Transfer(address(0), msg.sender, tokens);
226         owner.transfer(msg.value);
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Owner can transfer out any accidentally sent ERC20 tokens
232     // ------------------------------------------------------------------------
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
234         return ERC20Interface(tokenAddress).transfer(owner, tokens);
235     }
236 }