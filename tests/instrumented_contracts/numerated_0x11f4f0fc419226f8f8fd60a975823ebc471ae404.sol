1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 /**
78  * @title ERC165
79  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
80  */
81 interface ERC165 {
82 
83   /**
84    * @notice Query if a contract implements an interface
85    * @param _interfaceId The interface identifier, as specified in ERC-165
86    * @dev Interface identification is specified in ERC-165. This function
87    * uses less than 30,000 gas.
88    */
89   function supportsInterface(bytes4 _interfaceId)
90     external
91     view
92     returns (bool);
93 }
94 
95 
96 
97 /**
98  * @title SupportsInterfaceWithLookup
99  * @author Matt Condon (@shrugs)
100  * @dev Implements ERC165 using a lookup table.
101  */
102 contract SupportsInterfaceWithLookup is ERC165 {
103 
104   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
105   /**
106    * 0x01ffc9a7 ===
107    *   bytes4(keccak256('supportsInterface(bytes4)'))
108    */
109 
110   /**
111    * @dev a mapping of interface id to whether or not it's supported
112    */
113   mapping(bytes4 => bool) internal supportedInterfaces;
114 
115   /**
116    * @dev A contract implementing SupportsInterfaceWithLookup
117    * implement ERC165 itself
118    */
119   constructor()
120     public
121   {
122     _registerInterface(InterfaceId_ERC165);
123   }
124 
125   /**
126    * @dev implement supportsInterface(bytes4) using a lookup table
127    */
128   function supportsInterface(bytes4 _interfaceId)
129     external
130     view
131     returns (bool)
132   {
133     return supportedInterfaces[_interfaceId];
134   }
135 
136   /**
137    * @dev private method for registering an interface
138    */
139   function _registerInterface(bytes4 _interfaceId)
140     internal
141   {
142     require(_interfaceId != 0xffffffff);
143     supportedInterfaces[_interfaceId] = true;
144   }
145 }
146 
147 
148 
149 
150 
151 
152 
153 contract Contract is Ownable, SupportsInterfaceWithLookup {
154     /**
155      * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
156         ^ this.template.selector
157      */
158     bytes4 public constant InterfaceId_Contract = 0x6125ede5;
159 
160     Template public template;
161 
162     constructor(address _owner) public {
163         require(_owner != address(0));
164 
165         template = Template(msg.sender);
166         owner = _owner;
167 
168         _registerInterface(InterfaceId_Contract);
169     }
170 }
171 
172 
173 /**
174  * @title Template
175  * @notice Template instantiates `Contract`s of the same form.
176  */
177 contract Template is Ownable, SupportsInterfaceWithLookup {
178     /**
179      * @notice this.owner.selector ^ this.renounceOwnership.selector ^ this.transferOwnership.selector
180         ^ this.bytecodeHash.selector ^ this.price.selector ^ this.beneficiary.selector
181         ^ this.name.selector ^ this.description.selector ^ this.setNameAndDescription.selector
182         ^ this.instantiate.selector
183      */
184     bytes4 public constant InterfaceId_Template = 0xd48445ff;
185 
186     mapping(string => string) nameOfLocale;
187     mapping(string => string) descriptionOfLocale;
188     /**
189      * @notice Hash of EVM bytecode to be instantiated.
190      */
191     bytes32 public bytecodeHash;
192     /**
193      * @notice Price to pay when instantiating
194      */
195     uint public price;
196     /**
197      * @notice Address to receive payment
198      */
199     address public beneficiary;
200 
201     /**
202      * @notice Logged when a new `Contract` instantiated.
203      */
204     event Instantiated(address indexed creator, address indexed contractAddress);
205 
206     /**
207      * @param _bytecodeHash Hash of EVM bytecode
208      * @param _price Price of instantiating in wei
209      * @param _beneficiary Address to transfer _price when instantiating
210      */
211     constructor(
212         bytes32 _bytecodeHash,
213         uint _price,
214         address _beneficiary
215     ) public {
216         bytecodeHash = _bytecodeHash;
217         price = _price;
218         beneficiary = _beneficiary;
219         if (price > 0) {
220             require(beneficiary != address(0));
221         }
222 
223         _registerInterface(InterfaceId_Template);
224     }
225 
226     /**
227      * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
228      * @return Name in `_locale`.
229      */
230     function name(string _locale) public view returns (string) {
231         return nameOfLocale[_locale];
232     }
233 
234     /**
235      * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
236      * @return Description in `_locale`.
237      */
238     function description(string _locale) public view returns (string) {
239         return descriptionOfLocale[_locale];
240     }
241 
242     /**
243      * @param _locale IETF language tag(https://en.wikipedia.org/wiki/IETF_language_tag)
244      * @param _name Name to set
245      * @param _description Description to set
246      */
247     function setNameAndDescription(string _locale, string _name, string _description) public onlyOwner {
248         nameOfLocale[_locale] = _name;
249         descriptionOfLocale[_locale] = _description;
250     }
251 
252     /**
253      * @notice `msg.sender` is passed as first argument for the newly created `Contract`.
254      * @param _bytecode Bytecode corresponding to `bytecodeHash`
255      * @param _args If arguments where passed to this function, those will be appended to the arguments for `Contract`.
256      * @return Newly created contract account's address
257      */
258     function instantiate(bytes _bytecode, bytes _args) public payable returns (address contractAddress) {
259         require(bytecodeHash == keccak256(_bytecode));
260         bytes memory calldata = abi.encodePacked(_bytecode, _args);
261         assembly {
262             contractAddress := create(0, add(calldata, 0x20), mload(calldata))
263         }
264         if (contractAddress == address(0)) {
265             revert("Cannot instantiate contract");
266         } else {
267             Contract c = Contract(contractAddress);
268             // InterfaceId_ERC165
269             require(c.supportsInterface(0x01ffc9a7));
270             // InterfaceId_Contract
271             require(c.supportsInterface(0x6125ede5));
272 
273             if (price > 0) {
274                 require(msg.value == price);
275                 beneficiary.transfer(msg.value);
276             }
277             emit Instantiated(msg.sender, contractAddress);
278         }
279     }
280 }
281 
282 
283 /**
284  * @title Registry
285  * @notice Registry maintains Contracts by version.
286  */
287 contract Registry is Ownable {
288     bool opened;
289     string[] identifiers;
290     mapping(string => address) registrantOfIdentifier;
291     mapping(string => uint[]) versionsOfIdentifier;
292     mapping(string => mapping(uint => Template)) templateOfVersionOfIdentifier;
293 
294     constructor(bool _opened) Ownable() public {
295         opened = _opened;
296     }
297 
298     /**
299      * @notice Open the Registry so that anyone can register.
300      */
301     function open() onlyOwner public {
302         opened = true;
303     }
304 
305     /**
306      * @notice Registers a new `Template`.
307      * @param _identifier If any template was registered for the same identifier, the registrant of the templates must be the same.
308      * @param _version If any template was registered for the same identifier, new version must be greater than the old one.
309      * @param _template Template to be registered.
310      */
311     function register(string _identifier, uint _version, Template _template) public {
312         require(opened || msg.sender == owner);
313 
314         // InterfaceId_ERC165
315         require(_template.supportsInterface(0x01ffc9a7));
316         // InterfaceId_Template
317         require(_template.supportsInterface(0xd48445ff));
318 
319         address registrant = registrantOfIdentifier[_identifier];
320         require(registrant == address(0) || registrant == msg.sender, "identifier already registered by another registrant");
321         if (registrant == address(0)) {
322             identifiers.push(_identifier);
323             registrantOfIdentifier[_identifier] = msg.sender;
324         }
325 
326         uint[] storage versions = versionsOfIdentifier[_identifier];
327         if (versions.length > 0) {
328             require(_version > versions[versions.length - 1], "new version must be greater than old versions");
329         }
330         versions.push(_version);
331         templateOfVersionOfIdentifier[_identifier][_version] = _template;
332     }
333 
334     function numberOfIdentifiers() public view returns (uint size) {
335         return identifiers.length;
336     }
337 
338     function identifierAt(uint _index) public view returns (string identifier) {
339         return identifiers[_index];
340     }
341 
342     function versionsOf(string _identifier) public view returns (uint[] version) {
343         return versionsOfIdentifier[_identifier];
344     }
345 
346     function templateOf(string _identifier, uint _version) public view returns (Template template) {
347         return templateOfVersionOfIdentifier[_identifier][_version];
348     }
349 
350     function latestTemplateOf(string _identifier) public view returns (Template template) {
351         uint[] storage versions = versionsOfIdentifier[_identifier];
352         return templateOfVersionOfIdentifier[_identifier][versions[versions.length - 1]];
353     }
354 }
355 
356 
357 /**
358  * @title Token Registry
359  * @notice `Template` to be registered must be a `TokenTemplate`.
360  */
361 contract TokenRegistry is Registry(false) {
362 }