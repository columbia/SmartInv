1 pragma solidity ^0.4.8;
2 
3 
4 contract Token {
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12 
13     function approve(address _spender, uint256 _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59 }
60 
61 contract IQB is StandardToken {
62 
63     function () {
64         throw;
65     }
66 
67     string public name;
68     uint8 public decimals;
69     string public symbol;
70     string public version = '1.0';
71 
72     function IQB() {
73         balances[msg.sender] = 18000000000000000;        // Give the creator all initial tokens
74         totalSupply = 18000000000000000;                 // Update total supply
75         name = 'IQB Coin';                               // Set the name for display purposes
76         decimals = 8;                                    // Amount of decimals for display purposes
77         symbol = 'IQB';                                  // Set the symbol for display purposes
78     }
79 }