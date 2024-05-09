1 /*
2 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
3 
4 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
5 Imagine coins, currencies, shares, voting weight, etc.
6 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
7 
8 1) Initial Finite Supply (upon creation one specifies how much is minted).
9 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
10 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
11 
12 # Used for Market XL more info at mxl.pt and marketxl.eth
13 
14 */
15 
16 pragma solidity ^0.4.4;
17 
18 contract Token {
19 
20     /// @return total amount of tokens
21     function totalSupply() constant returns (uint256 supply) {}
22 
23     /// @param _owner The address from which the balance will be retrieved
24     /// @return The balance
25     function balanceOf(address _owner) constant returns (uint256 balance) {}
26 
27     /// @notice send `_value` token to `_to` from `msg.sender`
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transfer(address _to, uint256 _value) returns (bool success) {}
32 
33     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
34     /// @param _from The address of the sender
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
39 
40     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @param _value The amount of wei to be approved for transfer
43     /// @return Whether the approval was successful or not
44     function approve(address _spender, uint256 _value) returns (bool success) {}
45 
46     /// @param _owner The address of the account owning tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @return Amount of remaining tokens allowed to spent
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
50 
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54 
55 
56 
57 contract StandardToken is Token {
58 
59     function transfer(address _to, uint256 _value) returns (bool success) {
60         //Default assumes totalSupply can't be over max (2^256 - 1).
61         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
62         //Replace the if with this one instead.
63         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[msg.sender] >= _value && _value > 0) {
65             balances[msg.sender] -= _value;
66             balances[_to] += _value;
67             Transfer(msg.sender, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
73         //same as above. Replace this line with the following if you want to protect against wrapping uints.
74         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
76             balances[_to] += _value;
77             balances[_from] -= _value;
78             allowed[_from][msg.sender] -= _value;
79             Transfer(_from, _to, _value);
80             return true;
81         } else { return false; }
82     }
83 
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100     uint256 public totalSupply;
101 }
102 
103 
104 contract MXLToken is StandardToken {
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
119 	
120     string public name = 'MXL Token';                  
121     uint8 public decimals = 18;                
122     string public symbol = 'MXL';              
123     string public version = 'H0.1';      
124 
125     function MXLToken() {
126         balances[msg.sender] = 999999999000000000000000000;  // Give the creator all initial tokens
127         totalSupply = 999999999000000000000000000;           // Update total supply
128         name = 'MXL Token';                                  // Set the name for display purposes
129         decimals = 18;                                       // Amount of decimals for display purposes
130         symbol = 'MXL';                                      // Set the symbol for display purposes
131     }
132 
133     /* Approves and then calls the receiving contract */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137 
138         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
139         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
140         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
141         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
142         return true;
143     }
144 }