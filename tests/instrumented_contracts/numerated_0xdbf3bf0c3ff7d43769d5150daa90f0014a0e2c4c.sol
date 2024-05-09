1 pragma solidity ^0.4.4;
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
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13     
14 }
15 
16 
17 
18 contract StandardToken is Token {
19 
20     function transfer(address _to, uint256 _value) returns (bool success) {
21         if (balances[msg.sender] >= _value && _value > 0) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else { return false; }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31             balances[_to] += _value;
32             balances[_from] -= _value;
33             allowed[_from][msg.sender] -= _value;
34             Transfer(_from, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
50       return allowed[_owner][_spender];
51     }
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     uint256 public totalSupply;
56 }
57 
58 
59 contract ERC20Token is StandardToken {
60 
61     function () {
62         throw;
63     }
64 
65     string public name;                   
66     uint8 public decimals;                
67     string public symbol;                 
68     string public version = 'H1.0';       
69 
70     function ERC20Token(
71         ) {
72         balances[msg.sender] = 12000000000000000000000000;               // 12 Million Total Supply
73         totalSupply = 12000000000000000000000000;                     
74         name = "Monetize Coin";                                   
75         decimals = 18;                            
76         symbol = "MNZ";                              
77     }
78 
79     
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83 
84         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
85         return true;
86     }
87 }