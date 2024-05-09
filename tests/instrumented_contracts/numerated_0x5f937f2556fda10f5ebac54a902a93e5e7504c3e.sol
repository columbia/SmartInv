1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract ERC20 {
35 
36     function name() public view returns (string);
37     function symbol() public view returns (string);
38     function decimals() public view returns (uint8);
39 
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 
50 }
51 
52 contract ERC223 {
53     function transferdata(address to, uint value, bytes data) payable public;
54     event Transferdata(address indexed from, address indexed to, uint value, bytes indexed data);
55 }
56 
57 
58 contract ERC223ReceivingContract {
59     function tokenFallback(address _from, uint _value, bytes _data) public;
60 }
61 
62 
63 contract ERCAddressFrozenFund is ERC20{
64 
65     using SafeMath for uint;
66 
67     struct LockedWallet {
68         address owner; // the owner of the locked wallet, he/she must secure the private key
69         uint256 amount; //
70         uint256 start; // timestamp when "lock" function is executed
71         uint256 duration; // duration period in seconds. if we want to lock an amount for
72         uint256 release;  // release = start+duration
73         // "start" and "duration" is for bookkeeping purpose only. Only "release" will be actually checked once unlock function is called
74     }
75 
76 
77     address public owner;
78 
79     uint256 _lockedSupply;
80 
81     mapping (address => LockedWallet) addressFrozenFund; //address -> (deadline, amount),freeze fund of an address its so that no token can be transferred out until deadline
82 
83     function mintToken(address _owner, uint256 amount) internal;
84     function burnToken(address _owner, uint256 amount) internal;
85 
86     event LockBalance(address indexed addressOwner, uint256 releasetime, uint256 amount);
87     event LockSubBalance(address indexed addressOwner, uint256 index, uint256 releasetime, uint256 amount);
88     event UnlockBalance(address indexed addressOwner, uint256 releasetime, uint256 amount);
89     event UnlockSubBalance(address indexed addressOwner, uint256 index, uint256 releasetime, uint256 amount);
90 
91     function lockedSupply() public view returns (uint256) {
92         return _lockedSupply;
93     }
94 
95     function releaseTimeOf(address _owner) public view returns (uint256 releaseTime) {
96         return addressFrozenFund[_owner].release;
97     }
98 
99     function lockedBalanceOf(address _owner) public view returns (uint256 lockedBalance) {
100         return addressFrozenFund[_owner].amount;
101     }
102 
103     function lockBalance(uint256 duration, uint256 amount) public{
104 
105         address _owner = msg.sender;
106 
107         require(address(0) != _owner && amount > 0 && duration > 0 && balanceOf(_owner) >= amount);
108         require(addressFrozenFund[_owner].release <= now && addressFrozenFund[_owner].amount == 0);
109 
110         addressFrozenFund[_owner].start = now;
111         addressFrozenFund[_owner].duration = duration;
112         addressFrozenFund[_owner].release = SafeMath.add(addressFrozenFund[_owner].start, duration);
113         addressFrozenFund[_owner].amount = amount;
114         burnToken(_owner, amount);
115         _lockedSupply = SafeMath.add(_lockedSupply, lockedBalanceOf(_owner));
116 
117         emit LockBalance(_owner, addressFrozenFund[_owner].release, amount);
118     }
119 
120     //_owner must call this function explicitly to release locked balance in a locked wallet
121     function releaseLockedBalance() public {
122 
123         address _owner = msg.sender;
124 
125         require(address(0) != _owner && lockedBalanceOf(_owner) > 0 && releaseTimeOf(_owner) <= now);
126         mintToken(_owner, lockedBalanceOf(_owner));
127         _lockedSupply = SafeMath.sub(_lockedSupply, lockedBalanceOf(_owner));
128 
129         emit UnlockBalance(_owner, addressFrozenFund[_owner].release, lockedBalanceOf(_owner));
130 
131         delete addressFrozenFund[_owner];
132     }
133 
134 }
135 
136 contract INTToken is ERC223, ERCAddressFrozenFund {
137 
138     using SafeMath for uint;
139 
140     string internal _name;
141     string internal _symbol;
142     uint8 internal _decimals;
143     uint256 internal _totalSupply;
144     address public fundsWallet;
145     uint256 internal fundsWalletChanged;
146 
147     mapping (address => uint256) internal balances;
148     mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151     constructor() public {
152         _symbol = 'INT';
153         _name = 'inChat Token';
154         _decimals = 8;
155         _totalSupply = 10000000000000000;
156         balances[msg.sender] = _totalSupply;
157         fundsWallet = msg.sender;
158 
159         owner = msg.sender;
160 
161         fundsWalletChanged = 0;
162     }
163 
164     function changeFundsWallet(address newOwner) public{
165         require(msg.sender == fundsWallet && fundsWalletChanged == 0);
166 
167         balances[newOwner] = balances[fundsWallet];
168         balances[fundsWallet] = 0;
169         fundsWallet = newOwner;
170         fundsWalletChanged = 1;
171     }
172 
173     function name() public view returns (string) {
174         return _name;
175     }
176 
177     function symbol() public view returns (string) {
178         return _symbol;
179     }
180 
181     function decimals() public view returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public view returns (uint256) {
186         return _totalSupply;
187     }
188 
189     function mintToken(address _owner, uint256 amount) internal {
190         balances[_owner] = SafeMath.add(balances[_owner], amount);
191     }
192 
193     function burnToken(address _owner, uint256 amount) internal {
194         balances[_owner] = SafeMath.sub(balances[_owner], amount);
195     }
196 
197     function() payable public {
198 
199         require(msg.sender == address(0));//disable ICO crowd sale 禁止ICO资金募集，因为本合约已经过了募集阶段
200     }
201 
202     function transfer(address _to, uint256 _value) public returns (bool) {
203         require(_to != address(0));
204         require(_value <= balances[msg.sender]);
205 
206         if(isContract(_to)) {
207             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
208             bytes memory _data = new bytes(1);
209             receiver.tokenFallback(msg.sender, _value, _data);
210         }
211 
212         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
213         balances[_to] = SafeMath.add(balances[_to], _value);
214         emit Transfer(msg.sender, _to, _value);
215 
216         return true;
217     }
218 
219     function balanceOf(address _owner) public view returns (uint256 balance) {
220         return balances[_owner];
221     }
222 
223     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224         require(_to != address(0));
225         require(_value <= balances[_from]);
226         require(_value <= allowed[_from][msg.sender]);
227 
228         if(_from == fundsWallet){
229             require(_value <= balances[_from]);
230         }
231 
232         if(isContract(_to)) {
233             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
234             bytes memory _data = new bytes(1);
235             receiver.tokenFallback(msg.sender, _value, _data);
236         }
237 
238         balances[_from] = SafeMath.sub(balances[_from], _value);
239         balances[_to] = SafeMath.add(balances[_to], _value);
240         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
241 
242         emit Transfer(_from, _to, _value);
243         return true;
244     }
245 
246     function approve(address _spender, uint256 _value) public returns (bool) {
247         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); 
248         allowed[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252 
253     function allowance(address _owner, address _spender) public view returns (uint256) {
254         return allowed[_owner][_spender];
255     }
256 
257     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
259         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260         return true;
261     }
262 
263     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264         uint oldValue = allowed[msg.sender][_spender];
265         if (_subtractedValue > oldValue) {
266             allowed[msg.sender][_spender] = 0;
267         } else {
268             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
269         }
270         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273 
274     function transferdata(address _to, uint _value, bytes _data) public payable {
275         require(_value > 0 );
276         if(isContract(_to)) {
277             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
278             receiver.tokenFallback(msg.sender, _value, _data);
279         }
280 
281         balances[msg.sender] = balances[msg.sender].sub(_value);
282         balances[_to] = balances[_to].add(_value);
283 
284         emit Transferdata(msg.sender, _to, _value, _data);
285     }
286 
287     function isContract(address _addr) private view returns (bool is_contract) {
288         uint length;
289         assembly {
290         //retrieve the size of the code on target address, this needs assembly
291             length := extcodesize(_addr)
292         }
293         return (length>0);
294     }
295 
296     function transferMultiple(address[] _tos, uint256[] _values, uint count)  payable public returns (bool) {
297         uint256 total = 0;
298         uint256 total_prev = 0;
299         uint i = 0;
300 
301         for(i=0;i<count;i++){
302             require(_tos[i] != address(0) && !isContract(_tos[i]));//_tos must no contain any contract address
303 
304             if(isContract(_tos[i])) {
305                 ERC223ReceivingContract receiver = ERC223ReceivingContract(_tos[i]);
306                 bytes memory _data = new bytes(1);
307                 receiver.tokenFallback(msg.sender, _values[i], _data);
308             }
309 
310             total_prev = total;
311             total = SafeMath.add(total, _values[i]);
312             require(total >= total_prev);
313         }
314 
315         require(total <= balances[msg.sender]);
316 
317         for(i=0;i<count;i++){
318             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _values[i]);
319             balances[_tos[i]] = SafeMath.add(balances[_tos[i]], _values[i]);
320             emit Transfer(msg.sender, _tos[i], _values[i]);
321         }
322 
323         return true;
324     }
325 }