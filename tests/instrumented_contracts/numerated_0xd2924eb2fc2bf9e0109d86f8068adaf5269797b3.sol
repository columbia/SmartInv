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
12 }
13 
14 contract StandardToken is Token {
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24 
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
26         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
27             balances[_to] += _value;
28             balances[_from] -= _value;
29             allowed[_from][msg.sender] -= _value;
30             Transfer(_from, _to, _value);
31             return true;
32         } else { return false; }
33     }
34 
35     function balanceOf(address _owner) constant returns (uint256 balance) {
36         return balances[_owner];
37     }
38 
39     function approve(address _spender, uint256 _value) returns (bool success) {
40         allowed[msg.sender][_spender] = _value;
41         Approval(msg.sender, _spender, _value);
42         return true;
43     }
44 
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
46 		return allowed[_owner][_spender];
47     }
48 
49     mapping (address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51     uint256 public totalSupply;
52 }
53 
54 contract NYJFIN is StandardToken {
55 
56     function () {
57         throw;
58     }
59 
60     string public name;
61     uint8 public decimals;
62     string public symbol;
63     string public version = 'M1.2';
64 
65     function NYJFIN () {
66         balances[msg.sender] = 100000000000000000000000000;
67         totalSupply = 100000000000000000000000000;
68         name = "JFincoin";
69         decimals = 18;
70         symbol = "JFin";
71     }
72 
73     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
77         return true;
78     }
79 }