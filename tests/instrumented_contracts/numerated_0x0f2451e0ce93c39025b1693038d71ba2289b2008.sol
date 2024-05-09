1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   function transferOwnership(address newOwner) onlyOwner public {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 }
47 
48 contract SmartToken is Ownable {
49   using SafeMath for uint256;
50 
51   uint256 public totalSupply;
52   mapping(address => uint256) balances;
53   mapping (address => mapping (address => uint256)) allowed;
54   bool public mintingFinished = false;
55 
56   event Transfer(address indexed from, address indexed to, uint256 value);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58   event Burn(address indexed burner, uint256 value);
59   event Mint(address indexed to, uint256 amount);
60   event MintFinished();
61 
62   modifier canMint() {
63     require(!mintingFinished);
64     _;
65   }
66 
67   function balanceOf(address _owner) public constant returns (uint256 balance) {
68     return balances[_owner];
69   }
70 
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     uint256 _allowance = allowed[_from][msg.sender];
82     require(_allowance > 0);
83     require(_allowance >= _value);
84     balances[_from] = balances[_from].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     allowed[_from][msg.sender] = _allowance.sub(_value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
92     return allowed[_owner][_spender];
93   }
94 
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
102     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function burn(uint256 _value) public {
119       require(_value > 0);
120 
121       address burner = msg.sender;
122       balances[burner] = balances[burner].sub(_value);
123       totalSupply = totalSupply.sub(_value);
124       Burn(burner, _value);
125   }
126 
127   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
128     totalSupply = totalSupply.add(_amount);
129     balances[_to] = balances[_to].add(_amount);
130     Mint(_to, _amount);
131     Transfer(0x0, _to, _amount);
132     return true;
133   }
134 
135   function finishMinting() onlyOwner public returns (bool) {
136     mintingFinished = true;
137     MintFinished();
138     return true;
139   }
140 
141 }
142 
143 contract Token is SmartToken {
144 
145   using SafeMath for uint256;
146   string public name = "Ponscoin";
147   string public symbol = "PONS";
148   uint public decimals = 6;
149   uint256 public INITIAL_SUPPLY = 10000000;
150 
151   function Token() {
152     owner = msg.sender;
153     mint(msg.sender, INITIAL_SUPPLY * 1000000);
154   }
155 
156   function transfer(address _to, uint _value) returns (bool success) {
157     return super.transfer(_to, _value);
158   }
159 
160   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161     return super.transferFrom(_from, _to, _value);
162   }
163 
164   function () payable {
165     revert();
166   }
167 
168   function withdraw() onlyOwner {
169     msg.sender.transfer(this.balance);
170   }
171 
172   function withdrawSome(uint _value) onlyOwner {
173     require(_value <= this.balance);
174     msg.sender.transfer(_value);
175   }
176 
177   function killContract(uint256 _value) onlyOwner {
178     require(_value > 0);
179     selfdestruct(owner);
180   }
181 }