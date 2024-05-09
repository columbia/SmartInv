1 contract DSFalseFallback {
2     function() returns (bool) {
3         return false;
4     }
5 }
6 
7 contract DSTrueFallback {
8     function() returns (bool) {
9         return true;
10     }
11 }
12 
13 contract DSAuthModesEnum {
14     enum DSAuthModes {
15         Owner,
16         Authority
17     }
18 }
19 
20 contract DSAuthUtils is DSAuthModesEnum {
21     function setOwner( DSAuthorized what, address owner ) internal {
22         what.updateAuthority( owner, DSAuthModes.Owner );
23     }
24     function setAuthority( DSAuthorized what, DSAuthority authority ) internal {
25         what.updateAuthority( authority, DSAuthModes.Authority );
26     }
27 }
28 contract DSAuthorizedEvents is DSAuthModesEnum {
29     event DSAuthUpdate( address indexed auth, DSAuthModes indexed mode );
30 }
31 
32 
33 // `DSAuthority` is the interface which `DSAuthorized` (`DSAuth`) contracts expect
34 // their authority to be when they are in the remote auth mode.
35 contract DSAuthority {
36     // `can_call` will be called with these arguments in the caller's
37     // scope if it is coming from an `auth()` call:
38     // `DSAuthority(_ds_authority).can_call(msg.sender, address(this), msg.sig);`
39     function canCall( address caller
40                     , address callee
41                     , bytes4 sig )
42              constant
43              returns (bool);
44 }
45 
46 
47 contract AcceptingAuthority is DSTrueFallback {}
48 contract RejectingAuthority is DSFalseFallback {}
49 
50 // `DSAuthorized` is a mixin contract which enables standard authorization patterns.
51 // It has a shorter alias `auth/auth.sol: DSAuth` because it is so common.
52 contract DSAuthorized is DSAuthModesEnum, DSAuthorizedEvents
53 {
54     // There are two "modes":
55     // * "owner mode", where `auth()` simply checks if the sender is `_authority`.
56     //   This is the default mode, when `_auth_mode` is false.
57     // * "authority mode", where `auth()` makes a call to
58     // `DSAuthority(_authority).canCall(sender, this, sig)` to ask if the
59     // call should be allowed.
60     DSAuthModes  public _auth_mode;
61     DSAuthority  public _authority;
62 
63     function DSAuthorized() {
64         _authority = DSAuthority(msg.sender);
65         _auth_mode = DSAuthModes.Owner;
66         DSAuthUpdate( msg.sender, DSAuthModes.Owner );
67     }
68 
69     // Attach the `auth()` modifier to functions to protect them.
70     modifier auth() {
71         if( isAuthorized() ) {
72             _
73         } else {
74             throw;
75         }
76     }
77     // A version of `auth()` which implicitly returns garbage instead of throwing.
78     modifier try_auth() {
79         if( isAuthorized() ) {
80             _
81         }
82     }
83 
84     // An internal helper function for if you want to use the `auth()` logic
85     // someplace other than the modifier (like in a fallback function).
86     function isAuthorized() internal returns (bool is_authorized) {
87         if( _auth_mode == DSAuthModes.Owner ) {
88             return msg.sender == address(_authority);
89         }
90         if( _auth_mode == DSAuthModes.Authority ) { // use `canCall` in "authority" mode
91             return _authority.canCall( msg.sender, address(this), msg.sig );
92         }
93         throw;
94     }
95 
96     // This function is used to both transfer the authority and update the mode.
97     // Be extra careful about setting *both* correctly every time.
98     function updateAuthority( address new_authority, DSAuthModes mode )
99              auth()
100     {
101         _authority = DSAuthority(new_authority);
102         _auth_mode = mode;
103         DSAuthUpdate( new_authority, mode );
104     }
105 }
106 
107 
108 
109 
110 
111 
112 contract DSAuth is DSAuthorized {} //, is DSAuthorizedEvents, DSAuthModesEnum
113 contract DSAuthUser is DSAuthUtils {} //, is DSAuthModesEnum {}
114 
115 contract DSActionStructUser {
116     struct Action {
117         address target;
118         uint value;
119         bytes calldata;
120         // bool triggered;
121     }
122     // todo store call_ret by default?
123 }
124 // A base contract used by governance contracts in `gov` and by the generic `DSController`.
125 contract DSBaseActor is DSActionStructUser {
126     // todo gas???
127     function tryExec(Action a) internal returns (bool call_ret) {
128         return a.target.call.value(a.value)(a.calldata);
129     }
130     function exec(Action a) internal {
131         if(!tryExec(a)) {
132             throw;
133         }
134     }
135     function tryExec( address target, bytes calldata, uint value)
136              internal
137              returns (bool call_ret)
138     {
139         return target.call.value(value)(calldata);
140     }
141     function exec( address target, bytes calldata, uint value)
142              internal
143     {
144         if(!tryExec(target, calldata, value)) {
145             throw;
146         }
147     }
148 }
149 
150 contract DSEasyMultisigEvents {
151     event MemberAdded(address who);
152     event Proposed(uint indexed action_id, bytes calldata);
153     event Confirmed(uint indexed action_id, address who);
154     event Triggered(uint indexed action_id);
155 }
156 
157 /* A multisig actor optimized for ease of use.
158  * The user never has to pack their own calldata. Instead, use `easyPropose`.
159  * This eliminates the need for UI support or helper contracts.
160  *
161  * To set up the multisig, specify the arguments, then add members
162  *
163  * First, call the multisig contract itself as if it were your target contract,
164  * with the correct calldata. You can make Solidity and web3.js to do this for
165  * you very easily by casting the multisig address as the target type.
166  * Then, you call `easyPropose` with the missing arguments. This calls `propose`.
167  *
168  * "last calldata" is "local" to the `msg.sender`. This makes it usable directly
169  * from keys (but still not as secure as if it were atomic using a helper contract).
170  *
171  * In Soldity:
172  * 1) `TargetType(address(multisig)).doAction(arg1, arg2);`
173  * 2) `multisig.easyPropose(address(target), value);`
174  *
175  * This is equivalent to `propose(address(my_target), <calldata>, value);`,
176  * where calldata is correctly formatted for `TargetType(target).doAction(arg1, arg2)`
177  */
178 contract DSEasyMultisig is DSBaseActor
179                          , DSEasyMultisigEvents
180                          , DSAuthUser
181                          , DSAuth
182 {
183     // How many confirmations an action needs to execute.
184     uint _required;
185     // How many members this multisig has. Members must be distinct addresses.
186     uint _member_count;
187     // Auto-locks once this reaches zero - easy setup phase.
188     uint _members_remaining;
189     // Maximum time between proposal time and trigger time.
190     uint _expiration;
191     // Action counter
192     uint _last_action_id;
193 
194 
195     struct action {
196         address target;
197         bytes calldata;
198         uint value;
199 
200         uint confirmations; // If this number reaches `required`, you can trigger
201         uint expiration; // Last timestamp this action can execute
202         bool triggered; // Was this action successfully triggered (multisig does not catch exceptions)
203     }
204 
205     mapping( uint => action ) actions;
206 
207     // action_id -> member -> confirmed
208     mapping( uint => mapping( address => bool ) ) confirmations;
209     // A record of the last fallback calldata recorded for this sender.
210     // This is an easy way to create proposals for most actions.
211     mapping( address => bytes ) easy_calldata;
212     // Only these addresses can add confirmations
213     mapping( address => bool ) is_member;
214 
215     function DSEasyMultisig( uint required, uint member_count, uint expiration ) {
216         _required = required;
217         _member_count = member_count;
218         _members_remaining = member_count;
219         _expiration = expiration;
220     }
221     // The authority can add members until they reach `member_count`, and then
222     // the contract is finalized (`updateAuthority(0, DSAuthModes.Owner)`),
223     // meaning addMember will always throw.
224     function addMember( address who ) auth()
225     {
226         if( is_member[who] ) {
227             throw;
228         }
229         is_member[who] = true;
230         MemberAdded(who);
231         _members_remaining--;
232         if( _members_remaining == 0 ) {
233             updateAuthority( address(0x0), DSAuthModes.Owner );
234         }
235     }
236     function isMember( address who ) constant returns (bool) {
237         return is_member[who];
238     }
239 
240     // Some constant getters
241     function getInfo()
242              constant
243              returns ( uint required, uint members, uint expiration, uint last_proposed_action)
244     {
245         return (_required, _member_count, _expiration, _last_action_id);
246     }
247     // Public getter for the action mapping doesn't work in web3.js yet
248     function getActionStatus(uint action_id)
249              constant
250              returns (uint confirmations, uint expiration, bool triggered, address target, uint eth_value)
251     {
252         var a = actions[action_id];
253         return (a.confirmations, a.expiration, a.triggered, a.target, a.value);
254     }
255 
256     // `propose` an action using the calldata from this sender's last call.
257     function easyPropose( address target, uint value ) returns (uint action_id) {
258         return propose( target, easy_calldata[msg.sender], value );
259     }
260     function() {
261         easy_calldata[msg.sender] = msg.data;
262     }
263 
264     // Propose an action.
265     // Anyone can propose an action.
266     // Only members can confirm actions.
267     function propose( address target, bytes calldata, uint value )
268              returns (uint action_id)
269     {
270         action memory a;
271         a.target = target;
272         a.calldata = calldata;
273         a.value = value;
274         a.expiration = block.timestamp + _expiration;
275         // Increment first because, 0 is not a valid ID.
276         _last_action_id++;
277         actions[_last_action_id] = a;
278         Proposed(_last_action_id, calldata);
279         return _last_action_id;
280     }
281 
282     // Attempts to confirm the action.
283     // Only members can confirm actions.
284     function confirm( uint action_id ) returns (bool confirmed) {
285         if( !is_member[msg.sender] ) {
286             throw;
287         }
288         if( confirmations[action_id][msg.sender] ) {
289             throw;
290         }
291         if( action_id > _last_action_id ) {
292             throw;
293         }
294         var a = actions[action_id];
295         if( block.timestamp > a.expiration ) {
296             throw;
297         }
298         if( a.triggered ) {
299             throw;
300         }
301         confirmations[action_id][msg.sender] = true;
302         a.confirmations = a.confirmations + 1;
303         actions[action_id] = a;
304         Confirmed(action_id, msg.sender);
305     }
306 
307     // Attempts to trigger the action.
308     // Fails if there are not enough confirmations or if the action has expired.
309     function trigger( uint action_id ) {
310         var a = actions[action_id];
311         if( a.confirmations < _required ) {
312             throw;
313         }
314         if( block.timestamp > a.expiration ) {
315             throw;
316         }
317         if( a.triggered ) {
318             throw;
319         }
320         if( this.balance < a.value ) {
321             throw;
322         }
323         a.triggered = true;
324         exec( a.target, a.calldata, a.value );
325         actions[action_id] = a;
326         Triggered(action_id);
327     }
328 }