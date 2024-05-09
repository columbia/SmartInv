1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.15;
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
42 contract Owned {
43 
44     /// `owner` is the only address that can call a function with this
45     /// modifier
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     address public owner;
52 
53     /// @notice The Constructor assigns the message sender to be `owner`
54     function Owned() public {
55         owner = msg.sender;
56     }
57 
58     address newOwner=0x0;
59 
60     event OwnerUpdate(address _prevOwner, address _newOwner);
61 
62     ///change the owner
63     function changeOwner(address _newOwner) public onlyOwner {
64         require(_newOwner != owner);
65         newOwner = _newOwner;
66     }
67 
68     /// accept the ownership
69     function acceptOwnership() public{
70         require(msg.sender == newOwner);
71         OwnerUpdate(owner, newOwner);
72         owner = newOwner;
73         newOwner = 0x0;
74     }
75 }
76 
77 contract Controlled is Owned{
78 
79     function Controlled() public {
80        setExclude(msg.sender);
81     }
82 
83     // Flag that determines if the token is transferable or not.
84     bool public transferEnabled = false;
85 
86     // flag that makes locked address effect
87     bool lockFlag=true;
88     mapping(address => bool) locked;
89     mapping(address => bool) exclude;
90 
91     function enableTransfer(bool _enable) public onlyOwner{
92         transferEnabled=_enable;
93     }
94 
95     function disableLock(bool _enable) public onlyOwner returns (bool success){
96         lockFlag=_enable;
97         return true;
98     }
99 
100     function addLock(address[] _addrs) public onlyOwner returns (bool success){
101         for (uint256 i = 0; i < _addrs.length; i++){
102             locked[_addrs[i]]=true;
103          }
104         return true;
105     }
106 
107     function setExclude(address _addr) public onlyOwner returns (bool success){
108         exclude[_addr]=true;
109         return true;
110     }
111 
112     function removeLock(address[] _addrs) public onlyOwner returns (bool success){
113         for (uint256 i = 0; i < _addrs.length; i++){
114             locked[_addrs[i]]=false;
115          }
116         return true;
117     }
118 
119     modifier transferAllowed(address _addr) {
120         if (!exclude[_addr]) {
121             assert(transferEnabled);
122             if(lockFlag){
123                 assert(!locked[_addr]);
124             }
125         }
126         
127         _;
128     }
129 
130 }
131 
132 contract StandardToken is Token,Controlled {
133 
134     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {
135         //Default assumes totalSupply can't be over max (2^256 - 1).
136         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
137         //Replace the if with this one instead.
138         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
139             balances[msg.sender] -= _value;
140             balances[_to] += _value;
141             Transfer(msg.sender, _to, _value);
142             return true;
143         } else { return false; }
144     }
145 
146     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {
147         //same as above. Replace this line with the following if you want to protect against wrapping uints.
148         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
149             balances[_to] += _value;
150             balances[_from] -= _value;
151             allowed[_from][msg.sender] -= _value;
152             Transfer(_from, _to, _value);
153             return true;
154         } else { return false; }
155     }
156 
157     function balanceOf(address _owner) public constant returns (uint256 balance) {
158         return balances[_owner];
159     }
160 
161     function approve(address _spender, uint256 _value) public returns (bool success) {
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
168       return allowed[_owner][_spender];
169     }
170 
171     mapping (address => uint256) balances;
172     mapping (address => mapping (address => uint256)) allowed;
173 }
174 
175 contract MESH is StandardToken {
176 
177     function () public {
178         revert();
179     }
180 
181     string public name = "MeshBox";                   //fancy name
182     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
183     string public symbol = "MESH";                 //An identifier
184     string public version = 'v0.1';       //MESH 0.1 standard. Just an arbitrary versioning scheme.
185     uint256 public allocateEndTime;
186 
187     
188     // The nonce for avoid transfer replay attacks
189     mapping(address => uint256) nonces;
190 
191     function MESH() public {
192         allocateEndTime = now + 1 days;
193     }
194 
195     /*
196      * Proxy transfer MESH. When some users of the ethereum account has no ether,
197      * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
198      * @param _from
199      * @param _to
200      * @param _value
201      * @param feeMesh
202      * @param _v
203      * @param _r
204      * @param _s
205      */
206     function transferProxy(address _from, address _to, uint256 _value, uint256 _feeMesh,
207         uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){
208 
209         if(balances[_from] < _feeMesh + _value) revert();
210 
211         uint256 nonce = nonces[_from];
212         bytes32 h = keccak256(_from,_to,_value,_feeMesh,nonce,name);
213         if(_from != ecrecover(h,_v,_r,_s)) revert();
214 
215         if(balances[_to] + _value < balances[_to]
216             || balances[msg.sender] + _feeMesh < balances[msg.sender]) revert();
217         balances[_to] += _value;
218         Transfer(_from, _to, _value);
219 
220         balances[msg.sender] += _feeMesh;
221         Transfer(_from, msg.sender, _feeMesh);
222 
223         balances[_from] -= _value + _feeMesh;
224         nonces[_from] = nonce + 1;
225         return true;
226     }
227 
228     /*
229      * Proxy approve that some one can authorize the agent for broadcast transaction
230      * which call approve method, and agents may charge agency fees
231      * @param _from The address which should tranfer MESH to others
232      * @param _spender The spender who allowed by _from
233      * @param _value The value that should be tranfered.
234      * @param _v
235      * @param _r
236      * @param _s
237      */
238     function approveProxy(address _from, address _spender, uint256 _value,
239         uint8 _v,bytes32 _r, bytes32 _s) public returns (bool success) {
240 
241         uint256 nonce = nonces[_from];
242         bytes32 hash = keccak256(_from,_spender,_value,nonce,name);
243         if(_from != ecrecover(hash,_v,_r,_s)) revert();
244         allowed[_from][_spender] = _value;
245         Approval(_from, _spender, _value);
246         nonces[_from] = nonce + 1;
247         return true;
248     }
249 
250 
251     /*
252      * Get the nonce
253      * @param _addr
254      */
255     function getNonce(address _addr) public constant returns (uint256){
256         return nonces[_addr];
257     }
258 
259     /* Approves and then calls the receiving contract */
260     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
261         allowed[msg.sender][_spender] = _value;
262         Approval(msg.sender, _spender, _value);
263 
264         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
265         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
266         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
267         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
268         return true;
269     }
270 
271     /* Approves and then calls the contract code */
272     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
273         allowed[msg.sender][_spender] = _value;
274         Approval(msg.sender, _spender, _value);
275 
276         //Call the contract code
277         if(!_spender.call(_extraData)) { revert(); }
278         return true;
279     }
280 
281    /* Refundable tokens sent to the smart contract for misoperation of the user */
282     function getBackToken(address _spender,address _to,uint256 _value) public onlyOwner{
283         if(!_spender.call(bytes4(bytes32(keccak256("transfer(address,uint256)"))), _to, _value)) { revert(); }
284     }
285 
286     // Allocate tokens to the users
287     // @param _owners The owners list of the token
288     // @param _values The value list of the token
289     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
290 
291         if(allocateEndTime < now) revert();
292         if(_owners.length != _values.length) revert();
293 
294         for(uint256 i = 0; i < _owners.length ; i++){
295             address to = _owners[i];
296             uint256 value = _values[i];
297             if(totalSupply + value <= totalSupply || balances[to] + value <= balances[to]) revert();
298             totalSupply += value;
299             balances[to] += value;
300         }
301     }
302 }