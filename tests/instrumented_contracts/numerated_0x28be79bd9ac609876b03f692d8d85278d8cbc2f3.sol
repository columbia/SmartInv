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
153     string public symbol = "QSHC";
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
171     balanceOf[msg.sender] = totalSupply;
172     }
173 
174     function name() public view returns (string _name) {
175         return name;
176     }
177 
178     function symbol() public view returns (string _symbol) {
179         return symbol;
180     }
181 
182     function decimals() public view returns (uint8 _decimals) {
183         return decimals;
184     }
185 
186     function totalSupply() public view returns (uint256 _totalSupply) {
187         return totalSupply;
188     }
189 
190     function balanceOf(address _owner) public view returns (uint256 balance) {
191         return balanceOf[_owner];
192     }
193 
194     /**
195      * @dev Prevent targets from sending or receiving tokens
196      * @param targets Addresses to be frozen
197      * @param isFrozen either to freeze it or not
198      */
199     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
200         require(targets.length > 0);
201 
202         for (uint j = 0; j < targets.length; j++) {
203             require(targets[j] != 0x0);
204             frozenAccount[targets[j]] = isFrozen;
205             emit FrozenFunds(targets[j], isFrozen);
206         }
207     }
208 
209     /**
210      * @dev Prevent targets from sending or receiving tokens by setting Unix times
211      * @param targets Addresses to be locked funds
212      * @param unixTimes Unix times when locking up will be finished
213      */
214     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
215         require(targets.length > 0
216                 && targets.length == unixTimes.length);
217 
218         for(uint j = 0; j < targets.length; j++){
219             require(unlockUnixTime[targets[j]] < unixTimes[j]);
220             unlockUnixTime[targets[j]] = unixTimes[j];
221             emit LockedFunds(targets[j], unixTimes[j]);
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
244     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
245         require(_value > 0
246                 && frozenAccount[msg.sender] == false
247                 && frozenAccount[_to] == false
248                 && now > unlockUnixTime[msg.sender]
249                 && now > unlockUnixTime[_to]);
250 
251         if (isContract(_to)) {
252             return transferToContract(_to, _value, _data);
253         } else {
254             return transferToAddress(_to, _value, _data);
255         }
256     }
257 
258     /**
259      * @dev Function that is called when a user or another contract wants to transfer funds
260      */
261     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
262         require(_value > 0
263                 && frozenAccount[msg.sender] == false
264                 && frozenAccount[_to] == false
265                 && now > unlockUnixTime[msg.sender]
266                 && now > unlockUnixTime[_to]);
267 
268         if (isContract(_to)) {
269             require(balanceOf[msg.sender] >= _value);
270             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
271             balanceOf[_to] = balanceOf[_to].add(_value);
272             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
273             emit Transfer(msg.sender, _to, _value, _data);
274             emit Transfer(msg.sender, _to, _value);
275             return true;
276         } else {
277             return transferToAddress(_to, _value, _data);
278         }
279     }
280 
281     
282     function isContract(address _addr) private view returns (bool is_contract) {
283         uint length;
284         assembly {
285             //retrieve the size of the code on target address, this needs assembly
286             length := extcodesize(_addr)
287         }
288         return (length > 0);
289     }
290 
291     
292     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
293         require(balanceOf[msg.sender] >= _value);
294         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
295         balanceOf[_to] = balanceOf[_to].add(_value);
296         emit Transfer(msg.sender, _to, _value, _data);
297         emit Transfer(msg.sender, _to, _value);
298         return true;
299     }
300 
301     
302     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
303         require(balanceOf[msg.sender] >= _value);
304         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
305         balanceOf[_to] = balanceOf[_to].add(_value);
306         ContractReceiver receiver = ContractReceiver(_to);
307         receiver.tokenFallback(msg.sender, _value, _data);
308         emit Transfer(msg.sender, _to, _value, _data);
309         emit Transfer(msg.sender, _to, _value);
310         return true;
311     }
312 
313     /**
314      * @dev Transfer tokens from one address to another
315      *      Added due to backwards compatibility with ERC20
316      * @param _from address The address which you want to send tokens from
317      * @param _to address The address which you want to transfer to
318      * @param _value uint256 the amount of tokens to be transferred
319      */
320     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
321         require(_to != address(0)
322                 && _value > 0
323                 && balanceOf[_from] >= _value
324                 && allowance[_from][msg.sender] >= _value
325                 && frozenAccount[_from] == false
326                 && frozenAccount[_to] == false
327                 && now > unlockUnixTime[_from]
328                 && now > unlockUnixTime[_to]);
329 
330         balanceOf[_from] = balanceOf[_from].sub(_value);
331         balanceOf[_to] = balanceOf[_to].add(_value);
332         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
333         emit Transfer(_from, _to, _value);
334         return true;
335     }
336 
337     /**
338      * @dev Allows _spender to spend no more than _value tokens in your behalf
339      *      Added due to backwards compatibility with ERC20
340      * @param _spender The address authorized to spend
341      * @param _value the max amount they can spend
342      */
343     function approve(address _spender, uint256 _value) public returns (bool success) {
344         allowance[msg.sender][_spender] = _value;
345         emit Approval(msg.sender, _spender, _value);
346         return true;
347     }
348 
349     /**
350      * @dev Function to check the amount of tokens that an owner allowed to a spender
351      *      Added due to backwards compatibility with ERC20
352      * @param _owner address The address which owns the funds
353      * @param _spender address The address which will spend the funds
354      */
355     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
356         return allowance[_owner][_spender];
357     }
358 
359     /**
360      * @dev Burns a specific amount of tokens.
361      * @param _from The address that will burn the tokens.
362      * @param _unitAmount The amount of token to be burned.
363      */
364     function burn(address _from, uint256 _unitAmount) onlyOwner public {
365         require(_unitAmount > 0
366                 && balanceOf[_from] >= _unitAmount);
367 
368         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
369         totalSupply = totalSupply.sub(_unitAmount);
370         emit Burn(_from, _unitAmount);
371     }
372 
373     /**
374      * @dev Function to distribute tokens to the list of addresses by the provided amount
375      */
376     function qshdrop(address[] addresses, uint256 amount) public returns (bool) {
377         require(amount > 0
378                 && addresses.length > 0
379                 && frozenAccount[msg.sender] == false
380                 && now > unlockUnixTime[msg.sender]);
381 
382         uint256 totalAmount = amount.mul(addresses.length);
383         require(balanceOf[msg.sender] >= totalAmount);
384 
385         for (uint j = 0; j < addresses.length; j++) {
386             require(addresses[j] != 0x0
387                     && frozenAccount[addresses[j]] == false
388                     && now > unlockUnixTime[addresses[j]]);
389 
390             balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
391             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
392             emit Transfer(msg.sender, addresses[j], amount);
393         }
394         return true;
395     }
396 
397     function qshdrop(address[] addresses, uint256[] amounts) public returns (bool) {
398         require(addresses.length > 0
399                 && addresses.length == amounts.length
400                 && frozenAccount[msg.sender] == false
401                 && now > unlockUnixTime[msg.sender]);
402 
403         uint256 totalAmount = 0;
404 
405         for(uint j = 0; j < addresses.length; j++){
406             require(amounts[j] > 0
407                     && addresses[j] != 0x0
408                     && frozenAccount[addresses[j]] == false
409                     && now > unlockUnixTime[addresses[j]]);
410 
411             totalAmount = totalAmount.add(amounts[j]);
412         }
413         require(balanceOf[msg.sender] >= totalAmount);
414 
415         for (j = 0; j < addresses.length; j++) {
416             balanceOf[msg.sender] = balanceOf[msg.sender].sub(amounts[j]);
417             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
418             emit Transfer(msg.sender, addresses[j], amounts[j]);
419         }
420         return true;
421     }
422 
423     function() payable public {
424     }
425 }
426 
427 /**
428  * My thought is strong!
429  * The reconstruction of Kyusyu is the power of everyone!
430  */