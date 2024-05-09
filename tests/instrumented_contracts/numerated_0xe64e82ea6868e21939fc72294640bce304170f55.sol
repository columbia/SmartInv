1 pragma solidity >=0.5.0 <0.6.0;
2 
3 contract PauserRole {
4     using Roles for Roles.Role;
5 
6     event PauserAdded(address indexed account);
7     event PauserRemoved(address indexed account);
8 
9     Roles.Role private _pausers;
10 
11     constructor () internal {
12         _addPauser(msg.sender);
13     }
14 
15     modifier onlyPauser() {
16         require(isPauser(msg.sender));
17         _;
18     }
19 
20     function isPauser(address account) public view returns (bool) {
21         return _pausers.has(account);
22     }
23 
24     function addPauser(address account) public onlyPauser {
25         _addPauser(account);
26     }
27 
28     function renouncePauser() public {
29         _removePauser(msg.sender);
30     }
31 
32     function _addPauser(address account) internal {
33         _pausers.add(account);
34         emit PauserAdded(account);
35     }
36 
37     function _removePauser(address account) internal {
38         _pausers.remove(account);
39         emit PauserRemoved(account);
40     }
41 }
42 
43 /**
44  * @title Pausable
45  * @dev Base contract which allows children to implement an emergency stop mechanism.
46  */
47 contract Pausable is PauserRole {
48     event Paused(address account);
49     event Unpaused(address account);
50 
51     bool private _paused;
52 
53     constructor () internal {
54         _paused = false;
55     }
56 
57     /**
58      * @return true if the contract is paused, false otherwise.
59      */
60     function paused() public view returns (bool) {
61         return _paused;
62     }
63 
64     /**
65      * @dev Modifier to make a function callable only when the contract is not paused.
66      */
67     modifier whenNotPaused() {
68         require(!_paused);
69         _;
70     }
71 
72     /**
73      * @dev Modifier to make a function callable only when the contract is paused.
74      */
75     modifier whenPaused() {
76         require(_paused);
77         _;
78     }
79 
80     /**
81      * @dev called by the owner to pause, triggers stopped state
82      */
83     function pause() public onlyPauser whenNotPaused {
84         _paused = true;
85         emit Paused(msg.sender);
86     }
87 
88     /**
89      * @dev called by the owner to unpause, returns to normal state
90      */
91     function unpause() public onlyPauser whenPaused {
92         _paused = false;
93         emit Unpaused(msg.sender);
94     }
95 }
96 
97 /**
98  * @title Roles
99  * @dev Library for managing addresses assigned to a Role.
100  */
101 library Roles {
102     struct Role {
103         mapping (address => bool) bearer;
104     }
105 
106     /**
107      * @dev give an account access to this role
108      */
109     function add(Role storage role, address account) internal {
110         require(account != address(0));
111         require(!has(role, account));
112 
113         role.bearer[account] = true;
114     }
115 
116     /**
117      * @dev remove an account's access to this role
118      */
119     function remove(Role storage role, address account) internal {
120         require(account != address(0));
121         require(has(role, account));
122 
123         role.bearer[account] = false;
124     }
125 
126     /**
127      * @dev check if an account has this role
128      * @return bool
129      */
130     function has(Role storage role, address account) internal view returns (bool) {
131         require(account != address(0));
132         return role.bearer[account];
133     }
134 }
135 
136 /**
137  * @title Ownable
138  * @dev The Ownable contract has an owner address, and provides basic authorization control
139  * functions, this simplifies the implementation of "user permissions".
140  */
141 contract Ownable {
142     address private _owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     /**
147      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
148      * account.
149      */
150     constructor () internal {
151         _owner = msg.sender;
152         emit OwnershipTransferred(address(0), _owner);
153     }
154 
155     /**
156      * @return the address of the owner.
157      */
158     function owner() public view returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyOwner() {
166         require(isOwner());
167         _;
168     }
169 
170     /**
171      * @return true if `msg.sender` is the owner of the contract.
172      */
173     function isOwner() public view returns (bool) {
174         return msg.sender == _owner;
175     }
176 
177     /**
178      * @dev Allows the current owner to relinquish control of the contract.
179      * @notice Renouncing to ownership will leave the contract without an owner.
180      * It will not be possible to call the functions with the `onlyOwner`
181      * modifier anymore.
182      */
183     function renounceOwnership() public onlyOwner {
184         emit OwnershipTransferred(_owner, address(0));
185         _owner = address(0);
186     }
187 
188     /**
189      * @dev Allows the current owner to transfer control of the contract to a newOwner.
190      * @param newOwner The address to transfer ownership to.
191      */
192     function transferOwnership(address newOwner) public onlyOwner {
193         _transferOwnership(newOwner);
194     }
195 
196     /**
197      * @dev Transfers control of the contract to a newOwner.
198      * @param newOwner The address to transfer ownership to.
199      */
200     function _transferOwnership(address newOwner) internal {
201         require(newOwner != address(0));
202         emit OwnershipTransferred(_owner, newOwner);
203         _owner = newOwner;
204     }
205 }
206 
207 contract HistoricATD is Ownable, Pausable {
208 
209   /**
210     Constructor
211    */
212 
213   // constructor() public {}
214 
215   /**
216     Events
217    */
218 
219   event Distributed(
220     uint256 indexed date,
221     address indexed lockedWallet,
222     address indexed unlockWallet,
223     uint256 ratioDTV,
224     uint256 ratioDecimals,
225     uint256 dailyTradedVolume,
226     uint256 amount,
227     bytes32 transaction
228   );
229 
230   event TotalDistributed(
231     uint256 indexed date,
232     uint256 dailyTradedVolume,
233     uint256 amount,
234     bytes32 transaction
235   );
236 
237   /**
238     Publics
239    */
240 
241   function emitDistribute(
242     uint256[] memory dates,
243     uint256[] memory dailyTradedVolumes,
244     address[] memory lockedWallets,
245     address[] memory unlockWallets,
246     uint256[] memory ratioDTVs,
247     uint256[] memory ratioDecimals,
248     uint256[] memory amounts,
249     bytes32[] memory transactions
250   ) public whenNotPaused {
251     require(dates.length == dailyTradedVolumes.length, "dailyTradedVolumes length is different");
252     require(dates.length == lockedWallets.length, "lockedWallets length is different");
253     require(dates.length == unlockWallets.length, "unlockWallets length is different");
254     require(dates.length == ratioDTVs.length, "ratioDTVs length is different");
255     require(dates.length == ratioDecimals.length, "ratioDecimals length is different");
256     require(dates.length == amounts.length, "amounts length is different");
257     require(dates.length == transactions.length, "transactions length is different");
258     for (uint256 i = 0; i < dates.length; i++) {
259       emit Distributed(
260         dates[i],
261         lockedWallets[i],
262         unlockWallets[i],
263         ratioDTVs[i],
264         ratioDecimals[i],
265         dailyTradedVolumes[i],
266         amounts[i],
267         transactions[i]
268       );
269     }
270   }
271 
272   function emitDistributeTotal(
273     uint256[] memory dates,
274     uint256[] memory dailyTradedVolumes,
275     uint256[] memory totals,
276     bytes32[] memory transactions
277   ) public whenNotPaused {
278     require(dates.length == dailyTradedVolumes.length, "dailyTradedVolumes length is different");
279     require(dates.length == totals.length, "totals length is different");
280     require(dates.length == transactions.length, "transactions length is different");
281     for (uint256 i = 0; i < dates.length; i++) {
282       emit TotalDistributed(dates[i], dailyTradedVolumes[i], totals[i], transactions[i]);
283     }
284   }
285 
286   function destroy() public onlyOwner {
287     selfdestruct(msg.sender);
288   }
289 
290   function removePauser(address account) public onlyOwner {
291     _removePauser(account);
292   }
293 
294 }