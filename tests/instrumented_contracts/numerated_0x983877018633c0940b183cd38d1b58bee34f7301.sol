1 pragma solidity ^0.4.16;
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
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33     function balanceOf(address _owner) constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36     function approve(address _spender, uint256 _value) returns (bool success) {
37         allowed[msg.sender][_spender] = _value;
38         Approval(msg.sender, _spender, _value);
39         return true;
40     }
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
42       return allowed[_owner][_spender];
43     }
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     uint256 public totalSupply;
47 }
48 contract DeepGold is StandardToken {
49     function () {
50         throw;
51     }
52     string public name;   
53     uint8 public decimals;     
54     string public symbol;  
55     string public version = 'D1.0';   
56 
57     function DeepGold(
58         ) {
59         balances[msg.sender] = 10000000000000000; 
60         totalSupply = 10000000000000000; 
61         name = "Deep Gold";      
62         decimals = 8;            
63         symbol = "DEEP";                 
64     }
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
69         return true;
70     }
71 }