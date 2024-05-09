1 pragma solidity 0.4.19;
2 
3 
4 /// @title Ethereum Claims Registry - A repository storing claims issued
5 ///        from any Ethereum account to any other Ethereum account.
6 contract EthereumClaimsRegistry {
7 
8     mapping(address => mapping(address => mapping(bytes32 => bytes32))) public registry;
9 
10     event ClaimSet(
11         address indexed issuer,
12         address indexed subject,
13         bytes32 indexed key,
14         bytes32 value,
15         uint updatedAt);
16 
17     event ClaimRemoved(
18         address indexed issuer,
19         address indexed subject,
20         bytes32 indexed key,
21         uint removedAt);
22 
23     /// @dev Create or update a claim
24     /// @param subject The address the claim is being issued to
25     /// @param key The key used to identify the claim
26     /// @param value The data associated with the claim
27     function setClaim(address subject, bytes32 key, bytes32 value) public {
28         registry[msg.sender][subject][key] = value;
29         ClaimSet(msg.sender, subject, key, value, now);
30     }
31 
32     /// @dev Create or update a claim about yourself
33     /// @param key The key used to identify the claim
34     /// @param value The data associated with the claim
35     function setSelfClaim(bytes32 key, bytes32 value) public {
36         setClaim(msg.sender, key, value);
37     }
38 
39     /// @dev Allows to retrieve claims from other contracts as well as other off-chain interfaces
40     /// @param issuer The address of the issuer of the claim
41     /// @param subject The address to which the claim was issued to
42     /// @param key The key used to identify the claim
43     function getClaim(address issuer, address subject, bytes32 key) public constant returns(bytes32) {
44         return registry[issuer][subject][key];
45     }
46 
47     /// @dev Allows to remove a claims from the registry.
48     ///      This can only be done by the issuer or the subject of the claim.
49     /// @param issuer The address of the issuer of the claim
50     /// @param subject The address to which the claim was issued to
51     /// @param key The key used to identify the claim
52     function removeClaim(address issuer, address subject, bytes32 key) public {
53         require(msg.sender == issuer || msg.sender == subject);
54         require(registry[issuer][subject][key] != 0);
55         delete registry[issuer][subject][key];
56         ClaimRemoved(msg.sender, subject, key, now);
57     }
58 }
59 
60 
61 /// @title Revoke and Publish - an interface for publishing data and 
62 ///        rotating access to publish new data
63 contract RevokeAndPublish {
64 
65     event Revocation(
66         address indexed genesis,
67         address indexed from,
68         address indexed to,
69         uint updatedAt);
70 
71     mapping(address => address) public manager;
72     EthereumClaimsRegistry registry = EthereumClaimsRegistry(0xAcA1BCd8D0f5A9BFC95aFF331Da4c250CD9ac2Da);
73 
74     function revokeAndPublish(address genesis, bytes32 key, bytes32 data, address newManager) public {
75         publish(genesis, key, data);
76         Revocation(genesis, manager[genesis], newManager, now);
77         manager[genesis] = newManager;
78     }
79 
80     /// @dev Publish some data
81     /// @param genesis The address of the first publisher
82     /// @param key The key used to identify the claim
83     /// @param data The data associated with the claim
84     function publish(address genesis, bytes32 key, bytes32 data) public {
85         require((manager[genesis] == 0x0 && genesis == msg.sender) || manager[genesis] == msg.sender);
86         registry.setClaim(genesis, key, data);
87     }
88 
89     /// @dev Lookup the currently published data for genesis
90     /// @param genesis The address of the first publisher
91     /// @param key The key used to identify the claim
92     function lookup(address genesis, bytes32 key) public constant returns(bytes32) {
93       return registry.getClaim(address(this), genesis, key);
94     }
95 }