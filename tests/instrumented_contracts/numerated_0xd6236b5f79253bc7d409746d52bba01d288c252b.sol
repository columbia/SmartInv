1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Goopy Token' token contract
5 //
6 // Deployed to : TBD
7 // Symbol      : GOP
8 // Name        : GOPERTOKEN
9 // Total supply: 30000000
10 // Decimals    : 18
11 //
12 // THANKS.
13 //
14 // (c) by DANIEL K / DEC 2021 COPYRIGHT.
15 // ----------------------------------------------------------------------------
16 
17 contract Lockable {
18     uint public creationTime;
19     bool public lock;
20     address public owner;
21 
22     mapping( address => bool ) public lockaddress;
23 
24     event Locked(address lockaddress,bool status);
25     event Unlocked(address unlockedaddress, bool status);
26 
27     constructor() public {
28         creationTime = now;    
29         owner = msg.sender;
30     }
31 
32     // This modifier check whether the contract should be in a locked
33     // or unlocked state, then acts and updates accordingly if
34     // necessary
35     modifier checkLock {
36         if (lockaddress[msg.sender]) {
37            revert();
38         }
39         //require(!lockaddress[msg.sender]);
40         //assert(!lockaddress[msg.sender]);
41         _;
42     }
43 
44     modifier isOwner {
45         require(owner == msg.sender);
46         _;
47     }
48 
49    
50 
51     // Lock Address
52     function lockAddress(address target)
53     external
54     isOwner
55     {
56         require(owner != target);
57         lockaddress[target] = true;
58         emit Locked(target, true);
59     }
60 
61     // UnLock Address
62     function unlockAddress(address target)
63     external
64     isOwner
65     {
66         lockaddress[target] = false;
67         emit Unlocked(target, false);
68     }
69 }
70 
71 // ----------------------------------------------------------------------------
72 // Safe maths
73 // ----------------------------------------------------------------------------
74 
75 contract SafeMath {
76     function safeAdd(uint a, uint b) public pure returns (uint c) {
77         c = a + b;
78         require(c >= a);
79     }
80     function safeSub(uint a, uint b) public pure returns (uint c) {
81         require(b <= a);
82         c = a - b;
83     }
84     function safeMul(uint a, uint b) public pure returns (uint c) {
85         c = a * b;
86         require(a == 0 || c / a == b);
87     }
88     function safeDiv(uint a, uint b) public pure returns (uint c) {
89         require(b > 0);
90         c = a / b;
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC Token Standard #20 Interface
97 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
98 // ----------------------------------------------------------------------------
99 contract ERC20Interface {
100     function totalSupply() public constant returns (uint);
101     function balanceOf(address tokenOwner) public constant returns (uint balance);
102     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
103     function transfer(address to, uint tokens) public returns (bool success);
104     function approve(address spender, uint tokens) public returns (bool success);
105     function transferFrom(address from, address to, uint tokens) public returns (bool success);
106 
107     event Transfer(address indexed from, address indexed to, uint tokens);
108     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
109 }
110 
111 
112 // ----------------------------------------------------------------------------
113 // Contract function to receive approval and execute function in one call
114 //
115 // Borrowed from MiniMeToken
116 // ----------------------------------------------------------------------------
117 contract ApproveAndCallFallBack {
118     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
119 }
120 
121 
122 // ----------------------------------------------------------------------------
123 // Owned contract
124 // ----------------------------------------------------------------------------
125 contract Owned {
126     address public owner;
127     address public newOwner;
128 
129     event OwnershipTransferred(address indexed _from, address indexed _to);
130 
131     constructor() public {
132         owner = msg.sender;
133     }
134 
135     modifier onlyOwner {
136         require(msg.sender == owner);
137         _;
138     }
139 
140     function transferOwnership(address _newOwner) public onlyOwner {
141         newOwner = _newOwner;
142     }
143     function acceptOwnership() public {
144         require(msg.sender == newOwner);
145         emit OwnershipTransferred(owner, newOwner);
146         owner = newOwner;
147         newOwner = address(0);
148     }
149 }
150 
151 
152 // ----------------------------------------------------------------------------
153 // ERC20 Token, with the addition of symbol, name and decimals and assisted
154 // token transfers
155 // ----------------------------------------------------------------------------
156 contract GOPHERTOKEN is ERC20Interface, Owned, SafeMath, Lockable {
157     //string public constant name = "GOPHERTOKEN";
158     //string public constant symbol = "GOP";
159     string public constant name = "Gopher Token";
160     string public constant symbol = "GOP";
161     uint8 public constant decimals = 18; 
162     uint public constant INITIAL_SUPPLY = 30000000000000000000000000;
163     uint public _totalSupply;
164     
165     mapping(address => uint) balances;
166     mapping(address => mapping(address => uint)) allowed;
167 
168     event TokenBurned(address burnAddress, uint amountOfTokens);
169 
170     // ------------------------------------------------------------------------
171     // Constructor
172     // ------------------------------------------------------------------------
173     constructor() public {
174         _totalSupply = INITIAL_SUPPLY;
175         balances[msg.sender] = _totalSupply;
176         emit Transfer(address(0), msg.sender, _totalSupply);
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Total supply
182     // ------------------------------------------------------------------------
183     function totalSupply() public constant returns (uint) {
184         return _totalSupply  - balances[address(0)];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Get the token balance for account tokenOwner
190     // ------------------------------------------------------------------------
191     function balanceOf(address tokenOwner) public constant returns (uint balance) {
192         return balances[tokenOwner];
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Transfer the balance from token owner's account to to account
198     // - Owner's account must have sufficient balance to transfer
199     // - 0 value transfers are allowed
200     // ------------------------------------------------------------------------
201     function transfer(address to, uint tokens) public 
202     checkLock
203     returns (bool success) {
204         require( balances[msg.sender] >= tokens );
205 
206         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
207         balances[to] = safeAdd(balances[to], tokens);
208         emit Transfer(msg.sender, to, tokens);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Token owner can approve for spender to transferFrom(...) tokens
215     // from the token owner's account
216     //
217     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
218     // recommends that there are no checks for the approval double-spend attack
219     // as this should be implemented in user interfaces 
220     // ------------------------------------------------------------------------
221     function approve(address spender, uint tokens) public 
222     checkLock
223     returns (bool success) {
224         allowed[msg.sender][spender] = tokens;
225         emit Approval(msg.sender, spender, tokens);
226         return true;
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Transfer tokens from the from account to the to account
232     // 
233     // The calling account must already have sufficient tokens approve(...)-d
234     // for spending from the from account and
235     // - From account must have sufficient balance to transfer
236     // - Spender must have sufficient allowance to transfer
237     // - 0 value transfers are allowed
238     // ------------------------------------------------------------------------
239     function transferFrom(address from, address to, uint tokens) public 
240     checkLock
241     returns (bool success) {
242         require( balances[from] >= tokens );
243         require( allowed[from][msg.sender] >= tokens );
244 
245         balances[from] = safeSub(balances[from], tokens);
246         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
247         balances[to] = safeAdd(balances[to], tokens);
248         emit Transfer(from, to, tokens);
249         return true;
250     }
251 
252 
253     // ------------------------------------------------------------------------
254     // Returns the amount of tokens approved by the owner that can be
255     // transferred to the spender's account
256     // ------------------------------------------------------------------------
257     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
258         return allowed[tokenOwner][spender];
259     }
260 
261 
262     // ------------------------------------------------------------------------
263     // Token owner can approve for spender to transferFrom(...) tokens
264     // from the token owner's account. The spender contract function
265     // receiveApproval(...) is then executed
266     // ------------------------------------------------------------------------
267     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
268         allowed[msg.sender][spender] = tokens;
269         emit Approval(msg.sender, spender, tokens);
270         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
271         return true;
272     }
273 
274 
275     // ------------------------------------------------------------------------
276     // Don't accept ETH
277     // ------------------------------------------------------------------------
278     function () public payable {
279         revert();
280     }
281 
282 
283     // ------------------------------------------------------------------------
284     // Owner can transfer out any accidentally sent ERC20 tokens
285     // ------------------------------------------------------------------------
286     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
287         return ERC20Interface(tokenAddress).transfer(owner, tokens);
288     }
289 
290     // burnToken burn tokensAmount for sender balance
291     function burnTokens(uint tokensAmount)
292     external
293     isOwner
294     {
295         require( balances[msg.sender] >= tokensAmount );
296 
297         balances[msg.sender] = safeSub(balances[msg.sender], tokensAmount);
298         _totalSupply = safeSub(_totalSupply, tokensAmount);
299         emit TokenBurned(msg.sender, tokensAmount);
300 
301     }
302 }