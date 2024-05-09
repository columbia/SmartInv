1 contract GameRegistry {
2 
3     // This struct keeps all data for a Record.
4     struct Record {
5         // Keeps the address of this record creator.
6         address owner;
7         // Keeps the time when this record was created.
8         uint time;
9         // Keeps the index of the keys array for fast lookup
10         uint keysIndex;
11         string description;
12         string url;
13     }
14 
15     // This mapping keeps the records of this Registry.
16     mapping(address => Record) private records;
17 
18     // Keeps the total numbers of records in this Registry.
19     uint private numRecords;
20 
21     // Keeps a list of all keys to interate the recoreds.
22     address[] private keys;
23 
24     // The owner of this registry.
25     address private owner;
26 
27     uint private KEY_HOLDER_SHARE  = 50;
28     uint private REGISTRATION_COST = 500 finney;
29     uint private TRANSFER_COST     = 0;
30 
31     // Constructor
32     function GameRegistry() {
33         owner = msg.sender;
34     }
35     
36     // public interface to the directory of games
37     function theGames(uint rindex) constant returns(address contractAddress, string description, string url, address submittedBy, uint time) {
38         Record record = records[keys[rindex]];
39         contractAddress = keys[rindex];
40         description = record.description;
41         url = record.url;
42         submittedBy = record.owner;
43         time = record.time;
44     }
45 
46     function settings() constant public returns(uint registrationCost, uint percentSharedWithKeyHolders) {
47         registrationCost            = REGISTRATION_COST / 1 finney;
48         percentSharedWithKeyHolders = KEY_HOLDER_SHARE;
49     }
50 
51     function distributeValue() private {
52         if (msg.value == 0) {
53             return;
54         }
55         // share value with all key holders
56         uint ownerPercentage  = 100 - KEY_HOLDER_SHARE;
57         uint valueForRegOwner = (ownerPercentage * msg.value) / 100;
58         owner.send(valueForRegOwner);
59         uint valueForEachOwner = (msg.value - valueForRegOwner) / numRecords;
60         if (valueForEachOwner <= 0) {
61             return;
62         }
63         for (uint k = 0; k < numRecords; k++) {
64             records[keys[k]].owner.send(valueForEachOwner);
65         }
66     }
67 
68     // This is the function that actually inserts a record. 
69     function addGame(address key, string description, string url) {
70         // Only allow registration if received value >= REGISTRATION_COST
71         if (msg.value < REGISTRATION_COST) {
72             // Return value back to sender.
73             if (msg.value > 0) {
74                 msg.sender.send(msg.value);
75             }
76             return;
77         }
78         distributeValue();
79         if (records[key].time == 0) {
80             records[key].time = now;
81             records[key].owner = msg.sender;
82             records[key].keysIndex = keys.length;
83             keys.length++;
84             keys[keys.length - 1] = key;
85             records[key].description = description;
86             records[key].url = url;
87 
88             numRecords++;
89         }
90     }
91 
92     function () { distributeValue(); }
93 
94     // Updates the values of the given record.
95     function update(address key, string description, string url) {
96         // Only the owner can update his record.
97         if (records[key].owner == msg.sender) {
98             records[key].description = description;
99             records[key].url = url;
100         }
101     }
102 
103 /*
104     // Transfer ownership of a given record.
105     function transfer(address key, address newOwner) {
106         // Only allow transfer if received value >= TRANSFER_COST
107         if (msg.value < TRANSFER_COST) {
108             // Return value back to sender
109             if (msg.value > 0) {
110                 msg.sender.send(msg.value);
111             }
112             return;
113         }
114         distributeValue();
115         if (records[key].owner == msg.sender) {
116             records[key].owner = newOwner;
117         }
118     }
119 */
120 
121     // Tells whether a given key is registered.
122     function isRegistered(address key) private constant returns(bool) {
123         return records[key].time != 0;
124     }
125 
126     function getRecord(address key) private constant returns(address owner, uint time, string description, string url) {
127         Record record = records[key];
128         owner = record.owner;
129         time = record.time;
130         description = record.description;
131         url = record.url;
132     }
133 
134     // Returns the owner of the given record. The owner could also be get
135     // by using the function getRecord but in that case all record attributes 
136     // are returned.
137     function getOwner(address key) private constant returns(address) {
138         return records[key].owner;
139     }
140 
141     // Returns the registration time of the given record. The time could also
142     // be get by using the function getRecord but in that case all record attributes
143     // are returned.
144     function getTime(address key) private constant returns(uint) {
145         return records[key].time;
146     }
147 
148     // Registry owner can use this function to withdraw any surplus value owned by
149     // the registry.
150     function maintain(uint value, uint cost) {
151         if (msg.sender == owner) {
152             msg.sender.send(value);
153             REGISTRATION_COST = cost;
154         }
155     }
156 
157     // Returns the total number of records in this registry.
158     function getTotalRecords() private constant returns(uint) {
159         return numRecords;
160     }
161 
162     // This function is used by subcontracts when an error is detected and
163     // the value needs to be returned to the transaction originator.
164     function returnValue() internal {
165         if (msg.value > 0) {
166             msg.sender.send(msg.value);
167         }
168     }
169 
170 }