1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     address public owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49     * account.
50     */
51     function Ownable() public {
52         owner = msg.sender;
53     }
54 
55     /**
56     * @dev Throws if called by any account other than the owner.
57     */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     /**
64     * @dev Allows the current owner to transfer control of the contract to a newOwner.
65     * @param newOwner The address to transfer ownership to.
66     */
67     function transferOwnership(address newOwner) onlyOwner public {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 
75 
76 /**
77  * @title ERC223
78  *
79  * https://github.com/Dexaran/ERC223-token-standard
80  */
81 contract ERC223 {
82     uint public totalSupply;
83 
84     // ERC223 and ERC20 functions and events
85     function balanceOf(address who) public view returns (uint);
86     function totalSupply() public view returns (uint256 _supply);
87     function transfer(address to, uint value) public returns (bool ok);
88     function transfer(address to, uint value, bytes data) public returns (bool ok);
89     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
90     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
91 
92     // ERC223 functions
93     function name() public view returns (string _name);
94     function symbol() public view returns (string _symbol);
95     function decimals() public view returns (uint8 _decimals);
96 
97     // ERC20 functions and events
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
99     function approve(address _spender, uint256 _value) public returns (bool success);
100     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
101     event Transfer(address indexed _from, address indexed _to, uint256 _value);
102     event Approval(address indexed _owner, address indexed _spender, uint _value);
103 }
104 
105 
106 /*
107  * @title ContractReceiver
108  * Contract that is working with ERC223 tokens
109  */
110 contract ContractReceiver {
111 
112     struct TKN {
113         address sender;
114         uint value;
115         bytes data;
116         bytes4 sig;
117     }
118 
119 
120     function tokenFallback(address _from, uint _value, bytes _data) public pure {
121         TKN memory tkn;
122         tkn.sender = _from;
123         tkn.value = _value;
124         tkn.data = _data;
125         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
126         tkn.sig = bytes4(u);
127 
128         /* tkn variable is analogue of msg variable of Ether transaction
129          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
130          * tkn.value the number of tokens that were sent   (analogue of msg.value)
131          * tkn.data is data of token transaction   (analogue of msg.data)
132          * tkn.sig is 4 bytes signature of function
133          * if data of token transaction is a function execution
134          */
135     }
136 }
137 
138 
139 /**
140  * @title ExhaustionCoin
141  */
142 contract ExhaustionCoin is ERC223, Ownable {
143 
144     using SafeMath for uint256;
145 
146     string public name = "ExhaustionCoin";
147     string public symbol = "EXST";
148     uint8 public decimals = 8;
149     uint256 public totalSupply = 500e9 * 1e8;
150     uint256 public distributeAmount = 0;
151     bool public mintingFinished = false;
152 
153     address public Addr1 = 0x68FF231F1AF6e982437a157db8DeddCf91878220;
154     address public Addr2 = 0x97D3b60C2266484F415B7549B8E8fd73a66BF5e7;
155     address public Addr3 = 0xaadA9D72f0b560f47B7e19eE26A6fBB78566CA24;
156     address public Addr4 = 0xE7A55Cf0642A497921b67893D5a7cDF51B389f46;
157     address public Addr5 = 0x55BA76b349669fF87367D98e7767C38396677aA3;
158     address public Addr6 = 0xedF3dC209d58f7C05b7f5dC807F28A2835bC987a;
159     address public Addr7 = 0x19839dC3b6981Fc511dc00fEc42C5aE549Eb51cD;
160 
161     mapping(address => uint256) public balanceOf;
162     mapping(address => mapping (address => uint256)) public allowance;
163     mapping (address => bool) public frozenAccount;
164     mapping (address => uint256) public unlockUnixTime;
165 
166     event FrozenFunds(address indexed target, bool frozen);
167     event LockedFunds(address indexed target, uint256 locked);
168     event Burn(address indexed from, uint256 amount);
169     event Mint(address indexed to, uint256 amount);
170     event MintFinished();
171 
172     function ExhaustionCoin() public {
173         owner = Addr1;
174 
175         balanceOf[Addr1] = totalSupply.mul(20).div(100);
176         balanceOf[Addr2] = totalSupply.mul(10).div(100);
177         balanceOf[Addr3] = totalSupply.mul(10).div(100);
178         balanceOf[Addr4] = totalSupply.mul(20).div(100);
179         balanceOf[Addr5] = totalSupply.mul(20).div(100);
180         balanceOf[Addr6] = totalSupply.mul(10).div(100);
181         balanceOf[Addr7] = totalSupply.mul(10).div(100);
182 
183     }
184 
185     function name() public view returns (string _name) {
186         return name;
187     }
188     function symbol() public view returns (string _symbol) {
189         return symbol;
190     }
191     function decimals() public view returns (uint8 _decimals) {
192         return decimals;
193     }
194     function totalSupply() public view returns (uint256 _totalSupply) {
195         return totalSupply;
196     }
197     function balanceOf(address _owner) public view returns (uint256 balance) {
198         return balanceOf[_owner];
199     }
200     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
201         require(targets.length > 0);
202 
203         for (uint j = 0; j < targets.length; j++) {
204             require(targets[j] != 0x0);
205             frozenAccount[targets[j]] = isFrozen;
206             FrozenFunds(targets[j], isFrozen);
207         }
208     }
209     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
210         require(targets.length > 0 && targets.length == unixTimes.length);
211 
212         for(uint j = 0; j < targets.length; j++){
213             require(unlockUnixTime[targets[j]] < unixTimes[j]);
214             unlockUnixTime[targets[j]] = unixTimes[j];
215             LockedFunds(targets[j], unixTimes[j]);
216         }
217     }
218     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
219         require(_value > 0
220                 && frozenAccount[msg.sender] == false
221                 && frozenAccount[_to] == false
222                 && now > unlockUnixTime[msg.sender]
223                 && now > unlockUnixTime[_to]);
224         if (isContract(_to)) {
225             require(balanceOf[msg.sender] >= _value);
226             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
227             balanceOf[_to] = balanceOf[_to].add(_value);
228             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
229             Transfer(msg.sender, _to, _value, _data);
230             Transfer(msg.sender, _to, _value);
231             return true;
232         } else {
233             return transferToAddress(_to, _value, _data);
234         }
235     }
236     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
237         require(_value > 0
238                 && frozenAccount[msg.sender] == false
239                 && frozenAccount[_to] == false
240                 && now > unlockUnixTime[msg.sender]
241                 && now > unlockUnixTime[_to]);
242         if (isContract(_to)) {
243             return transferToContract(_to, _value, _data);
244         } else {
245             return transferToAddress(_to, _value, _data);
246         }
247     }
248     function transfer(address _to, uint _value) public returns (bool success) {
249         require(_value > 0
250                 && frozenAccount[msg.sender] == false
251                 && frozenAccount[_to] == false
252                 && now > unlockUnixTime[msg.sender]
253                 && now > unlockUnixTime[_to]);
254         bytes memory empty;
255         if (isContract(_to)) {
256             return transferToContract(_to, _value, empty);
257         } else {
258             return transferToAddress(_to, _value, empty);
259         }
260     }
261     function isContract(address _addr) private view returns (bool is_contract) {
262         uint length;
263         assembly {
264             length := extcodesize(_addr)
265         }
266         return (length > 0);
267     }
268     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
269         require(balanceOf[msg.sender] >= _value);
270         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
271         balanceOf[_to] = balanceOf[_to].add(_value);
272         Transfer(msg.sender, _to, _value, _data);
273         Transfer(msg.sender, _to, _value);
274         return true;
275     }
276     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
277         require(balanceOf[msg.sender] >= _value);
278         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
279         balanceOf[_to] = balanceOf[_to].add(_value);
280         ContractReceiver receiver = ContractReceiver(_to);
281         receiver.tokenFallback(msg.sender, _value, _data);
282         Transfer(msg.sender, _to, _value, _data);
283         Transfer(msg.sender, _to, _value);
284         return true;
285     }
286     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
287         require(_to != address(0)
288                 && _value > 0
289                 && balanceOf[_from] >= _value
290                 && allowance[_from][msg.sender] >= _value
291                 && frozenAccount[_from] == false
292                 && frozenAccount[_to] == false
293                 && now > unlockUnixTime[_from]
294                 && now > unlockUnixTime[_to]);
295 
296         balanceOf[_from] = balanceOf[_from].sub(_value);
297         balanceOf[_to] = balanceOf[_to].add(_value);
298         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
299         Transfer(_from, _to, _value);
300         return true;
301     }
302     function approve(address _spender, uint256 _value) public returns (bool success) {
303         allowance[msg.sender][_spender] = _value;
304         Approval(msg.sender, _spender, _value);
305         return true;
306     }
307     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
308         return allowance[_owner][_spender];
309     }
310     function burn(address _from, uint256 _unitAmount) onlyOwner public {
311         require(_unitAmount > 0
312                 && balanceOf[_from] >= _unitAmount);
313 
314         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
315         totalSupply = totalSupply.sub(_unitAmount);
316         Burn(_from, _unitAmount);
317     }
318     modifier canMint() {
319         require(!mintingFinished);
320         _;
321     }
322     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
323         require(_unitAmount > 0);
324 
325         totalSupply = totalSupply.add(_unitAmount);
326         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
327         Mint(_to, _unitAmount);
328         Transfer(address(0), _to, _unitAmount);
329         return true;
330     }
331     function finishMinting() onlyOwner canMint public returns (bool) {
332         mintingFinished = true;
333         MintFinished();
334         return true;
335     }
336     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
337         require(amount > 0
338                 && addresses.length > 0
339                 && frozenAccount[msg.sender] == false
340                 && now > unlockUnixTime[msg.sender]);
341 
342         amount = amount.mul(1e8);
343         uint256 totalAmount = amount.mul(addresses.length);
344         require(balanceOf[msg.sender] >= totalAmount);
345 
346         for (uint j = 0; j < addresses.length; j++) {
347             require(addresses[j] != 0x0
348                     && frozenAccount[addresses[j]] == false
349                     && now > unlockUnixTime[addresses[j]]);
350 
351             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
352             Transfer(msg.sender, addresses[j], amount);
353         }
354         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
355         return true;
356     }
357     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
358         require(addresses.length > 0
359                 && addresses.length == amounts.length
360                 && frozenAccount[msg.sender] == false
361                 && now > unlockUnixTime[msg.sender]);
362 
363         uint256 totalAmount = 0;
364 
365         for(uint j = 0; j < addresses.length; j++){
366             require(amounts[j] > 0
367                     && addresses[j] != 0x0
368                     && frozenAccount[addresses[j]] == false
369                     && now > unlockUnixTime[addresses[j]]);
370 
371             amounts[j] = amounts[j].mul(1e8);
372             totalAmount = totalAmount.add(amounts[j]);
373         }
374         require(balanceOf[msg.sender] >= totalAmount);
375 
376         for (j = 0; j < addresses.length; j++) {
377             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
378             Transfer(msg.sender, addresses[j], amounts[j]);
379         }
380         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
381         return true;
382     }
383     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
384         require(addresses.length > 0
385                 && addresses.length == amounts.length);
386 
387         uint256 totalAmount = 0;
388 
389         for (uint j = 0; j < addresses.length; j++) {
390             require(amounts[j] > 0
391                     && addresses[j] != 0x0
392                     && frozenAccount[addresses[j]] == false
393                     && now > unlockUnixTime[addresses[j]]);
394 
395             amounts[j] = amounts[j].mul(1e8);
396             require(balanceOf[addresses[j]] >= amounts[j]);
397             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
398             totalAmount = totalAmount.add(amounts[j]);
399             Transfer(addresses[j], msg.sender, amounts[j]);
400         }
401         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
402         return true;
403     }
404     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
405         distributeAmount = _unitAmount;
406     }
407     function autoDistribute() payable public {
408         require(distributeAmount > 0
409                 && balanceOf[Addr1] >= distributeAmount
410                 && frozenAccount[msg.sender] == false
411                 && now > unlockUnixTime[msg.sender]);
412         if(msg.value > 0) Addr1.transfer(msg.value);
413 
414         balanceOf[Addr1] = balanceOf[Addr1].sub(distributeAmount);
415         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
416         Transfer(Addr1, msg.sender, distributeAmount);
417     }
418     function() payable public {
419         autoDistribute();
420     }
421 }