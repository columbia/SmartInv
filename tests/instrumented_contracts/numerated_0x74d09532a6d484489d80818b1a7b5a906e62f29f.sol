1 pragma solidity 0.4.19;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint supply) {}
6     function balanceOf(address _owner) constant returns (uint balance) {}
7     function transfer(address _to, uint _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
9     function approve(address _spender, uint _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint _value);
13     event Approval(address indexed _owner, address indexed _spender, uint _value);
14 }
15 
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint _value) returns (bool) {
19         //Default assumes totalSupply can't be over max (2^256 - 1).
20         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
21             balances[msg.sender] -= _value;
22             balances[_to] += _value;
23             Transfer(msg.sender, _to, _value);
24             return true;
25         } else { return false; }
26     }
27 
28     function transferFrom(address _from, address _to, uint _value) returns (bool) {
29         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
30             balances[_to] += _value;
31             balances[_from] -= _value;
32             allowed[_from][msg.sender] -= _value;
33             Transfer(_from, _to, _value);
34             return true;
35         } else { return false; }
36     }
37 
38     function balanceOf(address _owner) constant returns (uint) {
39         return balances[_owner];
40     }
41 
42     function approve(address _spender, uint _value) returns (bool) {
43         allowed[msg.sender][_spender] = _value;
44         Approval(msg.sender, _spender, _value);
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) constant returns (uint) {
49         return allowed[_owner][_spender];
50     }
51 
52     mapping (address => uint) balances;
53     mapping (address => mapping (address => uint)) allowed;
54     uint public totalSupply;
55 }
56 
57 contract SaftToken is StandardToken {
58 
59     uint8 constant public decimals = 18;
60     uint public totalSupply = 10**27; // 1 billion tokens, 18 decimal places
61     string constant public name = "Simple agreement for future tokens ";
62     string constant public symbol = "SAFT";
63 
64     function SaftToken() {
65         balances[msg.sender] = totalSupply;
66         Transfer(0x0, msg.sender, totalSupply);
67     }
68 }