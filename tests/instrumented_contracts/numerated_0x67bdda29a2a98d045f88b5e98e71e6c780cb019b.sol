1 pragma solidity ^0.4.4;
2 /**
3   My name is James and I am so fucked right now.
4 
5 I created this contract in hopes that someone can help me.
6 I got into crypto in February this year and lost so much money.
7 Now I don't know what im going to do month end.
8 
9 I was an Noob when I got into crypto and decided to quit my job.
10 Took a loan at the bank and bought a couple mining rigs, thought i was going to be rich, lol.
11 As you can predict, things didn't go as planned.
12 I had to sell my rigs a few months back and now I have nothing except a pile of debt.
13 
14 I am looking for a job but times are tough right now.
15 
16 I'm ashamed to have to resort to asking for handouts, but I'm trying here before I end up on the street.
17 Atleast this way I can keep some form of pride that I have left.
18 
19 If you are fortunate enough and can help me with any amount I would really appreciate it.
20 
21 I Just need 5 Ethereum to help me get through this month.
22 
23 If you can't donate any ethereum then kindly share this with someone who can.
24 
25 Any amount of Ethereum you can donate will be greatly appreciated and you will 
26 receive "Thank-You" tokens in return.
27 
28 If you can donate 0.1 Ethereum or more then I can create a basic contract or token for you, 
29 including verification and crowdsale/ Selfdrop prices etc. 
30 Its cheap to do coding 'for 0.1 ETH I know, but I can't find work now and I'm desperate.
31 
32 If you donated 0.1 ETH and want your own token then I can make one in about 10 minutes.
33 
34 I will just need the following information if you want your own token.
35 * Token Name:
36 * Symbol:
37 * Total Supply:
38 * Price of the token in ETH:
39 * Wallet Address of Contract Owner:
40 
41 You can email me your requests on airdrop1178-at-gmail.com
42 
43 
44 Thank you so much.
45 
46 */
47  
48 contract Token {
49  
50     /// @return total amount of tokens
51     function totalSupply() constant returns (uint256 supply) {}
52  
53     /// @param _owner The address from which the balance will be retrieved
54     /// @return The balance
55     function balanceOf(address _owner) constant returns (uint256 balance) {}
56  
57     /// @notice send `_value` token to `_to` from `msg.sender`
58     /// @param _to The address of the recipient
59     /// @param _value The amount of token to be transferred
60     /// @return Whether the transfer was successful or not
61     function transfer(address _to, uint256 _value) returns (bool success) {}
62  
63     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
64     /// @param _from The address of the sender
65     /// @param _to The address of the recipient
66     /// @param _value The amount of token to be transferred
67     /// @return Whether the transfer was successful or not
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
69  
70     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
71     /// @param _spender The address of the account able to transfer the tokens
72     /// @param _value The amount of wei to be approved for transfer
73     /// @return Whether the approval was successful or not
74     function approve(address _spender, uint256 _value) returns (bool success) {}
75  
76     /// @param _owner The address of the account owning tokens
77     /// @param _spender The address of the account able to transfer the tokens
78     /// @return Amount of remaining tokens allowed to spent
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
80  
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83    
84 }
85  
86  
87  
88 contract StandardToken is Token {
89  
90     function transfer(address _to, uint256 _value) returns (bool success) {
91         //Default assumes totalSupply can't be over max (2^256 - 1).
92         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
93         //Replace the if with this one instead.
94         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
95         if (balances[msg.sender] >= _value && _value > 0) {
96             balances[msg.sender] -= _value;
97             balances[_to] += _value;
98             Transfer(msg.sender, _to, _value);
99             return true;
100         } else { return false; }
101     }
102  
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
104         //same as above. Replace this line with the following if you want to protect against wrapping uints.
105         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
106         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
107             balances[_to] += _value;
108             balances[_from] -= _value;
109             allowed[_from][msg.sender] -= _value;
110             Transfer(_from, _to, _value);
111             return true;
112         } else { return false; }
113     }
114  
115     function balanceOf(address _owner) constant returns (uint256 balance) {
116         return balances[_owner];
117     }
118  
119     function approve(address _spender, uint256 _value) returns (bool success) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124  
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126       return allowed[_owner][_spender];
127     }
128  
129     mapping (address => uint256) balances;
130     mapping (address => mapping (address => uint256)) allowed;
131     uint256 public totalSupply;
132 }
133  
134  
135 contract PleaseHelpMe is StandardToken { // CHANGE THIS. Update the contract name.
136 
137     /* Public variables of the token */
138 
139     /*
140     NOTE:
141     The following variables are OPTIONAL vanities. One does not have to include them.
142     They allow one to customise the token contract & in no way influences the core functionality.
143     Some wallets/interfaces might not even bother to look at this information.
144     */
145     string public name;                   // Token Name
146     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
147     string public symbol;                 // An identifier: eg SBX, XPR etc..
148     string public version = 'H1.0'; 
149     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
150     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
151     address public fundsWallet;           // Where should the raised ETH go?
152 
153     // This is a constructor function 
154     // which means the following function name has to match the contract name declared above
155     function PleaseHelpMe() {
156         balances[msg.sender] = 2000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
157         totalSupply = 2000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
158         name = "Please-Help-Me";                                   // Set the name for display purposes (CHANGE THIS)
159         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
160         symbol = "Thank-You :)";                                             // Set the symbol for display purposes (CHANGE THIS)
161         unitsOneEthCanBuy = 100000;                                      // Set the price of your token for the ICO (CHANGE THIS)
162         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
163     }
164 
165     function() payable{
166         totalEthInWei = totalEthInWei + msg.value;
167         uint256 amount = msg.value * unitsOneEthCanBuy;
168         require(balances[fundsWallet] >= amount);
169 
170         balances[fundsWallet] = balances[fundsWallet] - amount;
171         balances[msg.sender] = balances[msg.sender] + amount;
172 
173         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
174 
175         //Transfer ether to fundsWallet
176         fundsWallet.transfer(msg.value);                               
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