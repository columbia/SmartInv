1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.23;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.*/
7     /// total amount of tokens
8     uint256 public totalSupply;
9 
10     /// @param _owner The address from which the balance will be retrieved
11     /// @return The balance
12     function balanceOf(address _owner) public constant returns (uint256 balance);
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint256 _value) public returns (bool success);
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of tokens to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint256 _value) public returns (bool success);
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function add(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a + b;
49     assert(c>=a && c>=b);
50     return c;
51   }
52 }
53 
54 contract Owned {
55 
56     /// `owner` is the only address that can call a function with this
57     /// modifier
58     modifier isOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     address public owner;
64 
65     /// @notice The constructor assigns the message sender to be `owner`
66     constructor() public {
67         owner = msg.sender;
68     }
69     
70     address newOwner=0x0;
71 
72     event OwnerUpdate(address _prevOwner, address _newOwner);
73 
74     ///change the owner
75     function changeOwner(address _newOwner) public isOwner {
76         require(_newOwner != owner);
77         newOwner = _newOwner;
78     }
79 
80     /// accept the ownership
81     function acceptOwnership() public{
82         require(msg.sender == newOwner);
83         emit OwnerUpdate(owner, newOwner);
84         owner = newOwner;
85         newOwner = 0x0;
86     }
87 }
88 
89 contract Controlled is Owned{
90 
91     constructor() public {
92        setExclude(msg.sender);
93     }
94 
95     // Flag that determines if the token is transferable or not.
96     bool public transferEnabled = false;
97 
98     // flag that makes locked address effect
99     bool public lockFlag=true;
100     mapping(address => bool) public locked;
101     mapping(address => bool) public exclude;
102 
103     function enableTransfer(bool _enable) public isOwner{
104         transferEnabled=_enable;
105     }
106 
107     function disableLock(bool _enable) public isOwner returns (bool success){
108         lockFlag=_enable;
109         return true;
110     }
111 
112     function addLock(address _addr) public isOwner returns (bool success){
113         require(_addr!=msg.sender);
114         locked[_addr]=true;
115         return true;
116     }
117 
118     function setExclude(address _addr) public isOwner returns (bool success){
119         exclude[_addr]=true;
120         return true;
121     }
122 
123     function removeLock(address _addr) public isOwner returns (bool success){
124         locked[_addr]=false;
125         return true;
126     }
127 
128     modifier transferAllowed(address _addr) {
129         if (!exclude[_addr]) {
130             assert(transferEnabled);
131             if(lockFlag){
132                 assert(!locked[_addr]);
133             }
134         }
135 
136         _;
137     }
138     modifier validAddress(address _addr) {
139         assert(0x0 != _addr && 0x0 != msg.sender);
140         _;
141     }
142 }
143 
144 contract StandardToken is Token,Controlled {
145 
146     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) validAddress(_to) returns (bool success) {
147         //Default assumes totalSupply can't be over max (2^256 - 1).
148         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
149         //Replace the if with this one instead.
150         require(_value > 0);
151         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
152             balances[msg.sender] -= _value;
153             balances[_to] += _value;
154             emit Transfer(msg.sender, _to, _value);
155             return true;
156         } else { return false; }
157     }
158 
159     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) validAddress(_to) returns (bool success) {
160         //same as above. Replace this line with the following if you want to protect against wrapping uints.
161         require(_value > 0);
162         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
163             balances[_to] += _value;
164             balances[_from] -= _value;
165             allowed[_from][msg.sender] -= _value;
166             emit Transfer(_from, _to, _value);
167             return true;
168         } else { return false; }
169     }
170 
171     function balanceOf(address _owner) public constant returns (uint256 balance) {
172         return balances[_owner];
173     }
174 
175     function approve(address _spender, uint256 _value) public returns (bool success) {
176         require(_value > 0);
177         allowed[msg.sender][_spender] = _value;
178         emit Approval(msg.sender, _spender, _value);
179         return true;
180     }
181 
182     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
183       return allowed[_owner][_spender];
184     }
185 
186     mapping (address => uint256) balances;
187     mapping (address => mapping (address => uint256)) allowed;
188 }
189 
190 contract MTC is StandardToken {
191 
192     function () public {
193         revert();
194     }
195 
196     using SafeMath for uint256;
197     string public name = "MTC Mesh Network";
198     uint8 public decimals = 18;
199     string public symbol = "MTC";
200 
201 
202     // The nonce for avoid transfer replay attacks
203     mapping(address => uint256) nonces;
204 
205     constructor (uint256 initialSupply) public {
206         totalSupply = initialSupply * 10 ** uint256(decimals);
207         balances[msg.sender] = totalSupply;
208     }
209     
210     function setName(string _name) isOwner public {
211         name = _name;
212     }
213     
214     /*
215      * Proxy transfer token. When some users of the ethereum account has no ether,
216      * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
217      * @param _from
218      * @param _to
219      * @param _value
220      * @param fee
221      * @param _v
222      * @param _r
223      * @param _s
224      */
225     function transferProxy(address _from, address _to, uint256 _value, uint256 _fee,
226         uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){
227 
228         require(_value > 0);
229         if(balances[_from] < _fee.add(_value)) revert();
230 
231         uint256 nonce = nonces[_from];
232         bytes32 h = keccak256(_from,_to,_value,_fee,nonce);
233         if(_from != ecrecover(h,_v,_r,_s)) revert();
234 
235         if(balances[_to].add(_value) < balances[_to]
236             || balances[msg.sender].add(_fee) < balances[msg.sender]) revert();
237         balances[_to] += _value;
238         emit Transfer(_from, _to, _value);
239 
240         balances[msg.sender] += _fee;
241         emit Transfer(_from, msg.sender, _fee);
242 
243         balances[_from] -= _value.add(_fee);
244         nonces[_from] = nonce + 1;
245         return true;
246     }
247 
248     /*
249      * Proxy approve that some one can authorize the agent for broadcast transaction
250      * @param _from The address which should tranfer tokens to others
251      * @param _spender The spender who allowed by _from
252      * @param _value The value that should be tranfered.
253      * @param _v
254      * @param _r
255      * @param _s
256      */
257     function approveProxy(address _from, address _spender, uint256 _value,
258         uint8 _v,bytes32 _r, bytes32 _s) public returns (bool success) {
259 
260         require(_value > 0);
261         uint256 nonce = nonces[_from];
262         bytes32 hash = keccak256(_from,_spender,_value,nonce);
263         if(_from != ecrecover(hash,_v,_r,_s)) revert();
264         allowed[_from][_spender] = _value;
265         emit Approval(_from, _spender, _value);
266         nonces[_from] = nonce + 1;
267         return true;
268     }
269 
270 
271     /*
272      * Get the nonce
273      * @param _addr
274      */
275     function getNonce(address _addr) public constant returns (uint256){
276         return nonces[_addr];
277     }
278 
279     /* Approves and then calls the receiving contract */
280     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
281         allowed[msg.sender][_spender] = _value;
282         emit Approval(msg.sender, _spender, _value);
283 
284         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
285         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
286         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
287         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
288         return true;
289     }
290 
291     /* Approves and then calls the contract code*/
292     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
293         allowed[msg.sender][_spender] = _value;
294         emit Approval(msg.sender, _spender, _value);
295 
296         //Call the contract code
297         if(!_spender.call(_extraData)) { revert(); }
298         return true;
299     }
300     // Allocate tokens to the users
301     // @param _owners The owners list of the token
302     // @param _values The value list of the token
303     function allocateTokens(address[] _owners, uint256[] _values) public isOwner {
304         if(_owners.length != _values.length) revert();
305         for(uint256 i = 0; i < _owners.length ; i++){
306             address to = _owners[i];
307             uint256 value = _values[i];
308             balances[owner] -= value;
309             balances[to] += value;
310         }
311     }
312 }