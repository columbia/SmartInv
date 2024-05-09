1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, May 8, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.8;
6 
7 
8 contract Token {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) public view returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 contract StandardToken is Token {
55 
56     uint256 constant MAX_UINT256 = 2**256 - 1;
57 
58     function transfer(address _to, uint256 _value) public returns (bool success) {
59         //Default assumes totalSupply can't be over max (2^256 - 1).
60         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
61         //Replace the if with this one instead.
62         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
63         require(balances[msg.sender] >= _value);
64         balances[msg.sender] -= _value;
65         balances[_to] += _value;
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         //same as above. Replace this line with the following if you want to protect against wrapping uints.
72         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
73         uint256 allowance = allowed[_from][msg.sender];
74         require(balances[_from] >= _value && allowance >= _value);
75         balances[_to] += _value;
76         balances[_from] -= _value;
77         if (allowance < MAX_UINT256) {
78             allowed[_from][msg.sender] -= _value;
79         }
80         Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) view public returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender)
95     view public returns (uint256 remaining) {
96       return allowed[_owner][_spender];
97     }
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 }
102 
103 
104 contract GOLDToken is StandardToken {
105 
106     function GOLDToken() public {
107         balances[msg.sender] = initialAmount;   // Give the creator all initial balances is defined in StandardToken.sol
108         totalSupply = initialAmount;            // Update total supply, totalSupply is defined in Tocken.sol
109     }
110 
111     function() public {
112 
113     }
114 
115     /* Approves and then calls the receiving contract */
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119 
120         //call the receiveApproval function on the contract you want to be notified. 
121         //This crafts the function signature manually so one doesn't have to include a contract in here just for this.
122         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
123         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
124         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
125         return true;
126     }
127 
128     string public name = "GOLD";
129     uint8 public decimals = 18;
130     string public symbol = "GOLD";
131     string public version = "v1.1";
132     uint256 public initialAmount = 1000 * (10 ** 8) * (10 ** 18);
133 
134 }