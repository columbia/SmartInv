1 pragma solidity 0.4.15;
2 
3 /// @title Ownable
4 /// @dev The Ownable contract has an owner address, and provides basic authorization control
5 /// functions, this simplifies the implementation of "user permissions".
6 contract Ownable {
7 
8   // EVENTS
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   // PUBLIC FUNCTIONS
13 
14   /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19   /// @dev Allows the current owner to transfer control of the contract to a newOwner.
20   /// @param newOwner The address to transfer ownership to.
21   function transferOwnership(address newOwner) onlyOwner public {
22     require(newOwner != address(0));
23     OwnershipTransferred(owner, newOwner);
24     owner = newOwner;
25   }
26 
27   // MODIFIERS
28 
29   /// @dev Throws if called by any account other than the owner.
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   // FIELDS
36 
37   address public owner;
38 }
39 
40 
41 contract DaoOwnable is Ownable{
42 
43     address public dao = address(0);
44 
45     event DaoOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Throws if called by any account other than the dao.
49      */
50     modifier onlyDao() {
51         require(msg.sender == dao);
52         _;
53     }
54 
55     modifier onlyDaoOrOwner() {
56         require(msg.sender == dao || msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newDao.
63      * @param newDao The address to transfer ownership to.
64      */
65     function transferDao(address newDao) onlyOwner {
66         require(newDao != address(0));
67         dao = newDao;
68         DaoOwnershipTransferred(owner, newDao);
69     }
70 
71 }
72 
73 contract SSPTypeAware {
74     enum SSPType { Gate, Direct }
75 }
76 
77 contract SSPRegistry is SSPTypeAware{
78     // This is the function that actually insert a record.
79     function register(address key, SSPType sspType, uint16 publisherFee, address recordOwner);
80 
81     // Updates the values of the given record.
82     function updatePublisherFee(address key, uint16 newFee, address sender);
83 
84     function applyKarmaDiff(address key, uint256[2] diff);
85 
86     // Unregister a given record
87     function unregister(address key, address sender);
88 
89     //Transfer ownership of record
90     function transfer(address key, address newOwner, address sender);
91 
92     function getOwner(address key) constant returns(address);
93 
94     // Tells whether a given key is registered.
95     function isRegistered(address key) constant returns(bool);
96 
97     function getSSP(address key) constant returns(address sspAddress, SSPType sspType, uint16 publisherFee, uint256[2] karma, address recordOwner);
98 
99     function getAllSSP() constant returns(address[] addresses, SSPType[] sspTypes, uint16[] publisherFees, uint256[2][] karmas, address[] recordOwners);
100 
101     function kill();
102 }
103 
104 
105 contract SSPRegistryImpl is SSPRegistry, DaoOwnable {
106 
107     uint public creationTime = now;
108 
109     // This struct keeps all data for a SSP.
110     struct SSP {
111         // Keeps the address of this record creator.
112         address owner;
113         // Keeps the time when this record was created.
114         uint time;
115         // Keeps the index of the keys array for fast lookup
116         uint keysIndex;
117         // SSP Address
118         address sspAddress;
119 
120         SSPType sspType;
121 
122         uint16 publisherFee;
123 
124         uint256[2] karma;
125     }
126 
127     // This mapping keeps the records of this Registry.
128     mapping(address => SSP) records;
129 
130     // Keeps the total numbers of records in this Registry.
131     uint public numRecords;
132 
133     // Keeps a list of all keys to interate the records.
134     address[] public keys;
135 
136     // This is the function that actually insert a record.
137     function register(address key, SSPType sspType, uint16 publisherFee, address recordOwner) onlyDaoOrOwner {
138         require(records[key].time == 0);
139         records[key].time = now;
140         records[key].owner = recordOwner;
141         records[key].keysIndex = keys.length;
142         records[key].sspAddress = key;
143         records[key].sspType = sspType;
144         records[key].publisherFee = publisherFee;
145         keys.length++;
146         keys[keys.length - 1] = key;
147         numRecords++;
148     }
149 
150     // Updates the values of the given record.
151     function updatePublisherFee(address key, uint16 newFee, address sender) onlyDaoOrOwner {
152         // Only the owner can update his record.
153         require(records[key].owner == sender);
154         records[key].publisherFee = newFee;
155     }
156 
157     function applyKarmaDiff(address key, uint256[2] diff) onlyDaoOrOwner {
158         SSP storage ssp = records[key];
159         ssp.karma[0] += diff[0];
160         ssp.karma[1] += diff[1];
161     }
162 
163     // Unregister a given record
164     function unregister(address key, address sender) onlyDaoOrOwner {
165         require(records[key].owner == sender);
166         uint keysIndex = records[key].keysIndex;
167         delete records[key];
168         numRecords--;
169         keys[keysIndex] = keys[keys.length - 1];
170         records[keys[keysIndex]].keysIndex = keysIndex;
171         keys.length--;
172     }
173 
174     // Transfer ownership of a given record.
175     function transfer(address key, address newOwner, address sender) onlyDaoOrOwner {
176         require(records[key].owner == sender);
177         records[key].owner = newOwner;
178     }
179 
180     // Tells whether a given key is registered.
181     function isRegistered(address key) constant returns(bool) {
182         return records[key].time != 0;
183     }
184 
185     function getSSP(address key) constant returns(address sspAddress, SSPType sspType, uint16 publisherFee, uint256[2] karma, address recordOwner) {
186         SSP storage record = records[key];
187         sspAddress = record.sspAddress;
188         sspType = record.sspType;
189         publisherFee = record.publisherFee;
190         karma = record.karma;
191         recordOwner = owner;
192     }
193 
194     // Returns the owner of the given record. The owner could also be get
195     // by using the function getSSP but in that case all record attributes
196     // are returned.
197     function getOwner(address key) constant returns(address) {
198         return records[key].owner;
199     }
200 
201     function getAllSSP() constant returns(address[] addresses, SSPType[] sspTypes, uint16[] publisherFees, uint256[2][] karmas, address[] recordOwners) {
202         addresses = new address[](numRecords);
203         sspTypes = new SSPType[](numRecords);
204         publisherFees = new uint16[](numRecords);
205         karmas = new uint256[2][](numRecords);
206         recordOwners = new address[](numRecords);
207         uint i;
208         for(i = 0; i < numRecords; i++) {
209             SSP storage ssp = records[keys[i]];
210             addresses[i] = ssp.sspAddress;
211             sspTypes[i] = ssp.sspType;
212             publisherFees[i] = ssp.publisherFee;
213             karmas[i] = ssp.karma;
214             recordOwners[i] = ssp.owner;
215         }
216     }
217 
218     // Returns the registration time of the given record. The time could also
219     // be get by using the function getSSP but in that case all record attributes
220     // are returned.
221     function getTime(address key) constant returns(uint) {
222         return records[key].time;
223     }
224 
225     function kill() onlyOwner {
226         selfdestruct(owner);
227     }
228 }