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
44         if (balances[msg.sender] >= _value && _value > 0) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         //same as above. Replace this line with the following if you want to protect against wrapping uints.
54         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             allowed[_from][msg.sender] -= _value;
59             Transfer(_from, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80     uint256 public totalSupply;
81 }
82 
83 contract Kujira is StandardToken {
84 
85     /* Public variables of the token */
86     string public name;                   // The Token Name Identifier
87     uint8 public decimals;                // Total Decimals
88     string public symbol;                 // An identifier
89     string public version = 'H1.0'; 
90     uint256 public unitsOneEthCanBuy;     // ICO Value per ETH
91     uint256 public totalEthInWei;         // Total ETH Raised 
92     address public fundsWallet;           // ICO Raised Funds Address
93 
94     function Kujira() {
95         balances[msg.sender] = 10000000000000000000000000;               // Starting supply
96         totalSupply = 10000000000000000000000000;                        // Total supply
97         name = "Kujira";                                   // Token Display Name
98         decimals = 18;                                               // Decimals
99         symbol = "KUJI";                                             // Token Symbol
100         unitsOneEthCanBuy = 13;                                      // ICO Price
101         fundsWallet = msg.sender;                                    // ETH in return for KUJ token during ICO
102     }
103 
104     function() payable{
105         totalEthInWei = totalEthInWei + msg.value;
106         uint256 amount = msg.value * unitsOneEthCanBuy;
107         require(balances[fundsWallet] >= amount);
108 
109         balances[fundsWallet] = balances[fundsWallet] - amount;
110         balances[msg.sender] = balances[msg.sender] + amount;
111 
112         Transfer(fundsWallet, msg.sender, amount); // Broadcasted Message
113 
114         //Transfer ether to fundsWallet
115         fundsWallet.transfer(msg.value);                               
116     }
117 
118     /* Approves and then calls the receiving contract */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122 
123         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
124         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
125         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
126         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
127         return true;
128     }
129 }