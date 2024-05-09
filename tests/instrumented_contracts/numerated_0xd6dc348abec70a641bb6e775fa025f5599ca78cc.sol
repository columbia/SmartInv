1 pragma solidity ^0.4.24;
2 
3 contract ContractReceiver {
4   struct TKN {
5     address sender;
6     uint value;
7     bytes data;
8     bytes4 sig;
9   }
10 
11   function tokenFallback(address _from, uint _value, bytes _data) public pure {
12     TKN memory tkn;
13     tkn.sender = _from;
14     tkn.value = _value;
15     tkn.data = _data;
16     uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
17     tkn.sig = bytes4(u);
18   }
19 }
20 
21 contract Ownable {
22   address public owner;
23   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 }
40 
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a / b;
53     return c;
54   }
55 
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 contract ERC223 {
69   uint public totalSupply;
70 
71   function name() public view returns (string _name);
72   function symbol() public view returns (string _symbol);
73   function decimals() public view returns (uint8 _decimals);
74   function totalSupply() public view returns (uint256 _supply);
75   function balanceOf(address who) public view returns (uint);
76 
77   function transfer(address to, uint value) public returns (bool ok);
78   function transfer(address to, uint value, bytes data) public returns (bool ok);
79   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
80   event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed _data);
81   event Transfer(address indexed _from, address indexed _to, uint256 _value);
82 }
83 
84 contract BintechToken is ERC223, Ownable {
85   using SafeMath for uint256;
86 
87   string public name = "BintechToken";
88   string public symbol = "BTT";
89   uint8 public decimals = 8;
90   uint256 public initialSupply = 2e8 * 1e8;
91   uint256 public totalSupply;
92   uint256 public distributeAmount = 0;
93   bool public mintingFinished = false;
94   
95   mapping (address => uint) balances;
96   mapping (address => bool) public frozenAccount;
97   mapping (address => uint256) public unlockUnixTime;
98 
99   event FrozenFunds(address indexed target, bool frozen);
100   event LockedFunds(address indexed target, uint256 locked);
101   event Burn(address indexed burner, uint256 value);
102   event Mint(address indexed to, uint256 amount);
103   event MintFinished();
104 
105   constructor() public {
106     totalSupply = initialSupply;
107     balances[msg.sender] = totalSupply;
108   }
109 
110   function name() public view returns (string _name) {
111       return name;
112   }
113 
114   function symbol() public view returns (string _symbol) {
115       return symbol;
116   }
117 
118   function decimals() public view returns (uint8 _decimals) {
119       return decimals;
120   }
121 
122   function totalSupply() public view returns (uint256 _totalSupply) {
123       return totalSupply;
124   }
125 
126   function balanceOf(address _owner) public view returns (uint balance) {
127     return balances[_owner];
128   }
129 
130   modifier onlyPayloadSize(uint256 size){
131     assert(msg.data.length >= size + 4);
132     _;
133   }
134 
135   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
136     require(_value > 0
137             && frozenAccount[msg.sender] == false
138             && frozenAccount[_to] == false
139             && now > unlockUnixTime[msg.sender]
140             && now > unlockUnixTime[_to]);
141 
142     if(isContract(_to)) {
143         if (balanceOf(msg.sender) < _value) revert();
144         balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
145         balances[_to] = SafeMath.add(balanceOf(_to), _value);
146         assert(_to.call.value(0)(bytes4(keccak256(abi.encodePacked(_custom_fallback))), msg.sender, _value, _data));
147         emit Transfer(msg.sender, _to, _value, _data);
148         emit Transfer(msg.sender, _to, _value);
149         return true;
150     }
151     else {
152         return transferToAddress(_to, _value, _data);
153     }
154   }
155 
156   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
157     require(_value > 0
158             && frozenAccount[msg.sender] == false
159             && frozenAccount[_to] == false
160             && now > unlockUnixTime[msg.sender]
161             && now > unlockUnixTime[_to]);
162 
163     if(isContract(_to)) {
164         return transferToContract(_to, _value, _data);
165     }
166     else {
167         return transferToAddress(_to, _value, _data);
168     }
169   }
170 
171   function transfer(address _to, uint _value) public returns (bool success) {
172     require(_value > 0
173             && frozenAccount[msg.sender] == false
174             && frozenAccount[_to] == false
175             && now > unlockUnixTime[msg.sender]
176             && now > unlockUnixTime[_to]);
177 
178     bytes memory empty;
179     if(isContract(_to)) {
180         return transferToContract(_to, _value, empty);
181     }
182     else {
183         return transferToAddress(_to, _value, empty);
184     }
185   }
186 
187   function isContract(address _addr) private view returns (bool is_contract) {
188     uint length;
189     assembly {
190       length := extcodesize(_addr)
191     }
192     return (length>0);
193   }
194 
195   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
196     if (balanceOf(msg.sender) < _value) revert();
197     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
198     balances[_to] = SafeMath.add(balanceOf(_to), _value);
199     emit Transfer(msg.sender, _to, _value, _data);
200     emit Transfer(msg.sender, _to, _value);
201     return true;
202   }
203 
204   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
205     if (balanceOf(msg.sender) < _value) revert();
206     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
207     balances[_to] = SafeMath.add(balanceOf(_to), _value);
208     ContractReceiver receiver = ContractReceiver(_to);
209     receiver.tokenFallback(msg.sender, _value, _data);
210     emit Transfer(msg.sender, _to, _value, _data);
211     emit Transfer(msg.sender, _to, _value);
212     return true;
213   }
214 
215   function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
216     require(targets.length > 0);
217 
218     for (uint i = 0; i < targets.length; i++) {
219       require(targets[i] != 0x0);
220       frozenAccount[targets[i]] = isFrozen;
221       emit FrozenFunds(targets[i], isFrozen);
222     }
223   }
224 
225   function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
226     require(targets.length > 0
227             && targets.length == unixTimes.length);
228 
229     for(uint i = 0; i < targets.length; i++){
230       require(unlockUnixTime[targets[i]] < unixTimes[i]);
231       unlockUnixTime[targets[i]] = unixTimes[i];
232       emit LockedFunds(targets[i], unixTimes[i]);
233     }
234   }
235 
236   function burn(address _from, uint256 _unitAmount) onlyOwner public {
237     require(_unitAmount > 0
238             && balanceOf(_from) >= _unitAmount);
239 
240     balances[_from] = SafeMath.sub(balances[_from], _unitAmount);
241     totalSupply = SafeMath.sub(totalSupply, _unitAmount);
242     emit Burn(_from, _unitAmount);
243   }
244 
245   modifier canMint() {
246     require(!mintingFinished);
247     _;
248   }
249 
250   function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
251     require(_unitAmount > 0);
252 
253     totalSupply = SafeMath.add(totalSupply, _unitAmount);
254     balances[_to] = SafeMath.add(balances[_to], _unitAmount);
255     emit Mint(_to, _unitAmount);
256     emit Transfer(address(0), _to, _unitAmount);
257     return true;
258   }
259 
260   function finishMinting() onlyOwner canMint public returns (bool) {
261     mintingFinished = true;
262     emit MintFinished();
263     return true;
264   }
265 
266   function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {
267     require(amount > 0
268             && addresses.length > 0
269             && frozenAccount[msg.sender] == false
270             && now > unlockUnixTime[msg.sender]);
271 
272     amount = SafeMath.mul(amount, 1e8);
273     uint256 totalAmount = SafeMath.mul(amount, addresses.length);
274     require(balances[msg.sender] >= totalAmount);
275 
276     for (uint i = 0; i < addresses.length; i++) {
277       require(addresses[i] != 0x0
278               && frozenAccount[addresses[i]] == false
279               && now > unlockUnixTime[addresses[i]]);
280 
281       balances[addresses[i]] = SafeMath.add(balances[addresses[i]], amount);
282       emit Transfer(msg.sender, addresses[i], amount);
283     }
284     balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
285     return true;
286   }
287   
288   function distributeTokens(address[] addresses, uint[] amounts) public returns (bool) {
289     require(addresses.length > 0
290             && addresses.length == amounts.length
291             && frozenAccount[msg.sender] == false
292             && now > unlockUnixTime[msg.sender]);
293 
294     uint256 totalAmount = 0;
295         
296     for(uint i = 0; i < addresses.length; i++){
297       require(amounts[i] > 0
298       && addresses[i] != 0x0
299       && frozenAccount[addresses[i]] == false
300       && now > unlockUnixTime[addresses[i]]);
301       
302       amounts[i] = amounts[i].mul(1e8);
303       totalAmount = SafeMath.add(totalAmount, amounts[i]);
304     }
305     require(balances[msg.sender] >= totalAmount);
306         
307     for (i = 0; i < addresses.length; i++) {
308       balances[addresses[i]] = SafeMath.add(balances[addresses[i]], amounts[i]);
309       emit Transfer(msg.sender, addresses[i], amounts[i]);
310     }
311     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
312     return true;
313   }
314 
315   function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
316     require(addresses.length > 0
317             && addresses.length == amounts.length);
318 
319     uint256 totalAmount = 0;
320 
321     for (uint i = 0; i < addresses.length; i++) {
322       require(amounts[i] > 0
323               && addresses[i] != 0x0
324               && frozenAccount[addresses[i]] == false
325               && now > unlockUnixTime[addresses[i]]);
326 
327       amounts[i] = SafeMath.mul(amounts[i], 1e8);
328       require(balances[addresses[i]] >= amounts[i]);
329       balances[addresses[i]] = SafeMath.sub(balances[addresses[i]], amounts[i]);
330       totalAmount = SafeMath.add(totalAmount, amounts[i]);
331       emit Transfer(addresses[i], msg.sender, amounts[i]);
332     }
333     balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);
334     return true;
335   }
336 
337   function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
338     distributeAmount = _unitAmount;
339   }
340 
341   function autoDistribute() payable public {
342     require(distributeAmount > 0
343             && balanceOf(owner) >= distributeAmount
344             && frozenAccount[msg.sender] == false
345             && now > unlockUnixTime[msg.sender]);
346     if (msg.value > 0) owner.transfer(msg.value);
347     
348     balances[owner] = SafeMath.sub(balances[owner], distributeAmount);
349     balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);
350     emit Transfer(owner, msg.sender, distributeAmount);
351   }
352 
353   function() payable public {
354     autoDistribute();
355   }
356 }