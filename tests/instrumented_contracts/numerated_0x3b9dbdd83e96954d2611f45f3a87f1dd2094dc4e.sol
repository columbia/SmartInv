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
73 contract PublisherRegistry {
74     // This is the function that actually insert a record.
75     function register(address key, bytes32[5] url, address recordOwner);
76 
77     // Updates the values of the given record.
78     function updateUrl(address key, bytes32[5] url, address sender);
79 
80     function applyKarmaDiff(address key, uint256[2] diff);
81 
82     // Unregister a given record
83     function unregister(address key, address sender);
84 
85     //Transfer ownership of record
86     function transfer(address key, address newOwner, address sender);
87 
88     function getOwner(address key) constant returns(address);
89 
90     // Tells whether a given key is registered.
91     function isRegistered(address key) constant returns(bool);
92 
93     function getPublisher(address key) constant returns(address publisherAddress, bytes32[5] url, uint256[2] karma, address recordOwner);
94 
95     //@dev Get list of all registered publishers
96     //@return Returns array of addresses registered as DSP with register times
97     function getAllPublishers() constant returns(address[] addresses, bytes32[5][] urls, uint256[2][] karmas, address[] recordOwners);
98 
99     function kill();
100 }
101 
102 contract PublisherRegistryImpl is PublisherRegistry, DaoOwnable{
103     // This struct keeps all data for a publisher.
104     struct Publisher {
105         // Keeps the address of this record creator.
106         address owner;
107         // Keeps the time when this record was created.
108         uint time;
109         // Keeps the index of the keys array for fast lookup
110         uint keysIndex;
111         // publisher Address
112         address publisherAddress;
113 
114         bytes32[5] url;
115 
116         uint256[2] karma;
117     }
118 
119     // This mapping keeps the records of this Registry.
120     mapping(address => Publisher) records;
121 
122     // Keeps the total numbers of records in this Registry.
123     uint public numRecords;
124 
125     // Keeps a list of all keys to interate the records.
126     address[] public keys;
127 
128     // This is the function that actually insert a record.
129     function register(address key, bytes32[5] url, address recordOwner) onlyDaoOrOwner {
130         require(records[key].time == 0);
131         records[key].time = now;
132         records[key].owner = recordOwner;
133         records[key].keysIndex = keys.length;
134         records[key].publisherAddress = key;
135         records[key].url = url;
136         keys.length++;
137         keys[keys.length - 1] = key;
138         numRecords++;
139     }
140 
141     // Updates the values of the given record.
142     function updateUrl(address key, bytes32[5] url, address sender) onlyDaoOrOwner {
143         // Only the owner can update his record.
144         require(records[key].owner == sender);
145         records[key].url = url;
146     }
147 
148 
149     function applyKarmaDiff(address key, uint256[2] diff) onlyDaoOrOwner {
150         Publisher storage publisher = records[key];
151         publisher.karma[0] += diff[0];
152         publisher.karma[1] += diff[1];
153     }
154 
155     // Unregister a given record
156     function unregister(address key, address sender) onlyDaoOrOwner {
157         require(records[key].owner == sender);
158         uint keysIndex = records[key].keysIndex;
159         delete records[key];
160         numRecords--;
161         keys[keysIndex] = keys[keys.length - 1];
162         records[keys[keysIndex]].keysIndex = keysIndex;
163         keys.length--;
164     }
165 
166     // Transfer ownership of a given record.
167     function transfer(address key, address newOwner, address sender) onlyDaoOrOwner {
168         require(records[key].owner == sender);
169         records[key].owner = newOwner;
170     }
171 
172     // Tells whether a given key is registered.
173     function isRegistered(address key) constant returns(bool) {
174         return records[key].time != 0;
175     }
176 
177     function getPublisher(address key) constant returns(address publisherAddress, bytes32[5] url, uint256[2] karma, address recordOwner) {
178         Publisher storage record = records[key];
179         publisherAddress = record.publisherAddress;
180         url = record.url;
181         karma = record.karma;
182         recordOwner = record.owner;
183     }
184 
185     // Returns the owner of the given record. The owner could also be get
186     // by using the function getDSP but in that case all record attributes
187     // are returned.
188     function getOwner(address key) constant returns(address) {
189         return records[key].owner;
190     }
191 
192     // Returns the registration time of the given record. The time could also
193     // be get by using the function getDSP but in that case all record attributes
194     // are returned.
195     function getTime(address key) constant returns(uint) {
196         return records[key].time;
197     }
198 
199     //@dev Get list of all registered publishers
200     //@return Returns array of addresses registered as DSP with register times
201     function getAllPublishers() constant returns(address[] addresses, bytes32[5][] urls, uint256[2][] karmas, address[] recordOwners) {
202         addresses = new address[](numRecords);
203         urls = new bytes32[5][](numRecords);
204         karmas = new uint256[2][](numRecords);
205         recordOwners = new address[](numRecords);
206         uint i;
207         for(i = 0; i < numRecords; i++) {
208             Publisher storage publisher = records[keys[i]];
209             addresses[i] = publisher.publisherAddress;
210             urls[i] = publisher.url;
211             karmas[i] = publisher.karma;
212             recordOwners[i] = publisher.owner;
213         }
214     }
215 
216     function kill() onlyOwner {
217         selfdestruct(owner);
218     }
219 }