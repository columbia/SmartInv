1 pragma solidity ^0.4.24;
2 
3 contract IERC20Token {
4     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
5     function name() public constant returns (string) {}
6     function symbol() public constant returns (string) {}
7     function decimals() public constant returns (uint8) {}
8     function totalSupply() public constant returns (uint256) {}
9     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
10     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
11 
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14     function approve(address _spender, uint256 _value) public returns (bool success);
15 }
16 
17 contract Ownable {
18     address public owner;
19     address public newOwner;
20 
21     event OwnerUpdate(address _prevOwner, address _newOwner);
22 
23     /*
24         @dev constructor
25     */
26     constructor (address _owner) public {
27         owner = _owner;
28     }
29 
30     /*
31         @dev allows execution by the owner only
32     */
33     modifier ownerOnly {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     /*
39         @dev allows transferring the contract ownership
40         the new owner still needs to accept the transfer
41         can only be called by the contract owner
42 
43         @param _newOwner    new contract owner
44     */
45     function transferOwnership(address _newOwner) public ownerOnly {
46         require(_newOwner != owner);
47         newOwner = _newOwner;
48     }
49 
50     /*
51         @dev used by a new owner to accept an ownership transfer
52     */
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         emit OwnerUpdate(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 
61 contract Utils {
62     /*
63         @dev constructor
64     */
65     constructor() public {
66     }
67 
68     /*
69         @dev verifies that an amount is greater than zero
70     */
71     modifier greaterThanZero(uint256 _amount) {
72         require(_amount > 0);
73         _;
74     }
75 
76     /*
77         @dev validates an address - currently only checks that it isn't null
78     */
79     modifier validAddress(address _address) {
80         require(_address != 0x0);
81         _;
82     }
83 
84     /*
85         @dev verifies that the address is different than this contract address
86     */
87     modifier notThis(address _address) {
88         require(_address != address(this));
89         _;
90     }
91 
92     /*
93         @dev verifies that the string is not empty
94     */
95     modifier notEmpty(string _str) {
96         require(bytes(_str).length > 0);
97         _;
98     }
99 
100     // Overflow protected math functions
101 
102     /*
103         @dev returns the sum of _x and _y, asserts if the calculation overflows
104 
105         @param _x   value 1
106         @param _y   value 2
107 
108         @return sum
109     */
110     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
111         uint256 z = _x + _y;
112         assert(z >= _x);
113         return z;
114     }
115 
116     /*
117         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
118 
119         @param _x   minuend
120         @param _y   subtrahend
121 
122         @return difference
123     */
124     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
125         require(_x >= _y);
126         return _x - _y;
127     }
128 
129     /*
130         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
131 
132         @param _x   factor 1
133         @param _y   factor 2
134 
135         @return product
136     */
137     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
138         uint256 z = _x * _y;
139         assert(_x == 0 || z / _x == _y);
140         return z;
141     }
142 }
143 
144 contract WithdrawalConfigurations is Ownable, Utils {
145     
146     /*
147      *  Members
148      */
149 
150     uint public      minWithdrawalCoolingPeriod;
151     uint constant    maxWithdrawalCoolingPeriod = 12 * 1 weeks; // = 14515200 seconds
152     uint public      withdrawalCoolingPeriod;
153    
154     /*
155      *  Events
156      */
157     event WithdrawalRequested(address _sender, address _smartWallet);
158     event SetWithdrawalCoolingPeriod(uint _withdrawalCoolingPeriod);
159 
160     /*
161         @dev constructor
162 
163         @param _withdrawalCoolingPeriod       The cooling period 
164         @param _minWithdrawalCoolingPeriod    The minimum time from withdraw request to allow performing it
165 
166     */
167     constructor (uint _withdrawalCoolingPeriod, uint _minWithdrawalCoolingPeriod) 
168         Ownable(msg.sender)
169         public
170         {
171             require(_withdrawalCoolingPeriod <= maxWithdrawalCoolingPeriod &&
172                     _withdrawalCoolingPeriod >= _minWithdrawalCoolingPeriod);
173             require(_minWithdrawalCoolingPeriod >= 0);
174 
175             minWithdrawalCoolingPeriod = _minWithdrawalCoolingPeriod;
176             withdrawalCoolingPeriod = _withdrawalCoolingPeriod;
177        }
178 
179     /*
180         @dev Get the withdrawalCoolingPeriod parameter value. 
181    
182      */
183     function getWithdrawalCoolingPeriod() external view returns(uint) {
184         return withdrawalCoolingPeriod;
185     }
186 
187     /*
188         @dev Set the withdrawalCoolingPeriod parameter value. 
189 
190         @param _withdrawalCoolingPeriod   Cooling period in seconds
191      */
192     function setWithdrawalCoolingPeriod(uint _withdrawalCoolingPeriod)
193         ownerOnly()
194         public
195         {
196             require (_withdrawalCoolingPeriod <= maxWithdrawalCoolingPeriod &&
197                      _withdrawalCoolingPeriod >= minWithdrawalCoolingPeriod);
198             withdrawalCoolingPeriod = _withdrawalCoolingPeriod;
199             emit SetWithdrawalCoolingPeriod(_withdrawalCoolingPeriod);
200     }
201 
202     /*
203         @dev Fire the WithdrawalRequested event. 
204 
205         @param _userWithdrawalAccount   User withdrawal account address
206         @param _sender                  The user account, activating this request
207      */
208     function emitWithrawalRequestEvent(address _sender, address _smartWallet) 
209         public
210         {
211             emit WithdrawalRequested(_sender, _smartWallet);
212     }
213 }
214 
215 library SmartWalletLib {
216 
217     /*
218      *  Structs
219      */ 
220     struct Wallet {
221         address operatorAccount;
222         address userWithdrawalAccount;
223         address feesAccount;
224         uint    withdrawAllowedAt; //In seconds
225     }
226 
227     /*
228      *  Members
229      */
230     string constant VERSION = "1.1";
231     address constant withdrawalConfigurationsContract = 0xDdD336eAad17F1D40cc81997Fb956608f00639FF; 
232     
233     /*
234      *  Modifiers
235      */
236     modifier validAddress(address _address) {
237         require(_address != 0x0);
238         _;
239     }
240 
241     modifier addressNotSet(address _address) {
242         require(_address == 0);
243         _;
244     }
245 
246     modifier operatorOnly(address _operatorAccount) {
247         require(msg.sender == _operatorAccount);
248         _;
249     }
250 
251     modifier userWithdrawalAccountOnly(Wallet storage _self) {
252         require(msg.sender == _self.userWithdrawalAccount);
253         _;
254     }
255 
256     /*
257      *  Events
258      */
259     event TransferToUserWithdrawalAccount(address _token, address _userWithdrawalAccount, uint _amount, address _feesToken, address _feesAccount, uint _fee);
260     event SetUserWithdrawalAccount(address _userWithdrawalAccount);
261     event PerformUserWithdraw(address _token, address _userWithdrawalAccount, uint _amount);
262     
263     /*
264         @dev Initialize the wallet with the operator and backupAccount address
265         
266         @param _self                        Wallet storage
267         @param _operator                    The operator account
268         @param _feesAccount                 The account to transfer fees to
269     */
270     function initWallet(Wallet storage _self, address _operator, address _feesAccount) 
271             public
272             validAddress(_operator)
273             validAddress(_feesAccount)
274             {
275         
276                 _self.operatorAccount = _operator;
277                 _self.feesAccount = _feesAccount;
278     }
279 
280     /*
281         @dev Setting the account of the user to send funds to. 
282         
283         @param _self                        Wallet storage
284         @param _userWithdrawalAccount       The user account to withdraw funds to
285     */
286     function setUserWithdrawalAccount(Wallet storage _self, address _userWithdrawalAccount) 
287             public
288             operatorOnly(_self.operatorAccount)
289             validAddress(_userWithdrawalAccount)
290             addressNotSet(_self.userWithdrawalAccount)
291             {
292         
293                 _self.userWithdrawalAccount = _userWithdrawalAccount;
294                 emit SetUserWithdrawalAccount(_userWithdrawalAccount);
295     }
296     
297     /*
298         @dev Withdraw funds to the user account. 
299 
300         @param _self                Wallet storage
301         @param _token               The ERC20 token the owner withdraws from 
302         @param _amount              Amount to transfer  
303         @param _fee                 Fee to transfer   
304     */
305     function transferToUserWithdrawalAccount(Wallet storage _self, IERC20Token _token, uint _amount, IERC20Token _feesToken, uint _fee) 
306             public 
307             operatorOnly(_self.operatorAccount)
308             validAddress(_self.userWithdrawalAccount)
309             {
310 
311                 if (_fee > 0) {        
312                     _feesToken.transfer(_self.feesAccount, _fee); 
313                 }       
314                 
315                 _token.transfer(_self.userWithdrawalAccount, _amount);
316                 emit TransferToUserWithdrawalAccount(_token, _self.userWithdrawalAccount, _amount,  _feesToken, _self.feesAccount, _fee);   
317         
318     }
319 
320     /*
321         @dev returns the sum of _x and _y, asserts if the calculation overflows
322 
323         @param _x   value 1
324         @param _y   value 2
325 
326         @return sum
327     */
328     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
329         uint256 z = _x + _y;
330         assert(z >= _x);
331         return z;
332     }
333     
334     /*
335         @dev user request withdraw. 
336 
337         @param _self                Wallet storage
338         @param _token               The ERC20 token the owner withdraws from 
339         
340     */
341     function requestWithdraw(Wallet storage _self) 
342         public 
343         userWithdrawalAccountOnly(_self)
344         {
345             
346             WithdrawalConfigurations withdrawalConfigurations = WithdrawalConfigurations(withdrawalConfigurationsContract);
347             
348             _self.withdrawAllowedAt = safeAdd(now, withdrawalConfigurations.getWithdrawalCoolingPeriod());
349 
350             withdrawalConfigurations.emitWithrawalRequestEvent(msg.sender, address(this));
351     }
352 
353     /*
354         @dev user perform withdraw. 
355 
356         @param _self                Wallet storage
357         @param _token               The ERC20 token the owner withdraws from 
358         
359     */
360     function performUserWithdraw(Wallet storage _self, IERC20Token _token)
361         public
362         userWithdrawalAccountOnly(_self)
363         {
364             require(_self.withdrawAllowedAt != 0 &&
365                     _self.withdrawAllowedAt <= now );
366 
367             uint userBalance = _token.balanceOf(this);
368             _token.transfer(_self.userWithdrawalAccount, userBalance);
369             emit PerformUserWithdraw(_token, _self.userWithdrawalAccount, userBalance);   
370         }
371 
372 }
373 
374 contract SmartWallet {
375 
376     /*
377      *  Members
378      */
379     using SmartWalletLib for SmartWalletLib.Wallet;
380     SmartWalletLib.Wallet public wallet;
381        
382    // Wallet public wallet;
383     /*
384      *  Events
385      */
386     event TransferToUserWithdrawalAccount(address _token, address _userWithdrawalAccount, uint _amount, address _feesToken, address _feesAccount, uint _fee);
387     event SetUserWithdrawalAccount(address _userWithdrawalAccount);
388     event PerformUserWithdraw(address _token, address _userWithdrawalAccount, uint _amount);
389      
390     /*
391         @dev constructor
392 
393         @param _backupAccount       A default operator's account to send funds to, in cases where the user account is
394                                     unavailable or lost
395         @param _operator            The contract operator address
396         @param _feesAccount         The account to transfer fees to 
397 
398     */
399     constructor (address _operator, address _feesAccount) public {
400         wallet.initWallet(_operator, _feesAccount);
401     }
402 
403     /*
404         @dev Setting the account of the user to send funds to. 
405         
406         @param _userWithdrawalAccount       The user account to withdraw funds to
407         
408     */
409     function setUserWithdrawalAccount(address _userWithdrawalAccount) public {
410         wallet.setUserWithdrawalAccount(_userWithdrawalAccount);
411     }
412 
413     /*
414         @dev Withdraw funds to the user account. 
415 
416 
417         @param _token               The ERC20 token the owner withdraws from 
418         @param _amount              Amount to transfer    
419     */
420     function transferToUserWithdrawalAccount(IERC20Token _token, uint _amount, IERC20Token _feesToken, uint _fee) public {
421         wallet.transferToUserWithdrawalAccount(_token, _amount, _feesToken, _fee);
422     }
423 
424     /*
425         @dev Allows the user to request a withdraw of his/her placements
426         
427         @param _token               The ERC20 token the user wishes to withdraw from 
428     */
429     function requestWithdraw() public {
430         wallet.requestWithdraw();
431     }
432 
433     /*
434         @dev Allows the user to perform the requestWithdraw operation
435         
436         @param _token               The ERC20 token the user withdraws from 
437     */
438     function performUserWithdraw(IERC20Token _token) public {
439         wallet.performUserWithdraw(_token);
440     }
441 }