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