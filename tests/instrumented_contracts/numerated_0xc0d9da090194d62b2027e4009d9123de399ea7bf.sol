1 pragma solidity ^0.4.8;
2 
3 
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
49 
50 contract StandardToken is Token {
51 
52     uint256 constant MAX_UINT256 = 2**256 - 1;
53 
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
59         require(balances[msg.sender] >= _value);
60         balances[msg.sender] -= _value;
61         balances[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         //same as above. Replace this line with the following if you want to protect against wrapping uints.
68         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
69         uint256 allowance = allowed[_from][msg.sender];
70         require(balances[_from] >= _value && allowance >= _value);
71         balances[_to] += _value;
72         balances[_from] -= _value;
73         if (allowance < MAX_UINT256) {
74             allowed[_from][msg.sender] -= _value;
75         }
76         Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function balanceOf(address _owner) view public returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender)
91     view public returns (uint256 remaining) {
92       return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97 }
98 
99 
100 contract VIPToken is StandardToken {
101 
102     function VIPToken() public {
103         balances[msg.sender] = initialAmount;   // Give the creator all initial balances is defined in StandardToken.sol
104         totalSupply = initialAmount;            // Update total supply, totalSupply is defined in Tocken.sol
105     }
106 
107     function() public {
108 
109     }
110 
111     /* Approves and then calls the receiving contract */
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115 
116         //call the receiveApproval function on the contract you want to be notified. 
117         //This crafts the function signature manually so one doesn't have to include a contract in here just for this.
118         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
119         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
120         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
121         return true;
122     }
123 
124     string public name = "VIP";
125     uint8 public decimals = 18;
126     string public symbol = "VIP";
127     string public version = "v1.0";
128     uint256 public initialAmount = 99 * (10 ** 8) * (10 ** 18);
129 
130 }