1 pragma solidity ^0.4.17;
2 
3 contract SingleSourceAuthority {
4     // Struct and Enum
5     struct Authority {
6         bool valid;
7         address authorizedBy;
8         address revokedBy;
9         uint validFrom;
10         uint validTo;
11     }
12 
13     // Instance variables
14     address public rootAuthority;
15     mapping(address => Authority) public authorities;
16 
17     // Modifier
18     modifier restricted() {
19         if (msg.sender == rootAuthority)
20             _;
21     }
22 
23     // Init
24     function SingleSourceAuthority() public {
25         rootAuthority = msg.sender;
26     }
27 
28     // Functions
29     function changeRootAuthority(address newRootAuthorityAddress)
30       public
31       restricted()
32     {
33         rootAuthority = newRootAuthorityAddress;
34     }
35 
36     function isRootAuthority(address authorityAddress)
37       public
38       view
39       returns (bool)
40     {
41         if (authorityAddress == rootAuthority) {
42             return true;
43         } else {
44             return false;
45         }
46     }
47 
48     function isValidAuthority(address authorityAddress, uint blockNumber)
49       public
50       view
51       returns (bool)
52     {
53         Authority storage authority = authorities[authorityAddress];
54         if (authority.valid) {
55             if (authority.validFrom <= blockNumber && (authority.validTo == 0 || authority.validTo >= blockNumber)) {
56                 return true;
57             } else {
58                 return false;
59             }
60         } else {
61             return false;
62         }
63     }
64 
65     function approveAuthority(address authorityAddress) public restricted() {
66         Authority memory authority = Authority({
67             valid: true,
68             authorizedBy: msg.sender,
69             revokedBy: 0x0,
70             validFrom: block.number,
71             validTo: 0
72         });
73         authorities[authorityAddress] = authority;
74     }
75 
76     function revokeAuthority(address authorityAddress, uint blockNumber) public restricted() {
77         Authority storage authority = authorities[authorityAddress];
78         authority.revokedBy = msg.sender;
79         authority.validTo = blockNumber;
80     }
81 }