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
13 contract StandardToken is Token {
14     function transfer(address _to, uint256 _value) returns (bool success) {
15         if (balances[msg.sender] >= _value && _value > 0) {
16             balances[msg.sender] -= _value;
17             balances[_to] += _value;
18             Transfer(msg.sender, _to, _value);
19             return true;
20         } else { return false; }
21     }
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
23         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
24             balances[_to] += _value;
25             balances[_from] -= _value;
26             allowed[_from][msg.sender] -= _value;
27             Transfer(_from, _to, _value);
28             return true;
29         } else { return false; }
30     }
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balances[_owner];
33     }
34     function approve(address _spender, uint256 _value) returns (bool success) {
35         allowed[msg.sender][_spender] = _value;
36         Approval(msg.sender, _spender, _value);
37         return true;
38     }
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
40       return allowed[_owner][_spender];
41     }
42     function makeItRain(address[] dests, uint256[] values)
43     returns (uint256) {
44         uint256 i = 0;
45         while (i < dests.length) {
46            transfer(dests[i], values[i]);
47            i += 1;
48         }
49         return(i);
50     }
51     
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54     uint256 public totalSupply;
55 }
56 contract Cyrus is StandardToken{
57     function () {
58         throw;
59     }
60 
61     string public name;                   
62     uint8 public decimals;              
63     string public symbol;                
64     string public version = 'H1.0';
65     function Cyrus(
66         ) {
67         balances[msg.sender] = 1000000000000000;
68         totalSupply = 1000000000000000;
69         name = "CYRUS";
70         decimals = 5;
71         symbol = "CYRUS";
72     }
73     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
77         return true;
78     }
79 }