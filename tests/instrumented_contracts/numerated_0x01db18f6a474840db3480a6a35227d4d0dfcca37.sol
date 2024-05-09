1 pragma solidity ^0.4.20;
2 
3 
4 /*
5  * ERC20 interface
6  * see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9     uint public totalSupply;
10     function balanceOf(address who) constant returns (uint);
11     function allowance(address owner, address spender) constant returns (uint);
12 
13     function transfer(address to, uint value) returns (bool ok);
14     function transferFrom(address from, address to, uint value) returns (bool ok);
15     function approve(address spender, uint value) returns (bool ok);
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 
21 /**
22  * Math operations with safety checks
23  */
24 contract SafeMath {
25     function safeMul(uint a, uint b) internal returns (uint) {
26         uint c = a * b;
27         assert(a == 0 || c / a == b);
28         return c;
29     }
30 
31     function safeDiv(uint a, uint b) internal returns (uint) {
32         assert(b > 0);
33         uint c = a / b;
34         assert(a == b * c + a % b);
35         return c;
36     }
37 
38     function safeSub(uint a, uint b) internal returns (uint) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function safeAdd(uint a, uint b) internal returns (uint) {
44         uint c = a + b;
45         assert(c >= a && c >= b);
46         return c;
47     }
48 
49     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50         return a >= b ? a : b;
51     }
52 
53     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54         return a < b ? a : b;
55     }
56 
57     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58         return a >= b ? a : b;
59     }
60 
61     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62         return a < b ? a : b;
63     }
64 
65     function assert(bool assertion) internal {
66         if (!assertion) {
67             throw;
68         }
69     }
70 
71 }
72 
73 /**
74  * Owned contract
75  */
76 contract Owned {
77     address[] public pools;
78     address public owner;
79 
80     function Owned() {
81         owner = msg.sender;
82         pools.push(msg.sender);
83     }
84 
85     modifier onlyPool {
86         require(isPool(msg.sender));
87         _;
88     }
89 
90     modifier onlyOwner {
91         require(msg.sender == owner);
92         _;
93     }
94     
95     /// add new pool address to pools
96     function addPool(address newPool) onlyOwner {
97         assert (newPool != 0);
98         if (isPool(newPool)) throw;
99         pools.push(newPool);
100     }
101     
102     /// remove a address from pools
103     function removePool(address pool) onlyOwner{
104         assert (pool != 0);
105         if (!isPool(pool)) throw;
106         
107         for (uint i=0; i<pools.length - 1; i++) {
108             if (pools[i] == pool) {
109                 pools[i] = pools[pools.length - 1];
110                 break;
111             }
112         }
113         pools.length -= 1;
114     }
115 
116     function isPool(address pool) internal returns (bool ok){
117         for (uint i=0; i<pools.length; i++) {
118             if (pools[i] == pool)
119                 return true;
120         }
121         return false;
122     }
123     
124     function transferOwnership(address newOwner) onlyOwner public {
125         removePool(owner);
126         addPool(newOwner);
127         owner = newOwner;
128     }
129 }
130 
131 /**
132  * BP crowdsale contract
133 */
134 contract BPToken is SafeMath, Owned, ERC20 {
135     string public constant name = "Backpack Token";
136     string public constant symbol = "BP";
137     uint256 public constant decimals = 18;  
138 
139     mapping (address => uint256) balances;
140     mapping (address => mapping (address => uint256)) allowed;
141 
142     function BPToken() {
143         totalSupply = 2000000000 * 10 ** uint256(decimals);
144         balances[msg.sender] = totalSupply;
145     }
146 
147     /// asset pool map
148     mapping (address => address) addressPool;
149 
150     /// address base amount
151     mapping (address => uint256) addressAmount;
152 
153     /// per month seconds
154     uint perMonthSecond = 2592000;
155     
156     /// calc the balance that the user shuold hold
157     function shouldHadBalance(address who) constant returns (uint256){
158         if (isPool(who)) return 0;
159 
160         address apAddress = getAssetPoolAddress(who);
161         uint256 baseAmount  = getBaseAmount(who);
162 
163         /// Does not belong to AssetPool contract
164         if( (apAddress == address(0)) || (baseAmount == 0) ) return 0;
165 
166         /// Instantiate ap contract
167         AssetPool ap = AssetPool(apAddress);
168 
169         uint startLockTime = ap.getStartLockTime();
170         uint stopLockTime = ap.getStopLockTime();
171 
172         if (block.timestamp > stopLockTime) {
173             return 0;
174         }
175 
176         if (ap.getBaseLockPercent() == 0) {
177             return 0;
178         }
179 
180         // base lock amount 
181         uint256 baseLockAmount = safeDiv(safeMul(baseAmount, ap.getBaseLockPercent()),100);
182         if (block.timestamp < startLockTime) {
183             return baseLockAmount;
184         }
185         
186         /// will not linear release
187         if (ap.getLinearRelease() == 0) {
188             if (block.timestamp < stopLockTime) {
189                 return baseLockAmount;
190             } else {
191                 return 0;
192             }
193         }
194         /// will linear release 
195 
196         /// now timestamp before start lock time 
197         if (block.timestamp < startLockTime + perMonthSecond) {
198             return baseLockAmount;
199         }
200         // total lock months
201         uint lockMonth = safeDiv(safeSub(stopLockTime,startLockTime),perMonthSecond);
202         if (lockMonth <= 0) {
203             if (block.timestamp >= stopLockTime) {
204                 return 0;
205             } else {
206                 return baseLockAmount;
207             }
208         }
209 
210         // unlock amount of every month
211         uint256 monthUnlockAmount = safeDiv(baseLockAmount,lockMonth);
212 
213         // current timestamp passed month 
214         uint hadPassMonth = safeDiv(safeSub(block.timestamp,startLockTime),perMonthSecond);
215 
216         return safeSub(baseLockAmount,safeMul(hadPassMonth,monthUnlockAmount));
217     }
218 
219     function getAssetPoolAddress(address who) internal returns(address){
220         return addressPool[who];
221     }
222 
223     function getBaseAmount(address who) internal returns(uint256){
224         return addressAmount[who];
225     }
226 
227     function getBalance() constant returns(uint){
228         return balances[msg.sender];
229     }
230 
231     function setPoolAndAmount(address who, uint256 amount) onlyPool returns (bool) {
232         assert(balances[msg.sender] >= amount);
233 
234         if (owner == who) {
235             return true;
236         }
237         
238         address apAddress = getAssetPoolAddress(who);
239         uint256 baseAmount = getBaseAmount(who);
240 
241         assert((apAddress == msg.sender) || (baseAmount == 0));
242 
243         addressPool[who] = msg.sender;
244         addressAmount[who] += amount;
245 
246         return true;
247     }
248 
249     /// get balance of the special address
250     function balanceOf(address who) constant returns (uint) {
251         return balances[who];
252     }
253 
254     /// @notice Transfer `value` BP tokens from sender's account
255     /// `msg.sender` to provided account address `to`.
256     /// @notice This function is disabled during the funding.
257     /// @dev Required state: Success
258     /// @param to The address of the recipient
259     /// @param value The number of BPs to transfer
260     /// @return Whether the transfer was successful or not
261     function transfer(address to, uint256 value) returns (bool) {
262         if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;
263 
264         uint256 senderBalance = balances[msg.sender];
265         if (senderBalance >= value && value > 0) {
266             senderBalance = safeSub(senderBalance, value);
267             balances[msg.sender] = senderBalance;
268             balances[to] = safeAdd(balances[to], value);
269             Transfer(msg.sender, to, value);
270             return true;
271         } else {
272             throw;
273         }
274     }
275 
276     /// @notice Transfer `value` BP tokens from sender 'from'
277     /// to provided account address `to`.
278     /// @notice This function is disabled during the funding.
279     /// @dev Required state: Success
280     /// @param from The address of the sender
281     /// @param to The address of the recipient
282     /// @param value The number of BPs to transfer
283     /// @return Whether the transfer was successful or not
284     function transferFrom(address from, address to, uint256 value) returns (bool) {
285         // Abort if not in Success state.
286         // protect against wrapping uints
287         if (balances[from] >= value &&
288         allowed[from][msg.sender] >= value &&
289         safeAdd(balances[to], value) > balances[to])
290         {
291             balances[to] = safeAdd(balances[to], value);
292             balances[from] = safeSub(balances[from], value);
293             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
294             Transfer(from, to, value);
295             return true;
296         } else {
297             throw;
298         }
299     }
300 
301     /// @notice `msg.sender` approves `spender` to spend `value` tokens
302     /// @param spender The address of the account able to transfer the tokens
303     /// @param value The amount of wei to be approved for transfer
304     /// @return Whether the approval was successful or not
305     function approve(address spender, uint256 value) returns (bool) {
306         if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;
307         
308         // Abort if not in Success state.
309         allowed[msg.sender][spender] = value;
310         Approval(msg.sender, spender, value);
311         return true;
312     }
313 
314     /// @param owner The address of the account owning tokens
315     /// @param spender The address of the account able to transfer the tokens
316     /// @return Amount of remaining tokens allowed to spent
317     function allowance(address owner, address spender) constant returns (uint) {
318         uint allow = allowed[owner][spender];
319         return allow;
320     }
321 }
322 
323 
324 
325 contract ownedPool {
326     address public owner;
327 
328     function ownedPool() public {
329         owner = msg.sender;
330     }
331 
332     modifier onlyOwner {
333         require(msg.sender == owner);
334         _;
335     }
336 
337     function transferOwnership(address newOwner) onlyOwner public {
338         owner = newOwner;
339     }
340 }
341 
342 /**
343  * Asset pool contract
344 */
345 contract AssetPool is ownedPool {
346     uint  baseLockPercent;
347     uint  startLockTime;
348     uint  stopLockTime;
349     uint  linearRelease;
350     address public bpTokenAddress;
351 
352     BPToken bp;
353 
354     function AssetPool(address _bpTokenAddress, uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) {
355         assert(_stopLockTime > _startLockTime);
356         
357         baseLockPercent = _baseLockPercent;
358         startLockTime = _startLockTime;
359         stopLockTime = _stopLockTime;
360         linearRelease = _linearRelease;
361 
362         bpTokenAddress = _bpTokenAddress;
363         bp = BPToken(bpTokenAddress);
364 
365         owner = msg.sender;
366     }
367     
368     /// set role value
369     function setRule(uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) onlyOwner {
370         assert(_stopLockTime > _startLockTime);
371        
372         baseLockPercent = _baseLockPercent;
373         startLockTime = _startLockTime;
374         stopLockTime = _stopLockTime;
375         linearRelease = _linearRelease;
376     }
377 
378     /// set bp token contract address
379     // function setBpToken(address _bpTokenAddress) onlyOwner {
380     //     bpTokenAddress = _bpTokenAddress;
381     //     bp = BPToken(bpTokenAddress);
382     // }
383     
384     /// assign BP token to another address
385     function assign(address to, uint256 amount) onlyOwner returns (bool) {
386         if (bp.setPoolAndAmount(to,amount)) {
387             if (bp.transfer(to,amount)) {
388                 return true;
389             }
390         }
391         return false;
392     }
393 
394     /// get the balance of current asset pool
395     function getPoolBalance() constant returns (uint) {
396         return bp.getBalance();
397     }
398     
399     function getStartLockTime() constant returns (uint) {
400         return startLockTime;
401     }
402     
403     function getStopLockTime() constant returns (uint) {
404         return stopLockTime;
405     }
406     
407     function getBaseLockPercent() constant returns (uint) {
408         return baseLockPercent;
409     }
410     
411     function getLinearRelease() constant returns (uint) {
412         return linearRelease;
413     }
414 }