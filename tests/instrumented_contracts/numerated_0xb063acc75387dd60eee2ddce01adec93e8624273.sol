1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12     
13 }
14 
15 contract StandardToken is Token {
16 
17     function transfer(address _to, uint256 _value) returns (bool success) {
18         if (balances[msg.sender] >= _value && _value > 0) {
19             balances[msg.sender] -= _value;
20             balances[_to] += _value;
21             Transfer(msg.sender, _to, _value);
22             return true;
23         } else { return false; }
24     }
25 
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
27         
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
56 contract CandyCoinBigBang is StandardToken {
57 
58     function () {
59         throw;
60     }
61 
62     string public name;                   
63     uint8 public decimals;                
64     string public symbol;                 
65     string public version = 'H1.0';      
66 
67     function CandyCoinBigBang() {
68         balances[msg.sender] = 1000000000000000000000000;               
69         totalSupply = 1000000000000000000000000;
70         name = "Candy Coin";                                  
71         decimals = 18;                            
72         symbol = "CNDY";                               
73     }
74 
75 
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
80         return true;
81     }
82 }