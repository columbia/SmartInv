1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5    
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     function transfer(address _to, uint256 _value) returns (bool success) {}
11 
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
14 
15   
16     function approve(address _spender, uint256 _value) returns (bool success) {}
17 
18     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22     
23 }
24 
25 
26 
27 contract StandardToken is Token {
28 
29     function transfer(address _to, uint256 _value) returns (bool success) {
30         //Default assumes totalSupply can't be over max (2^256 - 1).
31         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
32         //Replace the if with this one instead.
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
43         //same as above. Replace this line with the following if you want to protect against wrapping uints.
44         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
45         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
46             balances[_to] += _value;
47             balances[_from] -= _value;
48             allowed[_from][msg.sender] -= _value;
49             Transfer(_from, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function balanceOf(address _owner) constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58     function approve(address _spender, uint256 _value) returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65       return allowed[_owner][_spender];
66     }
67 
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70     uint256 public totalSupply;
71 }
72 
73 
74 //name this contract whatever you'd like
75 contract tobkacoin is StandardToken {
76 
77     function () {
78         //if ether is sent to this address, send it back.
79         throw;
80     }
81 
82     /* Public variables of the token */
83 
84     /*
85     NOTE:
86     The following variables are OPTIONAL vanities. One does not have to include them.
87     They allow one to customise the token contract & in no way influences the core functionality.
88     Some wallets/interfaces might not even bother to look at this information.
89     */
90     string public name;                   //fancy name: eg Simon Bucks
91     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
92     string public symbol;                 //An identifier: eg SBX
93    
94 
95 //
96 // CHANGE THESE VALUES FOR YOUR TOKEN
97 //
98 
99 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
100 
101     function tobkacoin(
102         ) {
103         balances[msg.sender] = 4000000000000000;               // Give the creator all initial tokens (100000 for example)
104         totalSupply = 4000000000000000;                        // Update total supply (100000 for example)
105         name = "TobkaCoin";                                   // Set the name for display purposes
106         decimals = 8;                            // Amount of decimals for display purposes
107         symbol = "TBK";                               // Set the symbol for display purposes
108     }
109 
110     /* Approves and then calls the receiving contract */
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114 
115         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
116         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
117         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
118         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
119         return true;
120     }
121 }