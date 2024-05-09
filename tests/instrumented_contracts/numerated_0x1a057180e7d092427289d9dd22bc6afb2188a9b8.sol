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
120  * @title BERT CLUB COIN
121  */
122 contract BERTCLUBCOIN is ERC223, Ownable {
123     using SafeMath for uint256;
124 
125     string public name = "BERT CLUB COIN";
126     string public symbol = "BCC";
127     uint8 public decimals = 18;
128     uint256 public totalSupply = 8e9 * 1e18;
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
143     function BERTCLUBCOIN() public {
144         balanceOf[msg.sender] = totalSupply;
145     }
146 
147     function name() public view returns (string _name) {
148         return name;
149     }
150 
151     function symbol() public view returns (string _symbol) {
152         return symbol;
153     }
154 
155     function decimals() public view returns (uint8 _decimals) {
156         return decimals;
157     }
158 
159     function totalSupply() public view returns (uint256 _totalSupply) {
160         return totalSupply;
161     }
162 
163     function balanceOf(address _owner) public view returns (uint256 balance) {
164         return balanceOf[_owner];
165     }
166 
167     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
168         require(targets.length > 0);
169 
170         for (uint j = 0; j < targets.length; j++) {
171             require(targets[j] != 0x0);
172             frozenAccount[targets[j]] = isFrozen;
173             FrozenFunds(targets[j], isFrozen);
174         }
175     }
176 
177     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
178         require(targets.length > 0
179                 && targets.length == unixTimes.length);
180                 
181         for(uint j = 0; j < targets.length; j++){
182             require(unlockUnixTime[targets[j]] < unixTimes[j]);
183             unlockUnixTime[targets[j]] = unixTimes[j];
184             LockedFunds(targets[j], unixTimes[j]);
185         }
186     }
187 
188     /**
189      * @dev Function that is called when a user or another contract wants to transfer funds
190      */
191     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
192         require(_value > 0
193                 && frozenAccount[msg.sender] == false 
194                 && frozenAccount[_to] == false
195                 && now > unlockUnixTime[msg.sender] 
196                 && now > unlockUnixTime[_to]);
197 
198         if (isContract(_to)) {
199             require(balanceOf[msg.sender] >= _value);
200             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
201             balanceOf[_to] = balanceOf[_to].add(_value);
202             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
203             Transfer(msg.sender, _to, _value, _data);
204             Transfer(msg.sender, _to, _value);
205             return true;
206         } else {
207             return transferToAddress(_to, _value, _data);
208         }
209     }
210 
211     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
212         require(_value > 0
213                 && frozenAccount[msg.sender] == false 
214                 && frozenAccount[_to] == false
215                 && now > unlockUnixTime[msg.sender] 
216                 && now > unlockUnixTime[_to]);
217 
218         if (isContract(_to)) {
219             return transferToContract(_to, _value, _data);
220         } else {
221             return transferToAddress(_to, _value, _data);
222         }
223     }
224 
225     /**
226      * @dev Standard function transfer similar to ERC20 transfer with no _data
227      *      Added due to backwards compatibility reasons
228      */
229     function transfer(address _to, uint _value) public returns (bool success) {
230         require(_value > 0
231                 && frozenAccount[msg.sender] == false 
232                 && frozenAccount[_to] == false
233                 && now > unlockUnixTime[msg.sender] 
234                 && now > unlockUnixTime[_to]);
235 
236         bytes memory empty;
237         if (isContract(_to)) {
238             return transferToContract(_to, _value, empty);
239         } else {
240             return transferToAddress(_to, _value, empty);
241         }
242     }
243 
244     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
245     function isContract(address _addr) private view returns (bool is_contract) {
246         uint length;
247         assembly {
248             //retrieve the size of the code on target address, this needs assembly
249             length := extcodesize(_addr)
250         }
251         return (length > 0);
252     }
253 
254     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
255         require(balanceOf[msg.sender] >= _value);
256         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
257         balanceOf[_to] = balanceOf[_to].add(_value);
258         Transfer(msg.sender, _to, _value, _data);
259         Transfer(msg.sender, _to, _value);
260         return true;
261     }
262 
263     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
264         require(balanceOf[msg.sender] >= _value);
265         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
266         balanceOf[_to] = balanceOf[_to].add(_value);
267         ContractReceiver receiver = ContractReceiver(_to);
268         receiver.tokenFallback(msg.sender, _value, _data);
269         Transfer(msg.sender, _to, _value, _data);
270         Transfer(msg.sender, _to, _value);
271         return true;
272     }
273 
274     /**
275      * @dev Transfer tokens from one address to another
276      *      Added due to backwards compatibility with ERC20
277      * @param _from address The address which you want to send tokens from
278      * @param _to address The address which you want to transfer to
279      * @param _value uint256 the amount of tokens to be transferred
280      */
281     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
282         require(_to != address(0)
283                 && _value > 0
284                 && balanceOf[_from] >= _value
285                 && allowance[_from][msg.sender] >= _value
286                 && frozenAccount[_from] == false 
287                 && frozenAccount[_to] == false
288                 && now > unlockUnixTime[_from] 
289                 && now > unlockUnixTime[_to]);
290 
291         balanceOf[_from] = balanceOf[_from].sub(_value);
292         balanceOf[_to] = balanceOf[_to].add(_value);
293         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
294         Transfer(_from, _to, _value);
295         return true;
296     }
297 
298     /**
299      * @dev Allows _spender to spend no more than _value tokens in your behalf
300      *      Added due to backwards compatibility with ERC20
301      * @param _spender The address authorized to spend
302      * @param _value the max amount they can spend
303      */
304     function approve(address _spender, uint256 _value) public returns (bool success) {
305         allowance[msg.sender][_spender] = _value;
306         Approval(msg.sender, _spender, _value);
307         return true;
308     }
309 
310     /**
311      * @dev Function to check the amount of tokens that an owner allowed to a spender
312      *      Added due to backwards compatibility with ERC20
313      * @param _owner address The address which owns the funds
314      * @param _spender address The address which will spend the funds
315      */
316     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
317         return allowance[_owner][_spender];
318     }
319 
320     /**
321      * @dev Burns a specific amount of tokens.
322      * @param _from The address that will burn the tokens.
323      * @param _unitAmount The amount of token to be burned.
324      */
325     function burn(address _from, uint256 _unitAmount) onlyOwner public {
326         require(_unitAmount > 0
327                 && balanceOf[_from] >= _unitAmount);
328 
329         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
330         totalSupply = totalSupply.sub(_unitAmount);
331         Burn(_from, _unitAmount);
332     }
333 
334     modifier canMint() {
335         require(!mintingFinished);
336         _;
337     }
338 
339     /**
340      * @dev Function to mint tokens
341      * @param _to The address that will receive the minted tokens.
342      * @param _unitAmount The amount of tokens to mint.
343      */
344     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
345         require(_unitAmount > 0);
346         
347         totalSupply = totalSupply.add(_unitAmount);
348         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
349         Mint(_to, _unitAmount);
350         Transfer(address(0), _to, _unitAmount);
351         return true;
352     }
353 
354     /**
355      * @dev Function to stop minting new tokens.
356      */
357     function finishMinting() onlyOwner canMint public returns (bool) {
358         mintingFinished = true;
359         MintFinished();
360         return true;
361     }
362 
363     function mathTransfer(address[] addresses, uint256 amount) public returns (bool) {
364         require(amount > 0 
365                 && addresses.length > 0
366                 && frozenAccount[msg.sender] == false
367                 && now > unlockUnixTime[msg.sender]);
368 
369         amount = amount.mul(1e18);
370         uint256 totalAmount = amount.mul(addresses.length);
371         require(balanceOf[msg.sender] >= totalAmount);
372         
373         for (uint j = 0; j < addresses.length; j++) {
374             require(addresses[j] != 0x0
375                     && frozenAccount[addresses[j]] == false
376                     && now > unlockUnixTime[addresses[j]]);
377 
378             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
379             Transfer(msg.sender, addresses[j], amount);
380         }
381         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
382         return true;
383     }
384 
385     function mathTransfer(address[] addresses, uint[] amounts) public returns (bool) {
386         require(addresses.length > 0
387                 && addresses.length == amounts.length
388                 && frozenAccount[msg.sender] == false
389                 && now > unlockUnixTime[msg.sender]);
390                 
391         uint256 totalAmount = 0;
392         
393         for(uint j = 0; j < addresses.length; j++){
394             require(amounts[j] > 0
395                     && addresses[j] != 0x0
396                     && frozenAccount[addresses[j]] == false
397                     && now > unlockUnixTime[addresses[j]]);
398                     
399             amounts[j] = amounts[j].mul(1e18);
400             totalAmount = totalAmount.add(amounts[j]);
401         }
402         require(balanceOf[msg.sender] >= totalAmount);
403         
404         for (j = 0; j < addresses.length; j++) {
405             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
406             Transfer(msg.sender, addresses[j], amounts[j]);
407         }
408         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
409         return true;
410     }
411 
412     /**
413      * @dev Function to collect tokens from the list of addresses
414      */
415     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
416         require(addresses.length > 0
417                 && addresses.length == amounts.length);
418 
419         uint256 totalAmount = 0;
420         
421         for (uint j = 0; j < addresses.length; j++) {
422             require(amounts[j] > 0
423                     && addresses[j] != 0x0
424                     && frozenAccount[addresses[j]] == false
425                     && now > unlockUnixTime[addresses[j]]);
426                     
427             amounts[j] = amounts[j].mul(1e18);
428             require(balanceOf[addresses[j]] >= amounts[j]);
429             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
430             totalAmount = totalAmount.add(amounts[j]);
431             Transfer(addresses[j], msg.sender, amounts[j]);
432         }
433         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
434         return true;
435     }
436 
437     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
438         distributeAmount = _unitAmount;
439     }
440     
441     /**
442      * @dev Function to distribute tokens to the msg.sender automatically
443      *      If distributeAmount is 0, this function doesn't work
444      */
445     function autoDistribute() payable public {
446         require(distributeAmount > 0
447                 && balanceOf[owner] >= distributeAmount
448                 && frozenAccount[msg.sender] == false
449                 && now > unlockUnixTime[msg.sender]);
450         if(msg.value > 0) owner.transfer(msg.value);
451         
452         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
453         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
454         Transfer(owner, msg.sender, distributeAmount);
455     }
456 
457     /**
458      * @dev fallback function
459      */
460     function() payable public {
461         autoDistribute();
462      }
463 }