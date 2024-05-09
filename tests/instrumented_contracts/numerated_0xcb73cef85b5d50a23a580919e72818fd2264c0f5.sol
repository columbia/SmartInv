1 pragma solidity ^0.4.4;
2 
3 /* PEERBANKS IRA 'Individual retirement accounts (IRAs) are a vital component 
4 of the differents countries retirement savings, holding nearly one quarter of 
5 all retirement plan assets in the nation.
6 *https://peerbanks.org
7 *https://t.me/peerbanks
8 https://twitter.com/peerbanks
9 *https://medium.com/@PeerBanks
10 *https://github.com/peerbanks
11 *https://peerbanks.slack.com
12 *https://www.reddit.com/r/PeerbanksIRA
13 *
14 */
15 
16 contract Token {
17 
18     /// @return total amount of tokens
19     function totalSupply() constant returns (uint256 supply) {}
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) constant returns (uint256 balance) {}
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) returns (bool success) {}
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of wei to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) returns (bool success) {}
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51     
52 }
53 
54 
55 
56 contract StandardToken is Token {
57 
58     function transfer(address _to, uint256 _value) returns (bool success) {
59         //Default assumes totalSupply can't be over max (2^256 - 1).
60         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
61         //Replace the if with this one instead.
62         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
63         if (balances[msg.sender] >= _value && _value > 0) {
64             balances[msg.sender] -= _value;
65             balances[_to] += _value;
66             Transfer(msg.sender, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
72         //same as above. Replace this line with the following if you want to protect against wrapping uints.
73         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
75             balances[_to] += _value;
76             balances[_from] -= _value;
77             allowed[_from][msg.sender] -= _value;
78             Transfer(_from, _to, _value);
79             return true;
80         } else { return false; }
81     }
82 
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint256 _value) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94       return allowed[_owner][_spender];
95     }
96 
97     mapping (address => uint256) balances;
98     mapping (address => mapping (address => uint256)) allowed;
99     uint256 public totalSupply;
100 }
101 
102 
103 //name this contract whatever you'd like
104 contract PEERBANKS is StandardToken {
105 
106     function () {
107         //if ether is sent to this address, send it back.
108         throw;
109     }
110 
111     /* Public variables of the token */
112 
113     /*
114     NOTE:
115     The following variables are OPTIONAL vanities. One does not have to include them.
116     They allow one to customise the token contract & in no way influences the core functionality.
117     Some wallets/interfaces might not even bother to look at this information.
118     */
119     string public name;                   //fancy name: eg Simon Bucks
120     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
121     string public symbol;                 //An identifier: eg PBK
122     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
123 
124 //
125 // CHANGE THESE VALUES FOR YOUR TOKEN
126 //
127 
128 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
129 
130     function PEERBANKS (
131         ) {
132         balances[msg.sender] = 100000000000000;               // Give the creator all initial tokens (100000 for example)
133         totalSupply = 100000000000000;                        // Update total supply (100000 for example)
134         name = "PEERBANKS";                                   // Set the name for display purposes
135         decimals = 8;                            // Amount of decimals for display purposes
136         symbol = "IRA";                               // Set the symbol for display purposes
137     }
138 
139     /* Approves and then calls the receiving contract */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143 
144         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
145         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
146         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
147         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
148         return true;
149     }
150 }