1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4 
5    function safeMul(uint a, uint b) pure internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) pure internal returns (uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) pure internal returns (uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 
22 }
23 
24 contract Token {
25 
26     uint256 public totalSupply;
27     function balanceOf(address _owner) public constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) public returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30     function approve(address _spender, uint256 _value) public returns (bool success);
31     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35 }
36 
37 contract StandardToken is Token {
38 
39     function transfer(address _to, uint256 _value) public returns (bool success) {
40       if (balances[msg.sender] >= _value && _value > 0) {
41         balances[msg.sender] -= _value;
42         balances[_to] += _value;
43         Transfer(msg.sender, _to, _value);
44         return true;
45       } else {
46         return false;
47       }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52         balances[_to] += _value;
53         balances[_from] -= _value;
54         allowed[_from][msg.sender] -= _value;
55         Transfer(_from, _to, _value);
56         return true;
57       } else {
58         return false;
59       }
60     }
61 
62     function balanceOf(address _owner) public constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) public returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 
79 }
80 
81 contract DataKnowYourCustomer is StandardToken, SafeMath {
82 
83 
84 
85     string public constant name = "DataKnowYourCustomer";
86     string public constant symbol = "DKYC";
87     uint256 public constant decimals = 18;
88     uint256 public totalSupply = 10000000000 * 10**decimals;
89     string public version = "1.0";
90 
91     address public etherProceedsAccount;
92 
93     uint256 public constant CAP =  100000000000 * 10**decimals;
94 
95     // constructor
96     function DataKnowYourCustomer(address _etherProceedsAccount)  {
97       etherProceedsAccount = _etherProceedsAccount;
98       balances[etherProceedsAccount] += CAP;
99       Transfer(this, etherProceedsAccount, CAP);
100     }
101 
102     function () payable public {
103       require(msg.value == 0);
104     }
105 
106 }