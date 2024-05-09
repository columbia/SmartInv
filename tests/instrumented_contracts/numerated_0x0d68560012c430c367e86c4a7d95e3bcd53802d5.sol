1 pragma solidity ^0.4.11;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @return The balance
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     /// @return Whether the transfer was successful or not
12     function transfer(address _to, uint256 _value) returns (bool success) {}
13 
14     /// @return Whether the transfer was successful or not
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
16 
17    /// @return Whether the approval was successful or not
18     function approve(address _spender, uint256 _value) returns (bool success) {}
19 
20    /// @return Amount of remaining tokens allowed to spent
21     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25     
26 }
27 
28 
29 
30 contract StandardToken is Token {
31 
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
34         if (balances[msg.sender] >= _value && _value > 0) {
35             balances[msg.sender] -= _value;
36             balances[_to] += _value;
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
43        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
44         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
45             balances[_to] += _value;
46             balances[_from] -= _value;
47             allowed[_from][msg.sender] -= _value;
48             Transfer(_from, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function balanceOf(address _owner) constant returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     uint256 public totalSupply;
70 }
71 
72 
73 
74 contract DiscoverCoin is StandardToken {
75 
76     function () {
77         
78         throw;
79     }
80 
81     
82     string public name;                   
83     uint8 public decimals;                
84     string public symbol;                 
85     string public version = 'H1.0';       
86 
87 
88     function DiscoverCoin(
89         ) {
90         balances[msg.sender] = 15000000000000000000000000;               
91         totalSupply = 15000000000000000000000000;                        
92         name = "DiscoverCoin";                                   
93         decimals = 18;                            
94         symbol = "DISC";                               
95     }
96 
97     /* Approves and then calls the receiving contract */
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101 
102         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
103         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
104         return true;
105     }
106 }