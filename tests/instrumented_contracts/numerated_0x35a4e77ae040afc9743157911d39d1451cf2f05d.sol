1 pragma solidity ^0.4.24;
2 
3 //*************** SafeMath ***************
4 
5 library SafeMath {
6 
7     /**
8     * @dev Multiplies two numbers, throws on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12         // benefit is lost if 'b' is also tested.
13         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14         if (a == 0) {
15             return 0;
16         }
17 
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         // uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45         c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 //*************** Ownable *************** 
52 
53 contract Ownable {
54     address public owner;
55     address public admin;
56 
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     modifier onlyOwnerAdmin() {
67         require(msg.sender == owner || msg.sender == admin);
68         _;
69     }
70 
71     function transferOwnership(address newOwner)public onlyOwner {
72         if (newOwner != address(0)) {
73             owner = newOwner;
74         }
75     }
76     function setAdmin(address _admin)public onlyOwner {
77         admin = _admin;
78     }
79 
80 }
81 
82 //************* ERC20 *************** 
83 
84 contract ERC20 {
85   
86     function balanceOf(address who)public view returns (uint256);
87     function transfer(address to, uint256 value)public returns (bool);
88     function transferFrom(address from, address to, uint256 value)public returns (bool);
89     function allowance(address owner, address spender)public view returns (uint256);
90     function approve(address spender, uint256 value)public returns (bool);
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 //************* BlackList *************
98 contract BlackList is Ownable {
99 
100     function getBlackListStatus(address _address) external view returns (bool) {
101         return isBlackListed[_address];
102     }
103 
104     mapping (address => bool) public isBlackListed;
105     
106     function addBlackList(address _evilUser) public onlyOwnerAdmin {
107         isBlackListed[_evilUser] = true;
108         emit AddedBlackList(_evilUser);
109     }
110 
111     function removeBlackList (address _clearedUser) public onlyOwnerAdmin {
112         isBlackListed[_clearedUser] = false;
113         emit RemovedBlackList(_clearedUser);
114     }
115 
116     event AddedBlackList(address _user);
117     event RemovedBlackList(address _user);
118 
119 }
120 
121 //************* WhiteList *************
122 // White list of free-of-fee.
123 
124 contract WhiteList is Ownable {
125 
126     function getWhiteListStatus(address _address) external view returns (bool) {
127         return isWhiteListed[_address];
128     }
129 
130     mapping (address => bool) public isWhiteListed;
131     
132     function addWhiteList(address _User) public onlyOwnerAdmin {
133         isWhiteListed[_User] = true;
134         emit AddedWhiteList(_User);
135     }
136 
137     function removeWhiteList(address _User) public onlyOwnerAdmin {
138         isWhiteListed[_User] = false;
139         emit RemovedWhiteList(_User);
140     }
141 
142     event AddedWhiteList(address _user);
143     event RemovedWhiteList(address _user);
144 
145 }
146 
147 //************* KYC ********************
148 
149 contract KYC is Ownable {
150     bool public needVerified = false;
151 
152     mapping (address => bool) public verifiedAccount;
153 
154     event VerifiedAccount(address target, bool Verified);
155     event Error_No_Binding_Address(address _from, address _to);
156     event OpenKYC();
157     event CloseKYC();
158 
159     function openKYC() onlyOwnerAdmin public {
160         needVerified = true;
161         emit OpenKYC();
162     }
163 
164     function closeKYC() onlyOwnerAdmin public {
165         needVerified = false;
166         emit CloseKYC();
167     }
168 
169     function verifyAccount(address _target, bool _Verify) onlyOwnerAdmin public {
170         require(_target != address(0));
171         verifiedAccount[_target] = _Verify;
172         emit VerifiedAccount(_target, _Verify);
173     }
174 
175     function checkIsKYC(address _from, address _to)public view returns (bool) {
176         return (!needVerified || (needVerified && verifiedAccount[_from] && verifiedAccount[_to]));
177     }
178 }
179 
180 //************* TWDT Token *************
181 
182 contract TWDTToken is ERC20,Ownable,KYC,BlackList,WhiteList {
183     using SafeMath for uint256;
184 
185 	// Token Info.
186     string public name;
187     string public symbol;
188     uint256 public totalSupply;
189     uint256 public constant decimals = 6;
190 
191     //Wallet address.
192     address public blackFundsWallet;
193     address public redeemWallet;
194     address public feeWallet;
195 
196     //Transaction fees.
197     uint256 public feeRate = 0;
198     uint256 public minimumFee = 0;
199     uint256 public maximumFee = 0;
200 
201     mapping (address => uint256) public balanceOf;
202     mapping (address => mapping (address => uint256)) allowed;
203     mapping (address => bool) public frozenAccount;
204     mapping (address => bool) public frozenAccountSend;
205 
206     event FrozenFunds(address target, bool frozen);
207     event FrozenFundsSend(address target, bool frozen);
208     event Logs(string log);
209 
210     event TransferredBlackFunds(address _blackListedUser, uint256 _balance);
211     event Redeem(uint256 amount);
212 
213     event Fee(uint256 feeRate, uint256 minFee, uint256 maxFee);
214 
215     constructor() public {
216         name = "Taiwan Digital Token";
217         symbol = "TWDT-ETH";
218         totalSupply = 100000000000*(10**decimals);
219         balanceOf[msg.sender] = totalSupply;	
220     }
221 
222     function balanceOf(address _who) public view returns (uint256 balance) {
223         return balanceOf[_who];
224     }
225 
226     function _transferFrom(address _from, address _to, uint256 _value) internal returns (bool) {
227         require(_from != address(0));
228         require(_to != address(0));
229         // require(balanceOf[_from] >= _value);
230         // require(balanceOf[_to] + _value >= balanceOf[_to]);
231         require(!frozenAccount[_from]);                  
232         require(!frozenAccount[_to]); 
233         require(!frozenAccountSend[_from]);
234         require(!isBlackListed[_from]);
235         if(checkIsKYC(_from, _to)){
236             //Round down.
237             uint256 fee = (((_value.mul(feeRate)).div(10000)).div(10**(decimals))).mul(10**(decimals));
238             if(isWhiteListed[_from] || isWhiteListed[_to]){
239                 fee = 0;
240             }else if(fee != 0){
241                 if (fee > maximumFee) {
242                     fee = maximumFee;
243                 } else if (fee < minimumFee){
244                     fee = minimumFee;
245                 }
246             }
247             
248             //_value must be equal to or larger than minimumFee, otherwise it will fail.
249             uint256 sendAmount = _value.sub(fee);
250             balanceOf[_from] = balanceOf[_from].sub(_value);
251             balanceOf[_to] = balanceOf[_to].add(sendAmount);
252             if (fee > 0) {
253                 balanceOf[feeWallet] = balanceOf[feeWallet].add(fee);
254                 emit Transfer(_from, feeWallet, fee);
255             }
256             emit Transfer(_from, _to, sendAmount);
257             return true;
258         } else {
259             //If not pass KYC, throw the event.
260             emit Error_No_Binding_Address(_from, _to);
261             return false;
262         }
263     }
264 	
265     function transfer(address _to, uint256 _value) public returns (bool){	    
266         return _transferFrom(msg.sender,_to,_value);
267     }
268     function transferLog(address _to, uint256 _value,string logs) public returns (bool){
269         bool _status = _transferFrom(msg.sender,_to,_value);
270         emit Logs(logs);
271         return _status;
272     }
273 	
274     function () public {
275         revert();
276     }
277 
278     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
279         require(_spender != address(0));
280         return allowed[_owner][_spender];
281     }
282 
283     function approve(address _spender, uint256 _value) public returns (bool) {
284         require(_spender != address(0));
285         allowed[msg.sender][_spender] = _value;
286         emit Approval(msg.sender, _spender, _value);
287         return true;
288     }
289 	
290     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
291         require(_from != address(0));
292         require(_to != address(0));
293         require(_value > 0);
294         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
295         // require(allowed[_from][msg.sender] >= _value);
296         // require(balanceOf[_from] >= _value);
297         // require(balanceOf[_to] + _value >= balanceOf[_to]);
298         require(!frozenAccount[_from]);
299         require(!frozenAccount[_to]);
300         require(!frozenAccountSend[_from]);
301         require(!isBlackListed[_from]); 
302         if(checkIsKYC(_from, _to)){
303             //Round down.
304             uint256 fee = (((_value.mul(feeRate)).div(10000)).div(10**(decimals))).mul(10**(decimals));
305             if(isWhiteListed[_from] || isWhiteListed[_to]){
306                 fee = 0;
307             }else if(fee != 0){
308                 if (fee > maximumFee) {
309                     fee = maximumFee;
310                 } else if (fee < minimumFee){
311                     fee = minimumFee;
312                 }
313             }
314             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315             //_value must be equal to or larger than minimumFee, otherwise it will fail.
316             uint256 sendAmount = _value.sub(fee);
317 
318             balanceOf[_from] = balanceOf[_from].sub(_value);
319             balanceOf[_to] = balanceOf[_to].add(sendAmount);
320             if (fee > 0) {
321                 balanceOf[feeWallet] = balanceOf[feeWallet].add(fee);
322                 emit Transfer(_from, feeWallet, fee);
323             }
324             emit Transfer(_from, _to, sendAmount);
325             return true;
326         } else {
327             // If not pass KYC, throw the event.
328             emit Error_No_Binding_Address(_from, _to);
329             return false;
330         }
331     }
332         
333     function freezeAccount(address _target, bool _freeze) onlyOwnerAdmin public {
334         require(_target != address(0));
335         frozenAccount[_target] = _freeze;
336         emit FrozenFunds(_target, _freeze);
337     }
338 
339     function freezeAccountSend(address _target, bool _freeze) onlyOwnerAdmin public {
340         require(_target != address(0));
341         frozenAccountSend[_target] = _freeze;
342         emit FrozenFundsSend(_target, _freeze);
343     }
344 
345     // Transfer of illegal funds.
346     // It can transfer tokens to blackFundsWallet only.
347     function transferBlackFunds(address _blackListedUser) public onlyOwnerAdmin {
348         require(blackFundsWallet != address(0));
349         require(isBlackListed[_blackListedUser]);
350         uint256 dirtyFunds = balanceOf[_blackListedUser];
351         balanceOf[_blackListedUser] = 0;
352         balanceOf[blackFundsWallet] = balanceOf[blackFundsWallet].add(dirtyFunds);
353         emit Transfer(_blackListedUser, blackFundsWallet, dirtyFunds);
354         emit TransferredBlackFunds(_blackListedUser, dirtyFunds);
355     }
356 
357     // Burn tokens when user stops rent.
358     // It can burn tokens from redeemWallet only.
359     function redeem(uint256 amount) public onlyOwnerAdmin {
360         require(redeemWallet != address(0));
361         require(totalSupply >= amount);
362         require(balanceOf[redeemWallet] >= amount);
363 
364         totalSupply = totalSupply.sub(amount);
365         balanceOf[redeemWallet] = balanceOf[redeemWallet].sub(amount);
366         emit Transfer(redeemWallet, address(0), amount);
367         emit Redeem(amount);
368     }
369 
370     // Mint a new amount of tokens.
371     function mintToken(address _target, uint256 _mintedAmount) onlyOwner public {
372         require(_target != address(0));
373         require(_mintedAmount > 0);
374         require(!frozenAccount[_target]);
375         // require(totalSupply + _mintedAmount > totalSupply);
376         // require(balanceOf[_target] + _mintedAmount > balanceOf[_target]);
377         balanceOf[_target] = balanceOf[_target].add(_mintedAmount);
378         totalSupply = totalSupply.add(_mintedAmount);
379         emit Transfer(address(0), this, _mintedAmount);
380         emit Transfer(this, _target, _mintedAmount);
381     }
382 
383     // Set the illegal fund wallet.
384     function setBlackFundsWallet(address _target) onlyOwner public {
385         blackFundsWallet = _target;
386     }
387 
388     // Set the redeem wallet.
389     function setRedeemWallet(address _target) onlyOwner public {
390         redeemWallet = _target;
391     }
392 
393     // Set the fee wallet.
394     function setFeeWallet(address _target) onlyOwner public {
395         feeWallet = _target;
396     }
397 
398     // Set the token transfer fee.
399     // The maximum of feeRate is 0.1%.
400     // The maximum of fee is 100 TWDT.
401     function setFee(uint256 _feeRate, uint256 _minimumFee, uint256 _maximumFee) onlyOwner public {
402         require(_feeRate <= 10);
403         require(_maximumFee <= 100);
404         require(_minimumFee <= _maximumFee);
405 
406         feeRate = _feeRate;
407         minimumFee = _minimumFee.mul(10**decimals);
408         maximumFee = _maximumFee.mul(10**decimals);
409 
410         emit Fee(feeRate, minimumFee, maximumFee);
411     }
412 }