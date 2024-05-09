1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
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
15         return a / b;
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
30 // Actually, it is not a RingList anymore. It's a Random Access List
31 // however, needed cyclic list functionality could modeled on top of Random Access List
32 // Recommended name - AddressSet
33 library AddressSet {
34 
35     // Name is kept for drop-in replacement reasons. Recommended name `Instance`
36     struct Instance {
37         address[] list;
38         mapping(address => uint256) idx; // actually stores indexes incremented by 1
39     }
40 
41     // _direction parameter is kept for drop-in replacement consistency; consider remove the parameter
42     // Gas efficient version of push
43     function push(Instance storage self, address addr) internal returns (bool) {
44         if (self.idx[addr] != 0) return false;
45         self.idx[addr] = self.list.push(addr);
46         return true;
47     }
48 
49     // Now in O(1)
50     function sizeOf(Instance storage self) internal view returns (uint256) {
51         return self.list.length;
52     }
53 
54     // Gets i-th address in O(1) time (RANDOM ACCESS!!!)
55     function getAddress(Instance storage self, uint256 index) internal view returns (address) {
56         return (index < self.list.length) ? self.list[index] : address(0);
57     }
58 
59     // Gas efficient version of remove
60     function remove(Instance storage self, address addr) internal returns (bool) {
61         if (self.idx[addr] == 0) return false;
62         uint256 idx = self.idx[addr];
63         delete self.idx[addr];
64         if (self.list.length == idx) {
65             self.list.length--;
66         } else {
67             address last = self.list[self.list.length-1];
68             self.list.length--;
69             self.list[idx-1] = last;
70             self.idx[last] = idx;
71         }
72         return true;
73     }
74 }
75 
76 contract ERC20 {
77     function totalSupply() external view returns (uint256 _totalSupply);
78     function balanceOf(address _owner) external view returns (uint256 balance);
79     function transfer(address _to, uint256 _value) external returns (bool success);
80     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
81     function approve(address _spender, uint256 _value) external returns (bool success);
82     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 }
86 
87 contract UHCToken is ERC20 {
88     using SafeMath for uint256;
89     using AddressSet for AddressSet.Instance;
90 
91     address public owner;
92     address public subowner;
93 
94     bool    public              contractEnable = true;
95 
96     string  public              name = "UFOHotelCoin";
97     string  public              symbol = "UHC";
98     uint8   public              decimals = 4;
99     uint256 private             summarySupply;
100     bool    public              isTransferFee;
101     uint8   public              transferFeePercent = 3;
102     uint8   public              refererFeePercent = 1;
103 
104     struct account{
105         uint256 balance;
106         uint8 group;
107         uint8 status;
108         address referer;
109         bool isBlocked;
110         bool withoutTransferFee;
111     }
112 
113     mapping(address => account)                      private   accounts;
114     mapping(address => mapping (address => uint256)) private   allowed;
115     mapping(bytes => address)                        private   promos;
116 
117     AddressSet.Instance                             private   holders;
118 
119     struct groupPolicy {
120         uint8 _default;
121         uint8 _backend;
122         uint8 _admin;
123         uint8 _owner;
124     }
125 
126     groupPolicy public groupPolicyInstance = groupPolicy(0, 3, 4, 9);
127 
128     event EvGroupChanged(address indexed _address, uint8 _oldgroup, uint8 _newgroup);
129     event EvMigration(address indexed _address, uint256 _balance, uint256 _secret);
130     event EvUpdateStatus(address indexed _address, uint8 _oldstatus, uint8 _newstatus);
131     event EvSetReferer(address indexed _referal, address _referer);
132 
133     constructor (string _name, string _symbol, uint8 _decimals,uint256 _summarySupply, uint8 _transferFeePercent, uint8 _refererFeePercent) public {
134         require(_refererFeePercent < _transferFeePercent);
135         owner = msg.sender;
136 
137         accounts[owner] = account(_summarySupply, groupPolicyInstance._owner, 4, address(0), false, false);
138 
139         holders.push(msg.sender);
140         name = _name;
141         symbol = _symbol;
142         decimals = _decimals;
143         summarySupply = _summarySupply;
144         transferFeePercent = _transferFeePercent;
145         refererFeePercent = _refererFeePercent;
146         emit Transfer(address(0), msg.sender, _summarySupply);
147     }
148 
149     modifier minGroup(int _require) {
150         require(accounts[msg.sender].group >= _require);
151         _;
152     }
153 
154     modifier onlySubowner() {
155         require(msg.sender == subowner);
156         _;
157     }
158 
159     modifier whenNotMigrating {
160         require(contractEnable);
161         _;
162     }
163 
164     modifier whenMigrating {
165         require(!contractEnable);
166         _;
167     }
168 
169     function serviceGroupChange(address _address, uint8 _group) minGroup(groupPolicyInstance._admin) external returns(uint8) {
170         require(_address != address(0));
171         require(_group <= groupPolicyInstance._admin);
172 
173         uint8 old = accounts[_address].group;
174         require(old < accounts[msg.sender].group);
175 
176         accounts[_address].group = _group;
177         emit EvGroupChanged(_address, old, _group);
178 
179         return accounts[_address].group;
180     }
181 
182     function serviceTransferOwnership(address newOwner) minGroup(groupPolicyInstance._owner) external {
183         require(newOwner != address(0));
184 
185         subowner = newOwner;
186     }
187 
188     function serviceClaimOwnership() onlySubowner() external {
189         address temp = owner;
190         uint256 value = accounts[owner].balance;
191 
192         accounts[owner].balance = accounts[owner].balance.sub(value);
193         holders.remove(owner);
194         accounts[msg.sender].balance = accounts[msg.sender].balance.add(value);
195         holders.push(msg.sender);
196 
197         owner = msg.sender;
198         subowner = address(0);
199 
200         delete accounts[temp].group;
201         uint8 oldGroup = accounts[msg.sender].group;
202         accounts[msg.sender].group = groupPolicyInstance._owner;
203 
204         emit EvGroupChanged(msg.sender, oldGroup, groupPolicyInstance._owner);
205         emit Transfer(temp, owner, value);
206     }
207 
208     function serviceSwitchTransferAbility(address _address) external minGroup(groupPolicyInstance._admin) returns(bool) {
209         require(accounts[_address].group < accounts[msg.sender].group);
210 
211         accounts[_address].isBlocked = !accounts[_address].isBlocked;
212 
213         return true;
214     }
215 
216     function serviceUpdateTransferFeePercent(uint8 newFee) external minGroup(groupPolicyInstance._admin) {
217         require(newFee < 100);
218         require(newFee > refererFeePercent);
219         transferFeePercent = newFee;
220     }
221 
222     function serviceUpdateRefererFeePercent(uint8 newFee) external minGroup(groupPolicyInstance._admin) {
223         require(newFee < 100);
224         require(transferFeePercent > newFee);
225         refererFeePercent = newFee;
226     }
227 
228     function serviceSetPromo(bytes num, address _address) external minGroup(groupPolicyInstance._admin) {
229         require(promos[num] == address(0), "Address already set for this promo");
230         promos[num] = _address;
231     }
232 
233     function serviceOnTransferFee() external minGroup(groupPolicyInstance._admin) {
234         require(!isTransferFee);
235         isTransferFee = true;
236     }
237 
238     function serviceOffTransferFee() external minGroup(groupPolicyInstance._admin) {
239         require(isTransferFee);
240         isTransferFee = false;
241     }
242     
243     function serviceAccountTransferFee(address _address, bool _withoutTransferFee) external minGroup(groupPolicyInstance._admin) {
244         require(_address != address(0));
245         require(accounts[_address].withoutTransferFee != _withoutTransferFee);
246         accounts[_address].withoutTransferFee = _withoutTransferFee;
247     }
248 
249     function backendSetStatus(address _address, uint8 status) external minGroup(groupPolicyInstance._backend) returns(bool){
250         require(_address != address(0));
251         require(status >= 0 && status <= 4);
252         uint8 oldStatus = accounts[_address].status;
253         accounts[_address].status = status;
254 
255         emit EvUpdateStatus(_address, oldStatus, status);
256 
257         return true;
258     }
259 
260     function backendSetReferer(address _referal, address _referer) external minGroup(groupPolicyInstance._backend) returns(bool) {
261         require(accounts[_referal].referer == address(0));
262         require(_referal != address(0));
263         require(_referal != _referer);
264         require(accounts[_referal].referer != _referer);
265 
266         accounts[_referal].referer = _referer;
267 
268         emit EvSetReferer(_referal, _referer);
269 
270         return true;
271     }
272 
273     function backendSendBonus(address _to, uint256 _value) external minGroup(groupPolicyInstance._backend) returns(bool) {
274         require(_to != address(0));
275         require(_value > 0);
276         require(accounts[owner].balance >= _value);
277 
278         accounts[owner].balance = accounts[owner].balance.sub(_value);
279         accounts[_to].balance = accounts[_to].balance.add(_value);
280 
281         emit Transfer(owner, _to, _value);
282 
283         return true;
284     }
285 
286     function backendRefund(address _from, uint256 _value) external minGroup(groupPolicyInstance._backend) returns(uint256 balance) {
287         require(_from != address(0));
288         require(_value > 0);
289         require(accounts[_from].balance >= _value);
290  
291         accounts[_from].balance = accounts[_from].balance.sub(_value);
292         accounts[owner].balance = accounts[owner].balance.add(_value);
293         if(accounts[_from].balance == 0){
294             holders.remove(_from);
295         }
296         emit Transfer(_from, owner, _value);
297         return accounts[_from].balance;
298     }
299 
300     function getGroup(address _check) external view returns(uint8 _group) {
301         return accounts[_check].group;
302     }
303 
304     function getHoldersLength() external view returns(uint256){
305         return holders.sizeOf();
306     }
307 
308     function getHolderByIndex(uint256 _index) external view returns(address){
309         return holders.getAddress(_index);
310     }
311 
312     function getPromoAddress(bytes _promo) external view returns(address) {
313         return promos[_promo];
314     }
315 
316     function getAddressTransferAbility(address _check) external view returns(bool) {
317         return !accounts[_check].isBlocked;
318     }
319 
320     function transfer(address _to, uint256 _value) external returns (bool success) {
321         return _transfer(msg.sender, _to, address(0), _value);
322     }
323 
324     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
325         return _transfer(_from, _to, msg.sender, _value);
326     }
327 
328     function _transfer(address _from, address _to, address _allow, uint256 _value) minGroup(groupPolicyInstance._default) whenNotMigrating internal returns(bool) {
329         require(!accounts[_from].isBlocked);
330         require(_from != address(0));
331         require(_to != address(0));
332         uint256 transferFee = accounts[_from].group == 0 && isTransferFee && !accounts[_from].withoutTransferFee ? _value.mul(accounts[_from].referer == address(0) ? transferFeePercent : transferFeePercent - refererFeePercent).div(100) : 0;
333         uint256 transferRefererFee = accounts[_from].referer == address(0) || accounts[_from].group != 0 ? 0 : _value.mul(refererFeePercent).div(100);
334         uint256 summaryValue = _value.add(transferFee).add(transferRefererFee);
335         require(accounts[_from].balance >= summaryValue);
336         require(_allow == address(0) || allowed[_from][_allow] >= summaryValue);
337 
338         accounts[_from].balance = accounts[_from].balance.sub(summaryValue);
339         if(_allow != address(0)) {
340             allowed[_from][_allow] = allowed[_from][_allow].sub(summaryValue);
341         }
342 
343         if(accounts[_from].balance == 0){
344             holders.remove(_from);
345         }
346         accounts[_to].balance = accounts[_to].balance.add(_value);
347         holders.push(_to);
348         emit Transfer(_from, _to, _value);
349 
350         if(transferFee > 0) {
351             accounts[owner].balance = accounts[owner].balance.add(transferFee);
352             emit Transfer(_from, owner, transferFee);
353         }
354 
355         if(transferRefererFee > 0) {
356             accounts[accounts[_from].referer].balance = accounts[accounts[_from].referer].balance.add(transferRefererFee);
357             holders.push(accounts[_from].referer);
358             emit Transfer(_from, accounts[_from].referer, transferRefererFee);
359         }
360         return true;
361     }
362 
363     function approve(address _spender, uint256 _value) minGroup(groupPolicyInstance._default) external returns (bool success) {
364         require (_value == 0 || allowed[msg.sender][_spender] == 0);
365         require(_spender != address(0));
366 
367         allowed[msg.sender][_spender] = _value;
368         emit Approval(msg.sender, _spender, _value);
369         return true;
370     }
371 
372     function increaseApproval(address _spender, uint256 _addedValue) minGroup(groupPolicyInstance._default) external returns (bool)
373     {
374         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
375         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376         return true;
377     }
378 
379     function decreaseApproval(address _spender, uint256 _subtractedValue) minGroup(groupPolicyInstance._default) external returns (bool)
380     {
381         uint256 oldValue = allowed[msg.sender][_spender];
382         if (_subtractedValue > oldValue) {
383             allowed[msg.sender][_spender] = 0;
384         } else {
385             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
386         }
387         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
388         return true;
389     }
390 
391     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
392         return allowed[_owner][_spender];
393     }
394 
395     function balanceOf(address _owner) external view returns (uint256 balance) {
396         return accounts[_owner].balance;
397     }
398 
399     function statusOf(address _owner) external view returns (uint8) {
400         return accounts[_owner].status;
401     }
402 
403     function refererOf(address _owner) external constant returns (address) {
404         return accounts[_owner].referer;
405     }
406 
407     function totalSupply() external constant returns (uint256 _totalSupply) {
408         _totalSupply = summarySupply;
409     }
410 
411     function settingsSwitchState() external minGroup(groupPolicyInstance._owner) returns (bool state) {
412 
413         contractEnable = !contractEnable;
414 
415         return contractEnable;
416     }
417 
418     function userMigration(uint256 _secret) external whenMigrating returns (bool successful) {
419         uint256 balance = accounts[msg.sender].balance;
420 
421         require (balance > 0);
422 
423         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(balance);
424         holders.remove(msg.sender);
425         accounts[owner].balance = accounts[owner].balance.add(balance);
426         holders.push(owner);
427         emit EvMigration(msg.sender, balance, _secret);
428         emit Transfer(msg.sender, owner, balance);
429         return true;
430     }
431 }