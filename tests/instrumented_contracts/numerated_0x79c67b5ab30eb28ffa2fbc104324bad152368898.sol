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
25         require(balances[msg.sender] >= _value);
26         balances[msg.sender] -= _value;
27         balances[_to] += _value;
28         Transfer(msg.sender, _to, _value);
29         return true;
30     }
31 
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns 
34     (bool success) {
35         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
36         // _value && balances[_to] + _value > balances[_to]);
37         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
38         balances[_to] += _value;
39         balances[_from] -= _value;
40         allowed[_from][msg.sender] -= _value;
41         Transfer(_from, _to, _value);
42         return true;
43     }
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48 
49     function approve(address _spender, uint256 _value) returns (bool success)   
50     {
51         allowed[msg.sender][_spender] = _value;
52         Approval(msg.sender, _spender, _value);
53         return true;
54     }
55 
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58         return allowed[_owner][_spender];
59     }
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62 }
63 
64 contract YuanTaiToken is StandardToken { 
65 
66     /* Public variables of the token */
67     string public name;
68     uint8 public decimals;
69     string public symbol;
70     string public version = 'H0.1';
71 
72     function YuanTaiToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
73         balances[msg.sender] = _initialAmount;
74         totalSupply = _initialAmount;
75         name = _tokenName;
76         decimals = _decimalUnits;
77         symbol = _tokenSymbol;
78     }
79 
80     /* Approves and then calls the receiving contract */
81     
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
86         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
87         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
88         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
89         return true;
90     }
91 
92 }