1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Contains the history of all relevant historic events in the vehicle lifecycle.
5  */
6 contract History  {
7 
8     // The creator of this contract. This address can authorize Mechanics, Insurers, Car-Dealers etc
9     // to log events.
10     address owner;
11 
12     // Currently 3 types suported. More to come soon.
13     enum EventType { NewOwner, Maintenance, DamageRepair }
14 
15     // List of addresses controlled by Mechanics, Insurers, Car-Dealers etc. that are 
16     // Authorized to log events this Vehicle-History-Log.
17     mapping(address => bool) public authorizedLoggers;
18 
19     // This event is broadcasted when a new maintenance event is logged.
20     event EventLogged(string vin, EventType eventType, uint256 mileage, address verifier);
21 
22     // The event is broadcasted when a new logger is authorized to log events.
23     event LoggerAuthorized(address loggerAddress);
24 
25     struct LedgerEvent {
26         
27         uint256 creationTime;
28         uint256 mileage; 
29         uint256 repairOrderNumber;
30         address verifier; 
31         EventType eventType;
32         string description;   
33     }
34 
35     mapping (bytes32 => LedgerEvent[]) events;
36 
37     /**
38      * Set the owner.
39      */
40     function History() {
41         
42         owner = msg.sender; 
43     }
44 
45     /**
46      * Only allows addresses can call this function.
47      */
48     modifier onlyAuthorized {
49 
50         if (!authorizedLoggers[msg.sender])
51             throw;
52         _;
53     }
54 
55     /**
56      * Only owner can call this function.
57      */
58      modifier onlyOwner {
59 
60         if (msg.sender != owner)
61             throw;
62         _;
63     }
64 
65 
66     /**
67      * Authorize the specified address to add evemnts to the historic log.
68      */
69     function authorize(address newLogger) onlyOwner {
70 
71         authorizedLoggers[newLogger] = true;
72         LoggerAuthorized(newLogger);
73     }
74 
75     /**
76      * Checks if the specified address is authorized to log events.
77      */
78     function isAuthorized(address logger) returns (bool) {
79 
80          return authorizedLoggers[logger];
81     }
82 
83     /**
84      * Add a historically significant event (i.e. maintenance, damage 
85      * repair or new owner).
86      */
87     function addEvent(uint256 _mileage, 
88                      uint256 _repairOrderNumber,
89                      EventType _eventType, 
90                      string _description, 
91                      string _vin) onlyAuthorized {
92 
93         events[sha3(_vin)].push(LedgerEvent({
94             creationTime: now,
95             mileage: _mileage,
96             repairOrderNumber: _repairOrderNumber,
97             verifier: msg.sender,
98             eventType: _eventType,
99             description: _description
100         }));
101         
102         EventLogged(_vin, _eventType, _mileage, msg.sender);
103     }
104     
105     /**
106      * Returns the number of events for a vin. (helper function for getEvent function)
107      */
108     function getEventsCount(string _vin) constant returns(uint256) {
109 
110         return events[sha3(_vin)].length;
111     }
112     
113     /**
114      * Returns the details of a specific event. To be used together with the function
115      * getEventsCount().
116      */
117     function getEvent(string _vin, uint256 _index) constant
118                 returns (uint256 mileage, address verifier, 
119                         EventType eventType, string description) {
120 
121         LedgerEvent memory e = events[sha3(_vin)][_index];
122         mileage = e.mileage;
123         verifier = e.verifier;
124         eventType = e.eventType;
125         description = e.description;
126     }
127 
128     /**
129      * Lifecycle management (Solidity best-practice).
130      */
131     function kill() onlyOwner { 
132 
133         selfdestruct(owner); 
134     }
135 
136     /**
137      * Fallback function (Solidity best-practice).
138      */
139     function() payable {}
140 }