1 pragma solidity ^0.4.18;
2 
3 // Created by DCMCoin
4 contract Token {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) public view returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract StandardToken is Token {
50 
51     uint256 constant MAX_UINT256 = 2**256 - 1;
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         //Default assumes totalSupply can't be over max (2^256 - 1).
55         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
56         //Replace the if with this one instead.
57         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
58         require(balances[msg.sender] >= _value);
59         balances[msg.sender] -= _value;
60         balances[_to] += _value;
61         Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
68         uint256 allowance = allowed[_from][msg.sender];
69         require(balances[_from] >= _value && allowance >= _value);
70         balances[_to] += _value;
71         balances[_from] -= _value;
72         if (allowance < MAX_UINT256) {
73             allowed[_from][msg.sender] -= _value;
74         }
75         Transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function balanceOf(address _owner) view public returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender)
90     view public returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 }
97 contract DCMCoin is StandardToken {
98 
99     function () {
100         throw;
101     }
102     
103     string public name;                  
104     uint8 public decimals;                
105     string public symbol;                 
106     string public version = 'DCM1.0';       
107 
108 
109 
110     function DCMCoin() {
111         balances[msg.sender] = 10000000000000000000000;               
112         totalSupply = 10000000000000000000000;                        
113         name = "DCMCoin";                                  
114         decimals = 18;                            
115         symbol = "DCM";
116     }
117 
118 
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122 
123         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
124         return true;
125     }
126 }