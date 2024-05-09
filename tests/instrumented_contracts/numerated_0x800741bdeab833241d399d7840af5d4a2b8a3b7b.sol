1 pragma solidity ^0.4.13;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
64         bytes             fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 // Token standard API
83 // https://github.com/ethereum/EIPs/issues/20
84 
85 contract ERC20 {
86     function totalSupply() public view returns (uint supply);
87     function balanceOf( address who ) public view returns (uint value);
88     function allowance( address owner, address spender ) public view returns (uint _allowance);
89 
90     function transfer( address to, uint value) public returns (bool ok);
91     function transferFrom( address from, address to, uint value) public returns (bool ok);
92     function approve( address spender, uint value ) public returns (bool ok);
93 
94     event Transfer( address indexed from, address indexed to, uint value);
95     event Approval( address indexed owner, address indexed spender, uint value);
96 }
97 
98 contract DSStop is DSNote, DSAuth {
99 
100     bool public stopped;
101 
102     modifier stoppable {
103         require(!stopped);
104         _;
105     }
106     function stop() public auth note {
107         stopped = true;
108     }
109     function start() public auth note {
110         stopped = false;
111     }
112 
113 }
114 
115 /**
116  * Math operations with safety checks
117  */
118 library SafeMath {
119   function mul(uint a, uint b) internal returns (uint) {
120     uint c = a * b;
121     assert(a == 0 || c / a == b);
122     return c;
123   }
124 
125   function div(uint a, uint b) internal returns (uint) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     uint c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return c;
130   }
131 
132   function sub(uint a, uint b) internal returns (uint) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   function add(uint a, uint b) internal returns (uint) {
138     uint c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 
143   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
144     return a >= b ? a : b;
145   }
146 
147   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
148     return a < b ? a : b;
149   }
150 
151   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
152     return a >= b ? a : b;
153   }
154 
155   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
156     return a < b ? a : b;
157   }
158 }
159 
160 contract TokenTransferGuard {
161     function onTokenTransfer(address _from, address _to, uint _amount) public returns (bool);
162 }
163 
164 contract RewardSharedPool is DSStop {
165     using SafeMath for uint256;
166 
167     uint public maxReward      = 1000000 ether;
168 
169     uint public consumed   = 0;
170 
171     mapping(address => bool) public consumers;
172 
173     modifier onlyConsumer {
174         require(msg.sender == owner || consumers[msg.sender]);
175         _;
176     }
177 
178     function RewardSharedPool()
179     {
180     }
181 
182     function consume(uint amount) onlyConsumer public returns (bool)
183     {
184         require(available(amount));
185 
186         consumed = consumed.add(amount);
187 
188         Consume(msg.sender, amount);
189 
190         return true;
191     }
192 
193     function available(uint amount) constant public returns (bool)
194     {
195         return consumed.add(amount) <= maxReward;
196     }
197 
198     function changeMaxReward(uint _maxReward) auth public
199     {
200         maxReward = _maxReward;
201     }
202 
203     function addConsumer(address consumer) public auth
204     {
205         consumers[consumer] = true;
206 
207         ConsumerAddition(consumer);
208     }
209 
210     function removeConsumer(address consumer) public auth
211     {
212         consumers[consumer] = false;
213 
214         ConsumerRemoval(consumer);
215     }
216 
217     event Consume(address indexed _sender, uint _value);
218     event ConsumerAddition(address indexed _consumer);
219     event ConsumerRemoval(address indexed _consumer);
220 }
221 
222 contract ATNLongTermHolding is DSStop, TokenTransferGuard {
223     using SafeMath for uint256;
224 
225     uint public constant DEPOSIT_WINDOW                 = 60 days;
226 
227     // There are three kinds of options: 1. {105, 120 days}, 2. {110, 240 days}, 3. {115, 360 days}
228     uint public rate = 105;
229     uint public withdrawal_delay    = 120 days;
230 
231     uint public agtAtnReceived      = 0;
232     uint public atnSent             = 0;
233 
234     uint public depositStartTime    = 0;
235     uint public depositStopTime     = 0;
236 
237     RewardSharedPool public pool;
238 
239     struct Record {
240         uint agtAtnAmount;
241         uint timestamp;
242     }
243 
244     mapping (address => Record) public records;
245 
246     ERC20 public AGT;
247     ERC20 public ATN;
248 
249     uint public gasRequired;
250 
251     function ATNLongTermHolding(address _agt, address _atn, address _poolAddress, uint _rate, uint _delayDays)
252     {
253         AGT = ERC20(_agt);
254         ATN = ERC20(_atn);
255 
256         pool = RewardSharedPool(_poolAddress);
257 
258         require(_rate > 100);
259 
260         rate = _rate;
261         withdrawal_delay = _delayDays * 1 days;
262     }
263 
264     function start() public auth {
265         require(depositStartTime == 0);
266 
267         depositStartTime = now;
268         depositStopTime  = now + DEPOSIT_WINDOW;
269 
270         Started(depositStartTime);
271     }
272 
273     function changeDepositStopTimeFromNow(uint _daysFromNow) public auth {
274         depositStopTime = now + _daysFromNow * 1 days;
275     }
276 
277     function tokenFallback(address _from, uint256 _value, bytes _data) public
278     {
279         tokenFallback(_from, _value);
280     }
281 
282     // TODO: To test the stoppable can work or not
283     function tokenFallback(address _from, uint256 _value) public stoppable
284     {
285         if (msg.sender == address(AGT) || msg.sender == address(ATN))
286         {
287             // the owner is not count in the statistics
288             // Only owner can use to deposit the ATN reward things.
289             if (_from == owner)
290             {
291                 return;
292             }
293 
294             require(now <= depositStopTime);
295 
296             var record = records[_from];
297 
298             record.agtAtnAmount += _value;
299             record.timestamp = now;
300             records[_from] = record;
301 
302             agtAtnReceived += _value;
303 
304             pool.consume( _value.mul(rate - 100 ).div(100) );
305 
306             Deposit(depositId++, _from, _value);
307         }
308     }
309 
310     function onTokenTransfer(address _from, address _to, uint _amount) public returns (bool)
311     {
312         if (_to == address(this) && _from != owner)
313         {
314             if (msg.gas < gasRequired) return false;
315             
316             if (stopped) return false;
317             if (now > depositStopTime) return false;
318 
319             // each address can only deposit once.
320             if (records[_from].timestamp > 0 ) return false;
321 
322             // can not over the limit of maximum reward amount
323             if ( !pool.available( _amount.mul(rate - 100 ).div(100) ) ) return false;
324         }
325 
326         return true;
327     }
328 
329     function withdrawATN() public stoppable {
330         require(msg.sender != owner);
331 
332         Record record = records[msg.sender];
333 
334         require(record.timestamp > 0);
335 
336         require(now >= record.timestamp + withdrawal_delay);
337 
338         withdrawFor(msg.sender);
339     }
340 
341     function withdrawATN(address _addr) public stoppable {
342         require(_addr != owner);
343 
344         Record record = records[_addr];
345 
346         require(record.timestamp > 0);
347 
348         require(now >= record.timestamp + withdrawal_delay);
349 
350         withdrawFor(_addr);
351     }
352 
353     function withdrawFor(address _addr) internal {
354         Record record = records[_addr];
355         
356         uint atnAmount = record.agtAtnAmount.mul(rate).div(100);
357 
358         require(ATN.transfer(_addr, atnAmount));
359 
360         atnSent += atnAmount;
361 
362         delete records[_addr];
363 
364         Withdrawal(
365                    withdrawId++,
366                    _addr,
367                    atnAmount
368                    );
369     }
370 
371     function batchWithdraw(address[] _addrList) public stoppable {
372         for (uint i = 0; i < _addrList.length; i++) {
373             if (records[_addrList[i]].timestamp > 0 && now >= records[_addrList[i]].timestamp + withdrawal_delay)
374             {
375                 withdrawFor(_addrList[i]);
376             }
377         }
378     }
379 
380     function changeGasRequired(uint _gasRequired) public auth {
381         gasRequired = _gasRequired;
382         ChangeGasRequired(_gasRequired);
383     }
384 
385     /// @notice This method can be used by the controller to extract mistakenly
386     ///  sent tokens to this contract.
387     /// @param _token The address of the token contract that you want to recover
388     ///  set to 0 in case you want to extract ether.
389     function claimTokens(address _token) public auth {
390         if (_token == 0x0) {
391             owner.transfer(this.balance);
392             return;
393         }
394         
395         ERC20 token = ERC20(_token);
396         
397         uint256 balance = token.balanceOf(this);
398         
399         token.transfer(owner, balance);
400         ClaimedTokens(_token, owner, balance);
401     }
402 
403     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
404 
405     /*
406      * EVENTS
407      */
408     /// Emitted when program starts.
409     event Started(uint _time);
410 
411     /// Emitted for each sucuessful deposit.
412     uint public depositId = 0;
413     event Deposit(uint _depositId, address indexed _addr, uint agtAtnAmount);
414 
415     /// Emitted for each sucuessful withdrawal.
416     uint public withdrawId = 0;
417     event Withdrawal(uint _withdrawId, address indexed _addr, uint _atnAmount);
418 
419     event ChangeGasRequired(uint _gasRequired);
420 }