1 pragma solidity ^0.4.19;
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
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     owner = newOwner;
47     OwnershipTransferred(owner, newOwner);
48   }
49 }
50 
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   function balanceOf(address _owner) public view returns (uint256 balance) {
83     return balances[_owner];
84   }
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[_from]);
94     require(_value <= allowed[_from][msg.sender]);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99     Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   function allowance(address _owner, address _spender) public view returns (uint256) {
110     return allowed[_owner][_spender];
111   }
112 
113   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
114     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
115     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118 
119   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
120     uint oldValue = allowed[msg.sender][_spender];
121     if (_subtractedValue > oldValue) {
122       allowed[msg.sender][_spender] = 0;
123     } else {
124       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
125     }
126     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }
129 }
130 
131 contract MintableToken is StandardToken, Ownable {
132   event Mint(address indexed to, uint256 amount);
133   event MintFinished();
134 
135   bool public mintingFinished = false;
136   address public airdropper;
137   
138   function MintableToken() public {
139     airdropper = msg.sender;
140   }
141 
142   modifier canMint() {
143     require(!mintingFinished);
144     _;
145   }
146     
147   modifier onlyAirdropper() {
148     require(msg.sender == airdropper);
149     _;
150   }
151 
152   function mint(address _to, uint256 _amount) onlyAirdropper canMint public returns (bool) {
153     totalSupply = totalSupply.add(_amount);
154     balances[_to] = balances[_to].add(_amount);
155     Mint(_to, _amount);
156     Transfer(address(0), _to, _amount);
157     return true;
158   }
159 
160   function finishMinting() onlyOwner canMint public returns (bool) {
161     mintingFinished = true;
162     MintFinished();
163     return true;
164   }
165   
166   function setAirdropper(address _airdropper) public onlyOwner {
167       require(_airdropper != address(0));
168       airdropper = _airdropper;
169   }
170 }
171 
172 contract TokenDestructible is Ownable {
173   function TokenDestructible() public payable { }
174 
175   function destroy(address[] tokens) onlyOwner public {
176     for(uint256 i = 0; i < tokens.length; i++) {
177       ERC20Basic token = ERC20Basic(tokens[i]);
178       uint256 balance = token.balanceOf(this);
179       token.transfer(owner, balance);
180     }
181 
182     selfdestruct(owner);
183   }
184 }
185 
186 contract JesusCoin is MintableToken, TokenDestructible {
187   string public constant name = "Jesus Coin";
188   uint8  public constant decimals = 18;
189   string public constant symbol = "JC";
190   
191   function JesusCoin() public payable { }
192 }