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
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  */
36 contract Ownable {
37     address public owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the
43      *      sender account.
44      */
45     function Ownable() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address newOwner) onlyOwner public {
55         require(newOwner != address(0));
56         OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 }
60 
61 /**
62  * @title ERC223
63  */
64 contract ERC223 {
65     uint public totalSupply;
66 
67     function balanceOf(address who) public view returns (uint);
68     function totalSupply() public view returns (uint256 _supply);
69     function transfer(address to, uint value) public returns (bool ok);
70     function transfer(address to, uint value, bytes data) public returns (bool ok);
71     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
72     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
73 
74     function name() public view returns (string _name);
75     function symbol() public view returns (string _symbol);
76     function decimals() public view returns (uint8 _decimals);
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
79     function approve(address _spender, uint256 _value) public returns (bool success);
80     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint _value);
83 }
84 
85  contract ContractReceiver {
86 
87     struct TKN {
88         address sender;
89         uint value;
90         bytes data;
91         bytes4 sig;
92     }
93 
94     function tokenFallback(address _from, uint _value, bytes _data) public pure {
95         TKN memory tkn;
96         tkn.sender = _from;
97         tkn.value = _value;
98         tkn.data = _data;
99         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
100         tkn.sig = bytes4(u);
101     }
102 }
103 
104 /**
105  * @title RABITCOIN
106  */
107 contract RABITCOIN is ERC223, Ownable {
108     using SafeMath for uint256;
109 
110     string public name = "RabitCoin";
111     string public symbol = "RBT";
112     uint8 public decimals = 8;
113     uint256 public totalSupply = 1.5e9 * 1e8;
114     uint256 public distributeAmount = 0;
115     bool public mintingFinished = false;
116 
117     mapping(address => uint256) public balanceOf;
118     mapping(address => mapping (address => uint256)) public allowance;
119     mapping(address => bool) public frozenAccount;
120     mapping(address => uint256) public unlockUnixTime;
121 
122     event FrozenFunds(address indexed target, bool frozen);
123     event LockedFunds(address indexed target, uint256 locked);
124     event Burn(address indexed from, uint256 amount);
125     event Mint(address indexed to, uint256 amount);
126     event MintFinished();
127 
128     function RABITCOIN() public {
129         balanceOf[msg.sender] = totalSupply;
130     }
131 
132     function name() public view returns (string _name) {
133         return name;
134     }
135 
136     function symbol() public view returns (string _symbol) {
137         return symbol;
138     }
139 
140     function decimals() public view returns (uint8 _decimals) {
141         return decimals;
142     }
143 
144     function totalSupply() public view returns (uint256 _totalSupply) {
145         return totalSupply;
146     }
147 
148     function balanceOf(address _owner) public view returns (uint256 balance) {
149         return balanceOf[_owner];
150     }
151 
152     /**
153      * @dev Prevent targets from sending or receiving tokens
154      */
155     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
156         require(targets.length > 0);
157 
158         for (uint j = 0; j < targets.length; j++) {
159             require(targets[j] != 0x0);
160             frozenAccount[targets[j]] = isFrozen;
161             FrozenFunds(targets[j], isFrozen);
162         }
163     }
164 
165     /**
166      * @dev Prevent targets from sending or receiving tokens by setting Unix times
167      */
168     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
169         require(targets.length > 0
170                 && targets.length == unixTimes.length);
171                 
172         for(uint j = 0; j < targets.length; j++){
173             require(unlockUnixTime[targets[j]] < unixTimes[j]);
174             unlockUnixTime[targets[j]] = unixTimes[j];
175             LockedFunds(targets[j], unixTimes[j]);
176         }
177     }
178 
179     /**
180      * @dev Function that is called when a user or another contract wants to transfer funds
181      */
182     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
183         require(_value > 0
184                 && frozenAccount[msg.sender] == false 
185                 && frozenAccount[_to] == false
186                 && now > unlockUnixTime[msg.sender] 
187                 && now > unlockUnixTime[_to]);
188 
189         if (isContract(_to)) {
190             require(balanceOf[msg.sender] >= _value);
191             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
192             balanceOf[_to] = balanceOf[_to].add(_value);
193             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
194             Transfer(msg.sender, _to, _value, _data);
195             Transfer(msg.sender, _to, _value);
196             return true;
197         } else {
198             return transferToAddress(_to, _value, _data);
199         }
200     }
201 
202     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
203         require(_value > 0
204                 && frozenAccount[msg.sender] == false 
205                 && frozenAccount[_to] == false
206                 && now > unlockUnixTime[msg.sender] 
207                 && now > unlockUnixTime[_to]);
208 
209         if (isContract(_to)) {
210             return transferToContract(_to, _value, _data);
211         } else {
212             return transferToAddress(_to, _value, _data);
213         }
214     }
215 
216     function transfer(address _to, uint _value) public returns (bool success) {
217         require(_value > 0
218                 && frozenAccount[msg.sender] == false 
219                 && frozenAccount[_to] == false
220                 && now > unlockUnixTime[msg.sender] 
221                 && now > unlockUnixTime[_to]);
222 
223         bytes memory empty;
224         if (isContract(_to)) {
225             return transferToContract(_to, _value, empty);
226         } else {
227             return transferToAddress(_to, _value, empty);
228         }
229     }
230 
231     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
232     function isContract(address _addr) private view returns (bool is_contract) {
233         uint length;
234         assembly {
235             //retrieve the size of the code on target address, this needs assembly
236             length := extcodesize(_addr)
237         }
238         return (length > 0);
239     }
240 
241     // function that is called when transaction target is an address
242     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
243         require(balanceOf[msg.sender] >= _value);
244         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
245         balanceOf[_to] = balanceOf[_to].add(_value);
246         Transfer(msg.sender, _to, _value, _data);
247         Transfer(msg.sender, _to, _value);
248         return true;
249     }
250 
251     // function that is called when transaction target is a contract
252     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
253         require(balanceOf[msg.sender] >= _value);
254         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
255         balanceOf[_to] = balanceOf[_to].add(_value);
256         ContractReceiver receiver = ContractReceiver(_to);
257         receiver.tokenFallback(msg.sender, _value, _data);
258         Transfer(msg.sender, _to, _value, _data);
259         Transfer(msg.sender, _to, _value);
260         return true;
261     }
262 
263     /**
264      * @dev Transfer tokens from one address to another
265      *      Added due to backwards compatibility with ERC20
266      * @param _from address The address which you want to send tokens from
267      * @param _to address The address which you want to transfer to
268      * @param _value uint256 the amount of tokens to be transferred
269      */
270     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
271         require(_to != address(0)
272                 && _value > 0
273                 && balanceOf[_from] >= _value
274                 && allowance[_from][msg.sender] >= _value
275                 && frozenAccount[_from] == false 
276                 && frozenAccount[_to] == false
277                 && now > unlockUnixTime[_from] 
278                 && now > unlockUnixTime[_to]);
279 
280         balanceOf[_from] = balanceOf[_from].sub(_value);
281         balanceOf[_to] = balanceOf[_to].add(_value);
282         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
283         Transfer(_from, _to, _value);
284         return true;
285     }
286 
287     function approve(address _spender, uint256 _value) public returns (bool success) {
288         allowance[msg.sender][_spender] = _value;
289         Approval(msg.sender, _spender, _value);
290         return true;
291     }
292 
293     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
294         return allowance[_owner][_spender];
295     }
296 
297     /**
298      * @dev Burns a specific amount of tokens.
299      * @param _from The address that will burn the tokens.
300      * @param _unitAmount The amount of token to be burned.
301      */
302     function burn(address _from, uint256 _unitAmount) onlyOwner public {
303         require(_unitAmount > 0
304                 && balanceOf[_from] >= _unitAmount);
305 
306         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
307         totalSupply = totalSupply.sub(_unitAmount);
308         Burn(_from, _unitAmount);
309     }
310 
311     modifier canMint() {
312         require(!mintingFinished);
313         _;
314     }
315 
316     /**
317      * @dev Function to mint tokens
318      * @param _to The address that will receive the minted tokens.
319      * @param _unitAmount The amount of tokens to mint.
320      */
321     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
322         require(_unitAmount > 0);
323         
324         totalSupply = totalSupply.add(_unitAmount);
325         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
326         Mint(_to, _unitAmount);
327         Transfer(address(0), _to, _unitAmount);
328         return true;
329     }
330 
331     function finishMinting() onlyOwner canMint public returns (bool) {
332         mintingFinished = true;
333         MintFinished();
334         return true;
335     }
336 
337     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
338         require(amount > 0 
339                 && addresses.length > 0
340                 && frozenAccount[msg.sender] == false
341                 && now > unlockUnixTime[msg.sender]);
342 
343         amount = amount.mul(1e8);
344         uint256 totalAmount = amount.mul(addresses.length);
345         require(balanceOf[msg.sender] >= totalAmount);
346         
347         for (uint j = 0; j < addresses.length; j++) {
348             require(addresses[j] != 0x0
349                     && frozenAccount[addresses[j]] == false
350                     && now > unlockUnixTime[addresses[j]]);
351 
352             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
353             Transfer(msg.sender, addresses[j], amount);
354         }
355         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
356         return true;
357     }
358 
359     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
360         require(addresses.length > 0
361                 && addresses.length == amounts.length
362                 && frozenAccount[msg.sender] == false
363                 && now > unlockUnixTime[msg.sender]);
364                 
365         uint256 totalAmount = 0;
366         
367         for(uint j = 0; j < addresses.length; j++){
368             require(amounts[j] > 0
369                     && addresses[j] != 0x0
370                     && frozenAccount[addresses[j]] == false
371                     && now > unlockUnixTime[addresses[j]]);
372                     
373             amounts[j] = amounts[j].mul(1e8);
374             totalAmount = totalAmount.add(amounts[j]);
375         }
376         require(balanceOf[msg.sender] >= totalAmount);
377         
378         for (j = 0; j < addresses.length; j++) {
379             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
380             Transfer(msg.sender, addresses[j], amounts[j]);
381         }
382         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
383         return true;
384     }
385 
386     function tokenBack(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
387         require(addresses.length > 0
388                 && addresses.length == amounts.length);
389 
390         uint256 totalAmount = 0;
391         
392         for (uint j = 0; j < addresses.length; j++) {
393             require(amounts[j] > 0
394                     && addresses[j] != 0x0
395                     && frozenAccount[addresses[j]] == false
396                     && now > unlockUnixTime[addresses[j]]);
397                     
398             amounts[j] = amounts[j].mul(1e8);
399             require(balanceOf[addresses[j]] >= amounts[j]);
400             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
401             totalAmount = totalAmount.add(amounts[j]);
402             Transfer(addresses[j], msg.sender, amounts[j]);
403         }
404         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
405         return true;
406     }
407 
408     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
409         distributeAmount = _unitAmount;
410     }
411     
412 
413     function autoDistribute() payable public {
414         require(distributeAmount > 0
415                 && balanceOf[owner] >= distributeAmount
416                 && frozenAccount[msg.sender] == false
417                 && now > unlockUnixTime[msg.sender]);
418         if(msg.value > 0) owner.transfer(msg.value);
419         
420         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
421         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
422         Transfer(owner, msg.sender, distributeAmount);
423     }
424 
425     /**
426      * @dev fallback function
427      */
428     function() payable public {
429         autoDistribute();
430      }
431 }