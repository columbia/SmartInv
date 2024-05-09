1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CurrenX' CROWDSALE token contract
5 //
6 // Deployed to : 0xbf510c045eeb72cfdefd985e351e32d38df87a6d
7 // Symbol      : CurX
8 // Name        : CurrenX
9 // Total supply: 121,000,000.000000000000000000
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
102 contract CurrenXToken is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107     uint public startDate;
108     uint public bonusEnds;
109     uint public endDate;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     function CurrenXToken() public {
119         symbol = "CurX";
120         name = "CurrenX";
121         decimals = 18;
122         _totalSupply = 121000000 * 10**uint(decimals);
123         balances[owner] = _totalSupply;
124         Transfer(address(0), owner, _totalSupply);
125         bonusEnds = now + 1 weeks;
126         endDate = now + 3 weeks;
127 
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Total supply
133     // ------------------------------------------------------------------------
134     function totalSupply() public constant returns (uint) {
135         return _totalSupply  - balances[address(0)];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Get the token balance for account `tokenOwner`
141     // ------------------------------------------------------------------------
142     function balanceOf(address tokenOwner) public constant returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to `to` account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transfer(address to, uint tokens) public returns (bool success) {
153         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
154         balances[to] = safeAdd(balances[to], tokens);
155         Transfer(msg.sender, to, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Token owner can approve for `spender` to transferFrom(...) `tokens`
162     // from the token owner's account
163     //
164     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
165     // recommends that there are no checks for the approval double-spend attack
166     // as this should be implemented in user interfaces
167     // ------------------------------------------------------------------------
168     function approve(address spender, uint tokens) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         Approval(msg.sender, spender, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Transfer `tokens` from the `from` account to the `to` account
177     //
178     // The calling account must already have sufficient tokens approve(...)-d
179     // for spending from the `from` account and
180     // - From account must have sufficient balance to transfer
181     // - Spender must have sufficient allowance to transfer
182     // - 0 value transfers are allowed
183     // ------------------------------------------------------------------------
184     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
185         balances[from] = safeSub(balances[from], tokens);
186         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
187         balances[to] = safeAdd(balances[to], tokens);
188         Transfer(from, to, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for `spender` to transferFrom(...) `tokens`
204     // from the token owner's account. The `spender` contract function
205     // `receiveApproval(...)` is then executed
206     // ------------------------------------------------------------------------
207     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         Approval(msg.sender, spender, tokens);
210         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
211         return true;
212     }
213 
214     // ------------------------------------------------------------------------
215     // 8,066 CurX Tokens per 1 ETH
216     // ------------------------------------------------------------------------
217     function () public payable {
218         require(now >= startDate && now <= endDate);
219         uint tokens;
220         if (now <= bonusEnds) {
221             tokens = msg.value * 8066;
222         } else {
223             tokens = msg.value * 8066;
224         }
225         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
226         _totalSupply = safeAdd(_totalSupply, tokens);
227         Transfer(address(0), msg.sender, tokens);
228         owner.transfer(msg.value);
229     }
230 
231 
232 
233     // ------------------------------------------------------------------------
234     // Owner can transfer out any accidentally sent ERC20 tokens
235     // ------------------------------------------------------------------------
236     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
237         return ERC20Interface(tokenAddress).transfer(owner, tokens);
238     }
239 }