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
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) public returns (bool success) {
46         //Default assumes totalSupply can't be over max (2^256 - 1).
47         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
48         //Replace the if with this one instead.
49         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         //same as above. Replace this line with the following if you want to protect against wrapping uints.
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) public constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 contract SMART is StandardToken {
87 
88     function () public payable {
89         require(msg.value > 0 && receivedWei < targetWei);
90         require(now > releaseTime);
91         receivedWei += msg.value;
92         walletAddress.transfer(msg.value);
93         NewSale(msg.sender, msg.value);
94         assert(receivedWei >= msg.value);
95     }
96 
97     string public name = "SmartMesh Token";                   //fancy name
98     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
99     string public symbol = "SMART";                 //An identifier
100     string public version = 'v0.1';       //SMART 0.1 standard. Just an arbitrary versioning scheme.
101 
102     address public founder; // The address of the founder
103     uint256 public targetWei;// The target eth of ico
104     uint256 public receivedWei;//The received nummber of eth
105     uint256 public releaseTime;//The start time of ico
106     uint256 public allocateEndTime;
107     address public walletAddress;//Address of wallet
108 
109     event NewSale(address indexed _from, uint256 _amount);
110     
111     
112     // The nonce for avoid transfer replay attacks
113     mapping(address => uint256) nonces;
114 
115     function SMART(address _walletAddress) public {
116         founder = msg.sender;
117         walletAddress = _walletAddress;
118         releaseTime = 1511917200;
119         allocateEndTime = releaseTime + 37 days;
120         targetWei = 3900 ether;
121     }
122 
123     /*
124      * Proxy transfer SMART token. When some users of the ethereum account has no ether,
125      * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
126      * @param _from
127      * @param _to
128      * @param _value
129      * @param feeSmart
130      * @param _v
131      * @param _r
132      * @param _s
133      */
134     function transferProxy(address _from, address _to, uint256 _value, uint256 _feeSmart,
135         uint8 _v,bytes32 _r, bytes32 _s) public returns (bool){
136 
137         if(balances[_from] < _feeSmart + _value) revert();
138 
139         uint256 nonce = nonces[_from];
140         bytes32 h = keccak256(_from,_to,_value,_feeSmart,nonce);
141         if(_from != ecrecover(h,_v,_r,_s)) revert();
142 
143         if(balances[_to] + _value < balances[_to]
144             || balances[msg.sender] + _feeSmart < balances[msg.sender]) revert();
145         balances[_to] += _value;
146         Transfer(_from, _to, _value);
147 
148         balances[msg.sender] += _feeSmart;
149         Transfer(_from, msg.sender, _feeSmart);
150 
151         balances[_from] -= _value + _feeSmart;
152         nonces[_from] = nonce + 1;
153         return true;
154     }
155 
156     /*
157      * Proxy approve that some one can authorize the agent for broadcast transaction
158      * which call approve method, and agents may charge agency fees
159      * @param _from The address which should tranfer SMART to others
160      * @param _spender The spender who allowed by _from
161      * @param _value The value that should be tranfered.
162      * @param _v
163      * @param _r
164      * @param _s
165      */
166     function approveProxy(address _from, address _spender, uint256 _value,
167         uint8 _v,bytes32 _r, bytes32 _s) public returns (bool success) {
168 
169         uint256 nonce = nonces[_from];
170         bytes32 hash = keccak256(_from,_spender,_value,nonce);
171         if(_from != ecrecover(hash,_v,_r,_s)) revert();
172         allowed[_from][_spender] = _value;
173         Approval(_from, _spender, _value);
174         nonces[_from] = nonce + 1;
175         return true;
176     }
177 
178 
179     /*
180      * Get the nonce
181      * @param _addr
182      */
183     function getNonce(address _addr) public constant returns (uint256){
184         return nonces[_addr];
185     }
186 
187     /* Approves and then calls the receiving contract */
188     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
189         allowed[msg.sender][_spender] = _value;
190         Approval(msg.sender, _spender, _value);
191 
192         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
193         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
194         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
195         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
196         return true;
197     }
198 
199     /* Approves and then calls the contract code*/
200     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
201         allowed[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203 
204         //Call the contract code
205         if(!_spender.call(_extraData)) { revert(); }
206         return true;
207     }
208 
209     // Allocate tokens to the users
210     // @param _owners The owners list of the token
211     // @param _values The value list of the token
212     function allocateTokens(address[] _owners, uint256[] _values) public {
213 
214         if(msg.sender != founder) revert();
215         if(allocateEndTime < now) revert();
216         if(_owners.length != _values.length) revert();
217 
218         for(uint256 i = 0; i < _owners.length ; i++){
219             address owner = _owners[i];
220             uint256 value = _values[i];
221             if(totalSupply + value <= totalSupply || balances[owner] + value <= balances[owner]) revert();
222             totalSupply += value;
223             balances[owner] += value;
224         }
225     }
226 }