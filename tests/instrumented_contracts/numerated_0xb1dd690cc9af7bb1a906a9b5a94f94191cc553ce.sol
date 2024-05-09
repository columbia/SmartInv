1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Module
5  * @dev Interface for a module. 
6  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
7  * can never end up in a "frozen" state.
8  * @author Julien Niset - <julien@argent.xyz>
9  */
10 interface Module {
11 
12     /**
13      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
14      * @param _wallet The wallet.
15      */
16     function init(BaseWallet _wallet) external;
17 
18     /**
19      * @dev Adds a module to a wallet.
20      * @param _wallet The target wallet.
21      * @param _module The modules to authorise.
22      */
23     function addModule(BaseWallet _wallet, Module _module) external;
24 
25     /**
26     * @dev Utility method to recover any ERC20 token that was sent to the
27     * module by mistake. 
28     * @param _token The token to recover.
29     */
30     function recoverToken(address _token) external;
31 }
32 
33 /**
34  * @title BaseWallet
35  * @dev Simple modular wallet that authorises modules to call its invoke() method.
36  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
37  * @author Julien Niset - <julien@argent.xyx>
38  */
39 contract BaseWallet {
40 
41     // The implementation of the proxy
42     address public implementation;
43     // The owner 
44     address public owner;
45     // The authorised modules
46     mapping (address => bool) public authorised;
47     // The enabled static calls
48     mapping (bytes4 => address) public enabled;
49     // The number of modules
50     uint public modules;
51     
52     event AuthorisedModule(address indexed module, bool value);
53     event EnabledStaticCall(address indexed module, bytes4 indexed method);
54     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
55     event Received(uint indexed value, address indexed sender, bytes data);
56     event OwnerChanged(address owner);
57     
58     /**
59      * @dev Throws if the sender is not an authorised module.
60      */
61     modifier moduleOnly {
62         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
63         _;
64     }
65 
66     /**
67      * @dev Inits the wallet by setting the owner and authorising a list of modules.
68      * @param _owner The owner.
69      * @param _modules The modules to authorise.
70      */
71     function init(address _owner, address[] _modules) external {
72         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
73         require(_modules.length > 0, "BW: construction requires at least 1 module");
74         owner = _owner;
75         modules = _modules.length;
76         for(uint256 i = 0; i < _modules.length; i++) {
77             require(authorised[_modules[i]] == false, "BW: module is already added");
78             authorised[_modules[i]] = true;
79             Module(_modules[i]).init(this);
80             emit AuthorisedModule(_modules[i], true);
81         }
82     }
83     
84     /**
85      * @dev Enables/Disables a module.
86      * @param _module The target module.
87      * @param _value Set to true to authorise the module.
88      */
89     function authoriseModule(address _module, bool _value) external moduleOnly {
90         if (authorised[_module] != _value) {
91             if(_value == true) {
92                 modules += 1;
93                 authorised[_module] = true;
94                 Module(_module).init(this);
95             }
96             else {
97                 modules -= 1;
98                 require(modules > 0, "BW: wallet must have at least one module");
99                 delete authorised[_module];
100             }
101             emit AuthorisedModule(_module, _value);
102         }
103     }
104 
105     /**
106     * @dev Enables a static method by specifying the target module to which the call
107     * must be delegated.
108     * @param _module The target module.
109     * @param _method The static method signature.
110     */
111     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
112         require(authorised[_module], "BW: must be an authorised module for static call");
113         enabled[_method] = _module;
114         emit EnabledStaticCall(_module, _method);
115     }
116 
117     /**
118      * @dev Sets a new owner for the wallet.
119      * @param _newOwner The new owner.
120      */
121     function setOwner(address _newOwner) external moduleOnly {
122         require(_newOwner != address(0), "BW: address cannot be null");
123         owner = _newOwner;
124         emit OwnerChanged(_newOwner);
125     }
126     
127     /**
128      * @dev Performs a generic transaction.
129      * @param _target The address for the transaction.
130      * @param _value The value of the transaction.
131      * @param _data The data of the transaction.
132      */
133     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
134         // solium-disable-next-line security/no-call-value
135         require(_target.call.value(_value)(_data), "BW: call to target failed");
136         emit Invoked(msg.sender, _target, _value, _data);
137     }
138 
139     /**
140      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
141      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
142      * to an enabled method, or logs the call otherwise.
143      */
144     function() public payable {
145         if(msg.data.length > 0) { 
146             address module = enabled[msg.sig];
147             if(module == address(0)) {
148                 emit Received(msg.value, msg.sender, msg.data);
149             } 
150             else {
151                 require(authorised[module], "BW: must be an authorised module for static call");
152                 // solium-disable-next-line security/no-inline-assembly
153                 assembly {
154                     calldatacopy(0, 0, calldatasize())
155                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
156                     returndatacopy(0, 0, returndatasize())
157                     switch result 
158                     case 0 {revert(0, returndatasize())} 
159                     default {return (0, returndatasize())}
160                 }
161             }
162         }
163     }
164 }