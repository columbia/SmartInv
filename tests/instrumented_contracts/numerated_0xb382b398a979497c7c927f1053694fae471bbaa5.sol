1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'IP' CROWDSALE token contract
5 //
6 // Deployed to : 0x7cf186Cad802cB992c4F14a634C7E81c9e8957b8
7 // Symbol      : IP
8 // Name        : IOTPOWER
9 // Total supply: 900000000
10 // Decimals    : 0
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
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68     address public owner;
69     address public newOwner;
70 
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72 
73     function Owned() public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public onlyOwner {
83         newOwner = _newOwner;
84     }
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and assisted
96 // token transfers
97 // ----------------------------------------------------------------------------
98 contract iotpowerToken is ERC20Interface, Owned, SafeMath {
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint public remaining;
103     uint public _totalSupply;
104     uint public startDate;
105     uint public stageOneBegin;
106     uint public stageOneEnd;
107     uint public stageTwoBegin;
108     uint public stageTwoEnd;
109     uint public stageThreeBegin;
110     uint public stageThreeEnd;
111     uint public stageFourBegin;
112     uint public stageFourEnd;
113     uint public stageFiveBegin;
114     uint public stageFiveEnd;
115     uint public endDate;
116 
117     mapping(address => uint) balances;
118     mapping(address => mapping(address => uint)) allowed;
119 
120 
121     // ------------------------------------------------------------------------
122     // Constructor
123     // ------------------------------------------------------------------------
124     function iotpowerToken() public {
125         symbol = "IP";
126         name = "IOTPOWER Token";
127         decimals = 0;
128         _totalSupply = 900000000;
129         stageOneBegin = 1537747200; 
130         stageOneEnd = 1539561599;
131         stageTwoBegin = 1539561600;
132         stageTwoEnd = 1541375999;
133         stageThreeBegin = 1541376000;
134         stageThreeEnd = 1543190399;
135         stageFourBegin = 1543190400;
136         stageFourEnd = 1545004799;
137         stageFiveBegin = 1545004800;
138         stageFiveEnd = 1546819199;
139         endDate = 1548633599;
140         balances[0x7cf186Cad802cB992c4F14a634C7E81c9e8957b8] = _totalSupply;
141         Transfer(address(0), 0x7cf186Cad802cB992c4F14a634C7E81c9e8957b8, _totalSupply);
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Total supply
147     // ------------------------------------------------------------------------
148     function totalSupply() public constant returns (uint) {
149         return _totalSupply  - balances[address(0)];
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Get the token balance for account `tokenOwner`
155     // ------------------------------------------------------------------------
156     function balanceOf(address tokenOwner) public constant returns (uint balance) {
157         return balances[tokenOwner];
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer the balance from token owner's account to `to` account
163     // - Owner's account must have sufficient balance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transfer(address to, uint tokens) public returns (bool success) {
167         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
168         balances[to] = safeAdd(balances[to], tokens);
169         Transfer(msg.sender, to, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account
177     //
178     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
179     // recommends that there are no checks for the approval double-spend attack
180     // as this should be implemented in user interfaces
181     // ------------------------------------------------------------------------
182     function approve(address spender, uint tokens) public returns (bool success) {
183         allowed[msg.sender][spender] = tokens;
184         Approval(msg.sender, spender, tokens);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Transfer `tokens` from the `from` account to the `to` account
191     //
192     // The calling account must already have sufficient tokens approve(...)-d
193     // for spending from the `from` account and
194     // - From account must have sufficient balance to transfer
195     // - Spender must have sufficient allowance to transfer
196     // - 0 value transfers are allowed
197     // ------------------------------------------------------------------------
198     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
199         balances[from] = safeSub(balances[from], tokens);
200         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
201         balances[to] = safeAdd(balances[to], tokens);
202         Transfer(from, to, tokens);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Returns the amount of tokens approved by the owner that can be
209     // transferred to the spender's account
210     // ------------------------------------------------------------------------
211     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
212         return allowed[tokenOwner][spender];
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Token owner can approve for `spender` to transferFrom(...) `tokens`
218     // from the token owner's account. The `spender` contract function
219     // `receiveApproval(...)` is then executed
220     // ------------------------------------------------------------------------
221     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
222         allowed[msg.sender][spender] = tokens;
223         Approval(msg.sender, spender, tokens);
224         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
225         return true;
226     }
227 
228     // ------------------------------------------------------------------------
229     // 4,955 IP Tokens per 1 ETH
230     // ------------------------------------------------------------------------
231     function () public payable {
232         
233         require(now >= startDate && now <= endDate);
234         require(msg.value > 0);                     // Require the sender to send an ETH tx higher than 0
235         require(msg.value <= msg.sender.balance);   // Require the sender to have sufficient ETH balance for the tx
236 
237         uint tokens;
238         uint weiAmount = msg.value;
239 
240         assert(remaining <= _totalSupply);
241 
242         if (now >= stageOneBegin && now <= stageOneEnd) {
243             tokens = 7185 * weiAmount / 1 ether;
244         } else if (now >= stageTwoBegin && now <= stageTwoEnd) {
245             tokens = 6789 * weiAmount / 1 ether;
246         } else if (now >= stageThreeBegin && now <= stageThreeEnd) {
247             tokens = 6392 * weiAmount / 1 ether;
248         } else if (now >= stageFourBegin && now <= stageFourEnd) {
249             tokens = 5996 * weiAmount / 1 ether;
250         }  else if (now >= stageFiveBegin && now <= stageFiveEnd) {
251             tokens = 5600 * weiAmount / 1 ether;
252         } else {
253             tokens = 4955 * weiAmount / 1 ether;
254         }
255 
256         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
257         Transfer(address(0), msg.sender, tokens);
258         owner.transfer(weiAmount);
259         remaining = safeAdd(remaining,tokens);
260   
261     }
262 
263 
264 
265     // ------------------------------------------------------------------------
266     // Owner can transfer out any accidentally sent ERC20 tokens
267     // ------------------------------------------------------------------------
268     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
269         return ERC20Interface(tokenAddress).transfer(owner, tokens);
270     }
271 }