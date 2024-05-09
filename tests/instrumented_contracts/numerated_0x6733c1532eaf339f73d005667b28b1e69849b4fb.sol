1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function sub(uint a, uint b) internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function add(uint a, uint b) internal returns (uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 contract Token {
23 
24     /// @return total amount of tokens
25     function totalSupply() constant returns (uint256 supply) {}
26 
27     /// @param _owner The address from which the balance will be retrieved
28     /// @return The balance
29     function balanceOf(address _owner) constant returns (uint256 balance) {}
30 
31     /// @notice send `_value` token to `_to` from `msg.sender`
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transfer(address _to, uint256 _value) returns (bool success) {}
36 
37     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
38     /// @param _from The address of the sender
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
43 
44     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @param _value The amount of wei to be approved for transfer
47     /// @return Whether the approval was successful or not
48     function approve(address _spender, uint256 _value) returns (bool success) {}
49 
50     /// @param _owner The address of the account owning tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @return Amount of remaining tokens allowed to spent
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 
58 }
59 
60 contract StandardToken is Token {
61 
62     function transfer(address _to, uint256 _value) returns (bool success) {
63         //Default assumes totalSupply can't be over max (2^256 - 1).
64         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
65         //Replace the if with this one instead.
66         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
67         if (balances[msg.sender] >= _value && _value > 0) {
68             balances[msg.sender] -= _value;
69             balances[_to] += _value;
70             Transfer(msg.sender, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76         //same as above. Replace this line with the following if you want to protect against wrapping uints.
77         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
78         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
79             balances[_to] += _value;
80             balances[_from] -= _value;
81             allowed[_from][msg.sender] -= _value;
82             Transfer(_from, _to, _value);
83             return true;
84         } else { return false; }
85     }
86 
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
98       return allowed[_owner][_spender];
99     }
100 
101     mapping (address => uint256) balances;
102     mapping (address => mapping (address => uint256)) allowed;
103     uint256 public totalSupply;
104 }
105 
106 contract EphronTestCoin is StandardToken { // CHANGE THIS. Update the contract name.
107 
108     /* Public variables of the token */
109     event FundTransfer(address backer, uint amount, bool isContribution);
110 
111     /*
112     NOTE:
113     The following variables are OPTIONAL vanities. One does not have to include them.
114     They allow one to customise the token contract & in no way influences the core functionality.
115     Some wallets/interfaces might not even bother to look at this information.
116     */
117     using SafeMath for uint;
118     string public name;                   // Token Name
119     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
120     string public symbol;                 // An identifier: eg SBX, XPR etc..
121     string public version = 'H1.0'; 
122     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
123     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
124     address public fundsWallet;           // Where should the raised ETH go?
125     uint public start; 
126     uint public end;
127 
128     // This is a constructor function 
129     // which means the following function name has to match the contract name declared above
130     function EphronTestCoin(
131         uint startTime,
132         uint endTime,
133         uint256 initialSupply,
134         string tokenName,
135         string tokenSymbol,
136         uint256 etherCostOfEachToken
137         ) {
138         totalSupply = initialSupply;   
139         balances[msg.sender] = initialSupply;                        // Update total supply (1000 for example) (CHANGE THIS)
140         name = tokenName;                                   // Set the name for display purposes (CHANGE THIS)
141         decimals = 0;                                               // Amount of decimals for display purposes (CHANGE THIS)
142         symbol = "EPHTCN";                                             // Set the symbol for display purposes (CHANGE THIS)
143         unitsOneEthCanBuy = etherCostOfEachToken;                                      // Set the price of your token for the ICO (CHANGE THIS)
144         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
145         start = startTime;
146         end = endTime;
147     }
148     
149     // ---- FOR TEST ONLY ----
150     uint _current = 0;
151     function current() public returns (uint) {
152         // Override not in use
153         if(_current == 0) {
154             return now;
155         }
156         return _current;
157     }
158     function setCurrent(uint __current) {
159         _current = __current;
160     }
161 
162     function() payable{
163         totalEthInWei = totalEthInWei + msg.value;
164         uint256 amount = msg.value * unitsOneEthCanBuy;
165         require(balances[fundsWallet] >= amount);
166         require(current() >= start && current() <= end);
167 
168         balances[fundsWallet] = balances[fundsWallet] - amount;
169         balances[msg.sender] = balances[msg.sender] + amount;
170 
171         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
172 
173         //Transfer ether to fundsWallet
174         fundsWallet.transfer(msg.value);                               
175     }
176 
177     /* Approves and then calls the receiving contract */
178     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
179         allowed[msg.sender][_spender] = _value;
180         Approval(msg.sender, _spender, _value);
181 
182         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
183         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
184         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
185         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
186         return true;
187     }
188     modifier afterDeadline() { if (current() >= end) _; }
189     
190     function safeWithdrawal() afterDeadline {
191         uint amount = balances[msg.sender];
192         if (address(this).balance >= amount) {
193             balances[msg.sender] = 0;
194             if (amount > 0) {
195                 msg.sender.transfer(amount);
196                 FundTransfer(msg.sender, amount, false);
197             }
198         }
199     }
200 }