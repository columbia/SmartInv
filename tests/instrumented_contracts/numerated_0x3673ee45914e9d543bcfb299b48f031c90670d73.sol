1 pragma solidity ^0.4.20;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);}
13 contract StandardToken is Token {
14     function transfer(address _to, uint256 _value) returns (bool success) {
15         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;}}
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
22         //same as above. Replace this line with the following if you want to protect against wrapping uints.
23         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
24         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
25             balances[_to] += _value;
26             balances[_from] -= _value;
27             allowed[_from][msg.sender] -= _value;
28             Transfer(_from, _to, _value);
29             return true;
30         } else { return false; }    }
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balances[_owner];    }
33     function approve(address _spender, uint256 _value) returns (bool success) {
34         allowed[msg.sender][_spender] = _value;
35         Approval(msg.sender, _spender, _value);
36         return true;    }
37     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
38       return allowed[_owner][_spender];    }
39     mapping (address => uint256) balances;
40     mapping (address => mapping (address => uint256)) allowed;
41     uint256 public totalSupply;}
42 contract Mire is StandardToken {
43     string public name = "Mire";                   
44     uint8 public decimals = 4;                
45     string public symbol = "MIR";
46     function Mire () {
47         balances[msg.sender] = 4*10**27;               
48         totalSupply = 4*10**27;   
49         name = "Mire";        
50         decimals = 5;           
51         symbol = "MIR";     }
52     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
56         return true;
57     }
58 }