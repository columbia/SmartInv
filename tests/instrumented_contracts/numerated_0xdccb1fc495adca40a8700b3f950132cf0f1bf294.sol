1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.6.8;
3 
4 interface IENS {
5     function owner(bytes32 _node) external view returns (address);
6 }
7 
8 /**
9  * @title PublicationRoles
10  * @author MirrorXYZ
11  */
12 contract PublicationRoles {
13     // Immutable data
14     address public immutable ens;
15 
16     // Mutable data
17 
18     // A flat mapping of the hash of the ENS node with the contributor
19     // address to the hash of the role.
20     mapping(bytes32 => bytes32) public roles;
21 
22     // Modifiers
23 
24     modifier onlyPublicationOwner(bytes32 publicationNode) {
25         require(
26             ownsPublication(publicationNode, msg.sender),
27             "Sender must be publication owner"
28         );
29         _;
30     }
31 
32     // Events
33     event ModifiedRole(
34         bytes32 indexed publicationNode,
35         address indexed contributor,
36         string roleName
37     );
38 
39     // Constructor
40 
41     constructor(address ens_) public {
42         ens = ens_;
43     }
44 
45     // Modifies data.
46 
47     function modifyRole(
48         address contributor,
49         // sha256(dev.mirror.xyz)
50         bytes32 publicationNode,
51         string calldata roleName
52     ) external onlyPublicationOwner(publicationNode) {
53         bytes32 role = encodeRole(roleName);
54         roles[getContributorId(contributor, publicationNode)] = role;
55 
56         emit ModifiedRole(publicationNode, contributor, roleName);
57     }
58 
59     function getContributorId(
60         address contributor,
61         // sha256(dev.mirror.xyz)
62         bytes32 publicationNode
63     ) public pure returns (bytes32) {
64         return keccak256(abi.encodePacked(contributor, publicationNode));
65     }
66 
67     function getRole(address contributor, bytes32 publicationNode)
68         external
69         view
70         returns (bytes32)
71     {
72         return roles[getContributorId(contributor, publicationNode)];
73     }
74 
75     // Convenient for encoding roles consistently.
76     function encodeRole(string memory roleName) public pure returns (bytes32) {
77         return keccak256(abi.encodePacked(roleName));
78     }
79 
80     function ownsPublication(bytes32 publicationNode, address account)
81         public
82         view
83         returns (bool)
84     {
85         return publicationOwner(publicationNode) == account;
86     }
87 
88     function publicationOwner(bytes32 publicationNode)
89         public
90         view
91         returns (address)
92     {
93         return IENS(ens).owner(publicationNode);
94     }
95 }