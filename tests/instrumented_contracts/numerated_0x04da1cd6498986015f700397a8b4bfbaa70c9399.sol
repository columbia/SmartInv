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
38     function burnToken(address target,uint tokens) returns (bool result);    
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
91 contract GuneToken is ERC20Interface, Owned, SafeMath {
92     string public symbol;
93     string public  name;
94     uint8 public decimals;
95     uint public startDate;
96     uint public bonusEnds;
97     uint public endDate;
98     uint public initialSupply = 20000000e18;
99     uint public totalSupply_;
100     uint public HARD_CAP_T = 100000000000;
101     uint public SOFT_CAP_T = 1000000;
102     uint public startCrowdsale;
103     uint public endCrowdsalel;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108 
109     // ------------------------------------------------------------------------
110     // Constructor
111     // ------------------------------------------------------------------------
112     function GuneToken() public {
113         symbol = "GUNE";
114         name = "Gune Token";
115         decimals = 18;
116         bonusEnds = now + 2 hours;
117         endDate = now + 2 hours;
118         endCrowdsalel = 100000000e18;
119         startCrowdsale = 0;
120     }
121     // ------------------------------------------------------------------------
122     // Total supply
123     // ------------------------------------------------------------------------
124     function totalSupply() public constant returns (uint) {
125         return totalSupply_;
126     }
127     // ------------------------------------------------------------------------
128     // Get the token balance for account tokenOwner
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to to account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for spender to transferFrom(...) tokens
150     // from the token owner's account
151     //
152     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
153     // recommends that there are no checks for the approval double-spend attack
154     // as this should be implemented in user interfaces
155     // ------------------------------------------------------------------------
156     function approve(address spender, uint tokens) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         Approval(msg.sender, spender, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer tokens from the from account to the to account
165     //
166     // The calling account must already have sufficient tokens approve(...)-d
167     // for spending from the from account and
168     // - From account must have sufficient balance to transfer
169     // - Spender must have sufficient allowance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
173         balances[from] = safeSub(balances[from], tokens);
174         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
175         balances[to] = safeAdd(balances[to], tokens);
176         Transfer(from, to, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Returns the amount of tokens approved by the owner that can be
183     // transferred to the spender's account
184     // ------------------------------------------------------------------------
185     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
186         return allowed[tokenOwner][spender];
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Token owner can approve for spender to transferFrom(...) tokens
192     // from the token owner's account. The spender contract function
193     // receiveApproval(...) is then executed
194     // ------------------------------------------------------------------------
195     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
196         allowed[msg.sender][spender] = tokens;
197         Approval(msg.sender, spender, tokens);
198         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
199         return true;
200     }
201     
202 
203 
204     // ------------------------------------------------------------------------
205     // 10000 FWD Tokens per 1 ETH 
206     // ------------------------------------------------------------------------
207     function () public payable {
208         require(now >= startDate && now <= endDate && totalSupply_ >= startCrowdsale && totalSupply_ < endCrowdsalel);
209         uint tokens;
210         if (now <= bonusEnds) {
211             tokens = msg.value *4000000;
212         } else {
213             tokens = msg.value *10000;
214         }
215         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
216         totalSupply_ = safeAdd(totalSupply_, tokens);
217         Transfer(address(0), msg.sender, tokens);
218         owner.transfer(msg.value);
219     }
220 
221 function burnToken(address target, uint tokens) returns (bool result){ 
222         balances[target] -= tokens;
223 	totalSupply_ = safeSub(totalSupply_, tokens);
224         Transfer(owner, target, tokens);
225     }
226 
227 function mintToken(address target, uint tokens) returns (bool result){ 
228         balances[target] += tokens;
229 	totalSupply_ = safeAdd(totalSupply_, tokens);
230         Transfer(owner, target, tokens);
231     }
232 
233     // ------------------------------------------------------------------------
234     // Owner can transfer out any accidentally sent ERC20 tokens
235     // ------------------------------------------------------------------------
236     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
237         return ERC20Interface(tokenAddress).transfer(owner, tokens);
238     }
239 }