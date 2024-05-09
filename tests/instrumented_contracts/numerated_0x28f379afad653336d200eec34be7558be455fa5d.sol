1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'AIWEB' CROWDSALE token contract
5 //
6 // Deployed to : 0x67f68684b67f80d53315307c7d4910016911a94c
7 // Symbol      : AIWEB
8 // Name        : AIWEB Token
9 // Total supply: 100,000,000,000.000000000000000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by AIWEB. The MIT Licence.
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
98 
99 
100 // ----------------------------------------------------------------------------
101 // ERC20 Token, with the addition of symbol, name and decimals and assisted
102 // token transfers
103 // ----------------------------------------------------------------------------
104 contract AIWEBToken is ERC20Interface, Owned, SafeMath {
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint public _totalSupply;
109     uint public startDate;
110     uint public bonusEnds;
111     uint public endDate;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     function AIWEBToken() public {
121         symbol = "AIWEB";
122         name = "AIWEB Token";
123         decimals = 18;
124         bonusEnds = now + 1 weeks;
125         endDate = now + 1 weeks;
126         _totalSupply = 100000000000 * 10**uint(decimals);
127         balances[0x669fcb22f157dba043118e3a452b860d74208562] = _totalSupply;
128         Transfer(address(0), 0x669fcb22f157dba043118e3a452b860d74208562, _totalSupply);
129 
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136     function totalSupply() public constant returns (uint) {
137         return _totalSupply  - balances[address(0)];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Get the token balance for account `tokenOwner`
143     // ------------------------------------------------------------------------
144     function balanceOf(address tokenOwner) public constant returns (uint balance) {
145         return balances[tokenOwner];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer the balance from token owner's account to `to` account
151     // - Owner's account must have sufficient balance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154     function transfer(address to, uint tokens) public returns (bool success) {
155         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
156         balances[to] = safeAdd(balances[to], tokens);
157         Transfer(msg.sender, to, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account
165     //
166     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
167     // recommends that there are no checks for the approval double-spend attack
168     // as this should be implemented in user interfaces
169     // ------------------------------------------------------------------------
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Transfer `tokens` from the `from` account to the `to` account
179     //
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the `from` account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
187         balances[from] = safeSub(balances[from], tokens);
188         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
189         balances[to] = safeAdd(balances[to], tokens);
190         Transfer(from, to, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
200         return allowed[tokenOwner][spender];
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Token owner can approve for `spender` to transferFrom(...) `tokens`
206     // from the token owner's account. The `spender` contract function
207     // `receiveApproval(...)` is then executed
208     // ------------------------------------------------------------------------
209     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
210         allowed[msg.sender][spender] = tokens;
211         Approval(msg.sender, spender, tokens);
212         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
213         return true;
214     }
215 
216     // ------------------------------------------------------------------------
217     // 1,000 AIWEB Tokens per 1 ETH
218     // ------------------------------------------------------------------------
219     function () public payable {
220         require(now >= startDate && now <= endDate);
221         uint tokens;
222         if (now <= bonusEnds) {
223             tokens = msg.value * 1200;
224         } else {
225             tokens = msg.value * 1000;
226         }
227         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
228         _totalSupply = safeAdd(_totalSupply, tokens);
229         Transfer(address(0), msg.sender, tokens);
230         owner.transfer(msg.value);
231     }
232 
233 
234 
235     // ------------------------------------------------------------------------
236     // Owner can transfer out any accidentally sent ERC20 tokens
237     // ------------------------------------------------------------------------
238     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
239         return ERC20Interface(tokenAddress).transfer(owner, tokens);
240     }
241 }