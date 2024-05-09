1 pragma solidity ^0.4.13;
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
68     balances[_to] = balances[_to].add(_value);
69     balances[_from] = balances[_from].sub(_value);
70     allowed[_from][msg.sender] = _allowance.sub(_value);
71     Transfer(_from, _to, _value);
72     return true;
73   }
74 
75   function approve(address _spender, uint256 _value) returns (bool) {
76 
77     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
78 
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85     return allowed[_owner][_spender];
86   }
87 
88 }
89 
90 contract PI is StandardToken {
91     
92   string public constant name = "PI";
93    
94   string public constant symbol = "PI";
95     
96   uint32 public constant decimals = 18;
97 
98   uint256 Total_Supply = 3141592653589793238;
99   
100   address First_Owner = 0xe90fFFd34aEcFE44db61a6efD85663296094A09c;
101 
102   function PI() {
103     totalSupply = Total_Supply;
104     balances[First_Owner] = Total_Supply;
105   }
106 }