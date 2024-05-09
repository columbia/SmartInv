1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.8;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 contract StandardToken is Token {
52 
53     function transfer(address _to, uint256 _value) returns (bool success) {
54         //Default assumes totalSupply can't be over max (2^256 - 1).
55         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
56         //Replace the if with this one instead.
57         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68             balances[_to] += _value;
69             balances[_from] -= _value;
70             allowed[_from][msg.sender] -= _value;
71             Transfer(_from, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92 }
93 
94 contract UGToken is StandardToken {
95 
96     function () {
97         //if ether is sent to this address, send it back.
98         throw;
99     }
100 
101     string public name = "UG Token";                   //fancy name: eg Simon Bucks
102     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
103     string public symbol = "UGT";                 //An identifier: eg SBX
104     string public version = 'v0.1';       //ug 0.1 standard. Just an arbitrary versioning scheme.
105 
106     address public founder; // The address of the founder
107     uint256 public allocateStartBlock; // The start block number that starts to allocate token to users.
108     uint256 public allocateEndBlock; // The end block nubmer that allocate token to users, lasted for a week.
109 
110     // The nonce for avoid transfer replay attacks
111     mapping(address => uint256) nonces;
112 
113     function UGToken() {
114         founder = msg.sender;
115         allocateStartBlock = block.number;
116         allocateEndBlock = allocateStartBlock + 5082; // about one day
117     }
118 
119     /*
120      * Proxy transfer ug token. When some users of the ethereum account has no ether,
121      * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
122      * @param _from
123      * @param _to
124      * @param _value
125      * @param feeUgt
126      * @param _v
127      * @param _r
128      * @param _s
129      */
130     function transferProxy(address _from, address _to, uint256 _value, uint256 _feeUgt,
131         uint8 _v,bytes32 _r, bytes32 _s) returns (bool){
132 
133         if(balances[_from] < _feeUgt + _value) throw;
134 
135         uint256 nonce = nonces[_from];
136         bytes32 h = sha3(_from,_to,_value,_feeUgt,nonce);
137         if(_from != ecrecover(h,_v,_r,_s)) throw;
138 
139         if(balances[_to] + _value < balances[_to]
140             || balances[msg.sender] + _feeUgt < balances[msg.sender]) throw;
141         balances[_to] += _value;
142         Transfer(_from, _to, _value);
143 
144         balances[msg.sender] += _feeUgt;
145         Transfer(_from, msg.sender, _feeUgt);
146 
147         balances[_from] -= _value + _feeUgt;
148         nonces[_from] = nonce + 1;
149         return true;
150     }
151 
152     /*
153      * Proxy approve that some one can authorize the agent for broadcast transaction
154      * which call approve method, and agents may charge agency fees
155      * @param _from The  address which should tranfer ugt to others
156      * @param _spender The spender who allowed by _from
157      * @param _value The value that should be tranfered.
158      * @param _v
159      * @param _r
160      * @param _s
161      */
162     function approveProxy(address _from, address _spender, uint256 _value,
163         uint8 _v,bytes32 _r, bytes32 _s) returns (bool success) {
164 
165         uint256 nonce = nonces[_from];
166         bytes32 hash = sha3(_from,_spender,_value,nonce);
167         if(_from != ecrecover(hash,_v,_r,_s)) throw;
168         allowed[_from][_spender] = _value;
169         Approval(_from, _spender, _value);
170         nonces[_from] = nonce + 1;
171         return true;
172     }
173 
174 
175     /*
176      * Get the nonce
177      * @param _addr
178      */
179     function getNonce(address _addr) constant returns (uint256){
180         return nonces[_addr];
181     }
182 
183     /* Approves and then calls the receiving contract */
184     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187 
188         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
189         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
190         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
191         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
192         return true;
193     }
194 
195     /* Approves and then calls the contract code*/
196     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199 
200         //Call the contract code
201         if(!_spender.call(_extraData)) { throw; }
202         return true;
203     }
204 
205     // Allocate tokens to the users
206     // @param _owners The owners list of the token
207     // @param _values The value list of the token
208     function allocateTokens(address[] _owners, uint256[] _values) {
209 
210         if(msg.sender != founder) throw;
211         if(block.number < allocateStartBlock || block.number > allocateEndBlock) throw;
212         if(_owners.length != _values.length) throw;
213 
214         for(uint256 i = 0; i < _owners.length ; i++){
215             address owner = _owners[i];
216             uint256 value = _values[i];
217             if(totalSupply + value <= totalSupply || balances[owner] + value <= balances[owner]) throw;
218             totalSupply += value;
219             balances[owner] += value;
220         }
221     }
222 }