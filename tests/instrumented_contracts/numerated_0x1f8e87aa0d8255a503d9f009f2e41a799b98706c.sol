1 /*
2 This file is part of the Cryptaur Contract.
3 
4 The CryptaurToken Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version. See the GNU lesser General Public License
8 for more details.
9 
10 You should have received a copy of the GNU lesser General Public License
11 along with the CryptaurToken Contract. If not, see <http://www.gnu.org/licenses/>.
12 
13 @author Ilya Svirin <i.svirin@nordavind.ru>
14 Donation address 0x3Ad38D1060d1c350aF29685B2b8Ec3eDE527452B
15 */
16 
17 pragma solidity ^0.4.19;
18 
19 contract owned {
20 
21     address public owner;
22     address public candidate;
23 
24     function owned() payable public {
25         owner = msg.sender;
26     }
27     
28     modifier onlyOwner {
29         require(owner == msg.sender);
30         _;
31     }
32 
33     function changeOwner(address _owner) onlyOwner public {
34         candidate = _owner;
35     }
36     
37     function confirmOwner() public {
38         require(candidate == msg.sender);
39         owner = candidate;
40         delete candidate;
41     }
42 }
43 
44 /**
45  * @title Part of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 contract ERC20Base {
49     uint public totalSupply;
50     function balanceOf(address who) public constant returns (uint);
51     function transfer(address to, uint value) public;
52 }
53 
54 contract CryptaurRewards {
55     function payment(address _buyer, address _seller, uint _amount, address _opinionLeader) public returns(uint fee);
56 }
57 
58 contract CryputarReserveFund {
59     function depositNotification(uint _amount) public;
60     function withdrawNotification(uint _amount) public;
61 }
62 
63 /**
64  * @title Allows to store liked adsress(slave address) connected to the main address (master address)
65  */
66 contract AddressBook {
67 
68     struct AddressRelations {
69         SlaveDictionary slaves;
70         bool hasValue;
71     }
72 
73     struct SlaveDictionary
74     {
75         address[] values;
76         mapping(address => uint) keys;
77     }
78 
79     event WalletLinked(address indexed _master, address indexed _slave);
80     event WalletUnlinked(address indexed _master, address indexed _slave);
81     event AddressChanged(address indexed _old, address indexed _new);
82 
83     mapping(address => AddressRelations) private masterToSlaves;
84     mapping(address => address) private slaveToMasterAddress;
85     uint8 public maxLinkedWalletCount = 5;
86 
87     function AddressBook() public {}
88 
89     function getLinkedWallets(address _wallet) public view returns (address[]) {
90         return masterToSlaves[_wallet].slaves.values;
91     }
92 
93     /**
94      * Only owner of master wallet can add additional wallet.
95      */
96     function linkToMasterWalletInternal(address _masterWallet, address _linkedWallet) internal {
97         require(_masterWallet != _linkedWallet && _linkedWallet != address(0));
98         require(isMasterWallet(_masterWallet));
99         require(!isLinkedWallet(_linkedWallet) && !isMasterWallet(_linkedWallet));
100         AddressRelations storage rel = masterToSlaves[_masterWallet];
101         require(rel.slaves.values.length < maxLinkedWalletCount);    
102         rel.slaves.values.push(_linkedWallet);
103         rel.slaves.keys[_linkedWallet] = rel.slaves.values.length - 1;
104         slaveToMasterAddress[_linkedWallet] = _masterWallet;
105         WalletLinked(_masterWallet, _linkedWallet);
106     }
107  
108     function unLinkFromMasterWalletInternal(address _masterWallet, address _linkedWallet) internal {
109         require(_masterWallet != _linkedWallet && _linkedWallet != address(0));
110         require(_masterWallet == getMasterWallet(_linkedWallet));
111         SlaveDictionary storage slaves = masterToSlaves[_masterWallet].slaves;
112         uint indexToDelete = slaves.keys[_linkedWallet];
113         address keyToMove = slaves.values[slaves.values.length - 1];
114         slaves.values[indexToDelete] = keyToMove;
115         slaves.keys[keyToMove] = indexToDelete;
116         slaves.values.length--;
117         delete slaves.keys[_linkedWallet];
118         delete slaveToMasterAddress[_linkedWallet];
119         WalletUnlinked(_masterWallet, _linkedWallet);
120     }
121 
122     function isMasterWallet(address _addr) internal constant returns (bool) {
123         return masterToSlaves[_addr].hasValue;
124     }
125 
126     function isLinkedWallet(address _addr) internal constant returns (bool) {
127         return slaveToMasterAddress[_addr] != address(0);
128     }
129 
130     /**
131      * Guess that address book already had changing address.
132      */ 
133     function applyChangeWalletAddress(address _old, address _new) internal {
134         require(isMasterWallet(_old) || isLinkedWallet(_old));
135         require(_new != address(0));
136         if (isMasterWallet(_old)) {
137             // Cannt change master address with existed linked
138             require(!isLinkedWallet(_new));
139             require(masterToSlaves[_new].slaves.values.length == 0);
140             changeMasterAddress(_old, _new);
141         }
142         else {
143             // Cannt change linked address with existed master and linked to another master
144             require(!isMasterWallet(_new) && !isLinkedWallet(_new));
145             changeLinkedAddress(_old, _new);
146         }
147     }
148 
149     function addMasterWallet(address _master) internal {
150         require(_master != address(0));
151         masterToSlaves[_master].hasValue = true;
152     }
153 
154     function getMasterWallet(address _wallet) internal constant returns(address) {
155         if(isMasterWallet(_wallet))
156             return _wallet;
157         return slaveToMasterAddress[_wallet];  
158     }
159 
160     /**
161      * Try to find master address by any other; otherwise add to address book as master.
162      */
163     function getOrAddMasterWallet(address _wallet) internal returns (address) {
164         address masterWallet = getMasterWallet(_wallet);
165         if (masterWallet == address(0))
166             addMasterWallet(_wallet);
167         return _wallet;
168     }
169 
170     function changeLinkedAddress(address _old, address _new) internal {
171         slaveToMasterAddress[_new] = slaveToMasterAddress[_old];     
172         SlaveDictionary storage slaves = masterToSlaves[slaveToMasterAddress[_new]].slaves;
173         uint index = slaves.keys[_old];
174         slaves.values[index] = _new;
175         delete slaveToMasterAddress[_old];
176     }
177     
178     function changeMasterAddress(address _old, address _new) internal {    
179         masterToSlaves[_new] = masterToSlaves[_old];  
180         SlaveDictionary storage slaves = masterToSlaves[_new].slaves;
181         for (uint8 i = 0; i < slaves.values.length; ++i)
182             slaveToMasterAddress[slaves.values[i]] = _new;
183         delete masterToSlaves[_old];
184     }
185 }
186 
187 contract CryptaurDepository is owned, AddressBook {
188     enum UnlimitedMode {UNLIMITED, LIMITED}
189 
190     event Deposit(address indexed _who, uint _amount, bytes32 _txHash);
191     event Withdraw(address indexed _who, uint _amount);
192     event Payment(address indexed _buyer, address indexed _seller, uint _amount, address indexed _opinionLeader, bool _dapp);
193     event Freeze(address indexed _who, bool _freeze);
194     event Share(address indexed _who, address indexed _dapp, uint _amount);
195     event SetUnlimited(bool _unlimited, address indexed _dapp);
196 
197     ERC20Base cryptaurToken = ERC20Base(0x88d50B466BE55222019D71F9E8fAe17f5f45FCA1);
198     address public cryptaurRecovery;
199     address public cryptaurRewards;
200     address public cryptaurReserveFund;
201     address public backend;
202     modifier onlyBackend {
203         require(backend == msg.sender);
204         _;
205     }
206 
207     modifier onlyOwnerOrBackend {
208         require(owner == msg.sender || backend == msg.sender);
209         _;
210     }
211 
212     modifier notFreezed {
213         require(!freezedAll && !freezed[msg.sender]);
214         _;
215     }
216 
217     mapping(address => uint) internal balances;
218     mapping(address => mapping (address => uint256)) public available;
219     mapping(address => bool) public freezed;
220     mapping(address => mapping(address => UnlimitedMode)) public unlimitedMode;
221     bool freezedAll;
222   
223     function CryptaurDepository() owned() public {}
224 
225     function sub(uint _a, uint _b) internal pure returns (uint) {
226         assert(_b <= _a);
227         return _a - _b;
228     }
229 
230     function add(uint _a, uint _b) internal pure returns (uint) {
231         uint c = _a + _b;
232         assert(c >= _a);
233         return c;
234     }
235 
236     function balanceOf(address _who) constant public returns (uint) {
237         return balances[getMasterWallet(_who)];
238     }
239 
240     function setUnlimitedMode(bool _unlimited, address _dapp) public {
241         address masterWallet = getOrAddMasterWallet(msg.sender);
242         unlimitedMode[masterWallet][_dapp] = _unlimited ? UnlimitedMode.UNLIMITED : UnlimitedMode.LIMITED;
243         SetUnlimited(_unlimited, _dapp);
244     }
245 
246     function transferToToken(address[] _addresses) public onlyOwnerOrBackend {
247         for (uint index = 0; index < _addresses.length; index++) {
248             address addr = _addresses[index];
249             uint amount = balances[addr];
250             if (amount > 0) {
251                 balances[addr] = 0;
252                 cryptaurToken.transfer(addr, amount);
253                 Withdraw(addr, amount);
254             }        
255         }
256     }
257 
258     function setBackend(address _backend) onlyOwner public {
259         backend = _backend;
260     }
261 
262     function setCryptaurRecovery(address _cryptaurRecovery) onlyOwner public {
263         cryptaurRecovery = _cryptaurRecovery;
264     }
265 
266     function setCryptaurToken(address _cryptaurToken) onlyOwner public {
267         cryptaurToken = ERC20Base(_cryptaurToken);
268     }
269 
270     function setCryptaurRewards(address _cryptaurRewards) onlyOwner public {
271         cryptaurRewards = _cryptaurRewards;
272     }
273 
274     function setCryptaurReserveFund(address _cryptaurReserveFund) onlyOwner public {
275         cryptaurReserveFund = _cryptaurReserveFund;
276     }
277     
278     function changeAddress(address _old, address _new) public {
279         require(msg.sender == cryptaurRecovery);
280         applyChangeWalletAddress(_old, _new);
281         balances[_new] = add(balances[_new], balances[_old]);
282         balances[_old] = 0;
283         AddressChanged(_old, _new);
284     }
285 
286     function linkToMasterWallet(address _linkedWallet) public {
287         linkToMasterWalletInternal(msg.sender, _linkedWallet);
288     }
289 
290     function unLinkFromMasterWallet(address _linkedWallet) public {
291         unLinkFromMasterWalletInternal(msg.sender, _linkedWallet);
292     }
293 
294     function linkToMasterWallet(address _masterWallet, address _linkedWallet) onlyOwnerOrBackend public {
295         linkToMasterWalletInternal(_masterWallet, _linkedWallet);
296     }
297 
298     function unLinkFromMasterWallet(address _masterWallet, address _linkedWallet) onlyOwnerOrBackend public {
299         unLinkFromMasterWalletInternal(_masterWallet, _linkedWallet);
300     }
301 
302     function setMaxLinkedWalletCount(uint8 _newMaxCount) public onlyOwnerOrBackend {
303         maxLinkedWalletCount = _newMaxCount;
304     }
305     
306     function freeze(address _who, bool _freeze) onlyOwner public {
307         address masterWallet = getMasterWallet(_who);
308         if (masterWallet == address(0))
309             masterWallet = _who;
310         freezed[masterWallet] = _freeze;
311         Freeze(masterWallet, _freeze);
312     }
313 
314     function freeze(bool _freeze) public onlyOwnerOrBackend {
315         freezedAll = _freeze;
316     }
317     
318     function deposit(address _who, uint _amount, bytes32 _txHash) notFreezed onlyBackend public {
319         address masterWallet = getOrAddMasterWallet(_who);
320         require(!freezed[masterWallet]);
321         balances[masterWallet] = add(balances[masterWallet], _amount);
322         Deposit(masterWallet, _amount, _txHash);
323     }
324     
325     function withdraw(uint _amount) public notFreezed {
326         address masterWallet = getMasterWallet(msg.sender);   
327         require(balances[masterWallet] >= _amount);
328         require(!freezed[masterWallet]);
329         balances[masterWallet] = sub(balances[masterWallet], _amount);
330         cryptaurToken.transfer(masterWallet, _amount);
331         Withdraw(masterWallet, _amount);
332     }
333 
334     function balanceOf2(address _who, address _dapp) constant public returns (uint) { 
335         return balanceOf2Internal(getMasterWallet(_who), _dapp);
336     }
337     
338     function balanceOf2Internal(address _who, address _dapp) constant internal returns (uint) {
339         uint avail;
340         if (!freezed[_who]) {
341             if (unlimitedMode[_who][_dapp] == UnlimitedMode.UNLIMITED) {
342                 avail = balances[_who];
343             } 
344             else {
345                 avail = available[_who][_dapp];
346                 if (avail > balances[_who])
347                     avail = balances[_who];
348             }
349         }
350         return avail;
351     }
352     /**
353      * @dev Function pay wrapper auto share balance.
354      * When dapp pay to the client, increase its balance at first. Then share "_amount"
355      * of client balance to dapp for the further purchases.
356      * 
357      * Only dapp wallet should use this function.
358      */
359     function pay2(address _seller, uint _amount, address _opinionLeader) public notFreezed {
360         address dapp = getOrAddMasterWallet(msg.sender);
361         address seller = getOrAddMasterWallet(_seller);
362         require(!freezed[dapp] && !freezed[seller]);
363         payInternal(dapp, seller, _amount, _opinionLeader);
364         available[seller][dapp] = add(available[seller][dapp], _amount);
365     }
366 
367     function pay(address _seller, uint _amount, address _opinionLeader) public notFreezed {
368         address buyer = getOrAddMasterWallet(msg.sender);
369         address seller = getOrAddMasterWallet(_seller);
370         require(!freezed[buyer] && !freezed[seller]);
371         payInternal(buyer, seller, _amount, _opinionLeader);
372     }
373     
374     /**
375      * @dev Common internal pay function.
376      * OpinionLeader is optional, can be zero.
377      */
378     function payInternal(address _buyer, address _seller, uint _amount, address _opinionLeader) internal {    
379         require(balances[_buyer] >= _amount);
380         uint fee;
381         if (cryptaurRewards != 0 && cryptaurReserveFund != 0) {
382             fee = CryptaurRewards(cryptaurRewards).payment(_buyer, _seller, _amount, _opinionLeader);
383         }
384         balances[_buyer] = sub(balances[_buyer], _amount);
385         balances[_seller] = add(balances[_seller], _amount - fee);
386         if (fee != 0) {
387             balances[cryptaurReserveFund] = add(balances[cryptaurReserveFund], fee);
388             CryputarReserveFund(cryptaurReserveFund).depositNotification(_amount);
389         }
390         Payment(_buyer, _seller, _amount, _opinionLeader, false);
391     }
392     
393     function payDAPP(address _buyer, uint _amount, address _opinionLeader) public notFreezed {
394         address buyerMasterWallet = getOrAddMasterWallet(_buyer);
395         require(balanceOf2Internal(buyerMasterWallet, msg.sender) >= _amount);
396         require(!freezed[buyerMasterWallet]);
397         uint fee;
398         if (cryptaurRewards != 0 && cryptaurReserveFund != 0) {
399             fee = CryptaurRewards(cryptaurRewards).payment(buyerMasterWallet, msg.sender, _amount, _opinionLeader);
400         }
401         balances[buyerMasterWallet] = sub(balances[buyerMasterWallet], _amount);
402         balances[msg.sender] = add(balances[msg.sender], _amount - fee);
403 
404         if (unlimitedMode[buyerMasterWallet][msg.sender] == UnlimitedMode.LIMITED)
405             available[buyerMasterWallet][msg.sender] -= _amount;
406         if (fee != 0) {
407             balances[cryptaurReserveFund] += fee;
408             CryputarReserveFund(cryptaurReserveFund).depositNotification(_amount);
409         }
410         Payment(buyerMasterWallet, msg.sender, _amount, _opinionLeader, true);
411     }
412 
413     function shareBalance(address _dapp, uint _amount) public notFreezed {
414         address masterWallet = getMasterWallet(msg.sender);
415         require(masterWallet != address(0));
416         require(!freezed[masterWallet]);
417         available[masterWallet][_dapp] = _amount;
418         Share(masterWallet, _dapp, _amount);
419     }
420     
421     function transferFromFund(address _to, uint _amount) public {
422         require(msg.sender == owner || msg.sender == cryptaurRewards || msg.sender == backend);
423         require(cryptaurReserveFund != address(0));
424         require(balances[cryptaurReserveFund] >= _amount);
425         address masterWallet = getOrAddMasterWallet(_to);
426         balances[masterWallet] = add(balances[masterWallet], _amount);
427         balances[cryptaurReserveFund] = sub(balances[cryptaurReserveFund], _amount);
428         CryputarReserveFund(cryptaurReserveFund).withdrawNotification(_amount);
429     }
430 }