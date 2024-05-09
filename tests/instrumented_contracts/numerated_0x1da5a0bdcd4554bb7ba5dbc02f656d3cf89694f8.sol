1 pragma solidity ^0.4.8;
2 contract Token{
3 
4     uint256 public totalSupply;    //Token amount, by default, generates a getter function interface for the public variable with the name of totalSupply().
5 
6     function balanceOf(address _owner) constant returns (uint256 balance);    // Gets the number of tokens owned by the account _owner
7 
8 
9     function transfer(address _to, uint256 _value) returns (bool success);    //Token that transfers amount to _value from message sender account
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns   // token transferred from account _from to account _to is used in conjunction with the approve method
12     (bool success);
13 
14     function allowance(address _owner, address _spender) constant returns // get the number of tokens that the account _spender can transfer from the account _owner
15     (uint256 remaining);
16     
17     function approve(address _spender, uint256 _value) returns (bool success); // message sending account setting account _spender can transfer the number of token as _value from the sending account
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 
20     _value);
21     
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 
24 }
25 
26 contract StandardToken is Token {
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         //The default totalSupply does not exceed the maximum (2^256 - 1).
29         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
30         require(balances[msg.sender] >= _value);
31         balances[msg.sender] -= _value;//Subtract the token number _value from the message sender account
32         balances[_to] += _value;//Add token number _value to receive account
33         Transfer(msg.sender, _to, _value);//Trigger the exchange transaction event
34         return true;
35     }
36 
37 
38     function transferFrom(address _from, address _to, uint256 _value) returns 
39     (bool success) {
40         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
41         // _value && balances[_to] + _value > balances[_to]);
42         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
43         balances[_to] += _value;//Receive account increases token number _value
44         balances[_from] -= _value; //The expenditure account _from minus the number of tokens _value
45         allowed[_from][msg.sender] -= _value;//The number of messages sent from the account _from can be reduced by _value
46         Transfer(_from, _to, _value);//Trigger the exchange transaction event
47         return true;
48     }
49 
50     function approve(address _spender, uint256 _value) returns (bool success)   
51     {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62         return allowed[_owner][_spender];
63     }
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66 }
67 
68 contract TIAToken is StandardToken { 
69 
70     /* Public variables of the token */
71     string public name;                   //eg Simon Bucks
72     uint8 public decimals;               //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
73     string public symbol;              
74     string public version = 'H0.1';  
75 
76     function TIAToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
77         balances[msg.sender] = _initialAmount; 
78         totalSupply = _initialAmount;       
79         name = _tokenName;                   
80         decimals = _decimalUnits;          
81         symbol = _tokenSymbol;            
82     }
83 
84     /* Approves and then calls the receiving contract */
85     
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
90         return true;
91     }
92 
93 }