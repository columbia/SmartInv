1 pragma solidity ^0.4.8;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) returns (bool success);
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns   
10     (bool success);
11 
12     function approve(address _spender, uint256 _value) returns (bool success);
13 
14     function allowance(address _owner, address _spender) constant returns 
15     (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 
20     _value);
21 }
22 
23 contract StandardToken is Token {
24     function transfer(address _to, uint256 _value) returns (bool success) {
25 
26         require(balances[msg.sender] >= _value);
27         balances[msg.sender] -= _value;
28         balances[_to] += _value;
29         Transfer(msg.sender, _to, _value);
30         return true;
31     }
32 
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns 
35     (bool success) {
36         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
37         // _value && balances[_to] + _value > balances[_to]);
38         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
39         balances[_to] += _value;
40         balances[_from] -= _value; 
41         allowed[_from][msg.sender] -= _value;
42         Transfer(_from, _to, _value);
43         return true;
44     }
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49 
50     function approve(address _spender, uint256 _value) returns (bool success)   
51     {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57 
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59         return allowed[_owner][_spender];
60     }
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63 }
64 
65 contract GDToken is StandardToken { 
66 
67     /* Public variables of the token */
68     string public name;                   
69     uint8 public decimals;               
70     string public symbol;               
71     string public version = 'H0.1';    
72 
73     function GDToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
74         balances[msg.sender] = _initialAmount; 
75         totalSupply = _initialAmount;         
76         name = _tokenName;                   
77         decimals = _decimalUnits;           
78         symbol = _tokenSymbol;             
79     }
80 
81     /* Approves and then calls the receiving contract */
82     
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
87         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
88         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
89         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
90         return true;
91     }
92 
93 }