1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
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
100     function addLock(address _addr) public onlyOwner returns (bool success){
101         require(_addr!=msg.sender);
102         locked[_addr]=true;
103         return true;
104     }
105 
106     function setExclude(address _addr) public onlyOwner returns (bool success){
107         exclude[_addr]=true;
108         return true;
109     }
110 
111     function removeLock(address _addr) public onlyOwner returns (bool success){
112         locked[_addr]=false;
113         return true;
114     }
115 
116     modifier transferAllowed(address _addr) {
117         if (!exclude[_addr]) {
118             assert(transferEnabled);
119             if(lockFlag){
120                 assert(!locked[_addr]);
121             }
122         }
123 
124         _;
125     }
126 
127 }
128 
129 contract StandardToken is Token,Controlled {
130 
131     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {
132         //Default assumes totalSupply can't be over max (2^256 - 1).
133         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
134         //Replace the if with this one instead.
135         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
136             balances[msg.sender] -= _value;
137             balances[_to] += _value;
138             Transfer(msg.sender, _to, _value);
139             return true;
140         } else { return false; }
141     }
142 
143     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {
144         //same as above. Replace this line with the following if you want to protect against wrapping uints.
145         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
146             balances[_to] += _value;
147             balances[_from] -= _value;
148             allowed[_from][msg.sender] -= _value;
149             Transfer(_from, _to, _value);
150             return true;
151         } else { return false; }
152     }
153 
154     function balanceOf(address _owner) public constant returns (uint256 balance) {
155         return balances[_owner];
156     }
157 
158     function approve(address _spender, uint256 _value) public returns (bool success) {
159         allowed[msg.sender][_spender] = _value;
160         Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
165       return allowed[_owner][_spender];
166     }
167 
168     mapping (address => uint256) balances;
169     mapping (address => mapping (address => uint256)) allowed;
170 }
171 
172 contract MESH is StandardToken {
173 
174     function () public {
175         revert();
176     }
177 
178     string public name = "M2C Mesh Network";
179     uint8 public decimals = 18;
180     string public symbol = "mesh";
181 
182 
183     // The nonce for avoid transfer replay attacks
184     mapping(address => uint256) nonces;
185 
186     function MESH (uint256 initialSupply) public {
187         totalSupply = initialSupply * 10 ** uint256(decimals);
188         balances[msg.sender] = totalSupply;
189     }
190     /*
191      * Proxy transfer token. When some users of the ethereum account has no ether,
192      * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
193      * @param _from
194      * @param _to
195      * @param _value
196      * @param fee
197      * @param _v
198      * @param _r
199      * @param _s
200      */
201     function transferProxy(address _from, address _to, uint256 _value, uint256 _fee,
202         uint8 _v,bytes32 _r, bytes32 _s) public transferAllowed(_from) returns (bool){
203 
204         if(balances[_from] < _fee + _value) revert();
205 
206         uint256 nonce = nonces[_from];
207         bytes32 h = keccak256(_from,_to,_value,_fee,nonce);
208         if(_from != ecrecover(h,_v,_r,_s)) revert();
209 
210         if(balances[_to] + _value < balances[_to]
211             || balances[msg.sender] + _fee < balances[msg.sender]) revert();
212         balances[_to] += _value;
213         Transfer(_from, _to, _value);
214 
215         balances[msg.sender] += _fee;
216         Transfer(_from, msg.sender, _fee);
217 
218         balances[_from] -= _value + _fee;
219         nonces[_from] = nonce + 1;
220         return true;
221     }
222 
223     /*
224      * Proxy approve that some one can authorize the agent for broadcast transaction
225      * which call approve method, and agents may charge agency fees
226      * @param _from The address which should tranfer tokens to others
227      * @param _spender The spender who allowed by _from
228      * @param _value The value that should be tranfered.
229      * @param _v
230      * @param _r
231      * @param _s
232      */
233     function approveProxy(address _from, address _spender, uint256 _value,
234         uint8 _v,bytes32 _r, bytes32 _s) public returns (bool success) {
235 
236         uint256 nonce = nonces[_from];
237         bytes32 hash = keccak256(_from,_spender,_value,nonce);
238         if(_from != ecrecover(hash,_v,_r,_s)) revert();
239         allowed[_from][_spender] = _value;
240         Approval(_from, _spender, _value);
241         nonces[_from] = nonce + 1;
242         return true;
243     }
244 
245 
246     /*
247      * Get the nonce
248      * @param _addr
249      */
250     function getNonce(address _addr) public constant returns (uint256){
251         return nonces[_addr];
252     }
253 
254     /* Approves and then calls the receiving contract */
255     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
256         allowed[msg.sender][_spender] = _value;
257         Approval(msg.sender, _spender, _value);
258 
259         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
260         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
261         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
262         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
263         return true;
264     }
265 
266     /* Approves and then calls the contract code*/
267     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
268         allowed[msg.sender][_spender] = _value;
269         Approval(msg.sender, _spender, _value);
270 
271         //Call the contract code
272         if(!_spender.call(_extraData)) { revert(); }
273         return true;
274     }
275 }