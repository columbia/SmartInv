1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) public returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) public returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 
41 contract B_CommerceCoin is Token {
42 
43     function transfer(address _to, uint256 _value) public returns (bool success) {
44         //Default TotalSupply can't be over max (2^256 - 1).
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
54         //same as above. Replace this line with the following if you want to protect against wrapping uints.
55         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             Transfer(_from, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function balanceOf(address _owner) public constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
76       return allowed[_owner][_spender];
77     }
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81     uint256 public totalSupply;
82 }
83 
84 
85     //B-CommerceCoin is a token created by Scorebot Pte Ltd for Tap-A-Coin, B-Commerce Pte Ltd
86 contract B_Com is B_CommerceCoin {
87 
88     function () public {
89         //if ether is sent to this address, send it back.
90         throw;
91     }
92 
93     /* Public variables of the token */
94 
95     /*
96     NOTE:
97     Created by Scorebot Pte Ltd for Tap-A-Coin, B-Commerce Pte Ltd.
98     */
99 
100     string public name;                   //Tap-A-Coin B-CommerceCoin
101     uint8 public decimals;                //Decimal Zero
102     string public symbol;                 //B-Com
103     string public version = 'V1.0';       //V1.0.
104 
105     // Attributes of B-CommerceCoin.
106     function B_Com() public {
107         balances[msg.sender] = 14250000000000;             // Creator receives all initial tokens 
108         totalSupply = 14250000000000;                      // Total Supply 1,425,000,000
109         name = "B-CommerceCoin";                           // Display name of B-Com
110         decimals = 4;                                      // 4 decimals 
111         symbol = "B-Com";                                  // Symbol for display
112     }
113 
114     /* Approves and then calls the receiving contract */
115     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118 
119         //call the receiveApproval function on the contract you want to be notified.
120         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
121         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
122         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
123         return true;
124     }
125 }