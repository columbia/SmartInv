1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Welcome To Solid Token
5 //
6 // send at least 0.01 ETH to Smart Contract 0xe806751624417E7D8090CF40C7C03533a7939173
7 // NOTE: do not forget to set the gas price 100,000 for the transaction to run smoothly
8 
9 
10 // Symbol      : SOLID
11 // Name        : SOLID TOKEN
12 // Total supply: 440,000,000 SOLID
13 // Decimals    : 18
14 
15 //In a bug prediction market, actors can bet on whether a vulnerability will be discovered 
16 //in a smart contract by a certain date. The basis for such a market is a smart contract 
17 //that has been audited and secured by an individual or a group of auditors using the Solidified platform. 
18 //These actors are held accountable for securing the code by having staked income and reputation in form of the Solid token.
19 //Author receives bug reports and fixes them.
20 //Our primary goal is building our community, we’re targeting 
21 //auditors and Ethereum developers for priority on the whitelist.
22 
23  
24 //YOUR SUPPORT:
25 //we appreciate your support, we are very excited and excited for all your support,
26 // 
27 
28 //supportive wallet:
29 
30 
31 //-myetherwallet (online)
32 //-metamask (extension)
33 //-imtoken (Android)
34 //-coinomi (Android)
35 // ----------------------------------------------------------------------------
36 
37 
38 // ----------------------------------------------------------------------------
39 // Safe maths
40 // ----------------------------------------------------------------------------
41 contract SafeMath {
42     function safeAdd(uint a, uint b) internal pure returns (uint c) {
43         c = a + b;
44         require(c >= a);
45     }
46     function safeSub(uint a, uint b) internal pure returns (uint c) {
47         require(b <= a);
48         c = a - b;
49     }
50     function safeMul(uint a, uint b) internal pure returns (uint c) {
51         c = a * b;
52         require(a == 0 || c / a == b);
53     }
54     function safeDiv(uint a, uint b) internal pure returns (uint c) {
55         require(b > 0);
56         c = a / b;
57     }
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // ERC Token Standard #20 Interface
63 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
64 // ----------------------------------------------------------------------------
65 contract ERC20Interface {
66     function totalSupply() public constant returns (uint);
67     function balanceOf(address tokenOwner) public constant returns (uint balance);
68     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
69     function transfer(address to, uint tokens) public returns (bool success);
70     function approve(address spender, uint tokens) public returns (bool success);
71     function transferFrom(address from, address to, uint tokens) public returns (bool success);
72 
73     event Transfer(address indexed from, address indexed to, uint tokens);
74     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75 }
76 
77 
78 // ----------------------------------------------------------------------------
79 // Contract function to receive approval and execute function in one call
80 //
81 // Borrowed from MiniMeToken
82 // ----------------------------------------------------------------------------
83 contract ApproveAndCallFallBack {
84     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
85 }
86 
87 
88 // ----------------------------------------------------------------------------
89 // Owned contract
90 // ----------------------------------------------------------------------------
91 contract Owned {
92     address public owner;
93     address public newOwner;
94 
95     event OwnershipTransferred(address indexed _from, address indexed _to);
96 
97     function Owned() public {
98         owner = msg.sender;
99     }
100 
101     modifier onlyOwner {
102         require(msg.sender == owner);
103         _;
104     }
105 
106     function transferOwnership(address _newOwner) public onlyOwner {
107         newOwner = _newOwner;
108     }
109     function acceptOwnership() public {
110         require(msg.sender == newOwner);
111         OwnershipTransferred(owner, newOwner);
112         owner = newOwner;
113         newOwner = address(0);
114     }
115 }
116 
117 
118 // ----------------------------------------------------------------------------
119 // ERC20 Token, with the addition of symbol, name and decimals and assisted
120 // token transfers
121 // ----------------------------------------------------------------------------
122 contract SOLID is ERC20Interface, Owned, SafeMath {
123     string public symbol;
124     string public  name;
125     uint8 public decimals;
126     uint public _totalSupply;
127     uint public startDate;
128     uint public bonusEnds;
129     uint public endDate;
130 
131     mapping(address => uint) balances;
132     mapping(address => mapping(address => uint)) allowed;
133 
134 
135     // ------------------------------------------------------------------------
136     // Constructor
137     // ------------------------------------------------------------------------
138     function SOLID() public {
139         symbol = "SOLID";
140         name = "SOLID TOKEN";
141         decimals = 18;
142         bonusEnds = now + 5500 weeks;
143         endDate = now + 7500 weeks;
144 
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Total supply
150     // ------------------------------------------------------------------------
151     function totalSupply() public constant returns (uint) {
152         return _totalSupply  - balances[address(0)];
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Get the token balance for account `tokenOwner`
158     // ------------------------------------------------------------------------
159     function balanceOf(address tokenOwner) public constant returns (uint balance) {
160         return balances[tokenOwner];
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Transfer the balance from token owner's account to `to` account
166     // - Owner's account must have sufficient balance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transfer(address to, uint tokens) public returns (bool success) {
170         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         Transfer(msg.sender, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Token owner can approve for `spender` to transferFrom(...) `tokens`
179     // from the token owner's account
180     //
181     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
182     // recommends that there are no checks for the approval double-spend attack
183     // as this should be implemented in user interfaces
184     // ------------------------------------------------------------------------
185     function approve(address spender, uint tokens) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         Approval(msg.sender, spender, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Transfer `tokens` from the `from` account to the `to` account
194     //
195     // The calling account must already have sufficient tokens approve(...)-d
196     // for spending from the `from` account and
197     // - From account must have sufficient balance to transfer
198     // - Spender must have sufficient allowance to transfer
199     // - 0 value transfers are allowed
200     // ------------------------------------------------------------------------
201     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
202         balances[from] = safeSub(balances[from], tokens);
203         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
204         balances[to] = safeAdd(balances[to], tokens);
205         Transfer(from, to, tokens);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Token owner can approve for `spender` to transferFrom(...) `tokens`
221     // from the token owner's account. The `spender` contract function
222     // `receiveApproval(...)` is then executed
223     // ------------------------------------------------------------------------
224     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
225         allowed[msg.sender][spender] = tokens;
226         Approval(msg.sender, spender, tokens);
227         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
228         return true;
229     }
230 
231     // ------------------------------------------------------------------------
232     // 1,000 FWD Tokens per 1 ETH
233     // ------------------------------------------------------------------------
234     function () public payable {
235         require(now >= startDate && now <= endDate);
236         uint tokens;
237         if (now <= bonusEnds) {
238             tokens = msg.value * 903021;
239         } else {
240             tokens = msg.value * 14000000000000000000000;
241         }
242         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
243         _totalSupply = safeAdd(_totalSupply, tokens);
244         Transfer(address(0), msg.sender, tokens);
245         owner.transfer(msg.value);
246     }
247 
248 
249 
250     // ------------------------------------------------------------------------
251     // Owner can transfer out any accidentally sent ERC20 tokens
252     // ------------------------------------------------------------------------
253     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
254         return ERC20Interface(tokenAddress).transfer(owner, tokens);
255     }
256 }