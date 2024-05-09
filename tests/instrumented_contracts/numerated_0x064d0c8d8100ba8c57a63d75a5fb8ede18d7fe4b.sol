1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9 	function mul(uint256 x, uint256 y) internal pure returns (uint256) {
10 		if (x == 0) {
11 			return 0;
12 		}
13 		uint256 z = x * y;
14 		assert(z / x == y);
15 		return z;
16 	}
17 	
18 	function div(uint256 x, uint256 y) internal pure returns (uint256) {
19 	    // assert(y > 0);//Solidity automatically throws when dividing by 0 
20 	    uint256 z = x / y;
21 	    // assert(x == y * z + x % y); // There is no case in which this doesn`t hold
22 	    return z;
23 	}
24 	
25 	function sub(uint256 x, uint256 y) internal pure returns (uint256) {
26 	    assert(y <= x);
27 	    return x - y;
28 	}
29 	
30 	function add(uint256 x, uint256 y) internal pure returns (uint256) {
31 	    uint256 z = x + y;
32 	    assert(z >= x);
33 	    return z;
34 	}
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization
40  *      control function,this simplifies the implementation of "user permissions".
41  */
42  
43  contract Ownable {
44      address public owner;
45      
46      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47      
48      /**
49       * 
50       * @dev The Ownable constructor sets the original 'owner' of the contract to the
51       *         sender account.
52       */
53       
54      function Ownable() public {
55          owner = msg.sender;
56  }
57  
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     /**
67      * @dev Allows the current owner to transfer control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function transferOwnership(address newOwner) onlyOwner public {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 }
76 
77 
78 
79 /**
80  * @title ERC223
81  * @dev ERC223 contract interface with ERC20 functions and events
82  *      Fully backward compatible with ERC20
83  *      newQSHUCOIN
84  */
85 contract ERC223 {
86     uint public totalSupply;
87 
88     // ERC223 and ERC20 functions and events
89     function balanceOf(address who) public view returns (uint);
90     function totalSupply() public view returns (uint256 _supply);
91     function transfer(address to, uint value) public returns (bool ok);
92     function transfer(address to, uint value, bytes data) public returns (bool ok);
93     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
94     event Transfer(address indexed from, address indexed to, uint value, bytes data);
95 
96     // ERC223 functions
97     function name() public view returns (string _name);
98     function symbol() public view returns (string _symbol);
99     function decimals() public view returns (uint8 _decimals);
100 
101     // ERC20 functions and events
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
103     function approve(address _spender, uint256 _value) public returns (bool success);
104     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint _value);
107 }
108 
109 /**
110  * @title ContractReceiver
111  * @dev Contract that is working with ERC223 tokens newQSHUCOIN
112  */
113  contract ContractReceiver {
114 
115     struct TKN {
116         address sender;
117         uint value;
118         bytes data;
119         bytes4 sig;
120     }
121 
122     function tokenFallback(address _from, uint _value, bytes _data) public pure {
123         TKN memory tkn;
124         tkn.sender = _from;
125         tkn.value = _value;
126         tkn.data = _data;
127         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
128         tkn.sig = bytes4(u);
129 
130         /*
131          * tkn variable is analogue of msg variable of Ether transaction
132          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
133          * tkn.value the number of tokens that were sent   (analogue of msg.value)
134          * tkn.data is data of token transaction   (analogue of msg.data)
135          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
136          */
137     }
138 }
139 
140 /**
141  * @title newQSHUCOIN
142  * @dev QSHUCOIN is an ERC223 Token with ERC20 functions and events
143  * Wishing for circulation of QSHUCOIN!
144  * I wish for prosperity for a long time!
145  * Flapping from Kyusyu to the world!
146  * We will work with integrity and sincerity!
147  * ARIGATOH!
148  */
149 contract QSHUCOIN is ERC223, Ownable {
150     using SafeMath for uint256;
151 
152     string public name = "QSHUCOIN";
153     string public symbol = "QSH";
154     uint8 public decimals = 8;
155     uint256 public totalSupply = 50e9 * 1e8;
156 
157     mapping(address => uint256) public balanceOf;
158     mapping(address => mapping (address => uint256)) public allowance;
159     mapping (address => bool) public frozenAccount;
160     mapping (address => uint256) public unlockUnixTime;
161 
162     event FrozenFunds(address indexed target, bool frozen);
163     event LockedFunds(address indexed target, uint256 locked);
164     event Burn(address indexed from, uint256 amount);
165 
166     /**
167      * @dev Constructor is called only once and can not be called again
168      */
169     function QSHUCOIN() public {
170         owner = msg.sender;
171 
172 
173     }
174 
175     function name() public view returns (string _name) {
176         return name;
177     }
178 
179     function symbol() public view returns (string _symbol) {
180         return symbol;
181     }
182 
183     function decimals() public view returns (uint8 _decimals) {
184         return decimals;
185     }
186 
187     function totalSupply() public view returns (uint256 _totalSupply) {
188         return totalSupply;
189     }
190 
191     function balanceOf(address _owner) public view returns (uint256 balance) {
192         return balanceOf[_owner];
193     }
194 
195     /**
196      * @dev Prevent targets from sending or receiving tokens
197      * @param targets Addresses to be frozen
198      * @param isFrozen either to freeze it or not
199      */
200     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
201         require(targets.length > 0);
202 
203         for (uint j = 0; j < targets.length; j++) {
204             require(targets[j] != 0x0);
205             frozenAccount[targets[j]] = isFrozen;
206             emit FrozenFunds(targets[j], isFrozen);
207         }
208     }
209 
210     /**
211      * @dev Prevent targets from sending or receiving tokens by setting Unix times
212      * @param targets Addresses to be locked funds
213      * @param unixTimes Unix times when locking up will be finished
214      */
215     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
216         require(targets.length > 0
217                 && targets.length == unixTimes.length);
218 
219         for(uint j = 0; j < targets.length; j++){
220             require(unlockUnixTime[targets[j]] < unixTimes[j]);
221             unlockUnixTime[targets[j]] = unixTimes[j];
222             emit LockedFunds(targets[j], unixTimes[j]);
223         }
224     }
225 
226     /**
227      * @dev Standard function transfer similar to ERC20 transfer with no _data
228      *      Added due to backwards compatibility reasons
229      */
230     function transfer(address _to, uint _value) public returns (bool success) {
231         require(_value > 0
232                 && frozenAccount[msg.sender] == false
233                 && frozenAccount[_to] == false
234                 && now > unlockUnixTime[msg.sender]
235                 && now > unlockUnixTime[_to]);
236 
237         bytes memory empty;
238         if (isContract(_to)) {
239             return transferToContract(_to, _value, empty);
240         } else {
241             return transferToAddress(_to, _value, empty);
242         }
243     }
244 
245     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
246         require(_value > 0
247                 && frozenAccount[msg.sender] == false
248                 && frozenAccount[_to] == false
249                 && now > unlockUnixTime[msg.sender]
250                 && now > unlockUnixTime[_to]);
251 
252         if (isContract(_to)) {
253             return transferToContract(_to, _value, _data);
254         } else {
255             return transferToAddress(_to, _value, _data);
256         }
257     }
258 
259     /**
260      * @dev Function that is called when a user or another contract wants to transfer funds
261      */
262     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
263         require(_value > 0
264                 && frozenAccount[msg.sender] == false
265                 && frozenAccount[_to] == false
266                 && now > unlockUnixTime[msg.sender]
267                 && now > unlockUnixTime[_to]);
268 
269         if (isContract(_to)) {
270             require(balanceOf[msg.sender] >= _value);
271             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
272             balanceOf[_to] = balanceOf[_to].add(_value);
273             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
274             emit Transfer(msg.sender, _to, _value, _data);
275             emit Transfer(msg.sender, _to, _value);
276             return true;
277         } else {
278             return transferToAddress(_to, _value, _data);
279         }
280     }
281 
282     
283     function isContract(address _addr) private view returns (bool is_contract) {
284         uint length;
285         assembly {
286             //retrieve the size of the code on target address, this needs assembly
287             length := extcodesize(_addr)
288         }
289         return (length > 0);
290     }
291 
292     
293     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
294         require(balanceOf[msg.sender] >= _value);
295         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
296         balanceOf[_to] = balanceOf[_to].add(_value);
297         emit Transfer(msg.sender, _to, _value, _data);
298         emit Transfer(msg.sender, _to, _value);
299         return true;
300     }
301 
302     
303     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
304         require(balanceOf[msg.sender] >= _value);
305         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
306         balanceOf[_to] = balanceOf[_to].add(_value);
307         ContractReceiver receiver = ContractReceiver(_to);
308         receiver.tokenFallback(msg.sender, _value, _data);
309         emit Transfer(msg.sender, _to, _value, _data);
310         emit Transfer(msg.sender, _to, _value);
311         return true;
312     }
313 
314     /**
315      * @dev Transfer tokens from one address to another
316      *      Added due to backwards compatibility with ERC20
317      * @param _from address The address which you want to send tokens from
318      * @param _to address The address which you want to transfer to
319      * @param _value uint256 the amount of tokens to be transferred
320      */
321     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
322         require(_to != address(0)
323                 && _value > 0
324                 && balanceOf[_from] >= _value
325                 && allowance[_from][msg.sender] >= _value
326                 && frozenAccount[_from] == false
327                 && frozenAccount[_to] == false
328                 && now > unlockUnixTime[_from]
329                 && now > unlockUnixTime[_to]);
330 
331         balanceOf[_from] = balanceOf[_from].sub(_value);
332         balanceOf[_to] = balanceOf[_to].add(_value);
333         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
334         emit Transfer(_from, _to, _value);
335         return true;
336     }
337 
338     /**
339      * @dev Allows _spender to spend no more than _value tokens in your behalf
340      *      Added due to backwards compatibility with ERC20
341      * @param _spender The address authorized to spend
342      * @param _value the max amount they can spend
343      */
344     function approve(address _spender, uint256 _value) public returns (bool success) {
345         allowance[msg.sender][_spender] = _value;
346         emit Approval(msg.sender, _spender, _value);
347         return true;
348     }
349 
350     /**
351      * @dev Function to check the amount of tokens that an owner allowed to a spender
352      *      Added due to backwards compatibility with ERC20
353      * @param _owner address The address which owns the funds
354      * @param _spender address The address which will spend the funds
355      */
356     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
357         return allowance[_owner][_spender];
358     }
359 
360     /**
361      * @dev Burns a specific amount of tokens.
362      * @param _from The address that will burn the tokens.
363      * @param _unitAmount The amount of token to be burned.
364      */
365     function burn(address _from, uint256 _unitAmount) onlyOwner public {
366         require(_unitAmount > 0
367                 && balanceOf[_from] >= _unitAmount);
368 
369         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
370         totalSupply = totalSupply.sub(_unitAmount);
371         emit Burn(_from, _unitAmount);
372     }
373 
374     /**
375      * @dev Function to distribute tokens to the list of addresses by the provided amount
376      */
377     function qshdrop(address[] addresses, uint256 amount) public returns (bool) {
378         require(amount > 0
379                 && addresses.length > 0
380                 && frozenAccount[msg.sender] == false
381                 && now > unlockUnixTime[msg.sender]);
382 
383         uint256 totalAmount = amount.mul(addresses.length);
384         require(balanceOf[msg.sender] >= totalAmount);
385 
386         for (uint j = 0; j < addresses.length; j++) {
387             require(addresses[j] != 0x0
388                     && frozenAccount[addresses[j]] == false
389                     && now > unlockUnixTime[addresses[j]]);
390 
391             balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
392             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
393             emit Transfer(msg.sender, addresses[j], amount);
394         }
395         return true;
396     }
397 
398     function qshdrop(address[] addresses, uint256[] amounts) public returns (bool) {
399         require(addresses.length > 0
400                 && addresses.length == amounts.length
401                 && frozenAccount[msg.sender] == false
402                 && now > unlockUnixTime[msg.sender]);
403 
404         uint256 totalAmount = 0;
405 
406         for(uint j = 0; j < addresses.length; j++){
407             require(amounts[j] > 0
408                     && addresses[j] != 0x0
409                     && frozenAccount[addresses[j]] == false
410                     && now > unlockUnixTime[addresses[j]]);
411 
412             totalAmount = totalAmount.add(amounts[j]);
413         }
414         require(balanceOf[msg.sender] >= totalAmount);
415 
416         for (j = 0; j < addresses.length; j++) {
417             balanceOf[msg.sender] = balanceOf[msg.sender].sub(amounts[j]);
418             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
419             emit Transfer(msg.sender, addresses[j], amounts[j]);
420         }
421         return true;
422     }
423 
424     function() payable public {
425     }
426 }
427 
428 /**
429  * My thought is strong!
430  * The reconstruction of Kyusyu is the power of everyone!
431  */