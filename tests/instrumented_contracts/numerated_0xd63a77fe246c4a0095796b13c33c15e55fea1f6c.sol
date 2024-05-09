1 pragma solidity ^0.4.24;
2 
3 // AddrSet is an address set based on http://solidity.readthedocs.io/en/develop/contracts.html#libraries
4 library AddrSet {
5     // We define a new struct datatype that will be used to
6     // hold its data in the calling contract.
7     struct Data { mapping(address => bool) flags; }
8 
9     // Note that the first parameter is of type "storage
10     // reference" and thus only its storage address and not
11     // its contents is passed as part of the call.  This is a
12     // special feature of library functions.  It is idiomatic
13     // to call the first parameter `self`, if the function can
14     // be seen as a method of that object.
15     function insert(Data storage self, address value) internal returns (bool) {
16         if (self.flags[value]) {
17             return false; // already there
18         }
19         self.flags[value] = true;
20         return true;
21     }
22 
23     function remove(Data storage self, address value) internal returns (bool) {
24         if (!self.flags[value]) {
25             return false; // not there
26         }
27         self.flags[value] = false;
28         return true;
29     }
30 
31     function contains(Data storage self, address value) internal view returns (bool) {
32         return self.flags[value];
33     }
34 }
35 
36 contract Owned {
37     
38     address public owner;
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address newOwner) public onlyOwner {
50         owner = newOwner;
51     }
52 }
53 
54 // Copyright 2017, 2018 Tensigma Ltd. All rights reserved.
55 // Use of this source code is governed by Microsoft Reference Source
56 // License (MS-RSL) that can be found in the LICENSE file.
57 
58 // KYC implements "Know Your Customer" storage for identity approvals by KYC providers.
59 contract KYC is Owned {
60 
61     // Status corresponding to the state of approvement:
62     // * Unknown when an address has not been processed yet;
63     // * Approved when an address has been approved by contract owner or 3rd party KYC provider;
64     // * Suspended means a temporary or permanent suspension of all operations, any KYC providers may
65     // set this status when account needs to be re-verified due to legal events or blocked because of fraud.
66     enum Status {
67         unknown,
68         approved,
69         suspended
70     }
71 
72     // Events emitted by this contract
73     event ProviderAdded(address indexed addr);
74     event ProviderRemoved(address indexed addr);
75     event AddrApproved(address indexed addr, address indexed by);
76     event AddrSuspended(address indexed addr, address indexed by);
77 
78     // Contract state
79     AddrSet.Data private kycProviders;
80     mapping(address => Status) public kycStatus;
81 
82     // registerProvider adds a new 3rd-party provider that is authorized to perform KYC.
83     function registerProvider(address addr) public onlyOwner {
84         require(AddrSet.insert(kycProviders, addr));
85         emit ProviderAdded(addr);
86     }
87 
88     // removeProvider removes a 3rd-party provider that was authorized to perform KYC.
89     function removeProvider(address addr) public onlyOwner {
90         require(AddrSet.remove(kycProviders, addr));
91         emit ProviderRemoved(addr);
92     }
93 
94     // isProvider returns true if the given address was authorized to perform KYC.
95     function isProvider(address addr) public view returns (bool) {
96         return addr == owner || AddrSet.contains(kycProviders, addr);
97     }
98 
99     // getStatus returns the KYC status for a given address.
100     function getStatus(address addr) public view returns (Status) {
101         return kycStatus[addr];
102     }
103 
104     // approveAddr sets the address status to Approved, see Status for details.
105     // Can be invoked by owner or authorized KYC providers only.
106     function approveAddr(address addr) public onlyAuthorized {
107         Status status = kycStatus[addr];
108         require(status != Status.approved);
109         kycStatus[addr] = Status.approved;
110         emit AddrApproved(addr, msg.sender);
111     }
112 
113     // suspendAddr sets the address status to Suspended, see Status for details.
114     // Can be invoked by owner or authorized KYC providers only.
115     function suspendAddr(address addr) public onlyAuthorized {
116         Status status = kycStatus[addr];
117         require(status != Status.suspended);
118         kycStatus[addr] = Status.suspended;
119         emit AddrSuspended(addr, msg.sender);
120     }
121 
122     // onlyAuthorized modifier restricts write access to contract owner and authorized KYC providers.
123     modifier onlyAuthorized() {
124         require(msg.sender == owner || AddrSet.contains(kycProviders, msg.sender));
125         _;
126     }
127 }