1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13     
14 }
15 
16 
17 
18 contract StandardToken is Token {
19 
20     function transfer(address _to, uint256 _value) returns (bool success) {
21         if (balances[msg.sender] >= _value && _value > 0) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else { return false; }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31             balances[_to] += _value;
32             balances[_from] -= _value;
33             allowed[_from][msg.sender] -= _value;
34             Transfer(_from, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
50       return allowed[_owner][_spender];
51     }
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     uint256 public totalSupply;
56 }
57 
58 
59 //name this contract whatever you'd like
60 contract Aguris is StandardToken {
61 
62     function () {
63         throw;
64     }
65 
66     /* Public variables of the token */
67 
68     /*
69     NOTE:
70     The following variables are OPTIONAL vanities. One does not have to include them.
71     They allow one to customise the token contract & in no way influences the core functionality.
72     Some wallets/interfaces might not even bother to look at this information.
73     */
74     string public name;                   //fancy name: eg Simon Bucks
75     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
76     string public symbol;                 //An identifier: eg SBX
77     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
78 
79 //
80 // CHANGE THESE VALUES FOR YOUR TOKEN
81 //
82 
83     function Aguris(
84         ) {
85         balances[msg.sender] = 102100000000000;               // Give the creator all initial tokens (100000 for example)
86         totalSupply = 102100000000000;                        // Update total supply (100000 for example)
87         name = "Aguris";                                   // Set the name for display purposes
88         decimals = 8;                            // Amount of decimals for display purposes
89         symbol = "AGS";                               // Set the symbol for display purposes
90     }
91 
92     /* Approves and then calls the receiving contract */
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96 
97         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
98         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
99         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
100         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
101         return true;
102     }
103 }