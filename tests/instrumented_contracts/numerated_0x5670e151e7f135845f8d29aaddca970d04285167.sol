1 pragma solidity ^0.4.18;
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
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization
39  *      control functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the
48      *      sender account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner public {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 }
72 
73 
74 
75 /**
76  * @title ERC223
77  * @dev ERC223 contract interface with ERC20 functions and events
78  *      Fully backward compatible with ERC20
79  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
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
90     event Transfer(address indexed from, address indexed to, uint value, bytes data);
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
105 /**
106  * @title ContractReceiver
107  * @dev Contract that is working with ERC223 tokens
108  */
109  contract ContractReceiver {
110 
111     struct TKN {
112         address sender;
113         uint value;
114         bytes data;
115         bytes4 sig;
116     }
117 
118     function tokenFallback(address _from, uint _value, bytes _data) public pure {
119         TKN memory tkn;
120         tkn.sender = _from;
121         tkn.value = _value;
122         tkn.data = _data;
123         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
124         tkn.sig = bytes4(u);
125 
126         /*
127          * tkn variable is analogue of msg variable of Ether transaction
128          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
129          * tkn.value the number of tokens that were sent   (analogue of msg.value)
130          * tkn.data is data of token transaction   (analogue of msg.data)
131          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
132          */
133     }
134 }
135 
136 /**
137  * @title SKILL COIN
138  * @author tsk
139  * @dev Skill COIN is an ERC223 Token with ERC20 functions and events
140  *      Fully backward compatible with ERC20
141  */
142 contract SkillCoinTest is ERC223, Ownable {
143     using SafeMath for uint256;
144 
145     string public name = "SKILLCOINtest";
146     string public symbol = "TEST";
147     uint8 public decimals = 18;
148     uint256 public totalSupply = 30e9 * 1e18;
149 
150     address public projectMemberAddress = 0x1Ea27b073Bb648fae5a8ec81E3460146BE8D0763;
151     address public developmentAddress = 0xabC0196253cd173c448A50edc991E041F49d5ee6;
152     address public operatingAddress = 0xD399ca463154F410Db104FC976129De7d1e78126;
153     address public initialSupplyAddress = 0x3a411e42c6ab79aDCCf10946646A6A6a458f6cB2;
154 
155     mapping(address => uint256) public balanceOf;
156     mapping(address => mapping (address => uint256)) public allowance;
157     mapping (address => bool) public frozenAccount;
158     mapping (address => uint256) public unlockUnixTime;
159 
160     event FrozenFunds(address indexed target, bool frozen);
161     event LockedFunds(address indexed target, uint256 locked);
162     event Burn(address indexed from, uint256 amount);
163 
164     /**
165      * @dev Constructor is called only once and can not be called again
166      */
167     function SkillCoinTest() public {
168         owner = msg.sender;
169 
170         balanceOf[msg.sender] = totalSupply.mul(25).div(100);
171         balanceOf[projectMemberAddress] = totalSupply.mul(10).div(100);
172         balanceOf[developmentAddress] = totalSupply.mul(30).div(100);
173         balanceOf[operatingAddress] = totalSupply.mul(10).div(100);
174         balanceOf[initialSupplyAddress] = totalSupply.mul(25).div(100);
175     }
176 
177     function name() public view returns (string _name) {
178         return name;
179     }
180 
181     function symbol() public view returns (string _symbol) {
182         return symbol;
183     }
184 
185     function decimals() public view returns (uint8 _decimals) {
186         return decimals;
187     }
188 
189     function totalSupply() public view returns (uint256 _totalSupply) {
190         return totalSupply;
191     }
192 
193     function balanceOf(address _owner) public view returns (uint256 balance) {
194         return balanceOf[_owner];
195     }
196 
197     /**
198      * @dev Prevent targets from sending or receiving tokens
199      * @param targets Addresses to be frozen
200      * @param isFrozen either to freeze it or not
201      */
202     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
203         require(targets.length > 0);
204 
205         for (uint j = 0; j < targets.length; j++) {
206             require(targets[j] != 0x0);
207             frozenAccount[targets[j]] = isFrozen;
208             FrozenFunds(targets[j], isFrozen);
209         }
210     }
211 
212     /**
213      * @dev Prevent targets from sending or receiving tokens by setting Unix times
214      * @param targets Addresses to be locked funds
215      * @param unixTimes Unix times when locking up will be finished
216      */
217     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
218         require(targets.length > 0
219                 && targets.length == unixTimes.length);
220 
221         for(uint j = 0; j < targets.length; j++){
222             require(unlockUnixTime[targets[j]] < unixTimes[j]);
223             unlockUnixTime[targets[j]] = unixTimes[j];
224             LockedFunds(targets[j], unixTimes[j]);
225         }
226     }
227 
228     /**
229      * @dev Function that is called when a user or another contract wants to transfer funds
230      */
231     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
232         require(_value > 0
233                 && frozenAccount[msg.sender] == false
234                 && frozenAccount[_to] == false
235                 && now > unlockUnixTime[msg.sender]
236                 && now > unlockUnixTime[_to]);
237 
238         if (isContract(_to)) {
239             require(balanceOf[msg.sender] >= _value);
240             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
241             balanceOf[_to] = balanceOf[_to].add(_value);
242             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
243             Transfer(msg.sender, _to, _value, _data);
244             Transfer(msg.sender, _to, _value);
245             return true;
246         } else {
247             return transferToAddress(_to, _value, _data);
248         }
249     }
250 
251     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
252         require(_value > 0
253                 && frozenAccount[msg.sender] == false
254                 && frozenAccount[_to] == false
255                 && now > unlockUnixTime[msg.sender]
256                 && now > unlockUnixTime[_to]);
257 
258         if (isContract(_to)) {
259             return transferToContract(_to, _value, _data);
260         } else {
261             return transferToAddress(_to, _value, _data);
262         }
263     }
264 
265     /**
266      * @dev Standard function transfer similar to ERC20 transfer with no _data
267      *      Added due to backwards compatibility reasons
268      */
269     function transfer(address _to, uint _value) public returns (bool success) {
270         require(_value > 0
271                 && frozenAccount[msg.sender] == false
272                 && frozenAccount[_to] == false
273                 && now > unlockUnixTime[msg.sender]
274                 && now > unlockUnixTime[_to]);
275 
276         bytes memory empty;
277         if (isContract(_to)) {
278             return transferToContract(_to, _value, empty);
279         } else {
280             return transferToAddress(_to, _value, empty);
281         }
282     }
283 
284     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
285     function isContract(address _addr) private view returns (bool is_contract) {
286         uint length;
287         assembly {
288             //retrieve the size of the code on target address, this needs assembly
289             length := extcodesize(_addr)
290         }
291         return (length > 0);
292     }
293 
294     // function that is called when transaction target is an address
295     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
296         require(balanceOf[msg.sender] >= _value);
297         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
298         balanceOf[_to] = balanceOf[_to].add(_value);
299         Transfer(msg.sender, _to, _value, _data);
300         Transfer(msg.sender, _to, _value);
301         return true;
302     }
303 
304     // function that is called when transaction target is a contract
305     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
306         require(balanceOf[msg.sender] >= _value);
307         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
308         balanceOf[_to] = balanceOf[_to].add(_value);
309         ContractReceiver receiver = ContractReceiver(_to);
310         receiver.tokenFallback(msg.sender, _value, _data);
311         Transfer(msg.sender, _to, _value, _data);
312         Transfer(msg.sender, _to, _value);
313         return true;
314     }
315 
316     /**
317      * @dev Transfer tokens from one address to another
318      *      Added due to backwards compatibility with ERC20
319      * @param _from address The address which you want to send tokens from
320      * @param _to address The address which you want to transfer to
321      * @param _value uint256 the amount of tokens to be transferred
322      */
323     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
324         require(_to != address(0)
325                 && _value > 0
326                 && balanceOf[_from] >= _value
327                 && allowance[_from][msg.sender] >= _value
328                 && frozenAccount[_from] == false
329                 && frozenAccount[_to] == false
330                 && now > unlockUnixTime[_from]
331                 && now > unlockUnixTime[_to]);
332 
333         balanceOf[_from] = balanceOf[_from].sub(_value);
334         balanceOf[_to] = balanceOf[_to].add(_value);
335         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
336         Transfer(_from, _to, _value);
337         return true;
338     }
339 
340     /**
341      * @dev Allows _spender to spend no more than _value tokens in your behalf
342      *      Added due to backwards compatibility with ERC20
343      * @param _spender The address authorized to spend
344      * @param _value the max amount they can spend
345      */
346     function approve(address _spender, uint256 _value) public returns (bool success) {
347         allowance[msg.sender][_spender] = _value;
348         Approval(msg.sender, _spender, _value);
349         return true;
350     }
351 
352     /**
353      * @dev Function to check the amount of tokens that an owner allowed to a spender
354      *      Added due to backwards compatibility with ERC20
355      * @param _owner address The address which owns the funds
356      * @param _spender address The address which will spend the funds
357      */
358     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
359         return allowance[_owner][_spender];
360     }
361 
362     /**
363      * @dev Burns a specific amount of tokens.
364      * @param _from The address that will burn the tokens.
365      * @param _unitAmount The amount of token to be burned.
366      */
367     function burn(address _from, uint256 _unitAmount) onlyOwner public {
368         require(_unitAmount > 0
369                 && balanceOf[_from] >= _unitAmount);
370 
371         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
372         totalSupply = totalSupply.sub(_unitAmount);
373         Burn(_from, _unitAmount);
374     }
375 
376     /**
377      * @dev Function to distribute tokens to the list of addresses by the provided amount
378      */
379     function bulkTransfer(address[] addresses, uint256 amount) public returns (bool) {
380         require(amount > 0
381                 && addresses.length > 0
382                 && frozenAccount[msg.sender] == false
383                 && now > unlockUnixTime[msg.sender]);
384 
385         amount = amount.mul(1e18);
386         uint256 totalAmount = amount.mul(addresses.length);
387         require(balanceOf[msg.sender] >= totalAmount);
388 
389         for (uint j = 0; j < addresses.length; j++) {
390             require(addresses[j] != 0x0
391                     && frozenAccount[addresses[j]] == false
392                     && now > unlockUnixTime[addresses[j]]);
393 
394             balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
395             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
396             Transfer(msg.sender, addresses[j], amount);
397         }
398         return true;
399     }
400 
401     function bulkTransfer(address[] addresses, uint256[] amounts) public returns (bool) {
402         require(addresses.length > 0
403                 && addresses.length == amounts.length
404                 && frozenAccount[msg.sender] == false
405                 && now > unlockUnixTime[msg.sender]);
406 
407         uint256 totalAmount = 0;
408 
409         for(uint j = 0; j < addresses.length; j++){
410             require(amounts[j] > 0
411                     && addresses[j] != 0x0
412                     && frozenAccount[addresses[j]] == false
413                     && now > unlockUnixTime[addresses[j]]);
414 
415             amounts[j] = amounts[j].mul(1e18);
416             totalAmount = totalAmount.add(amounts[j]);
417         }
418         require(balanceOf[msg.sender] >= totalAmount);
419 
420         for (j = 0; j < addresses.length; j++) {
421             balanceOf[msg.sender] = balanceOf[msg.sender].sub(amounts[j]);
422             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
423             Transfer(msg.sender, addresses[j], amounts[j]);
424         }
425         return true;
426     }
427 }