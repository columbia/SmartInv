1 pragma solidity ^0.4.24;
2 
3 // compiler: 0.4.24+commit.e67f0147
4 // optimization: ON
5 // dev: Luís Freitas @ HODL Media Inc., Dec-2018
6 // for more check github.com/LewisFreitas or github.com/hodlfinance ...
7 
8 /**
9  * @title Roles
10  * @dev Library for managing addresses assigned to a Role.
11  */
12 library Roles {
13     struct Role {
14         mapping (address => bool) bearer;
15     }
16 
17     /**
18      * @dev give an account access to this role
19      */
20     function add(Role storage role, address account) internal {
21         require(account != address(0));
22         require(!has(role, account));
23 
24         role.bearer[account] = true;
25     }
26 
27     /**
28      * @dev remove an account's access to this role
29      */
30     function remove(Role storage role, address account) internal {
31         require(account != address(0));
32         require(has(role, account));
33 
34         role.bearer[account] = false;
35     }
36 
37     /**
38      * @dev check if an account has this role
39      * @return bool
40      */
41     function has(Role storage role, address account) internal view returns (bool) {
42         require(account != address(0));
43         return role.bearer[account];
44     }
45 }
46 
47 contract PauserRole {
48     using Roles for Roles.Role;
49 
50     event PauserAdded(address indexed account);
51     event PauserRemoved(address indexed account);
52 
53     Roles.Role private _pausers;
54 
55     constructor () internal {
56         _addPauser(msg.sender);
57     }
58 
59     modifier onlyPauser() {
60         require(isPauser(msg.sender));
61         _;
62     }
63 
64     function isPauser(address account) public view returns (bool) {
65         return _pausers.has(account);
66     }
67 
68     function addPauser(address account) public onlyPauser {
69         _addPauser(account);
70     }
71 
72     function renouncePauser() public {
73         _removePauser(msg.sender);
74     }
75 
76     function _addPauser(address account) internal {
77         _pausers.add(account);
78         emit PauserAdded(account);
79     }
80 
81     function _removePauser(address account) internal {
82         _pausers.remove(account);
83         emit PauserRemoved(account);
84     }
85 }
86 
87 /**
88  * @title Pausable
89  * @dev Base contract which allows children to implement an emergency stop mechanism.
90  */
91 contract Pausable is PauserRole {
92     event Paused(address account);
93     event Unpaused(address account);
94 
95     bool private _paused;
96 
97     constructor () internal {
98         _paused = false;
99     }
100 
101     /**
102      * @return true if the contract is paused, false otherwise.
103      */
104     function paused() public view returns (bool) {
105         return _paused;
106     }
107 
108     /**
109      * @dev Modifier to make a function callable only when the contract is not paused.
110      */
111     modifier whenNotPaused() {
112         require(!_paused);
113         _;
114     }
115 
116     /**
117      * @dev Modifier to make a function callable only when the contract is paused.
118      */
119     modifier whenPaused() {
120         require(_paused);
121         _;
122     }
123 
124     /**
125      * @dev called by the owner to pause, triggers stopped state
126      */
127     function pause() public onlyPauser whenNotPaused {
128         _paused = true;
129         emit Paused(msg.sender);
130     }
131 
132     /**
133      * @dev called by the owner to unpause, returns to normal state
134      */
135     function unpause() public onlyPauser whenPaused {
136         _paused = false;
137         emit Unpaused(msg.sender);
138     }
139 }
140 
141 contract HODL is Pausable {
142 
143     modifier hashDoesNotExist(string _hash){
144         if(hashExistsMap[_hash] == true) revert();
145         _;
146     }
147 
148     mapping (string => bool) hashExistsMap;
149     mapping (string => uint256) hashToIndex;
150     
151     mapping (address => uint256[]) senderToIndexArray;
152     
153     mapping (address => mapping (address => bool)) userOptOut;
154     
155     struct Hash {
156         string hash;
157         address sender;
158         uint256 timestamp;
159     }
160     
161     Hash[] public hashes;
162 
163     event AddedBatch(address indexed from, string hash, uint256 timestamp);
164     event UserOptOut(address user, address appAddress, uint256 timestamp);
165     event UserOptIn(address user, address appAddress, uint256 timestamp);
166 
167     function storeBatch(string _hash) public whenNotPaused hashDoesNotExist(_hash) {
168 
169         Hash memory newHash = Hash({
170             hash: _hash,
171             sender: msg.sender,
172             timestamp: now
173         });
174         
175         uint256 newHashIndex = hashes.push(newHash) - 1;
176         
177         hashToIndex[_hash] = newHashIndex;
178         senderToIndexArray[msg.sender].push(newHashIndex);
179         
180         hashExistsMap[_hash] = true;
181         
182         emit AddedBatch(msg.sender, _hash, now);
183     }
184 
185     
186     function opt(address appAddress) public whenNotPaused {
187         
188         bool userOptState = userOptOut[msg.sender][appAddress];
189         
190         if(userOptState == false){
191             userOptOut[msg.sender][appAddress] = true;
192             emit UserOptIn(msg.sender, appAddress, now);
193         }
194         else{
195             userOptOut[msg.sender][appAddress] = false;
196             emit UserOptOut(msg.sender, appAddress, now);
197         }
198     }
199 
200     function getUserOptOut(address userAddress, address appAddress) public view returns (bool){
201         return userOptOut[userAddress][appAddress];
202     }
203     
204     function getIndexByHash (string _hash) public view returns (uint256){
205         return hashToIndex[_hash];
206     }
207 
208 	function getHashExists(string _hash) public view returns (bool){
209         return hashExistsMap[_hash];
210     }
211     
212     function getAllIndexesByAddress (address sender) public view returns (uint256[]){
213         return senderToIndexArray[sender];
214     }
215 }