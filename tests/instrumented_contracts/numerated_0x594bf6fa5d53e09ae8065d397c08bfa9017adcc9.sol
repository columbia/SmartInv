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
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     uint256 public totalSupply;
79 }
80 
81 contract Cuffcoin is StandardToken {
82 
83     function () {
84         //if ether is sent to this address, send it back.
85         throw;
86     }
87 
88     /* Public variables of the token */
89 
90     string public name;
91     uint8 public decimals;
92     string public symbol;
93     string public version = 'H1.0';
94 
95     function Cuffcoin(
96         ) {
97         balances[msg.sender] = 10000000000;
98         totalSupply = 10000000000;
99         name = "Cuffcoin";
100         decimals = 2;
101         symbol = "CUFF";
102     }
103 
104     /* Approves and then calls the receiving contract */
105     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108 
109         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
110         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
111         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
112         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
113         return true;
114     }
115 }