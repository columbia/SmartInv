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
87     /**
88      * Only owner of master wallet can add additional wallet.
89      */
90     function linkToMasterWalletInternal(address _masterWallet, address _linkedWallet) internal {
91         require(_masterWallet != _linkedWallet && _linkedWallet != address(0));
92         require(isMasterWallet(_masterWallet));
93         require(!isLinkedWallet(_linkedWallet) && !isMasterWallet(_linkedWallet));
94         AddressRelations storage rel = masterToSlaves[_masterWallet];
95         require(rel.slaves.values.length < maxLinkedWalletCount);    
96         rel.slaves.values.push(_linkedWallet);
97         rel.slaves.keys[_linkedWallet] = rel.slaves.values.length - 1;
98         slaveToMasterAddress[_linkedWallet] = _masterWallet;
99         WalletLinked(_masterWallet, _linkedWallet);
100     }
101  
102     function unLinkFromMasterWalletInternal(address _masterWallet, address _linkedWallet) internal {
103         require(_masterWallet != _linkedWallet && _linkedWallet != address(0));
104         require(_masterWallet == getMasterWallet(_linkedWallet));
105         SlaveDictionary storage slaves = masterToSlaves[_masterWallet].slaves;
106         uint indexToDelete = slaves.keys[_linkedWallet];
107         address keyToMove = slaves.values[slaves.values.length - 1];
108         slaves.values[indexToDelete] = keyToMove;
109         slaves.keys[keyToMove] = indexToDelete;
110         slaves.values.length--;
111         delete slaves.keys[_linkedWallet];
112         delete slaveToMasterAddress[_linkedWallet];
113         WalletUnlinked(_masterWallet, _linkedWallet);
114     }
115 
116     function getLinkedWallets(address _wallet) public view returns (address[]) {
117         return masterToSlaves[_wallet].slaves.values;
118     }
119 
120     function isMasterWallet(address _addr) internal constant returns (bool) {
121         return masterToSlaves[_addr].hasValue;
122     }
123 
124     function isLinkedWallet(address _addr) internal constant returns (bool) {
125         return slaveToMasterAddress[_addr] != address(0);
126     }
127 
128     /**
129      * Guess that address book already had changing address.
130      */ 
131     function applyChangeWalletAddress(address _old, address _new) internal {
132         require(isMasterWallet(_old) || isLinkedWallet(_old));
133         require(_new != address(0));
134         if (isMasterWallet(_old)) {
135             // Cannt change master address with existed linked
136             require(!isLinkedWallet(_new));
137             require(masterToSlaves[_new].slaves.values.length == 0);
138             changeMasterAddress(_old, _new);
139         }
140         else {
141             // Cannt change linked address with existed master and linked to another master
142             require(!isMasterWallet(_new) && !isLinkedWallet(_new));
143             changeLinkedAddress(_old, _new);
144         }
145     }
146 
147     function changeLinkedAddress(address _old, address _new) private {
148         slaveToMasterAddress[_new] = slaveToMasterAddress[_old];     
149         SlaveDictionary storage slaves = masterToSlaves[slaveToMasterAddress[_new]].slaves;
150         uint index = slaves.keys[_old];
151         slaves.values[index] = _new;
152         delete slaveToMasterAddress[_old];
153     }
154     
155     function changeMasterAddress(address _old, address _new) private {    
156         masterToSlaves[_new] = masterToSlaves[_old];  
157         SlaveDictionary storage slaves = masterToSlaves[_new].slaves;
158         for (uint8 i = 0; i < slaves.values.length; ++i)
159             slaveToMasterAddress[slaves.values[i]] = _new;
160         delete masterToSlaves[_old];
161     }
162 
163     function addMasterWallet(address _master) internal {
164         require(_master != address(0));
165         masterToSlaves[_master].hasValue = true;
166     }
167 
168     function getMasterWallet(address _wallet) internal constant returns(address) {
169         if(isMasterWallet(_wallet))
170             return _wallet;
171         return slaveToMasterAddress[_wallet];  
172     }
173 
174     /**
175      * Try to find master address by any other; otherwise add to address book as master.
176      */
177     function getOrAddMasterWallet(address _wallet) internal returns (address) {
178         address masterWallet = getMasterWallet(_wallet);
179         if (masterWallet == address(0))
180             addMasterWallet(_wallet);
181         return _wallet;
182     }
183 }
184 
185 contract CryptaurDepository is owned, AddressBook {
186     enum UnlimitedMode {UNLIMITED,LIMITED}
187 
188     event Deposit(address indexed _who, uint _amount, bytes32 _txHash);
189     event Withdraw(address indexed _who, uint _amount);
190     event Payment(address indexed _buyer, address indexed _seller, uint _amount, address indexed _opinionLeader, bool _dapp);
191     event Freeze(address indexed _who, bool _freeze);
192     event Share(address indexed _who, address indexed _dapp, uint _amount);
193 
194     ERC20Base cryptaurToken = ERC20Base(0x88d50B466BE55222019D71F9E8fAe17f5f45FCA1);
195     address cryptaurRecovery;
196     address cryptaurRewards;
197     address cryptaurReserveFund;
198     address backend;
199     modifier onlyBackend {
200         require(backend == msg.sender);
201         _;
202     }
203 
204     modifier onlyOwnerOrBackend {
205         require(owner == msg.sender || backend == msg.sender);
206         _;
207     }
208 
209     modifier notFreezed {
210         require(freezedAll != true);
211         _;
212     }
213 
214     mapping(address => uint) internal balances;
215     mapping(address => mapping (address => uint256)) public available;
216     mapping(address => bool) public freezed;
217     mapping(address => mapping(address => UnlimitedMode)) public unlimitedMode;
218     bool freezedAll;
219   
220     function CryptaurDepository() owned() public {}
221 
222     function balanceOf(address _who) constant public returns (uint) {
223         return balances[getMasterWallet(_who)];
224     }
225 
226     function setUnlimitedMode(bool _unlimited, address _dapp) public {
227         address masterWallet = getOrAddMasterWallet(msg.sender);
228         unlimitedMode[masterWallet][_dapp] = _unlimited ? UnlimitedMode.UNLIMITED : UnlimitedMode.LIMITED;
229     }
230 
231     function transferToToken(address[] _addresses) public onlyOwnerOrBackend {
232         for (uint index = 0; index < _addresses.length; index++) {
233             address addr = _addresses[index];
234             uint amount = balances[addr];
235             if (amount > 0) {
236                 balances[addr] = 0;
237                 cryptaurToken.transfer(addr, amount);
238                 Withdraw(addr, amount);
239             }        
240         }
241     }
242 
243     function setBackend(address _backend) onlyOwner public {
244         backend = _backend;
245     }
246 
247     function setCryptaurRecovery(address _cryptaurRecovery) onlyOwner public {
248         cryptaurRecovery = _cryptaurRecovery;
249     }
250 
251     function setCryptaurToken(address _cryptaurToken) onlyOwner public {
252         cryptaurToken = ERC20Base(_cryptaurToken);
253     }
254 
255     function setCryptaurRewards(address _cryptaurRewards) onlyOwner public {
256         cryptaurRewards = _cryptaurRewards;
257     }
258 
259     function setCryptaurReserveFund(address _cryptaurReserveFund) onlyOwner public {
260         cryptaurReserveFund = _cryptaurReserveFund;
261     }
262     
263     function changeAddress(address _old, address _new) public {
264         require(msg.sender == cryptaurRecovery);
265         applyChangeWalletAddress(_old, _new);
266 
267         balances[_new] += balances[_old];
268         balances[_old] = 0;
269         AddressChanged(_old, _new);
270     }
271 
272     function linkToMasterWallet(address _masterWaller, address _linkedWaller) public {
273         require(msg.sender == owner || msg.sender == backend || msg.sender == cryptaurRecovery);
274         linkToMasterWalletInternal(_masterWaller, _linkedWaller);
275     }
276 
277     function unLinkFromMasterWallet(address _masterWaller, address _linkedWaller) public {
278         require(msg.sender == owner || msg.sender == backend || msg.sender == cryptaurRecovery);
279         unLinkFromMasterWalletInternal(_masterWaller, _linkedWaller);
280     }
281 
282     function setMaxLinkedWalletCount(uint8 _newMaxCount) public onlyOwnerOrBackend {
283         maxLinkedWalletCount = _newMaxCount;
284     }
285     
286     function freeze(address _who, bool _freeze) onlyOwner public {
287         address masterWallet = getMasterWallet(_who);
288         if (masterWallet == address(0))
289             masterWallet = _who;
290         freezed[masterWallet] = _freeze;
291         Freeze(masterWallet, _freeze);
292     }
293 
294     function freeze(bool _freeze) public onlyOwnerOrBackend {
295         freezedAll = _freeze;
296     }
297     
298     function deposit(address _who, uint _amount, bytes32 _txHash) onlyBackend public {
299         address masterWallet = getOrAddMasterWallet(_who);
300         balances[masterWallet] += _amount;
301         Deposit(masterWallet, _amount, _txHash);
302     }
303     
304     function withdraw(uint _amount) public notFreezed {
305         address masterWallet = getMasterWallet(msg.sender);   
306         require(balances[masterWallet] >= _amount);
307         require(!freezed[masterWallet]);
308         balances[masterWallet] -= _amount;
309         cryptaurToken.transfer(masterWallet, _amount);
310         Withdraw(masterWallet, _amount);
311     }
312 
313     function balanceOf2(address _who, address _dapp) constant public returns (uint) { 
314         return balanceOf2Internal(getMasterWallet(_who), _dapp);
315     }
316     
317     function balanceOf2Internal(address _who, address _dapp) constant internal returns (uint) {
318         uint avail;
319         if (!freezed[_who]) {
320             if (unlimitedMode[_who][_dapp] == UnlimitedMode.UNLIMITED) {
321                 avail = balances[_who];
322             } 
323             else {
324                 avail = available[_who][_dapp];
325                 if (avail > balances[_who])
326                     avail = balances[_who];
327             }
328         }
329         return avail;
330     }
331     /**
332      * @dev Function pay wrapper. Using only for dapp.
333      */
334     function pay2(address _seller, uint _amount, address _opinionLeader) public notFreezed {
335         address dapp = getOrAddMasterWallet(msg.sender);
336         address seller = getOrAddMasterWallet(_seller);
337         payInternal(dapp, seller, _amount, _opinionLeader);
338         available[seller][dapp] += _amount;
339     }
340 
341     function pay(address _seller, uint _amount, address _opinionLeader) public notFreezed {
342         address buyer = getOrAddMasterWallet(msg.sender);
343         address seller = getOrAddMasterWallet(_seller);
344         payInternal(buyer, seller, _amount, _opinionLeader);
345     }
346     
347     /**
348      * @dev Common internal pay function.
349      * OpinionLeader is optional, can be zero.
350      */
351     function payInternal(address _buyer, address _seller, uint _amount, address _opinionLeader) internal {    
352         require(balances[_buyer] >= _amount);
353         uint fee;
354         if (cryptaurRewards != 0 && cryptaurReserveFund != 0) {
355             fee = CryptaurRewards(cryptaurRewards).payment(_buyer, _seller, _amount, _opinionLeader);
356         }
357         balances[_buyer] -= _amount;
358         balances[_seller] += _amount - fee;
359         if (fee != 0) {
360             balances[cryptaurReserveFund] += fee;
361             CryputarReserveFund(cryptaurReserveFund).depositNotification(_amount);
362         }
363         Payment(_buyer, _seller, _amount, _opinionLeader, false);
364     }
365     
366     function payDAPP(address _buyer, uint _amount, address _opinionLeader) public notFreezed {
367         address buyerMasterWallet = getOrAddMasterWallet(_buyer);
368         require(balanceOf2Internal(buyerMasterWallet, msg.sender) >= _amount);
369         uint fee;
370         if (cryptaurRewards != 0 && cryptaurReserveFund != 0) {
371             fee = CryptaurRewards(cryptaurRewards).payment(buyerMasterWallet, msg.sender, _amount, _opinionLeader);
372         }
373         balances[buyerMasterWallet] -= _amount;
374         balances[msg.sender] += _amount - fee; 
375         if (unlimitedMode[buyerMasterWallet][msg.sender] == UnlimitedMode.LIMITED)
376             available[buyerMasterWallet][msg.sender] -= _amount;
377         if (fee != 0) {
378             balances[cryptaurReserveFund] += fee;
379             CryputarReserveFund(cryptaurReserveFund).depositNotification(_amount);
380         }
381         Payment(buyerMasterWallet, msg.sender, _amount, _opinionLeader, true);
382     }
383 
384     function shareBalance(address _dapp, uint _amount) public notFreezed {
385         address masterWallet = getMasterWallet(msg.sender);
386         require(masterWallet != address(0));
387         available[masterWallet][_dapp] = _amount;
388         Share(masterWallet, _dapp, _amount);
389     }
390     
391     function transferFromFund(address _to, uint _amount) public {
392         require(msg.sender == owner || msg.sender == cryptaurRewards || msg.sender == backend);
393         require(cryptaurReserveFund != address(0));
394         require(balances[cryptaurReserveFund] >= _amount);
395         address masterWallet = getOrAddMasterWallet(_to);
396         balances[masterWallet] += _amount;
397         balances[cryptaurReserveFund] -= _amount;
398         CryputarReserveFund(cryptaurReserveFund).withdrawNotification(_amount);
399     }
400 }
401 
402 // test only
403 contract CryptaurDepositoryTest is CryptaurDepository {
404     function CryptaurDepositoryTest() CryptaurDepository() {}
405 
406     // test only
407     function testDrip(address _who, address _dapp, uint _amount) public {
408         require(msg.sender == owner || msg.sender == backend);
409         address masterWallet = getOrAddMasterWallet(_who);
410         balances[masterWallet] = _amount;
411         available[masterWallet][_dapp] = _amount;
412     }
413 }