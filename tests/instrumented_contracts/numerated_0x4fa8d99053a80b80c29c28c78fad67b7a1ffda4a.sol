1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 /**
36  * @title Ownable
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the
45      *      sender account.
46      */
47     function Ownable() public {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) onlyOwner public {
64         require(newOwner != address(0));
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67     }
68 }
69 
70 /**
71  * @title ERC223
72  */
73 contract ERC223 {
74     uint public totalSupply;
75 
76     // ERC223 and ERC20 functions and events
77     function balanceOf(address who) public view returns (uint);
78     function totalSupply() public view returns (uint256 _supply);
79     function transfer(address to, uint value) public returns (bool ok);
80     function transfer(address to, uint value, bytes data) public returns (bool ok);
81     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
82     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
83 
84     // ERC223 functions
85     function name() public view returns (string _name);
86     function symbol() public view returns (string _symbol);
87     function decimals() public view returns (uint8 _decimals);
88 
89     // ERC20 functions and events
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
91     function approve(address _spender, uint256 _value) public returns (bool success);
92     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint _value);
95 }
96 
97 /**
98  * @title ContractReceiver
99  */
100  contract ContractReceiver {
101 
102     struct TKN {
103         address sender;
104         uint value;
105         bytes data;
106         bytes4 sig;
107     }
108 
109     function tokenFallback(address _from, uint _value, bytes _data) public pure {
110         TKN memory tkn;
111         tkn.sender = _from;
112         tkn.value = _value;
113         tkn.data = _data;
114         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
115         tkn.sig = bytes4(u);
116     }
117 }
118 
119 /**
120  * @title SHUKIN-PAY
121  */
122 contract SHUKINPAY is ERC223, Ownable {
123     using SafeMath for uint256;
124 
125     string public name = "shukin-pay";
126     string public symbol = "SKPC";
127     uint8 public decimals = 16;
128     uint256 public totalSupply = 30e9 * 1e16;
129     uint256 public distributeAmount = 0;
130     bool public mintingFinished = false;
131     
132     mapping(address => uint256) public balanceOf;
133     mapping(address => mapping (address => uint256)) public allowance;
134     mapping (address => bool) public frozenAccount;
135     mapping (address => uint256) public unlockUnixTime;
136     
137     event FrozenFunds(address indexed target, bool frozen);
138     event LockedFunds(address indexed target, uint256 locked);
139     event Burn(address indexed from, uint256 amount);
140     event Mint(address indexed to, uint256 amount);
141     event MintFinished();
142 
143     /** 
144      * @dev Constructor is called only once and can not be called again
145      */
146     function SHUKINPAY() public {
147         balanceOf[msg.sender] = totalSupply;
148     }
149 
150     function name() public view returns (string _name) {
151         return name;
152     }
153 
154     function symbol() public view returns (string _symbol) {
155         return symbol;
156     }
157 
158     function decimals() public view returns (uint8 _decimals) {
159         return decimals;
160     }
161 
162     function totalSupply() public view returns (uint256 _totalSupply) {
163         return totalSupply;
164     }
165 
166     function balanceOf(address _owner) public view returns (uint256 balance) {
167         return balanceOf[_owner];
168     }
169 
170     /**
171      * @dev Prevent targets from sending or receiving tokens
172      * @param targets Addresses to be frozen
173      * @param isFrozen either to freeze it or not
174      */
175     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
176         require(targets.length > 0);
177 
178         for (uint j = 0; j < targets.length; j++) {
179             require(targets[j] != 0x0);
180             frozenAccount[targets[j]] = isFrozen;
181             FrozenFunds(targets[j], isFrozen);
182         }
183     }
184 
185     /**
186      * @dev Prevent targets from sending or receiving tokens by setting Unix times
187      * @param targets Addresses to be locked funds
188      * @param unixTimes Unix times when locking up will be finished
189      */
190     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
191         require(targets.length > 0
192                 && targets.length == unixTimes.length);
193                 
194         for(uint j = 0; j < targets.length; j++){
195             require(unlockUnixTime[targets[j]] < unixTimes[j]);
196             unlockUnixTime[targets[j]] = unixTimes[j];
197             LockedFunds(targets[j], unixTimes[j]);
198         }
199     }
200 
201     /**
202      * @dev Function that is called when a user or another contract wants to transfer funds
203      */
204     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
205         require(_value > 0
206                 && frozenAccount[msg.sender] == false 
207                 && frozenAccount[_to] == false
208                 && now > unlockUnixTime[msg.sender] 
209                 && now > unlockUnixTime[_to]);
210 
211         if (isContract(_to)) {
212             require(balanceOf[msg.sender] >= _value);
213             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
214             balanceOf[_to] = balanceOf[_to].add(_value);
215             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
216             Transfer(msg.sender, _to, _value, _data);
217             Transfer(msg.sender, _to, _value);
218             return true;
219         } else {
220             return transferToAddress(_to, _value, _data);
221         }
222     }
223 
224     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
225         require(_value > 0
226                 && frozenAccount[msg.sender] == false 
227                 && frozenAccount[_to] == false
228                 && now > unlockUnixTime[msg.sender] 
229                 && now > unlockUnixTime[_to]);
230 
231         if (isContract(_to)) {
232             return transferToContract(_to, _value, _data);
233         } else {
234             return transferToAddress(_to, _value, _data);
235         }
236     }
237 
238     /**
239      * @dev Standard function transfer similar to ERC20 transfer with no _data
240      *      Added due to backwards compatibility reasons
241      */
242     function transfer(address _to, uint _value) public returns (bool success) {
243         require(_value > 0
244                 && frozenAccount[msg.sender] == false 
245                 && frozenAccount[_to] == false
246                 && now > unlockUnixTime[msg.sender] 
247                 && now > unlockUnixTime[_to]);
248 
249         bytes memory empty;
250         if (isContract(_to)) {
251             return transferToContract(_to, _value, empty);
252         } else {
253             return transferToAddress(_to, _value, empty);
254         }
255     }
256 
257     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
258     function isContract(address _addr) private view returns (bool is_contract) {
259         uint length;
260         assembly {
261             //retrieve the size of the code on target address, this needs assembly
262             length := extcodesize(_addr)
263         }
264         return (length > 0);
265     }
266 
267     // function that is called when transaction target is an address
268     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
269         require(balanceOf[msg.sender] >= _value);
270         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
271         balanceOf[_to] = balanceOf[_to].add(_value);
272         Transfer(msg.sender, _to, _value, _data);
273         Transfer(msg.sender, _to, _value);
274         return true;
275     }
276 
277     // function that is called when transaction target is a contract
278     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
279         require(balanceOf[msg.sender] >= _value);
280         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
281         balanceOf[_to] = balanceOf[_to].add(_value);
282         ContractReceiver receiver = ContractReceiver(_to);
283         receiver.tokenFallback(msg.sender, _value, _data);
284         Transfer(msg.sender, _to, _value, _data);
285         Transfer(msg.sender, _to, _value);
286         return true;
287     }
288 
289     /**
290      * @dev Transfer tokens from one address to another
291      *      Added due to backwards compatibility with ERC20
292      * @param _from address The address which you want to send tokens from
293      * @param _to address The address which you want to transfer to
294      * @param _value uint256 the amount of tokens to be transferred
295      */
296     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
297         require(_to != address(0)
298                 && _value > 0
299                 && balanceOf[_from] >= _value
300                 && allowance[_from][msg.sender] >= _value
301                 && frozenAccount[_from] == false 
302                 && frozenAccount[_to] == false
303                 && now > unlockUnixTime[_from] 
304                 && now > unlockUnixTime[_to]);
305 
306         balanceOf[_from] = balanceOf[_from].sub(_value);
307         balanceOf[_to] = balanceOf[_to].add(_value);
308         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
309         Transfer(_from, _to, _value);
310         return true;
311     }
312 
313     /**
314      * @dev Allows _spender to spend no more than _value tokens in your behalf
315      *      Added due to backwards compatibility with ERC20
316      * @param _spender The address authorized to spend
317      * @param _value the max amount they can spend
318      */
319     function approve(address _spender, uint256 _value) public returns (bool success) {
320         allowance[msg.sender][_spender] = _value;
321         Approval(msg.sender, _spender, _value);
322         return true;
323     }
324 
325     /**
326      * @dev Function to check the amount of tokens that an owner allowed to a spender
327      *      Added due to backwards compatibility with ERC20
328      * @param _owner address The address which owns the funds
329      * @param _spender address The address which will spend the funds
330      */
331     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
332         return allowance[_owner][_spender];
333     }
334 
335     /**
336      * @dev Burns a specific amount of tokens.
337      * @param _from The address that will burn the tokens.
338      * @param _unitAmount The amount of token to be burned.
339      */
340     function burn(address _from, uint256 _unitAmount) onlyOwner public {
341         require(_unitAmount > 0
342                 && balanceOf[_from] >= _unitAmount);
343 
344         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
345         totalSupply = totalSupply.sub(_unitAmount);
346         Burn(_from, _unitAmount);
347     }
348 
349     modifier canMint() {
350         require(!mintingFinished);
351         _;
352     }
353 
354     /**
355      * @dev Function to mint tokens
356      * @param _to The address that will receive the minted tokens.
357      * @param _unitAmount The amount of tokens to mint.
358      */
359     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
360         require(_unitAmount > 0);
361         
362         totalSupply = totalSupply.add(_unitAmount);
363         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
364         Mint(_to, _unitAmount);
365         Transfer(address(0), _to, _unitAmount);
366         return true;
367     }
368 
369     /**
370      * @dev Function to stop minting new tokens.
371      */
372     function finishMinting() onlyOwner canMint public returns (bool) {
373         mintingFinished = true;
374         MintFinished();
375         return true;
376     }
377 
378     /**
379      * @dev Function to distribute tokens to the list of addresses by the provided amount
380      */
381     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
382         require(amount > 0 
383                 && addresses.length > 0
384                 && frozenAccount[msg.sender] == false
385                 && now > unlockUnixTime[msg.sender]);
386 
387         amount = amount.mul(1e16);
388         uint256 totalAmount = amount.mul(addresses.length);
389         require(balanceOf[msg.sender] >= totalAmount);
390         
391         for (uint j = 0; j < addresses.length; j++) {
392             require(addresses[j] != 0x0
393                     && frozenAccount[addresses[j]] == false
394                     && now > unlockUnixTime[addresses[j]]);
395 
396             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
397             Transfer(msg.sender, addresses[j], amount);
398         }
399         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
400         return true;
401     }
402 
403     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
404         require(addresses.length > 0
405                 && addresses.length == amounts.length
406                 && frozenAccount[msg.sender] == false
407                 && now > unlockUnixTime[msg.sender]);
408                 
409         uint256 totalAmount = 0;
410         
411         for(uint j = 0; j < addresses.length; j++){
412             require(amounts[j] > 0
413                     && addresses[j] != 0x0
414                     && frozenAccount[addresses[j]] == false
415                     && now > unlockUnixTime[addresses[j]]);
416                     
417             amounts[j] = amounts[j].mul(1e16);
418             totalAmount = totalAmount.add(amounts[j]);
419         }
420         require(balanceOf[msg.sender] >= totalAmount);
421         
422         for (j = 0; j < addresses.length; j++) {
423             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
424             Transfer(msg.sender, addresses[j], amounts[j]);
425         }
426         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
427         return true;
428     }
429 
430     /**
431      * @dev Function to collect tokens from the list of addresses
432      */
433     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
434         require(addresses.length > 0
435                 && addresses.length == amounts.length);
436 
437         uint256 totalAmount = 0;
438         
439         for (uint j = 0; j < addresses.length; j++) {
440             require(amounts[j] > 0
441                     && addresses[j] != 0x0
442                     && frozenAccount[addresses[j]] == false
443                     && now > unlockUnixTime[addresses[j]]);
444                     
445             amounts[j] = amounts[j].mul(1e16);
446             require(balanceOf[addresses[j]] >= amounts[j]);
447             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
448             totalAmount = totalAmount.add(amounts[j]);
449             Transfer(addresses[j], msg.sender, amounts[j]);
450         }
451         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
452         return true;
453     }
454 
455     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
456         distributeAmount = _unitAmount;
457     }
458     
459     /**
460      * @dev Function to distribute tokens to the msg.sender automatically
461      *      If distributeAmount is 0, this function doesn't work
462      */
463     function autoDistribute() payable public {
464         require(distributeAmount > 0
465                 && balanceOf[owner] >= distributeAmount
466                 && frozenAccount[msg.sender] == false
467                 && now > unlockUnixTime[msg.sender]);
468         if(msg.value > 0) owner.transfer(msg.value);
469         
470         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
471         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
472         Transfer(owner, msg.sender, distributeAmount);
473     }
474 
475     /**
476      * @dev fallback function
477      */
478     function() payable public {
479         autoDistribute();
480      }
481 }