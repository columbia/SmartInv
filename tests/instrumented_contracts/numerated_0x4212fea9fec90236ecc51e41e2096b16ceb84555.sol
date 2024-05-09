1 pragma solidity ^0.4.8;
2 contract Token{
3     
4     uint256 public totalSupply;
5     
6     function balanceOf(address _owner) constant returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) returns (bool success);
9 
10     function transferFrom(address _from, address _to, uint256 _value) returns   
11     (bool success);
12 
13     function approve(address _spender, uint256 _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns 
16     (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19 
20     event Approval(address indexed _owner, address indexed _spender, uint256 
21     _value);
22 }
23 
24 contract StandardToken is Token {
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         
27     //    require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
28         require(balances[msg.sender] >= _value);
29         balances[msg.sender] -= _value;
30         balances[_to] += _value;
31         Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns 
37     (bool success) {
38         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
39         // _value && balances[_to] + _value > balances[_to]);
40         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
41         balances[_to] += _value;
42         balances[_from] -= _value; 
43         allowed[_from][msg.sender] -= _value;
44         Transfer(_from, _to, _value);
45         return true;
46     }
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51 
52     function approve(address _spender, uint256 _value) returns (bool success)   
53     {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59 
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61         return allowed[_owner][_spender];
62     }
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65 }
66 
67 contract SixDomainAsset is StandardToken { 
68 
69     /* Public variables of the token */
70     string public  name;                    //name: eg Six Domain Asset
71     uint8  public  decimals;               
72     string public  symbol;                  
73     string public  version = 'v0.1';        
74     string public  officialWebsite = 'https://sdchain.io';
75 
76     function SixDomainAsset(
77         uint256 _initialAmount,
78         string _tokenName,
79         uint8 _decimalUnits,
80         string _tokenSymbol
81         ) {
82         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
83         balances[msg.sender] = totalSupply;                         // Give the creator all initial tokens
84         name = _tokenName;                                          // Set the name for display purposes
85         decimals = _decimalUnits;                                   // Amount of decimals for display purposes
86         symbol = _tokenSymbol;                                      // Set the symbol for display purposes
87     }
88 
89     /* Approves and then calls the receiving contract */
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
94         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
95         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
96         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
97         return true;
98     }
99 
100 }