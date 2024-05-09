1 pragma solidity ^0.4.4;
2 
3 /// GCH StandardToken Code
4 
5 contract Token {
6     function totalSupply() constant returns (uint256 supply) {}
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8     function transfer(address _to, uint256 _value) returns (bool success) {}
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10     function approve(address _spender, uint256 _value) returns (bool success) {}
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);}
14 
15 contract StandardToken is Token {
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;   } else { return false; } }
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
23         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
24             balances[_to] += _value;
25             balances[_from] -= _value;
26             allowed[_from][msg.sender] -= _value;
27             Transfer(_from, _to, _value);
28             return true;
29         } else { return false; } }
30     function balanceOf(address _owner) constant returns (uint256 balance) {
31         return balances[_owner]; }
32     function approve(address _spender, uint256 _value) returns (bool success) {
33         allowed[msg.sender][_spender] = _value;
34         Approval(msg.sender, _spender, _value);
35         return true; }
36     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
37       return allowed[_owner][_spender]; }
38      mapping (address => uint256) balances;
39      mapping (address => mapping (address => uint256)) allowed;
40        uint256 public totalSupply;}
41 
42 contract GCH is StandardToken {
43     
44     /// Throw back
45     function () {throw;}
46     string public name;                   
47     uint8 public decimals;                
48     string public symbol;                
49     string public version = 'H1.0';     
50 
51     /// Good Cash Data
52     function GCH( ) {
53         balances[msg.sender] = 125000000000000000000;            
54         totalSupply = 125000000000000000000;                     
55         name = "Good Cash";                               
56         decimals = 8;                         
57         symbol = "GCH";          }
58 
59     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
63         return true;  }
64 }