1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     
11     
12     function balanceOf(address _owner) constant returns (uint256 balance) {}
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint256 _value) returns (bool success) {}
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
26 
27     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of wei to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint256 _value) returns (bool success) {}
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         //Default assumes totalSupply can't be over max (2^256 - 1).
47         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
48         //Replace the if with this one instead.
49         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59         //same as above. Replace this line with the following if you want to protect against wrapping uints.
60         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     uint256 public totalSupply;
87 }
88 
89 contract Zigicoin is StandardToken { // CHANGE THIS. Update the contract name.
90 
91     /* Public variables of the token */
92 
93     /*
94     NOTE    
95    */
96     string public name;                   // Token 
97     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
98     string public symbol;                 // An identifier: ..
99     string public version = 'H1.0'; 
100     uint256 public ZIGICOIN ;     // How many units of your coin can be bought by 1 ETH?
101     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
102     address  fundsWallet;           // Where should the raised ETH go?
103 
104     // This is a constructor function 
105     // which means the following function name has to match the contract name declared above
106     function ZIGICOIN () {
107         balances[msg.sender] = 1000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
108         totalSupply = 1000000000000000000;                        // Update total supply (1000 for example) (1000000000000000000)
109         name = "ZIGICOIN";                                   // Set the name for display purposes (ZIGICOIN)
110         decimals = 8;                                               // Amount of decimals for display purposes (ZIGICOIN)
111         symbol = "ZIGI";                                             // Set the symbol for display purposes (ZIGICOIN)
112                                            
113         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
114     }
115                              
116 
117 /* Approves and then calls the receiving contract */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121 
122         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
123         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
124         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
125         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
126         return true;
127     }
128 }