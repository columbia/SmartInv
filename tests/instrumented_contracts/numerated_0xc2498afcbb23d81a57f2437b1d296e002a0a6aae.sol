1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34 
35   address public owner;
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   function Ownable() public {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 
56 contract ERC20 is Ownable {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 
66 }
67 
68 contract GeoGems is ERC20 {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73     string public name;
74     string public symbol;
75     uint8 public decimals;
76     uint256 totalSupply_;
77     address public vaultAddress;
78 
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   function GeoGems(address _vaultAddress) public {
84         name = "Geo Gems";
85         symbol = "GG";
86         decimals = 2;
87         totalSupply_ = 5000000000000 * (10 ** uint256(decimals));
88         vaultAddress = _vaultAddress; 
89         balances[_vaultAddress] = totalSupply_;
90  
91         emit Transfer(0x0, _vaultAddress, totalSupply_);
92         
93   }
94     
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(0x0 != msg.sender);
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     // SafeMath.sub will throw if there is not enough balance.
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106   
107     
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(0x0 != msg.sender);
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     emit Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   function approve(address _spender, uint256 _value)  public returns (bool) {
128     require(_spender != address(0));
129     require(0x0 != msg.sender);
130     allowed[msg.sender][_spender] = _value;
131     emit Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135 
136   function allowance(address _owner, address _spender) public view returns (uint256) {
137     return allowed[_owner][_spender];
138   }
139 
140   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
141     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
147     uint oldValue = allowed[msg.sender][_spender];
148     if (_subtractedValue > oldValue) {
149       allowed[msg.sender][_spender] = 0;
150     } else {
151       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152     }
153     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   event Mint(address indexed to, uint256 amount);
158   event MintFinished();
159 
160   bool public mintingFinished = false;
161 
162 
163   modifier canMint() {
164     require(!mintingFinished);
165     _;
166   }
167 
168   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
169     //assert(totalSupply_.add(_amount) <= 10000000000000 * (10 ** uint256(decimals)));
170     totalSupply_ = totalSupply_.add(_amount);
171     balances[_to] = balances[_to].add(_amount);
172     emit Mint(_to, _amount);
173     emit Transfer(address(0), _to, _amount);
174     return true;
175   }
176   event NameChangedTo (string value);
177   event SymbolChangedTo (string value);
178   
179   function setName(string _name) onlyOwner public {
180         name = _name;
181         emit NameChangedTo(_name);
182     }
183     
184   function setSymbol(string _symbol) onlyOwner public {
185         symbol = _symbol;
186         emit SymbolChangedTo(_symbol);
187     }
188 
189 
190   function finishMinting() onlyOwner canMint public returns (bool) {
191     mintingFinished = true;
192     emit MintFinished();
193     return true;
194   }
195 
196 }