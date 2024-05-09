1 pragma solidity 0.4.6;
2 
3 contract Owned {
4     address public contractOwner;
5     address public pendingContractOwner;
6 
7     function Owned() {
8         contractOwner = msg.sender;
9     }
10 
11     modifier onlyContractOwner() {
12         if (contractOwner == msg.sender) {
13             _;
14         }
15     }
16 
17     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
18         pendingContractOwner = _to;
19         return true;
20     }
21 
22     function claimContractOwnership() returns(bool) {
23         if (pendingContractOwner != msg.sender) {
24             return false;
25         }
26         contractOwner = pendingContractOwner;
27         delete pendingContractOwner;
28         return true;
29     }
30 }
31 
32 contract PropyPrototype is Owned {
33     struct IdentityProvider {
34         string metadata;
35     }
36 
37     struct Owner {
38         uint identityVerificationId;
39         address identityVerificationProvider;
40         bool status; // unverified/verified
41         string metadata;
42     }
43 
44     struct Title {
45         string legalAddress;
46         bytes32 ownerId;
47         bytes32 lastDeedId;
48         bool status; // executed/pending
49         string metadata;
50     }
51 
52     struct Deed {
53         bytes32 titleId;
54         bytes32 buyerId;
55         bytes32 sellerId;
56         uint status; // in progress/notarized/cancelled
57         string metadata;
58     }
59 
60     mapping(address => IdentityProvider) identityProviders;
61     mapping(bytes32 => Owner) owners;
62     mapping(bytes32 => Title) titles;
63     bytes32[] public titleIds;
64     mapping(bytes32 => Deed) deeds;
65     bytes32[] public deedIds;
66 
67     function putIdentityProvider(address _address, string _metadata) onlyContractOwner() returns(bool success) {
68         identityProviders[_address].metadata = _metadata;
69         return true;
70     }
71 
72     function getIdentityProvider(address _address) constant returns(string metadata) {
73         return identityProviders[_address].metadata;
74     }
75 
76     function putOwner(bytes32 _id, uint _identityVerificationId, address _identityVerificationProvider, bool _status, string _metadata) onlyContractOwner() returns(bool success) {
77         owners[_id] = Owner(_identityVerificationId, _identityVerificationProvider, _status, _metadata);
78         return true;
79     }
80 
81     function getOwner(bytes32 _id) constant returns(uint identityVerificationId, string identityProvider, string status, string metadata) {
82         var owner = owners[_id];
83         return (
84             owner.identityVerificationId,
85             getIdentityProvider(owner.identityVerificationProvider),
86             owner.status ? "Verified" : "Unverified",
87             owner.metadata
88         );
89     }
90 
91     function putTitle(bytes32 _id, string _legalAddress, bytes32 _ownerId, bytes32 _lastDeedId, bool _status, string _metadata) onlyContractOwner() returns(bool success) {
92         if (bytes(_legalAddress).length == 0) {
93             return false;
94         }
95         if (owners[_ownerId].identityVerificationProvider == 0x0) {
96             return false;
97         }
98         if (bytes(titles[_id].legalAddress).length == 0) {
99             titleIds.push(_id);
100         }
101         titles[_id] = Title(_legalAddress, _ownerId, _lastDeedId, _status, _metadata);
102         return true;
103     }
104 
105     function getTitle(bytes32 _id) constant returns(string legalAddress, bytes32 ownerId, string owner, bytes32 lastDeedId, string lastDeed, string status, string metadata) {
106         var title = titles[_id];
107         return (
108             title.legalAddress,
109             title.ownerId,
110             owners[title.ownerId].metadata,
111             title.lastDeedId,
112             deeds[title.lastDeedId].metadata,
113             title.status ? "Executed" : "Pending",
114             title.metadata
115         );
116     }
117 
118     function getDeedId(bytes32 _titleId, uint _index) constant returns(bytes32) {
119         return sha3(_titleId, _index);
120     }
121 
122     function putDeed(bytes32 _titleId, uint _index, bytes32 _buyerId, bytes32 _sellerId, uint _status, string _metadata) onlyContractOwner() returns(bool success) {
123         if (bytes(titles[_titleId].legalAddress).length == 0) {
124             return false;
125         }
126         if (owners[_buyerId].identityVerificationProvider == 0x0) {
127             return false;
128         }
129         if (owners[_sellerId].identityVerificationProvider == 0x0) {
130             return false;
131         }
132         if (_status > 2) {
133             return false;
134         }
135         bytes32 id = getDeedId(_titleId, _index);
136         if (uint(deeds[id].titleId) == 0) {
137             deedIds.push(id);
138         }
139         deeds[id] = Deed(_titleId, _buyerId, _sellerId, _status, _metadata);
140         return true;
141     }
142 
143     function getDeed(bytes32 _id) constant returns(bytes32 titleId, string title, bytes32 buyerId, string buyer, bytes32 sellerId, string seller, string status, string metadata) {
144         var deed = deeds[_id];
145         return (
146             deed.titleId,
147             titles[deed.titleId].metadata,
148             deed.buyerId,
149             owners[deed.buyerId].metadata,
150             deed.sellerId,
151             owners[deed.sellerId].metadata,
152             deed.status == 0 ? "In Progress" :
153                 deed.status == 1 ? "Notarized" : "Cancelled",
154             deed.metadata
155         );
156     }
157 
158     // Should not be used in non constant functions!
159     function getTitleDeeds(bytes32 _titleId) constant returns(bytes32[]) {
160         uint deedsCount = 0;
161         while(uint(deeds[getDeedId(_titleId, deedsCount)].titleId) != 0) {
162             deedsCount++;
163         }
164         bytes32[] memory result = new bytes32[](deedsCount);
165         for (uint i = 0; i < deedsCount; i++) {
166             result[i] = getDeedId(_titleId, i);
167         }
168         return result;
169     }
170 }