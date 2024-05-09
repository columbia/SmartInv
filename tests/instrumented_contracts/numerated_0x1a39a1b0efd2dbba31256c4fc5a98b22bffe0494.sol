1 pragma solidity ^0.4.4;
2 
3 
4 contract owned {
5     address public owner;
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 contract TokenERC20 {
22 
23     /// @return total amount of tokens
24     function totalSupply() constant returns (uint256 supply) {}
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) constant returns (uint256 balance) {}
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint256 _value) returns (bool success) {}
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
42 
43     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of wei to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint256 _value) returns (bool success) {}
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 
57 }
58 
59 contract StandardToken is TokenERC20 {
60 
61     function transfer(address _to, uint256 _value) returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64         //Replace the if with this one instead.
65         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[msg.sender] >= _value && _value > 0) {
67             balances[msg.sender] -= _value;
68             balances[_to] += _value;
69             Transfer(msg.sender, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75         //same as above. Replace this line with the following if you want to protect against wrapping uints.
76         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
78             balances[_to] += _value;
79             balances[_from] -= _value;
80             allowed[_from][msg.sender] -= _value;
81             Transfer(_from, _to, _value);
82             return true;
83         } else { return false; }
84     }
85 
86     function balanceOf(address _owner) constant returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97       return allowed[_owner][_spender];
98     }
99 
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102     uint256 public totalSupply;
103 }
104 
105 contract TalkCrypto is owned,StandardToken { // CHANGE THIS. Update the contract name.
106 
107     /* Public variables of the token */
108 
109     /*
110     NOTE:
111     The following variables are OPTIONAL vanities. One does not have to include them.
112     They allow one to customise the token contract & in no way influences the core functionality.
113     Some wallets/interfaces might not even bother to look at this information.
114     */
115     string public name;                   // Token Name
116     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
117     string public symbol;                 // An identifier: eg SBX, XPR etc..
118     string public version = 'H1.0'; 
119     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
120     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
121     address public fundsWallet;           // Where should the raised ETH go?
122 
123     // This is a constructor function 
124     // which means the following function name has to match the contract name declared above
125     function TalkCrypto() {
126         balances[msg.sender] = 25000000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
127         totalSupply = 25000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
128         name = "TalkCrypto";                                   // Set the name for display purposes (CHANGE THIS)
129         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
130         symbol = "TC";                                             // Set the symbol for display purposes (CHANGE THIS)
131         unitsOneEthCanBuy = 500000;                                      // Set the price of your token for the ICO (CHANGE THIS)
132         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
133     }
134 
135     function() payable{
136         totalEthInWei = totalEthInWei + msg.value;
137         uint256 amount = msg.value * unitsOneEthCanBuy;
138         if (balances[fundsWallet] < amount) {
139             return;
140         }
141 
142         balances[fundsWallet] = balances[fundsWallet] - amount;
143         balances[msg.sender] = balances[msg.sender] + amount;
144 
145         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
146 
147         //Transfer ether to fundsWallet
148         fundsWallet.transfer(msg.value);                               
149     }
150 
151     /* Approves and then calls the receiving contract */
152     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
153         allowed[msg.sender][_spender] = _value;
154         Approval(msg.sender, _spender, _value);
155 
156         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
157         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
158         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
159         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
160         return true;
161     }
162 }