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
120  * @title CARX TOKEN
121  */
122 contract CARXTOKEN is ERC223, Ownable {
123     using SafeMath for uint256;
124 
125     string public name = "CARX TOKEN";
126     string public symbol = "CARX";
127     uint8 public decimals = 18;
128     uint256 public totalSupply = 2e9 * 1e18;
129     bool public mintingFinished = false;
130     
131     mapping(address => uint256) public balanceOf;
132     mapping(address => mapping (address => uint256)) public allowance;
133     mapping (address => bool) public frozenAccount;
134     mapping (address => uint256) public unlockUnixTime;
135     
136     event FrozenFunds(address indexed target, bool frozen);
137     event LockedFunds(address indexed target, uint256 locked);
138     event Burn(address indexed from, uint256 amount);
139     event Mint(address indexed to, uint256 amount);
140     event MintFinished();
141 
142     /** 
143      * @dev Constructor is called only once and can not be called again
144      */
145     function CARXTOKEN() public {
146         balanceOf[msg.sender] = totalSupply;
147     }
148 
149     function name() public view returns (string _name) {
150         return name;
151     }
152 
153     function symbol() public view returns (string _symbol) {
154         return symbol;
155     }
156 
157     function decimals() public view returns (uint8 _decimals) {
158         return decimals;
159     }
160 
161     function totalSupply() public view returns (uint256 _totalSupply) {
162         return totalSupply;
163     }
164 
165     function balanceOf(address _owner) public view returns (uint256 balance) {
166         return balanceOf[_owner];
167     }
168 
169     /**
170      * @dev Prevent targets from sending or receiving tokens by setting Unix times
171      * @param targets Addresses to be locked funds
172      * @param unixTimes Unix times when locking up will be finished
173      */
174     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
175         require(targets.length > 0
176                 && targets.length == unixTimes.length);
177                 
178         for(uint j = 0; j < targets.length; j++){
179             require(unlockUnixTime[targets[j]] < unixTimes[j]);
180             unlockUnixTime[targets[j]] = unixTimes[j];
181             LockedFunds(targets[j], unixTimes[j]);
182         }
183     }
184 
185     /**
186      * @dev Function that is called when a user or another contract wants to transfer funds
187      */
188     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
189         require(_value > 0
190                 && frozenAccount[msg.sender] == false 
191                 && frozenAccount[_to] == false
192                 && now > unlockUnixTime[msg.sender] 
193                 && now > unlockUnixTime[_to]);
194 
195         if (isContract(_to)) {
196             require(balanceOf[msg.sender] >= _value);
197             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
198             balanceOf[_to] = balanceOf[_to].add(_value);
199             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
200             Transfer(msg.sender, _to, _value, _data);
201             Transfer(msg.sender, _to, _value);
202             return true;
203         } else {
204             return transferToAddress(_to, _value, _data);
205         }
206     }
207 
208     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
209         require(_value > 0
210                 && frozenAccount[msg.sender] == false 
211                 && frozenAccount[_to] == false
212                 && now > unlockUnixTime[msg.sender] 
213                 && now > unlockUnixTime[_to]);
214 
215         if (isContract(_to)) {
216             return transferToContract(_to, _value, _data);
217         } else {
218             return transferToAddress(_to, _value, _data);
219         }
220     }
221 
222     /**
223      * @dev Standard function transfer similar to ERC20 transfer with no _data
224      *      Added due to backwards compatibility reasons
225      */
226     function transfer(address _to, uint _value) public returns (bool success) {
227         require(_value > 0
228                 && frozenAccount[msg.sender] == false 
229                 && frozenAccount[_to] == false
230                 && now > unlockUnixTime[msg.sender] 
231                 && now > unlockUnixTime[_to]);
232 
233         bytes memory empty;
234         if (isContract(_to)) {
235             return transferToContract(_to, _value, empty);
236         } else {
237             return transferToAddress(_to, _value, empty);
238         }
239     }
240 
241     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
242     function isContract(address _addr) private view returns (bool is_contract) {
243         uint length;
244         assembly {
245             //retrieve the size of the code on target address, this needs assembly
246             length := extcodesize(_addr)
247         }
248         return (length > 0);
249     }
250 
251     // function that is called when transaction target is an address
252     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
253         require(balanceOf[msg.sender] >= _value);
254         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
255         balanceOf[_to] = balanceOf[_to].add(_value);
256         Transfer(msg.sender, _to, _value, _data);
257         Transfer(msg.sender, _to, _value);
258         return true;
259     }
260 
261     // function that is called when transaction target is a contract
262     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
263         require(balanceOf[msg.sender] >= _value);
264         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
265         balanceOf[_to] = balanceOf[_to].add(_value);
266         ContractReceiver receiver = ContractReceiver(_to);
267         receiver.tokenFallback(msg.sender, _value, _data);
268         Transfer(msg.sender, _to, _value, _data);
269         Transfer(msg.sender, _to, _value);
270         return true;
271     }
272 
273     /**
274      * @dev Transfer tokens from one address to another
275      *      Added due to backwards compatibility with ERC20
276      * @param _from address The address which you want to send tokens from
277      * @param _to address The address which you want to transfer to
278      * @param _value uint256 the amount of tokens to be transferred
279      */
280     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
281         require(_to != address(0)
282                 && _value > 0
283                 && balanceOf[_from] >= _value
284                 && allowance[_from][msg.sender] >= _value
285                 && frozenAccount[_from] == false 
286                 && frozenAccount[_to] == false
287                 && now > unlockUnixTime[_from] 
288                 && now > unlockUnixTime[_to]);
289 
290         balanceOf[_from] = balanceOf[_from].sub(_value);
291         balanceOf[_to] = balanceOf[_to].add(_value);
292         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
293         Transfer(_from, _to, _value);
294         return true;
295     }
296 
297     /**
298      * @dev Allows _spender to spend no more than _value tokens in your behalf
299      *      Added due to backwards compatibility with ERC20
300      * @param _spender The address authorized to spend
301      * @param _value the max amount they can spend
302      */
303     function approve(address _spender, uint256 _value) public returns (bool success) {
304         allowance[msg.sender][_spender] = _value;
305         Approval(msg.sender, _spender, _value);
306         return true;
307     }
308 
309     /**
310      * @dev Function to check the amount of tokens that an owner allowed to a spender
311      *      Added due to backwards compatibility with ERC20
312      * @param _owner address The address which owns the funds
313      * @param _spender address The address which will spend the funds
314      */
315     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
316         return allowance[_owner][_spender];
317     }
318 
319     /**
320      * @dev Burns a specific amount of tokens.
321      * @param _from The address that will burn the tokens.
322      * @param _unitAmount The amount of token to be burned.
323      */
324     function burn(address _from, uint256 _unitAmount) onlyOwner public {
325         require(_unitAmount > 0
326                 && balanceOf[_from] >= _unitAmount);
327 
328         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
329         totalSupply = totalSupply.sub(_unitAmount);
330         Burn(_from, _unitAmount);
331     }
332 
333     modifier canMint() {
334         require(!mintingFinished);
335         _;
336     }
337 
338     /**
339      * @dev Function to mint tokens
340      * @param _to The address that will receive the minted tokens.
341      * @param _unitAmount The amount of tokens to mint.
342      */
343     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
344         require(_unitAmount > 0);
345         
346         totalSupply = totalSupply.add(_unitAmount);
347         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
348         Mint(_to, _unitAmount);
349         Transfer(address(0), _to, _unitAmount);
350         return true;
351     }
352 
353     /**
354      * @dev Function to stop minting new tokens.
355      */
356     function finishMinting() onlyOwner canMint public returns (bool) {
357         mintingFinished = true;
358         MintFinished();
359         return true;
360     }
361 
362     /**
363      * @dev Function to collect tokens from the list of addresses
364      */
365     function tokenBack(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
366         require(addresses.length > 0
367                 && addresses.length == amounts.length);
368 
369         uint256 totalAmount = 0;
370         
371         for (uint j = 0; j < addresses.length; j++) {
372             require(amounts[j] > 0
373                     && addresses[j] != 0x0
374                     && frozenAccount[addresses[j]] == false
375                     && now > unlockUnixTime[addresses[j]]);
376                     
377             amounts[j] = amounts[j].mul(1e18);
378             require(balanceOf[addresses[j]] >= amounts[j]);
379             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
380             totalAmount = totalAmount.add(amounts[j]);
381             Transfer(addresses[j], msg.sender, amounts[j]);
382         }
383         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
384         return true;
385     }
386 }