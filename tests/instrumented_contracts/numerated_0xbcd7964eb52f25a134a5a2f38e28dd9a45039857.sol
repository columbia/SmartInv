1 pragma solidity ^0.4.25;
2 
3 // Project: token ALE, http://alehub.io
4 // v1, 2018-12-13
5 // Full compatibility with ERC20.
6 // Token with special add. properties: division into privileged (default, for all) and usual tokens (for team).
7 
8 // Authors: Ivan Fedorov and Dmitry Borodin (CryptoB2B)
9 // Copying in whole or in part is prohibited.
10 // This code is the property of CryptoB2B.io
11 
12 contract IRightAndRoles {
13     address[][] public wallets;
14     mapping(address => uint16) public roles;
15 
16     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
17     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
18 
19     function changeWallet(address _wallet, uint8 _role) external;
20     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
21 }
22 
23 contract RightAndRoles is IRightAndRoles {
24     constructor (address[] _roles) public {
25         uint8 len = uint8(_roles.length);
26         require(len > 0 &&len <16);
27         wallets.length = len;
28 
29         for(uint8 i = 0; i < len; i++){
30             wallets[i].push(_roles[i]);
31             roles[_roles[i]] += uint16(2)**i;
32             emit WalletChanged(_roles[i], address(0),i);
33         }
34         
35     }
36 
37     function changeClons(address _clon, uint8 _role, bool _mod) external {
38         require(wallets[_role][0] == msg.sender&&_clon != msg.sender);
39         emit CloneChanged(_clon,_role,_mod);
40         uint16 roleMask = uint16(2)**_role;
41         if(_mod){
42             require(roles[_clon]&roleMask == 0);
43             wallets[_role].push(_clon);
44         }else{
45             address[] storage tmp = wallets[_role];
46             uint8 i = 1;
47             for(i; i < tmp.length; i++){
48                 if(tmp[i] == _clon) break;
49             }
50             require(i > tmp.length);
51             tmp[i] = tmp[tmp.length];
52             delete tmp[tmp.length];
53         }
54         roles[_clon] = _mod?roles[_clon]|roleMask:roles[_clon]&~roleMask;
55     }
56 
57     function changeWallet(address _wallet, uint8 _role) external {
58         require(wallets[_role][0] == msg.sender || wallets[0][0] == msg.sender || (wallets[2][0] == msg.sender && _role == 0));
59         emit WalletChanged(wallets[_role][0],_wallet,_role);
60         uint16 roleMask = uint16(2)**_role;
61         address[] storage tmp = wallets[_role];
62         for(uint8 i = 0; i < tmp.length; i++){
63             roles[tmp[i]] = roles[tmp[i]]&~roleMask;
64         }
65         delete  wallets[_role];
66         tmp.push(_wallet);
67         roles[_wallet] = roles[_wallet]|roleMask;
68     }
69 
70     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool) {
71         return roles[_sender]&_roleMask != 0;
72     }
73 
74     function getMainWallets() view external returns(address[]){
75         address[] memory _wallets = new address[](wallets.length);
76         for(uint8 i = 0; i<wallets.length; i++){
77             _wallets[i] = wallets[i][0];
78         }
79         return _wallets;
80     }
81 
82     function getCloneWallets(uint8 _role) view external returns(address[]){
83         return wallets[_role];
84     }
85 }
86 
87 
88 
89 contract GuidedByRoles {
90     IRightAndRoles public rightAndRoles;
91     constructor(IRightAndRoles _rightAndRoles) public {
92         rightAndRoles = _rightAndRoles;
93     }
94 }
95 
96 contract BaseIterableDubleToken{
97     
98     uint8 public withdrawPriority;
99     uint8 public mixedType;
100     
101     uint256[2] public supply = [0,0];
102     
103     struct Item {
104         uint256 index;
105         uint256 value;
106     }
107     
108     address[][] items = [[address(0)],[address(0)]];
109     
110     mapping (uint8 => mapping (address => Item)) balances;
111     
112     mapping (address => mapping (address => uint256)) allowed;
113     
114     event Transfer(address indexed from, address indexed to, uint256 value);
115     
116     event Mint(address indexed to, uint256 value);
117     
118     event Burn(address indexed from, uint256 value);
119     
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121     
122     event changeBalance(uint8 indexed tokenType, address indexed owner, uint256 newValue);
123     
124     function totalSupply() view public returns(uint256){
125         return supply[0] + supply[1];
126     }
127     
128     function balanceOf(address _who) view public returns(uint256) {
129         return getBalance(0,_who) + getBalance(1,_who);
130     }
131     
132     function transfer(address _to, uint256 _value) public returns (bool){
133         internalTransfer(msg.sender,_to,_value);
134         return true;
135     }
136     
137     function getBalance(uint8 _type ,address _addr) view public returns(uint256){
138         return balances[_type][_addr].value;
139     }
140     
141     function allowance(address _owner, address _spender) public view returns (uint256) {
142         return allowed[_owner][_spender];
143     }
144     
145     function approve(address _spender, uint256 _value) public returns (bool) {
146         allowed[msg.sender][_spender] = _value;
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150     
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152         require(allowed[_from][msg.sender] >= _value);
153         
154         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
155         internalTransfer(_from, _to, _value);
156         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
157         return true;
158     }
159     
160     function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
161         uint256 _tmpAllowed = allowed[msg.sender][_spender] + _addedValue;
162         require(_tmpAllowed >= _addedValue);
163 
164         allowed[msg.sender][_spender] = _tmpAllowed;
165         emit Approval(msg.sender, _spender, _tmpAllowed);
166         return true;
167     }
168     
169     function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
170         require(allowed[msg.sender][_spender] >= _subtractedValue);
171         
172         allowed[msg.sender][_spender] -= _subtractedValue;
173         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176     
177     function internalMint(uint8 _type, address _account, uint256 _value) internal {
178         require(totalSupply() + _value >= _value);
179         supply[_type] += _value;
180         uint256 _tmpBalance = getBalance(_type,_account) + _value;
181         emit Mint(_account,_value);
182         setBalance(_type,_account,_tmpBalance);
183     }
184     
185     function internalBurn(uint8 _type, address _account, uint256 _value) internal {
186         uint256 _tmpBalance = getBalance(_type,_account);
187         require(_tmpBalance >= _value);
188         _tmpBalance -= _value;
189         emit Burn(_account,_value);
190         setBalance(_type,_account,_tmpBalance);
191     }
192     
193     function setBalance(uint8 _type ,address _addr, uint256 _value) internal {
194         address[] storage _items = items[_type];
195         Item storage _item = balances[_type][_addr];
196         if(_item.value == _value) return;
197         emit changeBalance(_type, _addr, _value);
198         if(_value == 0){
199             uint256 _index = _item.index;
200             delete balances[_type][_addr];
201             _items[_index] = _items[items.length - 1];
202             balances[_type][_items[_index]].index = _index;
203             _items.length = _items.length - 1;
204         }else{
205             if(_item.value == 0){
206                _item.index = _items.length; 
207                _items.push(_addr);
208             }
209             _item.value = _value;
210         }
211     }
212     
213     function internalSend(uint8 _type, address _to, uint256 _value) internal {
214         uint8 _tmpType = (mixedType > 1) ? mixedType - 2 : _type;
215         uint256 _tmpBalance = getBalance(_tmpType,_to);
216         require(mixedType != 1 || _tmpBalance > 0);
217         if(_tmpType != _type){
218             supply[_type] -= _value;
219             supply[_tmpType] += _value;
220         }
221         setBalance(_tmpType,_to,_tmpBalance + _value);
222     }
223     
224     function internalTransfer(address _from, address _to, uint256 _value) internal {
225         require(balanceOf(_from) >= _value);
226         emit Transfer(_from,_to,_value);
227         uint8 _tmpType = withdrawPriority;
228         uint256 _tmpValue = _value;
229         uint256 _tmpBalance = getBalance(_tmpType,_from);
230         if(_tmpBalance < _value){
231             setBalance(_tmpType,_from,0);
232             internalSend(_tmpType,_to,_tmpBalance);
233             _tmpType = (_tmpType == 0) ? 1 : 0;
234             _tmpValue = _tmpValue - _tmpBalance;
235             _tmpBalance = getBalance(_tmpType,_from);
236         }
237         setBalance(_tmpType,_from,_tmpBalance - _tmpValue);
238         internalSend(_tmpType,_to,_tmpValue);
239     }
240     
241     function getBalancesList(uint8 _type) view external returns(address[] _addreses, uint256[] _values){
242         require(_type < 3);
243         address[] storage _items = items[_type];
244         uint256 _length = _items.length - 1;
245         _addreses = new address[](_length);
246         _values = new uint256[](_length);
247         for(uint256 i = 0; i < _length; i++){
248             _addreses[i] = _items[i + 1];
249             _values[i] = getBalance(_type,_items[i + 1]);
250         }
251     }
252 }
253 
254 contract FreezingToken is BaseIterableDubleToken, GuidedByRoles {
255     struct freeze {
256     uint256 amount;
257     uint256 when;
258     }
259 
260     mapping (address => freeze) freezedTokens;
261     
262     constructor(IRightAndRoles _rightAndRoles) GuidedByRoles(_rightAndRoles) public {}
263 
264     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
265         freeze storage _freeze = freezedTokens[_beneficiary];
266         if(_freeze.when < now) return 0;
267         return _freeze.amount;
268     }
269 
270     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
271         freeze storage _freeze = freezedTokens[_beneficiary];
272         if(_freeze.when < now) return 0;
273         return _freeze.when;
274     }
275 
276     function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {
277         require(rightAndRoles.onlyRoles(msg.sender,3));
278         require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);
279         for(uint16 i = 0; i < _beneficiary.length; i++){
280             freeze storage _freeze = freezedTokens[_beneficiary[i]];
281             _freeze.amount = _amount[i];
282             _freeze.when = _when[i];
283         }
284     }
285 
286     function transfer(address _to, uint256 _value) public returns (bool) {
287         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender) + _value);
288         return super.transfer(_to,_value);
289     }
290 
291     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
292         require(balanceOf(_from) >= freezedTokenOf(_from) + _value);
293         return super.transferFrom( _from,_to,_value);
294     }
295 }
296 
297 contract managedToken is FreezingToken{
298     uint256[2] public mintLimit = [101000000 ether, 9000000 ether]; // privileged, usual (total hardcap = 110M tokens)
299     uint256[2] public totalMint = [0,0];
300     string public constant name = "ALE";
301     string public constant symbol = "ALE";
302     uint8 public constant decimals = 18;
303     
304     constructor(IRightAndRoles _rightAndRoles) FreezingToken(_rightAndRoles) public {}
305     
306     function internalMint(uint8 _type, address _account, uint256 _value) internal {
307         totalMint[_type] += _value;
308         require(totalMint[_type] <= mintLimit[_type]);
309         super.internalMint(_type,_account,_value);
310     }
311     // _withdrawPriority 
312     // first use when sending:
313     // 0 - privileged
314     // 1 - usual
315     // _mixedType
316     // 0 - mixing enabled
317     // 1 - mixing disabled
318     // 2 - mixing disabled, forced conversion into privileged
319     // 3 - mixing disabled, forced conversion into usual
320     function setup(uint8 _withdrawPriority, uint8 _mixedType) public {
321         require(rightAndRoles.onlyRoles(msg.sender,3));
322         require(_withdrawPriority < 2 && _mixedType < 4);
323         mixedType = _mixedType;
324         withdrawPriority = _withdrawPriority;
325     }
326     function massMint(uint8[] _types, address[] _addreses, uint256[] _values) public {
327         require(rightAndRoles.onlyRoles(msg.sender,3));
328         require(_types.length == _addreses.length && _addreses.length == _values.length);
329         for(uint256 i = 0; i < _types.length; i++){
330             internalMint(_types[i], _addreses[i], _values[i]);
331         }
332     }
333     function massBurn(uint8[] _types, address[] _addreses, uint256[] _values) public {
334         require(rightAndRoles.onlyRoles(msg.sender,3));
335         require(_types.length == _addreses.length && _addreses.length == _values.length);
336         for(uint256 i = 0; i < _types.length; i++){
337             internalBurn(_types[i], _addreses[i], _values[i]);
338         }
339     }
340     
341     function distribution(uint8 _type, address[] _addresses, uint256[] _values, uint256[] _when) public {
342         require(rightAndRoles.onlyRoles(msg.sender,3));
343         require(_addresses.length == _values.length && _values.length == _when.length);
344         uint256 sumValue = 0;
345         for(uint256 i = 0; i < _addresses.length; i++){
346             sumValue += _values[i]; 
347             uint256 _value = getBalance(_type,_addresses[i]) + _values[i];
348             setBalance(_type,_addresses[i],_value);
349             emit Transfer(msg.sender, _addresses[i], _values[i]);
350             if(_when[i] > 0){
351                 _value = balanceOf(_addresses[i]);
352                 freeze storage _freeze = freezedTokens[_addresses[i]];
353                 _freeze.amount = _value;
354                 _freeze.when = _when[i];
355             }
356         }
357         uint256 _balance = getBalance(_type, msg.sender);
358         require(_balance >= sumValue);
359         setBalance(_type,msg.sender,_balance-sumValue);
360     }
361 }
362 
363 
364 
365 contract Creator{
366 
367     IRightAndRoles public rightAndRoles;
368     managedToken public token;
369 
370     constructor() public{
371         address[] memory tmp = new address[](3);
372         tmp[0] = address(this);
373         tmp[1] = msg.sender;
374         tmp[2] = 0x19557B8beb5cC065fe001dc466b3642b747DA62B;
375 
376         rightAndRoles = new RightAndRoles(tmp);
377 
378         token=new managedToken(rightAndRoles);
379     }
380 
381 }