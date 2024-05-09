1 pragma solidity ^0.4.11;
2 pragma solidity ^0.4.8;
3 
4 
5 contract Token {
6     uint256 public totalSupply;
7 
8     function balanceOf(address _owner) constant returns (uint256 balance);
9 
10     function transfer(address _to, uint256 _value) returns (bool success);
11 
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
13 
14     function approve(address _spender, uint256 _value) returns (bool success);
15 
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 
23 contract StandardToken is Token {
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60 }
61 
62 contract MangoCoin is StandardToken {
63 
64     function () {
65         throw;
66     }
67 
68     string public name;
69     uint8 public decimals;
70     string public symbol;
71     string public version = '1.0';
72 
73   
74 
75     function MangoCoin() {
76         balances[msg.sender] = 12000000000000000;               // Give the creator all initial tokens
77         totalSupply = 12000000000000000;                        // Update total supply
78         name = 'MangoCoin';                                   // Set the name for display purposes
79         decimals = 8;                            // Amount of decimals for display purposes
80         symbol = 'MGO';                               // Set the symbol for display purposes
81     }
82 }