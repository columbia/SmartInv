1 pragma solidity ^0.4.25;
2 
3 
4 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * See https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender)
78     public view returns (uint256);
79 
80   function transferFrom(address from, address to, uint256 value)
81     public returns (bool);
82 
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 contract Ownable {
92   address public owner;
93 
94 
95   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   function Ownable() public {
103     owner = msg.sender;
104   }
105 
106 
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address newOwner) public onlyOwner {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 
129 /**
130  * @title Pausable
131  * @dev Base contract which allows children to implement an emergency stop mechanism.
132  */
133 contract Pausable is Ownable {
134   event Pause();
135   event Unpause();
136 
137   bool public paused = false;
138 
139 
140   /**
141    * @dev Modifier to make a function callable only when the contract is not paused.
142    */
143   modifier whenNotPaused() {
144     require(!paused);
145     _;
146   }
147 
148   /**
149    * @dev Modifier to make a function callable only when the contract is paused.
150    */
151   modifier whenPaused() {
152     require(paused);
153     _;
154   }
155 
156   /**
157    * @dev called by the owner to pause, triggers stopped state
158    */
159   function pause() onlyOwner whenNotPaused public {
160     paused = true;
161     Pause();
162   }
163 
164   /**
165    * @dev called by the owner to unpause, returns to normal state
166    */
167   function unpause() onlyOwner whenPaused public {
168     paused = false;
169     Unpause();
170   }
171 }
172 
173 // File: openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
174 
175 /**
176  * @title SafeERC20
177  * @dev Wrappers around ERC20 operations that throw on failure.
178  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
179  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
180  */
181 library SafeERC20 {
182   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
183     require(token.transfer(to, value));
184   }
185 
186   function safeTransferFrom(
187     ERC20 token,
188     address from,
189     address to,
190     uint256 value
191   )
192     internal
193   {
194     require(token.transferFrom(from, to, value));
195   }
196 
197   function safeApprove(ERC20 token, address spender, uint256 value) internal {
198     require(token.approve(spender, value));
199   }
200 }
201 
202 
203 
204 contract SpecialERC20 {
205     function transfer(address to, uint256 value) public;
206 }
207 
208 contract Random {
209   function getRandom(bytes32 hash) public view returns (uint);
210     
211 }
212 
213 contract RedEnvelope is Pausable {
214     
215     using SafeMath for uint;
216     using SafeERC20 for ERC20;
217     
218     Random public random;
219 
220     modifier isHuman() {
221         address _addr = msg.sender;
222         uint256 _codeLength;
223         
224         assembly {_codeLength := extcodesize(_addr)}
225         require(_codeLength == 0, "sorry humans only");
226         _;
227     }
228     
229     struct Info {
230         address token;
231         address owner;
232         uint amount;
233         uint count;
234         address[] limitAddress;
235         bool isRandom;
236         bool isSpecialERC20;
237         uint expires;
238         uint created;
239         string desc;
240         uint fill;
241     }
242     
243     string public name = "RedEnvelope";
244     
245     mapping(bytes32 => Info) public infos;
246     mapping (address => bool) public tokenWhiteList;
247     
248     struct SnatchInfo {
249         address user;
250         uint amount;
251         uint time;
252     }
253     
254     mapping(bytes32 => SnatchInfo[]) public snatchInfos;
255     
256     constructor() public {
257         
258     }
259 
260     function enableToken(address[] addr, bool[] enable) public onlyOwner() {
261         require(addr.length == enable.length);
262         for (uint i = 0; i < addr.length; i++) {
263             tokenWhiteList[addr[i]] = enable[i];
264         }
265     }
266 
267     function tokenIsEnable(address addr) public view returns (bool) {
268         return tokenWhiteList[addr];
269     }
270     
271     function setRandom(address _random) public onlyOwner isHuman() {
272         random = Random(_random);
273     }
274     
275     event RedEnvelopeCreated(bytes32 hash);
276     
277     // 创建红包
278     function create(
279         bool isSpecialERC20, 
280         address token, 
281         uint amount, 
282         uint count, 
283         uint expires, 
284         address[] limitAddress, 
285         bool isRandom, 
286         string desc, 
287         uint nonce
288     ) public payable isHuman() whenNotPaused() {
289         if (token == address(0)) {
290             require(msg.value >= amount);
291         } else {
292             ERC20(token).transferFrom(msg.sender, this, amount);
293         }
294 
295         require(tokenWhiteList[token]);
296 
297         require(amount > 0);
298         require(count > 0);
299         require(expires > now);
300         
301         bytes32 hash = sha256(abi.encodePacked(this, isSpecialERC20, token, amount, expires, nonce, msg.sender, now));
302         require(infos[hash].created == 0);
303         infos[hash] = Info(token, msg.sender, amount, count, limitAddress, isRandom, isSpecialERC20, expires, now, desc, 0);
304      
305         emit RedEnvelopeCreated(hash);   
306     }
307     
308     event Snatch(bytes32 hash, address user, uint amount, uint time);
309 
310     // 抢红包
311     function snatch(bytes32 hash) public isHuman() whenNotPaused() {
312         Info storage info = infos[hash];
313         require(info.created > 0);
314         require(info.amount >= info.fill);
315         require(info.expires >= now);
316         
317         
318         if (info.limitAddress.length > 0) {
319             bool find = false;
320             for (uint i = 0; i < info.limitAddress.length; i++) {
321                 if (info.limitAddress[i] == msg.sender) {
322                     find = true;
323                     break;
324                 }
325             }
326             require(find);
327         }
328 
329         SnatchInfo[] storage curSnatchInfos = snatchInfos[hash];
330         require(info.count > curSnatchInfos.length);
331         for (i = 0; i < curSnatchInfos.length; i++) {
332             require (curSnatchInfos[i].user != msg.sender);
333         }
334         
335         uint per = 0;
336 
337         if (info.isRandom) {
338             if (curSnatchInfos.length + 1 == info.count) {
339                 per = info.amount.sub(info.fill);
340             } else {
341                 require(random != address(0));
342                 per = random.getRandom(hash);
343             }
344         } else {
345             per = info.amount.div(info.count);
346         }
347 
348         snatchInfos[hash].push(SnatchInfo(msg.sender, per, now));
349         if (info.token == address(0)) {
350             msg.sender.transfer(per);
351         } else {
352             if (info.isSpecialERC20) {
353                 SpecialERC20(info.token).transfer(msg.sender, per);
354             } else {
355                 ERC20(info.token).transfer(msg.sender, per);
356             }
357         }
358         info.fill = info.fill.add(per);
359         
360         emit Snatch(hash, msg.sender, per, now);
361     }
362     
363     event RedEnvelopeSendBack(bytes32 hash, address owner, uint amount);
364     
365     function sendBack(bytes32 hash) public isHuman(){
366         Info storage info = infos[hash];
367         require(info.expires < now);
368         require(info.fill < info.amount);
369         require(info.owner == msg.sender);
370         
371         uint back = info.amount.sub(info.fill);
372         info.fill = info.amount;
373         if (info.token == address(0)) {
374             msg.sender.transfer(back);
375         } else {
376             if (info.isSpecialERC20) {
377                 SpecialERC20(info.token).transfer(msg.sender, back);
378             } else {
379                 ERC20(info.token).transfer(msg.sender, back);
380             }
381         }
382         
383         emit RedEnvelopeSendBack(hash, msg.sender, back);
384     }
385     
386     function getInfo(bytes32 hash) public view returns(
387         address token, 
388         address owner, 
389         uint amount, 
390         uint count, 
391         address[] limitAddress, 
392         bool isRandom, 
393         bool isSpecialERC20, 
394         uint expires, 
395         uint created, 
396         string desc,
397         uint fill
398     ) {
399         Info storage info = infos[hash];
400         return (info.token, 
401             info.owner, 
402             info.amount, 
403             info.count, 
404             info.limitAddress, 
405             info.isRandom, 
406             info.isSpecialERC20, 
407             info.expires, 
408             info.created, 
409             info.desc,
410             info.fill
411         );
412     }
413 
414     function getLightInfo(bytes32 hash) public view returns (
415         address token, 
416         uint amount, 
417         uint count,  
418         uint fill,
419         uint userCount
420     ) {
421         Info storage info = infos[hash];
422         SnatchInfo[] storage snatchInfo = snatchInfos[hash];
423         return (info.token, 
424             info.amount, 
425             info.count, 
426             info.fill,
427             snatchInfo.length
428         );
429     }
430     
431     function getSnatchInfo(bytes32 hash) public view returns (address[] user, uint[] amount, uint[] time) {
432         SnatchInfo[] storage info = snatchInfos[hash];
433         
434         address[] memory _user = new address[](info.length);
435         uint[] memory _amount = new uint[](info.length);
436         uint[] memory _time = new uint[](info.length);
437         
438         for (uint i = 0; i < info.length; i++) {
439             _user[i] = info[i].user;
440             _amount[i] = info[i].amount;
441             _time[i] = info[i].time;
442         }
443         
444         return (_user, _amount, _time);
445     }
446     
447 }