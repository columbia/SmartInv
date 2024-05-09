1 pragma solidity ^0.4.4;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 
57 contract Token {
58 
59     /// @return total amount of tokens
60     function totalSupply() constant returns (uint256 supply) {}
61 
62     /// @param _owner The address from which the balance will be retrieved
63     /// @return The balance
64     function balanceOf(address _owner) constant returns (uint256 balance) {}
65 
66     /// @notice send `_value` token to `_to` from `msg.sender`
67     /// @param _to The address of the recipient
68     /// @param _value The amount of token to be transferred
69     /// @return Whether the transfer was successful or not
70     function transfer(address _to, uint256 _value) returns (bool success) {}
71 
72     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
73     /// @param _from The address of the sender
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
78 
79     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
80     /// @param _spender The address of the account able to transfer the tokens
81     /// @param _value The amount of wei to be approved for transfer
82     /// @return Whether the approval was successful or not
83     function approve(address _spender, uint256 _value) returns (bool success) {}
84 
85     /// @param _owner The address of the account owning tokens
86     /// @param _spender The address of the account able to transfer the tokens
87     /// @return Amount of remaining tokens allowed to spent
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
89 
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92 
93 }
94 
95 contract StandardToken is Token {
96 
97     function transfer(address _to, uint256 _value) returns (bool success) {
98         //Default assumes totalSupply can't be over max (2^256 - 1).
99         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
100         //Replace the if with this one instead.
101         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
102         if (balances[msg.sender] >= _value && _value > 0) {
103             balances[msg.sender] -= _value;
104             balances[_to] += _value;
105             Transfer(msg.sender, _to, _value);
106             return true;
107         } else { return false; }
108     }
109 
110     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
111         //same as above. Replace this line with the following if you want to protect against wrapping uints.
112         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
113         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
114             balances[_to] += _value;
115             balances[_from] -= _value;
116             allowed[_from][msg.sender] -= _value;
117             Transfer(_from, _to, _value);
118             return true;
119         } else { return false; }
120     }
121 
122     function balanceOf(address _owner) constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126     function approve(address _spender, uint256 _value) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
133       return allowed[_owner][_spender];
134     }
135 
136     mapping (address => uint256) balances;
137     mapping (address => mapping (address => uint256)) allowed;
138     uint256 public totalSupply;
139 }
140 
141 contract CarToken is StandardToken { // CHANGE THIS. Update the contract name.
142 
143     /* Public variables of the token */
144 
145     /*
146     NOTE:
147     The following variables are OPTIONAL vanities. One does not have to include them.
148     They allow one to customise the token contract & in no way influences the core functionality.
149     Some wallets/interfaces might not even bother to look at this information.
150     */
151     string public name;                   // Token Name
152     uint8 public decimals;                // How many decimals to show. here 18
153     string public symbol;                 // An identifier: eg CAR etc..
154     string public version = 'H1.0'; 
155     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
156     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
157     address public fundsWallet;           // Where should the raised ETH go?
158 
159     // This is a constructor function 
160     // which means the following function name has to match the contract name declared above
161     function CarToken() {
162         balances[msg.sender] = 300000000000000000000000000;               // Give the creator all initial tokens. This is set to 300MLN for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. 
163         totalSupply = 300000000000000000000000000;                        // Update total supply (300MLN for example)
164         name = 'Car Token';                                   // The name for display purposes 
165         decimals = 18;                                               // Amount of decimals for display purposes 
166         symbol = 'CAR';                                             // Set the symbol for display purposes 
167         unitsOneEthCanBuy = 4000;                                      // The price of CAR token for the ICO 
168         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
169     }
170 
171     function() payable{
172         totalEthInWei = totalEthInWei + msg.value;
173         uint256 amount = msg.value * unitsOneEthCanBuy;
174         require(balances[fundsWallet] >= amount);
175 
176         balances[fundsWallet] = balances[fundsWallet] - amount;
177         balances[msg.sender] = balances[msg.sender] + amount;
178 
179         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
180 
181         //Transfer ether to fundsWallet
182         fundsWallet.transfer(msg.value);                               
183     }
184 
185     /* Approves and then calls the receiving contract */
186     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
187         allowed[msg.sender][_spender] = _value;
188         Approval(msg.sender, _spender, _value);
189 
190         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
191         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
192         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
193         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
194         return true;
195     }
196 }