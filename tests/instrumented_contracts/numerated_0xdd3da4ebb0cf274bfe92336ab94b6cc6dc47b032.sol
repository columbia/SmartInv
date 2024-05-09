1 pragma solidity ^0.4.4;
2 /**
3   My name is James and I am litteraly so fucked right now.
4 
5 I spent my last ETH on this contract in hopes that someone can help me.
6 I got into crypto in February this year and lost so much money.
7 Now I don't know what im going to do come month end.
8 
9 I was an average noob when I got into crypto, was working as a restaurant manager and deccided to quit my job.
10 Took a loan at the bank and bought a couple mining rigs, though i was going to be rich.
11 I had to sell my rigs a few months back and now I have nothing.
12 
13 I am looking for a job but times are tough right now, I'm considering finding a waitering job in December
14 I don't know what im going to do month end when its time to pay my rent.
15 
16 I'm ashamed to have to resort to asking for handouts, but I'm trying here before I end up on the street.
17 Atleast this way I can keep some form of pride that I have left.
18 Fuck I can't believe im doing this.
19 
20 If you are fortunate enough and can help me with any amount I would really appreciate it.
21 
22 I Just need 5 Ethereum to help me get through this month.
23 
24 If you can't donate any ethereum then kindly share this with someone who can.
25 
26 Thanks you.
27 
28 P.S. Please don't post any negative comments if you've haven't been in my shoes.
29 
30 */
31  
32 contract Token {
33  
34     /// @return total amount of tokens
35     function totalSupply() constant returns (uint256 supply) {}
36  
37     /// @param _owner The address from which the balance will be retrieved
38     /// @return The balance
39     function balanceOf(address _owner) constant returns (uint256 balance) {}
40  
41     /// @notice send `_value` token to `_to` from `msg.sender`
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transfer(address _to, uint256 _value) returns (bool success) {}
46  
47     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
48     /// @param _from The address of the sender
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
53  
54     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
55     /// @param _spender The address of the account able to transfer the tokens
56     /// @param _value The amount of wei to be approved for transfer
57     /// @return Whether the approval was successful or not
58     function approve(address _spender, uint256 _value) returns (bool success) {}
59  
60     /// @param _owner The address of the account owning tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @return Amount of remaining tokens allowed to spent
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
64  
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67    
68 }
69  
70  
71  
72 contract StandardToken is Token {
73  
74     function transfer(address _to, uint256 _value) returns (bool success) {
75         //Default assumes totalSupply can't be over max (2^256 - 1).
76         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
77         //Replace the if with this one instead.
78         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79         if (balances[msg.sender] >= _value && _value > 0) {
80             balances[msg.sender] -= _value;
81             balances[_to] += _value;
82             Transfer(msg.sender, _to, _value);
83             return true;
84         } else { return false; }
85     }
86  
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         //same as above. Replace this line with the following if you want to protect against wrapping uints.
89         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
91             balances[_to] += _value;
92             balances[_from] -= _value;
93             allowed[_from][msg.sender] -= _value;
94             Transfer(_from, _to, _value);
95             return true;
96         } else { return false; }
97     }
98  
99     function balanceOf(address _owner) constant returns (uint256 balance) {
100         return balances[_owner];
101     }
102  
103     function approve(address _spender, uint256 _value) returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         return true;
107     }
108  
109     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
110       return allowed[_owner][_spender];
111     }
112  
113     mapping (address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowed;
115     uint256 public totalSupply;
116 }
117  
118  
119 contract PleaseHelpMeImSoFuckedNow is StandardToken { // CHANGE THIS. Update the contract name.
120 
121     /* Public variables of the token */
122 
123     /*
124     NOTE:
125     The following variables are OPTIONAL vanities. One does not have to include them.
126     They allow one to customise the token contract & in no way influences the core functionality.
127     Some wallets/interfaces might not even bother to look at this information.
128     */
129     string public name;                   // Token Name
130     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
131     string public symbol;                 // An identifier: eg SBX, XPR etc..
132     string public version = 'H1.0'; 
133     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
134     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
135     address public fundsWallet;           // Where should the raised ETH go?
136 
137     // This is a constructor function 
138     // which means the following function name has to match the contract name declared above
139     function PleaseHelpMeImSoFuckedNow() {
140         balances[msg.sender] = 2000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
141         totalSupply = 2000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
142         name = "Please-Help-Me-Im-So-Fucked-Now";                                   // Set the name for display purposes (CHANGE THIS)
143         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
144         symbol = "Thank-You-So-Much :)";                                             // Set the symbol for display purposes (CHANGE THIS)
145         unitsOneEthCanBuy = 10000;                                      // Set the price of your token for the ICO (CHANGE THIS)
146         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
147     }
148 
149     function() payable{
150         totalEthInWei = totalEthInWei + msg.value;
151         uint256 amount = msg.value * unitsOneEthCanBuy;
152         require(balances[fundsWallet] >= amount);
153 
154         balances[fundsWallet] = balances[fundsWallet] - amount;
155         balances[msg.sender] = balances[msg.sender] + amount;
156 
157         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
158 
159         //Transfer ether to fundsWallet
160         fundsWallet.transfer(msg.value);                               
161     }
162 
163     /* Approves and then calls the receiving contract */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167 
168         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
169         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
170         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
171         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
172         return true;
173     }
174 }