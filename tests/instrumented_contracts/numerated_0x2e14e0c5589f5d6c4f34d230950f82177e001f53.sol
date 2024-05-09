1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) returns (bool);
39   function approve(address spender, uint256 value) returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   function transfer(address _to, uint256 _value) returns (bool) {
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   function balanceOf(address _owner) constant returns (uint256 balance) {
56     return balances[_owner];
57   }
58 }
59 
60 contract StandardToken is ERC20, BasicToken {
61 
62   mapping (address => mapping (address => uint256)) allowed;
63 
64   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
65     var _allowance = allowed[_from][msg.sender];
66 
67     balances[_from] = balances[_from].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     allowed[_from][msg.sender] = _allowance.sub(_value);
70     Transfer(_from, _to, _value);
71     return true;
72   }
73 
74   function approve(address _spender, uint256 _value) returns (bool) {
75 
76     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
77 
78     allowed[msg.sender][_spender] = _value;
79     Approval(msg.sender, _spender, _value);
80     return true;
81   }
82 
83   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84     return allowed[_owner][_spender];
85   }
86 
87   function increaseApproval (address _spender, uint _addedValue)
88     returns (bool success) {
89     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
90     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
91     return true;
92   }
93 
94   function decreaseApproval (address _spender, uint _subtractedValue)
95     returns (bool success) {
96     uint oldValue = allowed[msg.sender][_spender];
97     if (_subtractedValue > oldValue) {
98       allowed[msg.sender][_spender] = 0;
99     } else {
100       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
101     }
102     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     return true;
104   }
105 }
106 
107 contract Ownable {
108   address public owner;
109 
110   function Ownable() {
111     owner = msg.sender;
112   }
113 
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   function transferOwnership(address newOwner) onlyOwner {
120     require(newOwner != address(0));
121     owner = newOwner;
122   }
123 }
124 
125 contract MintableToken is StandardToken, Ownable {
126   event Mint(address indexed to, uint256 amount);
127   event MintFinished();
128 
129   bool public mintingFinished = false;
130 
131   modifier canMint() {
132     require(!mintingFinished);
133     _;
134   }
135 
136   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
137     totalSupply = totalSupply.add(_amount);
138     balances[_to] = balances[_to].add(_amount);
139     Mint(_to, _amount);
140     Transfer(0x0, _to, _amount);
141     return true;
142   }
143 
144   function finishMinting() onlyOwner returns (bool) {
145     mintingFinished = true;
146     MintFinished();
147     return true;
148   }
149 }
150 
151 contract SSAToken is MintableToken {
152   string public name = "SSA";
153   string public symbol = "SSA";
154   uint8 public decimals = 6;
155 
156   function SSAToken() {
157       totalSupply = 10000000;
158       balances[msg.sender] = totalSupply;
159   }
160 
161   event Burn(address indexed burner, uint indexed value);
162 
163   function burn(uint _value) onlyOwner {
164     require(_value > 0);
165 
166     address burner = msg.sender;
167     balances[burner] = balances[burner].sub(_value);
168     totalSupply = totalSupply.sub(_value);
169     Burn(burner, _value);
170   }
171 }