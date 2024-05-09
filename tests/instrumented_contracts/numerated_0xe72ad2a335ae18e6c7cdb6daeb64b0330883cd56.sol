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
108 /**
109  * @title LandRegistryProxy
110  * @dev Points to `LandRegistry`, enabling it to be upgraded if absolutely necessary.
111  *
112  * Contracts reference `this.landRegistry` to locate `LandRegistry`.
113  * They also reference `owner` to identify blockimmo's 'administrator' (currently blockimmo but ownership may be transferred to a
114  * contract / DAO in the near-future, or even rescinded).
115  *
116  * `TokenizedProperty` references `this` to enforce the `LandRegistry` and route blockimmo's 1% transaction fee on dividend payouts.
117  * `ShareholderDAO` references `this` to allow blockimmo's 'administrator' to extend proposals for any `TokenizedProperty`.
118  * `TokenSale` references `this` to route blockimmo's 1% transaction fee on sales.
119  *
120  * For now this centralized 'administrator' provides an extra layer of control / security until our contracts are time and battle tested.
121  *
122  * This contract is never intended to be upgraded.
123  */
124 contract LandRegistryProxy is Claimable {
125   address public landRegistry;
126 
127   event Set(address indexed landRegistry);
128 
129   function set(address _landRegistry) public onlyOwner {
130     landRegistry = _landRegistry;
131     emit Set(landRegistry);
132   }
133 }