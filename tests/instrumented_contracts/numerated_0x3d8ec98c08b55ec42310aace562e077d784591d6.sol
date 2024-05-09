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
104 
105     Meritocracy public previousMeritocracy; // Reference and read from previous contract
106 
107     // Events -----------------------------------------------------------------------------------------------
108 
109     event ContributorAdded(address _contributor);
110     event ContributorRemoved(address _contributor);
111     event ContributorWithdrew(address _contributor);
112     event ContributorTransaction(address _cSender, address _cReceiver);
113 
114     event AdminAdded(address _admin);
115     event AdminRemoved(address _admin);
116     event AllocationsForfeited();
117 
118     event OwnerChanged(address _owner);
119     event TokenChanged(address _token);
120     event MaxContributorsChanged(uint256 _maxContributors);
121     event EscapeHatchTriggered(address _executor);
122 
123 
124     // Modifiers --------------------------------------------------------------------------------------------
125 
126     // Functions only Owner can call
127     modifier onlyOwner {
128         require(msg.sender == owner);
129         _;
130     }
131 
132     // Functions only Admin can call
133     modifier onlyAdmin {
134         require(admins[msg.sender]);
135         _;
136     }
137 
138     // Open Functions  --------------------------------------------------------------------------------------
139 
140     // Split amount over each contributor in registry, any contributor can allocate? TODO maybe relax this restriction, so anyone can allocate tokens
141     function allocate(uint256 _amount) external {
142         // Locals
143         
144         // Contributor memory cAllocator = contributors[msg.sender];
145         // Requirements
146         // require(cAllocator.addr != address(0)); // is sender a Contributor? TODO maybe relax this restriction.
147         uint256 individualAmount = _amount / registry.length;
148 
149         // removing decimals
150         individualAmount = (individualAmount / 1000000000000000000 * 1000000000000000000);
151         
152         uint amount = individualAmount * registry.length;
153         
154         require(token.transferFrom(msg.sender, address(this), amount));
155         // Body
156         // cAllocator.inPot = true;
157         for (uint256 i = 0; i < registry.length; i++) {
158                contributors[registry[i]].allocation += individualAmount;
159         }
160     }
161 
162     function getRegistry() public view returns (address[] memory) {
163         return registry;
164     }
165 
166     // Contributor Functions --------------------------------------------------------------------------------
167 
168     // Allows a contributor to withdraw their received Token, when their allocation is 0
169     function withdraw() external {
170         // Locals
171          Contributor storage cReceiver = contributors[msg.sender];
172          // Requirements
173         require(cReceiver.addr == msg.sender); //is sender a Contributor?
174         require(cReceiver.received > 0); // Contributor has received some tokens
175         require(cReceiver.allocation == 0); // Contributor must allocate all Token (or have Token burnt)  before they can withdraw.
176         // require(cReceiver.inPot); // Contributor has put some tokens into the pot
177         // Body
178         uint256 r = cReceiver.received;
179         cReceiver.received = 0;
180         // cReceiver.inPot = false;
181         token.transfer(cReceiver.addr, r);
182         emit ContributorWithdrew(cReceiver.addr);
183     }
184 
185     // Allow Contributors to award allocated tokens to other Contributors
186     function award(address _contributor, uint256 _amount,  string memory _praise) public {
187         // Locals
188         Contributor storage cSender = contributors[msg.sender];
189         Contributor storage cReceiver = contributors[_contributor];
190         // Requirements
191         require(_amount > 0); // Allow Non-Zero amounts only
192         require(cSender.addr == msg.sender); // Ensure Contributors both exist, and isn't the same address 
193         require(cReceiver.addr == _contributor);
194         require(cSender.addr != cReceiver.addr); // cannot send to self
195         require(cSender.allocation >= _amount); // Ensure Sender has enough tokens to allocate
196         // Body
197         cSender.allocation -= _amount; // burn is not adjusted, which is done only in forfeitAllocations
198         cReceiver.received += _amount;
199         cReceiver.totalReceived += _amount;
200 
201         Status memory s = Status({
202             author: cSender.addr,
203             praise: _praise,
204             amount: _amount,
205             time: block.timestamp
206         });
207 
208         cReceiver.status.push(s); // Record the history
209         emit ContributorTransaction(cSender.addr, cReceiver.addr);
210     }
211 
212     function getStatusLength(address _contributor) public view returns (uint) {
213         return contributors[_contributor].status.length;
214     }
215 
216     function getStatus(address _contributor, uint _index) public view returns (
217         address author,
218         string memory praise,
219         uint256 amount,
220         uint256 time
221     ) {
222         author = contributors[_contributor].status[_index].author;
223         praise = contributors[_contributor].status[_index].praise;
224         amount = contributors[_contributor].status[_index].amount;
225         time = contributors[_contributor].status[_index].time;
226     }
227 
228     // Allow Contributor to award multiple Contributors 
229     function awardContributors(address[] calldata _contributors, uint256 _amountEach,  string calldata _praise) external {
230         // Locals
231         Contributor storage cSender = contributors[msg.sender];
232         uint256 contributorsLength = _contributors.length;
233         uint256 totalAmount = contributorsLength * _amountEach;
234         // Requirements
235         require(cSender.allocation >= totalAmount);
236         // Body
237         for (uint256 i = 0; i < contributorsLength; i++) {
238                 award(_contributors[i], _amountEach, _praise);
239         }
240     }
241 
242     // Admin Functions  -------------------------------------------------------------------------------------
243 
244     // Add Contributor to Registry
245     function addContributor(address _contributor) public onlyAdmin {
246         // Requirements
247         require(registry.length + 1 <= maxContributors); // Don't go out of bounds
248         require(contributors[_contributor].addr == address(0)); // Contributor doesn't exist
249         // Body
250         Contributor storage c = contributors[_contributor];
251         c.addr = _contributor;
252         registry.push(_contributor);
253         emit ContributorAdded(_contributor);
254     }
255 
256     // Add Multiple Contributors to the Registry in one tx
257     function addContributors(address[] calldata _newContributors ) external onlyAdmin {
258         // Locals
259         uint256 newContributorLength = _newContributors.length;
260         // Requirements
261         require(registry.length + newContributorLength <= maxContributors); // Don't go out of bounds
262         // Body
263         for (uint256 i = 0; i < newContributorLength; i++) {
264                 addContributor(_newContributors[i]);
265         }
266     }
267 
268     // Remove Contributor from Registry
269     // Note: Should not be easy to remove multiple contributors in one tx
270     // WARN: Changed to idx, client can do loop by enumerating registry
271     function removeContributor(uint256 idx) external onlyAdmin { // address _contributor
272         // Locals
273         uint256 registryLength = registry.length - 1;
274         // Requirements
275         require(idx < registryLength); // idx needs to be smaller than registry.length - 1 OR maxContributors
276         // Body
277         address c = registry[idx];
278         // Swap & Pop!
279         registry[idx] = registry[registryLength];
280         registry.pop();
281         delete contributors[c]; // TODO check if this works
282         emit ContributorRemoved(c);
283     }
284 
285     // Implictly sets a finite limit to registry length
286     function setMaxContributors(uint256 _maxContributors) external onlyAdmin {
287         require(_maxContributors > registry.length); // have to removeContributor first
288         // Body
289         maxContributors = _maxContributors;
290         emit MaxContributorsChanged(maxContributors);
291     }
292 
293     // Zero-out allocations for contributors, minimum once a week, if allocation still exists, add to burn
294     function forfeitAllocations() public onlyAdmin {
295         // Locals
296         uint256 registryLength = registry.length;
297         // Requirements
298         require(block.timestamp >= lastForfeit + 1 weeks); // prevents admins accidently calling too quickly.
299         // Body
300         lastForfeit = block.timestamp; 
301         for (uint256 i = 0; i < registryLength; i++) { // should never be longer than maxContributors, see addContributor
302                 Contributor storage c = contributors[registry[i]];
303                 c.totalForfeited += c.allocation; // Shaaaaame!
304                 c.allocation = 0;
305                 // cReceiver.inPot = false; // Contributor has to put tokens into next round
306         }
307         emit AllocationsForfeited();
308     }
309 
310     // Owner Functions  -------------------------------------------------------------------------------------
311 
312     // Set Admin flag for address to true
313     function addAdmin(address _admin) public onlyOwner {
314         admins[_admin] = true;
315         emit AdminAdded(_admin);
316     }
317 
318     //  Set Admin flag for address to false
319     function removeAdmin(address _admin) public onlyOwner {
320         delete admins[_admin];
321         emit AdminRemoved(_admin);
322     }
323 
324     // Change owner address, ideally to a management contract or multisig
325     function changeOwner(address payable _owner) external onlyOwner {
326         // Body
327         removeAdmin(owner);
328         addAdmin(_owner);
329         owner = _owner;
330         emit OwnerChanged(owner);
331     }
332 
333     // Change Token address
334     // WARN: call escape first, or escape(token);
335     function changeToken(address _token) external onlyOwner {
336         // Body
337         // Zero-out allocation and received, send out received tokens before token switch.
338         for (uint256 i = 0; i < registry.length; i++) {
339                 Contributor storage c = contributors[registry[i]];
340                 uint256 r =  c.received;
341                 c.received = 0;
342                 c.allocation = 0;
343                 // WARN: Should totalReceived and totalForfeited be zeroed-out? 
344                 token.transfer(c.addr, r); // Transfer any owed tokens to contributor 
345         }
346         lastForfeit = block.timestamp;
347         token = ERC20Token(_token);
348         emit TokenChanged(_token);
349     }
350 
351     // Failsafe, Owner can escape hatch all Tokens and ETH from Contract.
352     function escape() public onlyOwner {
353         // Body
354         token.transfer(owner,  token.balanceOf(address(this)));
355         owner.transfer(address(this).balance);
356         emit EscapeHatchTriggered(msg.sender);
357     }
358 
359     // Overloaded failsafe function, recourse incase changeToken is called before escape and funds are in a different token
360     // Don't want to require in changeToken incase bad behaviour of ERC20 token
361     function escape(address _token) external onlyOwner {
362         // Body
363         ERC20Token t = ERC20Token(_token);
364         t.transfer(owner,  t.balanceOf(address(this)));
365         escape();
366     }
367 
368     // Housekeeping -----------------------------------------------------------------------------------------
369 
370     // function importPreviousMeritocracyData() private onlyOwner { // onlyOwner not explicitly needed but safer than sorry, it's problem with overloaded function
371     //      // if previousMeritocracy != address(0) { // TODO better truthiness test, casting?
372     //      //        // Do Stuff
373     //      // }
374     // }
375 
376     // Constructor ------------------------------------------------------------------------------------------
377 
378     // constructor(address _token, uint256 _maxContributors, address _previousMeritocracy) public {
379         
380     // }
381 
382     // Set Owner, Token address,  initial maxContributors
383     constructor(address _token, uint256 _maxContributors) public {
384         // Body
385         owner = msg.sender;
386         addAdmin(owner);
387         lastForfeit = block.timestamp;
388         token = ERC20Token(_token);
389         maxContributors= _maxContributors;
390         // previousMeritocracy = Meritocracy(_previousMeritocracy);
391         // importPreviousMeritocracyData() TODO
392     }
393 }