1 pragma solidity 0.4.19;
2 
3 contract KVLT {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     
20 }
21 
22 
23 contract OFFERING is KVLT {
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     uint256 public totalSupply;
61 }
62 
63 
64 //name this contract whatever you'd like
65 contract EVOCATION is OFFERING {
66 
67     function () {
68         //if ether is sent to this address, send it back.
69         throw;
70     }
71 
72     string public name;                   //fancy name: eg Simon Bucks
73     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
74     string public symbol;                 //An identifier: eg SBX
75     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
76 
77 
78     function EVOCATION(
79         ) {
80         balances[msg.sender] = 88777666;               // Give the creator all initial tokens (100000 for example)
81         totalSupply = 88777666;                        // Update total supply (100000 for example)
82         name = "KVLT";                                   // Set the name for display purposes
83         decimals = 0;                            // Amount of decimals for display purposes
84         symbol = "KVLT";                               // Set the symbol for display purposes
85     }
86 
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90 
91         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
92         return true;
93     }
94 }