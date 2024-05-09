1 pragma solidity ^0.4.11;
2 /// @author Rodrigo Cremer - DEV Bth
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address owner) constant returns (uint256 balance);
6     function transfer(address to, uint256 value) returns (bool success);
7     function transferFrom(address from, address to, uint256 value) returns (bool success);
8     function approve(address spender, uint256 value) returns (bool success);
9     function allowance(address owner, address spender) constant returns (uint256 remaining);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 
16 
17 contract StandardToken is Token {
18 
19     mapping (address => uint256) balances;
20     mapping (address => mapping (address => uint256)) allowed;
21 
22     function transfer(address _to, uint256 _value) returns (bool success) {
23         if (balances[msg.sender] >= _value && _value > 0) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         }
29         else {
30             return false;
31         }
32     }
33 
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
36         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
37             balances[_to] += _value;
38             balances[_from] -= _value;
39             allowed[_from][msg.sender] -= _value;
40             Transfer(_from, _to, _value);
41             return true;
42         }
43         else {
44             return false;
45         }
46     }
47 
48 
49     function balanceOf(address _owner) constant returns (uint256 balance) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint256 _value) returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60       return allowed[_owner][_spender];
61     }
62 
63 }
64 
65 
66 contract BitHaus is StandardToken {
67 
68     string constant public name = "BitHaus";
69     string constant public symbol = "BTH";
70     uint8 constant public decimals = 8;
71 
72 
73     function () {
74 
75         throw;
76     }
77 
78 
79     function BitHaus() {
80         balances[msg.sender] = 10000000000000000;
81         totalSupply = 10000000000000000; //
82     }
83 }