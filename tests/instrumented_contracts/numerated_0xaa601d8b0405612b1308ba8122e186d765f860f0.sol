1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Tegshee Bok Consulting Pty Ltd Au 2018. The MIT Licence.
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b; 
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38     function burnToken(address target, uint tokens) returns (bool result);    
39     function mintToken(address target, uint tokens) returns (bool result);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43     
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Contract function to receive approval and execute function in one call
49 //
50 // Borrowed from MiniMeToken
51 // ----------------------------------------------------------------------------
52 contract ApproveAndCallFallBack {
53     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65 
66     function Owned() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80         OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and assisted
89 // token transfers
90 // ----------------------------------------------------------------------------
91 contract MNLTGUNE is ERC20Interface, Owned, SafeMath {
92     string public symbol;
93     string public  name;
94     uint8 public decimals;
95     uint public startDate;
96     uint public bonusEnds;
97     uint public endDate;
98     uint public initialSupply = 20000000e18;
99     uint public totalSupply_;
100     uint public HARD_CAP_T = 100000000;
101     uint public SOFT_CAP_T = 30000000;
102     uint public startCrowdsale;
103     uint public endCrowdsalel;
104     address public tokenOwner;
105     
106   
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function MNLTGUNE() public {
116         symbol = "GUNE";
117         name = "MNLTGUN";
118         decimals = 18;
119         bonusEnds = now + 31 days;
120         endDate = now + 61 days;
121         endCrowdsalel = 100000000e18;
122         startCrowdsale = 0;
123         tokenOwner = address(0x158A4507A22a0b98EeAf9694b91a8Ddf1f49Dd7d);
124     
125     
126     }
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public constant returns (uint) {
131         return totalSupply_;
132     }
133     // ------------------------------------------------------------------------
134     // Get the token balance for account tokenOwner
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public constant returns (uint balance) {
137         return balances[tokenOwner];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to to account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public returns (bool success) {
147         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
148         balances[to] = safeAdd(balances[to], tokens);
149         Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for spender to transferFrom(...) tokens
156     // from the token owner's account
157     //
158     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
159     // recommends that there are no checks for the approval double-spend attack
160     // as this should be implemented in user interfaces
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer tokens from the from account to the to account
171     //
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the from account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
179         balances[from] = safeSub(balances[from], tokens);
180         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
181         balances[to] = safeAdd(balances[to], tokens);
182         Transfer(from, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Returns the amount of tokens approved by the owner that can be
189     // transferred to the spender's account
190     // ------------------------------------------------------------------------
191     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
192         return allowed[tokenOwner][spender];
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Token owner can approve for spender to transferFrom(...) tokens
198     // from the token owner's account. The spender contract function
199     // receiveApproval(...) is then executed
200     // ------------------------------------------------------------------------
201     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         Approval(msg.sender, spender, tokens);
204         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
205         return true;
206     }
207     
208 
209 
210     // ------------------------------------------------------------------------
211     // 7000 MNLT Tokens per 1 ETH 
212     // ------------------------------------------------------------------------
213     function () public payable {
214         require(now >= startDate && now <= endDate && totalSupply_ >= startCrowdsale && totalSupply_ < endCrowdsalel);
215         uint tokens;
216         if (now <= bonusEnds) {
217             tokens = msg.value *8400;
218         } else {
219             tokens = msg.value *7350;
220         }
221         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
222         totalSupply_ = safeAdd(totalSupply_, tokens);
223         Transfer(address(0), msg.sender, tokens);
224         owner.transfer(msg.value);
225     }
226 
227 function burnToken(address target,uint tokens) returns (bool result){ 
228         balances[target] -= tokens;
229 	totalSupply_ = safeSub(totalSupply_, tokens);
230         Transfer(owner, target, tokens);
231         require(msg.sender == tokenOwner);
232 }
233  
234 
235 function mintToken(address target, uint tokens) returns (bool result){ 
236         balances[target] += tokens;
237 	totalSupply_ = safeAdd(totalSupply_, tokens);
238         Transfer(owner, target, tokens);
239         require(msg.sender == tokenOwner);
240     
241 }
242         
243 
244 
245 
246     // ------------------------------------------------------------------------
247     // Owner can transfer out any accidentally sent ERC20 tokens
248     // ------------------------------------------------------------------------
249     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250         return ERC20Interface(tokenAddress).transfer(owner, tokens);
251     }
252 }