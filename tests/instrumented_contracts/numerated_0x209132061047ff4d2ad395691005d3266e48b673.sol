1 pragma solidity ^0.4.19;
2 
3 contract ERC20 {
4   /// @return total amount of tokens
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of wei to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) returns (bool success) {}
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 
39 }
40 
41 
42 
43 
44 
45 
46 
47 
48 contract StandardToken is ERC20 {
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52     uint256 public totalSupply;
53 
54   function transfer(address _to, uint256 _value) returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[msg.sender] >= _value && _value > 0) {
60             balances[msg.sender] -= _value;
61             balances[_to] += _value;
62             emit Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         //same as above. Replace this line with the following if you want to protect against wrapping uints.
69         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             allowed[_from][msg.sender] -= _value;
74             Transfer(_from, _to, _value);
75             return true;
76         } else { return false; }
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90       return allowed[_owner][_spender];
91     }
92     
93      
94 }
95 
96 
97 
98 
99 contract IdGameCoin is StandardToken { // CHANGE THIS. Update the contract name.
100 
101     /* Public variables of the token */
102 
103     /*
104     NOTE:
105     The following variables are OPTIONAL vanities. One does not have to include them.
106     They allow one to customise the token contract & in no way influences the core functionality.
107     Some wallets/interfaces might not even bother to look at this information.
108     */
109     string public name;                   // Token Name
110     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
111     string public symbol;                 // An identifier: eg SBX, XPR etc..
112     string public version = 'H1.0'; 
113     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
114     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
115     address public owner;               // Where should the raised ETH go?
116     uint256 public endIco;
117     uint256 public bonusEnds;
118     uint256 public startPreIco;
119     uint256 public startIco;
120 
121     // This is a constructor function 
122     // which means the following function name has to match the contract name declared above
123     function IdGameCoin() public {
124         balances[msg.sender] = 30000000000000000000000000;               // Give the creator all initial tokens. 
125         totalSupply = 30000000000000000000000000;                        // Update total supply
126         name = "IdGameCoin";                                   // Set the name for display purposes
127         decimals = 18;                                               // Amount of decimals for display purposes 
128         symbol = "IDGO";                                             // Set the symbol for display purposes 
129         unitsOneEthCanBuy = 1000;                                      // Set the price of your token for the ICO 
130         owner = msg.sender;                                     // The owner of the contract gets ETH
131         startPreIco  = now;
132         startIco = 1556748000;                          // 02/05/2019
133         bonusEnds = 1546293600;                            // The end of the bonus 31/12/2018
134         endIco = 1568062800;                                // 09/09/2019
135     }
136 
137     function() public payable{
138         if (now <= bonusEnds) {
139             require (now >= startPreIco && now <= bonusEnds);
140         } else {
141             require (now >= startIco && now <= endIco);
142         }
143         
144         
145         
146         totalEthInWei = totalEthInWei + msg.value;
147         if (now <= bonusEnds) {
148             unitsOneEthCanBuy = 1200;
149         } else {
150             unitsOneEthCanBuy = 1000;
151         }
152         uint256 amount = msg.value * unitsOneEthCanBuy;
153         require(balances[owner] >= amount);
154 
155         balances[owner] = balances[owner] - amount;
156         balances[msg.sender] = balances[msg.sender] + amount;
157         
158 
159         emit Transfer(owner, msg.sender, amount); // Broadcast a message to the blockchain
160 
161         //Transfer ether to fundsWallet
162         owner.transfer(msg.value);                               
163     }
164     
165     function mint(address recipient, uint256 amount) public {
166         
167     
168     require(msg.sender == owner);
169     require(totalSupply + amount >= totalSupply); // Overflow check
170 
171     totalSupply += amount;
172     balances[recipient] += amount;
173     emit Transfer(owner, recipient, amount);
174 }
175 
176 function burn(uint256 amount) public {
177     require(amount <= balances[msg.sender]);
178     require(msg.sender == owner);
179 
180     totalSupply -= amount;
181     balances[msg.sender] -= amount;
182     emit Transfer(msg.sender, address(0), amount);
183 }
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