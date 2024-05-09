1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Token {
33 
34     function totalSupply() constant returns (uint supply) {}
35 
36     function balanceOf(address _owner) constant returns (uint balance) {}
37 
38     function transfer(address _to, uint _value) returns (bool success) {}
39 
40     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
41 
42     function approve(address _spender, uint _value) returns (bool success) {}
43 
44     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
45 
46     event Transfer(address indexed _from, address indexed _to, uint _value);
47     event Approval(address indexed _owner, address indexed _spender, uint _value);
48 }
49 
50 contract StandardToken is Token {
51     using SafeMath for uint256;
52     
53     function transfer(address _to, uint256 _value) returns (bool) {
54         require(_to != address(0));
55         require(_value <= balances[msg.sender]);
56         
57         balances[msg.sender] = balances[msg.sender].sub(_value);
58         balances[_to] = balances[_to].add(_value);
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
64         require(_to != address(0));
65         require(_value <= balances[_from]);
66         require(_value <= allowed[_from][msg.sender]);
67 
68         balances[_from] = balances[_from].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
71         Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256) {
86         return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91     uint256 public totalSupply;
92 }
93 
94 
95 
96 contract CGCGToken is StandardToken {
97 
98     uint8 constant public decimals = 10;
99     uint public totalSupply = 3 * (10**19); // 3 billion tokens, 10 decimal places
100     string constant public name = "CHANGE GROW CHANCE GAME";
101     string constant public symbol = "CGCG";
102 
103     function CGCGToken() {
104         balances[msg.sender] = totalSupply;
105     }
106 }