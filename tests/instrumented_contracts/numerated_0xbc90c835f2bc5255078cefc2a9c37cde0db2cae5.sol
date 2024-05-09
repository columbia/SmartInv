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
44     function transferOwnership(address newOwner) onlyOwner public {
45         require(newOwner != address(0));
46         OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 }
50 
51 contract ERC223 {
52     uint public totalSupply;
53 
54     function balanceOf(address who) public view returns (uint);
55     function totalSupply() public view returns (uint256 _supply);
56     function transfer(address to, uint value) public returns (bool ok);
57     function transfer(address to, uint value, bytes data) public returns (bool ok);
58     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
59     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
60 
61     function name() public view returns (string _name);
62     function symbol() public view returns (string _symbol);
63     function decimals() public view returns (uint8 _decimals);
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
66     function approve(address _spender, uint256 _value) public returns (bool success);
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint _value);
70 }
71 
72  contract ContractReceiver {
73 
74     struct TKN {
75         address sender;
76         uint value;
77         bytes data;
78         bytes4 sig;
79     }
80 
81     function tokenFallback(address _from, uint _value, bytes _data) public pure {
82         TKN memory tkn;
83         tkn.sender = _from;
84         tkn.value = _value;
85         tkn.data = _data;
86         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
87         tkn.sig = bytes4(u);
88     }
89 }
90 
91 contract OCTCOIN is ERC223, Ownable {
92     using SafeMath for uint256;
93 
94     string public name = "OCTCOIN";
95     string public symbol = "OCTC";
96     uint8 public decimals = 6;
97     uint256 public totalSupply = 50e9 * 1e6;
98     uint256 public distributeAmount = 0;
99     
100     mapping(address => uint256) public balanceOf;
101     mapping(address => mapping (address => uint256)) public allowance;
102     mapping (address => bool) public frozenAccount;
103     mapping (address => uint256) public unlockUnixTime;
104     
105     event FrozenFunds(address indexed target, bool frozen);
106     event LockedFunds(address indexed target, uint256 locked);
107     event Burn(address indexed from, uint256 amount);
108 
109     function OCTCOIN() public {
110         balanceOf[msg.sender] = totalSupply;
111     }
112 
113     function name() public view returns (string _name) {
114         return name;
115     }
116 
117     function symbol() public view returns (string _symbol) {
118         return symbol;
119     }
120 
121     function decimals() public view returns (uint8 _decimals) {
122         return decimals;
123     }
124 
125     function totalSupply() public view returns (uint256 _totalSupply) {
126         return totalSupply;
127     }
128 
129     function balanceOf(address _owner) public view returns (uint256 balance) {
130         return balanceOf[_owner];
131     }
132 
133     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
134         require(targets.length > 0);
135 
136         for (uint j = 0; j < targets.length; j++) {
137             require(targets[j] != 0x0);
138             frozenAccount[targets[j]] = isFrozen;
139             FrozenFunds(targets[j], isFrozen);
140         }
141     }
142 
143     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
144         require(targets.length > 0
145                 && targets.length == unixTimes.length);
146                 
147         for(uint j = 0; j < targets.length; j++){
148             require(unlockUnixTime[targets[j]] < unixTimes[j]);
149             unlockUnixTime[targets[j]] = unixTimes[j];
150             LockedFunds(targets[j], unixTimes[j]);
151         }
152     }
153 
154     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
155         require(_value > 0
156                 && frozenAccount[msg.sender] == false 
157                 && frozenAccount[_to] == false
158                 && now > unlockUnixTime[msg.sender] 
159                 && now > unlockUnixTime[_to]);
160 
161         if (isContract(_to)) {
162             require(balanceOf[msg.sender] >= _value);
163             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
164             balanceOf[_to] = balanceOf[_to].add(_value);
165             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
166             Transfer(msg.sender, _to, _value, _data);
167             Transfer(msg.sender, _to, _value);
168             return true;
169         } else {
170             return transferToAddress(_to, _value, _data);
171         }
172     }
173 
174     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
175         require(_value > 0
176                 && frozenAccount[msg.sender] == false 
177                 && frozenAccount[_to] == false
178                 && now > unlockUnixTime[msg.sender] 
179                 && now > unlockUnixTime[_to]);
180 
181         if (isContract(_to)) {
182             return transferToContract(_to, _value, _data);
183         } else {
184             return transferToAddress(_to, _value, _data);
185         }
186     }
187 
188     function transfer(address _to, uint _value) public returns (bool success) {
189         require(_value > 0
190                 && frozenAccount[msg.sender] == false 
191                 && frozenAccount[_to] == false
192                 && now > unlockUnixTime[msg.sender] 
193                 && now > unlockUnixTime[_to]);
194 
195         bytes memory empty;
196         if (isContract(_to)) {
197             return transferToContract(_to, _value, empty);
198         } else {
199             return transferToAddress(_to, _value, empty);
200         }
201     }
202 
203     function isContract(address _addr) private view returns (bool is_contract) {
204         uint length;
205         assembly {
206             length := extcodesize(_addr)
207         }
208         return (length > 0);
209     }
210 
211     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
212         require(balanceOf[msg.sender] >= _value);
213         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
214         balanceOf[_to] = balanceOf[_to].add(_value);
215         Transfer(msg.sender, _to, _value, _data);
216         Transfer(msg.sender, _to, _value);
217         return true;
218     }
219 
220     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
221         require(balanceOf[msg.sender] >= _value);
222         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
223         balanceOf[_to] = balanceOf[_to].add(_value);
224         ContractReceiver receiver = ContractReceiver(_to);
225         receiver.tokenFallback(msg.sender, _value, _data);
226         Transfer(msg.sender, _to, _value, _data);
227         Transfer(msg.sender, _to, _value);
228         return true;
229     }
230 
231     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
232         require(_to != address(0)
233                 && _value > 0
234                 && balanceOf[_from] >= _value
235                 && allowance[_from][msg.sender] >= _value
236                 && frozenAccount[_from] == false 
237                 && frozenAccount[_to] == false
238                 && now > unlockUnixTime[_from] 
239                 && now > unlockUnixTime[_to]);
240 
241         balanceOf[_from] = balanceOf[_from].sub(_value);
242         balanceOf[_to] = balanceOf[_to].add(_value);
243         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
244         Transfer(_from, _to, _value);
245         return true;
246     }
247 
248     function approve(address _spender, uint256 _value) public returns (bool success) {
249         allowance[msg.sender][_spender] = _value;
250         Approval(msg.sender, _spender, _value);
251         return true;
252     }
253 
254     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
255         return allowance[_owner][_spender];
256     }
257 
258     function burn(address _from, uint256 _unitAmount) onlyOwner public {
259         require(_unitAmount > 0
260                 && balanceOf[_from] >= _unitAmount);
261 
262         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
263         totalSupply = totalSupply.sub(_unitAmount);
264         Burn(_from, _unitAmount);
265     }
266 
267     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
268         require(amount > 0 
269                 && addresses.length > 0
270                 && frozenAccount[msg.sender] == false
271                 && now > unlockUnixTime[msg.sender]);
272 
273         amount = amount.mul(1e6);
274         uint256 totalAmount = amount.mul(addresses.length);
275         require(balanceOf[msg.sender] >= totalAmount);
276         
277         for (uint j = 0; j < addresses.length; j++) {
278             require(addresses[j] != 0x0
279                     && frozenAccount[addresses[j]] == false
280                     && now > unlockUnixTime[addresses[j]]);
281 
282             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
283             Transfer(msg.sender, addresses[j], amount);
284         }
285         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
286         return true;
287     }
288 
289     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
290         require(addresses.length > 0
291                 && addresses.length == amounts.length
292                 && frozenAccount[msg.sender] == false
293                 && now > unlockUnixTime[msg.sender]);
294                 
295         uint256 totalAmount = 0;
296         
297         for(uint j = 0; j < addresses.length; j++){
298             require(amounts[j] > 0
299                     && addresses[j] != 0x0
300                     && frozenAccount[addresses[j]] == false
301                     && now > unlockUnixTime[addresses[j]]);
302                     
303             amounts[j] = amounts[j].mul(1e6);
304             totalAmount = totalAmount.add(amounts[j]);
305         }
306         require(balanceOf[msg.sender] >= totalAmount);
307         
308         for (j = 0; j < addresses.length; j++) {
309             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
310             Transfer(msg.sender, addresses[j], amounts[j]);
311         }
312         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
313         return true;
314     }
315 
316     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
317         require(addresses.length > 0
318                 && addresses.length == amounts.length);
319 
320         uint256 totalAmount = 0;
321         
322         for (uint j = 0; j < addresses.length; j++) {
323             require(amounts[j] > 0
324                     && addresses[j] != 0x0
325                     && frozenAccount[addresses[j]] == false
326                     && now > unlockUnixTime[addresses[j]]);
327                     
328             amounts[j] = amounts[j].mul(1e6);
329             require(balanceOf[addresses[j]] >= amounts[j]);
330             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
331             totalAmount = totalAmount.add(amounts[j]);
332             Transfer(addresses[j], msg.sender, amounts[j]);
333         }
334         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
335         return true;
336     }
337 
338     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
339         distributeAmount = _unitAmount;
340     }
341     
342     function autoDistribute() payable public {
343         require(distributeAmount > 0
344                 && balanceOf[owner] >= distributeAmount
345                 && frozenAccount[msg.sender] == false
346                 && now > unlockUnixTime[msg.sender]);
347         if(msg.value > 0) owner.transfer(msg.value);
348         
349         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
350         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
351         Transfer(owner, msg.sender, distributeAmount);
352     }
353 
354     function() payable public {
355         autoDistribute();
356      }
357 }