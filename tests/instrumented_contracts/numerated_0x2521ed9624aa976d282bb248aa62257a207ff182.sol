1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title  Heaven in ERC20
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
20 
21     //Events
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
24     event Approval(address indexed _owner, address indexed _spender, uint _value);
25     event Burn(address indexed burner, uint256 value);
26     event FrozenAccount(address indexed targets);
27     event UnfrozenAccount(address indexed target);
28     event LockedAccount(address indexed target, uint256 locked);
29     event UnlockedAccount(address indexed target);
30 }
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 
37 library SafeMath {
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // assert(b > 0); // Solidity automatically throws when dividing by 0
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 contract ERC20Receive {
67 
68     TKN internal fallback;
69 
70     struct TKN {
71         address sender;
72         uint value;
73         bytes data;
74         bytes4 sig;
75     }
76 
77     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
78         TKN memory tkn;
79         tkn.sender = _from;
80         tkn.value = _value;
81         tkn.data = _data;
82         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
83         tkn.sig = bytes4(u);
84 
85        
86     }
87 }
88 
89 contract Ownable {
90     
91     address public owner;
92 
93     event OwnershipRenounced(address indexed previousOwner);
94     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
95 
96     constructor() public {
97         owner = msg.sender;
98     }
99 
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     function renounceOwnership() public onlyOwner {
106         emit OwnershipRenounced(owner);
107         owner = address(0);
108     }
109 
110     function transferOwnership(address _newOwner) public onlyOwner {
111         _transferOwnership(_newOwner);
112     }
113 
114     function _transferOwnership(address _newOwner) internal {
115         require(_newOwner != address(0));
116         emit OwnershipTransferred(owner, _newOwner);
117         owner = _newOwner;
118     }
119 }
120 
121 
122 /**
123  * @title Heaven Main
124  */
125 contract Heaven is ERC20, Ownable {
126 
127     using SafeMath for uint;
128     string public name = "Heaven";
129     string public symbol = "HCOIN";
130     uint8 public decimals = 8;
131     uint256 public totalSupply = 15300000000 * (10 ** uint256(decimals));
132 
133     
134     mapping (address => bool) public frozenAccount;
135     mapping (address => uint256) public unlockUnixTime;
136 
137     constructor() public {
138         balances[msg.sender] = totalSupply;
139     }
140 
141     mapping (address => uint256) public balances;
142 
143     mapping(address => mapping (address => uint256)) public allowance;
144 
145    
146     function name() external constant returns (string _name) {
147         return name;
148     }
149    
150     function symbol() external constant returns (string _symbol) {
151         return symbol;
152     }
153    
154     function decimals() external constant returns (uint8 _decimals) {
155         return decimals;
156     }
157    
158     function totalSupply() external constant returns (uint256 _totalSupply) {
159         return totalSupply;
160     }
161 
162    
163     function balanceOf(address _owner) external view returns (uint256 balance) {
164         return balances[_owner];
165     }
166    
167     function transfer(address _to, uint _value) public returns (bool success) {
168         require(_value > 0
169                 && frozenAccount[msg.sender] == false
170                 && frozenAccount[_to] == false
171                 && now > unlockUnixTime[msg.sender]
172                 && now > unlockUnixTime[_to]
173                 && _to != address(this));
174         bytes memory empty = hex"00000000";
175         if (isContract(_to)) {
176             return transferToContract(_to, _value, empty);
177         } else {
178             return transferToAddress(_to, _value, empty);
179         }
180     }
181 
182     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
183         require(_value > 0
184                 && frozenAccount[msg.sender] == false
185                 && frozenAccount[_to] == false
186                 && now > unlockUnixTime[msg.sender]
187                 && now > unlockUnixTime[_to]
188                 && _to != address(this));
189         if (isContract(_to)) {
190             return transferToContract(_to, _value, _data);
191         } else {
192             return transferToAddress(_to, _value, _data);
193         }
194     }
195 
196     function isContract(address _addr) private view returns (bool is_contract) {
197         uint length;
198         assembly {
199             //retrieve the size of the code on target address, this needs assembly
200             length := extcodesize(_addr)
201         }
202         return (length > 0);
203     }
204    
205     function approve(address _spender, uint256 _value) external returns (bool success) {
206         allowance[msg.sender][_spender] = 0; // mitigate the race condition
207         allowance[msg.sender][_spender] = _value;
208         emit Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     
213     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
214         return allowance[_owner][_spender];
215     }
216 
217 
218     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
219         require(balances[msg.sender] >= _value);
220         balances[msg.sender] = balances[msg.sender].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         emit ERC223Transfer(msg.sender, _to, _value, _data);
223         emit Transfer(msg.sender, _to, _value);
224         return true;
225     }
226 
227     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
228         require(balances[msg.sender] >= _value);
229         balances[msg.sender] = balances[msg.sender].sub(_value);
230         balances[_to] = balances[_to].add(_value);
231         ERC20Receive receiver = ERC20Receive(_to);
232         receiver.tokenFallback(msg.sender, _value, _data);
233         emit ERC223Transfer(msg.sender, _to, _value, _data);
234         emit Transfer(msg.sender, _to, _value);
235         return true;
236     }
237     
238     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
239         require(_to != address(0)
240                 && _value > 0
241                 && balances[_from] >= _value
242                 && allowance[_from][msg.sender] >= _value
243                 && frozenAccount[_from] == false
244                 && frozenAccount[_to] == false
245                 && now > unlockUnixTime[_from]
246                 && now > unlockUnixTime[_to]);
247 
248         balances[_from] = balances[_from].sub(_value);
249         balances[_to] = balances[_to].add(_value);
250         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
251         emit Transfer(_from, _to, _value);
252         return true;
253     }
254   
255     
256     function multiTransfer(address[] _addresses, uint256 _amount) public returns (bool) {
257         require(_amount > 0
258                 && _addresses.length > 0
259                 && frozenAccount[msg.sender] == false
260                 && now > unlockUnixTime[msg.sender]);
261 
262         uint256 totalAmount = _amount.mul(_addresses.length);
263         require(balances[msg.sender] >= totalAmount);
264 
265         for (uint j = 0; j < _addresses.length; j++) {
266             require(_addresses[j] != 0x0
267                     && frozenAccount[_addresses[j]] == false
268                     && now > unlockUnixTime[_addresses[j]]);
269                     
270             balances[msg.sender] = balances[msg.sender].sub(_amount);
271             balances[_addresses[j]] = balances[_addresses[j]].add(_amount);
272             emit Transfer(msg.sender, _addresses[j], _amount);
273         }
274         return true;
275     }
276 
277     function multiTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {
278         require(_addresses.length > 0
279                 && _addresses.length == _amounts.length
280                 && frozenAccount[msg.sender] == false
281                 && now > unlockUnixTime[msg.sender]);
282 
283         uint256 totalAmount = 0;
284 
285         for(uint j = 0; j < _addresses.length; j++){
286             require(_amounts[j] > 0
287                     && _addresses[j] != 0x0
288                     && frozenAccount[_addresses[j]] == false
289                     && now > unlockUnixTime[_addresses[j]]);
290 
291             totalAmount = totalAmount.add(_amounts[j]);
292         }
293         require(balances[msg.sender] >= totalAmount);
294 
295         for (j = 0; j < _addresses.length; j++) {
296             balances[msg.sender] = balances[msg.sender].sub(_amounts[j]);
297             balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
298             emit Transfer(msg.sender, _addresses[j], _amounts[j]);
299         }
300         return true;
301     }
302 
303     function burn(address _from, uint256 _tokenAmount) onlyOwner public {
304         require(_tokenAmount > 0
305                 && balances[_from] >= _tokenAmount);
306         
307         balances[_from] = balances[_from].sub(_tokenAmount);
308         totalSupply = totalSupply.sub(_tokenAmount);
309         emit Burn(_from, _tokenAmount);
310     }
311         
312     function freezeAccounts(address[] _targets) onlyOwner public {
313         require(_targets.length > 0);
314 
315         for (uint j = 0; j < _targets.length; j++) {
316             require(_targets[j] != 0x0 && _targets[j] != Ownable.owner);
317             frozenAccount[_targets[j]] = true;
318             emit FrozenAccount(_targets[j]);
319         }
320     }
321     
322     
323     function unfreezeAccounts(address[] _targets) onlyOwner public {
324         require(_targets.length > 0);
325 
326         for (uint j = 0; j < _targets.length; j++) {
327             require(_targets[j] != 0x0 && _targets[j] != Ownable.owner);
328             frozenAccount[_targets[j]] = false;
329             emit UnfrozenAccount(_targets[j]);
330         }
331     }
332     
333    
334     function lockAccounts(address[] _targets, uint[] _unixTimes) onlyOwner public {
335         require(_targets.length > 0
336                 && _targets.length == _unixTimes.length);
337 
338         for(uint j = 0; j < _targets.length; j++){
339             require(_targets[j] != Ownable.owner);
340             require(unlockUnixTime[_targets[j]] < _unixTimes[j]);
341             unlockUnixTime[_targets[j]] = _unixTimes[j];
342             emit LockedAccount(_targets[j], _unixTimes[j]);
343         }
344     }
345 
346     function unlockAccounts(address[] _targets) onlyOwner public {
347         require(_targets.length > 0);
348          
349         for(uint j = 0; j < _targets.length; j++){
350             unlockUnixTime[_targets[j]] = 0;
351             emit UnlockedAccount(_targets[j]);
352         }
353     }
354     
355     
356 
357 }