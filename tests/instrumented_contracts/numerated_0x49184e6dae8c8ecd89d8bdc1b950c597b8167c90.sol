1 /* Libertas Token */
2 pragma solidity ^0.4.16;
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
19     
20 }
21 
22 contract StandardToken is Token {
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         if (balances[msg.sender] >= _value && _value > 0) {
25             balances[msg.sender] -= _value;
26             balances[_to] += _value;
27             Transfer(msg.sender, _to, _value);
28             return true;
29         } else { return false; }
30     }
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
33             balances[_to] += _value;
34             balances[_from] -= _value;
35             allowed[_from][msg.sender] -= _value;
36             Transfer(_from, _to, _value);
37             return true;
38         } else { return false; }
39     }
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
49       return allowed[_owner][_spender];
50     }
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53     uint256 public totalSupply;
54 }
55 contract LibertasToken is StandardToken {
56     function () {
57         throw;
58     }
59 
60     string public name;                   
61     uint8 public decimals;               
62     string public symbol;             
63     string public version = 'V1.0';    
64 
65     function LibertasToken(
66         ) {
67         balances[msg.sender] = 10000000000;               
68         totalSupply = 10000000000;                        
69         name = "LIBERTAS";                                 
70         decimals = 2;                                     
71         symbol = "LIBERTAS";                                  
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77 
78         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
79         return true;
80     }
81 }