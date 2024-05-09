1 // Copyright (c) 2016 Chronicled, Inc. All rights reserved.
2 // http://explorer.chronicled.org
3 // http://demo.chronicled.org
4 // http://chronicled.org
5 
6 contract Registrar {
7     address public registrar;
8 
9     /**
10 
11     * Created event, gets triggered when a new registrant gets created
12     * event
13     * @param registrant - The registrant address.
14     * @param registrar - The registrar address.
15     * @param data - The data of the registrant.
16     */
17     event Created(address indexed registrant, address registrar, bytes data);
18 
19     /**
20     * Updated event, gets triggered when a new registrant id Updated
21     * event
22     * @param registrant - The registrant address.
23     * @param registrar - The registrar address.
24     * @param data - The data of the registrant.
25     */
26     event Updated(address indexed registrant, address registrar, bytes data, bool active);
27 
28     /**
29     * Error event.
30     * event
31     * @param code - The error code.
32     * 1: Permission denied.
33     * 2: Duplicate Registrant address.
34     * 3: No such Registrant.
35     */
36     event Error(uint code);
37 
38     struct Registrant {
39         address addr;
40         bytes data;
41         bool active;
42     }
43 
44     mapping(address => uint) public registrantIndex;
45     Registrant[] public registrants;
46 
47     /**
48     * Function can't have ether.
49     * modifier
50     */
51     modifier noEther() {
52         if (msg.value > 0) throw;
53         _;
54     }
55 
56     modifier isRegistrar() {
57       if (msg.sender != registrar) {
58         Error(1);
59         return;
60       }
61       else {
62         _;
63       }
64     }
65 
66     /**
67     * Construct registry with and starting registrants lenght of one, and registrar as msg.sender
68     * constructor
69     */
70     function Registrar() {
71         registrar = msg.sender;
72         registrants.length++;
73     }
74 
75     /**
76     * Add a registrant, only registrar allowed
77     * public_function
78     * @param _registrant - The registrant address.
79     * @param _data - The registrant data string.
80     */
81     function add(address _registrant, bytes _data) isRegistrar noEther returns (bool) {
82         if (registrantIndex[_registrant] > 0) {
83             Error(2); // Duplicate registrant
84             return false;
85         }
86         uint pos = registrants.length++;
87         registrants[pos] = Registrant(_registrant, _data, true);
88         registrantIndex[_registrant] = pos;
89         Created(_registrant, msg.sender, _data);
90         return true;
91     }
92 
93     /**
94     * Edit a registrant, only registrar allowed
95     * public_function
96     * @param _registrant - The registrant address.
97     * @param _data - The registrant data string.
98     */
99     function edit(address _registrant, bytes _data, bool _active) isRegistrar noEther returns (bool) {
100         if (registrantIndex[_registrant] == 0) {
101             Error(3); // No such registrant
102             return false;
103         }
104         Registrant registrant = registrants[registrantIndex[_registrant]];
105         registrant.data = _data;
106         registrant.active = _active;
107         Updated(_registrant, msg.sender, _data, _active);
108         return true;
109     }
110 
111     /**
112     * Set new registrar address, only registrar allowed
113     * public_function
114     * @param _registrar - The new registrar address.
115     */
116     function setNextRegistrar(address _registrar) isRegistrar noEther returns (bool) {
117         registrar = _registrar;
118         return true;
119     }
120 
121     /**
122     * Get if a regsitrant is active or not.
123     * constant_function
124     * @param _registrant - The registrant address.
125     */
126     function isActiveRegistrant(address _registrant) constant returns (bool) {
127         uint pos = registrantIndex[_registrant];
128         return (pos > 0 && registrants[pos].active);
129     }
130 
131     /**
132     * Get all the registrants.
133     * constant_function
134     */
135     function getRegistrants() constant returns (address[]) {
136         address[] memory result = new address[](registrants.length-1);
137         for (uint j = 1; j < registrants.length; j++) {
138             result[j-1] = registrants[j].addr;
139         }
140         return result;
141     }
142 
143     /**
144     * Function to reject value sends to the contract.
145     * fallback_function
146     */
147     function () noEther {}
148 
149     /**
150     * Desctruct the smart contract. Since this is first, alpha release of Open Registry for IoT, updated versions will follow.
151     * Registry's discontinue must be executed first.
152     */
153     function discontinue() isRegistrar noEther {
154       selfdestruct(msg.sender);
155     }
156 }