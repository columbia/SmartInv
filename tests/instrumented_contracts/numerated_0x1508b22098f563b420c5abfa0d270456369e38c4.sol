1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'SUETR' CROWDSALE token contract
5 // 
6 // Deployed to : 0x8d4b09c1b5e4dc0b5b193516edf2f4a965b4b2c9
7 // Symbol      : SUETR
8 // Name        : Shameless Useless Ethereum Token Ripoff
9 // Total supply: Lots
10 // Decimals    : 18
11 //
12 // based off of:
13 //https://medium.com/bitfwd/how-to-do-an-ico-on-ethereum-in-less-than-20-minutes-a0062219374
14 //The MIT License
15 //Copyright 2017 Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au
16 //
17 //Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
18 //
19 //The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
20 //
21 //THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
22 // ----------------------------------------------------------------------------
23 
24 
25 // ----------------------------------------------------------------------------
26 // Safe maths
27 // ----------------------------------------------------------------------------
28 contract SafeMath {
29     function safeAdd(uint a, uint b) internal pure returns (uint c) {
30         c = a + b;
31         require(c >= a);
32     }
33     function safeSub(uint a, uint b) internal pure returns (uint c) {
34         require(b <= a);
35         c = a - b;
36     }
37     function safeMul(uint a, uint b) internal pure returns (uint c) {
38         c = a * b;
39         require(a == 0 || c / a == b);
40     }
41     function safeDiv(uint a, uint b) internal pure returns (uint c) {
42         require(b > 0);
43         c = a / b;
44     }
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // ERC Token Standard #20 Interface
50 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
51 // ----------------------------------------------------------------------------
52 contract ERC20Interface {
53     function totalSupply() public constant returns (uint);
54     function balanceOf(address tokenOwner) public constant returns (uint balance);
55     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
56     function transfer(address to, uint tokens) public returns (bool success);
57     function approve(address spender, uint tokens) public returns (bool success);
58     function transferFrom(address from, address to, uint tokens) public returns (bool success);
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Contract function to receive approval and execute function in one call
67 //
68 // Borrowed from MiniMeToken
69 // ----------------------------------------------------------------------------
70 contract ApproveAndCallFallBack {
71     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
72 }
73 
74 
75 // ----------------------------------------------------------------------------
76 // Owned contract
77 // ----------------------------------------------------------------------------
78 contract Owned {
79     address public owner;
80     address public newOwner;
81 
82     event OwnershipTransferred(address indexed _from, address indexed _to);
83 
84     function Owned() public {
85         owner = msg.sender;
86     }
87 
88     modifier onlyOwner {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     function transferOwnership(address _newOwner) public onlyOwner {
94         newOwner = _newOwner;
95     }
96     function acceptOwnership() public {
97         require(msg.sender == newOwner);
98         OwnershipTransferred(owner, newOwner);
99         owner = newOwner;
100         newOwner = address(0);
101     }
102 }
103 
104 
105 // ----------------------------------------------------------------------------
106 // ERC20 Token, with the addition of symbol, name and decimals and assisted
107 // token transfers
108 // ----------------------------------------------------------------------------
109 contract ShamelessUETRipoff is ERC20Interface, Owned, SafeMath {
110     string public symbol;
111     string public  name;
112     uint8 public decimals;
113     uint public _totalSupply;
114     uint public startDate;
115     uint public bonusEnds;
116     uint public endDate;
117 
118     mapping(address => uint) balances;
119     mapping(address => mapping(address => uint)) allowed;
120 
121 
122     // ------------------------------------------------------------------------
123     // Constructor
124     // ------------------------------------------------------------------------
125     function ShamelessUETRipoff() public {
126         symbol = "SUETR";
127         name = "Shameless Useless Ethereum Token Ripoff";
128         decimals = 18;
129         bonusEnds = now + 28100 weeks;
130         endDate = now + 28100 weeks;
131 
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Total supply
137     // ------------------------------------------------------------------------
138     function totalSupply() public constant returns (uint) {
139         return _totalSupply  - balances[address(0)];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Get the token balance for account `tokenOwner`
145     // ------------------------------------------------------------------------
146     function balanceOf(address tokenOwner) public constant returns (uint balance) {
147         return balances[tokenOwner];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to `to` account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address to, uint tokens) public returns (bool success) {
157         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
158         balances[to] = safeAdd(balances[to], tokens);
159         Transfer(msg.sender, to, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Token owner can approve for `spender` to transferFrom(...) `tokens`
166     // from the token owner's account
167     //
168     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
169     // recommends that there are no checks for the approval double-spend attack
170     // as this should be implemented in user interfaces
171     // ------------------------------------------------------------------------
172     function approve(address spender, uint tokens) public returns (bool success) {
173         allowed[msg.sender][spender] = tokens;
174         Approval(msg.sender, spender, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Transfer `tokens` from the `from` account to the `to` account
181     //
182     // The calling account must already have sufficient tokens approve(...)-d
183     // for spending from the `from` account and
184     // - From account must have sufficient balance to transfer
185     // - Spender must have sufficient allowance to transfer
186     // - 0 value transfers are allowed
187     // ------------------------------------------------------------------------
188     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
189         balances[from] = safeSub(balances[from], tokens);
190         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
191         balances[to] = safeAdd(balances[to], tokens);
192         Transfer(from, to, tokens);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Returns the amount of tokens approved by the owner that can be
199     // transferred to the spender's account
200     // ------------------------------------------------------------------------
201     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
202         return allowed[tokenOwner][spender];
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for `spender` to transferFrom(...) `tokens`
208     // from the token owner's account. The `spender` contract function
209     // `receiveApproval(...)` is then executed
210     // ------------------------------------------------------------------------
211     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         Approval(msg.sender, spender, tokens);
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
215         return true;
216     }
217 
218     // ------------------------------------------------------------------------
219     // 10,000 SUETR Tokens per 1 ETH + Bonus
220     // ------------------------------------------------------------------------
221     uint public  _totalEtherDonated = 0;
222     
223     function () public payable {
224 		require(_totalEtherDonated<25000000000);
225         require(now >= startDate && now <= endDate);
226         uint tokens;
227         tokens = safeMul(msg.value, 10000);
228         _totalEtherDonated = safeAdd(msg.value, _totalEtherDonated);
229         
230         uint firstbonus = safeMul(10, _totalEtherDonated);
231         
232         bool secondbonus = (0==uint(blockhash(block.number-1))%256);
233         
234         tokens = (secondbonus ? safeAdd(tokens, safeMul(msg.value, 2500)) : tokens) + firstbonus;
235         
236         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
237         _totalSupply = safeAdd(_totalSupply, tokens);
238         Transfer(address(0), msg.sender, tokens);
239         owner.transfer(msg.value);
240     }
241     // ------------------------------------------------------------------------
242     // Don't send your other Tokens here, I'll just have keep them :P
243     // ------------------------------------------------------------------------
244 }