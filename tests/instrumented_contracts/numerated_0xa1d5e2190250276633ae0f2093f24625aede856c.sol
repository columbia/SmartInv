1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         
7         if (a == 0) {
8             return 0;
9         }
10 
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16   
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a / b;
19     }
20 
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 interface ERC223Receiver {
36 
37     function tokenFallback(address _from, uint256 _value, bytes _data) external;
38 
39 }
40 
41 
42 contract ERC20Basic {
43     function totalSupply() public view returns (uint256);
44     function balanceOf(address who) public view returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender)
52     public view returns (uint256);
53 
54     function transferFrom(address from, address to, uint256 value)
55     public returns (bool);
56 
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(
59         address indexed owner,
60         address indexed spender,
61         uint256 value
62     );
63 }
64 
65 
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) balances;
70 
71     uint256 totalSupply_;
72 
73     function totalSupply() public view returns (uint256) {
74         return totalSupply_;
75     }
76 
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80 
81         balances[msg.sender] = balances[msg.sender].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         emit Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) public view returns (uint256) {
88         return balances[_owner];
89     }
90 
91 }
92 
93 
94 contract Ownable {
95     address public owner;
96 
97     event OwnershipRenounced(address indexed previousOwner);
98     event OwnershipTransferred(
99         address indexed previousOwner,
100         address indexed newOwner
101     );
102 
103     constructor() public {
104         owner = msg.sender;
105     }
106 
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111 
112     function transferOwnership(address _newOwner) public onlyOwner {
113         _transferOwnership(_newOwner);
114     }
115 
116     function _transferOwnership(address _newOwner) internal {
117         require(_newOwner != address(0));
118         emit OwnershipTransferred(owner, _newOwner);
119         owner = _newOwner;
120     }
121 }
122 
123 
124 contract BurnableToken is BasicToken {
125 
126     event Burn(address indexed burner, uint256 value);
127 
128     function burn(uint256 _value) public {
129         _burn(msg.sender, _value);
130     }
131 
132     function _burn(address _who, uint256 _value) internal {
133         require(_value <= balances[_who]);
134 
135         balances[_who] = balances[_who].sub(_value);
136         totalSupply_ = totalSupply_.sub(_value);
137         emit Burn(_who, _value);
138         emit Transfer(_who, address(0), _value);
139     }
140 }
141 
142 
143 contract StandardToken is ERC20, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147   function transferFrom(
148     address _from,
149     address _to,
150     uint256 _value
151   )
152   public
153   returns (bool)
154   {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   function allowance(
173     address _owner,
174     address _spender
175   )
176   public
177   view
178   returns (uint256)
179   {
180     return allowed[_owner][_spender];
181   }
182 
183   function increaseApproval(
184     address _spender,
185     uint _addedValue
186   )
187   public
188   returns (bool)
189   {
190     allowed[msg.sender][_spender] = (
191     allowed[msg.sender][_spender].add(_addedValue));
192     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   function decreaseApproval(
197     address _spender,
198     uint _subtractedValue
199   )
200   public
201   returns (bool)
202   {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 
216 /**
217  * MiraToken ERC223 token contract
218  *
219  * Designed and developed by BlockSoft.biz
220  */
221 
222 contract MiraToken is StandardToken, BurnableToken, Ownable {
223     using SafeMath for uint256;
224 
225     event Release();
226     event AddressLocked(address indexed _address, uint256 _time);
227     event TokensReverted(address indexed _address, uint256 _amount);
228     event AddressLockedByKYC(address indexed _address);
229     event KYCVerified(address indexed _address);
230     event TokensRevertedByKYC(address indexed _address, uint256 _amount);
231     event SetTechAccount(address indexed _address);
232 
233     string public constant name = "MIRA Token";
234 
235     string public constant symbol = "MIRA";
236 
237     string public constant standard = "ERC223";
238 
239     uint256 public constant decimals = 8;
240 
241     bool public released = false;
242 
243     address public tokensWallet;
244     address public techAccount;
245 
246     mapping(address => uint) public lockedAddresses;
247     mapping(address => bool) public verifiedKYCAddresses;
248 
249     modifier isReleased() {
250         require(released || msg.sender == tokensWallet || msg.sender == owner || msg.sender == techAccount);
251         require(lockedAddresses[msg.sender] <= now);
252         require(verifiedKYCAddresses[msg.sender]);
253         _;
254     }
255 
256     modifier hasAddressLockupPermission() {
257         require(msg.sender == owner || msg.sender == techAccount);
258         _;
259     }
260 
261     constructor() public {
262         owner = 0x635c8F19795Db0330a5b7465DF0BD2eeD1A5758e;
263         tokensWallet = owner;
264         verifiedKYCAddresses[owner] = true;
265 
266         techAccount = 0x41D621De050A551F5f0eBb83D1332C75339B61E4;
267         verifiedKYCAddresses[techAccount] = true;
268         emit SetTechAccount(techAccount);
269 
270         totalSupply_ = 30770000 * (10 ** decimals);
271         balances[tokensWallet] = totalSupply_;
272         emit Transfer(0x0, tokensWallet, totalSupply_);
273     }
274 
275     function lockAddress(address _address, uint256 _time) public hasAddressLockupPermission returns (bool) {
276         require(_address != owner && _address != tokensWallet && _address != techAccount);
277         require(balances[_address] == 0 && lockedAddresses[_address] == 0 && _time > now);
278         lockedAddresses[_address] = _time;
279 
280         emit AddressLocked(_address, _time);
281         return true;
282     }
283 
284     function revertTokens(address _address) public hasAddressLockupPermission returns (bool) {
285         require(lockedAddresses[_address] > now && balances[_address] > 0);
286 
287         uint256 amount = balances[_address];
288         balances[tokensWallet] = balances[tokensWallet].add(amount);
289         balances[_address] = 0;
290 
291         emit Transfer(_address, tokensWallet, amount);
292         emit TokensReverted(_address, amount);
293 
294         return true;
295     }
296 
297     function lockAddressByKYC(address _address) public hasAddressLockupPermission returns (bool) {
298         require(released);
299         require(balances[_address] == 0 && verifiedKYCAddresses[_address]);
300 
301         verifiedKYCAddresses[_address] = false;
302         emit AddressLockedByKYC(_address);
303 
304         return true;
305     }
306 
307     function verifyKYC(address _address) public hasAddressLockupPermission returns (bool) {
308         verifiedKYCAddresses[_address] = true;
309         emit KYCVerified(_address);
310 
311         return true;
312     }
313 
314     function revertTokensByKYC(address _address) public hasAddressLockupPermission returns (bool) {
315         require(!verifiedKYCAddresses[_address] && balances[_address] > 0);
316 
317         uint256 amount = balances[_address];
318         balances[tokensWallet] = balances[tokensWallet].add(amount);
319         balances[_address] = 0;
320 
321         emit Transfer(_address, tokensWallet, amount);
322         emit TokensRevertedByKYC(_address, amount);
323 
324         return true;
325     }
326 
327     function release() public onlyOwner returns (bool) {
328         require(!released);
329         released = true;
330         emit Release();
331         return true;
332     }
333 
334     function getOwner() public view returns (address) {
335         return owner;
336     }
337 
338     function transfer(address _to, uint256 _value) public isReleased returns (bool) {
339         if (released) {
340             verifiedKYCAddresses[_to] = true;
341         }
342 
343         if (super.transfer(_to, _value)) {
344             uint codeLength;
345             assembly {
346                 codeLength := extcodesize(_to)
347             }
348             if (codeLength > 0) {
349                 ERC223Receiver receiver = ERC223Receiver(_to);
350                 receiver.tokenFallback(msg.sender, _value, msg.data);
351             }
352 
353             return true;
354         }
355 
356         return false;
357     }
358 
359     function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
360         if (released) {
361             verifiedKYCAddresses[_to] = true;
362         }
363 
364         if (super.transferFrom(_from, _to, _value)) {
365             uint codeLength;
366             assembly {
367                 codeLength := extcodesize(_to)
368             }
369             if (codeLength > 0) {
370                 ERC223Receiver receiver = ERC223Receiver(_to);
371                 receiver.tokenFallback(_from, _value, msg.data);
372             }
373 
374             return true;
375         }
376 
377         return false;
378     }
379 
380     function approve(address _spender, uint256 _value) public isReleased returns (bool) {
381         return super.approve(_spender, _value);
382     }
383 
384     function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
385         return super.increaseApproval(_spender, _addedValue);
386     }
387 
388     function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
389         return super.decreaseApproval(_spender, _subtractedValue);
390     }
391 
392     function transferOwnership(address newOwner) public onlyOwner {
393         require(newOwner != owner);
394         require(lockedAddresses[newOwner] < now);
395         address oldOwner = owner;
396         super.transferOwnership(newOwner);
397 
398         if (oldOwner != tokensWallet) {
399             allowed[tokensWallet][oldOwner] = 0;
400             emit Approval(tokensWallet, oldOwner, 0);
401         }
402 
403         if (owner != tokensWallet) {
404             allowed[tokensWallet][owner] = balances[tokensWallet];
405             emit Approval(tokensWallet, owner, balances[tokensWallet]);
406         }
407 
408         verifiedKYCAddresses[newOwner] = true;
409         emit KYCVerified(newOwner);
410     }
411 
412     function changeTechAccountAddress(address _address) public onlyOwner {
413         require(_address != address(0) && _address != techAccount);
414         require(lockedAddresses[_address] < now);
415 
416         techAccount = _address;
417         emit SetTechAccount(techAccount);
418 
419         verifiedKYCAddresses[_address] = true;
420         emit KYCVerified(_address);
421     }
422 
423 }