1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and assisted
86 // token transfers
87 // ----------------------------------------------------------------------------
88 contract GitBitToken is ERC20Interface, Owned, SafeMath {
89     string public symbol;
90     string public name;
91     uint8 public decimals;
92     
93     uint public stage1Ends;
94     uint public stage2Ends;
95 	uint public amountRaised;
96 	
97 	uint private _totalSupply;
98 	uint private _minPaymentAmount;
99 	
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     constructor() public {
105         symbol = "GBT";
106         name = "GitBit Token";
107         decimals = 18;
108         
109         _minPaymentAmount = 13000000000000000;
110 
111         stage1Ends = now + 4 weeks;
112         stage2Ends = now + 12 weeks;
113 
114         _totalSupply = 100000000000000000000000000;
115         
116         balances[owner] = _totalSupply;
117         emit Transfer(address(0), owner, _totalSupply);
118     }
119 	
120 	function minPaymentAmount() public returns (uint) {
121 		return _minPaymentAmount;
122 	}
123 
124     // ------------------------------------------------------------------------
125     // Total supply
126     // ------------------------------------------------------------------------
127     function totalSupply() public constant returns (uint) {
128         return _totalSupply;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account tokenOwner
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to to account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         emit Transfer(msg.sender, to, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for spender to transferFrom(...) tokens
155     // from the token owner's account
156     //
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces 
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer tokens from the from account to the to account
170     // 
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the from account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178         balances[from] = safeSub(balances[from], tokens);
179         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180         balances[to] = safeAdd(balances[to], tokens);
181         emit Transfer(from, to, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Returns the amount of tokens approved by the owner that can be
188     // transferred to the spender's account
189     // ------------------------------------------------------------------------
190     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
191         return allowed[tokenOwner][spender];
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Token owner can approve for spender to transferFrom(...) tokens
197     // from the token owner's account. The spender contract function
198     // receiveApproval(...) is then executed
199     // ------------------------------------------------------------------------
200     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
201         allowed[msg.sender][spender] = tokens;
202         emit Approval(msg.sender, spender, tokens);
203         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // 1,000 GBT Tokens per 1 ETH
210     // ------------------------------------------------------------------------
211     function () public payable {
212         require(msg.value >= _minPaymentAmount);
213         
214         uint tokens;
215         if (now <= stage1Ends) {
216             tokens = msg.value * 1400;
217         } else if (now <= stage2Ends) {        
218             tokens = msg.value * 1200;        
219         } else {
220             tokens = msg.value * 1000;
221         }
222         
223         require(balances[owner] >= tokens);
224 		
225 		amountRaised = safeAdd(amountRaised, msg.value);
226 		
227 		balances[owner] = safeSub(balances[owner], tokens);
228         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
229         
230         emit Transfer(owner, msg.sender, tokens);
231         owner.transfer(msg.value);
232     }
233 
234 
235 
236     // ------------------------------------------------------------------------
237     // Owner can transfer out any accidentally sent ERC20 tokens
238     // ------------------------------------------------------------------------
239     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
240         return ERC20Interface(tokenAddress).transfer(owner, tokens);
241     }
242     
243     function setStage1Ends(uint newDate) public onlyOwner returns (bool success) {
244         stage1Ends = newDate;
245         return true;
246     }
247     
248     function setStage2Ends(uint newDate) public onlyOwner returns (bool success) {
249         stage2Ends = newDate;
250         return true;
251     }
252     
253     function setMinPaymentAmount(uint newAmountWei) public onlyOwner returns (bool success) {
254         _minPaymentAmount = newAmountWei;
255         return true;
256     }
257     
258 }