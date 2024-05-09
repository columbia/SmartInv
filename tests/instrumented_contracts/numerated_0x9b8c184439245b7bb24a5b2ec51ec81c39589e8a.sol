1 pragma solidity ^0.4.21;
2 
3 
4 contract Owner {
5     address public owner;
6 
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     function Owner(address _owner) public {
13         owner = _owner;
14     }
15 
16     function changeOwner(address _newOwnerAddr) public onlyOwner {
17         require(_newOwnerAddr != address(0));
18         owner = _newOwnerAddr;
19     }
20 }
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28     /**
29     * @dev Multiplies two numbers, throws on overflow.
30     */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         assert(c / a == b);
37         return c;
38     }
39 
40     /**
41     * @dev Integer division of two numbers, truncating the quotient.
42     */
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // assert(b > 0); // Solidity automatically throws when dividing by 0
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47         return c;
48     }
49 
50     /**
51     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52     */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         assert(b <= a);
55         return a - b;
56     }
57 
58     /**
59     * @dev Adds two numbers, throws on overflow.
60     */
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         assert(c >= a);
64         return c;
65     }
66 }
67 
68 
69 contract KIMEX is Owner {
70     using SafeMath for uint256;
71 
72     string public constant name = "KIMEX";
73     string public constant symbol = "KMX";
74     uint public constant decimals = 18;
75     uint256 constant public totalSupply = 250000000 * 10 ** 18; // 375 mil tokens will be supplied
76   
77     mapping(address => uint256) internal balances;
78     mapping(address => mapping (address => uint256)) internal allowed;
79 
80     address public adminAddress;
81     address public walletAddress;
82     address public founderAddress;
83     address public teamAddress;
84 
85     mapping(address => bool) public whiteList;
86     mapping(address => uint256) public totalInvestedAmountOf;
87 
88     uint constant lockPeriod1 = 1 years; // 1nd locked period for tokens allocation of founder and team
89    
90     uint constant NOT_SALE = 0; // Not in sales
91     uint constant IN_SALE = 1;  // In sales
92     uint constant END_SALE = 2; // End sales
93 
94     uint256 public constant salesAllocation = 150000000 * 10 ** 18; // 150 mil tokens allocated for sales
95     uint256 public constant reservedAllocation = 22500000 * 10 ** 18; // 22.5 mil tokens allocated for reserved, bounty campaigns, ICO partners, and bonus fund
96     uint256 public constant founderAllocation = 50000000 * 10 ** 18; // 50 mil tokens allocated for founders
97     uint256 public constant teamAllocation = 22500000 * 10 ** 18; // 22.5 mil tokens allocated for team
98     uint256 public constant minInvestedCap = 5000 * 10 ** 18; // 5000 ether for softcap 
99     uint256 public constant minInvestedAmount = 0.1 * 10 ** 18; // 0.1 ether for mininum ether contribution per transaction
100     
101     uint saleState;
102     uint256 totalInvestedAmount;
103     uint public icoStartTime;
104     uint public icoEndTime;
105     bool public inActive;
106     bool public isSelling;
107     bool public isTransferable;
108     uint public founderAllocatedTime = 1;
109     uint public teamAllocatedTime = 1;
110     uint256 public icoStandardPrice;
111  
112     uint256 public totalRemainingTokensForSales; // Total tokens remaining for sales
113     uint256 public totalReservedTokenAllocation; // Total tokens allocated for reserved and bonuses
114     uint256 public totalLoadedRefund; // Total ether will be loaded to contract for refund
115     uint256 public totalRefundedAmount; // Total ether refunded to investors
116 
117     event Approval(address indexed owner, address indexed spender, uint256 value); // ERC20 standard event
118     event Transfer(address indexed from, address indexed to, uint256 value); // ERC20 standard event
119 
120     event ModifyWhiteList(address investorAddress, bool isWhiteListed);  // Add or remove investor's address to or from white list
121     event StartICO(uint state); // Start ICO sales
122     event EndICO(uint state); // End ICO sales
123     
124     event SetICOPrice(uint256 price); // Set ICO standard price
125     
126     
127     event IssueTokens(address investorAddress, uint256 amount, uint256 tokenAmount, uint state); // Issue tokens to investor
128     event AllocateTokensForFounder(address founderAddress, uint256 founderAllocatedTime, uint256 tokenAmount); // Allocate tokens to founders' address
129     event AllocateTokensForTeam(address teamAddress, uint256 teamAllocatedTime, uint256 tokenAmount); // Allocate tokens to team's address
130     event AllocateReservedTokens(address reservedAddress, uint256 tokenAmount); // Allocate reserved tokens
131     event AllocateSalesTokens(address salesAllocation, uint256 tokenAmount); // Allocate sales tokens
132     
133 
134     modifier isActive() {
135         require(inActive == false);
136         _;
137     }
138 
139     modifier isInSale() {
140         require(isSelling == true);
141         _;
142     }
143 
144     modifier transferable() {
145         require(isTransferable == true);
146         _;
147     }
148 
149     modifier onlyOwnerOrAdminOrPortal() {
150         require(msg.sender == owner || msg.sender == adminAddress);
151         _;
152     }
153 
154     modifier onlyOwnerOrAdmin() {
155         require(msg.sender == owner || msg.sender == adminAddress);
156         _;
157     }
158 
159     function KIMEX(address _walletAddr, address _adminAddr) public Owner(msg.sender) {
160         require(_walletAddr != address(0));
161         require(_adminAddr != address(0));
162 		
163         walletAddress = _walletAddr;
164         adminAddress = _adminAddr;
165         inActive = true;
166         totalInvestedAmount = 0;
167         totalRemainingTokensForSales = salesAllocation;
168         totalReservedTokenAllocation = reservedAllocation;
169     }
170 
171     // Fallback function for token purchasing  
172     function () external payable isActive isInSale {
173         uint state = getCurrentState();
174         require(state < END_SALE);
175         require(msg.value >= minInvestedAmount);
176        
177         if (state <= IN_SALE) {
178             return issueTokensForICO(state);
179         }
180         revert();
181     }
182 
183     // Load ether amount to contract for refunding or revoking
184     function loadFund() external payable {
185         require(msg.value > 0);
186 		
187         totalLoadedRefund = totalLoadedRefund.add(msg.value);
188     }
189 
190     // ERC20 standard function
191     function transfer(address _to, uint256 _value) external transferable returns (bool) {
192         require(_to != address(0));
193         require(_value > 0);
194 
195         balances[msg.sender] = balances[msg.sender].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         emit Transfer(msg.sender, _to, _value);
198         return true;
199     }
200 
201     // ERC20 standard function
202     function transferFrom(address _from, address _to, uint256 _value) external transferable returns (bool) {
203         require(_to != address(0));
204         require(_from != address(0));
205         require(_value > 0);
206 
207         balances[_from] = balances[_from].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210         emit Transfer(_from, _to, _value);
211         return true;
212     }
213 
214     // ERC20 standard function
215     function approve(address _spender, uint256 _value) external transferable returns (bool) {
216         require(_spender != address(0));
217         require(_value > 0);
218 		
219         allowed[msg.sender][_spender] = _value;
220         emit Approval(msg.sender, _spender, _value);
221         return true;
222     }
223 
224     // Modify white list
225     function modifyWhiteList(address[] _investorAddrs, bool _isWhiteListed) external isActive onlyOwnerOrAdminOrPortal returns(bool) {
226         for (uint256 i = 0; i < _investorAddrs.length; i++) {
227             whiteList[_investorAddrs[i]] = _isWhiteListed;
228             emit ModifyWhiteList(_investorAddrs[i], _isWhiteListed);
229         }
230         return true;
231     }
232 
233     // Start ICO
234     function startICO() external isActive onlyOwnerOrAdmin returns (bool) {
235         require(icoStandardPrice > 0);
236         saleState = IN_SALE;
237         icoStartTime = now;
238         isSelling = true;
239         emit StartICO(saleState);
240         return true;
241     }
242 
243     // End ICO
244     function endICO() external isActive onlyOwnerOrAdmin returns (bool) {
245         require(icoEndTime == 0);
246 		
247         saleState = END_SALE;
248         isSelling = false;
249         icoEndTime = now;
250         emit EndICO(saleState);
251         return true;
252     }
253     
254     // Set ICO price including ICO standard price
255     function setICOPrice(uint256 _tokenPerEther) external onlyOwnerOrAdmin returns(bool) {
256         require(_tokenPerEther > 0);
257     		
258         icoStandardPrice = _tokenPerEther;
259         emit SetICOPrice(icoStandardPrice);
260         return true;
261     }
262     // Activate token sale function
263     function activate() external onlyOwner {
264         inActive = false;
265     }
266 
267     // Deacivate token sale function
268     function deActivate() external onlyOwner {
269         inActive = true;
270     }
271 
272     // Enable transfer feature of tokens
273     function enableTokenTransfer() external isActive onlyOwner {
274         isTransferable = true;
275     }
276 
277     // Modify wallet
278     function changeWallet(address _newAddress) external onlyOwner {
279         require(_newAddress != address(0));
280         require(walletAddress != _newAddress);
281         walletAddress = _newAddress;
282     }
283 
284     // Modify admin
285     function changeAdminAddress(address _newAddress) external onlyOwner {
286         require(_newAddress != address(0));
287         require(adminAddress != _newAddress);
288         adminAddress = _newAddress;
289     }
290   
291     // Modify founder address to receive founder tokens allocation
292     function changeFounderAddress(address _newAddress) external onlyOwnerOrAdmin {
293         require(_newAddress != address(0));
294         require(founderAddress != _newAddress);
295         founderAddress = _newAddress;
296     }
297 
298     // Modify team address to receive team tokens allocation
299     function changeTeamAddress(address _newAddress) external onlyOwnerOrAdmin {
300         require(_newAddress != address(0));
301         require(teamAddress != _newAddress);
302         teamAddress = _newAddress;
303     }
304 
305     // Allocate tokens for founder vested gradually for 1 year
306     function allocateTokensForFounder() external isActive onlyOwnerOrAdmin {
307         require(saleState == END_SALE);
308         require(founderAddress != address(0));
309         uint256 amount;
310         if (founderAllocatedTime == 1) {
311             amount = founderAllocation;
312             balances[founderAddress] = balances[founderAddress].add(amount);
313             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
314             founderAllocatedTime = 2;
315             return;
316         }
317         revert();
318     }
319 
320     // Allocate tokens for team vested gradually for 1 year
321     function allocateTokensForTeam() external isActive onlyOwnerOrAdmin {
322         require(saleState == END_SALE);
323         require(teamAddress != address(0));
324         uint256 amount;
325         if (teamAllocatedTime == 1) {
326             amount = teamAllocation * 40/100;
327             balances[teamAddress] = balances[teamAddress].add(amount);
328             emit AllocateTokensForTeam(teamAddress, teamAllocatedTime, amount);
329             teamAllocatedTime = 2;
330             return;
331         }
332         if (teamAllocatedTime == 2) {
333             require(now >= icoEndTime + lockPeriod1);
334             amount = teamAllocation * 60/100;
335             balances[teamAddress] = balances[teamAddress].add(amount);
336             emit AllocateTokensForTeam(teamAddress, teamAllocatedTime, amount);
337             teamAllocatedTime = 3;
338             return;
339         }
340         revert();
341     }
342 
343     // Allocate reserved tokens
344     function allocateReservedTokens(address _addr, uint _amount) external isActive onlyOwnerOrAdmin {
345         require(_amount > 0);
346         require(_addr != address(0));
347 		
348         balances[_addr] = balances[_addr].add(_amount);
349         totalReservedTokenAllocation = totalReservedTokenAllocation.sub(_amount);
350         emit AllocateReservedTokens(_addr, _amount);
351     }
352     
353     // Allocate sales tokens
354     function allocateSalesTokens(address _addr, uint _amount) external isActive onlyOwnerOrAdmin {
355         require(_amount > 0);
356         require(_addr != address(0));
357 		
358         balances[_addr] = balances[_addr].add(_amount);
359         totalRemainingTokensForSales = totalRemainingTokensForSales.sub(_amount);
360         emit AllocateSalesTokens(_addr, _amount);
361     }
362 
363     // ERC20 standard function
364     function allowance(address _owner, address _spender) external constant returns (uint256) {
365         return allowed[_owner][_spender];
366     }
367 
368     // ERC20 standard function
369     function balanceOf(address _owner) external constant returns (uint256 balance) {
370         return balances[_owner];
371     }
372 
373     // Get current sales state
374     function getCurrentState() public view returns(uint256) {
375         return saleState;
376     }
377 
378     // Get softcap reaching status
379     function isSoftCapReached() public view returns (bool) {
380         return totalInvestedAmount >= minInvestedCap;
381     }
382     
383      // Issue tokens to normal investors through ICO rounds
384     function issueTokensForICO(uint _state) private {
385         uint256 price = icoStandardPrice;
386         issueTokens(price, _state);
387     }
388 
389     // Issue tokens to investors and transfer ether to wallet
390     function issueTokens(uint256 _price, uint _state) private {
391         require(walletAddress != address(0));
392 		
393         uint tokenAmount = msg.value.mul(_price).mul(10**18).div(1 ether);
394         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
395         totalInvestedAmountOf[msg.sender] = totalInvestedAmountOf[msg.sender].add(msg.value);
396         totalRemainingTokensForSales = totalRemainingTokensForSales.sub(tokenAmount);
397         totalInvestedAmount = totalInvestedAmount.add(msg.value);
398         walletAddress.transfer(msg.value);
399         emit IssueTokens(msg.sender, msg.value, tokenAmount, _state);
400     }
401 }