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
129 // File: openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
130 
131 /**
132  * @title SafeERC20
133  * @dev Wrappers around ERC20 operations that throw on failure.
134  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
135  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
136  */
137 library SafeERC20 {
138   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
139     require(token.transfer(to, value));
140   }
141 
142   function safeTransferFrom(
143     ERC20 token,
144     address from,
145     address to,
146     uint256 value
147   )
148     internal
149   {
150     require(token.transferFrom(from, to, value));
151   }
152 
153   function safeApprove(ERC20 token, address spender, uint256 value) internal {
154     require(token.approve(spender, value));
155   }
156 }
157 
158 
159 
160 contract SpecialERC20 {
161     function transfer(address to, uint256 value) public;
162 }
163 
164 contract Random {
165   function getRandom(bytes32 hash) public view returns (uint);
166     
167 }
168 
169 contract RedEnvelope is Ownable {
170     
171     using SafeMath for uint;
172     using SafeERC20 for ERC20;
173     
174     Random public random;
175     
176     struct Info {
177         address token;
178         address owner;
179         uint amount;
180         uint count;
181         address[] limitAddress;
182         bool isRandom;
183         bool isSpecialERC20;
184         uint expires;
185         uint created;
186         string desc;
187         uint fill;
188     }
189     
190     string public name = "RedEnvelope";
191     
192     mapping(bytes32 => Info) public infos;
193     
194     struct SnatchInfo {
195         address user;
196         uint amount;
197         uint time;
198     }
199     
200     mapping(bytes32 => SnatchInfo[]) public snatchInfos;
201     
202     constructor() public {
203         
204     }
205     
206     function setRandom(address _random) public onlyOwner {
207         random = Random(_random);
208     }
209     
210     event RedEnvelopeCreated(bytes32 hash);
211     
212     // 创建红包
213     function create(
214         bool isSpecialERC20, 
215         address token, 
216         uint amount, 
217         uint count, 
218         uint expires, 
219         address[] limitAddress, 
220         bool isRandom, 
221         string desc, 
222         uint nonce
223     ) public payable {
224         if (token == address(0)) {
225             require(msg.value >= amount);
226         } else {
227             ERC20(token).transferFrom(msg.sender, this, amount);
228         }
229 
230         require(amount > 0);
231         require(count > 0);
232         require(expires > now);
233         
234         bytes32 hash = sha256(abi.encodePacked(this, isSpecialERC20, token, amount, expires, nonce, msg.sender, now));
235         require(infos[hash].created == 0);
236         infos[hash] = Info(token, msg.sender, amount, count, limitAddress, isRandom, isSpecialERC20, expires, now, desc, 0);
237      
238         emit RedEnvelopeCreated(hash);   
239     }
240     
241     event Snatch(bytes32 hash, address user, uint amount, uint time);
242 
243     // 抢红包
244     function snatch(bytes32 hash) public {
245         Info storage info = infos[hash];
246         require(info.created > 0);
247         require(info.amount >= info.fill);
248         require(info.expires >= now);
249         
250         
251         if (info.limitAddress.length > 0) {
252             bool find = false;
253             for (uint i = 0; i < info.limitAddress.length; i++) {
254                 if (info.limitAddress[i] == msg.sender) {
255                     find = true;
256                     break;
257                 }
258             }
259             require(find);
260         }
261 
262         SnatchInfo[] storage curSnatchInfos = snatchInfos[hash];
263         require(info.count > curSnatchInfos.length);
264         for (i = 0; i < curSnatchInfos.length; i++) {
265             require (curSnatchInfos[i].user != msg.sender);
266         }
267         
268         uint per = 0;
269 
270         if (info.isRandom) {
271             if (curSnatchInfos.length + 1 == info.count) {
272                 per = info.amount - info.fill;
273             } else {
274                 require(random != address(0));
275                 per = random.getRandom(hash);
276             }
277         } else {
278             per = info.amount / info.count;
279         }
280 
281         snatchInfos[hash].push(SnatchInfo(msg.sender, per, now));
282         if (info.token == address(0)) {
283             msg.sender.transfer(per);
284         } else {
285             if (info.isSpecialERC20) {
286                 SpecialERC20(info.token).transfer(msg.sender, per);
287             } else {
288                 ERC20(info.token).transfer(msg.sender, per);
289             }
290         }
291         info.fill += per;
292         
293         emit Snatch(hash, msg.sender, per, now);
294     }
295 
296     function getRandom() internal view returns (uint) {
297         bytes32 hash = sha256(abi.encodePacked(this, now, block.blockhash(block.number - 1)));
298         uint val = uint(hash);
299         return val % 100;
300     }
301     
302     event RedEnvelopeSendBack(bytes32 hash, address owner, uint amount);
303     
304     function sendBack(bytes32 hash) public {
305         Info storage info = infos[hash];
306         require(info.expires < now);
307         require(info.fill < info.amount);
308         require(info.owner == msg.sender);
309         
310         uint back = info.amount - info.fill;
311         info.fill = info.amount;
312         if (info.token == address(0)) {
313             msg.sender.transfer(back);
314         } else {
315             if (info.isSpecialERC20) {
316                 SpecialERC20(info.token).transfer(msg.sender, back);
317             } else {
318                 ERC20(info.token).transfer(msg.sender, back);
319             }
320         }
321         
322         emit RedEnvelopeSendBack(hash, msg.sender, back);
323     }
324     
325     function getInfo(bytes32 hash) public view returns(
326         address token, 
327         address owner, 
328         uint amount, 
329         uint count, 
330         address[] limitAddress, 
331         bool isRandom, 
332         bool isSpecialERC20, 
333         uint expires, 
334         uint created, 
335         string desc,
336         uint fill
337     ) {
338         Info storage info = infos[hash];
339         return (info.token, 
340             info.owner, 
341             info.amount, 
342             info.count, 
343             info.limitAddress, 
344             info.isRandom, 
345             info.isSpecialERC20, 
346             info.expires, 
347             info.created, 
348             info.desc,
349             info.fill
350         );
351     }
352 
353     function getLightInfo(bytes32 hash) public view returns (
354         address token, 
355         uint amount, 
356         uint count,  
357         uint fill,
358         uint userCount
359     ) {
360         Info storage info = infos[hash];
361         SnatchInfo[] storage snatchInfo = snatchInfos[hash];
362         return (info.token, 
363             info.amount, 
364             info.count, 
365             info.fill,
366             snatchInfo.length
367         );
368     }
369     
370     function getSnatchInfo(bytes32 hash) public view returns (address[] user, uint[] amount, uint[] time) {
371         SnatchInfo[] storage info = snatchInfos[hash];
372         
373         address[] memory _user = new address[](info.length);
374         uint[] memory _amount = new uint[](info.length);
375         uint[] memory _time = new uint[](info.length);
376         
377         for (uint i = 0; i < info.length; i++) {
378             _user[i] = info[i].user;
379             _amount[i] = info[i].amount;
380             _time[i] = info[i].time;
381         }
382         
383         return (_user, _amount, _time);
384     }
385     
386 }