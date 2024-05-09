1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     uint256 constant public MAX_UINT256 =
5     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
6 
7     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
8         if (x > MAX_UINT256 - y) throw;
9         return x + y;
10     }
11 
12     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
13         if (x < y) throw;
14         return x - y;
15     }
16 
17     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
18         if (y == 0) return 0;
19         if (x > MAX_UINT256 / y) throw;
20         return x * y;
21     }
22 }
23 
24 contract ERC223ReceivingContract {
25 
26     struct inr {
27         address sender;
28         uint value;
29         bytes data;
30         bytes4 sig;
31     }
32 
33       function tokenFallback(address _from, uint _value, bytes _data){
34       inr memory igniter;
35       igniter.sender = _from;
36       igniter.value = _value;
37       igniter.data = _data;
38       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
39       igniter.sig = bytes4(u);
40 
41     }
42 }
43 
44 contract iGniter is SafeMath {
45 
46   struct serPayment {
47     uint unlockedTime;
48     uint256 unlockedBlockNumber;
49   }
50 
51     string public name;
52     bytes32 public symbol;
53     uint8 public decimals;
54     uint256 public rewardPerBlockPerAddress;
55     uint256 public totalInitialAddresses;
56     uint256 public initialBlockCount;
57     uint256 private minedBlocks;
58     uint256 private iGniting;
59     uint256 private initialSupplyPerAddress;
60     uint256 private totalMaxAvailableAmount;
61     uint256 private availableAmount;
62     uint256 private burnt;
63     uint256 public inrSessions;
64     uint256 private availableBalance;
65     uint256 private balanceOfAddress;
66     uint256 private initialSupply;
67     uint256 private _totalSupply;
68     uint256 public currentCost;
69     uint256 private startBounty;
70     uint256 private finishBounty;
71 
72     mapping(address => uint256) public balanceOf;
73     mapping(address => uint) balances;
74     mapping(address => bool) public initialAddress;
75     mapping(address => bool) public bountyAddress;
76     mapping (address => mapping (address => uint)) internal _allowances;
77     mapping (address => serPayment) ignPayments;
78     address private _owner;
79 
80     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Burn(address indexed from, uint256 value);
83     event Approval(address indexed _owner, address indexed _spender, uint _value);
84     event LogBurn(address indexed owner, uint indexed value);
85 
86     modifier isOwner() {
87 
88       require(msg.sender == _owner);
89       _;
90     }
91 
92     function iGniter() {
93 
94         initialSupplyPerAddress = 10000000000; //10000
95         initialBlockCount = 4948670;
96         rewardPerBlockPerAddress = 7;
97         totalInitialAddresses = 5000;
98         initialSupply = initialSupplyPerAddress * totalInitialAddresses;
99        _owner = msg.sender;
100 
101     }
102 
103     function currentBlock() constant returns (uint256 blockNumber)
104     {
105         return block.number;
106     }
107 
108     function blockDiff() constant returns (uint256 blockNumber)
109     {
110         return block.number - initialBlockCount;
111     }
112 
113     function assignInitialAddresses(address[] _address) isOwner public returns (bool success)
114     {
115         if (block.number <= 7000000)
116         {
117           for (uint i = 0; i < _address.length; i++)
118           {
119             balanceOf[_address[i]] = initialSupplyPerAddress;
120             initialAddress[_address[i]] = true;
121           }
122 
123           return true;
124         }
125         return false;
126     }
127 
128     function assignBountyAddresses(address[] _address) isOwner public returns (bool success)
129     {
130       startBounty = 2500000000;
131 
132         if (block.number <= 7000000)
133         {
134           for (uint i = 0; i < _address.length; i++)
135           {
136             balanceOf[_address[i]] = startBounty;
137             initialAddress[_address[i]] = true;
138           }
139 
140           return true;
141         }
142         return false;
143     }
144 
145     function completeBountyAddresses(address[] _address) isOwner public returns (bool success)
146     {
147       finishBounty = 7500000000;
148 
149         if (block.number <= 7000000)
150         {
151           for (uint i = 0; i < _address.length; i++)
152           {
153             balanceOf[_address[i]] = balanceOf[_address[i]] + finishBounty;
154             initialAddress[_address[i]] = true;
155           }
156 
157           return true;
158         }
159         return false;
160     }
161 
162     function balanceOf(address _address) constant returns (uint256 Balance)
163     {
164         if ((initialAddress[_address])) {
165             minedBlocks = block.number - initialBlockCount;
166 
167             if (minedBlocks >= 105120000) return balanceOf[_address]; //app. 2058
168 
169             availableAmount = rewardPerBlockPerAddress * minedBlocks;
170             availableBalance = balanceOf[_address] + availableAmount;
171 
172             return availableBalance;
173         }
174         else
175             return balanceOf[_address];
176     }
177 
178     function name() constant returns (string _name)
179     {
180         name = "iGniter";
181         return name;
182     }
183 
184     function symbol() constant returns (bytes32 _symbol)
185     {
186         symbol = "INR";
187         return symbol;
188     }
189 
190     function decimals() constant returns (uint8 _decimals)
191     {
192         decimals = 6;
193         return decimals;
194     }
195 
196     function totalSupply() constant returns (uint256 totalSupply)
197     {
198         minedBlocks = block.number - initialBlockCount;
199         availableAmount = rewardPerBlockPerAddress * minedBlocks;
200         iGniting = availableAmount * totalInitialAddresses;
201         return iGniting + initialSupply - burnt;
202     }
203 
204     function minedTotalSupply() constant returns (uint256 minedBlocks)
205     {
206         minedBlocks = block.number - initialBlockCount;
207         availableAmount = rewardPerBlockPerAddress * minedBlocks;
208         return availableAmount * totalInitialAddresses;
209     }
210 
211     function initialiGnSupply() constant returns (uint256 maxSupply)
212     {
213         return initialSupplyPerAddress * totalInitialAddresses;
214     }
215 
216     //burn tokens
217     function burn(uint256 _value) public returns(bool success) {
218 
219         //get sum
220         minedBlocks = block.number - initialBlockCount;
221         availableAmount = rewardPerBlockPerAddress * minedBlocks;
222         iGniting = availableAmount * totalInitialAddresses;
223         _totalSupply = iGniting + initialSupply;
224 
225         //burn time
226         require(balanceOf[msg.sender] >= _value);
227         balanceOf[msg.sender] -= _value;
228         burnt += _value;
229         Burn(msg.sender, _value);
230         return true;
231     }
232 
233     function transfer(address _to, uint _value) public returns (bool) {
234         if (_value > 0 && _value <= balanceOf[msg.sender] && !isContract(_to)) {
235             balanceOf[msg.sender] -= _value;
236             balanceOf[_to] += _value;
237             Transfer(msg.sender, _to, _value);
238             return true;
239         }
240         return false;
241     }
242 
243     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
244         if (_value > 0 && _value <= balanceOf[msg.sender] && isContract(_to)) {
245             balanceOf[msg.sender] -= _value;
246             balanceOf[_to] += _value;
247             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
248                 _contract.tokenFallback(msg.sender, _value, _data);
249             Transfer(msg.sender, _to, _value, _data);
250             return true;
251         }
252         return false;
253     }
254 
255     function isContract(address _addr) returns (bool) {
256         uint codeSize;
257         assembly {
258             codeSize := extcodesize(_addr)
259         }
260         return codeSize > 0;
261     }
262 
263     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
264         if (_allowances[_from][msg.sender] > 0 && _value > 0 && _allowances[_from][msg.sender] >= _value &&
265             balanceOf[_from] >= _value) {
266             balanceOf[_from] -= _value;
267             balanceOf[_to] += _value;
268             _allowances[_from][msg.sender] -= _value;
269             Transfer(_from, _to, _value);
270             return true;
271         }
272         return false;
273     }
274 
275     function approve(address _spender, uint _value) public returns (bool) {
276         _allowances[msg.sender][_spender] = _value;
277         Approval(msg.sender, _spender, _value);
278         return true;
279     }
280 
281     function allowance(address _owner, address _spender) public constant returns (uint) {
282         return _allowances[_owner][_spender];
283     }
284 
285     function PaymentStatusBlockNum(address _address) constant returns (uint256 bn) {
286 
287       return ignPayments[_address].unlockedBlockNumber;
288     }
289 
290     function PaymentStatusTimeStamp(address _address) constant returns (uint256 ut) {
291 
292       return ignPayments[_address].unlockedTime;
293     }
294 
295     function updateCost(uint256 _currCost) isOwner public returns (uint256 currCost) {
296 
297       currentCost = _currCost;
298 
299       return currentCost;
300     }
301 
302     function servicePayment(uint _value) public returns (bool, uint256, uint256) {
303 
304       require(_value >= currentCost);
305       require(balanceOf[msg.sender] >= currentCost);
306 
307       //either option available
308       ignPayments[msg.sender].unlockedTime = block.timestamp;
309       ignPayments[msg.sender].unlockedBlockNumber = block.number;
310 
311       inrSessions++;
312 
313       //burn
314       balanceOf[msg.sender] -= _value;
315       burnt += _value;
316       Burn(msg.sender, _value);
317 
318       return (true, ignPayments[msg.sender].unlockedTime, ignPayments[msg.sender].unlockedBlockNumber);
319     }
320 }