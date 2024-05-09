1 pragma solidity ^0.4.4;
2 
3 contract ERC20Token {
4     function totalSupply() constant returns (uint256 supply) {}
5 	function balanceOf(address _owner) constant returns (uint256 balance) {}
6 	function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     function getToken(uint256 _value) returns (bool success) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 
17 contract StandardToken is ERC20Token {
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {
20         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
21             balances[msg.sender] -= _value;
22             balances[_to] += _value;
23             Transfer(msg.sender, _to, _value);
24             return true;
25         } else { return false; }
26     }
27     
28     function getToken(uint256 _value) returns (bool success){
29         uint newTokens = _value;
30         balances[msg.sender] = balances[msg.sender] + newTokens;
31     }
32     
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     uint256 public totalSupply;
60 }
61 
62 
63 contract Amorcoin is StandardToken {
64 
65     string public name; 
66     uint8 public decimals;               
67     string public symbol;   
68     string public version = 'V1.0';   
69     address owner;
70 
71     function Amorcoin() {
72         totalSupply = 25000000000000000;
73         name = "AMORCOIN";
74         decimals = 8;     
75         symbol = "AMR";
76 	balances[msg.sender] = 25000000000000000;
77         owner = msg.sender;
78     }
79     
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
84         return true;
85     }   
86 	
87 }