1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     address public owner;
6 
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function setOwner(address _newOwner) onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a / b;
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 
44   function toUINT112(uint256 a) internal constant returns(uint112) {
45     assert(uint112(a) == a);
46     return uint112(a);
47   }
48 
49   function toUINT120(uint256 a) internal constant returns(uint120) {
50     assert(uint120(a) == a);
51     return uint120(a);
52   }
53 
54   function toUINT128(uint256 a) internal constant returns(uint128) {
55     assert(uint128(a) == a);
56     return uint128(a);
57   }
58 }
59 
60 contract Token {
61     function totalSupply() constant returns (uint256 supply);
62     function balanceOf(address _owner) constant returns (uint256 balance);
63     function transfer(address _to, uint256 _value) returns (bool success);
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
65     function approve(address _spender, uint256 _value) returns (bool success);
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 }
71 
72 contract COOToken is Token, Owned {
73     using SafeMath for uint256;
74 
75     string public constant name    = "Chief Operating Officer Token"; 
76     uint8 public constant decimals = 18;
77     string public constant symbol  = "COO";
78 
79     // The current total token supply.
80     uint256 currentTotalSupply;
81     uint256 limitTotalSupply = 10000000000000000000000000000;        //upper limit Supply
82 
83     mapping (address => uint256) balances;
84 
85     // Owner of account approves the transfer of an amount to another account
86     mapping(address => mapping(address => uint256)) allowed;
87     
88     event Aditional(address indexed _owner,uint256 _value);
89 
90     function COOToken(uint256 _initialAmount) {
91         if(_initialAmount > limitTotalSupply) throw;
92         balances[msg.sender] = _initialAmount;
93         currentTotalSupply = _initialAmount;
94     }
95 
96     function totalSupply() constant returns (uint256 supply){
97         return currentTotalSupply;
98     }
99     
100     function limitSupply() constant returns (uint256 supply){
101         return limitTotalSupply;
102     }
103 
104     function () {
105         revert();
106     }
107 
108     function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function transfer(address _to, uint256 _amount) returns (bool success) {
113         require(_to != address(0));
114         require(_amount <= balances[msg.sender]);
115     
116         balances[msg.sender] = balances[msg.sender].sub(_amount);
117         balances[_to] = balances[_to].add(_amount);
118         
119         Transfer(msg.sender, _to, _amount);
120         return true;
121     }
122 
123     function transferFrom(address _from,address _to,uint256 _value) returns (bool success) {
124         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
125         balances[_to] = balances[_to].add(_value);
126         balances[_from] = balances[_from].sub(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     function approve(address _spender, uint256 _amount) returns (bool success) {
133         allowed[msg.sender][_spender] = _amount;
134         Approval(msg.sender, _spender, _amount);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139         return allowed[_owner][_spender];
140     }
141 
142     function additional(uint256 _amount) public onlyOwner{
143         require(currentTotalSupply.add(_amount) <= limitTotalSupply);
144         currentTotalSupply = currentTotalSupply.add(_amount);
145         balances[msg.sender] = balances[msg.sender].add(_amount);
146         Aditional(msg.sender, _amount);
147     }
148 }