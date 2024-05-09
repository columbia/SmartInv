1 pragma solidity ^0.4.2;
2 
3 contract ValentineRegistry {
4 
5     event LogValentineRequestCreated(string requesterName, string valentineName, string customMessage, address valentineAddress, address requesterAddress);
6     event LogRequestAccepted(address requesterAddress);
7 
8     struct Request {
9         string requesterName;
10         string valentineName;
11         string customMessage;
12         bool doesExist;
13         bool wasAccepted;
14         address valentineAddress;
15     }
16     address public owner;
17     // Requests maps requester addresses to the requests details
18     mapping (address => Request) private requests;
19     uint public numRequesters;
20     address[] public requesters;
21     address constant ADDRESS_NULL = 0;
22     uint constant MAX_CUSTOM_MESSAGE_LENGTH = 140;
23     uint constant MAX_NAME_LENGTH = 25;
24     uint constant COST = 0.1 ether;
25 
26     modifier restricted() {
27         if (msg.sender != owner)
28             throw;
29         _;
30     }
31     modifier costs(uint _amount) {
32         if (msg.value < _amount)
33             throw;
34         _;
35     }
36     modifier prohibitRequestUpdates() {
37         if (requests[msg.sender].doesExist)
38             throw;
39         _;
40     }
41 
42     function ValentineRegistry() {
43         owner = msg.sender;
44     }
45 
46     // Creates a valentine request that can only be accepted by the specified valentineAddress
47     function createTargetedValentineRequest(string requesterName, string valentineName,
48         string customMessage, address valentineAddress)
49         costs(COST)
50         prohibitRequestUpdates
51         payable
52         public {
53         createNewValentineRequest(requesterName, valentineName, customMessage, valentineAddress);
54     }
55 
56     // Creates a valentine request that can be fullfilled by any address
57     function createOpenValentineRequest(string requesterName, string valentineName, string customMessage)
58         costs(COST)
59         prohibitRequestUpdates
60         payable
61         public {
62         createNewValentineRequest(requesterName, valentineName, customMessage, ADDRESS_NULL);
63     }
64 
65     function createNewValentineRequest(string requesterName, string valentineName, string customMessage,
66         address valentineAddress)
67         internal {
68         if (bytes(requesterName).length > MAX_NAME_LENGTH || bytes(valentineName).length > MAX_NAME_LENGTH
69             || bytes(customMessage).length > MAX_CUSTOM_MESSAGE_LENGTH) {
70             throw; // invalid request
71         }
72         bool doesExist = true;
73         bool wasAccepted = false;
74         Request memory r = Request(requesterName, valentineName, customMessage, doesExist,
75         wasAccepted, valentineAddress);
76         requesters.push(msg.sender);
77         numRequesters++;
78         requests[msg.sender] = r;
79         LogValentineRequestCreated(requesterName, valentineName, customMessage, valentineAddress, msg.sender);
80     }
81 
82     function acceptValentineRequest(address requesterAddress) public {
83         Request request = requests[requesterAddress];
84         if (!request.doesExist) {
85             throw; // the request doesn't exist
86         }
87         request.wasAccepted = true;
88         LogRequestAccepted(requesterAddress);
89     }
90 
91     function getRequestByRequesterAddress(address requesterAddress) public returns (string, string, string, bool, address, address) {
92         Request r = requests[requesterAddress];
93         if (!r.doesExist) {
94             return ("", "", "", false, ADDRESS_NULL, ADDRESS_NULL);
95         }
96         return (r.requesterName, r.valentineName, r.customMessage, r.wasAccepted, r.valentineAddress, requesterAddress);
97     }
98 
99     function getRequestByIndex(uint index) public returns (string, string, string, bool, address, address) {
100         if (index >= requesters.length) {
101             throw;
102         }
103         address requesterAddress = requesters[index];
104         Request r = requests[requesterAddress];
105         return (r.requesterName, r.valentineName, r.customMessage, r.wasAccepted, r.valentineAddress, requesterAddress);
106     }
107 
108     function updateOwner(address newOwner)
109         restricted
110         public {
111         owner = newOwner;
112     }
113 
114     function cashout(address recipient)
115         restricted
116         public {
117         address contractAddress = this;
118         if (!recipient.send(contractAddress.balance)) {
119             throw;
120         }
121     }
122 }