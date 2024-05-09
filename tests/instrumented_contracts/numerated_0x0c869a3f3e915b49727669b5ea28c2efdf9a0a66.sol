1 pragma solidity ^0.5.0;
2 
3 /*
4 Future Goals:
5 - remove admins necessity
6 - encourage contributors to allocate
7 - needs incentive for someone to call forfeit
8 - read from previous versions of the script
9 
10 DApp:
11 - show tokens to allocate
12 - allocate token to person with praise
13 - leaderboard, showing amount totalReceived and totalForfeited and amount, praises https://codepen.io/lewismcarey/pen/GJZVoG
14 - allows you to send SNT to meritocracy
15 - add/remove contributor
16 - add/remove adminstrator
17 
18 Extension:
19 - Command:
20     - above command = display allocation, received, withdraw button, allocate button? (might be better in dapp)
21     - /kudos 500 "<person>" "<praise>"
22 */
23 
24 
25 
26 // Abstract contract for the full ERC 20 Token standard
27 // https://github.com/ethereum/EIPs/issues/20
28 
29 interface ERC20Token {
30 
31     /**
32      * @notice send `_value` token to `_to` from `msg.sender`
33      * @param _to The address of the recipient
34      * @param _value The amount of token to be transferred
35      * @return Whether the transfer was successful or not
36      */
37     function transfer(address _to, uint256 _value) external returns (bool success);
38 
39     /**
40      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
41      * @param _spender The address of the account able to transfer the tokens
42      * @param _value The amount of tokens to be approved for transfer
43      * @return Whether the approval was successful or not
44      */
45     function approve(address _spender, uint256 _value) external returns (bool success);
46 
47     /**
48      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
49      * @param _from The address of the sender
50      * @param _to The address of the recipient
51      * @param _value The amount of token to be transferred
52      * @return Whether the transfer was successful or not
53      */
54     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
55 
56     /**
57      * @param _owner The address from which the balance will be retrieved
58      * @return The balance
59      */
60     function balanceOf(address _owner) external view returns (uint256 balance);
61 
62     /**
63      * @param _owner The address of the account owning tokens
64      * @param _spender The address of the account able to transfer the tokens
65      * @return Amount of remaining tokens allowed to spent
66      */
67     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
68 
69     /**
70      * @notice return total supply of tokens
71      */
72     function totalSupply() external view returns (uint256 supply);
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 contract Meritocracy {
79 
80     struct Status {
81         address author;
82         string praise;
83         uint256 amount;
84         uint256 time; // block.timestamp
85     }
86 
87     struct Contributor {
88         address addr;
89         uint256 allocation; // Amount they can send to other contributors, and amount they forfeit, when forfeit just zero this out and leave Token in contract, Owner can use escape to receive it back
90         uint256 totalForfeited; // Allocations they've burnt, can be used to show non-active players.
91         uint256 totalReceived;
92         uint256 received; // Ignore amounts in Status struct, and use this as source of truth, can withdraw at any time
93         // bool inPot; // Require Contributor WARN: commented because there's some edge cases not dealt with
94         Status[] status;
95     }
96 
97     ERC20Token public token; // token contract
98     address payable public owner; // contract owner
99     uint256 public lastForfeit; // timestamp to block admins calling forfeitAllocations too quickly
100     address[] public registry; // array of contributor addresses
101     uint256 public maxContributors; // Dynamic finite limit on registry.
102     mapping(address => bool) public admins;
103     mapping(address => Contributor) public contributors;
104     bytes public contributorListIPFSHash;
105 
106     Meritocracy public previousMeritocracy; // Reference and read from previous contract
107 
108     // Events -----------------------------------------------------------------------------------------------
109 
110     event ContributorAdded(address _contributor);
111     event ContributorRemoved(address _contributor);
112     event ContributorWithdrew(address _contributor);
113     event ContributorTransaction(address _cSender, address _cReceiver);
114 
115     event AdminAdded(address _admin);
116     event AdminRemoved(address _admin);
117     event AllocationsForfeited();
118 
119     event OwnerChanged(address _owner);
120     event TokenChanged(address _token);
121     event MaxContributorsChanged(uint256 _maxContributors);
122     event EscapeHatchTriggered(address _executor);
123 
124 
125     // Modifiers --------------------------------------------------------------------------------------------
126 
127     // Functions only Owner can call
128     modifier onlyOwner {
129         require(msg.sender == owner);
130         _;
131     }
132 
133     // Functions only Admin can call
134     modifier onlyAdmin {
135         require(admins[msg.sender]);
136         _;
137     }
138 
139     // Open Functions  --------------------------------------------------------------------------------------
140 
141     // Split amount over each contributor in registry, any contributor can allocate? TODO maybe relax this restriction, so anyone can allocate tokens
142     function allocate(uint256 _amount) external {
143         // Locals
144 
145         // Contributor memory cAllocator = contributors[msg.sender];
146         // Requirements
147         // require(cAllocator.addr != address(0)); // is sender a Contributor? TODO maybe relax this restriction.
148         uint256 individualAmount = _amount / registry.length;
149 
150         // removing decimals
151         individualAmount = (individualAmount / 1 ether * 1 ether);
152 
153         uint amount = individualAmount * registry.length;
154 
155         require(token.transferFrom(msg.sender, address(this), amount));
156         // Body
157         // cAllocator.inPot = true;
158         for (uint256 i = 0; i < registry.length; i++) {
159                contributors[registry[i]].allocation += individualAmount;
160         }
161     }
162 
163     function getRegistry() public view returns (address[] memory) {
164         return registry;
165     }
166 
167     // Contributor Functions --------------------------------------------------------------------------------
168 
169     // Allows a contributor to withdraw their received Token, when their allocation is 0
170     function withdraw() external {
171         // Locals
172          Contributor storage cReceiver = contributors[msg.sender];
173          // Requirements
174         require(cReceiver.addr == msg.sender); //is sender a Contributor?
175         require(cReceiver.received > 0); // Contributor has received some tokens
176         require(cReceiver.allocation == 0); // Contributor must allocate all Token (or have Token burnt)  before they can withdraw.
177         // require(cReceiver.inPot); // Contributor has put some tokens into the pot
178         // Body
179         uint256 r = cReceiver.received;
180         cReceiver.received = 0;
181         // cReceiver.inPot = false;
182         token.transfer(cReceiver.addr, r);
183         emit ContributorWithdrew(cReceiver.addr);
184     }
185 
186     // Allow Contributors to award allocated tokens to other Contributors
187     function award(address _contributor, uint256 _amount,  string memory _praise) public {
188         // Locals
189         Contributor storage cSender = contributors[msg.sender];
190         Contributor storage cReceiver = contributors[_contributor];
191         // Requirements
192         require(_amount > 0); // Allow Non-Zero amounts only
193         require(cSender.addr == msg.sender); // Ensure Contributors both exist, and isn't the same address
194         require(cReceiver.addr == _contributor);
195         require(cSender.addr != cReceiver.addr); // cannot send to self
196         require(cSender.allocation >= _amount); // Ensure Sender has enough tokens to allocate
197         // Body
198         cSender.allocation -= _amount; // burn is not adjusted, which is done only in forfeitAllocations
199         cReceiver.received += _amount;
200         cReceiver.totalReceived += _amount;
201 
202         Status memory s = Status({
203             author: cSender.addr,
204             praise: _praise,
205             amount: _amount,
206             time: block.timestamp
207         });
208 
209         cReceiver.status.push(s); // Record the history
210         emit ContributorTransaction(cSender.addr, cReceiver.addr);
211     }
212 
213     function getStatusLength(address _contributor) public view returns (uint) {
214         return contributors[_contributor].status.length;
215     }
216 
217     function getStatus(address _contributor, uint _index) public view returns (
218         address author,
219         string memory praise,
220         uint256 amount,
221         uint256 time
222     ) {
223         author = contributors[_contributor].status[_index].author;
224         praise = contributors[_contributor].status[_index].praise;
225         amount = contributors[_contributor].status[_index].amount;
226         time = contributors[_contributor].status[_index].time;
227     }
228 
229     // Allow Contributor to award multiple Contributors
230     function awardContributors(address[] calldata _contributors, uint256 _amountEach,  string calldata _praise) external {
231         // Locals
232         Contributor storage cSender = contributors[msg.sender];
233         uint256 contributorsLength = _contributors.length;
234         uint256 totalAmount = contributorsLength * _amountEach;
235         // Requirements
236         require(cSender.allocation >= totalAmount);
237         // Body
238         for (uint256 i = 0; i < contributorsLength; i++) {
239                 award(_contributors[i], _amountEach, _praise);
240         }
241     }
242 
243     // Admin Functions  -------------------------------------------------------------------------------------
244 
245     // Add Contributor to Registry
246     function addContributor(address _contributor, bytes memory _contributorListIPFSHash) public onlyAdmin {
247        addContributorWithoutHash(_contributor);
248 
249         // Set new IPFS hash for the list
250         contributorListIPFSHash = _contributorListIPFSHash;
251     }
252 
253     function addContributorWithoutHash(address _contributor) internal onlyAdmin {
254         // Requirements
255         require(registry.length + 1 <= maxContributors); // Don't go out of bounds
256         require(contributors[_contributor].addr == address(0)); // Contributor doesn't exist
257         // Body
258         Contributor storage c = contributors[_contributor];
259         c.addr = _contributor;
260         registry.push(_contributor);
261         emit ContributorAdded(_contributor);
262     }
263 
264     // Add Multiple Contributors to the Registry in one tx
265     function addContributors(address[] calldata _newContributors, bytes calldata _contributorListIPFSHash) external onlyAdmin {
266         // Locals
267         uint256 newContributorLength = _newContributors.length;
268         // Requirements
269         require(registry.length + newContributorLength <= maxContributors); // Don't go out of bounds
270         // Body
271         for (uint256 i = 0; i < newContributorLength; i++) {
272             addContributorWithoutHash(_newContributors[i]);
273         }
274         // Set new IPFS hash for the list
275         contributorListIPFSHash = _contributorListIPFSHash;
276     }
277 
278     // Remove Contributor from Registry
279     // Note: Should not be easy to remove multiple contributors in one tx
280     // WARN: Changed to idx, client can do loop by enumerating registry
281     function removeContributor(uint256 idx, bytes calldata _contributorListIPFSHash) external onlyAdmin { // address _contributor
282         // Locals
283         uint256 registryLength = registry.length - 1;
284         // Requirements
285         require(idx <= registryLength); // idx needs to be smaller than registry.length - 1 OR maxContributors
286         // Body
287         address c = registry[idx];
288         // Swap & Pop!
289         registry[idx] = registry[registryLength];
290         registry.pop();
291         delete contributors[c]; // TODO check if this works
292         // Set new IPFS hash for the list
293         contributorListIPFSHash = _contributorListIPFSHash;
294         emit ContributorRemoved(c);
295     }
296 
297     // Implictly sets a finite limit to registry length
298     function setMaxContributors(uint256 _maxContributors) external onlyAdmin {
299         require(_maxContributors > registry.length); // have to removeContributor first
300         // Body
301         maxContributors = _maxContributors;
302         emit MaxContributorsChanged(maxContributors);
303     }
304 
305     // Zero-out allocations for contributors, minimum once a week, if allocation still exists, add to burn
306     function forfeitAllocations() public onlyAdmin {
307         // Locals
308         uint256 registryLength = registry.length;
309         // Requirements
310         require(block.timestamp >= lastForfeit + 6 days); // prevents admins accidently calling too quickly.
311         // Body
312         lastForfeit = block.timestamp;
313         for (uint256 i = 0; i < registryLength; i++) { // should never be longer than maxContributors, see addContributor
314                 Contributor storage c = contributors[registry[i]];
315                 c.totalForfeited += c.allocation; // Shaaaaame!
316                 c.allocation = 0;
317                 // cReceiver.inPot = false; // Contributor has to put tokens into next round
318         }
319         emit AllocationsForfeited();
320     }
321 
322     // Owner Functions  -------------------------------------------------------------------------------------
323 
324     // Set Admin flag for address to true
325     function addAdmin(address _admin) public onlyOwner {
326         admins[_admin] = true;
327         emit AdminAdded(_admin);
328     }
329 
330     //  Set Admin flag for address to false
331     function removeAdmin(address _admin) public onlyOwner {
332         delete admins[_admin];
333         emit AdminRemoved(_admin);
334     }
335 
336     // Change owner address, ideally to a management contract or multisig
337     function changeOwner(address payable _owner) external onlyOwner {
338         // Body
339         removeAdmin(owner);
340         addAdmin(_owner);
341         owner = _owner;
342         emit OwnerChanged(owner);
343     }
344 
345     // Change Token address
346     // WARN: call escape first, or escape(token);
347     function changeToken(address _token) external onlyOwner {
348         // Body
349         // Zero-out allocation and received, send out received tokens before token switch.
350         for (uint256 i = 0; i < registry.length; i++) {
351                 Contributor storage c = contributors[registry[i]];
352                 uint256 r =  c.received;
353                 c.received = 0;
354                 c.allocation = 0;
355                 // WARN: Should totalReceived and totalForfeited be zeroed-out?
356                 token.transfer(c.addr, r); // Transfer any owed tokens to contributor
357         }
358         lastForfeit = block.timestamp;
359         token = ERC20Token(_token);
360         emit TokenChanged(_token);
361     }
362 
363     // Failsafe, Owner can escape hatch all Tokens and ETH from Contract.
364     function escape() public onlyOwner {
365         // Body
366         token.transfer(owner,  token.balanceOf(address(this)));
367         owner.transfer(address(this).balance);
368         emit EscapeHatchTriggered(msg.sender);
369     }
370 
371     // Overloaded failsafe function, recourse incase changeToken is called before escape and funds are in a different token
372     // Don't want to require in changeToken incase bad behaviour of ERC20 token
373     function escape(address _token) external onlyOwner {
374         // Body
375         ERC20Token t = ERC20Token(_token);
376         t.transfer(owner,  t.balanceOf(address(this)));
377         escape();
378     }
379 
380     // Housekeeping -----------------------------------------------------------------------------------------
381 
382     // function importPreviousMeritocracyData() private onlyOwner { // onlyOwner not explicitly needed but safer than sorry, it's problem with overloaded function
383     //      // if previousMeritocracy != address(0) { // TODO better truthiness test, casting?
384     //      //        // Do Stuff
385     //      // }
386     // }
387 
388     // Constructor ------------------------------------------------------------------------------------------
389 
390     // constructor(address _token, uint256 _maxContributors, address _previousMeritocracy) public {
391 
392     // }
393 
394     // Set Owner, Token address,  initial maxContributors
395     constructor(address _token, uint256 _maxContributors, bytes memory _contributorListIPFSHash) public {
396         // Body
397         owner = msg.sender;
398         addAdmin(owner);
399         lastForfeit = block.timestamp;
400         token = ERC20Token(_token);
401         maxContributors= _maxContributors;
402         contributorListIPFSHash = _contributorListIPFSHash;
403         // previousMeritocracy = Meritocracy(_previousMeritocracy);
404         // importPreviousMeritocracyData() TODO
405     }
406 }