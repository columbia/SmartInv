1 pragma solidity ^0.4.16;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 contract Token {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 
52 
53 /*
54 You should inherit from StandardToken or, for a token like you would want to
55 deploy in something like Mist, see HumanStandardToken.sol.
56 (This implements ONLY the standard functions and NOTHING else.
57 If you deploy this, you won't have anything useful.)
58 
59 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
60 .*/
61 
62 
63 contract StandardToken is Token {
64 
65     function transfer(address _to, uint256 _value) returns (bool success) {
66         Transfer(msg.sender, _to, _value);
67         //Default assumes totalSupply can't be over max (2^256 - 1).
68         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
69         //Replace the if with this one instead.
70         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[msg.sender] >= _value && _value > 0) {
72             balances[msg.sender] -= _value;
73             balances[_to] += _value;
74             Transfer(msg.sender, _to, _value);
75             return true;
76         } else { return false; }
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         //same as above. Replace this line with the following if you want to protect against wrapping uints.
81         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
82         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
83             balances[_to] += _value;
84             balances[_from] -= _value;
85             allowed[_from][msg.sender] -= _value;
86             Transfer(_from, _to, _value);
87             return true;
88         } else { return false; }
89     }
90 
91     function balanceOf(address _owner) constant returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
102       return allowed[_owner][_spender];
103     }
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107 }
108 
109 contract CELToken is StandardToken {
110 
111     function () {throw;}
112 
113     uint256 public initialSupply=9999 * 1e18;
114     string public name = "Cagliari Ethereum Lab";  //fancy name: eg Simon Bucks
115     uint8 public decimals=18;        //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
116     string public symbol="CEL";     //An identifier: eg SBX
117     string public version = 'H0.3'; //human 0.1 standard. Just an arbitrary versioning scheme.
118     function CELToken() {
119         balances[msg.sender] = initialSupply;
120         totalSupply = initialSupply;                        // Update total supply
121     }
122 
123     /* Approves and then calls the receiving contract */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127 
128         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
129         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
130         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
131         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
132         return true;
133     }
134     
135 
136 }