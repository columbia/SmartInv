1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CryptoSports' CROWDSALE token contract
5 //
6 // Deployed to : 0x5a3f767f1e3c6855c746f1563a17aafc8a361189
7 // Symbol      : SPORTS
8 // Name        : CryptoSports
9 // Total supply: 1000000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // Forked by JorgeArturo.
16 // ----------------------------------------------------------------------------
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 contract SafeMath {
23     function safeAdd(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function safeSub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function safeMul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function safeDiv(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // ERC Token Standard #20 Interface
44 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45 // ----------------------------------------------------------------------------
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Contract function to receive approval and execute function in one call
61 //
62 // Borrowed from MiniMeToken
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and assisted
101 // token transfers
102 // ----------------------------------------------------------------------------
103 contract CryptoSportsToken is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint public _totalSupply;
108     uint public startDate;
109     uint public bonusEnds;
110     uint public endDate;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     constructor() public {
120         symbol = "SPORTS";
121         name = "CryptoSports";
122         decimals = 18;
123         bonusEnds = now + 1 weeks;
124         endDate = now + 7 weeks;
125 
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return _totalSupply  - balances[address(0)];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account `tokenOwner`
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public constant returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to `to` account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
152         balances[to] = safeAdd(balances[to], tokens);
153         emit Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer `tokens` from the `from` account to the `to` account
175     //
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the `from` account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = safeSub(balances[from], tokens);
184         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
185         balances[to] = safeAdd(balances[to], tokens);
186         emit Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Returns the amount of tokens approved by the owner that can be
193     // transferred to the spender's account
194     // ------------------------------------------------------------------------
195     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
196         return allowed[tokenOwner][spender];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Token owner can approve for `spender` to transferFrom(...) `tokens`
202     // from the token owner's account. The `spender` contract function
203     // `receiveApproval(...)` is then executed
204     // ------------------------------------------------------------------------
205     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         emit Approval(msg.sender, spender, tokens);
208         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
209         return true;
210     }
211 
212     // ------------------------------------------------------------------------
213     // 5,000 SPORTS Tokens per 1 ETH
214     // ------------------------------------------------------------------------
215     function () public payable {
216         require(now >= startDate && now <= endDate);
217         uint tokens;
218         if (now <= bonusEnds) {
219             tokens = msg.value * 5200;
220         } else {
221             tokens = msg.value * 5000;
222         }
223         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
224         _totalSupply = safeAdd(_totalSupply, tokens);
225         emit Transfer(address(0), msg.sender, tokens);
226         owner.transfer(msg.value);
227     }
228 
229 
230 
231     // ------------------------------------------------------------------------
232     // Owner can transfer out any accidentally sent ERC20 tokens
233     // ------------------------------------------------------------------------
234     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
235         return ERC20Interface(tokenAddress).transfer(owner, tokens);
236     }
237 }