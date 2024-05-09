1 pragma solidity 0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/20
39  */
40 contract ERC20 {
41     string public name;
42     string public symbol;
43     uint8 public decimals;
44 	uint256 public totalSupply;
45 
46     function balanceOf(address who) public constant returns (uint256);
47     function transfer(address to, uint256 value) public returns (bool);
48     function allowance(address owner, address spender) public constant returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function approve(address spender, uint256 value) public returns (bool);
51     
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address public owner;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 }
92 
93 contract Token is Ownable {
94     using SafeMath for uint;
95 
96     string public name = "Invox";
97     string public symbol = "INVOX";
98     uint8 public decimals = 18;
99     uint256 public totalSupply = 0;
100 
101     address private owner;
102 
103     address internal constant FOUNDERS = 0x16368c58BDb7444C8b97cC91172315D99fB8dc81;
104     address internal constant OPERATIONAL_FUND = 0xc97E0F6AcCB18e3B3703c85c205509d02700aCAa;
105 
106     uint256 private constant MAY_15_2018 = 1526342400;
107 
108     mapping (address => uint256) balances;
109     mapping (address => mapping (address => uint256)) allowed;
110 
111     function Token () public {
112         balances[msg.sender] = 0;
113     }
114 
115     function balanceOf(address who) public constant returns (uint256) {
116         return balances[who];
117     }
118 
119     function transfer(address to, uint256 value) public returns (bool) {
120         require(to != address(0));
121         require(balances[msg.sender] >= value);
122 
123         require(now >= MAY_15_2018 + 14 days);
124 
125         balances[msg.sender] = balances[msg.sender].sub(value);
126         balances[to] = balances[to].add(value);
127 
128         Transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     function transferFrom(address from, address to, uint256 value) public returns (bool) {
133         require(from != address(0));
134         require(to != address(0));
135         require(balances[from] >= value && allowed[from][msg.sender] >= value && balances[to] + value >= balances[to]);
136 
137         balances[from] = balances[from].sub(value);
138         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
139         balances[to] = balances[to].add(value);
140 
141         Transfer(from, to, value);
142         return true;
143     }
144 
145     function approve(address spender, uint256 amount) public returns (bool) {
146         require(spender != address(0));
147         require(allowed[msg.sender][spender] == 0 || amount == 0);
148 
149         allowed[msg.sender][spender] = amount;
150         Approval(msg.sender, spender, amount);
151         return true;
152     }
153 
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 }
157 
158 contract ICO is Token {
159     using SafeMath for uint256;
160 
161     uint256 private constant MARCH_15_2018 = 1521072000;
162     uint256 private constant MARCH_25_2018 = 1521936000;
163     uint256 private constant APRIL_15_2018 = 1523750400;
164     uint256 private constant APRIL_17_2018 = 1523923200;
165     uint256 private constant APRIL_20_2018 = 1524182400;
166     uint256 private constant APRIL_30_2018 = 1525046400;
167     uint256 private constant MAY_15_2018 = 1526342400;
168 
169     uint256 private constant PRE_SALE_MIN = 1 ether;
170     uint256 private constant MAIN_SALE_MIN = 10 ** 17 wei;
171 
172     uint256 private constant PRE_SALE_HARD_CAP = 2491 ether;
173     uint256 private constant MAX_CAP = 20000 ether;
174     uint256 private constant TOKEN_PRICE = 10 ** 14 wei;
175 
176     uint256 private constant TIER_1_MIN = 10 ether;
177     uint256 private constant TIER_2_MIN = 50 ether;
178 
179     uint8 private constant FOUNDERS_ADVISORS_ALLOCATION = 20; //Percent
180     uint8 private constant OPERATIONAL_FUND_ALLOCATION = 20; //Percent
181     uint8 private constant AIR_DROP_ALLOCATION = 5; //Percent
182 
183     address private constant FOUNDERS_LOCKUP = 0x0000000000000000000000000000000000009999;
184     address private constant OPERATIONAL_FUND_LOCKUP = 0x0000000000000000000000000000000000008888;
185 
186     address private constant WITHDRAW_ADDRESS = 0x8B7aa4103Ae75A7dDcac9d2E90aEaAe915f2C75E;
187     address private constant AIR_DROP = 0x1100784Cb330ae0BcAFEd061fa95f8aE093d7769;
188 
189     mapping (address => bool) public whitelistAdmins;
190     mapping (address => bool) public whitelist;
191     mapping (address => address) public tier1;
192     mapping (address => address) public tier2;
193 
194     uint32 public whitelistCount;
195     uint32 public tier1Count;
196     uint32 public tier2Count;
197 
198     uint256 public preICOwei = 0;
199     uint256 public ICOwei = 0;
200 
201     function getCurrentBonus(address participant) public constant returns (uint256) {
202 
203         if (isInTier2(participant)) {
204             return 60;
205         }
206 
207         if (isInTier1(participant)) {
208             return 40;
209         }
210 
211         if (inPublicPreSalePeriod()) {
212             return 30;
213         }
214 
215         if (inAngelPeriod()) {
216             return 20;
217         }
218 
219         if (now >= APRIL_17_2018 && now < APRIL_20_2018) {
220             return 10;
221         }
222 
223         if (now >= APRIL_20_2018 && now < APRIL_30_2018) {
224             return 5;
225         }
226 
227         return 0;
228     }
229 
230     function inPrivatePreSalePeriod() public constant returns (bool) {
231         if (now >= MARCH_15_2018 && now < APRIL_15_2018) {
232             return true;
233         } else {
234             return false;
235         }
236     }
237 
238     function inPublicPreSalePeriod() public constant returns (bool) {
239         if (now >= MARCH_15_2018 && now < MARCH_25_2018) {
240             return true;
241         } else {
242             return false;
243         }
244     }
245 
246     function inAngelPeriod() public constant returns (bool) {
247         if (now >= APRIL_15_2018 && now < APRIL_17_2018) {
248             return true;
249         } else {
250             return false;
251         }
252     }
253 
254     function inMainSalePeriod() public constant returns (bool) {
255         if (now >= APRIL_17_2018 && now < MAY_15_2018) {
256             return true;
257         } else {
258             return false;
259         }
260     }
261 
262     function addWhitelistAdmin(address newAdmin) public onlyOwner {
263         whitelistAdmins[newAdmin] = true;
264     }
265 
266     function isInWhitelist(address participant) public constant returns (bool) {
267         require(participant != address(0));
268         return whitelist[participant];
269     }
270 
271     function addToWhitelist(address participant) public onlyWhiteLister {
272         require(participant != address(0));
273         require(!isInWhitelist(participant));
274         whitelist[participant] = true;
275         whitelistCount += 1;
276 
277         NewWhitelistParticipant(participant);
278     }
279 
280     function addMultipleToWhitelist(address[] participants) public onlyWhiteLister {
281         require(participants.length != 0);
282         for (uint16 i = 0; i < participants.length; i++) {
283             addToWhitelist(participants[i]);
284         }
285     }
286 
287     function isInTier1(address participant) public constant returns (bool) {
288         require(participant != address(0));
289         return !(tier1[participant] == address(0));
290     }
291 
292     function addTier1Member(address participant) public onlyWhiteLister {
293         require(participant != address(0));
294         require(!isInTier1(participant)); // unless we require this, the count variable could get out of sync
295         tier1[participant] = participant;
296         tier1Count += 1;
297 
298         NewTier1Participant(participant);
299     }
300 
301     function addMultipleTier1Members(address[] participants) public onlyWhiteLister {
302         require(participants.length != 0);
303         for (uint16 i = 0; i < participants.length; i++) {
304             addTier1Member(participants[i]);
305         }
306     }
307 
308     function isInTier2(address participant) public constant returns (bool) {
309         require(participant != address(0));
310         return !(tier2[participant] == address(0));
311     }
312 
313     function addTier2Member(address participant) public onlyWhiteLister {
314         require(participant != address(0));
315         require(!isInTier2(participant)); // unless we require this, the count variable could get out of sync
316         tier2[participant] = participant;
317         tier2Count += 1;
318 
319         NewTier2Participant(participant);
320     }
321 
322     function addMultipleTier2Members(address[] participants) public onlyWhiteLister {
323         require(participants.length != 0);
324         for (uint16 i = 0; i < participants.length; i++) {
325             addTier2Member(participants[i]);
326         }
327     }
328 
329     function buyTokens() public payable {
330 
331         require(msg.sender != address(0));
332         require(isInTier1(msg.sender) || isInTier2(msg.sender) || isInWhitelist(msg.sender));
333         
334         require(inPrivatePreSalePeriod() || inPublicPreSalePeriod() || inAngelPeriod() || inMainSalePeriod());
335 
336         if (isInTier1(msg.sender)) {
337             require(msg.value >= TIER_1_MIN);
338         }
339 
340         if (isInTier2(msg.sender)) {
341             require(msg.value >= TIER_2_MIN);
342         }
343 
344         if (inPrivatePreSalePeriod() == true) {
345             require(msg.value >= PRE_SALE_MIN);
346 
347             require(PRE_SALE_HARD_CAP >= preICOwei.add(msg.value));
348             preICOwei = preICOwei.add(msg.value);
349         }
350 
351         if (inMainSalePeriod() == true) {
352             require(msg.value >= MAIN_SALE_MIN);
353 
354             require(MAX_CAP >= preICOwei + ICOwei.add(msg.value));
355             ICOwei = ICOwei.add(msg.value);
356         }
357 
358         uint256 deltaTokens = 0;
359 
360         uint256 tokens = msg.value.div(TOKEN_PRICE);
361         uint256 bonusTokens = getCurrentBonus(msg.sender).mul(tokens.div(100));
362 
363         tokens = tokens.add(bonusTokens);
364         balances[msg.sender] = balances[msg.sender].add(tokens);
365 
366         deltaTokens = deltaTokens.add(tokens);
367 
368         balances[FOUNDERS] += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION).div(2);
369         balances[FOUNDERS_LOCKUP] += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION).div(2);
370         deltaTokens += tokens.mul(100).div(FOUNDERS_ADVISORS_ALLOCATION);
371 
372         balances[OPERATIONAL_FUND] += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION).div(2);
373         balances[OPERATIONAL_FUND_LOCKUP] += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION).div(2);
374         deltaTokens += tokens.mul(100).div(OPERATIONAL_FUND_ALLOCATION);
375 
376         balances[AIR_DROP] += tokens.mul(100).div(AIR_DROP_ALLOCATION);
377         deltaTokens += tokens.mul(100).div(AIR_DROP_ALLOCATION);
378 
379         totalSupply = totalSupply.add(deltaTokens);
380 
381         TokenPurchase(msg.sender, msg.value, tokens);
382     }
383 
384     function() public payable {
385         buyTokens();
386     }
387 
388     function withdrawPreICOEth() public {
389         require(now > MARCH_25_2018);
390         WITHDRAW_ADDRESS.transfer(preICOwei);
391     }
392 
393     function withdrawICOEth() public {
394         require(now > MAY_15_2018);
395         WITHDRAW_ADDRESS.transfer(ICOwei);
396     }
397 
398     function withdrawAll() public {
399         require(now > MAY_15_2018);
400         WITHDRAW_ADDRESS.transfer(this.balance);
401     }
402 
403     function unlockTokens() public {
404         require(now > (MAY_15_2018 + 180 days));
405         balances[FOUNDERS] += balances[FOUNDERS_LOCKUP];
406         balances[FOUNDERS_LOCKUP] = 0;
407         balances[OPERATIONAL_FUND] += balances[OPERATIONAL_FUND_LOCKUP];
408         balances[OPERATIONAL_FUND_LOCKUP] = 0;
409     }
410 
411     event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _amount);
412 
413     event NewWhitelistParticipant(address indexed _participant);
414     event NewTier1Participant(address indexed _participant);
415     event NewTier2Participant(address indexed _participant);
416 
417     //
418     modifier onlyWhiteLister() {
419         require(whitelistAdmins[msg.sender]);
420         _;
421     }
422 }