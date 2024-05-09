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
12     
13 }
14 contract StandardToken is Token {
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
24         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
25             balances[_to] += _value;
26             balances[_from] -= _value;
27             allowed[_from][msg.sender] -= _value;
28             Transfer(_from, _to, _value);
29             return true;
30         } else { return false; }
31     }
32     function balanceOf(address _owner) constant returns (uint256 balance) {
33         return balances[_owner];
34     }
35     function approve(address _spender, uint256 _value) returns (bool success) {
36         allowed[msg.sender][_spender] = _value;
37         Approval(msg.sender, _spender, _value);
38         return true;
39     }
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
41       return allowed[_owner][_spender];
42     }
43 
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     uint256 public totalSupply;
47 }
48 contract NAEC is StandardToken {
49 
50     function () {
51       
52         throw;
53     }
54     string public name;                   
55     uint8 public decimals;                
56     string public symbol;                 
57     string public version = '1.0';       
58 
59 
60     function NAEC(
61         ) {
62         balances[msg.sender] = 360000000000000000000000000;              
63         totalSupply = 360000000000000000000000000;                   
64         name = "NewAgricultureChain";                                   
65         decimals = 18;                           
66         symbol = "NAEC";                               
67     }
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
72         return true;
73     }
74 }