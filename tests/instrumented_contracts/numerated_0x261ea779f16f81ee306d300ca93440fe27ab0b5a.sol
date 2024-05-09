1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Withdrawable is Ownable {
107     event ReceiveEther(address _from, uint256 _value);
108     event WithdrawEther(address _to, uint256 _value);
109     event WithdrawToken(address _token, address _to, uint256 _value);
110 
111     /**
112          * @dev recording receiving ether from msn.sender
113          */
114     function () payable public {
115         emit ReceiveEther(msg.sender, msg.value);
116     }
117 
118     /**
119          * @dev withdraw,send ether to target
120          * @param _to is where the ether will be sent to
121          *        _amount is the number of the ether
122          */
123     function withdraw(address _to, uint _amount) public onlyOwner returns (bool) {
124         require(_to != address(0));
125         _to.transfer(_amount);
126         emit WithdrawEther(_to, _amount);
127 
128         return true;
129     }
130 
131     /**
132          * @dev withdraw tokens, send tokens to target
133      *
134      * @param _token the token address that will be withdraw
135          * @param _to is where the tokens will be sent to
136          *        _value is the number of the token
137          */
138     function withdrawToken(address _token, address _to, uint256 _value) public onlyOwner returns (bool) {
139         require(_to != address(0));
140         require(_token != address(0));
141 
142         ERC20 tk = ERC20(_token);
143         tk.transfer(_to, _value);
144         emit WithdrawToken(_token, _to, _value);
145 
146         return true;
147     }
148 
149     /**
150      * @dev receive approval from an ERC20 token contract, and then gain the tokens,
151      *      then take a record
152      *
153      * @param _from address The address which you want to send tokens from
154      * @param _value uint256 the amounts of tokens to be sent
155      * @param _token address the ERC20 token address
156      * @param _extraData bytes the extra data for the record
157      */
158     // function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
159     //     require(_token != address(0));
160     //     require(_from != address(0));
161 
162     //     ERC20 tk = ERC20(_token);
163     //     require(tk.transferFrom(_from, this, _value));
164 
165     //     emit ReceiveDeposit(_from, _value, _token, _extraData);
166     // }
167 }
168 
169 contract Claimable is Ownable {
170   address public pendingOwner;
171 
172   /**
173    * @dev Modifier throws if called by any account other than the pendingOwner.
174    */
175   modifier onlyPendingOwner() {
176     require(msg.sender == pendingOwner);
177     _;
178   }
179 
180   /**
181    * @dev Allows the current owner to set the pendingOwner address.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) public onlyOwner {
185     pendingOwner = newOwner;
186   }
187 
188   /**
189    * @dev Allows the pendingOwner address to finalize the transfer.
190    */
191   function claimOwnership() public onlyPendingOwner {
192     emit OwnershipTransferred(owner, pendingOwner);
193     owner = pendingOwner;
194     pendingOwner = address(0);
195   }
196 }
197 
198 contract DRCWalletStorage is Withdrawable, Claimable {
199     using SafeMath for uint256;
200 
201     /**
202      * withdraw wallet description
203      */
204     struct WithdrawWallet {
205         bytes32 name;
206         address walletAddr;
207     }
208 
209     /**
210      * Deposit data storage
211      */
212     struct DepositRepository {
213         int256 balance; // can be negative
214         uint256 frozen;
215         WithdrawWallet[] withdrawWallets;
216         // mapping (bytes32 => address) withdrawWallets;
217     }
218 
219     mapping (address => DepositRepository) depositRepos;
220     mapping (address => address) public walletDeposits;
221     mapping (address => bool) public frozenDeposits;
222     address[] depositAddresses;
223     uint256 public size;
224 
225 
226     /**
227          * @dev add deposit contract address for the default withdraw wallet
228      *
229      * @param _wallet the default withdraw wallet address
230      * @param _depositAddr the corresponding deposit address to the default wallet
231          */
232     function addDeposit(address _wallet, address _depositAddr) onlyOwner public returns (bool) {
233         require(_wallet != address(0));
234         require(_depositAddr != address(0));
235 
236         walletDeposits[_wallet] = _depositAddr;
237         WithdrawWallet[] storage withdrawWalletList = depositRepos[_depositAddr].withdrawWallets;
238         withdrawWalletList.push(WithdrawWallet("default wallet", _wallet));
239         depositRepos[_depositAddr].balance = 0;
240         depositRepos[_depositAddr].frozen = 0;
241         depositAddresses.push(_depositAddr);
242 
243         size = size.add(1);
244         return true;
245     }
246 
247     /**
248      * @dev remove an address from the deposit address list
249      *
250      * @param _deposit the deposit address in the list
251      */
252     function removeDepositAddress(address _deposit) internal returns (bool) {
253         uint i = 0;
254         for (;i < depositAddresses.length; i = i.add(1)) {
255             if (depositAddresses[i] == _deposit) {
256                 break;
257             }
258         }
259 
260         if (i >= depositAddresses.length) {
261             return false;
262         }
263 
264         while (i < depositAddresses.length.sub(1)) {
265             depositAddresses[i] = depositAddresses[i.add(1)];
266             i = i.add(1);
267         }
268 
269         delete depositAddresses[depositAddresses.length.sub(1)];
270         depositAddresses.length = depositAddresses.length.sub(1);
271         return true;
272     }
273 
274     /**
275          * @dev remove deposit contract address from storage
276      *
277      * @param _depositAddr the corresponding deposit address
278          */
279     function removeDeposit(address _depositAddr) onlyOwner public returns (bool) {
280         require(isExisted(_depositAddr));
281 
282         WithdrawWallet memory withdraw = depositRepos[_depositAddr].withdrawWallets[0];
283         delete walletDeposits[withdraw.walletAddr];
284         delete depositRepos[_depositAddr];
285         delete frozenDeposits[_depositAddr];
286         removeDepositAddress(_depositAddr);
287 
288         size = size.sub(1);
289         return true;
290     }
291 
292     /**
293          * @dev add withdraw address for one deposit addresss
294      *
295      * @param _deposit the corresponding deposit address
296      * @param _name the new withdraw wallet name
297      * @param _withdraw the new withdraw wallet address
298          */
299     function addWithdraw(address _deposit, bytes32 _name, address _withdraw) onlyOwner public returns (bool) {
300         require(_deposit != address(0));
301 
302         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
303         withdrawWalletList.push(WithdrawWallet(_name, _withdraw));
304         return true;
305     }
306 
307     /**
308          * @dev increase balance of this deposit address
309      *
310      * @param _deposit the corresponding deposit address
311      * @param _value the amount that the balance will be increased
312          */
313     function increaseBalance(address _deposit, uint256 _value) onlyOwner public returns (bool) {
314         // require(_deposit != address(0));
315         require (walletsNumber(_deposit) > 0);
316         int256 _balance = depositRepos[_deposit].balance;
317         depositRepos[_deposit].balance = _balance + int256(_value);
318         return true;
319     }
320 
321     /**
322          * @dev decrease balance of this deposit address
323      *
324      * @param _deposit the corresponding deposit address
325      * @param _value the amount that the balance will be decreased
326          */
327     function decreaseBalance(address _deposit, uint256 _value) onlyOwner public returns (bool) {
328         // require(_deposit != address(0));
329         require (walletsNumber(_deposit) > 0);
330         int256 _balance = depositRepos[_deposit].balance;
331         depositRepos[_deposit].balance = _balance - int256(_value);
332         return true;
333     }
334 
335     /**
336          * @dev change the default withdraw wallet address binding to the deposit contract address
337      *
338      * @param _oldWallet the old default withdraw wallet
339      * @param _newWallet the new default withdraw wallet
340          */
341     function changeDefaultWallet(address _oldWallet, address _newWallet) onlyOwner public returns (bool) {
342         require(_oldWallet != address(0));
343         require(_newWallet != address(0));
344 
345         address _deposit = walletDeposits[_oldWallet];
346         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
347         withdrawWalletList[0].walletAddr = _newWallet;
348         // emit ChangeDefaultWallet(_oldWallet, _newWallet);
349         walletDeposits[_newWallet] = _deposit;
350         delete walletDeposits[_oldWallet];
351 
352         return true;
353     }
354 
355     /**
356          * @dev change the name of the withdraw wallet address of the deposit contract address
357      *
358      * @param _deposit the deposit address
359      * @param _newName the wallet name
360      * @param _wallet the withdraw wallet
361          */
362     function changeWalletName(address _deposit, bytes32 _newName, address _wallet) onlyOwner public returns (bool) {
363         require(_deposit != address(0));
364         require(_wallet != address(0));
365 
366         uint len = walletsNumber(_deposit);
367         // default wallet name do not change
368         for (uint i = 1; i < len; i = i.add(1)) {
369             WithdrawWallet storage wallet = depositRepos[_deposit].withdrawWallets[i];
370             if (_wallet == wallet.walletAddr) {
371                 wallet.name = _newName;
372                 return true;
373             }
374         }
375 
376         return false;
377     }
378 
379     /**
380          * @dev freeze the tokens in the deposit address
381      *
382      * @param _deposit the deposit address
383      * @param _freeze to freeze or release
384      * @param _value the amount of tokens need to be frozen
385          */
386     function freezeTokens(address _deposit, bool _freeze, uint256 _value) onlyOwner public returns (bool) {
387         require(_deposit != address(0));
388         // require(_value <= balanceOf(_deposit));
389 
390         frozenDeposits[_deposit] = _freeze;
391         uint256 _frozen = depositRepos[_deposit].frozen;
392         int256 _balance = depositRepos[_deposit].balance;
393         int256 freezeAble = _balance - int256(_frozen);
394         freezeAble = freezeAble < 0 ? 0 : freezeAble;
395         if (_freeze) {
396             if (_value > uint256(freezeAble)) {
397                 _value = uint256(freezeAble);
398             }
399             depositRepos[_deposit].frozen = _frozen.add(_value);
400         } else {
401             if (_value > _frozen) {
402                 _value = _frozen;
403             }
404             depositRepos[_deposit].frozen = _frozen.sub(_value);
405         }
406 
407         return true;
408     }
409 
410     /**
411          * @dev get the wallet address for the deposit address
412      *
413      * @param _deposit the deposit address
414      * @param _ind the wallet index in the list
415          */
416     function wallet(address _deposit, uint256 _ind) public view returns (address) {
417         require(_deposit != address(0));
418 
419         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
420         return withdrawWalletList[_ind].walletAddr;
421     }
422 
423     /**
424          * @dev get the wallet name for the deposit address
425      *
426      * @param _deposit the deposit address
427      * @param _ind the wallet index in the list
428          */
429     function walletName(address _deposit, uint256 _ind) public view returns (bytes32) {
430         require(_deposit != address(0));
431 
432         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
433         return withdrawWalletList[_ind].name;
434     }
435 
436     /**
437          * @dev get the wallet name for the deposit address
438      *
439      * @param _deposit the deposit address
440          */
441     function walletsNumber(address _deposit) public view returns (uint256) {
442         require(_deposit != address(0));
443 
444         WithdrawWallet[] storage withdrawWalletList = depositRepos[_deposit].withdrawWallets;
445         return withdrawWalletList.length;
446     }
447 
448     /**
449          * @dev get the balance of the deposit account
450      *
451      * @param _deposit the wallet address
452          */
453     function isExisted(address _deposit) public view returns (bool) {
454         return (walletsNumber(_deposit) > 0);
455     }
456 
457     /**
458          * @dev get the balance of the deposit account
459      *
460      * @param _deposit the deposit address
461          */
462     function balanceOf(address _deposit) public view returns (int256) {
463         require(_deposit != address(0));
464         return depositRepos[_deposit].balance;
465     }
466 
467     /**
468          * @dev get the frozen amount of the deposit address
469      *
470      * @param _deposit the deposit address
471          */
472     function frozenAmount(address _deposit) public view returns (uint256) {
473         require(_deposit != address(0));
474         return depositRepos[_deposit].frozen;
475     }
476 
477     /**
478          * @dev get the deposit address by index
479      *
480      * @param _ind the deposit address index
481          */
482     function depositAddressByIndex(uint256 _ind) public view returns (address) {
483         return depositAddresses[_ind];
484     }
485 }
486 
487 contract ERC20Basic {
488   function totalSupply() public view returns (uint256);
489   function balanceOf(address _who) public view returns (uint256);
490   function transfer(address _to, uint256 _value) public returns (bool);
491   event Transfer(address indexed from, address indexed to, uint256 value);
492 }
493 
494 contract ERC20 is ERC20Basic {
495   function allowance(address _owner, address _spender)
496     public view returns (uint256);
497 
498   function transferFrom(address _from, address _to, uint256 _value)
499     public returns (bool);
500 
501   function approve(address _spender, uint256 _value) public returns (bool);
502   event Approval(
503     address indexed owner,
504     address indexed spender,
505     uint256 value
506   );
507 }