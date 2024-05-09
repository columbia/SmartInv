1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 contract BrainLegitCoin is StandardToken { // CHANGE THIS. Update the contract name.
88 
89     /* Public variables of the token */
90 
91     /*
92     NOTE:
93     The following variables are OPTIONAL vanities. One does not have to include them.
94     They allow one to customise the token contract & in no way influences the core functionality.
95     Some wallets/interfaces might not even bother to look at this information.
96     */
97     string public name;                   // Token Name
98     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
99     string public symbol;                 // An identifier: eg SBX, XPR etc..
100     string public version = 'BL1.0'; 
101     uint256 public unitsOneEthCanBuybefore;     // How many units of coin can be bought by 1 ETH during ICO?
102     uint256 public unitsOneEthCanBuyafter;     // How many units of coin can be bought by 1 ETH after ICO?
103     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
104     address public fundsWallet;          // Where should the raised ETH go?
105     uint public deadline;
106 uint256 public ecosystemtoken;
107 uint public preIcoStart;
108 uint public preIcoEnds;
109 uint public Icostart;
110 uint public Icoends;
111 
112 
113   // Token Distribution
114   // =============================
115   uint256 public maxTokens = 1000000000000000000000000000; // There will be total 1Billion LegitCoin Tokens
116   uint256 public tokensForplutonics = 200000000000000000000000000; // 200million legitt coin for utility ecosystem
117   uint256 public tokensForfortis = 150000000000000000000000000;    //150Million Legitt coin for fortis projects
118   uint256 public tokensFortorch = 10000000000000000000000000;     // 100 million legitt coin for Torch
119     uint256 public tokensForEcosystem = 10000000000000000000000000;  // 100 million legittcoin for ecosystem
120   uint256 public totalTokensForSale = 450000000000000000000000000; // 450Million LGT will be sold in Crowdsale
121 
122     // This is a constructor function 
123     // which means the following function name has to match the contract name declared above
124     function BrainLegitCoin() {
125         balances[msg.sender] = maxTokens;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
126         totalSupply = maxTokens;                        // Update total supply (1000 for example) (CHANGE THIS)
127       
128         name = "LegittCoin";                                   // Set the name for display purposes (CHANGE THIS)
129         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
130         symbol = "LGT";                                             // Set the symbol for display purposes (CHANGE THIS)
131         unitsOneEthCanBuybefore = 30000;                                      // Set the price of your token for the ICO (CHANGE THIS)
132        unitsOneEthCanBuyafter=15000;
133         fundsWallet = msg.sender;  
134    preIcoStart=now + 10080 * 1 minutes;
135    preIcoEnds = now + 25920 * 1 minutes;
136    Icostart = now + 27360 * 1 minutes;
137    Icoends= now + 72000 * 1 minutes;
138    
139                          
140     }
141 
142     function() payable{
143        
144       if(now > Icoends) throw;
145       if ((balances[fundsWallet] > 300000000000000000000000000) && ((now >= preIcoStart) && (now <= preIcoEnds))){
146               totalEthInWei = totalEthInWei + msg.value;
147         uint256 amount = msg.value * unitsOneEthCanBuybefore;
148         require(balances[fundsWallet] >= amount);
149 
150         balances[fundsWallet] = balances[fundsWallet] - amount;
151         balances[msg.sender] = balances[msg.sender] + amount;
152 
153         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
154 
155         //Transfer ether to fundsWallet
156         fundsWallet.transfer(msg.value);
157       } else if( (now >= Icostart) && (now <= Icoends)){
158        totalEthInWei = totalEthInWei + msg.value;
159         uint256 amountb = msg.value * unitsOneEthCanBuyafter;
160         require(tokensForEcosystem >= amountb);
161 
162         tokensForEcosystem = tokensForEcosystem - amountb;
163         balances[msg.sender] = balances[msg.sender] + amountb;
164 
165         Transfer(fundsWallet, msg.sender, amountb); // Broadcast a message to the blockchain
166 
167         //Transfer ether to fundsWallet
168         fundsWallet.transfer(msg.value);
169       }
170               
171      
172        
173       
174         
175        
176                                    
177     }
178 
179     /* Approves and then calls the receiving contract */
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
181         allowed[msg.sender][_spender] = _value;
182         Approval(msg.sender, _spender, _value);
183 
184         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
185         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
186         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
187         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
188         return true;
189     }
190 }