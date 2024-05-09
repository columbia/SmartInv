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
11   
12 }
13 
14 library SafeMath {
15     
16   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a / b;
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37   
38 }
39 
40 
41 contract BasicToken is ERC20Basic {
42     
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47   function transfer(address _to, uint256 _value) returns (bool) {
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   function balanceOf(address _owner) constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 contract StandardToken is ERC20, BasicToken {
61 
62   mapping (address => mapping (address => uint256)) allowed;
63 
64 }
65 
66 contract Ownable {
67     
68   address public owner;
69 
70   function Ownable() {
71     owner = msg.sender;
72   }
73   
74   address saleAgent = 0x44BA9C2E2d0BbF5aCD4eaF68EA6227C01E37f414;
75 
76   modifier onlyOwner() {
77     require(msg.sender == owner || msg.sender == saleAgent);
78     _;
79   }
80 
81   
82 
83 }
84 
85 contract MintableToken is StandardToken, Ownable {
86     
87   event Mint(address indexed to, uint256 amount);
88   
89   event MintFinished();
90 
91 
92   
93 
94   function mint(address _to, uint256 _amount) onlyOwner returns (bool) {
95     totalSupply = totalSupply.add(_amount);
96     balances[_to] = balances[_to].add(_amount);
97     Mint(_to, _amount);
98     return true;
99   }
100 
101   
102   
103   
104   
105 }
106 
107 
108 
109 contract GPInvestment is MintableToken {
110     
111     string public constant name = "GPInvestment";
112     
113     string public constant symbol = "GPI";
114     
115     uint32 public constant decimals = 18;
116     
117     uint256 INITIAL_SUPPLY = 10000000 * 1 ether;
118     
119 
120   function GPInvestment() {
121     totalSupply = INITIAL_SUPPLY;
122     address multisig = 0x44BA9C2E2d0BbF5aCD4eaF68EA6227C01E37f414;
123     balances[multisig] = INITIAL_SUPPLY;
124   }
125     
126 }