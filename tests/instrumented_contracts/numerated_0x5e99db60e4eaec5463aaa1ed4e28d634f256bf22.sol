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
73 /**
74  * @title ERC223
75  * @dev ERC223 contract interface with ERC20 functions and events
76  *      Fully backward compatible with ERC20
77  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
78  */
79 contract ERC223 {
80     uint public totalSupply;
81 
82     // ERC223 and ERC20 functions and events
83     function balanceOf(address who) public view returns (uint);
84     function totalSupply() public view returns (uint256 _supply);
85     function transfer(address to, uint value) public returns (bool ok);
86     function transfer(address to, uint value, bytes data) public returns (bool ok);
87     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
88     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
89 
90     // ERC223 functions
91     function name() public view returns (string _name);
92     function symbol() public view returns (string _symbol);
93     function decimals() public view returns (uint8 _decimals);
94 
95     // ERC20 functions and events
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
97     function approve(address _spender, uint256 _value) public returns (bool success);
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint _value);
101 }
102 
103 /**
104  * @title ContractReceiver
105  * @dev Contract that is working with ERC223 tokens
106  */
107  contract ContractReceiver {
108 
109     struct TKN {
110         address sender;
111         uint value;
112         bytes data;
113         bytes4 sig;
114     }
115 
116     function tokenFallback(address _from, uint _value, bytes _data) public pure {
117         TKN memory tkn;
118         tkn.sender = _from;
119         tkn.value = _value;
120         tkn.data = _data;
121         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
122         tkn.sig = bytes4(u);
123 
124         /*
125          * tkn variable is analogue of msg variable of Ether transaction
126          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
127          * tkn.value the number of tokens that were sent (analogue of msg.value)
128          * tkn.data is data of token transaction (analogue of msg.data)
129          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
130          */
131     }
132 }
133 
134 /**
135  * @title Arascacoin
136  * @author Arascacoin project
137  * @dev Arascacoin is an ERC223 Token with ERC20 functions and events
138  *      Fully backward compatible with ERC20
139  */
140 contract Arascacoin is ERC223, Ownable {
141     using SafeMath for uint256;
142 
143     string public name = "Arascacoin";
144     string public symbol = "ASC";
145     uint8 public decimals = 8;
146     uint256 public totalSupply = 10512e4 * 1e8;
147     bool public mintingFinished = false;
148 
149     mapping(address => uint256) public balanceOf;
150     mapping(address => mapping (address => uint256)) public allowance;
151     mapping (address => bool) public frozenAccount;
152     mapping (address => uint256) public unlockUnixTime;
153 
154     event FrozenFunds(address indexed target, bool frozen);
155     event LockedFunds(address indexed target, uint256 locked);
156     event Burn(address indexed from, uint256 amount);
157     event Mint(address indexed to, uint256 amount);
158     event MintFinished();
159 
160     /**
161      * @dev Constructor is called only once and can not be called again
162      */
163     function Arascacoin() public {
164         owner = 0xD4e4d1D80D2F828E6df406ed9c67C876FefC2554;
165 
166         balanceOf[owner] = totalSupply;
167     }
168 
169     function name() public view returns (string _name) {
170         return name;
171     }
172 
173     function symbol() public view returns (string _symbol) {
174         return symbol;
175     }
176 
177     function decimals() public view returns (uint8 _decimals) {
178         return decimals;
179     }
180 
181     function totalSupply() public view returns (uint256 _totalSupply) {
182         return totalSupply;
183     }
184 
185     function balanceOf(address _owner) public view returns (uint256 balance) {
186         return balanceOf[_owner];
187     }
188 
189     /**
190      * @dev Prevent targets from sending or receiving tokens
191      * @param targets Addresses to be frozen
192      * @param isFrozen either to freeze it or not
193      */
194     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
195         require(targets.length > 0);
196 
197         for (uint j = 0; j < targets.length; j++) {
198             require(targets[j] != 0x0);
199             frozenAccount[targets[j]] = isFrozen;
200             FrozenFunds(targets[j], isFrozen);
201         }
202     }
203 
204     /**
205      * @dev Prevent targets from sending or receiving tokens by setting Unix times
206      * @param targets Addresses to be locked funds
207      * @param unixTimes Unix times when locking up will be finished
208      */
209     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
210         require(targets.length > 0
211                 && targets.length == unixTimes.length);
212 
213         for(uint j = 0; j < targets.length; j++){
214             require(unlockUnixTime[targets[j]] < unixTimes[j]);
215             unlockUnixTime[targets[j]] = unixTimes[j];
216             LockedFunds(targets[j], unixTimes[j]);
217         }
218     }
219 
220     /**
221      * @dev Function that is called when a user or another contract wants to transfer funds
222      */
223     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
224         require(_value > 0
225                 && frozenAccount[msg.sender] == false
226                 && frozenAccount[_to] == false
227                 && now > unlockUnixTime[msg.sender]
228                 && now > unlockUnixTime[_to]);
229 
230         if (isContract(_to)) {
231             require(balanceOf[msg.sender] >= _value);
232             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
233             balanceOf[_to] = balanceOf[_to].add(_value);
234             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
235             Transfer(msg.sender, _to, _value, _data);
236             Transfer(msg.sender, _to, _value);
237             return true;
238         } else {
239             return transferToAddress(_to, _value, _data);
240         }
241     }
242 
243     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
244         require(_value > 0
245                 && frozenAccount[msg.sender] == false
246                 && frozenAccount[_to] == false
247                 && now > unlockUnixTime[msg.sender]
248                 && now > unlockUnixTime[_to]);
249 
250         if (isContract(_to)) {
251             return transferToContract(_to, _value, _data);
252         } else {
253             return transferToAddress(_to, _value, _data);
254         }
255     }
256 
257     /**
258      * @dev Standard function transfer similar to ERC20 transfer with no _data
259      *      Added due to backwards compatibility reasons
260      */
261     function transfer(address _to, uint _value) public returns (bool success) {
262         require(_value > 0
263                 && frozenAccount[msg.sender] == false
264                 && frozenAccount[_to] == false
265                 && now > unlockUnixTime[msg.sender]
266                 && now > unlockUnixTime[_to]);
267 
268         bytes memory empty;
269         if (isContract(_to)) {
270             return transferToContract(_to, _value, empty);
271         } else {
272             return transferToAddress(_to, _value, empty);
273         }
274     }
275 
276     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
277     function isContract(address _addr) private view returns (bool is_contract) {
278         uint length;
279         assembly {
280             //retrieve the size of the code on target address, this needs assembly
281             length := extcodesize(_addr)
282         }
283         return (length > 0);
284     }
285 
286     // function that is called when transaction target is an address
287     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
288         require(balanceOf[msg.sender] >= _value);
289         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
290         balanceOf[_to] = balanceOf[_to].add(_value);
291         Transfer(msg.sender, _to, _value, _data);
292         Transfer(msg.sender, _to, _value);
293         return true;
294     }
295 
296     // function that is called when transaction target is a contract
297     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
298         require(balanceOf[msg.sender] >= _value);
299         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
300         balanceOf[_to] = balanceOf[_to].add(_value);
301         ContractReceiver receiver = ContractReceiver(_to);
302         receiver.tokenFallback(msg.sender, _value, _data);
303         Transfer(msg.sender, _to, _value, _data);
304         Transfer(msg.sender, _to, _value);
305         return true;
306     }
307 
308     /**
309      * @dev Transfer tokens from one address to another
310      *      Added due to backwards compatibility with ERC20
311      * @param _from address The address which you want to send tokens from
312      * @param _to address The address which you want to transfer to
313      * @param _value uint256 the amount of tokens to be transferred
314      */
315     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
316         require(_to != address(0)
317                 && _value > 0
318                 && balanceOf[_from] >= _value
319                 && allowance[_from][msg.sender] >= _value
320                 && frozenAccount[_from] == false
321                 && frozenAccount[_to] == false
322                 && now > unlockUnixTime[_from]
323                 && now > unlockUnixTime[_to]);
324 
325         balanceOf[_from] = balanceOf[_from].sub(_value);
326         balanceOf[_to] = balanceOf[_to].add(_value);
327         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
328         Transfer(_from, _to, _value);
329         return true;
330     }
331 
332     /**
333      * @dev Allows _spender to spend no more than _value tokens in your behalf
334      *      Added due to backwards compatibility with ERC20
335      * @param _spender The address authorized to spend
336      * @param _value the max amount they can spend
337      */
338     function approve(address _spender, uint256 _value) public returns (bool success) {
339         allowance[msg.sender][_spender] = _value;
340         Approval(msg.sender, _spender, _value);
341         return true;
342     }
343 
344     /**
345      * @dev Function to check the amount of tokens that an owner allowed to a spender
346      *      Added due to backwards compatibility with ERC20
347      * @param _owner address The address which owns the funds
348      * @param _spender address The address which will spend the funds
349      */
350     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
351         return allowance[_owner][_spender];
352     }
353 
354     /**
355      * @dev Burns a specific amount of tokens.
356      * @param _from The address that will burn the tokens.
357      * @param _unitAmount The amount of token to be burned.
358      */
359     function burn(address _from, uint256 _unitAmount) onlyOwner public {
360         require(_unitAmount > 0
361                 && balanceOf[_from] >= _unitAmount);
362 
363         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
364         totalSupply = totalSupply.sub(_unitAmount);
365         Burn(_from, _unitAmount);
366     }
367 
368 
369     modifier canMint() {
370         require(!mintingFinished);
371         _;
372     }
373 
374     /**
375      * @dev Function to mint tokens
376      * @param _to The address that will receive the minted tokens.
377      * @param _unitAmount The amount of tokens to mint.
378      */
379     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
380         require(_unitAmount > 0);
381         
382         totalSupply = totalSupply.add(_unitAmount);
383         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
384         Mint(_to, _unitAmount);
385         Transfer(address(0), _to, _unitAmount);
386         return true;
387     }
388 
389     /**
390      * @dev Function to stop minting new tokens.
391      */
392     function finishMinting() onlyOwner canMint public returns (bool) {
393         mintingFinished = true;
394         MintFinished();
395         return true;
396     }
397 }