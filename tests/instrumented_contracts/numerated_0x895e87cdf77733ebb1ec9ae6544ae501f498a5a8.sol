1 pragma solidity ^0.4.4;
2 
3 contract Token {
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
19 	string public constant symbol = "";
20     
21 }
22 
23 
24 
25 contract StandardToken is Token {
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         //Default assumes totalSupply can't be over max (2^256 - 1).
29         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
30         //Replace the if with this one instead.
31         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
32         if (balances[msg.sender] >= _value && _value > 0) {
33             balances[msg.sender] -= _value;
34             balances[_to] += _value;
35             Transfer(msg.sender, _to, _value);
36             return true;
37         } else { return false; }
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41         //same as above. Replace this line with the following if you want to protect against wrapping uints.
42         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
43         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
44             balances[_to] += _value;
45             balances[_from] -= _value;
46             allowed[_from][msg.sender] -= _value;
47             Transfer(_from, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) returns (bool success) {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
63       return allowed[_owner][_spender];
64     }
65 
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68     uint256 public totalSupply;
69 }
70 
71 
72 //name this contract whatever you'd like
73 contract ERC20Token is StandardToken {
74 
75     function () {
76         //if ether is sent to this address, send it back.
77         throw;
78     }
79 
80     /* Public variables of the token */
81 
82     /*
83     NOTE:
84     The following variables are OPTIONAL vanities. One does not have to include them.
85     They allow one to customise the token contract & in no way influences the core functionality.
86     Some wallets/interfaces might not even bother to look at this information.
87     */
88     string public name;                   //fancy name: eg Simon Bucks
89     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
90     string public symbol;                 //An identifier: eg SBX
91     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
92 
93     function ERC20Token(
94         ) {
95         balances[msg.sender] = 10000000000000000000;               // Give the creator all initial tokens (100000 for example)
96         totalSupply = 10000000000000000000;                        // Update total supply (100000 for example)
97         name = "IAM";                                   // Set the name for display purposes
98         decimals = 8;                            // Amount of decimals for display purposes
99         symbol = "IAM";                            // Set the symbol for display purposes
100     }
101 
102     /* Approves and then calls the receiving contract */
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106 
107         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
108         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
109         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
110         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
111         return true;
112     }
113 }