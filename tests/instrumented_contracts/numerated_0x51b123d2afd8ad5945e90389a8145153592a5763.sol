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
104 contract BurnableToken is StandardToken {
105 
106     event Burn(address indexed burner, uint256 value);
107 
108     /**
109      * @dev Burns a specific amount of tokens.
110      * @param _value The amount of token to be burned.
111      */
112     function burn(uint256 _value) public {
113         require(_value > 0);
114 
115         address burner = msg.sender;
116         balances[burner] = balances[burner].sub(_value);
117         totalSupply = totalSupply.sub(_value);
118         Burn(burner, _value);
119     }
120 }
121 
122 
123 contract DALC is StandardToken,BurnableToken {
124 
125   string public constant name = "DALECOIN";
126   string public constant symbol = "DALC";
127   uint256 public constant decimals = 8;
128   address public owner;
129   
130 
131   uint256 public constant INITIAL_SUPPLY = 100000000000000;
132 
133   
134   
135   function DALC() {
136     totalSupply = INITIAL_SUPPLY;
137     owner = 0x5f558906aec7b38bebba0f67878957c53ed0e0a3;
138     balances[owner] = INITIAL_SUPPLY;
139   }
140   
141   
142  
143   
144 
145   function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {
146         for (uint256 i = 0; i < _addresses.length; i++) {
147             token.transfer(_addresses[i], amount);
148         }
149     }
150  
151  modifier onlyOwner() {
152         assert(msg.sender == owner);
153         _;
154     }
155   function transferOwnership(address newOwner) external onlyOwner {
156         if (newOwner != address(0)) {
157             owner = newOwner;
158         }
159     }
160  
161 }