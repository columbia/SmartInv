1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ERC223ReceivingContract.sol
4 
5 contract ERC223ReceivingContract {
6     /**
7      * @dev Standard ERC223 function that will handle incoming token transfers.
8      *
9      * @param _from  Token sender address.
10      * @param _value Amount of tokens.
11      * @param _data  Transaction metadata.
12      */
13     function tokenFallback(address _from, uint256 _value, bytes _data) public;
14 }
15 
16 // File: contracts/ERC20Interface.sol
17 
18 contract ERC20Interface {
19     uint256 public totalSupply;
20 
21     function balanceOf(address _owner) public constant returns (uint256);
22     function transfer(address _to, uint256 _value) public returns (bool ok);
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok);
24     function approve(address _spender, uint256 _value) public returns (bool ok);
25     function allowance(address _owner, address _spender) public constant returns (uint256);
26 
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 // File: contracts/SafeMath.sol
32 
33 /**
34  * Math operations with safety checks
35  */
36 library SafeMath {
37     function multiply(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a * b;
39         assert(a == 0 || c / a == b);
40         return c;
41     }
42 
43     function divide(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b > 0);
45         uint256 c = a / b;
46         assert(a == b * c + a % b);
47         return c;
48     }
49 
50     function subtract(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         assert(c >= a && c >= b);
58         return c;
59     }
60 }
61 
62 // File: contracts/StandardToken.sol
63 
64 contract StandardToken is ERC20Interface {
65     using SafeMath for uint256;
66 
67     /* Actual balances of token holders */
68     mapping(address => uint) balances;
69     /* approve() allowances */
70     mapping (address => mapping (address => uint)) allowed;
71 
72     /**
73      *
74      * Fix for the ERC20 short address attack
75      *
76      * http://vessenes.com/the-erc20-short-address-attack-explained/
77      */
78     modifier onlyPayloadSize(uint256 size) {
79         require(msg.data.length == size + 4);
80         _;
81     }
82 
83     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool ok) {
84         require(_to != address(0));
85         require(_value > 0);
86         uint256 holderBalance = balances[msg.sender];
87         require(_value <= holderBalance);
88 
89         balances[msg.sender] = holderBalance.subtract(_value);
90         balances[_to] = balances[_to].add(_value);
91 
92         emit Transfer(msg.sender, _to, _value);
93 
94         return true;
95     }
96 
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {
98         require(_to != address(0));
99         uint256 allowToTrans = allowed[_from][msg.sender];
100         uint256 balanceFrom = balances[_from];
101         require(_value <= balanceFrom);
102         require(_value <= allowToTrans);
103 
104         balances[_from] = balanceFrom.subtract(_value);
105         balances[_to] = balances[_to].add(_value);
106         allowed[_from][msg.sender] = allowToTrans.subtract(_value);
107 
108         emit Transfer(_from, _to, _value);
109 
110         return true;
111     }
112 
113     /**
114      * @dev Returns balance of the `_owner`.
115      *
116      * @param _owner   The address whose balance will be returned.
117      * @return balance Balance of the `_owner`.
118      */
119     function balanceOf(address _owner) public constant returns (uint256) {
120         return balances[_owner];
121     }
122 
123     function approve(address _spender, uint256 _value) public returns (bool ok) {
124         // To change the approve amount you first have to reduce the addresses`
125         //  allowance to zero by calling `approve(_spender, 0)` if it is not
126         //  already 0 to mitigate the race condition described here:
127         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128         //    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
129         //    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
130         allowed[msg.sender][_spender] = _value;
131 
132         emit Approval(msg.sender, _spender, _value);
133 
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public constant returns (uint256) {
138         return allowed[_owner][_spender];
139     }
140 
141     /**
142      * Atomic increment of approved spending
143      *
144      * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      */
147     function increaseApproval(address _spender, uint256 _addedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {
148         uint256 oldValue = allowed[msg.sender][_spender];
149         allowed[msg.sender][_spender] = oldValue.add(_addedValue);
150 
151         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152 
153         return true;
154     }
155 
156     /**
157      * Atomic decrement of approved spending.
158      *
159      * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      */
161     function decreaseApproval(address _spender, uint256 _subtractedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {
162         uint256 oldValue = allowed[msg.sender][_spender];
163         if (_subtractedValue > oldValue) {
164             allowed[msg.sender][_spender] = 0;
165         } else {
166             allowed[msg.sender][_spender] = oldValue.subtract(_subtractedValue);
167         }
168 
169         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170 
171         return true;
172     }
173 
174 }
175 
176 // File: contracts/BurnableToken.sol
177 
178 contract BurnableToken is StandardToken {
179     /**
180      * @dev Burns a specific amount of tokens.
181      * @param _value The amount of token to be burned.
182      */
183     function burn(uint256 _value) public {
184         _burn(msg.sender, _value);
185     }
186 
187     function _burn(address _holder, uint256 _value) internal {
188         require(_value <= balances[_holder]);
189 
190         balances[_holder] = balances[_holder].subtract(_value);
191         totalSupply = totalSupply.subtract(_value);
192 
193         emit Burn(_holder, _value);
194         emit Transfer(_holder, address(0), _value);
195     }
196 
197     event Burn(address indexed _burner, uint256 _value);
198 }
199 
200 // File: contracts/Ownable.sol
201 
202 /**
203  * @title Ownable
204  * @dev The Ownable contract has an owner address, and provides basic authorization control
205  * functions, this simplifies the implementation of "user permissions".
206  */
207 contract Ownable {
208     address public owner;
209     address public newOwner;
210 
211     /**
212      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
213      * account.
214      */
215     constructor() public {
216         owner = msg.sender;
217     }
218 
219     /**
220      * @dev Throws if called by any account other than the owner.
221      */
222     modifier onlyOwner() {
223         require(msg.sender == owner);
224         _;
225     }
226 
227     /**
228      * @dev Allows the current owner to transfer control of the contract to a newOwner.
229      * @param _newOwner The address to transfer ownership to.
230      */
231     function transferOwnership(address _newOwner) public onlyOwner {
232         newOwner = _newOwner;
233     }
234 
235     function acceptOwnership() public {
236         require(msg.sender == newOwner);
237 
238         owner = newOwner;
239         newOwner = address(0);
240 
241         emit OwnershipTransferred(owner, newOwner);
242     }
243 
244     event OwnershipTransferred(address indexed _from, address indexed _to);
245 }
246 
247 // File: contracts/ERC223Interface.sol
248 
249 contract ERC223Interface is ERC20Interface {
250     function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok);
251 
252     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes indexed _data);
253 }
254 
255 // File: contracts/Standard223Token.sol
256 
257 contract Standard223Token is ERC223Interface, StandardToken {
258     function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok) {
259         if (!super.transfer(_to, _value)) {
260             revert();
261         }
262         if (isContract(_to)) {
263             contractFallback(msg.sender, _to, _value, _data);
264         }
265 
266         emit Transfer(msg.sender, _to, _value, _data);
267 
268         return true;
269     }
270 
271     function transfer(address _to, uint256 _value) public returns (bool ok) {
272         return transfer(_to, _value, new bytes(0));
273     }
274 
275     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool ok) {
276         if (!super.transferFrom(_from, _to, _value)) {
277             revert();
278         }
279         if (isContract(_to)) {
280             contractFallback(_from, _to, _value, _data);
281         }
282 
283         emit Transfer(_from, _to, _value, _data);
284 
285         return true;
286     }
287 
288     function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {
289         return transferFrom(_from, _to, _value, new bytes(0));
290     }
291 
292     function contractFallback(address _origin, address _to, uint256 _value, bytes _data) private {
293         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
294         receiver.tokenFallback(_origin, _value, _data);
295     }
296 
297     function isContract(address _addr) private view returns (bool is_contract) {
298         uint256 length;
299         assembly {
300             length := extcodesize(_addr)
301         }
302 
303         return (length > 0);
304     }
305 }
306 
307 // File: contracts/ICOToken.sol
308 
309 // ----------------------------------------------------------------------------
310 // ICO Token contract
311 // ----------------------------------------------------------------------------
312 contract ICOToken is BurnableToken, Ownable, Standard223Token {
313     string public name;
314     string public symbol;
315     uint8 public decimals;
316 
317     // ------------------------------------------------------------------------
318     // Constructor
319     // ------------------------------------------------------------------------
320     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
321         name = _name;
322         symbol = _symbol;
323         decimals = _decimals;
324         totalSupply = _totalSupply;
325 
326         balances[owner] = totalSupply;
327 
328         emit Mint(owner, totalSupply);
329         emit Transfer(address(0), owner, totalSupply);
330         emit MintFinished();
331     }
332 
333     function () public payable {
334         revert();
335     }
336 
337     event Mint(address indexed _to, uint256 _amount);
338     event MintFinished();
339 }
340 
341 // File: contracts/PreICO.sol
342 
343 contract PreICO is Ownable, ERC223ReceivingContract {
344     using SafeMath for uint256;
345 
346     struct DatePeriod {
347         uint256 start;
348         uint256 end;
349     }
350 
351     struct Beneficiary {
352         address wallet;
353         uint256 transferred;
354         uint256 toTransfer;
355     }
356 
357     uint256 public price = 0.002 ether / 1e3;
358     uint256 public minPurchase = 0.01 ether;
359     // Tokens sold for ether
360     uint256 public totalSold = 0;
361     // Tokens for sale for ether
362     uint256 public forSale = 350000e3; // 350,000.000
363     DatePeriod public salePeriod;
364 
365     ICOToken internal token;
366     Beneficiary[] internal beneficiaries;
367 
368     constructor(ICOToken _token, uint256 _startTime, uint256 _endTime) public {
369         token = _token;
370         salePeriod.start = _startTime;
371         salePeriod.end = _endTime;
372 
373         addBeneficiary(0x7ADCE5a8CDC22b65A07b29Fb9F90ebe16F450aB1, 200 ether);
374         addBeneficiary(0xa406b97666Ea3D2093bDE9644794F8809B0F58Cc, 300 ether);
375         addBeneficiary(0x3Be990A4031D6A6a9f44c686ccD8B194Bdeea790, 200 ether);
376     }
377 
378     function () public isRunning payable {
379         require(msg.value >= minPurchase);
380 
381         uint256 unsold = forSale.subtract(totalSold);
382         uint256 paid = msg.value;
383         uint256 purchased = paid.divide(price);
384         if (purchased > unsold) {
385             purchased = unsold;
386         }
387         uint256 toReturn = paid.subtract(purchased.multiply(price));
388         uint256 reward = purchased.multiply(30).divide(100); // 30% bonus reward
389 
390         if (toReturn > 0) {
391             msg.sender.transfer(toReturn);
392         }
393         token.transfer(msg.sender, purchased.add(reward));
394         allocateFunds();
395         totalSold = totalSold.add(purchased);
396     }
397 
398     modifier isRunning() {
399         require(now >= salePeriod.start);
400         require(now <= salePeriod.end);
401         _;
402     }
403 
404     modifier afterEnd() {
405         require(now > salePeriod.end);
406         _;
407     }
408 
409     function burnUnsold() public onlyOwner afterEnd {
410         uint256 unsold = token.balanceOf(address(this));
411         token.burn(unsold);
412     }
413 
414     function changeStartTime(uint256 _startTime) public onlyOwner {
415         salePeriod.start = _startTime;
416     }
417 
418     function changeEndTime(uint256 _endTime) public onlyOwner {
419         salePeriod.end = _endTime;
420     }
421 
422     // Inside a tokenFallback function msg.sender is a token-contract.
423     function tokenFallback(address _from, uint256 _value, bytes _data) public {
424         // Accept only ours token
425         if (msg.sender != address(token)) {
426             revert();
427         }
428         // Only contract owner can deposit tokens
429         if (_from != owner) {
430             revert();
431         }
432     }
433 
434     function withdrawFunds(address wallet) public onlyOwner afterEnd {
435         uint256 balance = address(this).balance;
436         require(balance > 0);
437 
438         wallet.transfer(balance);
439     }
440 
441     function allocateFunds() internal {
442         uint256 balance = address(this).balance;
443         uint length = beneficiaries.length;
444         uint256 toTransfer = 0;
445 
446         for (uint i = 0; i < length; i++) {
447             Beneficiary storage beneficiary = beneficiaries[i];
448             toTransfer = beneficiary.toTransfer.subtract(beneficiary.transferred);
449             if (toTransfer > 0) {
450                 if (toTransfer > balance) {
451                     toTransfer = balance;
452                 }
453                 beneficiary.wallet.transfer(toTransfer);
454                 beneficiary.transferred = beneficiary.transferred.add(toTransfer);
455                 break;
456             }
457         }
458     }
459 
460     function addBeneficiary(address _wallet, uint256 _toTransfer) internal {
461         beneficiaries.push(Beneficiary({
462             wallet: _wallet,
463             transferred: 0,
464             toTransfer: _toTransfer
465             }));
466     }
467 }