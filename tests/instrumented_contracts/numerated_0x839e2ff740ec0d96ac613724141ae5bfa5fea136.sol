1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Digipay' CROWDSALE token contract
5 //
6 // Deployed to : 0x839e2ff740ec0d96ac613724141ae5bfa5fea136
7 // Symbol      : DIP
8 // Name        : Digipay Token
9 // Total supply: 180000000
10 // Decimals    : 18
11 //
12 // 2018 (c) by Digipay
13 // ----------------------------------------------------------------------------
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
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     function Owned() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract DIPToken is ERC20Interface, Owned, SafeMath {
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100     uint public startDate;
101     uint public bonusEnds50;
102     uint public bonusEnds20;
103     uint public bonusEnds15;
104     uint public bonusEnds10;
105     uint public bonusEnds5;
106     uint public endDate;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function DIPToken() public {
116         symbol = "DIP";
117         name = "DIP Token";
118         decimals = 18;
119         _totalSupply = 180000000000000000000000000;
120         balances[0xce8f00911386b2bE473012468e54dCaA82C09F7e] = _totalSupply;
121         Transfer(address(0), 0xce8f00911386b2bE473012468e54dCaA82C09F7e, _totalSupply);
122         bonusEnds50 = now + 6 weeks;
123         bonusEnds20 = now + 7 weeks;
124         bonusEnds15 = now + 8 weeks;
125         bonusEnds10 = now + 9 weeks;
126         bonusEnds5 = now + 10 weeks;
127         endDate = now + 11 weeks;
128 
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Total supply
134     // ------------------------------------------------------------------------
135     function totalSupply() public constant returns (uint) {
136         return _totalSupply  - balances[address(0)];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Get the token balance for account `tokenOwner`
142     // ------------------------------------------------------------------------
143     function balanceOf(address tokenOwner) public constant returns (uint balance) {
144         return balances[tokenOwner];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer the balance from token owner's account to `to` account
150     // - Owner's account must have sufficient balance to transfer
151     // - 0 value transfers are allowed
152     // ------------------------------------------------------------------------
153     function transfer(address to, uint tokens) public returns (bool success) {
154         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
155         balances[to] = safeAdd(balances[to], tokens);
156         Transfer(msg.sender, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for `spender` to transferFrom(...) `tokens`
163     // from the token owner's account
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
211     // ------------------------------------------------------------------------
212     // 11,000 DIP Tokens per 1 ETH (No bonus)
213     // ------------------------------------------------------------------------
214     function () public payable {
215         require(now >= startDate && now <= endDate);
216         uint tokens;
217         if (now <= bonusEnds50) {
218             if (msg.value < 10000000000000000000) {
219             tokens = msg.value * 16500;
220             } else {
221             tokens = msg.value * 17490;
222             }
223         }
224         if (now > bonusEnds50 && now <= bonusEnds20) {
225             if (msg.value < 10000000000000000000) {
226             tokens = msg.value * 13200;
227             } else {
228             tokens = msg.value * 13992;
229             }
230         }
231         if (now > bonusEnds20 && now <= bonusEnds15) {
232             if (msg.value < 10000000000000000000) {
233             tokens = msg.value * 12650;
234             } else {
235             tokens = msg.value * 13409;
236             }
237         }
238         if (now > bonusEnds15 && now <= bonusEnds10) {
239             if (msg.value < 10000000000000000000) {
240             tokens = msg.value * 12100;
241             } else {
242             tokens = msg.value * 12826;
243             }
244         }
245         if (now > bonusEnds10 && now <= bonusEnds5) {
246             if (msg.value < 10000000000000000000) {
247             tokens = msg.value * 11550;
248             } else {
249             tokens = msg.value * 12243;
250             }
251         }
252         if (bonusEnds5 < now) {
253             if (msg.value < 10000000000000000000) {
254             tokens = msg.value * 11000;
255             } else {
256             tokens = msg.value * 11660;
257             }
258         }
259         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
260         _totalSupply = safeAdd(_totalSupply, tokens);
261         Transfer(address(0), msg.sender, tokens);
262         owner.transfer(msg.value);
263     }
264 
265 
266 
267     // ------------------------------------------------------------------------
268     // Owner can transfer out any accidentally sent ERC20 tokens
269     // ------------------------------------------------------------------------
270     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
271         return ERC20Interface(tokenAddress).transfer(owner, tokens);
272     }
273 }