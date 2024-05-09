1 pragma solidity ^0.4.23;
2 
3 interface StorageInterface {
4   function getTarget(bytes32 exec_id, bytes4 selector)
5       external view returns (address implementation);
6   function getIndex(bytes32 exec_id) external view returns (address index);
7   function createInstance(address sender, bytes32 app_name, address provider, bytes32 registry_exec_id, bytes calldata)
8       external payable returns (bytes32 instance_exec_id, bytes32 version);
9   function createRegistry(address index, address implementation) external returns (bytes32 exec_id);
10   function exec(address sender, bytes32 exec_id, bytes calldata)
11       external payable returns (uint emitted, uint paid, uint stored);
12 }
13 
14 interface RegistryInterface {
15   function getLatestVersion(address stor_addr, bytes32 exec_id, address provider, bytes32 app_name)
16       external view returns (bytes32 latest_name);
17   function getVersionImplementation(address stor_addr, bytes32 exec_id, address provider, bytes32 app_name, bytes32 version_name)
18       external view returns (address index, bytes4[] selectors, address[] implementations);
19 }
20 
21 contract ScriptExec {
22 
23   /// DEFAULT VALUES ///
24 
25   address public app_storage;
26   address public provider;
27   bytes32 public registry_exec_id;
28   address public exec_admin;
29 
30   /// APPLICATION INSTANCE METADATA ///
31 
32   struct Instance {
33     address current_provider;
34     bytes32 current_registry_exec_id;
35     bytes32 app_exec_id;
36     bytes32 app_name;
37     bytes32 version_name;
38   }
39 
40   // Maps the execution ids of deployed instances to the address that deployed them -
41   mapping (bytes32 => address) public deployed_by;
42   // Maps the execution ids of deployed instances to a struct containing their metadata -
43   mapping (bytes32 => Instance) public instance_info;
44   // Maps an address that deployed app instances to metadata about the deployed instance -
45   mapping (address => Instance[]) public deployed_instances;
46   // Maps an application name to the exec ids under which it is deployed -
47   mapping (bytes32 => bytes32[]) public app_instances;
48 
49   /// EVENTS ///
50 
51   event AppInstanceCreated(address indexed creator, bytes32 indexed execution_id, bytes32 app_name, bytes32 version_name);
52   event StorageException(bytes32 indexed execution_id, string message);
53 
54   // Modifier - The sender must be the contract administrator
55   modifier onlyAdmin() {
56     require(msg.sender == exec_admin);
57     _;
58   }
59 
60   // Payable function - for abstract storage refunds
61   function () public payable { }
62 
63   /*
64   Configure various defaults for a script exec contract
65   @param _exec_admin: A privileged address, able to set the target provider and registry exec id
66   @param _app_storage: The address to which applications will be stored
67   @param _provider: The address under which applications have been initialized
68   */
69   function configure(address _exec_admin, address _app_storage, address _provider) public {
70     require(app_storage == 0, "ScriptExec already configured");
71     require(_app_storage != 0, 'Invalid input');
72     exec_admin = _exec_admin;
73     app_storage = _app_storage;
74     provider = _provider;
75 
76     if (exec_admin == 0)
77       exec_admin = msg.sender;
78   }
79 
80   /// APPLICATION EXECUTION ///
81 
82   bytes4 internal constant EXEC_SEL = bytes4(keccak256('exec(address,bytes32,bytes)'));
83 
84   /*
85   Executes an application using its execution id and storage address.
86 
87   @param _exec_id: The instance exec id, which will route the calldata to the appropriate destination
88   @param _calldata: The calldata to forward to the application
89   @return success: Whether execution succeeded or not
90   */
91   function exec(bytes32 _exec_id, bytes _calldata) external payable returns (bool success);
92 
93   bytes4 internal constant ERR = bytes4(keccak256('Error(string)'));
94 
95   // Return the bytes4 action requestor stored at the pointer, and cleans the remaining bytes
96   function getAction(uint _ptr) internal pure returns (bytes4 action) {
97     assembly {
98       // Get the first 4 bytes stored at the pointer, and clean the rest of the bytes remaining
99       action := and(mload(_ptr), 0xffffffff00000000000000000000000000000000000000000000000000000000)
100     }
101   }
102 
103   // Checks to see if an error message was returned with the failed call, and emits it if so -
104   function checkErrors(bytes32 _exec_id) internal {
105     // If the returned data begins with selector 'Error(string)', get the contained message -
106     string memory message;
107     bytes4 err_sel = ERR;
108     assembly {
109       // Get pointer to free memory, place returned data at pointer, and update free memory pointer
110       let ptr := mload(0x40)
111       returndatacopy(ptr, 0, returndatasize)
112       mstore(0x40, add(ptr, returndatasize))
113 
114       // Check value at pointer for equality with Error selector -
115       if eq(mload(ptr), and(err_sel, 0xffffffff00000000000000000000000000000000000000000000000000000000)) {
116         message := add(0x24, ptr)
117       }
118     }
119     // If no returned message exists, emit a default error message. Otherwise, emit the error message
120     if (bytes(message).length == 0)
121       emit StorageException(_exec_id, "No error recieved");
122     else
123       emit StorageException(_exec_id, message);
124   }
125 
126   // Checks data returned by an application and returns whether or not the execution changed state
127   function checkReturn() internal pure returns (bool success) {
128     success = false;
129     assembly {
130       // returndata size must be 0x60 bytes
131       if eq(returndatasize, 0x60) {
132         // Copy returned data to pointer and check that at least one value is nonzero
133         let ptr := mload(0x40)
134         returndatacopy(ptr, 0, returndatasize)
135         if iszero(iszero(mload(ptr))) { success := 1 }
136         if iszero(iszero(mload(add(0x20, ptr)))) { success := 1 }
137         if iszero(iszero(mload(add(0x40, ptr)))) { success := 1 }
138       }
139     }
140     return success;
141   }
142 
143   /// APPLICATION INITIALIZATION ///
144 
145   /*
146   Initializes an instance of an application. Uses default app provider and registry app.
147   Uses latest app version by default.
148   @param _app_name: The name of the application to initialize
149   @param _init_calldata: Calldata to be forwarded to the application's initialization function
150   @return exec_id: The execution id (within the application's storage) of the created application instance
151   @return version: The name of the version of the instance
152   */
153   function createAppInstance(bytes32 _app_name, bytes _init_calldata) external returns (bytes32 exec_id, bytes32 version) {
154     require(_app_name != 0 && _init_calldata.length >= 4, 'invalid input');
155     (exec_id, version) = StorageInterface(app_storage).createInstance(
156       msg.sender, _app_name, provider, registry_exec_id, _init_calldata
157     );
158     // Set various app metadata values -
159     deployed_by[exec_id] = msg.sender;
160     app_instances[_app_name].push(exec_id);
161     Instance memory inst = Instance(
162       provider, registry_exec_id, exec_id, _app_name, version
163     );
164     instance_info[exec_id] = inst;
165     deployed_instances[msg.sender].push(inst);
166     // Emit event -
167     emit AppInstanceCreated(msg.sender, exec_id, _app_name, version);
168   }
169 
170   /// ADMIN FUNCTIONS ///
171 
172   /*
173   Allows the exec admin to set the registry exec id from which applications will be initialized -
174   @param _exec_id: The new exec id from which applications will be initialized
175   */
176   function setRegistryExecID(bytes32 _exec_id) public onlyAdmin() {
177     registry_exec_id = _exec_id;
178   }
179 
180   /*
181   Allows the exec admin to set the provider from which applications will be initialized in the given registry exec id
182   @param _provider: The address under which applications to initialize are registered
183   */
184   function setProvider(address _provider) public onlyAdmin() {
185     provider = _provider;
186   }
187 
188   // Allows the admin to set a new admin address
189   function setAdmin(address _admin) public onlyAdmin() {
190     require(_admin != 0);
191     exec_admin = _admin;
192   }
193 
194   /// STORAGE GETTERS ///
195 
196   // Returns a list of execution ids under which the given app name was deployed
197   function getInstances(bytes32 _app_name) public view returns (bytes32[] memory) {
198     return app_instances[_app_name];
199   }
200 
201   /*
202   Returns the number of instances an address has created
203   @param _deployer: The address that deployed the instances
204   @return uint: The number of instances deployed by the deployer
205   */
206   function getDeployedLength(address _deployer) public view returns (uint) {
207     return deployed_instances[_deployer].length;
208   }
209 
210   // The function selector for a simple registry 'registerApp' function
211   bytes4 internal constant REGISTER_APP_SEL = bytes4(keccak256('registerApp(bytes32,address,bytes4[],address[])'));
212 
213   /*
214   Returns the index address and implementing address for the simple registry app set as the default
215   @return indx: The index address for the registry application - contains getters for the Registry, as well as its init funciton
216   @return implementation: The address implementing the registry's functions
217   */
218   function getRegistryImplementation() public view returns (address index, address implementation) {
219     index = StorageInterface(app_storage).getIndex(registry_exec_id);
220     implementation = StorageInterface(app_storage).getTarget(registry_exec_id, REGISTER_APP_SEL);
221   }
222 
223   /*
224   Returns the functions and addresses implementing those functions that make up an application under the give execution id
225   @param _exec_id: The execution id that represents the application in storage
226   @return index: The index address of the instance - holds the app's getter functions and init functions
227   @return functions: A list of function selectors supported by the application
228   @return implementations: A list of addresses corresponding to the function selectors, where those selectors are implemented
229   */
230   function getInstanceImplementation(bytes32 _exec_id) public view
231   returns (address index, bytes4[] memory functions, address[] memory implementations) {
232     Instance memory app = instance_info[_exec_id];
233     index = StorageInterface(app_storage).getIndex(app.current_registry_exec_id);
234     (index, functions, implementations) = RegistryInterface(index).getVersionImplementation(
235       app_storage, app.current_registry_exec_id, app.current_provider, app.app_name, app.version_name
236     );
237   }
238 }
239 
240 contract RegistryExec is ScriptExec {
241 
242   struct Registry {
243     address index;
244     address implementation;
245   }
246 
247   // Maps execution ids to its registry app metadata
248   mapping (bytes32 => Registry) public registry_instance_info;
249   // Maps address to list of deployed Registry instances
250   mapping (address => Registry[]) public deployed_registry_instances;
251 
252   /// EVENTS ///
253 
254   event RegistryInstanceCreated(address indexed creator, bytes32 indexed execution_id, address index, address implementation);
255 
256   /// APPLICATION EXECUTION ///
257 
258   bytes4 internal constant EXEC_SEL = bytes4(keccak256('exec(address,bytes32,bytes)'));
259 
260   /*
261   Executes an application using its execution id and storage address.
262 
263   @param _exec_id: The instance exec id, which will route the calldata to the appropriate destination
264   @param _calldata: The calldata to forward to the application
265   @return success: Whether execution succeeded or not
266   */
267   function exec(bytes32 _exec_id, bytes _calldata) external payable returns (bool success) {
268     // Get function selector from calldata -
269     bytes4 sel = getSelector(_calldata);
270     // Ensure no registry functions are being called -
271     require(
272       sel != this.registerApp.selector &&
273       sel != this.registerAppVersion.selector &&
274       sel != UPDATE_INST_SEL &&
275       sel != UPDATE_EXEC_SEL
276     );
277 
278     // Call 'exec' in AbstractStorage, passing in the sender's address, the app exec id, and the calldata to forward -
279     if (address(app_storage).call.value(msg.value)(abi.encodeWithSelector(
280       EXEC_SEL, msg.sender, _exec_id, _calldata
281     )) == false) {
282       // Call failed - emit error message from storage and return 'false'
283       checkErrors(_exec_id);
284       // Return unspent wei to sender
285       address(msg.sender).transfer(address(this).balance);
286       return false;
287     }
288 
289     // Get returned data
290     success = checkReturn();
291     // If execution failed,
292     require(success, 'Execution failed');
293 
294     // Transfer any returned wei back to the sender
295     address(msg.sender).transfer(address(this).balance);
296   }
297 
298   // Returns the first 4 bytes of calldata
299   function getSelector(bytes memory _calldata) internal pure returns (bytes4 selector) {
300     assembly {
301       selector := and(
302         mload(add(0x20, _calldata)),
303         0xffffffff00000000000000000000000000000000000000000000000000000000
304       )
305     }
306   }
307 
308   /// REGISTRY FUNCTIONS ///
309 
310   /*
311   Creates an instance of a registry application and returns its execution id
312   @param _index: The index file of the registry app (holds getters and init functions)
313   @param _implementation: The file implementing the registry's functionality
314   @return exec_id: The execution id under which the registry will store data
315   */
316   function createRegistryInstance(address _index, address _implementation) external onlyAdmin() returns (bytes32 exec_id) {
317     // Validate input -
318     require(_index != 0 && _implementation != 0, 'Invalid input');
319 
320     // Creates a registry from storage and returns the registry exec id -
321     exec_id = StorageInterface(app_storage).createRegistry(_index, _implementation);
322 
323     // Ensure a valid execution id returned from storage -
324     require(exec_id != 0, 'Invalid response from storage');
325 
326     // If there is not already a default registry exec id set, set it
327     if (registry_exec_id == 0)
328       registry_exec_id = exec_id;
329 
330     // Create Registry struct in memory -
331     Registry memory reg = Registry(_index, _implementation);
332 
333     // Set various app metadata values -
334     deployed_by[exec_id] = msg.sender;
335     registry_instance_info[exec_id] = reg;
336     deployed_registry_instances[msg.sender].push(reg);
337     // Emit event -
338     emit RegistryInstanceCreated(msg.sender, exec_id, _index, _implementation);
339   }
340 
341   /*
342   Registers an application as the admin under the provider and registry exec id
343   @param _app_name: The name of the application to register
344   @param _index: The index file of the application - holds the getters and init functions
345   @param _selectors: The selectors of the functions which the app implements
346   @param _implementations: The addresses at which each function is located
347   */
348   function registerApp(bytes32 _app_name, address _index, bytes4[] _selectors, address[] _implementations) external onlyAdmin() {
349     // Validate input
350     require(_app_name != 0 && _index != 0, 'Invalid input');
351     require(_selectors.length == _implementations.length && _selectors.length != 0, 'Invalid input');
352     // Check contract variables for valid initialization
353     require(app_storage != 0 && registry_exec_id != 0 && provider != 0, 'Invalid state');
354 
355     // Execute registerApp through AbstractStorage -
356     uint emitted;
357     uint paid;
358     uint stored;
359     (emitted, paid, stored) = StorageInterface(app_storage).exec(msg.sender, registry_exec_id, msg.data);
360 
361     // Ensure zero values for emitted and paid, and nonzero value for stored -
362     require(emitted == 0 && paid == 0 && stored != 0, 'Invalid state change');
363   }
364 
365   /*
366   Registers a version of an application as the admin under the provider and registry exec id
367   @param _app_name: The name of the application under which the version will be registered
368   @param _version_name: The name of the version to register
369   @param _index: The index file of the application - holds the getters and init functions
370   @param _selectors: The selectors of the functions which the app implements
371   @param _implementations: The addresses at which each function is located
372   */
373   function registerAppVersion(bytes32 _app_name, bytes32 _version_name, address _index, bytes4[] _selectors, address[] _implementations) external onlyAdmin() {
374     // Validate input
375     require(_app_name != 0 && _version_name != 0 && _index != 0, 'Invalid input');
376     require(_selectors.length == _implementations.length && _selectors.length != 0, 'Invalid input');
377     // Check contract variables for valid initialization
378     require(app_storage != 0 && registry_exec_id != 0 && provider != 0, 'Invalid state');
379 
380     // Execute registerApp through AbstractStorage -
381     uint emitted;
382     uint paid;
383     uint stored;
384     (emitted, paid, stored) = StorageInterface(app_storage).exec(msg.sender, registry_exec_id, msg.data);
385 
386     // Ensure zero values for emitted and paid, and nonzero value for stored -
387     require(emitted == 0 && paid == 0 && stored != 0, 'Invalid state change');
388   }
389 
390   // Update instance selectors, index, and addresses
391   bytes4 internal constant UPDATE_INST_SEL = bytes4(keccak256('updateInstance(bytes32,bytes32,bytes32)'));
392 
393   /*
394   Updates an application's implementations, selectors, and index address. Uses default app provider and registry app.
395   Uses latest app version by default.
396 
397   @param _exec_id: The execution id of the application instance to be updated
398   @return success: The success of the call to the application's updateInstance function
399   */
400   function updateAppInstance(bytes32 _exec_id) external returns (bool success) {
401     // Validate input. Only the original deployer can update an application -
402     require(_exec_id != 0 && msg.sender == deployed_by[_exec_id], 'invalid sender or input');
403 
404     // Get instance metadata from exec id -
405     Instance memory inst = instance_info[_exec_id];
406 
407     // Call 'exec' in AbstractStorage, passing in the sender's address, the execution id, and
408     // the calldata to update the application -
409     if(address(app_storage).call(
410       abi.encodeWithSelector(EXEC_SEL,            // 'exec' selector
411         inst.current_provider,                    // application provider address
412         _exec_id,                                 // execution id to update
413         abi.encodeWithSelector(UPDATE_INST_SEL,   // calldata for Registry updateInstance function
414           inst.app_name,                          // name of the applcation used by the instance
415           inst.version_name,                      // name of the current version of the application
416           inst.current_registry_exec_id           // registry exec id when the instance was instantiated
417         )
418       )
419     ) == false) {
420       // Call failed - emit error message from storage and return 'false'
421       checkErrors(_exec_id);
422       return false;
423     }
424     // Check returned data to ensure state was correctly changed in AbstractStorage -
425     success = checkReturn();
426     // If execution failed, revert state and return an error message -
427     require(success, 'Execution failed');
428 
429     // If execution was successful, the version was updated. Get the latest version
430     // and set the exec id instance info -
431     address registry_idx = StorageInterface(app_storage).getIndex(inst.current_registry_exec_id);
432     bytes32 latest_version  = RegistryInterface(registry_idx).getLatestVersion(
433       app_storage,
434       inst.current_registry_exec_id,
435       inst.current_provider,
436       inst.app_name
437     );
438     // Ensure nonzero latest version -
439     require(latest_version != 0, 'invalid latest version');
440     // Set current version -
441     instance_info[_exec_id].version_name = latest_version;
442   }
443 
444   // Update instance script exec contract
445   bytes4 internal constant UPDATE_EXEC_SEL = bytes4(keccak256('updateExec(address)'));
446 
447   /*
448   Updates an application's script executor from this Script Exec to a new address
449 
450   @param _exec_id: The execution id of the application instance to be updated
451   @param _new_exec_addr: The new script exec address for this exec id
452   @returns success: The success of the call to the application's updateExec function
453   */
454   function updateAppExec(bytes32 _exec_id, address _new_exec_addr) external returns (bool success) {
455     // Validate input. Only the original deployer can migrate the script exec address -
456     require(_exec_id != 0 && msg.sender == deployed_by[_exec_id] && address(this) != _new_exec_addr && _new_exec_addr != 0, 'invalid input');
457 
458     // Call 'exec' in AbstractStorage, passing in the sender's address, the execution id, and
459     // the calldata to migrate the script exec address -
460     if(address(app_storage).call(
461       abi.encodeWithSelector(EXEC_SEL,                            // 'exec' selector
462         msg.sender,                                               // sender address
463         _exec_id,                                                 // execution id to update
464         abi.encodeWithSelector(UPDATE_EXEC_SEL, _new_exec_addr)   // calldata for Registry updateExec
465       )
466     ) == false) {
467       // Call failed - emit error message from storage and return 'false'
468       checkErrors(_exec_id);
469       return false;
470     }
471     // Check returned data to ensure state was correctly changed in AbstractStorage -
472     success = checkReturn();
473     // If execution failed, revert state and return an error message -
474     require(success, 'Execution failed');
475   }
476 }