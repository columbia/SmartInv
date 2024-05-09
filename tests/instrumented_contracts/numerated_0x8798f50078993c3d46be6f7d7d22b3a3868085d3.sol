1 pragma solidity ^0.4.4;
2 
3 //Purpose: PantherCoin is the next step in the process of rebalancing the economic scales worldwide, returning wealth to the hands of the oppressed (more on that below) and providing a means for frictionless international and interpersonal commerce between people normally deprived of such benefits.
4 //The Promise: 10% or more of all funds the creator of PantherCoin receives will be invested in or donated to black empowerment & education causes, black people in need anywhere in the world.  Beyond that baseline promise, PantherCoin proceeds will also be used to begin exploring options and opportunities for providing black people across the globe with an international home, just as jewish people and other ethnicities have.  Get ready.
5 //Who am I?  My name is Zeaun Zarrieff, and I'm here to help.
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42     
43 }
44 
45 
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 
88 contract PantherCoin is StandardToken {
89 
90     function () {
91         //if ether is sent to this address, send it back.
92         throw;
93     }
94 
95     /* Public variables of the token */
96 
97     string public name = "PantherCoin";                   
98     uint8 public decimals = 7;                
99     string public symbol = "PANT";                 
100     string public version = 'H1.0';       
101 
102 
103     function PantherCoin(
104         ) {
105         balances[msg.sender] = 10000000000000000;
106         totalSupply = 10000000000000000;
107         name = "PantherCoin";
108         decimals = 7;
109         symbol = "PANT";
110     }
111 
112     /* Approves and then calls the receiving contract */
113     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
114         allowed[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116 
117         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
118         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
119         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
120         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
121         return true;
122     }
123 }