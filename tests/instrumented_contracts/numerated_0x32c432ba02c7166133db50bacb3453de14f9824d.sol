1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract MultiOwnable {
6   // FIELDS ========================
7 
8   bool public isLocked;
9 
10   address public owner1;
11   address public owner2;
12 
13   // the ongoing operations.
14   mapping(bytes32 => PendingState) public m_pending;
15 
16   // TYPES
17 
18   // struct for the status of a pending operation.
19   struct PendingState {
20     bool confirmation1;
21     bool confirmation2;
22     uint exists; // used to know if array exists, solidity is strange
23   }
24 
25   // EVENTS
26 
27   event Confirmation(address owner, bytes32 operation);
28   event Revoke(address owner, bytes32 operation);
29   event ConfirmationNeeded(bytes32 operation, address from, uint value, address to);
30 
31   modifier onlyOwner {
32     require(isOwner(msg.sender));
33     _;
34   }
35 
36   modifier onlyManyOwners(bytes32 _operation) {
37     if (confirmAndCheck(_operation))
38       _;
39   }
40 
41   modifier onlyIfUnlocked {
42     require(!isLocked);
43     _;
44   }
45 
46 
47   // constructor is given number of sigs required to do protected "onlyManyOwners" transactions
48   // as well as the selection of addresses capable of confirming them.
49   constructor(address _owner1, address _owner2) public {
50     require(_owner1 != address(0));
51     require(_owner2 != address(0));
52 
53     owner1 = _owner1;
54     owner2 = _owner2;
55     isLocked = true;
56   }
57 
58   function unlock() public onlyOwner {
59     isLocked = false;
60   }
61 
62   // Revokes a prior confirmation of the given operation
63   function revoke(bytes32 _operation) external onlyOwner {
64     emit Revoke(msg.sender, _operation);
65     delete m_pending[_operation];
66   }
67 
68   function isOwner(address _addr) public view returns (bool) {
69     return _addr == owner1 || _addr == owner2;
70   }
71 
72   function hasConfirmed(bytes32 _operation, address _owner)
73     constant public onlyOwner
74     returns (bool) {
75 
76     if (_owner == owner1) {
77       return m_pending[_operation].confirmation1;
78     }
79 
80     if (_owner == owner2) {
81       return m_pending[_operation].confirmation2;
82     }
83   }
84 
85   // INTERNAL METHODS
86 
87   function confirmAndCheck(bytes32 _operation)
88     internal onlyOwner
89     returns (bool) {
90 
91     // Confirmation doesn't exists so create it
92     if (m_pending[_operation].exists == 0) {
93       if (msg.sender == owner1) { m_pending[_operation].confirmation1 = true; }
94       if (msg.sender == owner2) { m_pending[_operation].confirmation2 = true; }
95       m_pending[_operation].exists = 1;
96 
97       // early exit
98       return false;
99     }
100 
101     // already confirmed
102     if (msg.sender == owner1 && m_pending[_operation].confirmation1 == true) {
103       return false;
104     }
105 
106     // already confirmed
107     if (msg.sender == owner2 && m_pending[_operation].confirmation2 == true) {
108       return false;
109     }
110 
111     if (msg.sender == owner1) {
112       m_pending[_operation].confirmation1 = true;
113     }
114 
115     if (msg.sender == owner2) {
116       m_pending[_operation].confirmation2 = true;
117     }
118 
119     // final verification
120     return m_pending[_operation].confirmation1 && m_pending[_operation].confirmation2;
121   }
122 }
123 
124 
125 
126 // ----------------------------------------------------------------------------
127 // Safe maths
128 // ----------------------------------------------------------------------------
129 library SafeMath {
130   function add(uint a, uint b) internal pure returns (uint c) {
131     c = a + b;
132     require(c >= a);
133   }
134 
135   function sub(uint a, uint b) internal pure returns (uint c) {
136     require(b <= a);
137     c = a - b;
138   }
139 
140   function mul(uint a, uint b) internal pure returns (uint c) {
141     c = a * b;
142     require(a == 0 || c / a == b);
143   }
144 
145   function div(uint a, uint b) internal pure returns (uint c) {
146     require(b > 0);
147     c = a / b;
148   }
149 }
150 
151 
152 
153 // ----------------------------------------------------------------------------
154 // ERC Token Standard #20 Interface
155 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
156 // ----------------------------------------------------------------------------
157 contract ERC20Interface {
158   function totalSupply() public constant returns (uint);
159   function balanceOf(address tokenOwner) public constant returns (uint balance);
160   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
161   function transfer(address to, uint tokens) public returns (bool success);
162   function approve(address spender, uint tokens) public returns (bool success);
163   function transferFrom(address from, address to, uint tokens) public returns (bool success);
164 
165   event Transfer(address indexed from, address indexed to, uint tokens);
166   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
167 }
168 
169 
170 
171 // ----------------------------------------------------------------------------
172 // Contract function to receive approval and execute function in one call
173 //
174 // Borrowed from MiniMeToken
175 // ----------------------------------------------------------------------------
176 contract ApproveAndCallFallBack {
177   function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
178 }
179 
180 
181 // ----------------------------------------------------------------------------
182 // ERC20 Token, with the addition of symbol, name and decimals and a
183 // fixed supply
184 // ----------------------------------------------------------------------------
185 
186 /* contract Goldchain is ERC20Interface, Owned { */
187 contract TruGold is ERC20Interface, MultiOwnable {
188   using SafeMath for uint;
189 
190   string public symbol;
191   string public  name;
192   uint8 public decimals;
193   uint _totalSupply;
194 
195   mapping(address => uint) balances;
196   mapping(address => mapping(address => uint)) allowed;
197   mapping (bytes32 => Transaction) public pendingTransactions; // pending transactions we have at present.
198 
199   struct Transaction {
200     address from;
201     address to;
202     uint value;
203   }
204 
205 
206   // ------------------------------------------------------------------------
207   // Constructor
208   // ------------------------------------------------------------------------
209   constructor(address target, address _owner1, address _owner2)
210     MultiOwnable(_owner1, _owner2) public {
211     symbol = "TruGold";
212     name = "TruGold";
213     decimals = 18;
214     _totalSupply = 300000000 * 10**uint(decimals);
215     balances[target] = _totalSupply;
216 
217     emit Transfer(address(0), target, _totalSupply);
218   }
219 
220   // ------------------------------------------------------------------------
221   // Total supply
222   // ------------------------------------------------------------------------
223   function totalSupply() public view returns (uint) {
224     return _totalSupply.sub(balances[address(0)]);
225   }
226 
227   // ------------------------------------------------------------------------
228   // Get the token balance for account `tokenOwner`
229   // ------------------------------------------------------------------------
230   function balanceOf(address tokenOwner) public view returns (uint balance) {
231     return balances[tokenOwner];
232   }
233 
234   // ------------------------------------------------------------------------
235   // Transfer the balance from token owner's account to `to` account
236   // - Owner's account must have sufficient balance to transfer
237   // - 0 value transfers are allowed
238   // ------------------------------------------------------------------------
239   /* function transfer(address to, uint tokens) public onlyOwnerIfLocked returns (bool success) { */
240   function transfer(address to, uint tokens)
241     public
242     onlyIfUnlocked
243     returns (bool success) {
244     balances[msg.sender] = balances[msg.sender].sub(tokens);
245     balances[to] = balances[to].add(tokens);
246 
247     emit Transfer(msg.sender, to, tokens);
248     return true;
249   }
250 
251   function ownerTransfer(address from, address to, uint value)
252     public onlyOwner
253     returns (bytes32 operation) {
254 
255     operation = keccak256(abi.encodePacked(msg.data, block.number));
256 
257     if (!approveOwnerTransfer(operation) && pendingTransactions[operation].to == 0) {
258       pendingTransactions[operation].from = from;
259       pendingTransactions[operation].to = to;
260       pendingTransactions[operation].value = value;
261 
262       emit ConfirmationNeeded(operation, from, value, to);
263     }
264 
265     return operation;
266   }
267 
268   function approveOwnerTransfer(bytes32 operation)
269     public
270     onlyManyOwners(operation)
271     returns (bool success) {
272 
273     // find transaction in storage
274     Transaction storage transaction = pendingTransactions[operation];
275 
276     // update balances accordingly
277     balances[transaction.from] = balances[transaction.from].sub(transaction.value);
278     balances[transaction.to] = balances[transaction.to].add(transaction.value);
279 
280     // delete current transaction
281     delete pendingTransactions[operation];
282 
283     emit Transfer(transaction.from, transaction.to, transaction.value);
284 
285     return true;
286   }
287 
288   // ------------------------------------------------------------------------
289   // Token owner can approve for `spender` to transferFrom(...) `tokens`
290   // from the token owner's account
291   //
292   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
293   // recommends that there are no checks for the approval double-spend attack
294   // as this should be implemented in user interfaces
295   // ------------------------------------------------------------------------
296   function approve(address spender, uint tokens) public returns (bool success) {
297     allowed[msg.sender][spender] = tokens;
298     emit Approval(msg.sender, spender, tokens);
299     return true;
300   }
301 
302   // ------------------------------------------------------------------------
303   // Transfer `tokens` from the `from` account to the `to` account
304   //
305   // The calling account must already have sufficient tokens approve(...)-d
306   // for spending from the `from` account and
307   // - From account must have sufficient balance to transfer
308   // - Spender must have sufficient allowance to transfer
309   // - 0 value transfers are allowed
310   // ------------------------------------------------------------------------
311   function transferFrom(address from, address to, uint tokens) public onlyIfUnlocked returns (bool success) {
312     balances[from] = balances[from].sub(tokens);
313     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
314     balances[to] = balances[to].add(tokens);
315 
316     emit Transfer(from, to, tokens);
317 
318     return true;
319   }
320 
321   // ------------------------------------------------------------------------
322   // Returns the amount of tokens approved by the owner that can be
323   // transferred to the spender's account
324   // ------------------------------------------------------------------------
325   function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
326     return allowed[tokenOwner][spender];
327   }
328 
329 
330   // ------------------------------------------------------------------------
331   // Token owner can approve for `spender` to transferFrom(...) `tokens`
332   // from the token owner's account. The `spender` contract function
333   // `receiveApproval(...)` is then executed
334   // ------------------------------------------------------------------------
335   function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
336     allowed[msg.sender][spender] = tokens;
337     emit Approval(msg.sender, spender, tokens);
338     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
339 
340     return true;
341   }
342 
343 
344   // ------------------------------------------------------------------------
345   // Don't accept ETH
346   // ------------------------------------------------------------------------
347   function () public payable {
348     revert();
349   }
350 
351   // ------------------------------------------------------------------------
352   // Owner can transfer out any accidentally sent ERC20 tokens
353   // ------------------------------------------------------------------------
354   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
355       return ERC20Interface(tokenAddress).transfer(owner1, tokens);
356   }
357 }