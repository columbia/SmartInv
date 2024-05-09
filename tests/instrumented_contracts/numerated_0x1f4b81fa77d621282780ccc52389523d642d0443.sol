1 pragma solidity ^0.4.4;
2 
3 contract SafeMath {
4   //internals
5 
6   function safeMul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeSub(uint a, uint b) internal returns (uint) {
13     assert(b <= a);
14     return a - b;
15   }
16 
17   function safeAdd(uint a, uint b) internal returns (uint) {
18     uint c = a + b;
19     assert(c>=a && c>=b);
20     return c;
21   }
22 
23   function assert(bool assertion) internal {
24     if (!assertion) throw;
25   }
26 }
27 
28 contract Token is SafeMath {
29 
30     /// @return total amount of tokens
31     function totalSupply() constant returns (uint256 supply) {}
32 
33     /// @param _owner The address from which the balance will be retrieved
34     /// @return The balance
35     function balanceOf(address _owner) constant returns (uint256 balance) {}
36 
37     /// @notice send `_value` token to `_to` from `msg.sender`
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transfer(address _to, uint256 _value) returns (bool success) {}
42 
43     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
44     /// @param _from The address of the sender
45     /// @param _to The address of the recipient
46     /// @param _value The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
49 
50     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @param _value The amount of wei to be approved for transfer
53     /// @return Whether the approval was successful or not
54     function approve(address _spender, uint256 _value) returns (bool success) {}
55 
56     /// @param _owner The address of the account owning tokens
57     /// @param _spender The address of the account able to transfer the tokens
58     /// @return Amount of remaining tokens allowed to spent
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63     
64     event Burned(uint amount);
65 }
66 
67 contract StandardToken is Token {
68 
69     function transfer(address _to, uint256 _value) returns (bool success) {
70         //Default assumes totalSupply can't be over max (2^256 - 1).
71         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
72         //Replace the if with this one instead.
73         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74         if (now < icoEnd + lockedPeriod && msg.sender != fundsWallet) throw;
75         if (msg.sender == fundsWallet && now < icoEnd + blockPeriod && ownerNegTokens < _value) throw; //prevent the owner of spending his share of tokens within the first year
76         if (balances[msg.sender] >= _value && _value > 0) {
77             balances[msg.sender] -= _value;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             if (msg.sender == fundsWallet && now < icoEnd + blockPeriod) {
81                 ownerNegTokens = safeSub(ownerNegTokens, _value);
82             }
83             return true;
84         } else { return false; }
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         //same as above. Replace this line with the following if you want to protect against wrapping uints.
89         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90         if (now < icoEnd + lockedPeriod && msg.sender != fundsWallet) throw;
91         if (msg.sender == fundsWallet && now < icoEnd + blockPeriod && ownerNegTokens < _value) throw;
92         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
93             balances[_to] += _value;
94             balances[_from] -= _value;
95             allowed[_from][msg.sender] -= _value;
96             Transfer(_from, _to, _value);
97             if (msg.sender == fundsWallet && now < icoEnd + blockPeriod) {
98                 ownerNegTokens = safeSub(ownerNegTokens, _value);
99             }
100             return true;
101         } else { return false; }
102     }
103 
104     function balanceOf(address _owner) constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108     function approve(address _spender, uint256 _value) returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115       return allowed[_owner][_spender];
116     }
117     
118     function burn(){
119     	//if tokens have not been burned already and the ICO ended
120     	if(!burned && now> icoEnd){
121     		uint256 difference = tokensToSell;//checked for overflow above
122     		balances[fundsWallet] = balances[fundsWallet] - difference;
123     		totalSupply = totalSupply - difference;
124     		burned = true;
125     		Burned(difference);
126     	}
127     }
128 
129     mapping (address => uint256) balances;
130     mapping (address => mapping (address => uint256)) allowed;
131     uint256 public totalSupply;
132     
133     uint256 public icoStart = 1520244000;
134     
135     uint256 public icoEnd = 1520244000 + 45 days;
136     
137     //ownerFreezeTokens tokens will be freezed during this period after ICO
138     uint256 public blockPeriod = 1 years;
139     
140     //after this period after ICO end token holders can operate with them
141     uint256 public lockedPeriod = 15 days;
142     
143     //owners negotiable token that he can spend in any time
144     uint256 public ownerNegTokens = 13500000000000000000000000;
145     
146     //owner tokens to be feezed on year
147     uint256 public ownerFreezeTokens = 13500000000000000000000000;
148     
149     //max number of tokens that can be sold
150     uint256 public tokensToSell = 63000000000000000000000000; 
151     
152     bool burned = false;
153     
154     string public name;                   
155     uint8 public decimals = 18;                
156     string public symbol;                 
157     string public version = 'H1.0'; 
158     uint256 public unitsOneEthCanBuy;     
159     uint256 public totalEthInWei = 0;          
160     address public fundsWallet;
161 }
162 
163 contract EpsToken is StandardToken {
164 
165     // This is a constructor function 
166     // which means the following function name has to match the contract name declared above
167     function EpsToken() {
168         balances[msg.sender] = 90000000000000000000000000;              
169         totalSupply = 90000000000000000000000000;                     
170         name = "Epsilon";                                            
171         symbol = "EPS";                                             
172         unitsOneEthCanBuy = 28570;                                      
173         fundsWallet = msg.sender;                         
174     }
175 
176     function() payable{
177         
178         if (now < icoStart || now > icoEnd || tokensToSell <= 0) {
179             return;
180         }
181         
182         totalEthInWei = totalEthInWei + msg.value;
183         uint256 amount = msg.value * unitsOneEthCanBuy;
184         uint256 valueInWei = msg.value;
185         
186         if (tokensToSell < amount) {
187             amount = tokensToSell;
188             valueInWei = amount / unitsOneEthCanBuy;
189             msg.sender.transfer(msg.value - valueInWei);
190         }
191         
192         tokensToSell -= amount;
193 
194         balances[fundsWallet] = balances[fundsWallet] - amount;
195         balances[msg.sender] = balances[msg.sender] + amount;
196         
197         
198         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
199 
200         //Transfer ether to fundsWallet
201         fundsWallet.transfer(valueInWei);                               
202     }
203 
204     /* Approves and then calls the receiving contract */
205     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
206         allowed[msg.sender][_spender] = _value;
207         Approval(msg.sender, _spender, _value);
208 
209         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
210         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
211         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
212         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
213         return true;
214     }
215 }