1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) constant returns (uint256);
7   function transfer(address to, uint256 value) returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 contract ERC20 is ERC20Basic {
13   function allowance(address owner, address spender) constant returns (uint256);
14   function transferFrom(address from, address to, uint256 value) returns (bool);
15   function approve(address spender, uint256 value) returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 library SafeMath {
21     
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45   
46 }
47 
48 contract BasicToken is ERC20Basic {
49     
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   function transfer(address _to, uint256 _value) returns (bool) {
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   
62   function balanceOf(address _owner) constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66 }
67 
68 contract StandardToken is ERC20, BasicToken {
69 
70   mapping (address => mapping (address => uint256)) allowed;
71 
72   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
73     var _allowance = allowed[_from][msg.sender];
74     balances[_to] = balances[_to].add(_value);
75     balances[_from] = balances[_from].sub(_value);
76     allowed[_from][msg.sender] = _allowance.sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   
82   function approve(address _spender, uint256 _value) returns (bool) {
83     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
84     allowed[msg.sender][_spender] = _value;
85     Approval(msg.sender, _spender, _value);
86     return true;
87   }
88 
89   
90   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91     return allowed[_owner][_spender];
92   }
93 
94 }
95 
96 contract Ownable {
97     
98   address public owner;
99  
100   
101   function Ownable() {
102     owner = msg.sender;
103   }
104  
105   
106   modifier onlyOwner() {
107     require(msg.sender == owner);
108     _;
109   }
110  
111   
112   
113  
114 }
115 contract SatoshiTeamToken is StandardToken, Ownable {
116   string public constant name = "SATOSHI.TEAM";
117    
118   string public constant symbol = "STH";
119   uint32 public constant decimals = 18;
120 
121   uint256 public INITIAL_SUPPLY = 21000000 * 1 ether;
122   address mainAdd = address (this);
123   function SatoshiTeamToken() {
124     totalSupply = INITIAL_SUPPLY;
125     balances[mainAdd] = INITIAL_SUPPLY;
126   }
127   
128 
129   
130   function transferTokens(address _to, uint256 _value) public onlyOwner returns (bool) {
131     balances[mainAdd] = balances[mainAdd].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(mainAdd, _to, _value);
134     return true;
135   }
136    
137    
138    function distributeToken(address[] addresses, uint256 _value) onlyOwner{
139      for (uint i = 0; i < addresses.length; i++) {
140          balances[mainAdd] -= _value * (10 ** 18 );
141          balances[addresses[i]] += _value * (10 ** 18 );
142          Transfer(mainAdd, addresses[i], (_value* (10 ** 18 )));
143          
144      }
145     }
146 
147     
148     
149 }