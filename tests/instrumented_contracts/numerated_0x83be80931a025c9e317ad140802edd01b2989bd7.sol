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
73 contract DSPTypeAware {
74     enum DSPType { Gate, Direct }
75 }
76 
77 contract DSPRegistry is DSPTypeAware{
78     // This is the function that actually insert a record.
79     function register(address key, DSPType dspType, bytes32[5] url, address recordOwner);
80 
81     // Updates the values of the given record.
82     function updateUrl(address key, bytes32[5] url, address sender);
83 
84     function applyKarmaDiff(address key, uint256[2] diff);
85 
86     // Unregister a given record
87     function unregister(address key, address sender);
88 
89     // Transfer ownership of a given record.
90     function transfer(address key, address newOwner, address sender);
91 
92     function getOwner(address key) constant returns(address);
93 
94     // Tells whether a given key is registered.
95     function isRegistered(address key) constant returns(bool);
96 
97     function getDSP(address key) constant returns(address dspAddress, DSPType dspType, bytes32[5] url, uint256[2] karma, address recordOwner);
98 
99     //@dev Get list of all registered dsp
100     //@return Returns array of addresses registered as DSP with register times
101     function getAllDSP() constant returns(address[] addresses, DSPType[] dspTypes, bytes32[5][] urls, uint256[2][] karmas, address[] recordOwners) ;
102 
103     function kill();
104 }
105 
106 contract DSPRegistryImpl is DSPRegistry, DaoOwnable {
107 
108     uint public creationTime = now;
109 
110     // This struct keeps all data for a DSP.
111     struct DSP {
112         // Keeps the address of this record creator.
113         address owner;
114         // Keeps the time when this record was created.
115         uint time;
116         // Keeps the index of the keys array for fast lookup
117         uint keysIndex;
118         // DSP Address
119         address dspAddress;
120 
121         DSPType dspType;
122 
123         bytes32[5] url;
124 
125         uint256[2] karma;
126     }
127 
128     // This mapping keeps the records of this Registry.
129     mapping(address => DSP) records;
130 
131     // Keeps the total numbers of records in this Registry.
132     uint public numRecords;
133 
134     // Keeps a list of all keys to interate the records.
135     address[] public keys;
136 
137     // This is the function that actually insert a record.
138     function register(address key, DSPType dspType, bytes32[5] url, address recordOwner) onlyDaoOrOwner {
139         require(records[key].time == 0);
140         records[key].time = now;
141         records[key].owner = recordOwner;
142         records[key].keysIndex = keys.length;
143         records[key].dspAddress = key;
144         records[key].dspType = dspType;
145         records[key].url = url;
146         keys.length++;
147         keys[keys.length - 1] = key;
148         numRecords++;
149     }
150 
151     // Updates the values of the given record.
152     function updateUrl(address key, bytes32[5] url, address sender) onlyDaoOrOwner {
153         // Only the owner can update his record.
154         require(records[key].owner == sender);
155         records[key].url = url;
156     }
157 
158     function applyKarmaDiff(address key, uint256[2] diff) onlyDaoOrOwner{
159         DSP storage dsp = records[key];
160         dsp.karma[0] += diff[0];
161         dsp.karma[1] += diff[1];
162     }
163 
164     // Unregister a given record
165     function unregister(address key, address sender) onlyDaoOrOwner {
166         require(records[key].owner == sender);
167         uint keysIndex = records[key].keysIndex;
168         delete records[key];
169         numRecords--;
170         keys[keysIndex] = keys[keys.length - 1];
171         records[keys[keysIndex]].keysIndex = keysIndex;
172         keys.length--;
173 
174     }
175 
176     // Transfer ownership of a given record.
177     function transfer(address key, address newOwner, address sender) onlyDaoOrOwner {
178         require(records[key].owner == sender);
179         records[key].owner = newOwner;
180     }
181 
182     // Tells whether a given key is registered.
183     function isRegistered(address key) constant returns(bool) {
184         return records[key].time != 0;
185     }
186 
187     function getDSP(address key) constant returns(address dspAddress, DSPType dspType, bytes32[5] url, uint256[2] karma, address recordOwner) {
188         DSP storage record = records[key];
189         dspAddress = record.dspAddress;
190         url = record.url;
191         dspType = record.dspType;
192         karma = record.karma;
193         recordOwner = record.owner;
194     }
195 
196     // Returns the owner of the given record. The owner could also be get
197     // by using the function getDSP but in that case all record attributes
198     // are returned.
199     function getOwner(address key) constant returns(address) {
200         return records[key].owner;
201     }
202 
203     // Returns the registration time of the given record. The time could also
204     // be get by using the function getDSP but in that case all record attributes
205     // are returned.
206     function getTime(address key) constant returns(uint) {
207         return records[key].time;
208     }
209 
210     //@dev Get list of all registered dsp
211     //@return Returns array of addresses registered as DSP with register times
212     function getAllDSP() constant returns(address[] addresses, DSPType[] dspTypes, bytes32[5][] urls, uint256[2][] karmas, address[] recordOwners) {
213         addresses = new address[](numRecords);
214         dspTypes = new DSPType[](numRecords);
215         urls = new bytes32[5][](numRecords);
216         karmas = new uint256[2][](numRecords);
217         recordOwners = new address[](numRecords);
218         uint i;
219         for(i = 0; i < numRecords; i++) {
220             DSP storage dsp = records[keys[i]];
221             addresses[i] = dsp.dspAddress;
222             dspTypes[i] = dsp.dspType;
223             urls[i] = dsp.url;
224             karmas[i] = dsp.karma;
225             recordOwners[i] = dsp.owner;
226         }
227     }
228 
229     function kill() onlyOwner {
230         selfdestruct(owner);
231     }
232 }