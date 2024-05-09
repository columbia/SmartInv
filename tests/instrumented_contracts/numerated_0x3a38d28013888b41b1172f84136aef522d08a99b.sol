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
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23 
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function balanceOf(address _owner) constant returns (uint256 balance) {
35         return balances[_owner];
36     }
37 
38     function approve(address _spender, uint256 _value) returns (bool success) {
39         allowed[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
45       return allowed[_owner][_spender];
46     }
47 
48     mapping (address => uint256) balances;
49     mapping (address => mapping (address => uint256)) allowed;
50     uint256 public totalSupply;
51 }
52 
53 
54 contract ERC20Token is StandardToken {
55     function () {
56         throw;
57     }
58 
59     string public name;                  
60     uint8 public decimals;             
61     string public symbol;                
62     string public version = 'H1.0'; 
63     
64     function ERC20Token(
65         ) {
66         balances[msg.sender] = 1000000000000000;
67         totalSupply = 1000000000000000;
68         name = "0xPay";
69         decimals = 7;
70         symbol = "0XPAY";
71     }
72 
73     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76 
77         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
78         return true;
79     }
80 }