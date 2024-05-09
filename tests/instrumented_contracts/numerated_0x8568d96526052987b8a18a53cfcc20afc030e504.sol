1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7 
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10 
11     function transfer(address _to, uint256 _value) returns (bool success) {}
12 
13    
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16 
17     function approve(address _spender, uint256 _value) returns (bool success) {}
18 
19 
20     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25 }
26 
27 
28 
29 contract StandardToken is Token {
30 
31     function transfer(address _to, uint256 _value) returns (bool success) {
32         //Default assumes totalSupply can't be over max (2^256 - 1).
33         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
34         //Replace the if with this one instead.
35         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
36         if (balances[msg.sender] >= _value && _value > 0) {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             Transfer(msg.sender, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45         //same as above. Replace this line with the following if you want to protect against wrapping uints.
46         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
48             balances[_to] += _value;
49             balances[_from] -= _value;
50             allowed[_from][msg.sender] -= _value;
51             Transfer(_from, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60     function approve(address _spender, uint256 _value) returns (bool success) {
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67       return allowed[_owner][_spender];
68     }
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72     uint256 public totalSupply;
73 }
74 
75 
76 
77 contract EIDOO is StandardToken {
78 
79     function () {
80         //if ether is sent to this address, send it back.
81         throw;
82     }
83 
84     /* Public variables of the token */
85 
86 
87     string public name;                   
88     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
89     string public symbol;                 //An identifier: eg SBX
90     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
91 
92 
93 
94 
95 
96     function EIDOO(
97         ) {
98         balances[msg.sender] = 810000000;               // Give the creator all initial tokens (100000 for example)
99         totalSupply = 810000000;                        // Update total supply (100000 for example)
100         name = "EIDOO";                                   // Set the name for display purposes
101         decimals = 1;                            // Amount of decimals for display purposes
102         symbol = "EDO";                               // Set the symbol for display purposes
103     }
104 
105     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108 
109        
110         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
111         return true;
112     }
113 }