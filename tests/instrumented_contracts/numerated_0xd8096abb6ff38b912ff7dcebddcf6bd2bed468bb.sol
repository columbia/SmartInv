1 pragma solidity ^0.4.17;
2 
3 /** @title Decentralized Identification Number (DIN) registry. */
4 contract DINRegistry {
5 
6     struct Record {
7         address owner;
8         address resolver;  // Address of the resolver contract, which can be used to find product information. 
9         uint256 updated;   // Last updated time (Unix timestamp).
10     }
11 
12     // DIN => Record
13     mapping (uint256 => Record) records;
14 
15     // The first DIN registered.
16     uint256 public genesis;
17 
18     // The current DIN.
19     uint256 public index;
20 
21     modifier only_owner(uint256 DIN) {
22         require(records[DIN].owner == msg.sender);
23         _;
24     }
25 
26     // Log transfers of ownership.
27     event NewOwner(uint256 indexed DIN, address indexed owner);
28 
29     // Log when new resolvers are set.
30     event NewResolver(uint256 indexed DIN, address indexed resolver);
31 
32     // Log new registrations.
33     event NewRegistration(uint256 indexed DIN, address indexed owner);
34 
35     /** @dev Constructor.
36       * @param _genesis The first DIN registered.
37       */
38     function DINRegistry(uint256 _genesis) public {
39         genesis = _genesis;
40         index = _genesis;
41 
42         // Register the genesis DIN to the account that deploys this contract.
43         records[_genesis].owner = msg.sender;
44         records[_genesis].updated = block.timestamp;
45         NewRegistration(_genesis, msg.sender);
46     }
47 
48     /**
49      * @dev Get the owner of a specific DIN.
50      */
51     function owner(uint256 _DIN) public view returns (address) {
52         return records[_DIN].owner;
53     }
54 
55     /**
56      * @dev Transfer ownership of a DIN.
57      * @param _DIN The DIN to transfer.
58      * @param _owner Address of the new owner.
59      */
60     function setOwner(uint256 _DIN, address _owner) public only_owner(_DIN) {
61         records[_DIN].owner = _owner;
62         records[_DIN].updated = block.timestamp;
63         NewOwner(_DIN, _owner);
64     }
65 
66     /**
67      * @dev Get the address of the resolver contract for a specific DIN.
68      */
69     function resolver(uint256 _DIN) public view returns (address) {
70         return records[_DIN].resolver;
71     }
72 
73     /**
74      * @dev Set the resolver of a DIN.
75      * @param _DIN The DIN to update.
76      * @param _resolver Address of the resolver.
77      */
78     function setResolver(uint256 _DIN, address _resolver) public only_owner(_DIN) {
79         records[_DIN].resolver = _resolver;
80         records[_DIN].updated = block.timestamp;
81         NewResolver(_DIN, _resolver);
82     }
83 
84     /**
85      * @dev Get the last time a DIN was updated with a new owner or resolver.
86      * @param _DIN The DIN to query.
87      * @return _timestamp Last updated time (Unix timestamp).
88      */
89     function updated(uint256 _DIN) public view returns (uint256 _timestamp) {
90         return records[_DIN].updated;
91     }
92 
93     /**
94      * @dev Self-register a new DIN.
95      * @return _DIN The DIN that is registered.
96      */
97     function selfRegisterDIN() public returns (uint256 _DIN) {
98         return registerDIN(msg.sender);
99     }
100 
101     /**
102      * @dev Self-register a new DIN and set the resolver.
103      * @param _resolver Address of the resolver.
104      * @return _DIN The DIN that is registered.
105      */
106     function selfRegisterDINWithResolver(address _resolver) public returns (uint256 _DIN) {
107         return registerDINWithResolver(msg.sender, _resolver);
108     }
109 
110     /**
111      * @dev Register a new DIN for a specific address.
112      * @param _owner Account that will own the DIN.
113      * @return _DIN The DIN that is registered.
114      */
115     function registerDIN(address _owner) public returns (uint256 _DIN) {
116         index++;
117         records[index].owner = _owner;
118         records[index].updated = block.timestamp;
119         NewRegistration(index, _owner);
120         return index;
121     }
122 
123     /**
124      * @dev Register a new DIN and set the resolver.
125      * @param _owner Account that will own the DIN.
126      * @param _resolver Address of the resolver.
127      * @return _DIN The DIN that is registered.
128      */
129     function registerDINWithResolver(address _owner, address _resolver) public returns (uint256 _DIN) {
130         index++;
131         records[index].owner = _owner;
132         records[index].resolver = _resolver;
133         records[index].updated = block.timestamp;
134         NewRegistration(index, _owner);
135         NewResolver(index, _resolver);
136         return index;
137     }
138 
139 }