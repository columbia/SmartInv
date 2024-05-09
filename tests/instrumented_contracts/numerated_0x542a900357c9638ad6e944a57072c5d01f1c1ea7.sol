1 pragma solidity ^0.4.19;
2 
3 contract Love {
4 
5   mapping (address => address) private propose;
6   mapping (address => address) private partner;
7   mapping (uint256 => string[]) private partnerMessages;
8   mapping (uint256 => bool) private isHiddenMessages;
9   uint public proposeCount;
10   uint public partnerCount;
11 
12   event Propose(address indexed from, address indexed to);
13   event CancelPropose(address indexed from, address indexed to);
14   event Partner(address indexed from, address indexed to);
15   event Farewell(address indexed from, address indexed to);
16   event Message(address indexed addressOne, address indexed addressTwo, string message, uint index);
17   event HiddenMessages(address indexed addressOne, address indexed addressTwo, bool flag);
18 
19   function proposeTo(address to) public {
20     require(to != address(0));
21     require(msg.sender != to);
22     require(partner[msg.sender] != to);
23 
24     address alreadyPropose = propose[to];
25     if (alreadyPropose == msg.sender) {
26       propose[to] = address(0);
27       if (propose[msg.sender] != address(0)) {
28         propose[msg.sender] = address(0);
29         proposeCount -= 2;
30 
31       } else {
32         proposeCount--;
33       }
34 
35       address selfPartner = partner[msg.sender];
36       if (selfPartner != address(0)) {
37         if (partner[selfPartner] == msg.sender) {
38           partner[selfPartner] = address(0);
39           partnerCount--;
40           Farewell(msg.sender, selfPartner);
41         }
42       }
43       partner[msg.sender] = to;
44 
45       address targetPartner = partner[to];
46       if (targetPartner != address(0)) {
47         if (partner[targetPartner] == to) {
48           partner[targetPartner] = address(0);
49           partnerCount--;
50           Farewell(to, targetPartner);
51         }
52       }
53       partner[to] = msg.sender;
54 
55       partnerCount++;
56       Partner(msg.sender, to);
57 
58     } else {
59       if (propose[msg.sender] == address(0)) {
60         proposeCount++;
61       }
62       propose[msg.sender] = to;
63       Propose(msg.sender, to);
64     }
65   }
66 
67   function cancelProposeTo() public {
68     address proposingTo = propose[msg.sender];
69     require(proposingTo != address(0));
70     propose[msg.sender] = address(0);
71     proposeCount--;
72     CancelPropose(msg.sender, proposingTo);
73   }
74 
75   function addMessage(string message) public {
76     address target = partner[msg.sender];
77     require(isPartner(msg.sender, target) == true);
78     uint index = partnerMessages[uint256(keccak256(craetePartnerBytes(msg.sender, target)))].push(message) - 1;
79     Message(msg.sender, target, message, index);
80   }
81 
82   function farewellTo(address to) public {
83     require(partner[msg.sender] == to);
84     require(partner[to] == msg.sender);
85     partner[msg.sender] = address(0);
86     partner[to] = address(0);
87     partnerCount--;
88     Farewell(msg.sender, to);
89   }
90 
91   function isPartner(address a, address b) public view returns (bool) {
92     require(a != address(0));
93     require(b != address(0));
94     return (a == partner[b]) && (b == partner[a]);
95   }
96 
97   function getPropose(address a) public view returns (address) {
98     return propose[a];
99   }
100 
101   function getPartner(address a) public view returns (address) {
102     return partner[a];
103   }
104 
105   function getPartnerMessage(address a, address b, uint index) public view returns (string) {
106     require(isPartner(a, b) == true);
107     uint256 key = uint256(keccak256(craetePartnerBytes(a, b)));
108     if (isHiddenMessages[key] == true) {
109       require((msg.sender == a) || (msg.sender == b));
110     }
111     uint count = partnerMessages[key].length;
112     require(index < count);
113     return partnerMessages[key][index];
114   }
115 
116   function partnerMessagesCount(address a, address b) public view returns (uint) {
117     require(isPartner(a, b) == true);
118     uint256 key = uint256(keccak256(craetePartnerBytes(a, b)));
119     if (isHiddenMessages[key] == true) {
120       require((msg.sender == a) || (msg.sender == b));
121     }
122     return partnerMessages[key].length;
123   }
124 
125   function getOwnPartnerMessage(uint index) public view returns (string) {
126     return getPartnerMessage(msg.sender, partner[msg.sender], index);
127   }
128 
129   function craetePartnerBytes(address a, address b) private pure returns(bytes) {
130     bytes memory arr = new bytes(64);
131     bytes32 first;
132     bytes32 second;
133     if (uint160(a) < uint160(b)) {
134       first = keccak256(a);
135       second = keccak256(b);
136     } else {
137       first = keccak256(b);
138       second = keccak256(a);
139     }
140 
141     for (uint i = 0; i < 32; i++) {
142       arr[i] = first[i];
143       arr[i + 32] = second[i];
144     }
145     return arr;
146   }
147 
148   function setIsHiddenMessages(bool flag) public {
149     require(isPartner(msg.sender, partner[msg.sender]) == true);
150     uint256 key = uint256(keccak256(craetePartnerBytes(msg.sender, partner[msg.sender])));
151     isHiddenMessages[key] = flag;
152     HiddenMessages(msg.sender, partner[msg.sender], flag);
153   }
154 }