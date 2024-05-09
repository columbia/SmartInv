1 pragma solidity ^0.4.11;
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
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value) returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47 
48   function transfer(address _to, uint256 _value) returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55 
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) returns (bool);
66   function approve(address spender, uint256 value) returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
78     var _allowance = allowed[_from][msg.sender];
79 
80     
81     balances[_to] = balances[_to].add(_value);
82     balances[_from] = balances[_from].sub(_value);
83     allowed[_from][msg.sender] = _allowance.sub(_value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88  
89   function approve(address _spender, uint256 _value) returns (bool) {
90 
91     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
92 
93     allowed[msg.sender][_spender] = _value;
94     Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99     return allowed[_owner][_spender];
100   }
101 
102 }
103 
104 
105 contract LegalBot is StandardToken {
106 
107   string public constant name = "LegalBot";
108   string public constant symbol = "LBOT";
109   uint256 public constant decimals = 18;
110   address public owner;
111   
112 
113   uint256 public constant INITIAL_SUPPLY = 10000000000000000000000000000;
114 
115   
116   function LegalBot() {
117     totalSupply = INITIAL_SUPPLY;
118     balances[msg.sender] = INITIAL_SUPPLY;
119     owner = msg.sender;
120   }
121   
122 
123   function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {
124         for (uint256 i = 0; i < _addresses.length; i++) {
125             token.transfer(_addresses[i], amount);
126         }
127     }
128  
129  modifier onlyOwner() {
130         assert(msg.sender == owner);
131         _;
132     }
133   function transferOwnership(address newOwner) external onlyOwner {
134         if (newOwner != address(0)) {
135             owner = newOwner;
136         }
137     }
138  
139 }