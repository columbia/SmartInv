1 pragma solidity ^0.4.18;
2 
3 /**
4  * INMCOIN
5  *
6  * @author icetea-neko and INMCOIN menbers.
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61     address public owner;
62 
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67     /**
68     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69     * account.
70     */
71     function Ownable() public {
72         owner = msg.sender;
73     }
74 
75     /**
76     * @dev Throws if called by any account other than the owner.
77     */
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     /**
84     * @dev Allows the current owner to transfer control of the contract to a newOwner.
85     * @param newOwner The address to transfer ownership to.
86     */
87     function transferOwnership(address newOwner) onlyOwner public {
88         require(newOwner != address(0));
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91     }
92 
93 }
94 
95 /**
96  * ERC223 token by Dexaran
97  *
98  * https://github.com/Dexaran/ERC223-token-standard
99  */
100 
101 /* New ERC223 contract interface */
102 contract ERC223 {
103     uint public totalSupply;
104 
105     // ERC223 and ERC20 functions and events
106     function balanceOf(address who) public view returns (uint);
107     function totalSupply() public view returns (uint256 _supply);
108     function transfer(address to, uint value) public returns (bool ok);
109     function transfer(address to, uint value, bytes data) public returns (bool ok);
110     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
111     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
112 
113     // ERC223 functions
114     function name() public view returns (string _name);
115     function symbol() public view returns (string _symbol);
116     function decimals() public view returns (uint8 _decimals);
117 
118     // ERC20 functions and events
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
120     function approve(address _spender, uint256 _value) public returns (bool success);
121     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
122     event Transfer(address indexed _from, address indexed _to, uint256 _value);
123     event Approval(address indexed _owner, address indexed _spender, uint _value);
124 }
125 
126 /*
127  * Contract that is working with ERC223 tokens
128  */
129 
130 contract ContractReceiver {
131 
132     struct TKN {
133         address sender;
134         uint value;
135         bytes data;
136         bytes4 sig;
137     }
138 
139 
140     function tokenFallback(address _from, uint _value, bytes _data) public pure {
141         TKN memory tkn;
142         tkn.sender = _from;
143         tkn.value = _value;
144         tkn.data = _data;
145         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
146         tkn.sig = bytes4(u);
147 
148         /* tkn variable is analogue of msg variable of Ether transaction
149          *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
150          *  tkn.value the number of tokens that were sent   (analogue of msg.value)
151          *  tkn.data is data of token transaction   (analogue of msg.data)
152          *  tkn.sig is 4 bytes signature of function
153          *  if data of token transaction is a function execution
154          */
155     }
156 }
157 
158 /**
159  * @title INMCOIN
160  *
161  * @author icetea-neko and INMCOIN menbers.
162  */
163 contract INMCOIN is ERC223, Ownable {
164 
165     using SafeMath for uint256;
166 
167     string public name = "INMCOIN";
168     string public symbol = "INM";
169     uint8 public decimals = 8;
170     uint256 public totalSupply = 1145141919810 * 1e8;
171     uint256 public distributeAmount = 0;
172     bool public mintingFinished = false;
173 
174     address public founder = 0x05597a39381A5a050afD22b1Bf339A421cDF7824;
175     address public developerFunds = 0x74215a1cC9BCaAFe9F307a305286AA682FF37210;
176     address public publicityFunds = 0x665992c65269bdEa0386DC60ca369DE08D29D829;
177     address public proofOfShit = 0x4E669Fe33921da7514c4852e18a4D2faE3364EE4;
178     address public listing = 0x283b39551C7c1694Afbe52aFA075E4565D4323bF;
179 
180     mapping(address => uint256) public balanceOf;
181     mapping(address => mapping (address => uint256)) public allowance;
182     mapping (address => bool) public frozenAccount;
183     mapping (address => uint256) public unlockUnixTime;
184 
185     event FrozenFunds(address indexed target, bool frozen);
186     event LockedFunds(address indexed target, uint256 locked);
187     event Burn(address indexed from, uint256 amount);
188     event Mint(address indexed to, uint256 amount);
189     event MintFinished();
190 
191     function INMCOIN() public {
192         owner = publicityFunds;
193 
194         balanceOf[founder] = totalSupply.mul(114514).div(1000000);
195         balanceOf[developerFunds] = totalSupply.mul(1919).div(10000);
196         balanceOf[publicityFunds] = totalSupply.mul(810).div(10000);
197         balanceOf[proofOfShit] = totalSupply.mul(364364).div(1000000);
198         balanceOf[listing] = totalSupply.mul(248222).div(1000000);
199 
200     }
201 
202     function name() public view returns (string _name) {
203         return name;
204     }
205     function symbol() public view returns (string _symbol) {
206         return symbol;
207     }
208     function decimals() public view returns (uint8 _decimals) {
209         return decimals;
210     }
211     function totalSupply() public view returns (uint256 _totalSupply) {
212         return totalSupply;
213     }
214     function balanceOf(address _owner) public view returns (uint256 balance) {
215         return balanceOf[_owner];
216     }
217     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
218         require(targets.length > 0);
219 
220         for (uint j = 0; j < targets.length; j++) {
221             require(targets[j] != 0x0);
222             frozenAccount[targets[j]] = isFrozen;
223             FrozenFunds(targets[j], isFrozen);
224         }
225     }
226     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
227         require(targets.length > 0 && targets.length == unixTimes.length);
228 
229         for(uint j = 0; j < targets.length; j++){
230             require(unlockUnixTime[targets[j]] < unixTimes[j]);
231             unlockUnixTime[targets[j]] = unixTimes[j];
232             LockedFunds(targets[j], unixTimes[j]);
233         }
234     }
235     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
236         require(_value > 0
237                 && frozenAccount[msg.sender] == false
238                 && frozenAccount[_to] == false
239                 && now > unlockUnixTime[msg.sender]
240                 && now > unlockUnixTime[_to]);
241         if (isContract(_to)) {
242             require(balanceOf[msg.sender] >= _value);
243             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
244             balanceOf[_to] = balanceOf[_to].add(_value);
245             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
246             Transfer(msg.sender, _to, _value, _data);
247             Transfer(msg.sender, _to, _value);
248             return true;
249         } else {
250             return transferToAddress(_to, _value, _data);
251         }
252     }
253     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
254         require(_value > 0
255                 && frozenAccount[msg.sender] == false
256                 && frozenAccount[_to] == false
257                 && now > unlockUnixTime[msg.sender]
258                 && now > unlockUnixTime[_to]);
259         if (isContract(_to)) {
260             return transferToContract(_to, _value, _data);
261         } else {
262             return transferToAddress(_to, _value, _data);
263         }
264     }
265     function transfer(address _to, uint _value) public returns (bool success) {
266         require(_value > 0
267                 && frozenAccount[msg.sender] == false
268                 && frozenAccount[_to] == false
269                 && now > unlockUnixTime[msg.sender]
270                 && now > unlockUnixTime[_to]);
271         bytes memory empty;
272         if (isContract(_to)) {
273             return transferToContract(_to, _value, empty);
274         } else {
275             return transferToAddress(_to, _value, empty);
276         }
277     }
278     function isContract(address _addr) private view returns (bool is_contract) {
279         uint length;
280         assembly {
281             length := extcodesize(_addr)
282         }
283         return (length > 0);
284     }
285     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
286         require(balanceOf[msg.sender] >= _value);
287         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
288         balanceOf[_to] = balanceOf[_to].add(_value);
289         Transfer(msg.sender, _to, _value, _data);
290         Transfer(msg.sender, _to, _value);
291         return true;
292     }
293     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
294         require(balanceOf[msg.sender] >= _value);
295         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
296         balanceOf[_to] = balanceOf[_to].add(_value);
297         ContractReceiver receiver = ContractReceiver(_to);
298         receiver.tokenFallback(msg.sender, _value, _data);
299         Transfer(msg.sender, _to, _value, _data);
300         Transfer(msg.sender, _to, _value);
301         return true;
302     }
303     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
304         require(_to != address(0)
305                 && _value > 0
306                 && balanceOf[_from] >= _value
307                 && allowance[_from][msg.sender] >= _value
308                 && frozenAccount[_from] == false
309                 && frozenAccount[_to] == false
310                 && now > unlockUnixTime[_from]
311                 && now > unlockUnixTime[_to]);
312 
313         balanceOf[_from] = balanceOf[_from].sub(_value);
314         balanceOf[_to] = balanceOf[_to].add(_value);
315         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
316         Transfer(_from, _to, _value);
317         return true;
318     }
319     function approve(address _spender, uint256 _value) public returns (bool success) {
320         allowance[msg.sender][_spender] = _value;
321         Approval(msg.sender, _spender, _value);
322         return true;
323     }
324     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
325         return allowance[_owner][_spender];
326     }
327     function burn(address _from, uint256 _unitAmount) onlyOwner public {
328         require(_unitAmount > 0
329                 && balanceOf[_from] >= _unitAmount);
330 
331         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
332         totalSupply = totalSupply.sub(_unitAmount);
333         Burn(_from, _unitAmount);
334     }
335     modifier canMint() {
336         require(!mintingFinished);
337         _;
338     }
339     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
340         require(_unitAmount > 0);
341 
342         totalSupply = totalSupply.add(_unitAmount);
343         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
344         Mint(_to, _unitAmount);
345         Transfer(address(0), _to, _unitAmount);
346         return true;
347     }
348     function finishMinting() onlyOwner canMint public returns (bool) {
349         mintingFinished = true;
350         MintFinished();
351         return true;
352     }
353     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
354         require(amount > 0
355                 && addresses.length > 0
356                 && frozenAccount[msg.sender] == false
357                 && now > unlockUnixTime[msg.sender]);
358 
359         amount = amount.mul(1e8);
360         uint256 totalAmount = amount.mul(addresses.length);
361         require(balanceOf[msg.sender] >= totalAmount);
362 
363         for (uint j = 0; j < addresses.length; j++) {
364             require(addresses[j] != 0x0
365                     && frozenAccount[addresses[j]] == false
366                     && now > unlockUnixTime[addresses[j]]);
367 
368             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
369             Transfer(msg.sender, addresses[j], amount);
370         }
371         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
372         return true;
373     }
374     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
375         require(addresses.length > 0
376                 && addresses.length == amounts.length
377                 && frozenAccount[msg.sender] == false
378                 && now > unlockUnixTime[msg.sender]);
379 
380         uint256 totalAmount = 0;
381 
382         for(uint j = 0; j < addresses.length; j++){
383             require(amounts[j] > 0
384                     && addresses[j] != 0x0
385                     && frozenAccount[addresses[j]] == false
386                     && now > unlockUnixTime[addresses[j]]);
387 
388             amounts[j] = amounts[j].mul(1e8);
389             totalAmount = totalAmount.add(amounts[j]);
390         }
391         require(balanceOf[msg.sender] >= totalAmount);
392 
393         for (j = 0; j < addresses.length; j++) {
394             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
395             Transfer(msg.sender, addresses[j], amounts[j]);
396         }
397         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
398         return true;
399     }
400     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
401         require(addresses.length > 0
402                 && addresses.length == amounts.length);
403 
404         uint256 totalAmount = 0;
405 
406         for (uint j = 0; j < addresses.length; j++) {
407             require(amounts[j] > 0
408                     && addresses[j] != 0x0
409                     && frozenAccount[addresses[j]] == false
410                     && now > unlockUnixTime[addresses[j]]);
411 
412             amounts[j] = amounts[j].mul(1e8);
413             require(balanceOf[addresses[j]] >= amounts[j]);
414             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
415             totalAmount = totalAmount.add(amounts[j]);
416             Transfer(addresses[j], msg.sender, amounts[j]);
417         }
418         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
419         return true;
420     }
421     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
422         distributeAmount = _unitAmount;
423     }
424     function autoDistribute() payable public {
425         require(distributeAmount > 0
426                 && balanceOf[publicityFunds] >= distributeAmount
427                 && frozenAccount[msg.sender] == false
428                 && now > unlockUnixTime[msg.sender]);
429         if(msg.value > 0) publicityFunds.transfer(msg.value);
430 
431         balanceOf[publicityFunds] = balanceOf[publicityFunds].sub(distributeAmount);
432         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
433         Transfer(publicityFunds, msg.sender, distributeAmount);
434     }
435     function() payable public {
436         autoDistribute();
437     }
438 }
439 /* INMCOIN. */