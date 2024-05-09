1 pragma solidity ^0.4.25;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 contract ERC20 {
27   uint public totalSupply;
28   function balanceOf(address who) constant returns (uint);
29   function allowance(address owner, address spender) constant returns (uint);
30 
31   function transfer(address to, uint value) returns (bool ok);
32   function transferFrom(address from, address to, uint value) returns (bool ok);
33   function approve(address spender, uint value) returns (bool ok);
34   event Transfer(address indexed from, address indexed to, uint value);
35   event Approval(address indexed owner, address indexed spender, uint value);
36 }
37 
38 contract StandardToken is ERC20, SafeMath {
39   mapping (address => uint) balances;
40   mapping (address => mapping (address => uint)) allowed;
41 
42   function transfer(address _to, uint _value) returns (bool success) {
43     // This test is implied by safeSub()
44     // if (balances[msg.sender] < _value) { throw; }
45     balances[msg.sender] = safeSub(balances[msg.sender], _value);
46     balances[_to] = safeAdd(balances[_to], _value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
52     var _allowance = allowed[_from][msg.sender];
53 
54     // These tests are implied by safeSub()
55     // if (balances[_from] < _value) { throw; }
56     // if (_allowance < _value) { throw; }
57     balances[_to] = safeAdd(balances[_to], _value);
58     balances[_from] = safeSub(balances[_from], _value);
59     allowed[_from][msg.sender] = safeSub(_allowance, _value);
60     Transfer(_from, _to, _value);
61     return true;
62   }
63 
64   function balanceOf(address _owner) constant returns (uint balance) {
65     return balances[_owner];
66   }
67 
68   function approve(address _spender, uint _value) returns (bool success) {
69     allowed[msg.sender][_spender] = _value;
70     Approval(msg.sender, _spender, _value);
71     return true;
72   }
73 
74   function allowance(address _owner, address _spender) constant returns (uint remaining) {
75     return allowed[_owner][_spender];
76   }
77 }
78 
79 contract Bitray is StandardToken {
80     /*
81     NOTE:
82     The following variables are OPTIONAL vanities. One does not have to include them.
83     They allow one to customise the token contract & in no way influences the core functionality.
84     Some wallets/interfaces might not even bother to look at this information.
85     */
86     string public name = "Bitray";   
87     string public symbol = "BTY"; 
88     uint public decimals = 8;
89 
90     uint public totalSupply = 10000000000000000000;
91  
92 
93     function BTY() {
94         balances[msg.sender] = totalSupply;
95         Transfer(address(0), msg.sender, totalSupply);
96     }
97     // do not allow deposits
98     function() {
99         throw;
100     }
101 }