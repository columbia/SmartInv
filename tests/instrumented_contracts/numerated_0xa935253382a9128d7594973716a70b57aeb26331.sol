1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13     
14 }
15 
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19         if (balances[msg.sender] >= _value && _value > 0) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
29             balances[_to] += _value;
30             balances[_from] -= _value;
31             allowed[_from][msg.sender] -= _value;
32             Transfer(_from, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint256 _value) returns (bool success) {
42         allowed[msg.sender][_spender] = _value;
43         Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
48       return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53     uint256 public totalSupply;
54 }
55 
56 contract FAOC is StandardToken {
57 
58     function () {
59       
60         throw;
61     }
62     string public name;                   
63     uint8 public decimals;                
64     string public symbol;                 
65     string public version = '1.0';       
66 
67 
68     function FAOC(
69         ) {
70         balances[msg.sender] = 700000000000000000000000000;              
71         totalSupply = 700000000000000000000000000;                   
72         name = "Food and Agriculture Organization Chain";                                   
73         decimals = 18;                           
74         symbol = "FAOC";                               
75     }
76 
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
81         return true;
82     }
83 }