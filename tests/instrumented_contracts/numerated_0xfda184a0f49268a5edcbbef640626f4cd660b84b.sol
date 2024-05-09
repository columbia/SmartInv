1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-31
3 */
4 
5 pragma solidity ^0.5.1;
6 
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev Give an account access to this role.
14      */
15     function add(Role storage role, address account) internal {
16         require(!has(role, account), "Roles: account already has role");
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev Remove an account's access to this role.
22      */
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "Roles: account does not have role");
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev Check if an account has this role.
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0), "Roles: account is the zero address");
34         return role.bearer[account];
35     }
36 }
37 
38 contract PauserRole {
39     using Roles for Roles.Role;
40 
41     event PauserAdded(address indexed account);
42     event PauserRemoved(address indexed account);
43 
44     Roles.Role private _pausers;
45 
46     constructor () internal {
47         _addPauser(msg.sender);
48     }
49 
50     modifier onlyPauser() {
51         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
52         _;
53     }
54 
55     function isPauser(address account) public view returns (bool) {
56         return _pausers.has(account);
57     }
58 
59     function addPauser(address account) public onlyPauser {
60         _addPauser(account);
61     }
62 
63     function renouncePauser() public {
64         _removePauser(msg.sender);
65     }
66 
67     function _addPauser(address account) internal {
68         _pausers.add(account);
69         emit PauserAdded(account);
70     }
71 
72     function _removePauser(address account) internal {
73         _pausers.remove(account);
74         emit PauserRemoved(account);
75     }
76 }
77 
78 /**
79  * @dev Contract module which allows children to implement an emergency stop
80  * mechanism that can be triggered by an authorized account.
81  *
82  * This module is used through inheritance. It will make available the
83  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
84  * the functions of your contract. Note that they will not be pausable by
85  * simply including this module, only once the modifiers are put in place.
86  */
87 contract Pausable is PauserRole {
88     /**
89      * @dev Emitted when the pause is triggered by a pauser (`account`).
90      */
91     event Paused(address account);
92 
93     /**
94      * @dev Emitted when the pause is lifted by a pauser (`account`).
95      */
96     event Unpaused(address account);
97 
98     bool private _paused;
99 
100     /**
101      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
102      * to the deployer.
103      */
104     constructor () internal {
105         _paused = false;
106     }
107 
108     /**
109      * @dev Returns true if the contract is paused, and false otherwise.
110      */
111     function paused() public view returns (bool) {
112         return _paused;
113     }
114 
115     /**
116      * @dev Modifier to make a function callable only when the contract is not paused.
117      */
118     modifier whenNotPaused() {
119         require(!_paused, "Pausable: paused");
120         _;
121     }
122 
123     /**
124      * @dev Modifier to make a function callable only when the contract is paused.
125      */
126     modifier whenPaused() {
127         require(_paused, "Pausable: not paused");
128         _;
129     }
130 
131     /**
132      * @dev Called by a pauser to pause, triggers stopped state.
133      */
134     function pause() public onlyPauser whenNotPaused {
135         _paused = true;
136         emit Paused(msg.sender);
137     }
138 
139     /**
140      * @dev Called by a pauser to unpause, returns to normal state.
141      */
142     function unpause() public onlyPauser whenPaused {
143         _paused = false;
144         emit Unpaused(msg.sender);
145     }
146 }
147 
148 contract Ownable {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     /**
154      * @dev Initializes the contract setting the deployer as the initial owner.
155      */
156     constructor () internal {
157         _owner = msg.sender;
158         emit OwnershipTransferred(address(0), _owner);
159     }
160 
161     /**
162      * @dev Returns the address of the current owner.
163      */
164     function owner() public view returns (address) {
165         return _owner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(isOwner(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     /**
177      * @dev Returns true if the caller is the current owner.
178      */
179     function isOwner() public view returns (bool) {
180         return msg.sender == _owner;
181     }
182 
183     /**
184      * @dev Leaves the contract without owner. It will not be possible to call
185      * `onlyOwner` functions anymore. Can only be called by the current owner.
186      *
187      * NOTE: Renouncing ownership will leave the contract without an owner,
188      * thereby removing any functionality that is only available to the owner.
189      */
190     function renounceOwnership() public onlyOwner {
191         emit OwnershipTransferred(_owner, address(0));
192         _owner = address(0);
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public onlyOwner {
200         _transferOwnership(newOwner);
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      */
206     function _transferOwnership(address newOwner) internal {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         emit OwnershipTransferred(_owner, newOwner);
209         _owner = newOwner;
210     }
211 }
212 
213 contract BitGemCheckIn is Ownable, Pausable {
214     mapping (address => mapping(uint => uint)) private checkins;
215     bool private isDev = false;
216 
217     // constructor() public Ownable() PauserRole() { }
218 
219     function enableDev(bool dev) public onlyOwner {
220         isDev = dev;
221     }
222 
223     function checkIn() public whenNotPaused returns (bool) {
224         uint day = block.timestamp / 1 days;
225         checkins[msg.sender][day / 256] |= (1 << (day % 256));
226         return true;
227     }
228 
229 
230     function checkInDev(uint timestamp) public whenNotPaused returns (bool) {
231         require(isDev, "require dev");
232         uint day = timestamp / 1 days;
233         checkins[msg.sender][day / 256] |= (1 << (day % 256));
234         return true;
235     }
236 
237     function getCheckIn(uint timestamp) public view returns (bool) {
238         uint day = timestamp / 1 days;
239         return checkins[msg.sender][day / 256] & ( 1 << (day % 256)) != 0;
240     }
241 }