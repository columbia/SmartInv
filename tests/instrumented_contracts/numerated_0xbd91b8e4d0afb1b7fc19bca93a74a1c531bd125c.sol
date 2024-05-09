1 pragma solidity ^0.4.21;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract StandardToken is Token {
22 
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         if (balances[msg.sender] >= _value && _value > 0) {
25             balances[msg.sender] -= _value;
26             balances[_to] += _value;
27             Transfer(msg.sender, _to, _value);
28             return true;
29         } else { return false; }
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
33         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function balanceOf(address _owner) constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value) returns (bool success) {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
53       return allowed[_owner][_spender];
54     }
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58     uint256 public totalSupply;
59 }
60 
61 contract IscmToken is StandardToken {
62 
63     function () {
64         throw;
65     }
66 
67     string public name;
68     uint8 public decimals = 18;
69     string public symbol;
70     string public version = '1.0';
71 
72     function IscmToken(
73         uint256 _initialAmount,
74         string _tokenName,
75         string _tokenSymbol
76         ) {
77         totalSupply = _initialAmount * 10 ** uint256(decimals);
78         balances[msg.sender] = totalSupply;
79         name = _tokenName;
80         symbol = _tokenSymbol;
81     }
82 
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86 
87         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
88         return true;
89     }
90 }