1 pragma solidity ^0.4.18;
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
29 contract Ownable {
30   address public owner;
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33   function Ownable() public {
34     owner = msg.sender;
35   }
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public view returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   uint256 totalSupply_;
70 
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return balances[_owner];
88   }
89 }
90 
91 contract BurnableToken is BasicToken {
92 
93   event Burn(address indexed burner, uint256 value);
94 
95   function burn(uint256 _value) public {
96     require(_value <= balances[msg.sender]);
97     // no need to require value <= totalSupply, since that would imply the
98     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
99 
100     address burner = msg.sender;
101     balances[burner] = balances[burner].sub(_value);
102     totalSupply_ = totalSupply_.sub(_value);
103     Burn(burner, _value);
104     Transfer(burner, address(0), _value);
105   }
106 }
107 
108 contract StandardToken is ERC20, BasicToken {
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   function allowance(address _owner, address _spender) public view returns (uint256) {
130     return allowed[_owner][_spender];
131   }
132 
133   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
134     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
140     uint oldValue = allowed[msg.sender][_spender];
141     if (_subtractedValue > oldValue) {
142       allowed[msg.sender][_spender] = 0;
143     } else {
144       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145     }
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 }
150 
151 contract MintableToken is StandardToken, Ownable {
152   event Mint(address indexed to, uint256 amount);
153   event MintFinished();
154 
155   bool public mintingFinished = false;
156 
157   modifier canMint() {
158     require(!mintingFinished);
159     _;
160   }
161 
162   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
163     totalSupply_ = totalSupply_.add(_amount);
164     balances[_to] = balances[_to].add(_amount);
165     Mint(_to, _amount);
166     Transfer(address(0), _to, _amount);
167     return true;
168   }
169 
170   function finishMinting() onlyOwner canMint public returns (bool) {
171     mintingFinished = true;
172     MintFinished();
173     return true;
174   }
175 }
176 
177 contract HivewayToken is StandardToken, BurnableToken, MintableToken {
178 
179     string public constant name = "Hiveway";
180     string public constant symbol = "WAY";
181     uint8 public constant decimals = 18;
182 
183     function getTotalSupply() public returns (uint256) {
184         return totalSupply_;
185     }
186 	
187 	function initialize() onlyOwner public {
188 		mint(msg.sender, 400 * 10**6 * 10**18);
189 		finishMinting();
190 	}
191 }