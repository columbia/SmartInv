1 pragma solidity ^0.4.24;
2 
3 contract ERC223Interface {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address _who) public view returns (uint256);
6     function transfer(address _to, uint256 _value) public returns (bool);
7     function allowance(address _owner, address _spender) public view returns (uint256);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
9     function approve(address _spender, uint256 _value) public returns (bool);
10     
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Transfer(address indexed from, address indexed to, uint value, bytes data);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16  /**
17  * @title Contract that will work with ERC223 tokens.
18  */
19  
20 contract ERC223ReceivingContract { 
21 /**
22  * @dev Standard ERC223 function that will handle incoming token transfers.
23  *
24  * @param _from  Token sender address.
25  * @param _value Amount of tokens.
26  * @param _data  Transaction metadata.
27  */
28     function tokenFallback(address _from, uint _value, bytes _data) public;
29 }
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipRenounced(address indexed previousOwner);
41   event OwnershipTransferred(
42     address indexed previousOwner,
43     address indexed newOwner
44   );
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to relinquish control of the contract.
65    * @notice Renouncing to ownership will leave the contract without an owner.
66    * It will not be possible to call the functions with the `onlyOwner`
67    * modifier anymore.
68    */
69   function renounceOwnership() public onlyOwner {
70     emit OwnershipRenounced(owner);
71     owner = address(0);
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is not paused.
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is paused.
115    */
116   modifier whenPaused() {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() public onlyOwner whenNotPaused {
125     paused = true;
126     emit Pause();
127   }
128 
129   /**
130    * @dev called by the owner to unpause, returns to normal state
131    */
132   function unpause() public onlyOwner whenPaused {
133     paused = false;
134     emit Unpause();
135   }
136 }
137 
138 /**
139  * @title SafeMath
140  * @dev Math operations with safety checks that throw on error
141  */
142 library SafeMath {
143 
144   /**
145   * @dev Multiplies two numbers, throws on overflow.
146   */
147   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
148     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
149     // benefit is lost if 'b' is also tested.
150     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151     if (_a == 0) {
152       return 0;
153     }
154 
155     c = _a * _b;
156     assert(c / _a == _b);
157     return c;
158   }
159 
160   /**
161   * @dev Integer division of two numbers, truncating the quotient.
162   */
163   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
164     // assert(_b > 0); // Solidity automatically throws when dividing by 0
165     // uint256 c = _a / _b;
166     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
167     return _a / _b;
168   }
169 
170   /**
171   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
172   */
173   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
174     assert(_b <= _a);
175     return _a - _b;
176   }
177 
178   /**
179   * @dev Adds two numbers, throws on overflow.
180   */
181   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
182     c = _a + _b;
183     assert(c >= _a);
184     return c;
185   }
186 }
187 
188 contract BGCoin is ERC223Interface, Pausable {
189     using SafeMath for uint256;
190     
191     string internal _name;
192     string internal _symbol;
193     uint8 internal _decimals;
194     uint256 internal _totalSupply;
195     
196     mapping (address => uint256) internal balances;
197     mapping (address => mapping (address => uint256)) internal allowed;
198     mapping (address => bool) public frozenAccount;
199     
200     event FrozenFunds(address target, bool frozen);
201     
202     constructor(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
203         _name = name;
204         _symbol = symbol;
205         _decimals = decimals;
206         _totalSupply = totalSupply;
207         balances[msg.sender] = totalSupply;
208     }
209     
210     function name() public view returns (string) {
211         return _name;
212     }
213     
214     function symbol() public view returns (string) {
215         return _symbol;
216     }
217     
218     function decimals() public view returns (uint8) {
219         return _decimals;
220     }
221     
222     function totalSupply() public view returns (uint256) {
223         return _totalSupply;
224     }
225     
226     function balanceOf(address _owner) public view returns (uint256 balance) {
227         return balances[_owner];
228     }
229     
230     function freezeAccount(address target, bool freeze) 
231     public 
232     onlyOwner
233     {
234         frozenAccount[target] = freeze;
235         emit FrozenFunds(target, freeze);
236     }
237     
238     function transfer(address _to, uint256 _value) 
239     public
240     whenNotPaused
241     returns (bool) 
242     {
243         require(_value <= balances[msg.sender]);
244         require(!frozenAccount[_to]);
245         require(!frozenAccount[msg.sender]);
246         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
247         balances[_to] = SafeMath.add(balances[_to], _value);
248         emit Transfer(msg.sender, _to, _value);
249         return true;
250     }
251     
252     function transfer(address _to, uint _value, bytes _data) 
253     public
254     whenNotPaused
255     returns (bool)
256     {
257         require(_value > 0 );
258         require(!frozenAccount[_to]);
259         require(!frozenAccount[msg.sender]);
260         if(isContract(_to)) {
261             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
262             receiver.tokenFallback(msg.sender, _value, _data);
263         }
264         balances[msg.sender] = balances[msg.sender].sub(_value);
265         balances[_to] = balances[_to].add(_value);
266         emit Transfer(msg.sender, _to, _value, _data);
267         return true;
268     }
269     
270     function isContract(address _addr) 
271     private
272     view
273     returns (bool is_contract) 
274     {
275         uint length;
276         assembly {
277             //retrieve the size of the code on target address, this needs assembly
278             length := extcodesize(_addr)
279         }
280         return (length>0);
281     }
282     
283     function transferFrom(address _from, address _to, uint256 _value) 
284     public
285     whenNotPaused
286     returns (bool) 
287     {
288         require(_value <= balances[_from]);
289         require(_value <= allowed[_from][msg.sender]);
290         require(!frozenAccount[_to]);
291         require(!frozenAccount[_from]);
292         
293         balances[_from] = SafeMath.sub(balances[_from], _value);
294         balances[_to] = SafeMath.add(balances[_to], _value);
295         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
296         emit Transfer(_from, _to, _value);
297         return true;
298     }
299     
300     function approve(address _spender, uint256 _value) 
301     public
302     whenNotPaused
303     returns (bool) 
304     {
305         allowed[msg.sender][_spender] = _value;
306         emit Approval(msg.sender, _spender, _value);
307         return true;
308     }
309     
310     function allowance(address _owner, address _spender) 
311     public
312     view
313     returns (uint256) 
314     {
315         return allowed[_owner][_spender];
316     }
317     
318     function increaseApproval(address _spender, uint _addedValue) 
319     public
320     whenNotPaused
321     returns (bool) 
322     {
323         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
324         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
325         return true;
326     }
327     
328     function decreaseApproval(address _spender, uint _subtractedValue) 
329     public
330     whenNotPaused
331     returns (bool) 
332     {
333         uint oldValue = allowed[msg.sender][_spender];
334         if (_subtractedValue > oldValue) {
335             allowed[msg.sender][_spender] = 0;
336         } else {
337             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
338         }
339         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340         return true;
341     }
342     
343     function distributeAirdrop(address[] addresses, uint256 amount) 
344     public
345     returns (bool seccess) 
346     {
347         require(amount > 0);
348         require(addresses.length > 0);
349         require(!frozenAccount[msg.sender]);
350         
351         uint256 totalAmount = amount.mul(addresses.length);
352         require(balances[msg.sender] >= totalAmount);
353         bytes memory empty;
354         
355         for (uint i = 0; i < addresses.length; i++) {
356             require(addresses[i] != address(0));
357             require(!frozenAccount[addresses[i]]);
358             balances[addresses[i]] = balances[addresses[i]].add(amount);
359             emit Transfer(msg.sender, addresses[i], amount, empty);
360         }
361         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
362         
363         return true;
364     }
365     
366     function distributeAirdrop(address[] addresses, uint256[] amounts) 
367     public returns (bool) {
368         require(addresses.length > 0);
369         require(addresses.length == amounts.length);
370         require(!frozenAccount[msg.sender]);
371         
372         uint256 totalAmount = 0;
373         
374         for(uint i = 0; i < addresses.length; i++){
375             require(amounts[i] > 0);
376             require(addresses[i] != address(0));
377             require(!frozenAccount[addresses[i]]);
378             
379             totalAmount = totalAmount.add(amounts[i]);
380         }
381         require(balances[msg.sender] >= totalAmount);
382         
383         bytes memory empty;
384         for (i = 0; i < addresses.length; i++) {
385             balances[addresses[i]] = balances[addresses[i]].add(amounts[i]);
386             emit Transfer(msg.sender, addresses[i], amounts[i], empty);
387         }
388         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
389         return true;
390     }
391     
392     /**
393      * @dev Function to collect tokens from the list of addresses
394      */
395     function collectTokens(address[] addresses, uint256[] amounts) 
396     public
397     onlyOwner 
398     returns (bool) {
399         require(addresses.length > 0);
400         require(addresses.length == amounts.length);
401 
402         uint256 totalAmount = 0;
403         bytes memory empty;
404         
405         for (uint j = 0; j < addresses.length; j++) {
406             require(amounts[j] > 0);
407             require(addresses[j] != address(0));
408             require(!frozenAccount[addresses[j]]);
409                     
410             require(balances[addresses[j]] >= amounts[j]);
411             balances[addresses[j]] = balances[addresses[j]].sub(amounts[j]);
412             totalAmount = totalAmount.add(amounts[j]);
413             emit Transfer(addresses[j], msg.sender, amounts[j], empty);
414         }
415         balances[msg.sender] = balances[msg.sender].add(totalAmount);
416         return true;
417     }
418 }