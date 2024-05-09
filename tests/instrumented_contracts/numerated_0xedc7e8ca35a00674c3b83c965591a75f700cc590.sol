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
69 contract Extradecoin is Owner {
70     using SafeMath for uint256;
71 
72     string public constant name = "EXTRADECOIN";
73     string public constant symbol = "ETE";
74     uint public constant decimals = 18;
75     uint256 constant public totalSupply = 250000000 * 10 ** 18; // 250 mil tokens will be supplied
76   
77     mapping(address => uint256) internal balances;
78     mapping(address => mapping (address => uint256)) internal allowed;
79 
80     address public adminAddress;
81     address public walletAddress;
82     address public founderAddress;
83     address public advisorAddress;
84     
85     mapping(address => uint256) public totalInvestedAmountOf;
86 
87     uint constant lockPeriod1 = 3 years; // 1st locked period for tokens allocation of founder and team
88     uint constant lockPeriod2 = 1 years; // 2nd locked period for tokens allocation of founder and team
89     uint constant lockPeriod3 = 90 days; // 3nd locked period for tokens allocation of advisor and ICO partners
90    
91     uint constant NOT_SALE = 0; // Not in sales
92     uint constant IN_ICO = 1; // In ICO
93     uint constant END_SALE = 2; // End sales
94 
95     uint256 public constant salesAllocation = 125000000 * 10 ** 18; // 125 mil tokens allocated for sales
96     uint256 public constant founderAllocation = 37500000 * 10 ** 18; // 37.5 mil tokens allocated for founders
97     uint256 public constant advisorAllocation = 25000000 * 10 ** 18; // 25 mil tokens allocated for allocated for ICO partners and bonus fund
98     uint256 public constant reservedAllocation = 62500000 * 10 ** 18; // 62.5 mil tokens allocated for reserved, bounty campaigns, ICO partners, and bonus fund
99     uint256 public constant minInvestedCap = 6000 * 10 ** 18; // 2500 ether for softcap 
100     uint256 public constant minInvestedAmount = 0.1 * 10 ** 18; // 0.1 ether for mininum ether contribution per transaction
101     
102     uint saleState;
103     uint256 totalInvestedAmount;
104     uint public icoStartTime;
105     uint public icoEndTime;
106     bool public inActive;
107     bool public isSelling;
108     bool public isTransferable;
109     uint public founderAllocatedTime = 1;
110     uint public advisorAllocatedTime = 1;
111     uint256 public icoStandardPrice;
112     
113     uint256 public totalRemainingTokensForSales; // Total tokens remaining for sales
114     uint256 public totalAdvisor; // Total tokens allocated for advisor
115     uint256 public totalReservedTokenAllocation; // Total tokens allocated for reserved
116 
117     event Approval(address indexed owner, address indexed spender, uint256 value); // ERC20 standard event
118     event Transfer(address indexed from, address indexed to, uint256 value); // ERC20 standard event
119 
120     event StartICO(uint state); // Start ICO sales
121     event EndICO(uint state); // End ICO sales
122     
123     event SetICOPrice(uint256 price); // Set ICO standard price
124     
125     event IssueTokens(address investorAddress, uint256 amount, uint256 tokenAmount, uint state); // Issue tokens to investor
126     event AllocateTokensForFounder(address founderAddress, uint256 founderAllocatedTime, uint256 tokenAmount); // Allocate tokens to founders' address
127     event AllocateTokensForAdvisor(address advisorAddress, uint256 advisorAllocatedTime, uint256 tokenAmount); // Allocate tokens to advisor address
128     event AllocateReservedTokens(address reservedAddress, uint256 tokenAmount); // Allocate reserved tokens
129     event AllocateSalesTokens(address salesAllocation, uint256 tokenAmount); // Allocate sales tokens
130 
131 
132     modifier isActive() {
133         require(inActive == false);
134         _;
135     }
136 
137     modifier isInSale() {
138         require(isSelling == true);
139         _;
140     }
141 
142     modifier transferable() {
143         require(isTransferable == true);
144         _;
145     }
146 
147     modifier onlyOwnerOrAdminOrPortal() {
148         require(msg.sender == owner || msg.sender == adminAddress);
149         _;
150     }
151 
152     modifier onlyOwnerOrAdmin() {
153         require(msg.sender == owner || msg.sender == adminAddress);
154         _;
155     }
156 
157     function Extradecoin(address _walletAddr, address _adminAddr) public Owner(msg.sender) {
158         require(_walletAddr != address(0));
159         require(_adminAddr != address(0));
160 		
161         walletAddress = _walletAddr;
162         adminAddress = _adminAddr;
163         inActive = true;
164         totalInvestedAmount = 0;
165         totalRemainingTokensForSales = salesAllocation;
166         totalAdvisor = advisorAllocation;
167         totalReservedTokenAllocation = reservedAllocation;
168     }
169     
170     // Fallback function for token purchasing  
171     function () external payable isActive isInSale {
172         uint state = getCurrentState();
173         require(state == IN_ICO);
174         require(msg.value >= minInvestedAmount);
175         
176         if (state == IN_ICO) {
177             return issueTokensForICO(state);
178         }
179         revert();
180     }
181 
182     // ERC20 standard function
183     function transfer(address _to, uint256 _value) external transferable returns (bool) {
184         require(_to != address(0));
185         require(_value > 0);
186 
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         emit Transfer(msg.sender, _to, _value);
190         return true;
191     }
192 
193     // ERC20 standard function
194     function transferFrom(address _from, address _to, uint256 _value) external transferable returns (bool) {
195         require(_to != address(0));
196         require(_from != address(0));
197         require(_value > 0);
198 
199         balances[_from] = balances[_from].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202         emit Transfer(_from, _to, _value);
203         return true;
204     }
205 
206     // ERC20 standard function
207     function approve(address _spender, uint256 _value) external transferable returns (bool) {
208         require(_spender != address(0));
209         require(_value > 0);
210 		
211         allowed[msg.sender][_spender] = _value;
212         emit Approval(msg.sender, _spender, _value);
213         return true;
214     }
215 
216 
217     // Start ICO
218     function startICO() external isActive onlyOwnerOrAdmin returns (bool) {
219         saleState = IN_ICO;
220         icoStartTime = now;
221         isSelling = true;
222         emit StartICO(saleState);
223         return true;
224     }
225 
226     // End ICO
227     function endICO() external isActive onlyOwnerOrAdmin returns (bool) {
228         require(icoEndTime == 0);
229         saleState = END_SALE;
230         isSelling = false;
231         icoEndTime = now;
232         emit EndICO(saleState);
233         return true;
234     }
235     
236     // Set ICO price including ICO standard price, ICO 1st round price, ICO 2nd round price
237     function setICOPrice(uint256 _tokenPerEther) external onlyOwnerOrAdmin returns(bool) {
238         require(_tokenPerEther > 0);
239 		
240         icoStandardPrice = _tokenPerEther;
241         emit SetICOPrice(icoStandardPrice);
242         
243         return true;
244     }
245 
246     // Activate token sale function
247     function activate() external onlyOwner {
248         inActive = false;
249     }
250 
251     // Deacivate token sale function
252     function deActivate() external onlyOwner {
253         inActive = true;
254     }
255 
256     // Enable transfer feature of tokens
257     function enableTokenTransfer() external isActive onlyOwner {
258         isTransferable = true;
259     }
260 
261     // Modify wallet
262     function changeWallet(address _newAddress) external onlyOwner {
263         require(_newAddress != address(0));
264         require(walletAddress != _newAddress);
265         walletAddress = _newAddress;
266     }
267 
268     // Modify admin
269     function changeAdminAddress(address _newAddress) external onlyOwner {
270         require(_newAddress != address(0));
271         require(adminAddress != _newAddress);
272         adminAddress = _newAddress;
273     }
274   
275     // Modify founder address to receive founder tokens allocation
276     function changeFounderAddress(address _newAddress) external onlyOwnerOrAdmin {
277         require(_newAddress != address(0));
278         require(founderAddress != _newAddress);
279         founderAddress = _newAddress;
280     }
281 
282     // Modify team address to receive team tokens allocation
283     function changeTeamAddress(address _newAddress) external onlyOwnerOrAdmin {
284         require(_newAddress != address(0));
285         require(advisorAddress != _newAddress);
286         advisorAddress = _newAddress;
287     }
288 
289     // Allocate tokens for founder vested gradually for 4 year
290     function allocateTokensForFounder() external isActive onlyOwnerOrAdmin {
291         require(saleState == END_SALE);
292         require(founderAddress != address(0));
293         uint256 amount;
294         if (founderAllocatedTime == 1) {
295             require(now >= icoEndTime + lockPeriod1);
296             amount = founderAllocation * 50/100;
297             balances[founderAddress] = balances[founderAddress].add(amount);
298             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
299             founderAllocatedTime = 2;
300             return;
301         }
302         if (founderAllocatedTime == 2) {
303             require(now >= icoEndTime + lockPeriod2);
304             amount = founderAllocation * 50/100;
305             balances[founderAddress] = balances[founderAddress].add(amount);
306             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
307             founderAllocatedTime = 3;
308             return;
309         }
310         revert();
311     }
312     
313 
314     // Allocate tokens for advisor and angel investors vested gradually for 1 year
315     function allocateTokensForAdvisor() external isActive onlyOwnerOrAdmin {
316         require(saleState == END_SALE);
317         require(advisorAddress != address(0));
318         uint256 amount;
319         if (advisorAllocatedTime == 1) {
320             amount = advisorAllocation * 50/100;
321             balances[advisorAddress] = balances[advisorAddress].add(amount);
322             emit AllocateTokensForFounder(advisorAddress, founderAllocatedTime, amount);
323             founderAllocatedTime = 2;
324             return;
325         }
326         if (advisorAllocatedTime == 2) {
327             require(now >= icoEndTime + lockPeriod2);
328             amount = advisorAllocation * 125/1000;
329             balances[advisorAddress] = balances[advisorAddress].add(amount);
330             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
331             advisorAllocatedTime = 3;
332             return;
333         }
334         if (advisorAllocatedTime == 3) {
335             require(now >= icoEndTime + lockPeriod3);
336             amount = advisorAllocation * 125/1000;
337             balances[advisorAddress] = balances[advisorAddress].add(amount);
338             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
339             advisorAllocatedTime = 4;
340             return;
341         }
342         if (advisorAllocatedTime == 4) {
343             require(now >= icoEndTime + lockPeriod3);
344             amount = advisorAllocation * 125/1000;
345             balances[advisorAddress] = balances[advisorAddress].add(amount);
346             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
347             advisorAllocatedTime = 5;
348             return;
349         }
350         if (advisorAllocatedTime == 5) {
351             require(now >= icoEndTime + lockPeriod3);
352             amount = advisorAllocation * 125/1000;
353             balances[advisorAddress] = balances[advisorAddress].add(amount);
354             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
355             advisorAllocatedTime = 6;
356             return;
357         }
358         revert();
359     }
360     
361     // Allocate reserved tokens
362     function allocateReservedTokens(address _addr, uint _amount) external isActive onlyOwnerOrAdmin {
363         require(_amount > 0);
364         require(_addr != address(0));
365 		
366         balances[_addr] = balances[_addr].add(_amount);
367         totalReservedTokenAllocation = totalReservedTokenAllocation.sub(_amount);
368         emit AllocateReservedTokens(_addr, _amount);
369     }
370 
371    // Allocate sales tokens
372     function allocateSalesTokens(address _addr, uint _amount) external isActive onlyOwnerOrAdmin {
373         require(_amount > 0);
374         require(_addr != address(0));
375 		
376         balances[_addr] = balances[_addr].add(_amount);
377         totalRemainingTokensForSales = totalRemainingTokensForSales.sub(_amount);
378         emit AllocateSalesTokens(_addr, _amount);
379     }
380     // ERC20 standard function
381     function allowance(address _owner, address _spender) external constant returns (uint256) {
382         return allowed[_owner][_spender];
383     }
384     
385      // Issue tokens to normal investors through ICO rounds
386     function issueTokensForICO(uint _state) private {
387         uint256 price = icoStandardPrice;
388         issueTokens(price, _state);
389     }
390     
391     // Issue tokens to investors and transfer ether to wallet
392     function issueTokens(uint256 _price, uint _state) private {
393         require(walletAddress != address(0));
394 		
395         uint tokenAmount = msg.value.mul(_price).mul(10**18).div(1 ether);
396         totalInvestedAmount = totalInvestedAmount.add(msg.value);
397         walletAddress.transfer(msg.value);
398         emit IssueTokens(msg.sender, msg.value, tokenAmount, _state);
399     }
400 
401     // ERC20 standard function
402     function balanceOf(address _owner) external constant returns (uint256 balance) {
403         return balances[_owner];
404     }
405     
406      // Get current sales state
407     function getCurrentState() public view returns(uint256) {
408         return saleState;
409     }
410     // Get softcap reaching status
411     function isSoftCapReached() public view returns (bool) {
412         return totalInvestedAmount >= minInvestedCap;
413     }
414 }