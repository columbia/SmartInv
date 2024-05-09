1 pragma solidity 0.5.3;
2 
3 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Stoppable.sol
4 
5 /* using a master switch, allowing to permanently turn-off functionality */
6 contract Stoppable {
7 
8   /************************************ abstract **********************************/
9   modifier onlyOwner { _; }
10   /********************************************************************************/
11 
12   bool public isOn = true;
13 
14   modifier whenOn() { require(isOn, "must be on"); _; }
15   modifier whenOff() { require(!isOn, "must be off"); _; }
16 
17   function switchOff() external onlyOwner {
18     if (isOn) {
19       isOn = false;
20       emit Off();
21     }
22   }
23   event Off();
24 }
25 
26 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Switchable.sol
27 
28 /* using a master switch, allowing to switch functionality on/off */
29 contract Switchable is Stoppable {
30 
31   function switchOn() external onlyOwner {
32     if (!isOn) {
33       isOn = true;
34       emit On();
35     }
36   }
37   event On();
38 }
39 
40 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Validating.sol
41 
42 contract Validating {
43 
44   modifier notZero(uint number) { require(number != 0, "invalid 0 value"); _; }
45   modifier notEmpty(string memory text) { require(bytes(text).length != 0, "invalid empty string"); _; }
46   modifier validAddress(address value) { require(value != address(0x0), "invalid address");  _; }
47 
48 }
49 
50 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/HasOwners.sol
51 
52 contract HasOwners is Validating {
53 
54   mapping(address => bool) public isOwner;
55   address[] private owners;
56 
57   constructor(address[] memory _owners) public {
58     for (uint i = 0; i < _owners.length; i++) _addOwner_(_owners[i]);
59     owners = _owners;
60   }
61 
62   modifier onlyOwner { require(isOwner[msg.sender], "invalid sender; must be owner"); _; }
63 
64   function getOwners() public view returns (address[] memory) { return owners; }
65 
66   function addOwner(address owner) external onlyOwner {  _addOwner_(owner); }
67 
68   function _addOwner_(address owner) private validAddress(owner) {
69     if (!isOwner[owner]) {
70       isOwner[owner] = true;
71       owners.push(owner);
72       emit OwnerAdded(owner);
73     }
74   }
75   event OwnerAdded(address indexed owner);
76 
77   function removeOwner(address owner) external onlyOwner {
78     if (isOwner[owner]) {
79       require(owners.length > 1, "removing the last owner is not allowed");
80       isOwner[owner] = false;
81       for (uint i = 0; i < owners.length - 1; i++) {
82         if (owners[i] == owner) {
83           owners[i] = owners[owners.length - 1]; // replace map last entry
84           delete owners[owners.length - 1];
85           break;
86         }
87       }
88       owners.length -= 1;
89       emit OwnerRemoved(owner);
90     }
91   }
92   event OwnerRemoved(address indexed owner);
93 }
94 
95 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/registry/Registry.sol
96 
97 interface Registry {
98 
99   function contains(address apiKey) external view returns (bool);
100 
101   function register(address apiKey) external;
102   function registerWithUserAgreement(address apiKey, bytes32 userAgreement) external;
103 
104   function translate(address apiKey) external view returns (address);
105 }
106 
107 // File: contracts/registry/ApiKeyRegistry.sol
108 
109 contract ApiKeyRegistry is Switchable, HasOwners, Registry {
110   string public version;
111 
112   /* mapping of: address of api-key used in trading => address of account map funds used in settling */
113   mapping (address => address) public accounts;
114   mapping (address => bytes32) public userAgreements;
115 
116   constructor(address[] memory _owners, string memory _version) HasOwners(_owners) public {
117     version = _version;
118   }
119 
120   modifier isAbsent(address apiKey) { require(!contains(apiKey), "api key already in use"); _; }
121 
122   function contains(address apiKey) public view returns (bool) { return accounts[apiKey] != address(0x0); }
123 
124   function register(address apiKey) external { registerWithUserAgreement(apiKey, 0); }
125 
126   function registerWithUserAgreement(address apiKey, bytes32 userAgreement) public validAddress(apiKey) isAbsent(apiKey) whenOn {
127     accounts[apiKey] = msg.sender;
128     if (userAgreement != 0 && userAgreements[msg.sender] == 0) {
129       userAgreements[msg.sender] = userAgreement;
130     }
131     emit Registered(apiKey, msg.sender, userAgreements[msg.sender]);
132   }
133   event Registered(address apiKey, address indexed account, bytes32 userAgreement);
134 
135   function translate(address apiKey) external view returns (address) { return accounts[apiKey]; }
136 }