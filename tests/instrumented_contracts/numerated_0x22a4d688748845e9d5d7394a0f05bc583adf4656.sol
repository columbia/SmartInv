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
34 contract IdentityManager {
35     uint adminTimeLock;
36     uint userTimeLock;
37     uint adminRate;
38 
39     event LogIdentityCreated(
40         address indexed identity,
41         address indexed creator,
42         address owner,
43         address indexed recoveryKey);
44 
45     event LogOwnerAdded(
46         address indexed identity,
47         address indexed owner,
48         address instigator);
49 
50     event LogOwnerRemoved(
51         address indexed identity,
52         address indexed owner,
53         address instigator);
54 
55     event LogRecoveryChanged(
56         address indexed identity,
57         address indexed recoveryKey,
58         address instigator);
59 
60     event LogMigrationInitiated(
61         address indexed identity,
62         address indexed newIdManager,
63         address instigator);
64 
65     event LogMigrationCanceled(
66         address indexed identity,
67         address indexed newIdManager,
68         address instigator);
69 
70     event LogMigrationFinalized(
71         address indexed identity,
72         address indexed newIdManager,
73         address instigator);
74 
75     mapping(address => mapping(address => uint)) owners;
76     mapping(address => address) recoveryKeys;
77     mapping(address => mapping(address => uint)) limiter;
78     mapping(address => uint) public migrationInitiated;
79     mapping(address => address) public migrationNewAddress;
80 
81     modifier onlyOwner(address identity) {
82         require(isOwner(identity, msg.sender));
83         _;
84     }
85 
86     modifier onlyOlderOwner(address identity) {
87         require(isOlderOwner(identity, msg.sender));
88         _;
89     }
90 
91     modifier onlyRecovery(address identity) {
92         require(recoveryKeys[identity] == msg.sender);
93         _;
94     }
95 
96     modifier rateLimited(address identity) {
97         require(limiter[identity][msg.sender] < (now - adminRate));
98         limiter[identity][msg.sender] = now;
99         _;
100     }
101 
102     modifier validAddress(address addr) { //protects against some weird attacks
103         require(addr != address(0));
104         _;
105     }
106 
107     /// @dev Contract constructor sets initial timelock limits
108     /// @param _userTimeLock Time before new owner added by recovery can control proxy
109     /// @param _adminTimeLock Time before new owner can add/remove owners
110     /// @param _adminRate Time period used for rate limiting a given key for admin functionality
111     function IdentityManager(uint _userTimeLock, uint _adminTimeLock, uint _adminRate) {
112         require(_adminTimeLock >= _userTimeLock);
113         adminTimeLock = _adminTimeLock;
114         userTimeLock = _userTimeLock;
115         adminRate = _adminRate;
116     }
117 
118     /// @dev Creates a new proxy contract for an owner and recovery
119     /// @param owner Key who can use this contract to control proxy. Given full power
120     /// @param recoveryKey Key of recovery network or address from seed to recovery proxy
121     /// Gas cost of 289,311
122     function createIdentity(address owner, address recoveryKey) public validAddress(recoveryKey) {
123         Proxy identity = new Proxy();
124         owners[identity][owner] = now - adminTimeLock; // This is to ensure original owner has full power from day one
125         recoveryKeys[identity] = recoveryKey;
126         LogIdentityCreated(identity, msg.sender, owner,  recoveryKey);
127     }
128 
129     /// @dev Creates a new proxy contract for an owner and recovery and allows an initial forward call which would be to set the registry in our case
130     /// @param owner Key who can use this contract to control proxy. Given full power
131     /// @param recoveryKey Key of recovery network or address from seed to recovery proxy
132     /// @param destination Address of contract to be called after proxy is created
133     /// @param data of function to be called at the destination contract
134     function createIdentityWithCall(address owner, address recoveryKey, address destination, bytes data) public validAddress(recoveryKey) {
135         Proxy identity = new Proxy();
136         owners[identity][owner] = now - adminTimeLock; // This is to ensure original owner has full power from day one
137         recoveryKeys[identity] = recoveryKey;
138         LogIdentityCreated(identity, msg.sender, owner,  recoveryKey);
139         identity.forward(destination, 0, data);
140     }
141 
142     /// @dev Allows a user to transfer control of existing proxy to this contract. Must come through proxy
143     /// @param owner Key who can use this contract to control proxy. Given full power
144     /// @param recoveryKey Key of recovery network or address from seed to recovery proxy
145     /// Note: User must change owner of proxy to this contract after calling this
146     function registerIdentity(address owner, address recoveryKey) public validAddress(recoveryKey) {
147         require(recoveryKeys[msg.sender] == 0); // Deny any funny business
148         owners[msg.sender][owner] = now - adminTimeLock; // This is to ensure original owner has full power from day one
149         recoveryKeys[msg.sender] = recoveryKey;
150         LogIdentityCreated(msg.sender, msg.sender, owner, recoveryKey);
151     }
152 
153     /// @dev Allows a user to forward a call through their proxy.
154     function forwardTo(Proxy identity, address destination, uint value, bytes data) public onlyOwner(identity) {
155         identity.forward(destination, value, data);
156     }
157 
158     /// @dev Allows an olderOwner to add a new owner instantly
159     function addOwner(Proxy identity, address newOwner) public onlyOlderOwner(identity) rateLimited(identity) {
160         require(!isOwner(identity, newOwner));
161         owners[identity][newOwner] = now - userTimeLock;
162         LogOwnerAdded(identity, newOwner, msg.sender);
163     }
164 
165     /// @dev Allows a recoveryKey to add a new owner with userTimeLock waiting time
166     function addOwnerFromRecovery(Proxy identity, address newOwner) public onlyRecovery(identity) rateLimited(identity) {
167         require(!isOwner(identity, newOwner));
168         owners[identity][newOwner] = now;
169         LogOwnerAdded(identity, newOwner, msg.sender);
170     }
171 
172     /// @dev Allows an owner to remove another owner instantly
173     function removeOwner(Proxy identity, address owner) public onlyOlderOwner(identity) rateLimited(identity) {
174         // an owner should not be allowed to remove itself
175         require(msg.sender != owner);
176         delete owners[identity][owner];
177         LogOwnerRemoved(identity, owner, msg.sender);
178     }
179 
180     /// @dev Allows an owner to change the recoveryKey instantly
181     function changeRecovery(Proxy identity, address recoveryKey) public
182         onlyOlderOwner(identity)
183         rateLimited(identity)
184         validAddress(recoveryKey)
185     {
186         recoveryKeys[identity] = recoveryKey;
187         LogRecoveryChanged(identity, recoveryKey, msg.sender);
188     }
189 
190     /// @dev Allows an owner to begin process of transfering proxy to new IdentityManager
191     function initiateMigration(Proxy identity, address newIdManager) public
192         onlyOlderOwner(identity)
193         validAddress(newIdManager)
194     {
195         migrationInitiated[identity] = now;
196         migrationNewAddress[identity] = newIdManager;
197         LogMigrationInitiated(identity, newIdManager, msg.sender);
198     }
199 
200     /// @dev Allows an owner to cancel the process of transfering proxy to new IdentityManager
201     function cancelMigration(Proxy identity) public onlyOwner(identity) {
202         address canceledManager = migrationNewAddress[identity];
203         delete migrationInitiated[identity];
204         delete migrationNewAddress[identity];
205         LogMigrationCanceled(identity, canceledManager, msg.sender);
206     }
207 
208     /// @dev Allows an owner to finalize migration once adminTimeLock time has passed
209     /// WARNING: before transfering to a new address, make sure this address is "ready to recieve" the proxy.
210     /// Not doing so risks the proxy becoming stuck.
211     function finalizeMigration(Proxy identity) public onlyOlderOwner(identity) {
212         require(migrationInitiated[identity] != 0 && migrationInitiated[identity] + adminTimeLock < now);
213         address newIdManager = migrationNewAddress[identity];
214         delete migrationInitiated[identity];
215         delete migrationNewAddress[identity];
216         identity.transfer(newIdManager);
217         delete recoveryKeys[identity];
218         // We can only delete the owner that we know of. All other owners
219         // needs to be removed before a call to this method.
220         delete owners[identity][msg.sender];
221         LogMigrationFinalized(identity, newIdManager, msg.sender);
222     }
223 
224     function isOwner(address identity, address owner) public constant returns (bool) {
225         return (owners[identity][owner] > 0 && (owners[identity][owner] + userTimeLock) <= now);
226     }
227 
228     function isOlderOwner(address identity, address owner) public constant returns (bool) {
229         return (owners[identity][owner] > 0 && (owners[identity][owner] + adminTimeLock) <= now);
230     }
231 
232     function isRecovery(address identity, address recoveryKey) public constant returns (bool) {
233         return recoveryKeys[identity] == recoveryKey;
234     }
235 }