1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Xi Ma La Ya contract
5 //
6 // Deployed to : msg.sender
7 // Symbol      : XMLY
8 // Name        : XiMaLaYa
9 // Total supply: 100000000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
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
74         owner = 0x5B807E379170d42f3B099C01A5399a2e1e58963B;
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
91     
92     function withdrawBalance() external onlyOwner {
93         owner.transfer(this.balance);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract XMLYToken is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110     mapping(address => bool) freezed;
111     mapping(address => uint) freezeAmount;
112     mapping(address => uint) unlockTime;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     function XMLYToken() public {
119         symbol = "XMLY";
120         name = "XiMaLaYa";
121         decimals = 18;
122         _totalSupply = 100000000000000000000000000000;
123         balances[0x5B807E379170d42f3B099C01A5399a2e1e58963B] = _totalSupply;
124         Transfer(address(0), 0x5B807E379170d42f3B099C01A5399a2e1e58963B, _totalSupply);
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public constant returns (uint) {
132         return _totalSupply  - balances[address(0)];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account tokenOwner
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to to account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         if(freezed[msg.sender] == false){
151             balances[msg.sender] = safeSub(balances[msg.sender], tokens);
152             balances[to] = safeAdd(balances[to], tokens);
153             Transfer(msg.sender, to, tokens);
154         } else {
155             if(balances[msg.sender] > freezeAmount[msg.sender]) {
156                 require(tokens <= safeSub(balances[msg.sender], freezeAmount[msg.sender]));
157                 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
158                 balances[to] = safeAdd(balances[to], tokens);
159                 Transfer(msg.sender, to, tokens);
160             }
161         }
162             
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for spender to transferFrom(...) tokens
169     // from the token owner's account
170     //
171     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
172     // recommends that there are no checks for the approval double-spend attack
173     // as this should be implemented in user interfaces 
174     // ------------------------------------------------------------------------
175     function approve(address spender, uint tokens) public returns (bool success) {
176         require(freezed[msg.sender] != true);
177         allowed[msg.sender][spender] = tokens;
178         Approval(msg.sender, spender, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Transfer tokens from the from account to the to account
185     // 
186     // The calling account must already have sufficient tokens approve(...)-d
187     // for spending from the from account and
188     // - From account must have sufficient balance to transfer
189     // - Spender must have sufficient allowance to transfer
190     // - 0 value transfers are allowed
191     // ------------------------------------------------------------------------
192     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
193         balances[from] = safeSub(balances[from], tokens);
194         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
195         balances[to] = safeAdd(balances[to], tokens);
196         Transfer(from, to, tokens);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Returns the amount of tokens approved by the owner that can be
203     // transferred to the spender's account
204     // ------------------------------------------------------------------------
205     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
206         require(freezed[msg.sender] != true);
207         return allowed[tokenOwner][spender];
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Token owner can approve for spender to transferFrom(...) tokens
213     // from the token owner's account. The spender contract function
214     // receiveApproval(...) is then executed
215     // ------------------------------------------------------------------------
216     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
217         require(freezed[msg.sender] != true);
218         allowed[msg.sender][spender] = tokens;
219         Approval(msg.sender, spender, tokens);
220         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
221         return true;
222     }
223 
224     // ------------------------------------------------------------------------
225     // Burn Tokens
226     // ------------------------------------------------------------------------
227     function burn(uint amount) public onlyOwner {
228         balances[msg.sender] = safeSub(balances[msg.sender], amount);
229         _totalSupply = safeSub(_totalSupply, amount);
230     }
231     
232     // ------------------------------------------------------------------------
233     // Freeze Tokens
234     // ------------------------------------------------------------------------
235     function freeze(address user, uint amount, uint period) public onlyOwner {
236         require(balances[user] >= amount);
237         freezed[user] = true;
238         unlockTime[user] = uint(now) + period;
239         freezeAmount[user] = amount;
240     }
241 
242     // ------------------------------------------------------------------------
243     // UnFreeze Tokens
244     // ------------------------------------------------------------------------
245     function unFreeze() public {
246         require(freezed[msg.sender] == true);
247         require(unlockTime[msg.sender] < uint(now));
248         freezed[msg.sender] = false;
249         freezeAmount[msg.sender] = 0;
250     }
251     
252     function ifFreeze(address user) public view returns (
253         bool check, 
254         uint amount, 
255         uint timeLeft
256     ) {
257         check = freezed[user];
258         amount = freezeAmount[user];
259         timeLeft = unlockTime[user] - uint(now);
260     }
261 
262     // ------------------------------------------------------------------------
263     // Accept ETH
264     // ------------------------------------------------------------------------
265     function () public payable {
266     }
267 
268     // ------------------------------------------------------------------------
269     // Owner can transfer out any accidentally sent ERC20 tokens
270     // ------------------------------------------------------------------------
271     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
272         return ERC20Interface(tokenAddress).transfer(owner, tokens);
273     }
274 }