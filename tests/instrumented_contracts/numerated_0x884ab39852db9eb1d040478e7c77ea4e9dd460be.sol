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
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);}
13 
14 contract StandardToken is Token {
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; } }
23 
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; } }
32  function balanceOf(address _owner) constant returns (uint256 balance) {
33         return balances[_owner]; }
34  function approve(address _spender, uint256 _value) returns (bool success) {
35         allowed[msg.sender][_spender] = _value;
36         Approval(msg.sender, _spender, _value);
37         return true; }
38  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
39       return allowed[_owner][_spender]; }
40     mapping (address => uint256) balances;
41     mapping (address => mapping (address => uint256)) allowed;
42     uint256 public totalSupply;}
43 
44 
45 
46 contract ROHH is StandardToken {
47 
48     function () {
49         throw;
50     }
51 
52     string public name;                   
53     uint8 public decimals;                
54     string public symbol;                
55     string public version = 'H1.0';     
56 
57 //
58     function ROHH(
59         ) {
60         balances[msg.sender] = 42000000000000000000000000;            
61         totalSupply = 42000000000000000000000000;                     
62         name = "Republic ov Hip Hop";                               
63         decimals = 18;                         
64         symbol = "ROHH";                           
65     }
66 
67     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70 
71       
72         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
73         return true;
74     }
75 }