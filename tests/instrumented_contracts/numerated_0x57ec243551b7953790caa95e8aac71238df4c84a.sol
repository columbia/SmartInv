1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56 
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     /**
62     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63     * account.
64     */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70     * @dev Throws if called by any account other than the owner.
71     */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78     * @dev Allows the current owner to transfer control of the contract to a newOwner.
79     * @param newOwner The address to transfer ownership to.
80     */
81     function transferOwnership(address newOwner) onlyOwner public {
82         require(newOwner != address(0));
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 /**
90  * ERC223 token by Dexaran
91  *
92  * https://github.com/Dexaran/ERC223-token-standard
93  */
94 
95 /* New ERC223 contract interface */
96 contract ERC223 {
97     uint public totalSupply;
98 
99     // ERC223 and ERC20 functions and events
100     function balanceOf(address who) public view returns (uint);
101     function totalSupply() public view returns (uint256 _supply);
102     function transfer(address to, uint value) public returns (bool ok);
103     function transfer(address to, uint value, bytes data) public returns (bool ok);
104     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
105     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
106 
107     // ERC223 functions
108     function name() public view returns (string _name);
109     function symbol() public view returns (string _symbol);
110     function decimals() public view returns (uint8 _decimals);
111 
112     // ERC20 functions and events
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
114     function approve(address _spender, uint256 _value) public returns (bool success);
115     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
116     event Transfer(address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address indexed _owner, address indexed _spender, uint _value);
118 }
119 
120 /*
121  * Contract that is working with ERC223 tokens
122  */
123 
124 contract ContractReceiver {
125 
126     struct TKN {
127         address sender;
128         uint value;
129         bytes data;
130         bytes4 sig;
131     }
132 
133 
134     function tokenFallback(address _from, uint _value, bytes _data) public pure {
135         TKN memory tkn;
136         tkn.sender = _from;
137         tkn.value = _value;
138         tkn.data = _data;
139         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
140         tkn.sig = bytes4(u);
141 
142         /* tkn variable is analogue of msg variable of Ether transaction
143          *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
144          *  tkn.value the number of tokens that were sent   (analogue of msg.value)
145          *  tkn.data is data of token transaction   (analogue of msg.data)
146          *  tkn.sig is 4 bytes signature of function
147          *  if data of token transaction is a function execution
148          */
149     }
150 }
151 
152 /**
153  * @title ReichaCOIN
154  */
155 contract ReichaCOIN is ERC223, Ownable {
156 
157     using SafeMath for uint256;
158 
159     string public name = "ReichaCOIN";
160     string public symbol = "REI";
161     uint8 public decimals = 8;
162     uint256 public totalSupply = 10000 * 1e8;
163     uint256 public distributeAmount = 0;
164     bool public mintingFinished = false;
165 
166     address public founder = 0x05597a39381A5a050afD22b1Bf339A421cDF7824;
167     address public developerFunds = 0x74215a1cC9BCaAFe9F307a305286AA682FF37210;
168     address public activityFunds = 0x665992c65269bdEa0386DC60ca369DE08D29D829;
169     address public primaryListing = 0x4E669Fe33921da7514c4852e18a4D2faE3364EE4;
170     address public secondaryListing = 0x283b39551C7c1694Afbe52aFA075E4565D4323bF;
171 
172     mapping(address => uint256) public balanceOf;
173     mapping(address => mapping (address => uint256)) public allowance;
174     mapping (address => bool) public frozenAccount;
175     mapping (address => uint256) public unlockUnixTime;
176 
177     event FrozenFunds(address indexed target, bool frozen);
178     event LockedFunds(address indexed target, uint256 locked);
179     event Burn(address indexed from, uint256 amount);
180     event Mint(address indexed to, uint256 amount);
181     event MintFinished();
182 
183     function ReichaCOIN() public {
184         owner = activityFunds;
185 
186         balanceOf[founder] = totalSupply.mul(114514).div(1000000);
187         balanceOf[developerFunds] = totalSupply.mul(1919).div(10000);
188         balanceOf[activityFunds] = totalSupply.mul(810).div(10000);
189         balanceOf[primaryListing] = totalSupply.mul(12586).div(1000000);
190         balanceOf[secondaryListing] = totalSupply.mul(60).div(100);
191 
192     }
193 
194     function name() public view returns (string _name) {
195         return name;
196     }
197     function symbol() public view returns (string _symbol) {
198         return symbol;
199     }
200     function decimals() public view returns (uint8 _decimals) {
201         return decimals;
202     }
203     function totalSupply() public view returns (uint256 _totalSupply) {
204         return totalSupply;
205     }
206     function balanceOf(address _owner) public view returns (uint256 balance) {
207         return balanceOf[_owner];
208     }
209     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
210         require(targets.length > 0);
211 
212         for (uint j = 0; j < targets.length; j++) {
213             require(targets[j] != 0x0);
214             frozenAccount[targets[j]] = isFrozen;
215             FrozenFunds(targets[j], isFrozen);
216         }
217     }
218     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
219         require(targets.length > 0 && targets.length == unixTimes.length);
220 
221         for(uint j = 0; j < targets.length; j++){
222             require(unlockUnixTime[targets[j]] < unixTimes[j]);
223             unlockUnixTime[targets[j]] = unixTimes[j];
224             LockedFunds(targets[j], unixTimes[j]);
225         }
226     }
227     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
228         require(_value > 0
229                 && frozenAccount[msg.sender] == false
230                 && frozenAccount[_to] == false
231                 && now > unlockUnixTime[msg.sender]
232                 && now > unlockUnixTime[_to]);
233         if (isContract(_to)) {
234             require(balanceOf[msg.sender] >= _value);
235             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
236             balanceOf[_to] = balanceOf[_to].add(_value);
237             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
238             Transfer(msg.sender, _to, _value, _data);
239             Transfer(msg.sender, _to, _value);
240             return true;
241         } else {
242             return transferToAddress(_to, _value, _data);
243         }
244     }
245     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
246         require(_value > 0
247                 && frozenAccount[msg.sender] == false
248                 && frozenAccount[_to] == false
249                 && now > unlockUnixTime[msg.sender]
250                 && now > unlockUnixTime[_to]);
251         if (isContract(_to)) {
252             return transferToContract(_to, _value, _data);
253         } else {
254             return transferToAddress(_to, _value, _data);
255         }
256     }
257     function transfer(address _to, uint _value) public returns (bool success) {
258         require(_value > 0
259                 && frozenAccount[msg.sender] == false
260                 && frozenAccount[_to] == false
261                 && now > unlockUnixTime[msg.sender]
262                 && now > unlockUnixTime[_to]);
263         bytes memory empty;
264         if (isContract(_to)) {
265             return transferToContract(_to, _value, empty);
266         } else {
267             return transferToAddress(_to, _value, empty);
268         }
269     }
270     function isContract(address _addr) private view returns (bool is_contract) {
271         uint length;
272         assembly {
273             length := extcodesize(_addr)
274         }
275         return (length > 0);
276     }
277     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
278         require(balanceOf[msg.sender] >= _value);
279         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
280         balanceOf[_to] = balanceOf[_to].add(_value);
281         Transfer(msg.sender, _to, _value, _data);
282         Transfer(msg.sender, _to, _value);
283         return true;
284     }
285     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
286         require(balanceOf[msg.sender] >= _value);
287         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
288         balanceOf[_to] = balanceOf[_to].add(_value);
289         ContractReceiver receiver = ContractReceiver(_to);
290         receiver.tokenFallback(msg.sender, _value, _data);
291         Transfer(msg.sender, _to, _value, _data);
292         Transfer(msg.sender, _to, _value);
293         return true;
294     }
295     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
296         require(_to != address(0)
297                 && _value > 0
298                 && balanceOf[_from] >= _value
299                 && allowance[_from][msg.sender] >= _value
300                 && frozenAccount[_from] == false
301                 && frozenAccount[_to] == false
302                 && now > unlockUnixTime[_from]
303                 && now > unlockUnixTime[_to]);
304 
305         balanceOf[_from] = balanceOf[_from].sub(_value);
306         balanceOf[_to] = balanceOf[_to].add(_value);
307         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
308         Transfer(_from, _to, _value);
309         return true;
310     }
311     function approve(address _spender, uint256 _value) public returns (bool success) {
312         allowance[msg.sender][_spender] = _value;
313         Approval(msg.sender, _spender, _value);
314         return true;
315     }
316     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
317         return allowance[_owner][_spender];
318     }
319     function burn(address _from, uint256 _unitAmount) onlyOwner public {
320         require(_unitAmount > 0
321                 && balanceOf[_from] >= _unitAmount);
322 
323         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
324         totalSupply = totalSupply.sub(_unitAmount);
325         Burn(_from, _unitAmount);
326     }
327     modifier canMint() {
328         require(!mintingFinished);
329         _;
330     }
331     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
332         require(_unitAmount > 0);
333 
334         totalSupply = totalSupply.add(_unitAmount);
335         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
336         Mint(_to, _unitAmount);
337         Transfer(address(0), _to, _unitAmount);
338         return true;
339     }
340     function finishMinting() onlyOwner canMint public returns (bool) {
341         mintingFinished = true;
342         MintFinished();
343         return true;
344     }
345     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
346         require(amount > 0
347                 && addresses.length > 0
348                 && frozenAccount[msg.sender] == false
349                 && now > unlockUnixTime[msg.sender]);
350 
351         amount = amount.mul(1e8);
352         uint256 totalAmount = amount.mul(addresses.length);
353         require(balanceOf[msg.sender] >= totalAmount);
354 
355         for (uint j = 0; j < addresses.length; j++) {
356             require(addresses[j] != 0x0
357                     && frozenAccount[addresses[j]] == false
358                     && now > unlockUnixTime[addresses[j]]);
359 
360             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
361             Transfer(msg.sender, addresses[j], amount);
362         }
363         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
364         return true;
365     }
366     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
367         require(addresses.length > 0
368                 && addresses.length == amounts.length
369                 && frozenAccount[msg.sender] == false
370                 && now > unlockUnixTime[msg.sender]);
371 
372         uint256 totalAmount = 0;
373 
374         for(uint j = 0; j < addresses.length; j++){
375             require(amounts[j] > 0
376                     && addresses[j] != 0x0
377                     && frozenAccount[addresses[j]] == false
378                     && now > unlockUnixTime[addresses[j]]);
379 
380             amounts[j] = amounts[j].mul(1e8);
381             totalAmount = totalAmount.add(amounts[j]);
382         }
383         require(balanceOf[msg.sender] >= totalAmount);
384 
385         for (j = 0; j < addresses.length; j++) {
386             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
387             Transfer(msg.sender, addresses[j], amounts[j]);
388         }
389         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
390         return true;
391     }
392     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
393         require(addresses.length > 0
394                 && addresses.length == amounts.length);
395 
396         uint256 totalAmount = 0;
397 
398         for (uint j = 0; j < addresses.length; j++) {
399             require(amounts[j] > 0
400                     && addresses[j] != 0x0
401                     && frozenAccount[addresses[j]] == false
402                     && now > unlockUnixTime[addresses[j]]);
403 
404             amounts[j] = amounts[j].mul(1e8);
405             require(balanceOf[addresses[j]] >= amounts[j]);
406             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
407             totalAmount = totalAmount.add(amounts[j]);
408             Transfer(addresses[j], msg.sender, amounts[j]);
409         }
410         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
411         return true;
412     }
413     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
414         distributeAmount = _unitAmount;
415     }
416     function autoDistribute() payable public {
417         require(distributeAmount > 0
418                 && balanceOf[activityFunds] >= distributeAmount
419                 && frozenAccount[msg.sender] == false
420                 && now > unlockUnixTime[msg.sender]);
421         if(msg.value > 0) activityFunds.transfer(msg.value);
422 
423         balanceOf[activityFunds] = balanceOf[activityFunds].sub(distributeAmount);
424         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
425         Transfer(activityFunds, msg.sender, distributeAmount);
426     }
427     function() payable public {
428         autoDistribute();
429     }
430 }