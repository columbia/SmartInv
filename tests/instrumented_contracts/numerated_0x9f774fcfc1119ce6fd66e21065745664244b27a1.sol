1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ellex Coin in ERC20
5  */
6 contract ERC20 {
7    
8     //functions
9     
10     function name() external constant returns  (string _name);
11     function symbol() external constant returns  (string _symbol);
12     function decimals() external constant returns (uint8 _decimals);
13     function totalSupply() external constant returns (uint256 _totalSupply);
14     
15     function balanceOf(address _owner) external view returns (uint256);
16     function transfer(address _to, uint256 _value) public returns (bool success);
17     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
19     function approve(address _spender, uint256 _value) external returns (bool success);
20     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
21 
22     //Events
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
25     event Approval(address indexed _owner, address indexed _spender, uint _value);
26     event Burn(address indexed burner, uint256 value);
27     event FrozenAccount(address indexed targets);
28     event UnfrozenAccount(address indexed target);
29     event LockedAccount(address indexed target, uint256 locked);
30     event UnlockedAccount(address indexed target);
31 }
32 
33 contract ERC20Receive {
34 
35     TKN internal fallback;
36 
37     struct TKN {
38         address sender;
39         uint value;
40         bytes data;
41         bytes4 sig;
42     }
43 
44     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
45         TKN memory tkn;
46         tkn.sender = _from;
47         tkn.value = _value;
48         tkn.data = _data;
49         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
50         tkn.sig = bytes4(u);
51 
52        
53     }
54 }
55 
56 /**
57  * @title SafeMath
58  * @dev Math operations with safety checks that throw on error
59  */
60 library SafeMath {
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         assert(c / a == b);
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // assert(b > 0); // Solidity automatically throws when dividing by 0
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return c;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         assert(b <= a);
79         return a - b;
80     }
81 
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         assert(c >= a);
85         return c;
86     }
87 }
88 
89 
90 contract Ownable {
91     
92     address public owner;
93 
94     event OwnershipRenounced(address indexed previousOwner);
95     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
96 
97     constructor() public {
98         owner = msg.sender;
99     }
100 
101     modifier onlyOwner() {
102         require(msg.sender == owner);
103         _;
104     }
105 
106     function renounceOwnership() public onlyOwner {
107         emit OwnershipRenounced(owner);
108         owner = address(0);
109     }
110 
111     function transferOwnership(address _newOwner) public onlyOwner {
112         _transferOwnership(_newOwner);
113     }
114 
115     function _transferOwnership(address _newOwner) internal {
116         require(_newOwner != address(0));
117         emit OwnershipTransferred(owner, _newOwner);
118         owner = _newOwner;
119     }
120 }
121 
122 
123 
124 /**
125  * @title Ellex Coin in USA
126  */
127 contract EllexCoin is ERC20, Ownable {
128 
129     using SafeMath for uint;
130     string public name = "Ellex Coin";
131     string public symbol = "ELLEX";
132     uint8 public decimals = 18;
133     uint256 public totalSupply = 10e10 * (10 ** uint256(decimals));
134 
135     
136     mapping (address => bool) public frozenAccount;
137     mapping (address => uint256) public unlockUnixTime;
138 
139     constructor() public {
140         balances[msg.sender] = totalSupply;
141     }
142 
143     mapping (address => uint256) public balances;
144 
145     mapping(address => mapping (address => uint256)) public allowance;
146 
147    
148     function name() external constant returns (string _name) {
149         return name;
150     }
151    
152     function symbol() external constant returns (string _symbol) {
153         return symbol;
154     }
155    
156     function decimals() external constant returns (uint8 _decimals) {
157         return decimals;
158     }
159    
160     function totalSupply() external constant returns (uint256 _totalSupply) {
161         return totalSupply;
162     }
163 
164    
165     function balanceOf(address _owner) external view returns (uint256 balance) {
166         return balances[_owner];
167     }
168 
169    
170     function transfer(address _to, uint _value) public returns (bool success) {
171         require(_value > 0
172                 && frozenAccount[msg.sender] == false
173                 && frozenAccount[_to] == false
174                 && now > unlockUnixTime[msg.sender]
175                 && now > unlockUnixTime[_to]
176                 && _to != address(this));
177         bytes memory empty = hex"00000000";
178         if (isContract(_to)) {
179             return transferToContract(_to, _value, empty);
180         } else {
181             return transferToAddress(_to, _value, empty);
182         }
183     }
184 
185     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
186         require(_value > 0
187                 && frozenAccount[msg.sender] == false
188                 && frozenAccount[_to] == false
189                 && now > unlockUnixTime[msg.sender]
190                 && now > unlockUnixTime[_to]
191                 && _to != address(this));
192         if (isContract(_to)) {
193             return transferToContract(_to, _value, _data);
194         } else {
195             return transferToAddress(_to, _value, _data);
196         }
197     }
198 
199 
200     function isContract(address _addr) private view returns (bool is_contract) {
201         uint length;
202         assembly {
203             //retrieve the size of the code on target address, this needs assembly
204             length := extcodesize(_addr)
205         }
206         return (length > 0);
207     }
208    
209     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
210         require(balances[msg.sender] >= _value);
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         emit ERC223Transfer(msg.sender, _to, _value, _data);
214         emit Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
219         require(balances[msg.sender] >= _value);
220         balances[msg.sender] = balances[msg.sender].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         ERC20Receive receiver = ERC20Receive(_to);
223         receiver.tokenFallback(msg.sender, _value, _data);
224         emit ERC223Transfer(msg.sender, _to, _value, _data);
225         emit Transfer(msg.sender, _to, _value);
226         return true;
227     }
228 
229     
230     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
231         require(_to != address(0)
232                 && _value > 0
233                 && balances[_from] >= _value
234                 && allowance[_from][msg.sender] >= _value
235                 && frozenAccount[_from] == false
236                 && frozenAccount[_to] == false
237                 && now > unlockUnixTime[_from]
238                 && now > unlockUnixTime[_to]);
239 
240 
241         balances[_from] = balances[_from].sub(_value);
242         balances[_to] = balances[_to].add(_value);
243         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
244         emit Transfer(_from, _to, _value);
245         return true;
246     }
247 
248 
249     function approve(address _spender, uint256 _value) external returns (bool success) {
250         allowance[msg.sender][_spender] = 0; // mitigate the race condition
251         allowance[msg.sender][_spender] = _value;
252         emit Approval(msg.sender, _spender, _value);
253         return true;
254     }
255 
256     
257     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
258         return allowance[_owner][_spender];
259     }
260 
261     
262     function multiTransfer(address[] _addresses, uint256 _amount) public returns (bool) {
263         require(_amount > 0
264                 && _addresses.length > 0
265                 && frozenAccount[msg.sender] == false
266                 && now > unlockUnixTime[msg.sender]);
267 
268         uint256 totalAmount = _amount.mul(_addresses.length);
269         require(balances[msg.sender] >= totalAmount);
270 
271         for (uint j = 0; j < _addresses.length; j++) {
272             require(_addresses[j] != 0x0
273                     && frozenAccount[_addresses[j]] == false
274                     && now > unlockUnixTime[_addresses[j]]);
275                     
276             balances[msg.sender] = balances[msg.sender].sub(_amount);
277             balances[_addresses[j]] = balances[_addresses[j]].add(_amount);
278             emit Transfer(msg.sender, _addresses[j], _amount);
279         }
280         return true;
281     }
282 
283     function multiTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {
284         require(_addresses.length > 0
285                 && _addresses.length == _amounts.length
286                 && frozenAccount[msg.sender] == false
287                 && now > unlockUnixTime[msg.sender]);
288 
289         uint256 totalAmount = 0;
290 
291         for(uint j = 0; j < _addresses.length; j++){
292             require(_amounts[j] > 0
293                     && _addresses[j] != 0x0
294                     && frozenAccount[_addresses[j]] == false
295                     && now > unlockUnixTime[_addresses[j]]);
296 
297             totalAmount = totalAmount.add(_amounts[j]);
298         }
299         require(balances[msg.sender] >= totalAmount);
300 
301         for (j = 0; j < _addresses.length; j++) {
302             balances[msg.sender] = balances[msg.sender].sub(_amounts[j]);
303             balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
304             emit Transfer(msg.sender, _addresses[j], _amounts[j]);
305         }
306         return true;
307     }
308     
309     
310     function freezeAccounts(address[] _targets) onlyOwner public {
311         require(_targets.length > 0);
312 
313         for (uint j = 0; j < _targets.length; j++) {
314             require(_targets[j] != 0x0 && _targets[j] != Ownable.owner);
315             frozenAccount[_targets[j]] = true;
316             emit FrozenAccount(_targets[j]);
317         }
318     }
319     
320     
321     function unfreezeAccounts(address[] _targets) onlyOwner public {
322         require(_targets.length > 0);
323 
324         for (uint j = 0; j < _targets.length; j++) {
325             require(_targets[j] != 0x0 && _targets[j] != Ownable.owner);
326             frozenAccount[_targets[j]] = false;
327             emit UnfrozenAccount(_targets[j]);
328         }
329     }
330     
331    
332     function lockAccounts(address[] _targets, uint[] _unixTimes) onlyOwner public {
333         require(_targets.length > 0
334                 && _targets.length == _unixTimes.length);
335 
336         for(uint j = 0; j < _targets.length; j++){
337             require(_targets[j] != Ownable.owner);
338             require(unlockUnixTime[_targets[j]] < _unixTimes[j]);
339             unlockUnixTime[_targets[j]] = _unixTimes[j];
340             emit LockedAccount(_targets[j], _unixTimes[j]);
341         }
342     }
343 
344     function unlockAccounts(address[] _targets) onlyOwner public {
345         require(_targets.length > 0);
346          
347         for(uint j = 0; j < _targets.length; j++){
348             unlockUnixTime[_targets[j]] = 0;
349             emit UnlockedAccount(_targets[j]);
350         }
351     }
352 
353     
354     function burn(address _from, uint256 _tokenAmount) onlyOwner public {
355         require(_tokenAmount > 0
356                 && balances[_from] >= _tokenAmount);
357         
358         balances[_from] = balances[_from].sub(_tokenAmount);
359         totalSupply = totalSupply.sub(_tokenAmount);
360         emit Burn(_from, _tokenAmount);
361     }
362 
363 }