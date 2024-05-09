1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title QR BitCoin in ERC20
5  */
6 contract ERC20 {
7    
8     //functions
9     function balanceOf(address _owner) external view returns (uint256);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
13     function approve(address _spender, uint256 _value) external returns (bool success);
14     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
15     function name() external constant returns  (string _name);
16     function symbol() external constant returns  (string _symbol);
17     function decimals() external constant returns (uint8 _decimals);
18     function totalSupply() external constant returns (uint256 _totalSupply);
19    
20     //Events
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
23     event Approval(address indexed _owner, address indexed _spender, uint _value);
24     event Burn(address indexed burner, uint256 value);
25     event FrozenAccount(address indexed targets);
26     event UnfrozenAccount(address indexed target);
27     event LockedAccount(address indexed target, uint256 locked);
28     event UnlockedAccount(address indexed target);
29 }
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40         uint256 c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // assert(b > 0); // Solidity automatically throws when dividing by 0
47         uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 contract ERC20Receive {
65 
66     TKN internal fallback;
67 
68     struct TKN {
69         address sender;
70         uint value;
71         bytes data;
72         bytes4 sig;
73     }
74 
75     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
76         TKN memory tkn;
77         tkn.sender = _from;
78         tkn.value = _value;
79         tkn.data = _data;
80         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
81         tkn.sig = bytes4(u);
82 
83        
84     }
85 }
86 
87 contract Ownable {
88     
89     address public owner;
90 
91     event OwnershipRenounced(address indexed previousOwner);
92     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
93 
94     constructor() public {
95         owner = msg.sender;
96     }
97 
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102 
103     function renounceOwnership() public onlyOwner {
104         emit OwnershipRenounced(owner);
105         owner = address(0);
106     }
107 
108     function transferOwnership(address _newOwner) public onlyOwner {
109         _transferOwnership(_newOwner);
110     }
111 
112     function _transferOwnership(address _newOwner) internal {
113         require(_newOwner != address(0));
114         emit OwnershipTransferred(owner, _newOwner);
115         owner = _newOwner;
116     }
117 }
118 
119 
120 /**
121  * @title QR BitCoin Main
122  */
123 contract QRBitCoin is ERC20, Ownable {
124 
125     using SafeMath for uint;
126     string public name = "QR BitCoin";
127     string public symbol = "QRBC";
128     uint8 public decimals = 8;
129     uint256 public totalSupply = 15300000000 * (10 ** uint256(decimals));
130 
131     
132     mapping (address => bool) public frozenAccount;
133     mapping (address => uint256) public unlockUnixTime;
134 
135     constructor() public {
136         balances[msg.sender] = totalSupply;
137     }
138 
139     mapping (address => uint256) public balances;
140 
141     mapping(address => mapping (address => uint256)) public allowance;
142 
143    
144     function name() external constant returns (string _name) {
145         return name;
146     }
147    
148     function symbol() external constant returns (string _symbol) {
149         return symbol;
150     }
151    
152     function decimals() external constant returns (uint8 _decimals) {
153         return decimals;
154     }
155    
156     function totalSupply() external constant returns (uint256 _totalSupply) {
157         return totalSupply;
158     }
159 
160    
161     function balanceOf(address _owner) external view returns (uint256 balance) {
162         return balances[_owner];
163     }
164    
165     function transfer(address _to, uint _value) public returns (bool success) {
166         require(_value > 0
167                 && frozenAccount[msg.sender] == false
168                 && frozenAccount[_to] == false
169                 && now > unlockUnixTime[msg.sender]
170                 && now > unlockUnixTime[_to]
171                 && _to != address(this));
172         bytes memory empty = hex"00000000";
173         if (isContract(_to)) {
174             return transferToContract(_to, _value, empty);
175         } else {
176             return transferToAddress(_to, _value, empty);
177         }
178     }
179 
180     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
181         require(_value > 0
182                 && frozenAccount[msg.sender] == false
183                 && frozenAccount[_to] == false
184                 && now > unlockUnixTime[msg.sender]
185                 && now > unlockUnixTime[_to]
186                 && _to != address(this));
187         if (isContract(_to)) {
188             return transferToContract(_to, _value, _data);
189         } else {
190             return transferToAddress(_to, _value, _data);
191         }
192     }
193 
194     function isContract(address _addr) private view returns (bool is_contract) {
195         uint length;
196         assembly {
197             //retrieve the size of the code on target address, this needs assembly
198             length := extcodesize(_addr)
199         }
200         return (length > 0);
201     }
202    
203     function approve(address _spender, uint256 _value) external returns (bool success) {
204         allowance[msg.sender][_spender] = 0; // mitigate the race condition
205         allowance[msg.sender][_spender] = _value;
206         emit Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     
211     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
212         return allowance[_owner][_spender];
213     }
214 
215 
216     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
217         require(balances[msg.sender] >= _value);
218         balances[msg.sender] = balances[msg.sender].sub(_value);
219         balances[_to] = balances[_to].add(_value);
220         emit ERC223Transfer(msg.sender, _to, _value, _data);
221         emit Transfer(msg.sender, _to, _value);
222         return true;
223     }
224 
225     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
226         require(balances[msg.sender] >= _value);
227         balances[msg.sender] = balances[msg.sender].sub(_value);
228         balances[_to] = balances[_to].add(_value);
229         ERC20Receive receiver = ERC20Receive(_to);
230         receiver.tokenFallback(msg.sender, _value, _data);
231         emit ERC223Transfer(msg.sender, _to, _value, _data);
232         emit Transfer(msg.sender, _to, _value);
233         return true;
234     }
235     
236     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
237         require(_to != address(0)
238                 && _value > 0
239                 && balances[_from] >= _value
240                 && allowance[_from][msg.sender] >= _value
241                 && frozenAccount[_from] == false
242                 && frozenAccount[_to] == false
243                 && now > unlockUnixTime[_from]
244                 && now > unlockUnixTime[_to]);
245 
246         balances[_from] = balances[_from].sub(_value);
247         balances[_to] = balances[_to].add(_value);
248         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
249         emit Transfer(_from, _to, _value);
250         return true;
251     }
252   
253     
254     function multiTransfer(address[] _addresses, uint256 _amount) public returns (bool) {
255         require(_amount > 0
256                 && _addresses.length > 0
257                 && frozenAccount[msg.sender] == false
258                 && now > unlockUnixTime[msg.sender]);
259 
260         uint256 totalAmount = _amount.mul(_addresses.length);
261         require(balances[msg.sender] >= totalAmount);
262 
263         for (uint j = 0; j < _addresses.length; j++) {
264             require(_addresses[j] != 0x0
265                     && frozenAccount[_addresses[j]] == false
266                     && now > unlockUnixTime[_addresses[j]]);
267                     
268             balances[msg.sender] = balances[msg.sender].sub(_amount);
269             balances[_addresses[j]] = balances[_addresses[j]].add(_amount);
270             emit Transfer(msg.sender, _addresses[j], _amount);
271         }
272         return true;
273     }
274 
275     function multiTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {
276         require(_addresses.length > 0
277                 && _addresses.length == _amounts.length
278                 && frozenAccount[msg.sender] == false
279                 && now > unlockUnixTime[msg.sender]);
280 
281         uint256 totalAmount = 0;
282 
283         for(uint j = 0; j < _addresses.length; j++){
284             require(_amounts[j] > 0
285                     && _addresses[j] != 0x0
286                     && frozenAccount[_addresses[j]] == false
287                     && now > unlockUnixTime[_addresses[j]]);
288 
289             totalAmount = totalAmount.add(_amounts[j]);
290         }
291         require(balances[msg.sender] >= totalAmount);
292 
293         for (j = 0; j < _addresses.length; j++) {
294             balances[msg.sender] = balances[msg.sender].sub(_amounts[j]);
295             balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
296             emit Transfer(msg.sender, _addresses[j], _amounts[j]);
297         }
298         return true;
299     }
300 
301     function burn(address _from, uint256 _tokenAmount) onlyOwner public {
302         require(_tokenAmount > 0
303                 && balances[_from] >= _tokenAmount);
304         
305         balances[_from] = balances[_from].sub(_tokenAmount);
306         totalSupply = totalSupply.sub(_tokenAmount);
307         emit Burn(_from, _tokenAmount);
308     }
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
354 
355 }