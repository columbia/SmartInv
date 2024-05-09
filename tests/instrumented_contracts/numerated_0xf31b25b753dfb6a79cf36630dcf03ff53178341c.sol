1 /**
2  * Copyright (c) 2018 blockimmo AG license@blockimmo.ch
3  * Non-Profit Open Software License 3.0 (NPOSL-3.0)
4  * https://opensource.org/licenses/NPOSL-3.0
5  */
6 
7 
8 pragma solidity 0.4.25;
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    * @notice Renouncing to ownership will leave the contract without an owner.
46    * It will not be possible to call the functions with the `onlyOwner`
47    * modifier anymore.
48    */
49   function renounceOwnership() public onlyOwner {
50     emit OwnershipRenounced(owner);
51     owner = address(0);
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address _newOwner) public onlyOwner {
59     _transferOwnership(_newOwner);
60   }
61 
62   /**
63    * @dev Transfers control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function _transferOwnership(address _newOwner) internal {
67     require(_newOwner != address(0));
68     emit OwnershipTransferred(owner, _newOwner);
69     owner = _newOwner;
70   }
71 }
72 
73 
74 /**
75  * @title Claimable
76  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
77  * This allows the new owner to accept the transfer.
78  */
79 contract Claimable is Ownable {
80   address public pendingOwner;
81 
82   /**
83    * @dev Modifier throws if called by any account other than the pendingOwner.
84    */
85   modifier onlyPendingOwner() {
86     require(msg.sender == pendingOwner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to set the pendingOwner address.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) public onlyOwner {
95     pendingOwner = newOwner;
96   }
97 
98   /**
99    * @dev Allows the pendingOwner address to finalize the transfer.
100    */
101   function claimOwnership() public onlyPendingOwner {
102     emit OwnershipTransferred(owner, pendingOwner);
103     owner = pendingOwner;
104     pendingOwner = address(0);
105   }
106 }
107 
108 
109 /**
110  * @title LandRegistry
111  * @dev A minimal, simple database mapping properties to their on-chain representation (`TokenizedProperty`).
112  *
113  * The purpose of this contract is not to be official or replace the existing (off-chain) land registry.
114  * Its purpose is to map entries in the official registry to their on-chain representation.
115  * This mapping / bridging process is enabled by our legal framework, which works in-sync with and relies on this database.
116  *
117  * `this.landRegistry` is the single source of truth for on-chain properties verified legitimate by blockimmo.
118  * Any property not indexed in `this.landRegistry` is NOT verified legitimate by blockimmo.
119  *
120  * `TokenizedProperty` references `this` to only allow tokens of verified properties to be transferred.
121  * Any (unmodified) `TokenizedProperty`'s tokens will be transferable if and only if it is indexed in `this.landRegistry` (otherwise locked).
122  *
123  * `LandRegistryProxy` enables `this` to be easily and reliably upgraded if absolutely necessary.
124  * `LandRegistryProxy` and `this` are controlled by a centralized entity.
125  * This centralization provides an extra layer of control / security until our contracts are time and battle tested.
126  * We intend to work towards full decentralization in small, precise, confident steps by transferring ownership
127  * of these contracts when appropriate and necessary.
128  */
129 contract LandRegistry is Claimable {
130   mapping(string => address) private landRegistry;
131 
132   event Tokenized(string eGrid, address indexed property);
133   event Untokenized(string eGrid, address indexed property);
134 
135   /**
136    * this function's abi should never change and always maintain backwards compatibility
137    */
138   function getProperty(string _eGrid) public view returns (address property) {
139     property = landRegistry[_eGrid];
140   }
141 
142   function tokenizeProperty(string _eGrid, address _property) public onlyOwner {
143     require(bytes(_eGrid).length > 0, "eGrid must be non-empty string");
144     require(_property != address(0), "property address must be non-null");
145     require(landRegistry[_eGrid] == address(0), "property must not already exist in land registry");
146 
147     landRegistry[_eGrid] = _property;
148     emit Tokenized(_eGrid, _property);
149   }
150 
151   function untokenizeProperty(string _eGrid) public onlyOwner {
152     address property = getProperty(_eGrid);
153     require(property != address(0), "property must exist in land registry");
154 
155     landRegistry[_eGrid] = address(0);
156     emit Untokenized(_eGrid, property);
157   }
158 }