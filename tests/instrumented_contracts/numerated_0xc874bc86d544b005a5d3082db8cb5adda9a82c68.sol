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
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14     
15 }
16 
17 contract StandardToken is Token {
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {
20 
21         if (balances[msg.sender] >= _value && _value > 0) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else { return false; }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30 
31         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
32             balances[_to] += _value;
33             balances[_from] -= _value;
34             allowed[_from][msg.sender] -= _value;
35             Transfer(_from, _to, _value);
36             return true;
37         } else { return false; }
38     }
39 
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56     uint256 public totalSupply;
57 }
58 
59 contract LAN30 is StandardToken {
60 
61     function () {
62         //if ether is sent to this address, send it back.
63         throw;
64     }
65 
66     string public name;                  
67     uint8 public decimals;                
68     string public symbol;                 
69     string public version = 'H1.0';       
70 
71     function LAN30(
72         ) {
73         balances[msg.sender] = 61000000000000000000000000;               
74         totalSupply = 61000000000000000000000000;                        
75         name = "LANITA";                                   
76         decimals = 18;                            
77         symbol = "LAN30";                              
78     }
79 
80 }