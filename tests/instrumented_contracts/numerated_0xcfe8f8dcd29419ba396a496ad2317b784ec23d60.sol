1 pragma solidity ^0.4.11;
2 
3 /** @title Decentralized Identification Number (DIN) registry. */
4 contract DINRegistry {
5 
6     struct Record {
7         address owner;
8         address resolver;  // Address where product information is stored. 
9         uint256 updated;   // Unix timestamp.
10     }
11 
12     // DIN => Record
13     mapping (uint256 => Record) records;
14 
15     // The address of DINRegistrar.
16     address public registrar;
17 
18     // The first DIN registered.
19     uint256 public genesis;
20 
21     modifier only_registrar {
22         require(registrar == msg.sender);
23         _;
24     }
25 
26     modifier only_owner(uint256 DIN) {
27         require(records[DIN].owner == msg.sender);
28         _;
29     }
30 
31     // Logged when the owner of a DIN transfers ownership to a new account.
32     event NewOwner(uint256 indexed DIN, address indexed owner);
33 
34     // Logged when the resolver associated with a DIN changes.
35     event NewResolver(uint256 indexed DIN, address indexed resolver);
36 
37     // Logged when a new DIN is registered.
38     event NewRegistration(uint256 indexed DIN, address indexed owner);
39 
40     // Logged when the DINRegistrar contract changes.
41     event NewRegistrar(address indexed registrar);
42 
43     /** @dev Constructor.
44       * @param _genesis The first DIN registered.
45       */
46     function DINRegistry(uint256 _genesis) {
47         genesis = _genesis;
48 
49         // Register the genesis DIN to the account that deploys this contract.
50         records[genesis].owner = msg.sender;
51         records[genesis].updated = block.timestamp;
52         NewRegistration(genesis, msg.sender);
53     }
54 
55     // Get the owner of a specified DIN.
56     function owner(uint256 DIN) constant returns (address) {
57         return records[DIN].owner;
58     }
59 
60     /**
61      * @dev Transfer ownership of a DIN.
62      * @param DIN The DIN to transfer.
63      * @param owner The address of the new owner.
64      */
65     function setOwner(uint256 DIN, address owner) only_owner(DIN) {
66         records[DIN].owner = owner;
67         records[DIN].updated = block.timestamp;
68         NewOwner(DIN, owner);
69     }
70 
71     // Get the resolver of a specified DIN.
72     function resolver(uint256 DIN) constant returns (address) {
73         return records[DIN].resolver;
74     }
75 
76     /**
77      * @dev Set the resolver of a DIN.
78      * @param DIN The DIN to update.
79      * @param resolver The address of the resolver.
80      */
81     function setResolver(uint256 DIN, address resolver) only_owner(DIN) {
82         records[DIN].resolver = resolver;
83         records[DIN].updated = block.timestamp;
84         NewResolver(DIN, resolver);
85     }
86 
87     // Get the time a specified DIN record was last updated.
88     function updated(uint256 DIN) constant returns (uint256) {
89         return records[DIN].updated;
90     } 
91 
92     /**
93      * @dev Register a new DIN.
94      * @param owner The account that will own the DIN.
95      */
96     function register(uint256 DIN, address owner) only_registrar {
97         records[DIN].owner = owner;
98         records[DIN].updated = block.timestamp;
99         NewRegistration(DIN, owner);
100     }
101 
102     /**
103      * @dev Change the DINRegistrar contract.
104      * @param _registrar The address of the new registrar.
105      */
106     function setRegistrar(address _registrar) only_owner(genesis) {
107         registrar = _registrar;
108         NewRegistrar(_registrar);
109     }
110 
111 }
112 
113 /** @title Decentralized Identification Number (DIN) registrar. Registers new DINs */
114 contract DINRegistrar {
115 
116     // The DINRegistry contract
117     DINRegistry registry;
118 
119     // The current DIN index. DINs are registered sequentially.
120     uint256 public index;
121 
122     // The maximum amount of DINs that can be registered in a single transaction.
123     uint256 public MAX_QUANTITY = 10;
124 
125     /** @dev Constructor.
126       * @param _registry The DINRegistry contract.
127       */
128     function DINRegistrar(DINRegistry _registry, uint256 _genesis) {
129         registry = _registry;
130 
131         // Set the current index to the genesis DIN.
132         index = _genesis;
133     }
134 
135     /**
136      * @dev Register a new DIN.
137      * @return DIN The newly registered DIN.
138      */
139     function registerDIN() returns (uint256 DIN) {
140         index++;
141         registry.register(index, msg.sender);
142         return index;
143     }
144 
145     /**
146      * @dev Register multiple new DINs.
147      * @param quantity The amount of DINs to register.
148      */
149     function registerDINs(uint256 quantity) {
150         require(quantity <= MAX_QUANTITY);
151 
152         for (uint i = 0; i < quantity; i++) {
153             registerDIN();
154         }
155     }
156 
157 }