1 pragma solidity ^0.4.4;
2 /**
3 
4 ***TOKEN INFORMATION***
5 NAME: DeveloperToken
6 SYMBOL: DEV 
7 TOTAL SUPPLY: 500,000
8 
9 To Purchase DEV Tokens send Ethereum to this smart contract
10 
11 Prices are as follows
12 
13 0.001 ETH =      20 DEV
14 0.01  ETH =     200 DEV
15 0.10  ETH =   2,000 DEV
16 0.25  ETH =   5,000 DEV
17 0.50  ETH =  10,000 DEV
18 1.00  ETH =  20,000 DEV
19 10    ETH = 200,000 DEV
20 
21  
22  Hey guys, my name is James and I'm an ERC20 developer and crypto activist.
23  
24  Times are tough for me at the moment and I don't have work right now.
25  
26  I created this Token because I'm looking for Work or any Donations if you guys can afford to
27  help a brother out any donations would be greatly appreciated. 
28  
29  I can create you your own erc20 Token if you're interested, including crowdsale functions and 
30  contract verification on Etherscan.
31  
32  If you buy 5000 of my DEV Tokens for 0.25 ETH then I will gladly create you your own erc20 Token.
33  I know its cheap but I'm pretty desperate at the moment, no work, no money and I don't want to 
34  have a shitty Christmas you know.
35  
36  You can email me on moneymakingmaster123 @ gmail.com 
37  (Yeah my email address is ironic considering I'm a broke ass right now)
38  
39  ---Please include the following information in your email
40  
41  * Token Name:
42  * Ticket/Symbol:
43  * Total Supply:
44  * Price per Token in ETH:
45  * Address of where initial supply should go:
46  * Address where the funds raised should go:
47  * Any other requirements you may have (Be reasonable, the price is for a basic contract)
48  * Your wallet address to prove you hold 5000 DEV Tokens
49 
50 Thanks so much guys
51 
52 */
53  
54 contract Token {
55  
56     /// @return total amount of tokens
57     function totalSupply() constant returns (uint256 supply) {}
58  
59     /// @param _owner The address from which the balance will be retrieved
60     /// @return The balance
61     function balanceOf(address _owner) constant returns (uint256 balance) {}
62  
63     /// @notice send `_value` token to `_to` from `msg.sender`
64     /// @param _to The address of the recipient
65     /// @param _value The amount of token to be transferred
66     /// @return Whether the transfer was successful or not
67     function transfer(address _to, uint256 _value) returns (bool success) {}
68  
69     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
70     /// @param _from The address of the sender
71     /// @param _to The address of the recipient
72     /// @param _value The amount of token to be transferred
73     /// @return Whether the transfer was successful or not
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
75  
76     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
77     /// @param _spender The address of the account able to transfer the tokens
78     /// @param _value The amount of wei to be approved for transfer
79     /// @return Whether the approval was successful or not
80     function approve(address _spender, uint256 _value) returns (bool success) {}
81  
82     /// @param _owner The address of the account owning tokens
83     /// @param _spender The address of the account able to transfer the tokens
84     /// @return Amount of remaining tokens allowed to spent
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
86  
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89    
90 }
91  
92  
93  
94 contract StandardToken is Token {
95  
96     function transfer(address _to, uint256 _value) returns (bool success) {
97         //Default assumes totalSupply can't be over max (2^256 - 1).
98         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
99         //Replace the if with this one instead.
100         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
101         if (balances[msg.sender] >= _value && _value > 0) {
102             balances[msg.sender] -= _value;
103             balances[_to] += _value;
104             Transfer(msg.sender, _to, _value);
105             return true;
106         } else { return false; }
107     }
108  
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
110         //same as above. Replace this line with the following if you want to protect against wrapping uints.
111         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
112         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
113             balances[_to] += _value;
114             balances[_from] -= _value;
115             allowed[_from][msg.sender] -= _value;
116             Transfer(_from, _to, _value);
117             return true;
118         } else { return false; }
119     }
120  
121     function balanceOf(address _owner) constant returns (uint256 balance) {
122         return balances[_owner];
123     }
124  
125     function approve(address _spender, uint256 _value) returns (bool success) {
126         allowed[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128         return true;
129     }
130  
131     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
132       return allowed[_owner][_spender];
133     }
134  
135     mapping (address => uint256) balances;
136     mapping (address => mapping (address => uint256)) allowed;
137     uint256 public totalSupply;
138 }
139  
140  
141 contract DeveloperTokenSale is StandardToken { // CHANGE THIS. Update the contract name.
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
152     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
153     string public symbol;                 // An identifier: eg SBX, XPR etc..
154     string public version = 'H1.0'; 
155     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
156     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
157     address public fundsWallet;           // Where should the raised ETH go?
158 
159     // This is a constructor function 
160     // which means the following function name has to match the contract name declared above
161     function DeveloperTokenSale() {
162         balances[msg.sender] = 500000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
163         totalSupply = 500000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
164         name = "DeveloperToken";                                   // Set the name for display purposes (CHANGE THIS)
165         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
166         symbol = "DEV";                                             // Set the symbol for display purposes (CHANGE THIS)
167         unitsOneEthCanBuy = 20000;                                      // Set the price of your token for the ICO (CHANGE THIS)
168         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
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