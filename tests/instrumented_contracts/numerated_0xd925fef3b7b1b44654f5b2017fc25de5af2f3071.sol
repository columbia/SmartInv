1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) constant returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) returns (bool success);
9 
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11 
12     function approve(address _spender, uint256 _value) returns (bool success);
13 
14     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 
21 contract StandardToken is Token {
22 
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         if (balances[msg.sender] >= _value && _value > 0) {
25             balances[msg.sender] -= _value;
26             balances[_to] += _value;
27             Transfer(msg.sender, _to, _value);
28             return true;
29         } else { return false; }
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
33         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function balanceOf(address _owner) constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value) returns (bool success) {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
53       return allowed[_owner][_spender];
54     }
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58 }
59 
60 contract JAVACoin is StandardToken {
61 
62     function () {
63         throw;
64     }
65 
66     string public name;
67     uint8 public decimals;
68     string public symbol;
69     string public version = '1.0';
70 
71   
72 
73     function JAVACoin() {
74         balances[msg.sender] = 12000000000000000;               // Give the creator all initial tokens
75         totalSupply = 12000000000000000;                        // Update total supply
76         name = 'JAVA Coin';                                   // Set the name for display purposes
77         decimals = 6;                            // Amount of decimals for display purposes
78         symbol = 'JAVA';                               // Set the symbol for display purposes
79     }
80 }