1 pragma solidity ^0.5.1;
2 
3 contract Multiowned {
4 
5     // TYPES
6     // struct for the status of a pending operation.
7     struct PendingState {
8         uint yetNeeded;
9         uint ownersDone;
10         uint index;
11     }
12 
13     // EVENTS
14     // this contract only has five types of events: it can accept a confirmation, in which case
15     // we record owner and operation (hash) alongside it.
16     event Confirmation(address owner, bytes32 operation);
17 
18     // MODIFIERS
19     // simple single-sig function modifier.
20     modifier onlyOwner {
21         if (!isOwner(msg.sender))
22             require(false);
23         _;
24     }
25 
26     // multi-sig function modifier: the operation must have an intrinsic hash in order
27     // that later attempts can be realised as the same underlying operation and
28     // thus count as confirmations.
29     modifier onlyManyOwners(bytes32 _operation) {
30         if (confirmAndCheck(_operation))
31             _;
32     }
33 
34     // METHODS
35     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
36     // as well as the selection of addresses capable of confirming them.
37     constructor(address[] memory _owners, uint _required) public{
38         m_numOwners = _owners.length;
39         for (uint i = 0; i < _owners.length; ++i)
40         {
41             m_owners[1 + i] = _owners[i];
42             m_ownerIndex[_owners[i]] = 1 + i;
43         }
44         m_required = _required;
45     }
46 
47     function isOwner(address _addr) public view returns (bool) {
48         return m_ownerIndex[_addr] > 0;
49     }
50 
51     function hasConfirmed(bytes32 _operation, address _owner) view public returns (bool) {
52         PendingState storage pending = m_pending[_operation];
53         uint ownerIndex = m_ownerIndex[_owner];
54 
55         // make sure they're an owner
56         if (ownerIndex == 0) return false;
57 
58         // determine the bit to set for this owner.
59         uint ownerIndexBit = 2 ** ownerIndex;
60         if (pending.ownersDone & ownerIndexBit == 0) {
61             return false;
62         } else {
63             return true;
64         }
65     }
66 
67     // INTERNAL METHODS
68 
69     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
70         // determine what index the present sender is:
71         uint ownerIndex = m_ownerIndex[msg.sender];
72         // make sure they're an owner
73         if (ownerIndex == 0) return false;
74 
75         PendingState storage pending = m_pending[_operation];
76         // if we're not yet working on this operation, switch over and reset the confirmation status.
77         if (pending.yetNeeded == 0) {
78             // reset count of confirmations needed.
79             pending.yetNeeded = m_required;
80             // reset which owners have confirmed (none) - set our bitmap to 0.
81             pending.ownersDone = 0;
82             pending.index = m_pendingIndex.length++;
83             m_pendingIndex[pending.index] = _operation;
84         }
85         // determine the bit to set for this owner.
86         uint ownerIndexBit = 2 ** ownerIndex;
87         // make sure we (the message sender) haven't confirmed this operation previously.
88         if (pending.ownersDone & ownerIndexBit == 0) {
89             emit Confirmation(msg.sender, _operation);
90             // ok - check if count is enough to go ahead.
91             if (pending.yetNeeded <= 1) {
92                 // enough confirmations: reset and run interior.
93                 delete m_pendingIndex[m_pending[_operation].index];
94                 delete m_pending[_operation];
95                 return true;
96             }
97             else
98             {
99                 // not enough: record that this owner in particular confirmed.
100                 pending.yetNeeded--;
101                 pending.ownersDone |= ownerIndexBit;
102             }
103         }
104         return false;
105     }
106 
107     // FIELDS
108 
109     // the number of owners that must confirm the same operation before it is run.
110     uint public m_required;
111     // pointer used to find a free slot in m_owners
112     uint public m_numOwners;
113 
114     // list of owners
115     address[11] m_owners;
116     uint constant c_maxOwners = 10;
117     // index on the list of owners to allow reverse lookup
118     mapping(address => uint) m_ownerIndex;
119     // the ongoing operations.
120     mapping(bytes32 => PendingState) m_pending;
121     bytes32[] m_pendingIndex;
122 }
123 
124 
125 /**
126  * @title Pausable
127  * @dev Base contract which allows children to implement an emergency stop mechanism.
128  */
129 contract Pausable is Multiowned {
130     event Pause();
131     event Unpause();
132 
133     bool public paused = false;
134 
135 
136     /**
137      * @dev Modifier to make a function callable only when the contract is not paused.
138      */
139     modifier whenNotPaused() {
140         require(!paused);
141         _;
142     }
143 
144     /**
145      * @dev Modifier to make a function callable only when the contract is paused.
146      */
147     modifier whenPaused() {
148         require(paused);
149         _;
150     }
151 
152     /**
153      * @dev called by the owner to pause, triggers stopped state
154      */
155     function pause() onlyOwner whenNotPaused public {
156         paused = true;
157         emit Pause();
158     }
159 
160     /**
161      * @dev called by the owner to unpause, returns to normal state
162      */
163     function unpause() onlyOwner whenPaused public {
164         paused = false;
165         emit Unpause();
166     }
167 }
168 /**
169  * Math operations with safety checks
170  */
171 contract SafeMath {
172     function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
173         uint256 c = a * b;
174         assert(a == 0 || c / a == b);
175         return c;
176     }
177 
178     function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
179         assert(b > 0);
180         uint256 c = a / b;
181         assert(a == b * c + a % b);
182         return c;
183     }
184 
185     function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
186         assert(b <= a);
187         return a - b;
188     }
189 
190     function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
191         uint256 c = a + b;
192         assert(c>=a && c>=b);
193         return c;
194     }
195 }
196 
197 contract tokenRecipientInterface {
198     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public;
199 }
200 
201 contract ZVC is Multiowned, SafeMath, Pausable{
202     string public name;
203     string public symbol;
204     uint8 public decimals;
205     uint256 public totalSupply;
206     address public creator;
207 
208     /* This creates an array with all balances */
209     mapping (address => uint256) public balanceOf;
210     mapping (address => mapping (address => uint256)) public allowance;
211 
212     /* This creates an array with all PEAccounts */
213     mapping (address => bool) public PEAccounts;
214 
215     // pending transactions we have at present.
216     mapping(bytes32 => Transaction) m_txs;
217 
218     // Transaction structure to remember details of transaction lest it need be saved for a later call.
219     struct Transaction {
220         address to;
221         uint value;
222     }
223 
224     /* This generates a public event on the blockchain that will notify clients */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /* This notifies clients about the amount to mapping */
228     event MappingTo(address from, string to, uint256 value);
229 
230     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
231     event MultiTransact(address owner, bytes32 operation, uint value, address to);
232     // Confirmation still needed for a transaction.
233     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to);
234 
235     modifier notHolderAndPE() {
236         require(creator != msg.sender && !PEAccounts[msg.sender]);
237         _;
238     }
239 
240 
241     /* Initializes contract with initial supply tokens to the creator of the contract */
242     constructor(address[] memory _owners, uint _required) Multiowned(_owners, _required) public payable  {
243         balanceOf[msg.sender] = 500000000000000000;              // Give the creator all initial tokens
244         totalSupply = 500000000000000000;                        // Update total supply
245         name = "ZVC";                                   // Set the name for display purposes
246         symbol = "ZVC";                               // Set the symbol for display purposes
247         decimals = 9;                            // Amount of decimals for display purposes
248         creator = msg.sender;                    // creator holds all tokens
249     }
250 
251     /* Send coins */
252     function transfer(address _to, uint256 _value) whenNotPaused notHolderAndPE public returns (bool success){
253         require(_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
254         require(_value > 0);
255         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
256         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
257         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
258         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
259         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
260         return true;
261     }
262 
263 
264     /* Allow another contract to spend some tokens in your behalf */
265     function approve(address _spender, uint256 _value) whenNotPaused notHolderAndPE public returns (bool success) {
266         require(_value > 0);
267         allowance[msg.sender][_spender] = _value;
268         return true;
269     }
270 
271 
272     /* A contract attempts to get the coins */
273     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
274         require (_to != address(0x0));                                // Prevent transfer to 0x0 address. Use burn() instead
275         require (_value > 0);
276         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
277         require (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
278         require (_value <= allowance[_from][msg.sender]);     // Check allowance
279         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
280         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
281         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
282         emit Transfer(_from, _to, _value);
283         return true;
284     }
285 
286     /* Approve and then communicate the approved contract in a single tx */
287     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) whenNotPaused notHolderAndPE public returns (bool success) {
288         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
289         if (approve(_spender, _value)) {
290             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
291             return true;
292         }
293         return false;
294     }
295 
296     // User attempts to mapping to mainnet
297     function mappingTo(string memory to, uint256 _value) notHolderAndPE public returns (bool success){
298         require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
299         require(_value > 0);
300         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
301         totalSupply = SafeMath.safeSub(totalSupply, _value);                                // Updates totalSupply
302         emit MappingTo(msg.sender, to, _value);
303         return true;
304     }
305 
306     // Outside-visible transact entry point. Executes transacion immediately if below daily spend limit.
307     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
308     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
309     // and _data arguments). They still get the option of using them if they want, anyways.
310     function execute(address _to, uint _value) external onlyOwner returns (bytes32 _r) {
311         _r = keccak256(abi.encode(msg.data, block.number));
312         if (!confirm(_r) && m_txs[_r].to == address(0)) {
313             m_txs[_r].to = _to;
314             m_txs[_r].value = _value;
315             emit ConfirmationNeeded(_r, msg.sender, _value, _to);
316         }
317     }
318 
319     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
320     // to determine the body of the transaction from the hash provided.
321     function confirm(bytes32 _h) public onlyManyOwners(_h) returns (bool) {
322         uint256 _value = m_txs[_h].value;
323         address _to = m_txs[_h].to;
324         if (_to != address(0)) {
325             require(_value > 0);
326             require(balanceOf[creator] >= _value);           // Check if the sender has enough
327             require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
328             balanceOf[creator] = SafeMath.safeSub(balanceOf[creator], _value);                     // Subtract from the sender
329             balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
330             emit Transfer(creator, _to, _value);                   // Notify anyone listening that this transfer took place
331             delete m_txs[_h];
332             return true;
333         }
334         return false;
335     }
336 
337     function addPEAccount(address _to) public onlyOwner{
338         PEAccounts[_to] = true;
339     }
340 
341     function delPEAccount(address _to) public onlyOwner {
342         delete PEAccounts[_to];
343     }
344 
345     function () external payable {
346     }
347 
348     // transfer balance to owner
349     function withdrawEther(uint256 amount) public onlyOwner{
350         msg.sender.transfer(amount);
351     }
352 }