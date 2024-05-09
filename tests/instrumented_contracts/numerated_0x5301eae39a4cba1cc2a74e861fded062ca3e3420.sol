1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
45 // ----------------------------------------------------------------------------
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     function Owned() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Centaure
83 // ----------------------------------------------------------------------------
84 contract Centaure is ERC20Interface, Owned, SafeMath {
85     string public  name;
86     string public symbol;
87     uint8 public decimals;
88     uint public _totalSupply;
89     uint public _tokens;
90 
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93 
94   	struct TokenLock { uint8 id; uint start; uint256 totalAmount;  uint256 amountWithDrawn; uint duration; uint8 withdrawSteps; }
95 
96     TokenLock public futureDevLock = TokenLock({
97         id: 1,
98         start: now,
99         totalAmount: 7500000000000000000000000,
100         amountWithDrawn: 0,
101         duration: 180 days,
102         withdrawSteps: 3
103     });
104 
105     TokenLock public advisorsLock = TokenLock({
106         id: 2,
107         start: now,
108         totalAmount: 2500000000000000000000000,
109         amountWithDrawn: 0,
110         duration: 180 days,
111         withdrawSteps: 1
112     });
113 
114     TokenLock public teamLock = TokenLock({
115         id: 3,
116         start: now,
117         totalAmount: 6000000000000000000000000,
118         amountWithDrawn: 0,
119         duration: 180 days,
120         withdrawSteps: 6
121     });
122 
123     function Centaure() public {
124         symbol = "CEN";
125         name = "Centaure Token";
126         decimals = 18;
127 
128         _totalSupply = 50000000* 10**uint(decimals);
129 
130         balances[owner] = _totalSupply;
131         Transfer(address(0), owner, _totalSupply);
132 
133         lockTokens(futureDevLock);
134         lockTokens(advisorsLock);
135         lockTokens(teamLock);
136     }
137 
138     function lockTokens(TokenLock lock) internal {
139         balances[owner] = safeSub(balances[owner], lock.totalAmount);
140         balances[address(0)] = safeAdd(balances[address(0)], lock.totalAmount);
141         Transfer(owner, address(0), lock.totalAmount);
142     }
143 
144     function withdrawLockedTokens() external onlyOwner {
145         if(unlockTokens(futureDevLock)){
146           futureDevLock.start = now;
147         }
148         if(unlockTokens(advisorsLock)){
149           advisorsLock.start = now;
150         }
151         if(unlockTokens(teamLock)){
152           teamLock.start = now;
153         }
154     }
155 
156 	function unlockTokens(TokenLock lock) internal returns (bool) {
157         uint lockReleaseTime = lock.start + lock.duration;
158 
159         if(lockReleaseTime < now && lock.amountWithDrawn < lock.totalAmount) {
160             if(lock.withdrawSteps > 1){
161                 _tokens = safeDiv(lock.totalAmount, lock.withdrawSteps);
162             }else{
163                 _tokens = safeSub(lock.totalAmount, lock.amountWithDrawn);
164             }
165 
166             balances[owner] = safeAdd(balances[owner], _tokens);
167             balances[address(0)] = safeSub(balances[address(0)], _tokens);
168             Transfer(address(0), owner, _tokens);
169 
170             if(lock.id==1 && lock.amountWithDrawn < lock.totalAmount){
171               futureDevLock.amountWithDrawn = safeAdd(futureDevLock.amountWithDrawn, _tokens);
172             }
173             if(lock.id==2 && lock.amountWithDrawn < lock.totalAmount){
174               advisorsLock.amountWithDrawn = safeAdd(advisorsLock.amountWithDrawn, _tokens);
175             }
176             if(lock.id==3 && lock.amountWithDrawn < lock.totalAmount) {
177               teamLock.amountWithDrawn = safeAdd(teamLock.amountWithDrawn, _tokens);
178               teamLock.withdrawSteps = 1;
179             }
180             return true;
181         }
182         return false;
183     }
184 
185     // ------------------------------------------------------------------------
186     // Total supply
187     // ------------------------------------------------------------------------
188     function totalSupply() public constant returns (uint) {
189         return _totalSupply  - balances[address(0)];
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Get the token balance for account tokenOwner
195     // ------------------------------------------------------------------------
196     function balanceOf(address tokenOwner) public constant returns (uint balance) {
197         return balances[tokenOwner];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Transfer the balance from token owner's account to to account
203     // - Owner's account must have sufficient balance to transfer
204     // - 0 value transfers are allowed
205     // ------------------------------------------------------------------------
206     function transfer(address to, uint tokens) public returns (bool success) {
207         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
208         balances[to] = safeAdd(balances[to], tokens);
209         Transfer(msg.sender, to, tokens);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Token owner can approve for spender to transferFrom(...) tokens
216     // from the token owner's account
217     //
218     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
219     // recommends that there are no checks for the approval double-spend attack
220     // as this should be implemented in user interfaces
221     // ------------------------------------------------------------------------
222     function approve(address spender, uint tokens) public returns (bool success) {
223         allowed[msg.sender][spender] = tokens;
224         Approval(msg.sender, spender, tokens);
225         return true;
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Transfer tokens from the from account to the to account
231     //
232     // The calling account must already have sufficient tokens approve(...)-d
233     // for spending from the from account and
234     // - From account must have sufficient balance to transfer
235     // - Spender must have sufficient allowance to transfer
236     // - 0 value transfers are allowed
237     // ------------------------------------------------------------------------
238     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
239         balances[from] = safeSub(balances[from], tokens);
240         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
241         balances[to] = safeAdd(balances[to], tokens);
242         Transfer(from, to, tokens);
243         return true;
244     }
245 
246 
247     // ------------------------------------------------------------------------
248     // Returns the amount of tokens approved by the owner that can be
249     // transferred to the spender's account
250     // ------------------------------------------------------------------------
251     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
252         return allowed[tokenOwner][spender];
253     }
254 
255 
256     // ------------------------------------------------------------------------
257     // Token owner can approve for spender to transferFrom(...) tokens
258     // from the token owner's account. The spender contract function
259     // receiveApproval(...) is then executed
260     // ------------------------------------------------------------------------
261     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
262         allowed[msg.sender][spender] = tokens;
263         Approval(msg.sender, spender, tokens);
264         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
265         return true;
266     }
267 
268 
269     // ------------------------------------------------------------------------
270     // Don't accept ETH
271     // ------------------------------------------------------------------------
272     function () public payable {
273         revert();
274     }
275 
276 
277     // ------------------------------------------------------------------------
278     // Owner can transfer out any accidentally sent ERC20 tokens
279     // ------------------------------------------------------------------------
280     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
281         return ERC20Interface(tokenAddress).transfer(owner, tokens);
282     }
283 }