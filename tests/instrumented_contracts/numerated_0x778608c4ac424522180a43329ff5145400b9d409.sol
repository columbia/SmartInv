1 pragma solidity ^0.4.21;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) returns (bool success);
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10 
11     function approve(address _spender, uint256 _value) returns (bool success);
12 
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16 
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 contract StandardToken is Token {
21     function transfer(address _to, uint256 _value) returns (bool success) {
22         require(balances[msg.sender] >= _value);
23         balances[msg.sender] -= _value;
24         balances[_to] += _value;
25         Transfer(msg.sender, _to, _value);
26         return true;
27     }
28 
29 
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
31         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
32         balances[_to] += _value;
33         balances[_from] -= _value; 
34         allowed[_from][msg.sender] -= _value;
35         Transfer(_from, _to, _value);
36         return true;
37     }
38     function balanceOf(address _owner) constant returns (uint256 balance) {
39         return balances[_owner];
40     }
41 
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
50         return allowed[_owner][_spender];
51     }
52     
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55 }
56 
57 contract ChainclubToken is StandardToken { 
58 
59     string public name;                   
60     uint8 public decimals;               
61     string public symbol;              
62 
63     function ChainclubToken() {
64         balances[msg.sender] = 0.21 ether; 
65         totalSupply = 0.21 ether;         
66         name = "Chainclub Ecosystem Network";                   
67         decimals = 8;           
68         symbol = "CEN";             
69     }
70 
71     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
75         return true;
76     }
77 
78 }