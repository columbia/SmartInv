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
50     mapping(address => uint) maxInvestLimitList;
51 
52     uint256 _totalHolders; // you should initialize this to 0 in the constructor
53 
54     function enableWhitelist(address[] _addresses) public returns (bool success);
55     function setMaximumInvest(address _address, uint _amount) public returns (bool success);
56 
57     modifier onlyWhitelist() {
58         require(whitelist[msg.sender] == 2);
59         _;
60     }
61 
62 
63 
64 
65 }
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     /**
85       * @dev Allows the current owner to transfer control of the contract to a newOwner.
86       * @param newOwner The address to transfer ownership to.
87       */
88     // function transferOwnership(address newOwner) public onlyOwner {
89     //     _transferOwnership(newOwner);
90     // }
91 
92     /**
93      * @dev Transfers control of the contract to a newOwner.
94      * @param newOwner The address to transfer ownership to.
95      */
96     function _transferOwnership(address newOwner) internal {
97         require(newOwner != address(0));
98         emit OwnershipTransferred(owner, newOwner);
99         owner = newOwner;
100     }
101 
102 }
103 
104 contract TokenTemplate is ERC20Interface, CrowdsaleInterface, Owned {
105     using SafeMath for uint;
106 
107     bytes32 public symbol;
108     uint public priceRate;
109     uint public minimumInvest;
110     bytes32 public  name;
111     uint8 public decimals;
112     uint _totalSupply;
113     uint amountRaised;
114 
115     mapping(address => uint) balances;
116     mapping(address => mapping(address => uint)) allowed;
117 
118 
119     // ------------------------------------------------------------------------
120     // Constructor
121     // ------------------------------------------------------------------------
122     constructor(bytes32 _name, bytes32 _symbol, uint _total, uint _weiCostOfEachToken, uint _weiMinimumInvest) public {
123         symbol = _symbol;
124         name = _name;
125         decimals = 18;
126         priceRate= _weiCostOfEachToken;
127         minimumInvest= _weiMinimumInvest;
128         _totalSupply = _total * 10**uint(decimals);
129 
130         _totalHolders = 0;
131 
132         balances[owner] = _totalSupply;
133         holders[_totalHolders] = owner;
134         whitelist[owner] = 2;
135         maxInvestLimitList[owner] = 0;
136         _totalHolders++;
137 
138 
139         emit Transfer(address(0), owner, _totalSupply);
140 
141 
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Total supply
147     // ------------------------------------------------------------------------
148     function totalSupply() public view returns (uint) {
149         return _totalSupply.sub(balances[address(0)]);
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Get the token balance for account `tokenOwner`
155     // ------------------------------------------------------------------------
156     function balanceOf(address tokenOwner) public view returns (uint balance) {
157         return balances[tokenOwner];
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer the balance from token owner's account to `to` account
163     // - Owner's account must have sufficient balance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transfer(address to, uint tokens) onlyWhitelist public returns (bool success) {
167         balances[msg.sender] = balances[msg.sender].sub(tokens);
168         balances[to] = balances[to].add(tokens);
169         emit Transfer(msg.sender, to, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account
177     //
178     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
179     // recommends that there are no checks for the approval double-spend attack
180     // as this should be implemented in user interfaces
181     // ------------------------------------------------------------------------
182     function approve(address spender, uint tokens) onlyWhitelist public returns (bool success) {
183         allowed[msg.sender][spender] = tokens;
184         emit Approval(msg.sender, spender, tokens);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Transfer `tokens` from the `from` account to the `to` account
191     //
192     // The calling account must already have sufficient tokens approve(...)-d
193     // for spending from the `from` account and
194     // - From account must have sufficient balance to transfer
195     // - Spender must have sufficient allowance to transfer
196     // - 0 value transfers are allowed
197     // ------------------------------------------------------------------------
198     function transferFrom(address from, address to, uint tokens) onlyWhitelist public returns (bool success) {
199         balances[from] = balances[from].sub(tokens);
200         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
201         balances[to] = balances[to].add(tokens);
202         emit Transfer(from, to, tokens);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Returns the amount of tokens approved by the owner that can be
209     // transferred to the spender's account
210     // ------------------------------------------------------------------------
211     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
212         return allowed[tokenOwner][spender];
213     }
214 
215     function enableWhitelist(address[] _addresses) public onlyOwner returns (bool success) {
216         for (uint i = 0; i < _addresses.length; i++) {
217             _addWalletToWhitelist(_addresses[i]);
218         }
219         return true;
220     }
221     function _addWalletToWhitelist(address addr) internal {
222         if (whitelist[addr] == 2) {
223         } else if (whitelist[addr] == 1) {
224             whitelist[addr] = 2;
225         } else {
226             whitelist[addr] = 2;
227             holders[_totalHolders] = addr;
228             maxInvestLimitList[addr] = 0;
229             _totalHolders++;
230         }
231     }
232 
233     function disableWhitelist(address[] _addresses) public onlyOwner returns (bool success) {
234         for (uint i = 0; i < _addresses.length; i++) {
235             _disableWhitelist(_addresses[i]);
236         }
237         return true;
238     }
239 
240     function _disableWhitelist(address addr) internal {
241         if (whitelist[addr] == 2) {
242             whitelist[addr] = 1;
243         } else {
244         }
245     }
246 
247     function getWhitelist() public view returns (address[] addresses) {
248 
249         uint256 j;
250         uint256 count = 0;
251 
252         for (j=0; j<_totalHolders; j++) {
253             if (whitelist[holders[j]] == 2) {
254                 count = count+1;
255             } else {
256             }
257         }
258         address[] memory wlist = new address[](count);
259 
260         for (j=0; j<count; j++) {
261             if (whitelist[holders[j]] == 2) {
262                 wlist[j] = holders[j];
263             } else {
264             }
265         }
266         return wlist;
267     }
268 
269     function getBalances() public view returns (address[] _addresses, uint256[] _balances) {
270         address[] memory wlist1 = new address[](_totalHolders);
271         uint256[] memory wlist2 = new uint256[](_totalHolders);
272 
273         for (uint256 j=0; j<_totalHolders; j++) {
274             //////if (whitelist[holders[j]] == 2) {
275                 wlist1[j] = holders[j];
276                 wlist2[j] = balances[holders[j]];
277             //////}
278         }
279         return (wlist1,wlist2);
280     }
281 
282     function getBalancesAndMaxLimit() public view returns (address[] _addresses, uint256[] _balances, uint256[] _limits) {
283         address[] memory wlist1 = new address[](_totalHolders);
284         uint256[] memory wlist2 = new uint256[](_totalHolders);
285         uint256[] memory wlist3 = new uint256[](_totalHolders);
286 
287         for (uint256 j=0; j<_totalHolders; j++) {
288             //////if (whitelist[holders[j]] == 2) {
289                 wlist1[j] = holders[j];
290                 wlist2[j] = balances[holders[j]];
291                 wlist3[j] = maxInvestLimitList[holders[j]];
292             //////}
293         }
294         return (wlist1,wlist2,wlist3);
295     }
296 
297     function closeCrowdsale() public onlyOwner  {
298         crowdsaleClosed = true;
299     }
300 
301     function safeWithdrawal() public onlyOwner {
302         require(crowdsaleClosed);
303         require(!fundingGoalReached);
304 
305         if (msg.sender.send(amountRaised)) {
306             fundingGoalReached = true;
307         } else {
308             fundingGoalReached = false;
309         }
310 
311     }
312 
313     // immediate withdrawal withou funding goal reached and without crowdsale close
314     function immediateWithdrawal() public onlyOwner {
315         if (msg.sender.send(amountRaised)) {
316             //fundingGoalReached = true;
317             amountRaised = 0;
318         } else {
319             //fundingGoalReached = false;
320         }
321     }
322 
323     function burnTokens(uint token_amount) public onlyOwner {
324 
325         require(!crowdsaleClosed);
326         balances[owner] = balances[owner].sub(token_amount);
327         _totalSupply = _totalSupply.sub(token_amount);
328         emit Transfer(owner, address(0), token_amount);
329     }
330 
331     function mintTokens(uint token_amount) public onlyOwner {
332         require(!crowdsaleClosed);
333         _totalSupply = _totalSupply.add(token_amount);
334         balances[owner] = balances[owner].add(token_amount);
335         emit Transfer(address(0), owner, token_amount);
336     }
337 
338     function transferOwnership(address newOwner) public onlyOwner {
339 
340         require(!crowdsaleClosed);
341 
342         // enable newOwner to whitelist
343         _addWalletToWhitelist(newOwner);
344 
345         // puts unrealized tokens to new owner
346         uint token_amount = balances[owner];
347         balances[owner] = 0;
348         balances[newOwner] = balances[newOwner].add(token_amount);
349         emit Transfer(owner, newOwner, token_amount);
350 
351         // change owner
352         _transferOwnership(newOwner);
353 
354     }
355 
356     function setMaximumInvest(address _address, uint _amount) public onlyOwner returns (bool success) {
357         if (whitelist[_address] == 2) {
358             maxInvestLimitList[_address] = _amount;
359             return true;
360         } else {
361             return false;
362         }
363     }
364 
365     function setMinimumInvest(uint _weiMinimumInvest) public onlyOwner {
366         minimumInvest = _weiMinimumInvest;
367     }
368 
369     function setPriceRate(uint _weiCostOfEachToken) public onlyOwner {
370         priceRate = _weiCostOfEachToken;
371     }
372 
373     function () payable onlyWhitelist public {
374 
375         require(!crowdsaleClosed);
376         uint amount = msg.value;
377         require(amount >= minimumInvest);
378         require(amount.div(priceRate) > 0);
379         require( maxInvestLimitList[msg.sender]>=amount || maxInvestLimitList[msg.sender] == 0 );
380 
381         uint token_amount = (amount.div(priceRate))*10**18;
382 
383         amountRaised = amountRaised.add(amount);
384 
385         balances[owner] = balances[owner].sub(token_amount);
386         balances[msg.sender] = balances[msg.sender].add(token_amount);
387         emit Transfer(owner, msg.sender, token_amount);
388 
389     }
390 
391 
392 }