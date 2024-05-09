1 pragma solidity ^0.4.24;
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
35         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
36         balances[_to] += _value;
37         balances[_from] -= _value; 
38         allowed[_from][msg.sender] -= _value;
39         Transfer(_from, _to, _value);
40         return true;
41     }
42     function balanceOf(address _owner) constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46 
47     function approve(address _spender, uint256 _value) returns (bool success)   
48     {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56         return allowed[_owner][_spender];
57     }
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60 }
61 
62 contract LINDOToken is StandardToken { 
63 
64     string public name;                   
65     uint8 public decimals;               
66     string public symbol;              
67 
68     function LINDOToken() {
69         balances[msg.sender] = 0.1 ether; 
70         totalSupply = 0.1 ether;         
71         name = "LINDO Token";                   
72         decimals = 8;           
73         symbol = "LINDO";             
74     }
75 
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
80         return true;
81     }
82 
83 }