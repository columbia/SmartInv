1 pragma solidity ^0.4.21;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint balance) {}
8 
9     function transfer(address _to, uint _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
12 
13     function approve(address _spender, uint _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18     event Approval(address indexed _owner, address indexed _spender, uint _value);
19     
20 }
21 
22 
23 
24 contract StandardToken is Token {
25 
26     function transfer(address _to, uint _value) returns (bool success) {
27         //Default assumes totalSupply can't be over max (2^256 - 1).
28         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
29         //Replace the if with this one instead.
30         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
31         if (balances[msg.sender] >= _value && _value > 0) {
32             balances[msg.sender] -= _value;
33             balances[_to] += _value;
34             Transfer(msg.sender, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
40         //same as above. Replace this line with the following if you want to protect against wrapping uints.
41         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
42         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43             balances[_to] += _value;
44             balances[_from] -= _value;
45             allowed[_from][msg.sender] -= _value;
46             Transfer(_from, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function balanceOf(address _owner) constant returns (uint balance) {
52         return balances[_owner];
53     }
54 
55     function approve(address _spender, uint _value) returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) constant returns (uint remaining) {
62       return allowed[_owner][_spender];
63     }
64 
65     mapping (address => uint) balances;
66     mapping (address => mapping (address => uint)) allowed;
67     uint public totalSupply;
68 }
69 
70 
71 contract CoinPulseToken is StandardToken {
72 
73     function () {
74         //if ether is sent to this address, send it back.
75         throw;
76     }
77 
78     /* Public variables of the token */
79 
80     /*
81     NOTE:
82     The following variables are OPTIONAL vanities. One does not have to include them.
83     They allow one to customise the token contract & in no way influences the core functionality.
84     Some wallets/interfaces might not even bother to look at this information.
85     */
86     string public name;                   
87     uint8 public decimals;                
88     string public symbol;                 
89     string public version = 'H1.0';       
90 
91 //
92 // CHANGE THESE VALUES FOR YOUR TOKEN
93 //
94 
95 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
96 
97     function CoinPulseToken(
98         ) {
99         balances[msg.sender] = 10000000000000000;
100         totalSupply = 10000000000000000;
101         name = "CoinPulseToken";
102         decimals = 8;
103         symbol = "CPEX";
104     }
105 
106     /* Approves and then calls the receiving contract */
107     function approveAndCall(address _spender, uint _value, bytes _extraData) returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110 
111         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
112         //receiveApproval(address _from, uint _value, address _tokenContract, bytes _extraData)
113         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
114         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
115         return true;
116     }
117 }