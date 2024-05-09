1 contract Multiowned {
2 
3     // TYPES
4 
5     // struct for the status of a pending operation.
6     struct PendingState {
7         uint yetNeeded;
8         uint ownersDone;
9         uint index;
10     }
11 
12     // EVENT
13 
14     // this contract only has five types of events: it can accept a confirmation, in which case
15     // we record owner and operation (hash) alongside it.
16     event Confirmation(address owner, bytes32 operation);
17     event Revoke(address owner, bytes32 operation);
18     // some others are in the case of an owner changing.
19     event OwnerChanged(address oldOwner, address newOwner, bytes32 operation);
20     event OwnerAdded(address newOwner, bytes32 operation);
21     event OwnerRemoved(address oldOwner, bytes32 operation);
22     // the last one is emitted if the required signatures change
23     event RequirementChanged(uint newRequirement, bytes32 operation);
24     event Operation(bytes32 operation);
25 
26 
27     // MODIFIERS
28 
29     // simple single-sig function modifier.
30     modifier onlyOwner {
31         if (isOwner(msg.sender))
32             _;
33     }
34     // multi-sig function modifier: the operation must have an intrinsic hash in order
35     // that later attempts can be realised as the same underlying operation and
36     // thus count as confirmations.
37     modifier onlyManyOwners(bytes32 _operation) {
38         Operation(_operation);
39         if (confirmAndCheck(_operation))
40             _;
41     }
42 
43     // METHODS
44 
45     // constructor is given number of sigs required to do protected "onlyManyOwners" transactions
46     // as well as the selection of addresses capable of confirming them.
47     function Multiowned() public{
48         m_numOwners = 1;
49         m_owners[1] = uint(msg.sender);
50         m_ownerIndex[uint(msg.sender)] = 1;
51         m_required = 1;
52     }
53     
54     // Revokes a prior confirmation of the given operation
55     function revoke(bytes32 _operation) external {
56         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
57         // make sure they're an owner
58         if (ownerIndex == 0) return;
59         uint ownerIndexBit = 2**ownerIndex;
60         var pending = m_pending[_operation];
61         if (pending.ownersDone & ownerIndexBit > 0) {
62             pending.yetNeeded++;
63             pending.ownersDone -= ownerIndexBit;
64             Revoke(msg.sender, _operation);
65         }
66     }
67     
68     // Replaces an owner `_from` with another `_to`.
69     function changeOwner(address _from, address _to) onlyManyOwners(keccak256(msg.data)) external {
70         if (isOwner(_to)) return;
71         uint ownerIndex = m_ownerIndex[uint(_from)];
72         if (ownerIndex == 0) return;
73 
74         clearPending();
75         m_owners[ownerIndex] = uint(_to);
76         m_ownerIndex[uint(_from)] = 0;
77         m_ownerIndex[uint(_to)] = ownerIndex;
78         OwnerChanged(_from, _to, keccak256(msg.data));
79     }
80     
81     function addOwner(address _owner) onlyManyOwners(keccak256(msg.data)) external {
82         if (isOwner(_owner)) return;
83 
84         clearPending();
85         if (m_numOwners >= c_maxOwners)
86             reorganizeOwners();
87         if (m_numOwners >= c_maxOwners)
88             return;
89         m_numOwners++;
90         m_owners[m_numOwners] = uint(_owner);
91         m_ownerIndex[uint(_owner)] = m_numOwners;
92         OwnerAdded(_owner,keccak256(msg.data));
93     }
94     
95     function removeOwner(address _owner) onlyManyOwners(keccak256(msg.data)) external {
96         uint ownerIndex = m_ownerIndex[uint(_owner)];
97         if (ownerIndex == 0) return;
98         if (m_required > m_numOwners - 1) return;
99 
100         m_owners[ownerIndex] = 0;
101         m_ownerIndex[uint(_owner)] = 0;
102         clearPending();
103         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
104         OwnerRemoved(_owner,keccak256(msg.data));
105     }
106     
107     function changeRequirement(uint _newRequired) onlyManyOwners(keccak256(msg.data)) external {
108         if (_newRequired > m_numOwners) return;
109         m_required = _newRequired;
110         clearPending();
111         RequirementChanged(_newRequired,keccak256(msg.data));
112     }
113 
114     function isOwner(address _addr) view public returns (bool){
115         return m_ownerIndex[uint(_addr)] > 0;
116     }
117     
118     //when the voting is complate, hasConfirmed return false
119     //if the voteing is ongoing, it returns whether _owner has voted the _operation
120     function hasConfirmed(bytes32 _operation, address _owner) view public returns (bool) {
121         var pending = m_pending[_operation];
122         uint ownerIndex = m_ownerIndex[uint(_owner)];
123 
124         // make sure they're an owner
125         if (ownerIndex == 0) return false;
126 
127         // determine the bit to set for this owner.
128         uint ownerIndexBit = 2**ownerIndex;
129         return !(pending.ownersDone & ownerIndexBit == 0);
130     }
131     
132     // INTERNAL METHODS
133 
134     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
135         // determine what index the present sender is:
136         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
137         // make sure they're an owner
138         if (ownerIndex == 0) return;
139 
140         var pending = m_pending[_operation];
141         // if we're not yet working on this operation, switch over and reset the confirmation status.
142         if (pending.yetNeeded == 0) {
143             // reset count of confirmations needed.
144             pending.yetNeeded = m_required;
145             // reset which owners have confirmed (none) - set our bitmap to 0.
146             pending.ownersDone = 0;
147             pending.index = m_pendingIndex.length++;
148             m_pendingIndex[pending.index] = _operation;
149         }
150         // determine the bit to set for this owner.
151         uint ownerIndexBit = 2**ownerIndex;
152         // make sure we (the message sender) haven't confirmed this operation previously.
153         if (pending.ownersDone & ownerIndexBit == 0) {
154             Confirmation(msg.sender, _operation);
155             // ok - check if count is enough to go ahead.
156             if (pending.yetNeeded <= 1) {
157                 // enough confirmations: reset and run interior.
158                 delete m_pendingIndex[m_pending[_operation].index];
159                 delete m_pending[_operation];
160                 return true;
161             }
162             else
163             {
164                 // not enough: record that this owner in particular confirmed.
165                 pending.yetNeeded--;
166                 pending.ownersDone |= ownerIndexBit;
167             }
168         }
169     }
170 
171     function reorganizeOwners() private {
172         uint free = 1;
173         while (free < m_numOwners)
174         {
175             while (free < m_numOwners && m_owners[free] != 0) free++;
176             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
177             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
178             {
179                 m_owners[free] = m_owners[m_numOwners];
180                 m_ownerIndex[m_owners[free]] = free;
181                 m_owners[m_numOwners] = 0;
182             }
183         }
184     }
185     
186     function clearPending() internal {
187         uint length = m_pendingIndex.length;
188         for (uint i = 0; i < length; ++i)
189             if (m_pendingIndex[i] != 0)
190                 delete m_pending[m_pendingIndex[i]];
191         delete m_pendingIndex;
192     }
193         
194     // FIELDS
195 
196     // the number of owners that must confirm the same operation before it is run.
197     uint public m_required;
198     // pointer used to find a free slot in m_owners
199     uint public m_numOwners;
200     
201     // list of owners
202     uint[256] m_owners;
203     uint constant c_maxOwners = 250;
204     // index on the list of owners to allow reverse lookup
205     mapping(uint => uint) m_ownerIndex;
206     // the ongoing operations.
207     mapping(bytes32 => PendingState) m_pending;
208     bytes32[] m_pendingIndex;
209 }
210 
211 contract Token {
212     /* This is a slight change to the ERC20 base standard.
213     function totalSupply() constant returns (uint256 supply);
214     is replaced with:
215     uint256 public totalSupply;
216     This automatically creates a getter function for the totalSupply.
217     This is moved to the base contract since public getter functions are not
218     currently recognised as an implementation of the matching abstract
219     function by the compiler.
220     */
221     /// total amount of tokens
222     uint256 public totalSupply;
223 
224     /// @param _owner The address from which the balance will be retrieved
225     /// @return The balance
226     function balanceOf(address _owner) public view returns (uint256 balance);
227 
228     /// @notice send `_value` token to `_to` from `msg.sender`
229     /// @param _to The address of the recipient
230     /// @param _value The amount of token to be transferred
231     /// @return Whether the transfer was successful or not
232     function transfer(address _to, uint256 _value) public returns (bool success);
233 
234     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
235     /// @param _from The address of the sender
236     /// @param _to The address of the recipient
237     /// @param _value The amount of token to be transferred
238     /// @return Whether the transfer was successful or not
239     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
240 
241     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
242     /// @param _spender The address of the account able to transfer the tokens
243     /// @param _value The amount of tokens to be approved for transfer
244     /// @return Whether the approval was successful or not
245     function approve(address _spender, uint256 _value) public returns (bool success);
246 
247     /// @param _owner The address of the account owning tokens
248     /// @param _spender The address of the account able to transfer the tokens
249     /// @return Amount of remaining tokens allowed to spent
250     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
251 
252     event Transfer(address indexed _from, address indexed _to, uint256 _value);
253     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
254 }
255 
256 contract StandardToken is Token {
257 
258     uint256 constant MAX_UINT256 = 2**256 - 1;
259 
260     function transfer(address _to, uint256 _value) public returns (bool success) {
261         //Default assumes totalSupply can't be over max (2^256 - 1).
262         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
263         //Replace the if with this one instead.
264         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
265         require(balances[msg.sender] >= _value);
266         balances[msg.sender] -= _value;
267         balances[_to] += _value;
268         Transfer(msg.sender, _to, _value);
269         return true;
270     }
271 
272     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
273         //same as above. Replace this line with the following if you want to protect against wrapping uints.
274         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
275         uint256 allowance = allowed[_from][msg.sender];
276         require(balances[_from] >= _value && allowance >= _value);
277         balances[_to] += _value;
278         balances[_from] -= _value;
279         if (allowance < MAX_UINT256) {
280             allowed[_from][msg.sender] -= _value;
281         }
282         Transfer(_from, _to, _value);
283         return true;
284     }
285 
286     function balanceOf(address _owner) view public returns (uint256 balance) {
287         return balances[_owner];
288     }
289 
290     function approve(address _spender, uint256 _value) public returns (bool success) {
291         allowed[msg.sender][_spender] = _value;
292         Approval(msg.sender, _spender, _value);
293         return true;
294     }
295 
296     function allowance(address _owner, address _spender)
297     view public returns (uint256 remaining) {
298       return allowed[_owner][_spender];
299     }
300 
301     mapping (address => uint256) balances;
302     mapping (address => mapping (address => uint256)) allowed;
303 }
304 
305 
306 contract UGCoin is Multiowned, StandardToken {
307 
308     event Freeze(address from, uint value);
309     event Defreeze(address ownerAddr, address userAddr, uint256 amount);
310     event ReturnToOwner(address ownerAddr, uint amount);
311     event Destroy(address from, uint value);
312 
313     function UGCoin() public Multiowned(){
314         balances[msg.sender] = initialAmount;   // Give the creator all initial balances is defined in StandardToken.sol
315         totalSupply = initialAmount;              // Update total supply, totalSupply is defined in Tocken.sol
316     }
317 
318     function() public {
319 
320     }
321     
322     /* transfer UGC to DAS */
323     function freeze(uint256 _amount) external returns (bool success){
324         require(balances[msg.sender] >= _amount);
325         coinPool += _amount;
326         balances[msg.sender] -= _amount;
327         Freeze(msg.sender, _amount);
328         return true;
329     }
330 
331     /* transfer UGC from DAS */
332     function defreeze(address _userAddr, uint256 _amount) onlyOwner external returns (bool success){
333         require(balances[msg.sender] >= _amount); //msg.sender is a owner
334         require(coinPool >= _amount);
335         balances[_userAddr] += _amount;
336         balances[msg.sender] -= _amount;
337         ownersLoan[msg.sender] += _amount;
338         Defreeze(msg.sender, _userAddr, _amount);
339         return true;
340     }
341 
342     function returnToOwner(address _ownerAddr, uint256 _amount) onlyManyOwners(keccak256(msg.data)) external returns (bool success){
343         require(coinPool >= _amount);
344         require(isOwner(_ownerAddr));
345         require(ownersLoan[_ownerAddr] >= _amount);
346         balances[_ownerAddr] += _amount;
347         coinPool -= _amount;
348         ownersLoan[_ownerAddr] -= _amount;
349         ReturnToOwner(_ownerAddr, _amount);
350         return true;
351     }
352     
353     function destroy(uint256 _amount) external returns (bool success){
354         require(balances[msg.sender] >= _amount);
355         balances[msg.sender] -= _amount;
356         totalSupply -= _amount;
357         Destroy(msg.sender, _amount);
358         return true;
359     }
360 
361     function getOwnersLoan(address _ownerAddr) view public returns (uint256){
362         return ownersLoan[_ownerAddr];
363     }
364 
365     /* Approves and then calls the receiving contract */
366     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
367         allowed[msg.sender][_spender] = _value;
368         Approval(msg.sender, _spender, _value);
369 
370         //call the receiveApproval function on the contract you want to be notified. 
371         //This crafts the function signature manually so one doesn't have to include a contract in here just for this.
372         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
373         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
374         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
375         return true;
376     }
377 
378     string public name = "UG Coin";
379     uint8 public decimals = 18;
380     string public symbol = "UGC";
381     string public version = "v0.1";
382     uint256 public initialAmount = (10 ** 9) * (10 ** 18);
383     uint256 public coinPool = 0;      // coinPool is a pool for freezing UGC
384     mapping (address => uint256) ownersLoan;      // record the amount of UGC paid by oweners for freezing UGC
385 
386 }