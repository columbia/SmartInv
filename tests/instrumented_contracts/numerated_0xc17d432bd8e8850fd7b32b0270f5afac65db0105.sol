1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title BaseWallet
5  * @dev Simple modular wallet that authorises modules to call its invoke() method.
6  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
7  * @author Julien Niset - <julien@argent.xyz>
8  */
9 contract BaseWallet {
10 
11     // The implementation of the proxy
12     address public implementation;
13     // The owner 
14     address public owner;
15     // The authorised modules
16     mapping (address => bool) public authorised;
17     // The enabled static calls
18     mapping (bytes4 => address) public enabled;
19     // The number of modules
20     uint public modules;
21     
22     event AuthorisedModule(address indexed module, bool value);
23     event EnabledStaticCall(address indexed module, bytes4 indexed method);
24     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
25     event Received(uint indexed value, address indexed sender, bytes data);
26     event OwnerChanged(address owner);
27     
28     /**
29      * @dev Throws if the sender is not an authorised module.
30      */
31     modifier moduleOnly {
32         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
33         _;
34     }
35 
36     /**
37      * @dev Inits the wallet by setting the owner and authorising a list of modules.
38      * @param _owner The owner.
39      * @param _modules The modules to authorise.
40      */
41     function init(address _owner, address[] _modules) external {
42         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
43         require(_modules.length > 0, "BW: construction requires at least 1 module");
44         owner = _owner;
45         modules = _modules.length;
46         for(uint256 i = 0; i < _modules.length; i++) {
47             require(authorised[_modules[i]] == false, "BW: module is already added");
48             authorised[_modules[i]] = true;
49             Module(_modules[i]).init(this);
50             emit AuthorisedModule(_modules[i], true);
51         }
52     }
53     
54     /**
55      * @dev Enables/Disables a module.
56      * @param _module The target module.
57      * @param _value Set to true to authorise the module.
58      */
59     function authoriseModule(address _module, bool _value) external moduleOnly {
60         if (authorised[_module] != _value) {
61             if(_value == true) {
62                 modules += 1;
63                 authorised[_module] = true;
64                 Module(_module).init(this);
65             }
66             else {
67                 modules -= 1;
68                 require(modules > 0, "BW: wallet must have at least one module");
69                 delete authorised[_module];
70             }
71             emit AuthorisedModule(_module, _value);
72         }
73     }
74 
75     /**
76     * @dev Enables a static method by specifying the target module to which the call
77     * must be delegated.
78     * @param _module The target module.
79     * @param _method The static method signature.
80     */
81     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
82         require(authorised[_module], "BW: must be an authorised module for static call");
83         enabled[_method] = _module;
84         emit EnabledStaticCall(_module, _method);
85     }
86 
87     /**
88      * @dev Sets a new owner for the wallet.
89      * @param _newOwner The new owner.
90      */
91     function setOwner(address _newOwner) external moduleOnly {
92         require(_newOwner != address(0), "BW: address cannot be null");
93         owner = _newOwner;
94         emit OwnerChanged(_newOwner);
95     }
96     
97     /**
98      * @dev Performs a generic transaction.
99      * @param _target The address for the transaction.
100      * @param _value The value of the transaction.
101      * @param _data The data of the transaction.
102      */
103     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
104         // solium-disable-next-line security/no-call-value
105         require(_target.call.value(_value)(_data), "BW: call to target failed");
106         emit Invoked(msg.sender, _target, _value, _data);
107     }
108 
109     /**
110      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
111      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
112      * to an enabled method, or logs the call otherwise.
113      */
114     function() public payable {
115         if(msg.data.length > 0) { 
116             address module = enabled[msg.sig];
117             if(module == address(0)) {
118                 emit Received(msg.value, msg.sender, msg.data);
119             } 
120             else {
121                 require(authorised[module], "BW: must be an authorised module for static call");
122                 // solium-disable-next-line security/no-inline-assembly
123                 assembly {
124                     calldatacopy(0, 0, calldatasize())
125                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
126                     returndatacopy(0, 0, returndatasize())
127                     switch result 
128                     case 0 {revert(0, returndatasize())} 
129                     default {return (0, returndatasize())}
130                 }
131             }
132         }
133     }
134 }
135 
136 /**
137  * @title Module
138  * @dev Interface for a module. 
139  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
140  * can never end up in a "frozen" state.
141  * @author Julien Niset - <julien@argent.xyz>
142  */
143 interface Module {
144 
145     /**
146      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
147      * @param _wallet The wallet.
148      */
149     function init(BaseWallet _wallet) external;
150 
151     /**
152      * @dev Adds a module to a wallet.
153      * @param _wallet The target wallet.
154      * @param _module The modules to authorise.
155      */
156     function addModule(BaseWallet _wallet, Module _module) external;
157 
158     /**
159     * @dev Utility method to recover any ERC20 token that was sent to the
160     * module by mistake. 
161     * @param _token The token to recover.
162     */
163     function recoverToken(address _token) external;
164 }
165 
166 /**
167  * @title Upgrader
168  * @dev Interface for a contract that can upgrade wallets by enabling/disabling modules. 
169  * @author Julien Niset - <julien@argent.xyz>
170  */
171 interface Upgrader {
172 
173     /**
174      * @dev Upgrades a wallet by enabling/disabling modules.
175      * @param _wallet The owner.
176      */
177     function upgrade(address _wallet, address[] _toDisable, address[] _toEnable) external;
178 
179     function toDisable() external view returns (address[]);
180 
181     function toEnable() external view returns (address[]);
182 }
183 
184 /**
185  * @title Owned
186  * @dev Basic contract to define an owner.
187  * @author Julien Niset - <julien@argent.xyz>
188  */
189 contract Owned {
190 
191     // The owner
192     address public owner;
193 
194     event OwnerChanged(address indexed _newOwner);
195 
196     /**
197      * @dev Throws if the sender is not the owner.
198      */
199     modifier onlyOwner {
200         require(msg.sender == owner, "Must be owner");
201         _;
202     }
203 
204     constructor() public {
205         owner = msg.sender;
206     }
207 
208     /**
209      * @dev Lets the owner transfer ownership of the contract to a new owner.
210      * @param _newOwner The new owner.
211      */
212     function changeOwner(address _newOwner) external onlyOwner {
213         require(_newOwner != address(0), "Address must not be null");
214         owner = _newOwner;
215         emit OwnerChanged(_newOwner);
216     }
217 }
218 
219 /**
220  * ERC20 contract interface.
221  */
222 contract ERC20 {
223     function totalSupply() public view returns (uint);
224     function decimals() public view returns (uint);
225     function balanceOf(address tokenOwner) public view returns (uint balance);
226     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
227     function transfer(address to, uint tokens) public returns (bool success);
228     function approve(address spender, uint tokens) public returns (bool success);
229     function transferFrom(address from, address to, uint tokens) public returns (bool success);
230 }
231 
232 /**
233  * @title ModuleRegistry
234  * @dev Registry of authorised modules. 
235  * Modules must be registered before they can be authorised on a wallet.
236  * @author Julien Niset - <julien@argent.xyz>
237  */
238 contract ModuleRegistry is Owned {
239 
240     mapping (address => Info) internal modules;
241     mapping (address => Info) internal upgraders;
242 
243     event ModuleRegistered(address indexed module, bytes32 name);
244     event ModuleDeRegistered(address module);
245     event UpgraderRegistered(address indexed upgrader, bytes32 name);
246     event UpgraderDeRegistered(address upgrader);
247 
248     struct Info {
249         bool exists;
250         bytes32 name;
251     }
252 
253     /**
254      * @dev Registers a module.
255      * @param _module The module.
256      * @param _name The unique name of the module.
257      */
258     function registerModule(address _module, bytes32 _name) external onlyOwner {
259         require(!modules[_module].exists, "MR: module already exists");
260         modules[_module] = Info({exists: true, name: _name});
261         emit ModuleRegistered(_module, _name);
262     }
263 
264     /**
265      * @dev Deregisters a module.
266      * @param _module The module.
267      */
268     function deregisterModule(address _module) external onlyOwner {
269         require(modules[_module].exists, "MR: module does not exists");
270         delete modules[_module];
271         emit ModuleDeRegistered(_module);
272     }
273 
274         /**
275      * @dev Registers an upgrader.
276      * @param _upgrader The upgrader.
277      * @param _name The unique name of the upgrader.
278      */
279     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
280         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
281         upgraders[_upgrader] = Info({exists: true, name: _name});
282         emit UpgraderRegistered(_upgrader, _name);
283     }
284 
285     /**
286      * @dev Deregisters an upgrader.
287      * @param _upgrader The _upgrader.
288      */
289     function deregisterUpgrader(address _upgrader) external onlyOwner {
290         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
291         delete upgraders[_upgrader];
292         emit UpgraderDeRegistered(_upgrader);
293     }
294 
295     /**
296     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
297     * registry.
298     * @param _token The token to recover.
299     */
300     function recoverToken(address _token) external onlyOwner {
301         uint total = ERC20(_token).balanceOf(address(this));
302         ERC20(_token).transfer(msg.sender, total);
303     } 
304 
305     /**
306      * @dev Gets the name of a module from its address.
307      * @param _module The module address.
308      * @return the name.
309      */
310     function moduleInfo(address _module) external view returns (bytes32) {
311         return modules[_module].name;
312     }
313 
314     /**
315      * @dev Gets the name of an upgrader from its address.
316      * @param _upgrader The upgrader address.
317      * @return the name.
318      */
319     function upgraderInfo(address _upgrader) external view returns (bytes32) {
320         return upgraders[_upgrader].name;
321     }
322 
323     /**
324      * @dev Checks if a module is registered.
325      * @param _module The module address.
326      * @return true if the module is registered.
327      */
328     function isRegisteredModule(address _module) external view returns (bool) {
329         return modules[_module].exists;
330     }
331 
332     /**
333      * @dev Checks if a list of modules are registered.
334      * @param _modules The list of modules address.
335      * @return true if all the modules are registered.
336      */
337     function isRegisteredModule(address[] _modules) external view returns (bool) {
338         for(uint i = 0; i < _modules.length; i++) {
339             if (!modules[_modules[i]].exists) {
340                 return false;
341             }
342         }
343         return true;
344     }  
345 
346     /**
347      * @dev Checks if an upgrader is registered.
348      * @param _upgrader The upgrader address.
349      * @return true if the upgrader is registered.
350      */
351     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
352         return upgraders[_upgrader].exists;
353     } 
354 
355 }