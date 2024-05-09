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
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);}
38 
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) returns (bool success) {
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else { return false; }}
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
51             balances[_to] += _value;
52             balances[_from] -= _value;
53             allowed[_from][msg.sender] -= _value;
54             Transfer(_from, _to, _value);
55             return true;
56         } else { return false; }}
57 
58     function balanceOf(address _owner) constant returns (uint256 balance) {
59         return balances[_owner];}
60 
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;}
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67       return allowed[_owner][_spender];}
68 
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     uint256 public totalSupply;}
72 
73 contract Collectorcoin is StandardToken {
74 
75     function () {
76         throw;}
77 
78     /* Public variables of the token */
79 
80     string public name = 'Collectorcoin';                   
81     uint8 public decimals = 2;                
82     string public symbol = 'CLC';                 
83     string public version = 'H1.0';       
84 
85     function Collectorcoin(
86         ) {
87         balances[msg.sender] = 100000000000;               
88         totalSupply = 100000000000;                        
89         name = "Collectorcoin";                                   
90         decimals = 2;                            
91         symbol = "CLC";}
92 
93     /* Approves and then calls the receiving contract */
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97 
98         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
99         return true;}}