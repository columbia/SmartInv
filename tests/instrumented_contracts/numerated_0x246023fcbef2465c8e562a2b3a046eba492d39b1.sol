1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract Token {
35 
36     function totalSupply() constant returns (uint256 supply) {}
37 
38     function balanceOf(address _owner) constant returns (uint256 balance) {}
39 
40     function transfer(address _to, uint256 _value) returns (bool success) {}
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {}
45 
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50     
51 }
52 
53 
54 
55 contract StandardToken is Token {
56     
57     using SafeMath for uint256;
58 
59     function transfer(address _to, uint256 _value) returns (bool success) {
60         if (balances[msg.sender] >= _value && _value > 0) {
61             balances[msg.sender] -= _value;
62             balances[_to] += _value;
63             Transfer(msg.sender, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
70             balances[_to] += _value;
71             balances[_from] -= _value;
72             allowed[_from][msg.sender] -= _value;
73             Transfer(_from, _to, _value);
74             return true;
75         } else { return false; }
76     }
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 
92     mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94     uint256 public totalSupply;
95 }
96 
97 
98 contract Crypterium is StandardToken {
99 
100     function () {
101         throw;
102     }
103 
104 
105     string public name;                   
106     uint8 public decimals;                
107     string public symbol;                 
108     string public version = 'H1.0';     
109 
110 
111     function Crypterium(
112         ) {
113         balances[msg.sender] = 10000000000000000000000000; 
114         totalSupply = 10000000000000000000000000;  
115         name = "Crypterium";   
116         decimals = 18; 
117         symbol = "CRPT";  
118     }
119 
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123 
124         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
125         return true;
126     }
127 }