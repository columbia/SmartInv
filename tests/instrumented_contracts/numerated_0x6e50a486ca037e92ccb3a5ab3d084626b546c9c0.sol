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
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization
41  *      control function,this simplifies the implementation of "user permissions".
42  */
43  
44  contract Ownable {
45      address public owner;
46      
47      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48      
49      /**
50       * 
51       * @dev The Ownable constructor sets the original 'owner' of the contract to the
52       *         sender account.
53       */
54       
55      function Ownable() public {
56          owner = msg.sender;
57  }
58  
59  /**
60   * @dev Throws if called by any account other than the owner.
61   */
62   
63  modifier onlyOwner() {
64      require(msg.sender == owner);
65      _;
66  }
67  
68  /**
69   * @dev Allows the current owner to transfer control of the contract to a newOwner.
70   * @param newOwner The address to transfer ownership to.
71   */
72   
73   function transferOwnership(address newOwner) public onlyOwner {
74       require(newOwner !=address(0));
75       emit OwnershipTransferred(owner, newOwner);
76       owner = newOwner;
77   }
78 }
79 
80 /**
81  * @title ContractReceiver
82  * @dev Receiver for ERC223 tokens
83  */
84  
85 contract ContractReceiver {
86     
87     struct TKN {
88         address sender;
89         uint value;
90         bytes data;
91         bytes4 sig;
92     }
93     function tokenFallback(address _from, uint _value, bytes _data) public pure {
94         TKN memory tkn;
95         tkn.sender = _from;
96         tkn.value = _value;
97         tkn.data = _data;
98         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) <<16) + (uint32(_data[0]) << 24);
99         tkn.sig = bytes4(u);
100         
101         /*
102          *tkn variable is analogue of msg variable of Ether transaction
103          *tkn.sender is person who initiated this token transaction (analogue of msg.sender)
104          *tkn.value the number of tokens that were sent (analogue of msg.value)
105          *tkn.data is data of token transaction (analogue of msg.data)
106          *tkn.sig is 4 bytes signature of function
107          *if data of token transaction is a function execution
108          */
109          
110     }
111 }
112 
113 contract ERC223 {
114     uint public totalSupply;
115     function name() public view returns (string _name);
116     function symbol() public view returns (string _symbol);
117     function decimals() public view returns (uint8 _decimals);
118     function totalSupply() public view returns (uint256 _supply);
119     function balanceOf(address who) public view returns (uint);
120 
121     function transfer(address to, uint value) public returns (bool ok);
122     function transfer(address to, uint value, bytes data) public returns (bool ok);
123     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
124 
125     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
126     event Transfer(address indexed _from, address indexed _to, uint256 _value);
127 }
128 
129 /**
130  * Wishing for circulation of QSHUCOIN!
131  * I wish for prosperity for a long time!
132  * Flapping from Kyusyu to the world!
133  * We will work with integrity and sincerity!
134  * ARIGATOH!
135  */
136 
137 contract QSHU is ERC223, Ownable {
138     using SafeMath for uint256;
139     
140     string public name = "QSHUCOIN";
141     string public symbol = "QSHU";
142     uint8 public decimals = 8;
143     uint256 public initialSupply = 50e9 * 1e8;
144     uint256 public totalSupply;
145     uint256 public distributeAmount = 0;
146     bool public mintingFinished = false;
147     
148     mapping (address => uint) balances;
149     mapping (address => bool) public frozenAccount;
150     mapping (address => uint256) public unlockUnixTime;
151     
152     event FrozenFunds(address indexed target, bool frozen);
153     event LockedFunds(address indexed target, uint256 locked);
154     event Burn(address indexed burner, uint256 value);
155     event Mint(address indexed to, uint256 amount);
156     event MintFinished();
157     
158     function QSHU() public {
159         totalSupply = initialSupply;
160         balances[msg.sender] = totalSupply;
161     }
162     
163     function name() public view returns (string _name) {
164         return name;
165     }
166     function symbol() public view returns (string _symbol) {
167         return symbol;
168     }
169     function decimals() public view returns (uint8 _decimals) {
170         return decimals;
171     }
172     function totalSupply() public view returns (uint256 _totalSupply) {
173         return totalSupply;
174     }
175     function balanceOf(address _owner) public view returns (uint balance) {
176         return balances[_owner];
177     }
178     
179     modifier onlyPayloadSize(uint256 size){
180         assert(msg.data.length >= size + 4);
181         _;
182     }
183     
184     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
185         require(_value > 0
186             && frozenAccount[msg.sender] == false
187             && frozenAccount[_to] == false
188             && now > unlockUnixTime[msg.sender]
189             && now > unlockUnixTime[_to]);
190         
191         if(isContract(_to)) {
192             if (balanceOf(msg.sender) < _value) revert();
193             balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
194             balances[_to] = SafeMath.add(balanceOf(_to), _value);
195             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
196             emit Transfer(msg.sender, _to, _value, _data);
197             emit Transfer(msg.sender, _to, _value);
198             return true;
199         }
200         else {
201             return transferToAddress(_to, _value, _data);
202         }
203     }
204     
205     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
206         require(_value > 0
207             && frozenAccount[msg.sender] == false
208             && frozenAccount[_to] == false
209             && now > unlockUnixTime[msg.sender]
210             && now > unlockUnixTime[_to]);
211 
212         if(isContract(_to)) {
213             return transferToContract(_to, _value, _data);
214         }
215         else {
216             return transferToAddress(_to, _value, _data);
217         }
218     }
219     
220     function transfer(address _to, uint _value) public returns (bool success) {
221         require(_value > 0
222             && frozenAccount[msg.sender] == false
223             && frozenAccount[_to] == false
224             && now > unlockUnixTime[msg.sender]
225             && now > unlockUnixTime[_to]);
226     bytes memory empty;
227     if(isContract(_to)) {
228         return transferToContract(_to, _value, empty);
229     }
230     else {
231         return transferToAddress(_to, _value, empty);
232         }
233     }
234     
235     function isContract(address _addr) private view returns (bool is_contract) {
236         uint length;
237         assembly {
238             length := extcodesize(_addr)
239         }
240         return (length > 0);
241     }
242     
243     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
244         if (balanceOf(msg.sender) < _value) revert();
245         balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
246         balances[_to] = SafeMath.add(balanceOf(_to), _value);
247         emit Transfer(msg.sender, _to, _value, _data);
248         emit Transfer(msg.sender, _to, _value);
249         return true;
250     }
251     
252     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
253         if (balanceOf(msg.sender) < _value) revert();
254         balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
255         balances[_to] = SafeMath.add(balanceOf(_to), _value);
256         ContractReceiver receiver = ContractReceiver(_to);
257         receiver.tokenFallback(msg.sender, _value, _data);
258         emit Transfer(msg.sender, _to, _value, _data);
259         emit Transfer(msg.sender, _to, _value);
260         return true;
261     }
262 
263 /**
264  * @dev Prevent targets from sending or receiving tokens
265  * @param targets Addresses to be frozen
266  * @param isFrozen either to freeze it or not
267  */
268 
269     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
270         require(targets.length > 0);
271 
272         for (uint q = 0; q < targets.length; q++) {
273             require(targets[q] != 0x0);
274             frozenAccount[targets[q]] = isFrozen;
275             emit FrozenFunds(targets[q], isFrozen);
276         }
277     }
278     
279 /**
280  * @dev Prevent targets from sending or receiving tokens by setting Unix times 
281  * @param targets Addresses to be locked funds 
282  * @param unixTimes Unix times when locking up will be finished 
283  */
284  
285     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
286         require(targets.length > 0 
287             && targets.length == unixTimes.length);
288             
289         for(uint q = 0; q < targets.length; q++){
290             require(unlockUnixTime[targets[q]] < unixTimes[q]);
291             unlockUnixTime[targets[q]] = unixTimes[q];
292             emit LockedFunds(targets[q], unixTimes[q]);
293         }
294     }
295 
296 /**
297  * @dev Burns a specific amount of tokens.
298  * @param _from The address that will burn the tokens.
299  * @param _unitAmount The amount of token to be burned.
300  */
301  
302     function burn(address _from, uint256 _unitAmount) onlyOwner public {
303         require(_unitAmount > 0
304             && balanceOf(_from) >= _unitAmount);
305         
306         balances[_from] = SafeMath.sub(balances[_from], _unitAmount);
307         totalSupply = SafeMath.sub(totalSupply, _unitAmount);
308         emit Burn(_from, _unitAmount);
309     }
310     
311     modifier canMint() {
312         require(!mintingFinished);
313         _;
314     }
315     
316 /**
317  * @dev Function to mint tokens
318  * @param _to The address that will receive the minted tokens.
319  * @param _unitAmount The amount of tokens to mint.
320  */
321  
322     function mint (address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
323         require(_unitAmount > 0);
324         
325         totalSupply = SafeMath.add(totalSupply, _unitAmount);
326         balances[_to] = SafeMath.add(balances[_to], _unitAmount);
327         emit Mint(_to, _unitAmount);
328         emit Transfer(address(0), _to, _unitAmount);
329         return true;
330     }
331 
332 
333 /**
334  * dev Function to stop minting new tokens.
335  */
336  
337     function finishMinting() onlyOwner canMint public returns (bool) {
338         mintingFinished = true;
339         emit MintFinished();
340         return true;
341     }
342     
343 /**
344  * @dev Function to distribute tokens to the list of addresses by the provided amount
345  */
346  
347 
348     function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {
349         require(amount > 0
350             && addresses.length > 0
351             && frozenAccount[msg.sender] == false
352             && now > unlockUnixTime[msg.sender]);
353         
354         amount = SafeMath.mul(amount,1e8);
355         uint256 totalAmount = SafeMath.mul(amount, addresses.length);
356         require(balances[msg.sender] >= totalAmount);
357         
358         for (uint q = 0; q < addresses.length; q++) {
359             require(addresses[q] != 0x0
360                 && frozenAccount[addresses[q]] == false
361                 && now > unlockUnixTime[addresses[q]]);
362             
363             balances[addresses[q]] = SafeMath.add(balances[addresses[q]], amount);
364             emit Transfer(msg.sender, addresses[q], amount);
365         }
366         balances[msg.sender] = SafeMath.sub(balances[msg.sender],totalAmount);
367         return true;
368     }
369     
370 /**
371  * @dev Function to collect tokens from the list of addresses
372  */
373 
374     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
375         require(addresses.length > 0
376                 && addresses.length == amounts.length);
377         
378         uint256 totalAmount = 0;
379         
380         for (uint q = 0; q < addresses.length; q++) {
381             require(amounts[q] > 0
382                     && addresses[q] != 0x0
383                     && frozenAccount[addresses[q]] == false
384                     && now > unlockUnixTime[addresses[q]]);
385             
386             amounts[q] = SafeMath.mul(amounts[q], 1e8);
387             require(balances[addresses[q]] >= amounts[q]);
388             balances[addresses[q]] = SafeMath.sub(balances[addresses[q]], amounts[q]);
389             totalAmount = SafeMath.add(totalAmount, amounts[q]);
390             emit Transfer(addresses[q], msg.sender, amounts[q]);
391         }
392         balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);
393         return true;
394     }
395     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
396         distributeAmount = _unitAmount;
397     }
398     
399 /**
400  * @dev Function to distribute tokens to the msg.sender automatically
401  * If distributeAmount is 0 , this function doesn't work'
402  */
403  
404     function autoDistribute() payable public {
405         require(distributeAmount > 0
406                 && balanceOf(owner) >= distributeAmount
407                 && frozenAccount[msg.sender] == false
408                 && now > unlockUnixTime[msg.sender]);
409         if (msg.value > 0) owner.transfer(msg.value);
410         
411         balances[owner] = SafeMath.sub(balances[owner], distributeAmount);
412         balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);
413         emit Transfer(owner, msg.sender, distributeAmount);
414     }
415     
416 /**
417  * @dev token fallback function
418  */
419  
420     function() payable public {
421         autoDistribute();
422     }
423 }
424 
425 /**
426  * My thought is strong!
427  * The reconstruction of Kyusyu is the power of everyone!
428  */