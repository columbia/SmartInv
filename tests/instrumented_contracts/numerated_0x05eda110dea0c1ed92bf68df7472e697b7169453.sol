1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'MNLTToken' CROWDSALE token contract
5 //
6 // Deployed to : 0x158A4507A22a0b98EeAf9694b91a8Ddf1f49Dd7d
7 // Symbol      : MNLT
8 // Name        : MNLT Token
9 // Total supply: 100000000*10**18
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
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
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
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
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     function Owned() public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and assisted
99 // token transfers
100 // ----------------------------------------------------------------------------
101 contract MNLTToken is ERC20Interface, Owned, SafeMath {
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint public startDate;
106     uint public bonusEnds;
107     uint public endDate;
108     uint256 public constant initialSupply = 100000000000000000000000000;
109     uint256 totalSupply_;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     function MNLTToken() public {
119         symbol = "MNLT";
120         name = "MNLTToken";
121         decimals = 18;
122         bonusEnds = now + 1 days;
123         endDate = now + 1 days;
124         totalSupply_ = initialSupply;
125         balances[msg.sender] = 20000000000000000000000000;
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return totalSupply_;
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
153         Transfer(msg.sender, to, tokens);
154         totalSupply_ = initialSupply;
155         balances[msg.sender] = 20000000000000000000000000;
156         Transfer(0x0, msg.sender, 20000000000000000000000000);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for `spender` to transferFrom(...) `tokens`
163     // from the token owner's account
164     //
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         Approval(msg.sender, spender, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Transfer `tokens` from the `from` account to the `to` account
178     //
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the `from` account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186         balances[from] = safeSub(balances[from], tokens);
187         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
188         balances[to] = safeAdd(balances[to], tokens);
189         Transfer(from, to, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Returns the amount of tokens approved by the owner that can be
196     // transferred to the spender's account
197     // ------------------------------------------------------------------------
198     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
199         return allowed[tokenOwner][spender];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Token owner can approve for `spender` to transferFrom(...) `tokens`
205     // from the token owner's account. The `spender` contract function
206     // `receiveApproval(...)` is then executed
207     // ------------------------------------------------------------------------
208     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
209         allowed[msg.sender][spender] = tokens;
210         Approval(msg.sender, spender, tokens);
211         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
212         return true;
213     }
214 
215     // ------------------------------------------------------------------------
216     // 6820 Tokens per 1 ETH 
217     // ------------------------------------------------------------------------
218     function () public payable {
219         require(now >= startDate && now <= endDate);
220         uint tokens;
221         if (now <= bonusEnds) {
222             tokens = msg.value *7000;
223         } else {
224             tokens = msg.value *6820;
225         }
226         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
227         totalSupply_ = safeAdd(totalSupply_, tokens);
228         Transfer(address(0), msg.sender, tokens);
229         owner.transfer(msg.value);
230     }
231 
232 
233 
234     // ------------------------------------------------------------------------
235     // Owner can transfer out any accidentally sent ERC20 tokens
236     // ------------------------------------------------------------------------
237     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
238         return ERC20Interface(tokenAddress).transfer(owner, tokens);
239     }
240 }