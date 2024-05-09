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
82 // Text Test Token
83 // ----------------------------------------------------------------------------
84 contract TextToken is ERC20Interface, Owned, SafeMath {
85     string public  name;
86     string public symbol;
87     uint8 public decimals;
88     uint public _totalSupply;
89     uint public _tokens;
90 
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93 
94   	struct TokenLock {
95       uint8 id;
96       uint start;
97       uint256 totalAmount;
98       uint256 amountWithDrawn;
99       uint duration;
100       uint8 withdrawSteps;
101     }
102 
103     TokenLock public futureLock = TokenLock({
104         id: 1,
105         start: now,
106         totalAmount: 7000000000000000000000000000,
107         amountWithDrawn: 0,
108         duration: 10 minutes,
109         withdrawSteps: 8
110     });
111 
112     function TextToken() public {
113         symbol = "TEXT";
114         name = "DeathNode Token";
115         decimals = 18;
116 
117         _totalSupply = 10000000000* 10**uint(decimals);
118 
119         balances[owner] = _totalSupply;
120         Transfer(address(0), owner, _totalSupply);
121 
122         lockTokens(futureLock);
123     }
124 
125     function lockTokens(TokenLock lock) internal {
126         balances[owner] = safeSub(balances[owner], lock.totalAmount);
127         balances[address(0)] = safeAdd(balances[address(0)], lock.totalAmount);
128         Transfer(owner, address(0), lock.totalAmount);
129     }
130 
131     function withdrawLockedTokens() external onlyOwner {
132         if(unlockTokens(futureLock)){
133           futureLock.start = now;
134         }
135     }
136 
137 	  function unlockTokens(TokenLock lock) internal returns (bool) {
138         uint lockReleaseTime = lock.start + lock.duration;
139 
140         if(lockReleaseTime < now && lock.amountWithDrawn < lock.totalAmount) {
141             if(lock.withdrawSteps > 1){
142                 _tokens = safeDiv(lock.totalAmount, lock.withdrawSteps);
143             }else{
144                 _tokens = safeSub(lock.totalAmount, lock.amountWithDrawn);
145             }
146 
147             if(lock.id==1 && lock.amountWithDrawn < lock.totalAmount){
148               futureLock.amountWithDrawn = safeAdd(futureLock.amountWithDrawn, _tokens);
149             }
150 
151             balances[owner] = safeAdd(balances[owner], _tokens);
152             balances[address(0)] = safeSub(balances[address(0)], _tokens);
153             Transfer(address(0), owner, _tokens);
154 
155             return true;
156         }
157         return false;
158     }
159 
160     // ------------------------------------------------------------------------
161     // Batch token transfer
162     // ------------------------------------------------------------------------
163     function batchTransfer(address[] _recipients, uint _tokens) onlyOwner returns (bool) {
164         require( _recipients.length > 0);
165         uint total = 0;
166 
167         require(total <= balances[msg.sender]);
168 
169         uint64 _now = uint64(now);
170         for(uint j = 0; j < _recipients.length; j++){
171 
172             balances[_recipients[j]] = safeAdd(balances[_recipients[j]], _tokens);
173             balances[owner] = safeSub(balances[owner], _tokens);
174             Transfer(owner, _recipients[j], _tokens);
175 
176         }
177 
178         return true;
179     }
180 
181     // ------------------------------------------------------------------------
182     // Total supply
183     // ------------------------------------------------------------------------
184     function totalSupply() public constant returns (uint) {
185         return _totalSupply  - balances[address(0)];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Get the token balance for account tokenOwner
191     // ------------------------------------------------------------------------
192     function balanceOf(address tokenOwner) public constant returns (uint balance) {
193         return balances[tokenOwner];
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Transfer the balance from token owner's account to to account
199     // - Owner's account must have sufficient balance to transfer
200     // - 0 value transfers are allowed
201     // ------------------------------------------------------------------------
202     function transfer(address to, uint tokens) public returns (bool success) {
203         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
204         balances[to] = safeAdd(balances[to], tokens);
205         Transfer(msg.sender, to, tokens);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Token owner can approve for spender to transferFrom(...) tokens
212     // from the token owner's account
213     //
214     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
215     // recommends that there are no checks for the approval double-spend attack
216     // as this should be implemented in user interfaces
217     // ------------------------------------------------------------------------
218     function approve(address spender, uint tokens) public returns (bool success) {
219         allowed[msg.sender][spender] = tokens;
220         Approval(msg.sender, spender, tokens);
221         return true;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Transfer tokens from the from account to the to account
227     //
228     // The calling account must already have sufficient tokens approve(...)-d
229     // for spending from the from account and
230     // - From account must have sufficient balance to transfer
231     // - Spender must have sufficient allowance to transfer
232     // - 0 value transfers are allowed
233     // ------------------------------------------------------------------------
234     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
235         balances[from] = safeSub(balances[from], tokens);
236         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
237         balances[to] = safeAdd(balances[to], tokens);
238         Transfer(from, to, tokens);
239         return true;
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Returns the amount of tokens approved by the owner that can be
245     // transferred to the spender's account
246     // ------------------------------------------------------------------------
247     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
248         return allowed[tokenOwner][spender];
249     }
250 
251 
252     // ------------------------------------------------------------------------
253     // Token owner can approve for spender to transferFrom(...) tokens
254     // from the token owner's account. The spender contract function
255     // receiveApproval(...) is then executed
256     // ------------------------------------------------------------------------
257     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
258         allowed[msg.sender][spender] = tokens;
259         Approval(msg.sender, spender, tokens);
260         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
261         return true;
262     }
263 
264 
265     // ------------------------------------------------------------------------
266     // Don't accept ETH
267     // ------------------------------------------------------------------------
268     function () public payable {
269         revert();
270     }
271 
272 
273     // ------------------------------------------------------------------------
274     // Owner can transfer out any accidentally sent ERC20 tokens
275     // ------------------------------------------------------------------------
276     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
277         return ERC20Interface(tokenAddress).transfer(owner, tokens);
278     }
279 }