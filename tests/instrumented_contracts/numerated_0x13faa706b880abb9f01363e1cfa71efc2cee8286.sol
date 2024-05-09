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
73 contract AuditorRegistry {
74     // This is the function that actually insert a record.
75     function register(address key, address recordOwner);
76 
77     function applyKarmaDiff(address key, uint256[2] diff);
78 
79     // Unregister a given record
80     function unregister(address key, address sender);
81 
82     //Transfer ownership of record
83     function transfer(address key, address newOwner, address sender);
84 
85     function getOwner(address key) constant returns(address);
86 
87     // Tells whether a given key is registered.
88     function isRegistered(address key) constant returns(bool);
89 
90     function getAuditor(address key) constant returns(address auditorAddress, uint256[2] karma, address recordOwner);
91 
92     //@dev Get list of all registered dsp
93     //@return Returns array of addresses registered as DSP with register times
94     function getAllAuditors() constant returns(address[] addresses, uint256[2][] karmas, address[] recordOwners);
95 
96     function kill();
97 }
98 
99 contract AuditorRegistryImpl is AuditorRegistry, DaoOwnable {
100 
101     uint public creationTime = now;
102 
103     // This struct keeps all data for a Auditor.
104     struct Auditor {
105         // Keeps the address of this record creator.
106         address owner;
107         // Keeps the time when this record was created.
108         uint time;
109         // Keeps the index of the keys array for fast lookup
110         uint keysIndex;
111         // Auditor Address
112         address auditorAddress;
113 
114         uint256[2] karma;
115     }
116 
117     // This mapping keeps the records of this Registry.
118     mapping(address => Auditor) records;
119 
120     // Keeps the total numbers of records in this Registry.
121     uint public numRecords;
122 
123     // Keeps a list of all keys to interate the records.
124     address[] public keys;
125 
126     // This is the function that actually insert a record.
127     function register(address key, address recordOwner) onlyDaoOrOwner {
128         require(records[key].time == 0);
129         records[key].time = now;
130         records[key].owner = recordOwner;
131         records[key].keysIndex = keys.length;
132         records[key].auditorAddress = key;
133         keys.length++;
134         keys[keys.length - 1] = key;
135         numRecords++;
136     }
137 
138     function applyKarmaDiff(address key, uint256[2] diff) onlyDaoOrOwner {
139         Auditor storage auditor = records[key];
140         auditor.karma[0] += diff[0];
141         auditor.karma[1] += diff[1];
142     }
143 
144     // Unregister a given record
145     function unregister(address key, address sender) onlyDaoOrOwner {
146         require(records[key].owner == sender);
147         uint keysIndex = records[key].keysIndex;
148         delete records[key];
149         numRecords--;
150         keys[keysIndex] = keys[keys.length - 1];
151         records[keys[keysIndex]].keysIndex = keysIndex;
152         keys.length--;
153     }
154 
155     // Transfer ownership of a given record.
156     function transfer(address key, address newOwner, address sender) onlyDaoOrOwner {
157         require(records[key].owner == sender);
158         records[key].owner = newOwner;
159     }
160 
161     // Tells whether a given key is registered.
162     function isRegistered(address key) constant returns(bool) {
163         return records[key].time != 0;
164     }
165 
166     function getAuditor(address key) constant returns(address auditorAddress, uint256[2] karma, address recordOwner) {
167         Auditor storage record = records[key];
168         auditorAddress = record.auditorAddress;
169         karma = record.karma;
170         recordOwner = record.owner;
171     }
172 
173     // Returns the owner of the given record. The owner could also be get
174     // by using the function getAuditor but in that case all record attributes
175     // are returned.
176     function getOwner(address key) constant returns(address) {
177         return records[key].owner;
178     }
179 
180     // Returns the registration time of the given record. The time could also
181     // be get by using the function getAuditor but in that case all record attributes
182     // are returned.
183     function getTime(address key) constant returns(uint) {
184         return records[key].time;
185     }
186 
187     //@dev Get list of all registered auditor
188     //@return Returns array of addresses registered as Auditor with register times
189     function getAllAuditors() constant returns(address[] addresses, uint256[2][] karmas, address[] recordOwners) {
190         addresses = new address[](numRecords);
191         karmas = new uint256[2][](numRecords);
192         recordOwners = new address[](numRecords);
193         uint i;
194         for(i = 0; i < numRecords; i++) {
195             Auditor storage auditor = records[keys[i]];
196             addresses[i] = auditor.auditorAddress;
197             karmas[i] = auditor.karma;
198             recordOwners[i] = auditor.owner;
199         }
200     }
201 
202     function kill() onlyOwner {
203         selfdestruct(owner);
204     }
205 }