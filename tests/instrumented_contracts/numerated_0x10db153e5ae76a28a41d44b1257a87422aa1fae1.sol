1 pragma solidity ^0.4.24;
2 
3 contract Enum {
4     enum Operation {
5         Call,
6         DelegateCall,
7         Create
8     }
9 }
10 
11 contract EtherPaymentFallback {
12 
13     /// @dev Fallback function accepts Ether transactions.
14     function ()
15         external
16         payable
17     {
18 
19     }
20 }
21 
22 contract Executor is EtherPaymentFallback {
23 
24     event ContractCreation(address newContract);
25 
26     function execute(address to, uint256 value, bytes data, Enum.Operation operation, uint256 txGas)
27         internal
28         returns (bool success)
29     {
30         if (operation == Enum.Operation.Call)
31             success = executeCall(to, value, data, txGas);
32         else if (operation == Enum.Operation.DelegateCall)
33             success = executeDelegateCall(to, data, txGas);
34         else {
35             address newContract = executeCreate(data);
36             success = newContract != 0;
37             emit ContractCreation(newContract);
38         }
39     }
40 
41     function executeCall(address to, uint256 value, bytes data, uint256 txGas)
42         internal
43         returns (bool success)
44     {
45         // solium-disable-next-line security/no-inline-assembly
46         assembly {
47             success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
48         }
49     }
50 
51     function executeDelegateCall(address to, bytes data, uint256 txGas)
52         internal
53         returns (bool success)
54     {
55         // solium-disable-next-line security/no-inline-assembly
56         assembly {
57             success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
58         }
59     }
60 
61     function executeCreate(bytes data)
62         internal
63         returns (address newContract)
64     {
65         // solium-disable-next-line security/no-inline-assembly
66         assembly {
67             newContract := create(0, add(data, 0x20), mload(data))
68         }
69     }
70 }
71 
72 contract SelfAuthorized {
73     modifier authorized() {
74         require(msg.sender == address(this), "Method can only be called from this contract");
75         _;
76     }
77 }
78 
79 contract ModuleManager is SelfAuthorized, Executor {
80 
81     event EnabledModule(Module module);
82     event DisabledModule(Module module);
83 
84     address public constant SENTINEL_MODULES = address(0x1);
85 
86     mapping (address => address) internal modules;
87     
88     function setupModules(address to, bytes data)
89         internal
90     {
91         require(modules[SENTINEL_MODULES] == 0, "Modules have already been initialized");
92         modules[SENTINEL_MODULES] = SENTINEL_MODULES;
93         if (to != 0)
94             // Setup has to complete successfully or transaction fails.
95             require(executeDelegateCall(to, data, gasleft()), "Could not finish initialization");
96     }
97 
98     /// @dev Allows to add a module to the whitelist.
99     ///      This can only be done via a Safe transaction.
100     /// @param module Module to be whitelisted.
101     function enableModule(Module module)
102         public
103         authorized
104     {
105         // Module address cannot be null or sentinel.
106         require(address(module) != 0 && address(module) != SENTINEL_MODULES, "Invalid module address provided");
107         // Module cannot be added twice.
108         require(modules[module] == 0, "Module has already been added");
109         modules[module] = modules[SENTINEL_MODULES];
110         modules[SENTINEL_MODULES] = module;
111         emit EnabledModule(module);
112     }
113 
114     /// @dev Allows to remove a module from the whitelist.
115     ///      This can only be done via a Safe transaction.
116     /// @param prevModule Module that pointed to the module to be removed in the linked list
117     /// @param module Module to be removed.
118     function disableModule(Module prevModule, Module module)
119         public
120         authorized
121     {
122         // Validate module address and check that it corresponds to module index.
123         require(address(module) != 0 && address(module) != SENTINEL_MODULES, "Invalid module address provided");
124         require(modules[prevModule] == address(module), "Invalid prevModule, module pair provided");
125         modules[prevModule] = modules[module];
126         modules[module] = 0;
127         emit DisabledModule(module);
128     }
129 
130     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
131     /// @param to Destination address of module transaction.
132     /// @param value Ether value of module transaction.
133     /// @param data Data payload of module transaction.
134     /// @param operation Operation type of module transaction.
135     function execTransactionFromModule(address to, uint256 value, bytes data, Enum.Operation operation)
136         public
137         returns (bool success)
138     {
139         // Only whitelisted modules are allowed.
140         require(modules[msg.sender] != 0, "Method can only be called from an enabled module");
141         // Execute transaction without further confirmations.
142         success = execute(to, value, data, operation, gasleft());
143     }
144 
145     /// @dev Returns array of modules.
146     /// @return Array of modules.
147     function getModules()
148         public
149         view
150         returns (address[])
151     {
152         // Calculate module count
153         uint256 moduleCount = 0;
154         address currentModule = modules[SENTINEL_MODULES];
155         while(currentModule != SENTINEL_MODULES) {
156             currentModule = modules[currentModule];
157             moduleCount ++;
158         }
159         address[] memory array = new address[](moduleCount);
160 
161         // populate return array
162         moduleCount = 0;
163         currentModule = modules[SENTINEL_MODULES];
164         while(currentModule != SENTINEL_MODULES) {
165             array[moduleCount] = currentModule;
166             currentModule = modules[currentModule];
167             moduleCount ++;
168         }
169         return array;
170     }
171 }
172 
173 contract OwnerManager is SelfAuthorized {
174 
175     event AddedOwner(address owner);
176     event RemovedOwner(address owner);
177     event ChangedThreshold(uint256 threshold);
178 
179     address public constant SENTINEL_OWNERS = address(0x1);
180 
181     mapping(address => address) internal owners;
182     uint256 ownerCount;
183     uint256 internal threshold;
184 
185     /// @dev Setup function sets initial storage of contract.
186     /// @param _owners List of Safe owners.
187     /// @param _threshold Number of required confirmations for a Safe transaction.
188     function setupOwners(address[] _owners, uint256 _threshold)
189         internal
190     {
191         // Threshold can only be 0 at initialization.
192         // Check ensures that setup function can only be called once.
193         require(threshold == 0, "Owners have already been setup");
194         // Validate that threshold is smaller than number of added owners.
195         require(_threshold <= _owners.length, "Threshold cannot exceed owner count");
196         // There has to be at least one Safe owner.
197         require(_threshold >= 1, "Threshold needs to be greater than 0");
198         // Initializing Safe owners.
199         address currentOwner = SENTINEL_OWNERS;
200         for (uint256 i = 0; i < _owners.length; i++) {
201             // Owner address cannot be null.
202             address owner = _owners[i];
203             require(owner != 0 && owner != SENTINEL_OWNERS, "Invalid owner address provided");
204             // No duplicate owners allowed.
205             require(owners[owner] == 0, "Duplicate owner address provided");
206             owners[currentOwner] = owner;
207             currentOwner = owner;
208         }
209         owners[currentOwner] = SENTINEL_OWNERS;
210         ownerCount = _owners.length;
211         threshold = _threshold;
212     }
213 
214     /// @dev Allows to add a new owner to the Safe and update the threshold at the same time.
215     ///      This can only be done via a Safe transaction.
216     /// @param owner New owner address.
217     /// @param _threshold New threshold.
218     function addOwnerWithThreshold(address owner, uint256 _threshold)
219         public
220         authorized
221     {
222         // Owner address cannot be null.
223         require(owner != 0 && owner != SENTINEL_OWNERS, "Invalid owner address provided");
224         // No duplicate owners allowed.
225         require(owners[owner] == 0, "Address is already an owner");
226         owners[owner] = owners[SENTINEL_OWNERS];
227         owners[SENTINEL_OWNERS] = owner;
228         ownerCount++;
229         emit AddedOwner(owner);
230         // Change threshold if threshold was changed.
231         if (threshold != _threshold)
232             changeThreshold(_threshold);
233     }
234 
235     /// @dev Allows to remove an owner from the Safe and update the threshold at the same time.
236     ///      This can only be done via a Safe transaction.
237     /// @param prevOwner Owner that pointed to the owner to be removed in the linked list
238     /// @param owner Owner address to be removed.
239     /// @param _threshold New threshold.
240     function removeOwner(address prevOwner, address owner, uint256 _threshold)
241         public
242         authorized
243     {
244         // Only allow to remove an owner, if threshold can still be reached.
245         require(ownerCount - 1 >= _threshold, "New owner count needs to be larger than new threshold");
246         // Validate owner address and check that it corresponds to owner index.
247         require(owner != 0 && owner != SENTINEL_OWNERS, "Invalid owner address provided");
248         require(owners[prevOwner] == owner, "Invalid prevOwner, owner pair provided");
249         owners[prevOwner] = owners[owner];
250         owners[owner] = 0;
251         ownerCount--;
252         emit RemovedOwner(owner);
253         // Change threshold if threshold was changed.
254         if (threshold != _threshold)
255             changeThreshold(_threshold);
256     }
257 
258     /// @dev Allows to swap/replace an owner from the Safe with another address.
259     ///      This can only be done via a Safe transaction.
260     /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
261     /// @param oldOwner Owner address to be replaced.
262     /// @param newOwner New owner address.
263     function swapOwner(address prevOwner, address oldOwner, address newOwner)
264         public
265         authorized
266     {
267         // Owner address cannot be null.
268         require(newOwner != 0 && newOwner != SENTINEL_OWNERS, "Invalid owner address provided");
269         // No duplicate owners allowed.
270         require(owners[newOwner] == 0, "Address is already an owner");
271         // Validate oldOwner address and check that it corresponds to owner index.
272         require(oldOwner != 0 && oldOwner != SENTINEL_OWNERS, "Invalid owner address provided");
273         require(owners[prevOwner] == oldOwner, "Invalid prevOwner, owner pair provided");
274         owners[newOwner] = owners[oldOwner];
275         owners[prevOwner] = newOwner;
276         owners[oldOwner] = 0;
277         emit RemovedOwner(oldOwner);
278         emit AddedOwner(newOwner);
279     }
280 
281     /// @dev Allows to update the number of required confirmations by Safe owners.
282     ///      This can only be done via a Safe transaction.
283     /// @param _threshold New threshold.
284     function changeThreshold(uint256 _threshold)
285         public
286         authorized
287     {
288         // Validate that threshold is smaller than number of owners.
289         require(_threshold <= ownerCount, "Threshold cannot exceed owner count");
290         // There has to be at least one Safe owner.
291         require(_threshold >= 1, "Threshold needs to be greater than 0");
292         threshold = _threshold;
293         emit ChangedThreshold(threshold);
294     }
295 
296     function getThreshold()
297         public
298         view
299         returns (uint256)
300     {
301         return threshold;
302     }
303 
304     function isOwner(address owner)
305         public
306         view
307         returns (bool)
308     {
309         return owners[owner] != 0;
310     }
311 
312     /// @dev Returns array of owners.
313     /// @return Array of Safe owners.
314     function getOwners()
315         public
316         view
317         returns (address[])
318     {
319         address[] memory array = new address[](ownerCount);
320 
321         // populate return array
322         uint256 index = 0;
323         address currentOwner = owners[SENTINEL_OWNERS];
324         while(currentOwner != SENTINEL_OWNERS) {
325             array[index] = currentOwner;
326             currentOwner = owners[currentOwner];
327             index ++;
328         }
329         return array;
330     }
331 }
332 
333 contract MasterCopy is SelfAuthorized {
334   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
335   // It should also always be ensured that the address is stored alone (uses a full word)
336     address masterCopy;
337 
338   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
339   /// @param _masterCopy New contract address.
340     function changeMasterCopy(address _masterCopy)
341         public
342         authorized
343     {
344         // Master copy address cannot be null.
345         require(_masterCopy != 0, "Invalid master copy address provided");
346         masterCopy = _masterCopy;
347     }
348 }
349 
350 contract Module is MasterCopy {
351 
352     ModuleManager public manager;
353 
354     modifier authorized() {
355         require(msg.sender == address(manager), "Method can only be called from manager");
356         _;
357     }
358 
359     function setManager()
360         internal
361     {
362         // manager can only be 0 at initalization of contract.
363         // Check ensures that setup function can only be called once.
364         require(address(manager) == 0, "Manager has already been set");
365         manager = ModuleManager(msg.sender);
366     }
367 }
368 
369 contract WhitelistModule is Module {
370 
371     string public constant NAME = "Whitelist Module";
372     string public constant VERSION = "0.0.2";
373 
374     // isWhitelisted mapping maps destination address to boolean.
375     mapping (address => bool) public isWhitelisted;
376 
377     /// @dev Setup function sets initial storage of contract.
378     /// @param accounts List of whitelisted accounts.
379     function setup(address[] accounts)
380         public
381     {
382         setManager();
383         for (uint256 i = 0; i < accounts.length; i++) {
384             address account = accounts[i];
385             require(account != 0, "Invalid account provided");
386             isWhitelisted[account] = true;
387         }
388     }
389 
390     /// @dev Allows to add destination to whitelist. This can only be done via a Safe transaction.
391     /// @param account Destination address.
392     function addToWhitelist(address account)
393         public
394         authorized
395     {
396         require(account != 0, "Invalid account provided");
397         require(!isWhitelisted[account], "Account is already whitelisted");
398         isWhitelisted[account] = true;
399     }
400 
401     /// @dev Allows to remove destination from whitelist. This can only be done via a Safe transaction.
402     /// @param account Destination address.
403     function removeFromWhitelist(address account)
404         public
405         authorized
406     {
407         require(isWhitelisted[account], "Account is not whitelisted");
408         isWhitelisted[account] = false;
409     }
410 
411     /// @dev Returns if Safe transaction is to a whitelisted destination.
412     /// @param to Whitelisted destination address.
413     /// @param value Not checked.
414     /// @param data Not checked.
415     /// @return Returns if transaction can be executed.
416     function executeWhitelisted(address to, uint256 value, bytes data)
417         public
418         returns (bool)
419     {
420         // Only Safe owners are allowed to execute transactions to whitelisted accounts.
421         require(OwnerManager(manager).isOwner(msg.sender), "Method can only be called by an owner");
422         require(isWhitelisted[to], "Target account is not whitelisted");
423         require(manager.execTransactionFromModule(to, value, data, Enum.Operation.Call), "Could not execute transaction");
424     }
425 }