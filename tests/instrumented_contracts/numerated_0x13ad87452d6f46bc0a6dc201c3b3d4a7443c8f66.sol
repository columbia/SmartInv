1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public view returns (uint);
32     function balanceOf(address tokenOwner) public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 contract CrowdsaleInterface {
44 
45     bool fundingGoalReached = false;
46     bool crowdsaleClosed = false;
47 
48     mapping(address => uint8) whitelist;
49     mapping(uint256 => address) holders;
50     uint256 _totalHolders; // you should initialize this to 0 in the constructor
51 
52     function enableWhitelist(address[] _addresses) public returns (bool success);
53 
54     modifier onlyWhitelist() {
55         require(whitelist[msg.sender] == 2);
56         _;
57     }
58 
59 
60 
61 
62 }
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68     address public owner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82       * @dev Allows the current owner to transfer control of the contract to a newOwner.
83       * @param newOwner The address to transfer ownership to.
84       */
85     // function transferOwnership(address newOwner) public onlyOwner {
86     //     _transferOwnership(newOwner);
87     // }
88 
89     /**
90      * @dev Transfers control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93     function _transferOwnership(address newOwner) internal {
94         require(newOwner != address(0));
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97     }
98 
99 }
100 
101 contract TokenTemplate is ERC20Interface, CrowdsaleInterface, Owned {
102     using SafeMath for uint;
103 
104     bytes32 public symbol;
105     uint public price;
106     bytes32 public  name;
107     uint8 public decimals;
108     uint _totalSupply;
109     uint amountRaised;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     constructor(bytes32 _name, bytes32 _symbol, uint _total, uint _gweiCostOfEachToken) public {
119         symbol = _symbol;
120         name = _name;
121         decimals = 18;
122         price= _gweiCostOfEachToken * 10**9;
123         _totalSupply = _total * 10**uint(decimals);
124 
125         _totalHolders = 0;
126 
127         balances[owner] = _totalSupply;
128         holders[_totalHolders] = owner;
129         whitelist[owner] = 2;
130         _totalHolders++;
131 
132 
133         emit Transfer(address(0), owner, _totalSupply);
134 
135 
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Total supply
141     // ------------------------------------------------------------------------
142     function totalSupply() public view returns (uint) {
143         return _totalSupply.sub(balances[address(0)]);
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Get the token balance for account `tokenOwner`
149     // ------------------------------------------------------------------------
150     function balanceOf(address tokenOwner) public view returns (uint balance) {
151         return balances[tokenOwner];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer the balance from token owner's account to `to` account
157     // - Owner's account must have sufficient balance to transfer
158     // - 0 value transfers are allowed
159     // ------------------------------------------------------------------------
160     function transfer(address to, uint tokens) onlyWhitelist public returns (bool success) {
161         balances[msg.sender] = balances[msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         emit Transfer(msg.sender, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Token owner can approve for `spender` to transferFrom(...) `tokens`
170     // from the token owner's account
171     //
172     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
173     // recommends that there are no checks for the approval double-spend attack
174     // as this should be implemented in user interfaces
175     // ------------------------------------------------------------------------
176     function approve(address spender, uint tokens) onlyWhitelist public returns (bool success) {
177         allowed[msg.sender][spender] = tokens;
178         emit Approval(msg.sender, spender, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Transfer `tokens` from the `from` account to the `to` account
185     //
186     // The calling account must already have sufficient tokens approve(...)-d
187     // for spending from the `from` account and
188     // - From account must have sufficient balance to transfer
189     // - Spender must have sufficient allowance to transfer
190     // - 0 value transfers are allowed
191     // ------------------------------------------------------------------------
192     function transferFrom(address from, address to, uint tokens) onlyWhitelist public returns (bool success) {
193         balances[from] = balances[from].sub(tokens);
194         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
195         balances[to] = balances[to].add(tokens);
196         emit Transfer(from, to, tokens);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Returns the amount of tokens approved by the owner that can be
203     // transferred to the spender's account
204     // ------------------------------------------------------------------------
205     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
206         return allowed[tokenOwner][spender];
207     }
208 
209     function enableWhitelist(address[] _addresses) public onlyOwner returns (bool success) {
210         for (uint i = 0; i < _addresses.length; i++) {
211             _addWalletToWhitelist(_addresses[i]);
212         }
213         return true;
214     }
215 
216     function _addWalletToWhitelist(address addr) internal {
217         if (whitelist[addr] == 2) {
218         } else if (whitelist[addr] == 1) {
219             whitelist[addr] = 2;
220         } else {
221             whitelist[addr] = 2;
222             holders[_totalHolders] = addr;
223             _totalHolders++;
224         }
225     }
226 
227     function disableWhitelist(address[] _addresses) public onlyOwner returns (bool success) {
228         for (uint i = 0; i < _addresses.length; i++) {
229             _disableWhitelist(_addresses[i]);
230         }
231         return true;
232     }
233 
234     function _disableWhitelist(address addr) internal {
235         if (whitelist[addr] == 2) {
236             whitelist[addr] = 1;
237         } else {
238         }
239     }
240 
241     function getWhitelist() public view returns (address[] addresses) {
242 
243         uint256 j;
244         uint256 count = 0;
245 
246         for (j=0; j<_totalHolders; j++) {
247             if (whitelist[holders[j]] == 2) {
248                 count = count+1;
249             } else {
250             }
251         }
252         address[] memory wlist = new address[](count);
253 
254         for (j=0; j<count; j++) {
255             if (whitelist[holders[j]] == 2) {
256                 wlist[j] = holders[j];
257             } else {
258             }
259         }
260         return wlist;
261     }
262 
263     function getBalances() public view returns (address[] _addresses, uint256[] _balances) {
264         address[] memory wlist1 = new address[](_totalHolders);
265         uint256[] memory wlist2 = new uint256[](_totalHolders);
266 
267         for (uint256 j=0; j<_totalHolders; j++) {
268             //////if (whitelist[holders[j]] == 2) {
269                 wlist1[j] = holders[j];
270                 wlist2[j] = balances[holders[j]];
271             //////}
272         }
273         return (wlist1,wlist2);
274     }
275 
276     function closeCrowdsale() public onlyOwner  {
277         crowdsaleClosed = true;
278     }
279 
280     function safeWithdrawal() public onlyOwner {
281         require(crowdsaleClosed);
282         require(!fundingGoalReached);
283 
284         if (msg.sender.send(amountRaised)) {
285             fundingGoalReached = true;
286         } else {
287             fundingGoalReached = false;
288         }
289 
290     }
291 
292     // immediate withdrawal withou funding goal reached and without crowdsale close
293     function immediateWithdrawal() public onlyOwner {
294         if (msg.sender.send(amountRaised)) {
295             //fundingGoalReached = true;
296             amountRaised = 0;
297         } else {
298             //fundingGoalReached = false;
299         }
300     }
301 
302     function burnTokens(uint token_amount) public onlyOwner {
303 
304         require(!crowdsaleClosed);
305         balances[owner] = balances[owner].sub(token_amount);
306         _totalSupply = _totalSupply.sub(token_amount);
307         emit Transfer(owner, address(0), token_amount);
308     }
309 
310     function mintTokens(uint token_amount) public onlyOwner {
311         require(!crowdsaleClosed);
312         _totalSupply = _totalSupply.add(token_amount);
313         balances[owner] = balances[owner].add(token_amount);
314         emit Transfer(address(0), owner, token_amount);
315     }
316 
317     function transferOwnership(address newOwner) public onlyOwner {
318 
319         require(!crowdsaleClosed);
320 
321         // enable newOwner to whitelist
322         _addWalletToWhitelist(newOwner);
323 
324         // puts unrealized tokens to new owner
325         uint token_amount = balances[owner];
326         balances[owner] = 0;
327         balances[newOwner] = balances[newOwner].add(token_amount);
328         emit Transfer(owner, newOwner, token_amount);
329 
330         // change owner
331         _transferOwnership(newOwner);
332 
333     }
334 
335 
336     function () payable onlyWhitelist public {
337 
338         require(!crowdsaleClosed);
339         uint amount = msg.value;
340         require(amount.div(price) > 0);
341         uint token_amount = (amount.div(price))*10**18;
342 
343         amountRaised = amountRaised.add(amount);
344 
345         balances[owner] = balances[owner].sub(token_amount);
346         balances[msg.sender] = balances[msg.sender].add(token_amount);
347         emit Transfer(owner, msg.sender, token_amount);
348 
349     }
350 
351 
352 }