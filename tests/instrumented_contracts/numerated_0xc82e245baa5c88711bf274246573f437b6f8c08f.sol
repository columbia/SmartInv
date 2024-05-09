1 pragma solidity ^0.4.16;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     
19   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40   
41 }
42 
43 contract BasicToken is ERC20Basic {
44     
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   function transfer(address _to, uint256 _value) returns (bool) {
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 contract StandardToken is ERC20, BasicToken {
63 
64   mapping (address => mapping (address => uint256)) allowed;
65 
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
67     var _allowance = allowed[_from][msg.sender];
68 
69     balances[_to] = balances[_to].add(_value);
70     balances[_from] = balances[_from].sub(_value);
71     allowed[_from][msg.sender] = _allowance.sub(_value);
72     Transfer(_from, _to, _value);
73     return true;
74   }
75 
76   function approve(address _spender, uint256 _value) returns (bool) {
77 
78     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79 
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84 
85   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 
89 }
90 
91 contract Ownable {
92     
93   address public owner;
94 
95   function Ownable() {
96     owner = msg.sender;
97   }
98 
99   modifier onlyOwner() {
100     require(msg.sender == owner);
101     _;
102   }
103 
104   function transferOwnership(address newOwner) onlyOwner {
105     require(newOwner != address(0));      
106     owner = newOwner;
107   }
108 
109 }
110 
111 contract BurnableToken is StandardToken {
112 
113   function burn(uint _value) public {
114     require(_value > 0);
115     address burner = msg.sender;
116     balances[burner] = balances[burner].sub(_value);
117     totalSupply = totalSupply.sub(_value);
118     Burn(burner, _value);
119   }
120 
121   event Burn(address indexed burner, uint indexed value);
122 
123 }
124 
125 
126 contract TonexToken is BurnableToken {
127     
128   string public constant name = "TONex";
129   string public constant symbol = "TNX";
130   uint32 public constant decimals = 8;
131   uint256 public INITIAL_SUPPLY = 5000000000000000;
132 
133   function TonexToken() {
134     totalSupply = INITIAL_SUPPLY;
135     balances[msg.sender] = INITIAL_SUPPLY;
136   }
137     
138 }