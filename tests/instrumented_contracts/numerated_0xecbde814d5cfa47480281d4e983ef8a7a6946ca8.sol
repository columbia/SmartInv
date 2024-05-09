1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.16;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 contract StandardToken is Token {
52 
53     function transfer(address _to, uint256 _value) returns (bool success) {
54         require(_to != address(0));
55         require(_value <= balances[msg.sender]);
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         require(balances[_to] + _value > balances[_to]);
60         balances[msg.sender] -= _value;
61         balances[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         require(_to != address(0));
68         require(_value <= balances[_from]);
69         require(_value <= allowed[_from][msg.sender]);
70         //same as above. Replace this line with the following if you want to protect against wrapping uints.
71         require(balances[_to] + _value > balances[_to]);
72         balances[_to] += _value;
73         balances[_from] -= _value;
74         allowed[_from][msg.sender] -= _value;
75         Transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90         return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95 }
96 
97 contract Anubis is StandardToken {
98 
99     function () {
100         //if ether is sent to this address, send it back.
101         revert();
102     }
103 
104     string public name = "Anubis Token";
105     uint8 public decimals = 18;
106     string public symbol = "ANB";
107     string public version = 'v0.1';
108 
109     address public founder; // The address of the founder
110 
111     function Anubis() {
112         founder = msg.sender;
113         totalSupply = 100000000 * 10 ** uint256(decimals);
114         balances[founder] = totalSupply;
115     }
116 
117     /* Approves and then calls the receiving contract */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121 
122         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
123         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
124         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
125         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
126         return true;
127     }
128 
129     /* Approves and then calls the contract code*/
130     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133 
134         //Call the contract code
135         if(!_spender.call(_extraData)) { revert(); }
136         return true;
137     }
138 }