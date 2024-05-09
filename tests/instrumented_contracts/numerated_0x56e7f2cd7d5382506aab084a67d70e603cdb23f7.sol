1 pragma solidity ^0.4.4;
2 
3 contract BicodeToken {
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
14 contract BicodeBIC is BicodeToken {
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
26         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
27             balances[_to] += _value;
28             balances[_from] -= _value;
29             allowed[_from][msg.sender] -= _value;
30             Transfer(_from, _to, _value);
31             return true;
32         } else { return false; }
33     }
34     function balanceOf(address _owner) constant returns (uint256 balance) {
35         return balances[_owner];
36     }
37     function approve(address _spender, uint256 _value) returns (bool success) {
38         allowed[msg.sender][_spender] = _value;
39         Approval(msg.sender, _spender, _value);
40         return true;
41     }
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
43       return allowed[_owner][_spender];
44     }
45     mapping (address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed;
47     uint256 public totalSupply;
48 }
49 
50 contract BICODE is BicodeBIC {
51     function () {
52         throw;
53     }
54     string public name;
55     uint8 public decimals;
56     string public symbol;
57     string public version = 'H1.0';
58     function BICODE(
59         ) {
60         balances[msg.sender] = 10000000000000;
61         totalSupply = 10000000000000;
62         name = "BiCode";
63         decimals = 8;                          
64         symbol = "CODE";                               
65     }
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
70         return true;
71     }
72 }