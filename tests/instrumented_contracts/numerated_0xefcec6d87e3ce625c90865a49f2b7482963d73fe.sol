1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     function Ownable() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address _newOwner) onlyOwner public returns (bool _success) {
45         require(_newOwner != address(0));
46         owner = _newOwner;
47         OwnershipTransferred(owner, _newOwner);
48         return true;
49     }
50 }
51 
52 contract Pausable is Ownable {
53     event Pause();
54     event Unpause();
55 
56     bool public paused = false;
57 
58     modifier whenNotPaused() {
59         require(!paused);
60         _;
61     }
62 
63     modifier whenPaused {
64         require(paused);
65         _;
66     }
67 
68     function isPaused() public view returns (bool _is_paused) {
69         return paused;
70     }
71 
72     function pause() onlyOwner whenNotPaused public returns (bool _success) {
73         paused = true;
74         Pause();
75         return true;
76     }
77 
78     function unpause() onlyOwner whenPaused public returns (bool _success) {
79         paused = false;
80         Unpause();
81         return true;
82     }
83 }
84 
85 contract ERC223 {
86     uint public totalSupply;
87 
88     function balanceOf(address who) public view returns (uint _balance);
89     function totalSupply() public view returns (uint256 _totalSupply);
90     function transfer(address to, uint value) public returns (bool _success);
91     function transfer(address to, uint value, bytes data) public returns (bool _success);
92     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool _success);
93     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
94 
95     function name() public view returns (string _name);
96     function symbol() public view returns (string _symbol);
97     function decimals() public view returns (uint8 _decimals);
98 
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success);
100     function approve(address _spender, uint256 _value) public returns (bool _success);
101     function allowance(address _owner, address _spender) public view returns (uint256 _remaining);
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint _value);
104 }
105 
106 
107 contract ContractReceiver {
108     struct TKN {
109         address sender;
110         uint value;
111         bytes data;
112         bytes4 sig;
113     }
114 
115     function tokenFallback(address _from, uint _value, bytes _data) public pure {
116         TKN memory tkn;
117         tkn.sender = _from;
118         tkn.value = _value;
119         tkn.data = _data;
120         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
121         tkn.sig = bytes4(u);
122     }
123 }
124 
125 contract FETCOIN is ERC223, Pausable {
126     using SafeMath for uint256;
127 
128     struct Offering {
129         uint256 amount;
130         uint256 locktime;
131     }
132 
133     string public name = "fetish coin";
134     string public symbol = "FET";
135     uint8 public decimals = 6;
136     uint256 public totalSupply = 10e10 * 1e6;
137 
138     mapping(address => uint256) public balanceOf;
139     mapping(address => mapping(address => uint256)) public allowance;
140     mapping(address => bool) public frozenAccount;
141 
142     mapping(address => mapping(address => Offering)) public offering;
143 
144     event Freeze(address indexed target, uint256 value);
145     event Unfreeze(address indexed target, uint256 value);
146     event Burn(address indexed from, uint256 amount);
147     event Rain(address indexed from, uint256 amount);
148 
149     function FETCOIN() public {
150         owner = msg.sender;
151         balanceOf[msg.sender] = totalSupply;
152     }
153 
154     function balanceOf(address _owner) public view returns (uint256 _balance) {
155         return balanceOf[_owner];
156     }
157 
158     function totalSupply() public view returns (uint256 _totalSupply) {
159         return totalSupply;
160     }
161 
162     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) whenNotPaused public returns (bool _success) {
163         require(_value > 0 && frozenAccount[msg.sender] == false && frozenAccount[_to] == false);
164 
165         if (isContract(_to)) {
166             require(balanceOf[msg.sender] >= _value);
167             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
168             balanceOf[_to] = balanceOf[_to].add(_value);
169             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
170             Transfer(msg.sender, _to, _value, _data);
171             Transfer(msg.sender, _to, _value);
172             return true;
173         } else {
174             return transferToAddress(_to, _value, _data);
175         }
176     }
177 
178     function transfer(address _to, uint _value, bytes _data) whenNotPaused public returns (bool _success) {
179         require(_value > 0 && frozenAccount[msg.sender] == false && frozenAccount[_to] == false);
180 
181         if (isContract(_to)) {
182             return transferToContract(_to, _value, _data);
183         } else {
184             return transferToAddress(_to, _value, _data);
185         }
186     }
187 
188     function transfer(address _to, uint _value) whenNotPaused public returns (bool _success) {
189         require(_value > 0 && frozenAccount[msg.sender] == false && frozenAccount[_to] == false);
190 
191         bytes memory empty;
192         if (isContract(_to)) {
193             return transferToContract(_to, _value, empty);
194         } else {
195             return transferToAddress(_to, _value, empty);
196         }
197     }
198 
199     function name() public view returns (string _name) {
200         return name;
201     }
202 
203     function symbol() public view returns (string _symbol) {
204         return symbol;
205     }
206 
207     function decimals() public view returns (uint8 _decimals) {
208         return decimals;
209     }
210 
211     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool _success) {
212         require(_to != address(0)
213             && _value > 0
214             && balanceOf[_from] >= _value
215             && allowance[_from][msg.sender] >= _value
216             && frozenAccount[_from] == false && frozenAccount[_to] == false);
217 
218         balanceOf[_from] = balanceOf[_from].sub(_value);
219         balanceOf[_to] = balanceOf[_to].add(_value);
220         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
221         Transfer(_from, _to, _value);
222         return true;
223     }
224 
225     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool _success) {
226         allowance[msg.sender][_spender] = _value;
227         Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     function allowance(address _owner, address _spender) public view returns (uint256 _remaining) {
232         return allowance[_owner][_spender];
233     }
234 
235     function freezeAccounts(address[] _targets) onlyOwner whenNotPaused public returns (bool _success) {
236         require(_targets.length > 0);
237 
238         for (uint j = 0; j < _targets.length; j++) {
239             require(_targets[j] != 0x0);
240             frozenAccount[_targets[j]] = true;
241             Freeze(_targets[j], balanceOf[_targets[j]]);
242         }
243         return true;
244     }
245 
246     function unfreezeAccounts(address[] _targets) onlyOwner whenNotPaused public returns (bool _success) {
247         require(_targets.length > 0);
248 
249         for (uint j = 0; j < _targets.length; j++) {
250             require(_targets[j] != 0x0);
251             frozenAccount[_targets[j]] = false;
252             Unfreeze(_targets[j], balanceOf[_targets[j]]);
253         }
254         return true;
255     }
256 
257     function isFrozenAccount(address _target) public view returns (bool _is_frozen){
258         return frozenAccount[_target] == true;
259     }
260 
261     function isContract(address _target) private view returns (bool _is_contract) {
262         uint length;
263         assembly {
264             length := extcodesize(_target)
265         }
266         return (length > 0);
267     }
268 
269     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool _success) {
270         require(balanceOf[msg.sender] >= _value);
271         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
272         balanceOf[_to] = balanceOf[_to].add(_value);
273         Transfer(msg.sender, _to, _value, _data);
274         Transfer(msg.sender, _to, _value);
275         return true;
276     }
277 
278     function transferToContract(address _to, uint _value, bytes _data) private returns (bool _success) {
279         require(balanceOf[msg.sender] >= _value);
280         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
281         balanceOf[_to] = balanceOf[_to].add(_value);
282         ContractReceiver receiver = ContractReceiver(_to);
283         receiver.tokenFallback(msg.sender, _value, _data);
284         Transfer(msg.sender, _to, _value, _data);
285         Transfer(msg.sender, _to, _value);
286         return true;
287     }
288 
289     function burn(address _from, uint256 _amount) onlyOwner whenNotPaused public returns (bool _success) {
290         require(_amount > 0 && balanceOf[_from] >= _amount);
291         _amount = _amount.mul(1e6);
292         balanceOf[_from] = balanceOf[_from].sub(_amount);
293         totalSupply = totalSupply.sub(_amount);
294         Burn(_from, _amount);
295         return true;
296     }
297 
298     function rain(address[] _addresses, uint256 _amount) onlyOwner whenNotPaused public returns (bool _success) {
299         require(_amount > 0 && _addresses.length > 0 && frozenAccount[msg.sender] == false);
300 
301         _amount = _amount.mul(1e6);
302         uint256 totalAmount = _amount.mul(_addresses.length);
303         require(balanceOf[msg.sender] >= totalAmount);
304 
305         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
306 
307         for (uint j = 0; j < _addresses.length; j++) {
308             require(_addresses[j] != 0x0 && frozenAccount[_addresses[j]] == false);
309 
310             balanceOf[_addresses[j]] = balanceOf[_addresses[j]].add(_amount);
311             Transfer(msg.sender, _addresses[j], _amount);
312         }
313         Rain(msg.sender, totalAmount);
314         return true;
315     }
316 
317     function collectTokens(address[] _addresses, uint[] _amounts) onlyOwner whenNotPaused public returns (bool _success) {
318         require(_addresses.length > 0 && _addresses.length == _amounts.length);
319 
320         uint256 totalAmount = 0;
321 
322         for (uint j = 0; j < _addresses.length; j++) {
323             require(_amounts[j] > 0 && _addresses[j] != 0x0 && frozenAccount[_addresses[j]] == false);
324             _amounts[j] = _amounts[j].mul(1e6);
325             require(balanceOf[_addresses[j]] >= _amounts[j]);
326             balanceOf[_addresses[j]] = balanceOf[_addresses[j]].sub(_amounts[j]);
327             totalAmount = totalAmount.add(_amounts[j]);
328             Transfer(_addresses[j], msg.sender, _amounts[j]);
329         }
330         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
331         return true;
332     }
333 
334     function() payable public {}
335 }