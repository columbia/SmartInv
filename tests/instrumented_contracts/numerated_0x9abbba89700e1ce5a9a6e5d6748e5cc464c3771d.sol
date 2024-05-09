1 pragma solidity ^0.5.0;
2 
3 
4 contract SafeMath {
5 
6     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
13         assert(b > 0);
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(a >= b);
20         return a - b;
21     }
22 
23     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract MakePayable {
31     function makePayable(address x) internal pure returns (address payable) {
32         return address(uint160(x));
33     }
34 }
35 
36 contract IERC20Token {
37     string public name;
38     string public symbol;
39     uint8 public decimals;
40     uint256 public totalSupply;
41 
42     function balanceOf(address _owner) public view returns (uint256 balance);
43     function transfer(address _to, uint256 _value)  public returns (bool success);
44     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
45     function approve(address _spender, uint256 _value)  public returns (bool success);
46     function allowance(address _owner, address _spender)  public view returns (uint256 remaining);
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 contract ERC20Token is IERC20Token, SafeMath {
53     mapping (address => uint256) public balances;
54     mapping (address => mapping (address => uint256)) public allowed;
55 
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         require(_to != address(0));
58         require(balances[msg.sender] >= _value);
59 
60         balances[msg.sender] = safeSub(balances[msg.sender], _value);
61         balances[_to] = safeAdd(balances[_to], _value);
62         emit Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
69 
70         balances[_to] = safeAdd(balances[_to], _value);
71         balances[_from] = safeSub(balances[_from], _value);
72         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
73         emit Transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function balanceOf(address _owner) public view returns (uint256) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool) {
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) public view returns (uint256) {
88         return allowed[_owner][_spender];
89     }
90 }
91 
92 contract IOwnable {
93 
94     address public owner;
95     address public newOwner;
96 
97     event OwnerChanged(address _oldOwner, address _newOwner);
98 
99     function changeOwner(address _newOwner) public;
100     function acceptOwnership() public;
101 }
102 
103 contract Ownable is IOwnable {
104 
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     constructor() public {
111         owner = msg.sender;
112         emit OwnerChanged(address(0), owner);
113     }
114 
115     function changeOwner(address _newOwner) public onlyOwner {
116         newOwner = _newOwner;
117     }
118 
119     function acceptOwnership() public {
120         require(msg.sender == newOwner);
121         emit OwnerChanged(owner, newOwner);
122         owner = newOwner;
123         newOwner = address(0);
124     }
125 }
126 
127 contract IWinbixToken is IERC20Token {
128 
129     uint256 public votableTotal;
130     uint256 public accruableTotal;
131     address public issuer;
132     bool public transferAllowed;
133 
134     mapping (address => bool) public isPayable;
135 
136     event SetIssuer(address _address);
137     event TransferAllowed(bool _newState);
138     event FreezeWallet(address _address);
139     event UnfreezeWallet(address _address);
140     event IssueTokens(address indexed _to, uint256 _value);
141     event IssueVotable(address indexed _to, uint256 _value);
142     event IssueAccruable(address indexed _to, uint256 _value);
143     event BurnTokens(address indexed _from, uint256 _value);
144     event BurnVotable(address indexed _from, uint256 _value);
145     event BurnAccruable(address indexed _from, uint256 _value);
146     event SetPayable(address _address, bool _state);
147 
148     function setIssuer(address _address) public;
149     function allowTransfer(bool _allowTransfer) public;
150     function freeze(address _address) public;
151     function unfreeze(address _address) public;
152     function isFrozen(address _address) public returns (bool);
153     function issue(address _to, uint256 _value) public;
154     function issueVotable(address _to, uint256 _value) public;
155     function issueAccruable(address _to, uint256 _value) public;
156     function votableBalanceOf(address _address) public view returns (uint256);
157     function accruableBalanceOf(address _address) public view returns (uint256);
158     function burn(uint256 _value) public;
159     function burnAll() public;
160     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool);
161     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool);
162     function setMePayable(bool _state) public;
163 }
164 
165 contract IWinbixPayable {
166 
167     function catchWinbix(address payable _from, uint256 _value) external;
168 
169 }
170 
171 contract WinbixToken is IWinbixToken, ERC20Token, Ownable, MakePayable {
172 
173     mapping (address => bool) private frozen;
174     mapping (address => uint256) private votableBalances;
175     mapping (address => uint256) private accruableBalances;
176 
177 
178     modifier onlyIssuer() {
179         require(msg.sender == issuer);
180         _;
181     }
182 
183     modifier canTransfer(address _from, address _to) {
184         require((transferAllowed && !frozen[_from] && !frozen[_to]) || _from == issuer || isPayable[_to]);
185         _;
186     }
187 
188 
189     constructor() public {
190         name = "Winbix Token";
191         symbol = "WBX";
192         decimals = 18;
193         totalSupply = 0;
194     }
195 
196     function setIssuer(address _address) public onlyOwner {
197         issuer = _address;
198         emit SetIssuer(_address);
199     }
200 
201     function freeze(address _address) public onlyIssuer {
202         if (frozen[_address]) return;
203         frozen[_address] = true;
204         emit FreezeWallet(_address);
205     }
206 
207     function unfreeze(address _address) public onlyIssuer {
208         if (!frozen[_address]) return;
209         frozen[_address] = false;
210         emit UnfreezeWallet(_address);
211     }
212 
213     function isFrozen(address _address) public returns (bool) {
214         return frozen[_address];
215     }
216 
217     function issue(address _to, uint256 _value) public onlyIssuer {
218         totalSupply = safeAdd(totalSupply, _value);
219         balances[_to] += _value;
220         emit IssueTokens(_to, _value);
221     }
222 
223     function issueVotable(address _to, uint256 _value) public onlyIssuer {
224         votableTotal = safeAdd(votableTotal, _value);
225         votableBalances[_to] += _value;
226         require(votableBalances[_to] <= balances[_to]);
227         emit IssueVotable(_to, _value);
228     }
229 
230     function issueAccruable(address _to, uint256 _value) public onlyIssuer {
231         accruableTotal = safeAdd(accruableTotal, _value);
232         accruableBalances[_to] += _value;
233         require(accruableBalances[_to] <= balances[_to]);
234         emit IssueAccruable(_to, _value);
235     }
236 
237     function votableBalanceOf(address _address) public view returns (uint256) {
238         return votableBalances[_address];
239     }
240 
241     function accruableBalanceOf(address _address) public view returns (uint256) {
242         return accruableBalances[_address];
243     }
244 
245     function burn(uint256 _value) public {
246         if (_value == 0) return;
247         burnTokens(msg.sender, _value);
248         minimizeSpecialBalances(msg.sender);
249     }
250 
251     function burnAll() public {
252         burn(balances[msg.sender]);
253     }
254 
255     function burnTokens(address _from, uint256 _value) private {
256         require(balances[_from] >= _value);
257         totalSupply -= _value;
258         balances[_from] -= _value;
259         emit BurnTokens(_from, _value);
260     }
261 
262     function allowTransfer(bool _allowTransfer) public onlyIssuer {
263         if (_allowTransfer == transferAllowed) {
264             return;
265         }
266         transferAllowed = _allowTransfer;
267         emit TransferAllowed(_allowTransfer);
268     }
269 
270     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
271         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
272         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273         return true;
274     }
275 
276     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
277         uint256 oldValue = allowed[msg.sender][_spender];
278         if (_subtractedValue >= oldValue) {
279             allowed[msg.sender][_spender] = 0;
280         } else {
281             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
282         }
283         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284         return true;
285     }
286 
287     function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {
288         bool res = super.transfer(_to, _value);
289         if (isPayable[_to]) IWinbixPayable(_to).catchWinbix(msg.sender, _value);
290         processSpecialBalances(msg.sender, _to, _value);
291         return res;
292     }
293 
294     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
295         bool res = super.transferFrom(_from, _to, _value);
296         if (isPayable[_to]) IWinbixPayable(_to).catchWinbix(makePayable(_from), _value);
297         processSpecialBalances(_from, _to, _value);
298         return res;
299     }
300 
301     function processSpecialBalances(address _from, address _to, uint256 _value) private {
302         if (_value == 0) return;
303         if (balances[_to] == 0) {
304             reduceSpecialBalances(_from, _value);
305         } else {
306             minimizeSpecialBalances(_from);
307         }
308     }
309 
310     function reduceSpecialBalances(address _address, uint256 _value) private {
311         uint256 value = _value;
312         if (value > votableBalances[_address]) {
313             value = votableBalances[_address];
314         }
315         if (value > 0) {
316             votableBalances[_address] -= value;
317             votableTotal -= value;
318             emit BurnVotable(_address, value);
319         }
320         value = _value;
321         if (value > accruableBalances[_address]) {
322             value = accruableBalances[_address];
323         }
324         if (value > 0) {
325             accruableBalances[_address] -= value;
326             accruableTotal -= value;
327             emit BurnAccruable(_address, value);
328         }
329     }
330 
331     function minimizeSpecialBalances(address _address) private {
332         uint256 delta;
333         uint256 tokenBalance = balanceOf(_address);
334         if (tokenBalance < votableBalances[_address]) {
335             delta = votableBalances[_address] - tokenBalance;
336             votableBalances[_address] = tokenBalance;
337             votableTotal -= delta;
338             emit BurnVotable(_address, delta);
339         }
340         if (tokenBalance < accruableBalances[_address]) {
341             delta = accruableBalances[_address] - tokenBalance;
342             accruableBalances[_address] = tokenBalance;
343             accruableTotal -= delta;
344             emit BurnAccruable(_address, delta);
345         }
346     }
347 
348     function setMePayable(bool _state) public onlyIssuer {
349         if (isPayable[msg.sender] == _state) return;
350         isPayable[msg.sender] = _state;
351         emit SetPayable(msg.sender, _state);
352     }
353 }