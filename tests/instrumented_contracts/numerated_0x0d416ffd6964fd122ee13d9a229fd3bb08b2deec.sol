1 // TAKEN FROM https://github.com/OpenZeppelin/openzeppelin-solidity/commit/5daaf60d11ee2075260d0f3adfb22b1c536db983
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 
68 // This is an implementation (with some adaptations) of uPort erc780: https://etherscan.io/address/0xdb55d40684e7dc04655a9789937214b493a2c2c6#code && https://github.com/ethereum/EIPs/issues/780
69 
70 contract Registry is Ownable {
71 
72     mapping(address =>
73     mapping(address =>
74     mapping(bytes32 =>
75     mapping(bytes32 => bytes32)))) registry;
76 
77     event ClaimSet(
78         address indexed subject,
79         address indexed issuer,
80         bytes32 indexed id,
81         bytes32 key,
82         bytes32 data,
83         uint updatedAt
84     );
85 
86     event ClaimRemoved(
87         address indexed subject,
88         address indexed issuer,
89         bytes32 indexed id,
90         bytes32 key,
91         uint removedAt
92     );
93 
94     function setClaim(
95         address subject,
96         address issuer,
97         bytes32 id,
98         bytes32 key,
99         bytes32 data
100     ) public {
101         require(msg.sender == issuer || msg.sender == owner);
102         registry[subject][issuer][id][key] = data;
103         emit ClaimSet(subject, issuer, id, key, data, now);
104     }
105 
106     function getClaim(
107         address subject,
108         address issuer,
109         bytes32 id,
110         bytes32 key
111     )
112     public view returns(bytes32) {
113         return registry[subject][issuer][id][key];
114     }
115 
116     function removeClaim(
117         address subject,
118         address issuer,
119         bytes32 id,
120         bytes32 key
121     ) public {
122         require(
123             msg.sender == subject || msg.sender == issuer || msg.sender == owner
124         );
125         delete registry[subject][issuer][id][key];
126         emit ClaimRemoved(subject, issuer, id, key, now);
127     }
128 }