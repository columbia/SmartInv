1 pragma solidity 0.4.15;
2 
3 
4 contract Owned {
5     address public owner;
6     modifier onlyOwner() {
7         require(isOwner(msg.sender));
8         _;
9     }
10 
11     function Owned() { owner = msg.sender; }
12 
13     function isOwner(address addr) public returns(bool) { return addr == owner; }
14 
15     function transfer(address newOwner) public onlyOwner {
16         if (newOwner != address(this)) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 contract Proxy is Owned {
23     event Forwarded (address indexed destination, uint value, bytes data);
24     event Received (address indexed sender, uint value);
25 
26     function () payable { Received(msg.sender, msg.value); }
27 
28     function forward(address destination, uint value, bytes data) public onlyOwner {
29         require(destination.call.value(value)(data));
30         Forwarded(destination, value, data);
31     }
32 }
33 
34 
35 contract MetaIdentityManager {
36     uint adminTimeLock;
37     uint userTimeLock;
38     uint adminRate;
39     address relay;
40 
41     event LogIdentityCreated(
42         address indexed identity,
43         address indexed creator,
44         address owner,
45         address indexed recoveryKey);
46 
47     event LogOwnerAdded(
48         address indexed identity,
49         address indexed owner,
50         address instigator);
51 
52     event LogOwnerRemoved(
53         address indexed identity,
54         address indexed owner,
55         address instigator);
56 
57     event LogRecoveryChanged(
58         address indexed identity,
59         address indexed recoveryKey,
60         address instigator);
61 
62     event LogMigrationInitiated(
63         address indexed identity,
64         address indexed newIdManager,
65         address instigator);
66 
67     event LogMigrationCanceled(
68         address indexed identity,
69         address indexed newIdManager,
70         address instigator);
71 
72     event LogMigrationFinalized(
73         address indexed identity,
74         address indexed newIdManager,
75         address instigator);
76 
77     mapping(address => mapping(address => uint)) owners;
78     mapping(address => address) recoveryKeys;
79     mapping(address => mapping(address => uint)) limiter;
80     mapping(address => uint) public migrationInitiated;
81     mapping(address => address) public migrationNewAddress;
82 
83     modifier onlyAuthorized() {
84         require(msg.sender == relay || checkMessageData(msg.sender));
85         _;
86     }
87 
88     modifier onlyOwner(address identity, address sender) {
89         require(isOwner(identity, sender));
90         _;
91     }
92 
93     modifier onlyOlderOwner(address identity, address sender) {
94         require(isOlderOwner(identity, sender));
95         _;
96     }
97 
98     modifier onlyRecovery(address identity, address sender) {
99         require(recoveryKeys[identity] == sender);
100         _;
101     }
102 
103     modifier rateLimited(Proxy identity, address sender) {
104         require(limiter[identity][sender] < (now - adminRate));
105         limiter[identity][sender] = now;
106         _;
107     }
108 
109     modifier validAddress(address addr) { //protects against some weird attacks
110         require(addr != address(0));
111         _;
112     }
113 
114     /// @dev Contract constructor sets initial timelocks and meta-tx relay address
115     /// @param _userTimeLock Time before new owner added by recovery can control proxy
116     /// @param _adminTimeLock Time before new owner can add/remove owners
117     /// @param _adminRate Time period used for rate limiting a given key for admin functionality
118     /// @param _relayAddress Address of meta transaction relay contract
119     function MetaIdentityManager(uint _userTimeLock, uint _adminTimeLock, uint _adminRate, address _relayAddress) {
120         require(_adminTimeLock >= _userTimeLock);
121         adminTimeLock = _adminTimeLock;
122         userTimeLock = _userTimeLock;
123         adminRate = _adminRate;
124         relay = _relayAddress;
125     }
126 
127     /// @dev Creates a new proxy contract for an owner and recovery
128     /// @param owner Key who can use this contract to control proxy. Given full power
129     /// @param recoveryKey Key of recovery network or address from seed to recovery proxy
130     /// Gas cost of ~300,000
131     function createIdentity(address owner, address recoveryKey) public validAddress(recoveryKey) {
132         Proxy identity = new Proxy();
133         owners[identity][owner] = now - adminTimeLock; // This is to ensure original owner has full power from day one
134         recoveryKeys[identity] = recoveryKey;
135         LogIdentityCreated(identity, msg.sender, owner,  recoveryKey);
136     }
137 
138     /// @dev Creates a new proxy contract for an owner and recovery and allows an initial forward call which would be to set the registry in our case
139     /// @param owner Key who can use this contract to control proxy. Given full power
140     /// @param recoveryKey Key of recovery network or address from seed to recovery proxy
141     /// @param destination Address of contract to be called after proxy is created
142     /// @param data of function to be called at the destination contract
143     function createIdentityWithCall(address owner, address recoveryKey, address destination, bytes data) public validAddress(recoveryKey) {
144         Proxy identity = new Proxy();
145         owners[identity][owner] = now - adminTimeLock; // This is to ensure original owner has full power from day one
146         recoveryKeys[identity] = recoveryKey;
147         LogIdentityCreated(identity, msg.sender, owner,  recoveryKey);
148         identity.forward(destination, 0, data);
149     }
150 
151     /// @dev Allows a user to transfer control of existing proxy to this contract. Must come through proxy
152     /// @param owner Key who can use this contract to control proxy. Given full power
153     /// @param recoveryKey Key of recovery network or address from seed to recovery proxy
154     /// Note: User must change owner of proxy to this contract after calling this
155     function registerIdentity(address owner, address recoveryKey) public validAddress(recoveryKey) {
156         require(recoveryKeys[msg.sender] == 0); // Deny any funny business
157         owners[msg.sender][owner] = now - adminTimeLock; // Owner has full power from day one
158         recoveryKeys[msg.sender] = recoveryKey;
159         LogIdentityCreated(msg.sender, msg.sender, owner, recoveryKey);
160     }
161 
162     /// @dev Allows a user to forward a call through their proxy.
163     function forwardTo(address sender, Proxy identity, address destination, uint value, bytes data) public
164         onlyAuthorized
165         onlyOwner(identity, sender)
166     {
167         identity.forward(destination, value, data);
168     }
169 
170     /// @dev Allows an olderOwner to add a new owner instantly
171     function addOwner(address sender, Proxy identity, address newOwner) public
172         onlyAuthorized
173         onlyOlderOwner(identity, sender)
174         rateLimited(identity, sender)
175     {
176         require(!isOwner(identity, newOwner));
177         owners[identity][newOwner] = now - userTimeLock;
178         LogOwnerAdded(identity, newOwner, sender);
179     }
180 
181     /// @dev Allows a recoveryKey to add a new owner with userTimeLock waiting time
182     function addOwnerFromRecovery(address sender, Proxy identity, address newOwner) public
183         onlyAuthorized
184         onlyRecovery(identity, sender)
185         rateLimited(identity, sender)
186     {
187         require(!isOwner(identity, newOwner));
188         owners[identity][newOwner] = now;
189         LogOwnerAdded(identity, newOwner, sender);
190     }
191 
192     /// @dev Allows an owner to remove another owner instantly
193     function removeOwner(address sender, Proxy identity, address owner) public
194         onlyAuthorized
195         onlyOlderOwner(identity, sender)
196         rateLimited(identity, sender)
197     {
198         // an owner should not be allowed to remove itself
199         require(sender != owner);
200         delete owners[identity][owner];
201         LogOwnerRemoved(identity, owner, sender);
202     }
203 
204     /// @dev Allows an owner to change the recoveryKey instantly
205     function changeRecovery(address sender, Proxy identity, address recoveryKey) public
206         onlyAuthorized
207         onlyOlderOwner(identity, sender)
208         rateLimited(identity, sender)
209         validAddress(recoveryKey)
210     {
211         recoveryKeys[identity] = recoveryKey;
212         LogRecoveryChanged(identity, recoveryKey, sender);
213     }
214 
215     /// @dev Allows an owner to begin process of transfering proxy to new IdentityManager
216     function initiateMigration(address sender, Proxy identity, address newIdManager) public
217         onlyAuthorized
218         onlyOlderOwner(identity, sender)
219     {
220         migrationInitiated[identity] = now;
221         migrationNewAddress[identity] = newIdManager;
222         LogMigrationInitiated(identity, newIdManager, sender);
223     }
224 
225     /// @dev Allows an owner to cancel the process of transfering proxy to new IdentityManager
226     function cancelMigration(address sender, Proxy identity) public
227         onlyAuthorized
228         onlyOwner(identity, sender)
229     {
230         address canceledManager = migrationNewAddress[identity];
231         delete migrationInitiated[identity];
232         delete migrationNewAddress[identity];
233         LogMigrationCanceled(identity, canceledManager, sender);
234     }
235 
236     /// @dev Allows an owner to finalize and completly transfer proxy to new IdentityManager
237     /// Note: before transfering to a new address, make sure this address is "ready to recieve" the proxy.
238     /// Not doing so risks the proxy becoming stuck.
239     function finalizeMigration(address sender, Proxy identity) onlyAuthorized onlyOlderOwner(identity, sender) {
240         require(migrationInitiated[identity] != 0 && migrationInitiated[identity] + adminTimeLock < now);
241         address newIdManager = migrationNewAddress[identity];
242         delete migrationInitiated[identity];
243         delete migrationNewAddress[identity];
244         identity.transfer(newIdManager);
245         delete recoveryKeys[identity];
246         // We can only delete the owner that we know of. All other owners
247         // needs to be removed before a call to this method.
248         delete owners[identity][sender];
249         LogMigrationFinalized(identity, newIdManager, sender);
250     }
251 
252     //Checks that address a is the first input in msg.data.
253     //Has very minimal gas overhead.
254     function checkMessageData(address a) internal constant returns (bool t) {
255         if (msg.data.length < 36) return false;
256         assembly {
257             let mask := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
258             t := eq(a, and(mask, calldataload(4)))
259         }
260     }
261 
262     function isOwner(address identity, address owner) public constant returns (bool) {
263         return (owners[identity][owner] > 0 && (owners[identity][owner] + userTimeLock) <= now);
264     }
265 
266     function isOlderOwner(address identity, address owner) public constant returns (bool) {
267         return (owners[identity][owner] > 0 && (owners[identity][owner] + adminTimeLock) <= now);
268     }
269 
270     function isRecovery(address identity, address recoveryKey) public constant returns (bool) {
271         return recoveryKeys[identity] == recoveryKey;
272     }
273 }