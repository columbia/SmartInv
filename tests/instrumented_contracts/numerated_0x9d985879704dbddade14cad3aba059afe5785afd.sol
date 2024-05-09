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
111     
112     uint256 public totalRemainingTokensForSales; // Total tokens remaining for sales
113     uint256 public totalAdvisor; // Total tokens allocated for advisor
114     uint256 public totalReservedTokenAllocation; // Total tokens allocated for reserved
115 
116     event Approval(address indexed owner, address indexed spender, uint256 value); // ERC20 standard event
117     event Transfer(address indexed from, address indexed to, uint256 value); // ERC20 standard event
118 
119     event StartICO(uint state); // Start ICO sales
120     event EndICO(uint state); // End ICO sales
121     
122     
123     event AllocateTokensForFounder(address founderAddress, uint256 founderAllocatedTime, uint256 tokenAmount); // Allocate tokens to founders' address
124     event AllocateTokensForAdvisor(address advisorAddress, uint256 advisorAllocatedTime, uint256 tokenAmount); // Allocate tokens to advisor address
125     event AllocateReservedTokens(address reservedAddress, uint256 tokenAmount); // Allocate reserved tokens
126     event AllocateSalesTokens(address salesAllocation, uint256 tokenAmount); // Allocate sales tokens
127 
128 
129     modifier isActive() {
130         require(inActive == false);
131         _;
132     }
133 
134     modifier isInSale() {
135         require(isSelling == true);
136         _;
137     }
138 
139     modifier transferable() {
140         require(isTransferable == true);
141         _;
142     }
143 
144     modifier onlyOwnerOrAdminOrPortal() {
145         require(msg.sender == owner || msg.sender == adminAddress);
146         _;
147     }
148 
149     modifier onlyOwnerOrAdmin() {
150         require(msg.sender == owner || msg.sender == adminAddress);
151         _;
152     }
153 
154     function Extradecoin(address _walletAddr, address _adminAddr) public Owner(msg.sender) {
155         require(_walletAddr != address(0));
156         require(_adminAddr != address(0));
157 		
158         walletAddress = _walletAddr;
159         adminAddress = _adminAddr;
160         inActive = true;
161         totalInvestedAmount = 0;
162         totalRemainingTokensForSales = salesAllocation;
163         totalAdvisor = advisorAllocation;
164         totalReservedTokenAllocation = reservedAllocation;
165     }
166 
167     // ERC20 standard function
168     function transfer(address _to, uint256 _value) external transferable returns (bool) {
169         require(_to != address(0));
170         require(_value > 0);
171 
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         emit Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     // ERC20 standard function
179     function transferFrom(address _from, address _to, uint256 _value) external transferable returns (bool) {
180         require(_to != address(0));
181         require(_from != address(0));
182         require(_value > 0);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         emit Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     // ERC20 standard function
192     function approve(address _spender, uint256 _value) external transferable returns (bool) {
193         require(_spender != address(0));
194         require(_value > 0);
195 		
196         allowed[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201 
202     // Start ICO
203     function startICO() external isActive onlyOwnerOrAdmin returns (bool) {
204         saleState = IN_ICO;
205         icoStartTime = now;
206         isSelling = true;
207         emit StartICO(saleState);
208         return true;
209     }
210 
211     // End ICO
212     function endICO() external isActive onlyOwnerOrAdmin returns (bool) {
213         require(icoEndTime == 0);
214         saleState = END_SALE;
215         isSelling = false;
216         icoEndTime = now;
217         emit EndICO(saleState);
218         return true;
219     }
220 
221     // Activate token sale function
222     function activate() external onlyOwner {
223         inActive = false;
224     }
225 
226     // Deacivate token sale function
227     function deActivate() external onlyOwner {
228         inActive = true;
229     }
230 
231     // Enable transfer feature of tokens
232     function enableTokenTransfer() external isActive onlyOwner {
233         isTransferable = true;
234     }
235 
236     // Modify wallet
237     function changeWallet(address _newAddress) external onlyOwner {
238         require(_newAddress != address(0));
239         require(walletAddress != _newAddress);
240         walletAddress = _newAddress;
241     }
242 
243     // Modify admin
244     function changeAdminAddress(address _newAddress) external onlyOwner {
245         require(_newAddress != address(0));
246         require(adminAddress != _newAddress);
247         adminAddress = _newAddress;
248     }
249   
250     // Modify founder address to receive founder tokens allocation
251     function changeFounderAddress(address _newAddress) external onlyOwnerOrAdmin {
252         require(_newAddress != address(0));
253         require(founderAddress != _newAddress);
254         founderAddress = _newAddress;
255     }
256 
257     // Modify team address to receive team tokens allocation
258     function changeTeamAddress(address _newAddress) external onlyOwnerOrAdmin {
259         require(_newAddress != address(0));
260         require(advisorAddress != _newAddress);
261         advisorAddress = _newAddress;
262     }
263 
264     // Allocate tokens for founder vested gradually for 4 year
265     function allocateTokensForFounder() external isActive onlyOwnerOrAdmin {
266         require(saleState == END_SALE);
267         require(founderAddress != address(0));
268         uint256 amount;
269         if (founderAllocatedTime == 1) {
270             require(now >= icoEndTime + lockPeriod1);
271             amount = founderAllocation * 50/100;
272             balances[founderAddress] = balances[founderAddress].add(amount);
273             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
274             founderAllocatedTime = 2;
275             return;
276         }
277         if (founderAllocatedTime == 2) {
278             require(now >= icoEndTime + lockPeriod2);
279             amount = founderAllocation * 50/100;
280             balances[founderAddress] = balances[founderAddress].add(amount);
281             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
282             founderAllocatedTime = 3;
283             return;
284         }
285         revert();
286     }
287     
288 
289     // Allocate tokens for advisor and angel investors vested gradually for 1 year
290     function allocateTokensForAdvisor() external isActive onlyOwnerOrAdmin {
291         require(saleState == END_SALE);
292         require(advisorAddress != address(0));
293         uint256 amount;
294         if (founderAllocatedTime == 1) {
295             amount = advisorAllocation * 50/100;
296             balances[advisorAddress] = balances[advisorAddress].add(amount);
297             emit AllocateTokensForFounder(advisorAddress, founderAllocatedTime, amount);
298             founderAllocatedTime = 2;
299             return;
300         }
301         if (advisorAllocatedTime == 2) {
302             require(now >= icoEndTime + lockPeriod2);
303             amount = advisorAllocation * 125/1000;
304             balances[advisorAddress] = balances[advisorAddress].add(amount);
305             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
306             advisorAllocatedTime = 3;
307             return;
308         }
309         if (advisorAllocatedTime == 3) {
310             require(now >= icoEndTime + lockPeriod3);
311             amount = advisorAllocation * 125/1000;
312             balances[advisorAddress] = balances[advisorAddress].add(amount);
313             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
314             advisorAllocatedTime = 4;
315             return;
316         }
317         if (advisorAllocatedTime == 4) {
318             require(now >= icoEndTime + lockPeriod3);
319             amount = advisorAllocation * 125/1000;
320             balances[advisorAddress] = balances[advisorAddress].add(amount);
321             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
322             advisorAllocatedTime = 5;
323             return;
324         }
325         if (advisorAllocatedTime == 5) {
326             require(now >= icoEndTime + lockPeriod3);
327             amount = advisorAllocation * 125/1000;
328             balances[advisorAddress] = balances[advisorAddress].add(amount);
329             emit AllocateTokensForAdvisor(advisorAddress, advisorAllocatedTime, amount);
330             advisorAllocatedTime = 6;
331             return;
332         }
333         revert();
334     }
335     
336     // Allocate reserved tokens
337     function allocateReservedTokens(address _addr, uint _amount) external isActive onlyOwnerOrAdmin {
338         require(saleState == END_SALE);
339         require(_amount > 0);
340         require(_addr != address(0));
341 		
342         balances[_addr] = balances[_addr].add(_amount);
343         totalReservedTokenAllocation = totalReservedTokenAllocation.sub(_amount);
344         emit AllocateReservedTokens(_addr, _amount);
345     }
346 
347    // Allocate sales tokens
348     function allocateSalesTokens(address _addr, uint _amount) external isActive onlyOwnerOrAdmin {
349         require(_amount > 0);
350         require(_addr != address(0));
351 		
352         balances[_addr] = balances[_addr].add(_amount);
353         totalRemainingTokensForSales = totalRemainingTokensForSales.sub(_amount);
354         emit AllocateSalesTokens(_addr, _amount);
355     }
356     // ERC20 standard function
357     function allowance(address _owner, address _spender) external constant returns (uint256) {
358         return allowed[_owner][_spender];
359     }
360 
361     // ERC20 standard function
362     function balanceOf(address _owner) external constant returns (uint256 balance) {
363         return balances[_owner];
364     }
365 
366     // Get softcap reaching status
367     function isSoftCapReached() public view returns (bool) {
368         return totalInvestedAmount >= minInvestedCap;
369     }
370 }