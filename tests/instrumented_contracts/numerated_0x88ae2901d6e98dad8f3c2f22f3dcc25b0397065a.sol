1 pragma solidity ^0.4.18;
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
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   function Ownable() public {
35     owner = msg.sender;
36   }
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 contract ERC20Basic {
50   uint256 public totalSupply;
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     emit Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   function balanceOf(address _owner) public view returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 contract StandardToken is ERC20, BasicToken {
86 
87   mapping (address => mapping (address => uint256)) internal allowed;
88 
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     emit Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   function approve(address _spender, uint256 _value) public returns (bool) {
102     allowed[msg.sender][_spender] = _value;
103     emit Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   function allowance(address _owner, address _spender) public view returns (uint256) {
108     return allowed[_owner][_spender];
109   }
110 
111   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
112     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
118     uint oldValue = allowed[msg.sender][_spender];
119     if (_subtractedValue > oldValue) {
120       allowed[msg.sender][_spender] = 0;
121     } else {
122       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123     }
124     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128 }
129 
130 contract TokenContract is Ownable, StandardToken {
131     string public constant name = "MTE Token";
132     string public constant symbol = "MTE";
133     uint8 public constant decimals = 18;
134     uint256 public constant INITIAL_SUPPLY = 80000000 * (10 ** uint256(decimals));
135 
136     function TokenContract(address _mainWallet) public {
137     address mainWallet = _mainWallet;
138     uint256 tokensForWallet = 18400000 * (10 ** uint256(decimals));
139     uint256 tokensForICO = INITIAL_SUPPLY - tokensForWallet;
140     totalSupply = INITIAL_SUPPLY;
141     balances[mainWallet] = tokensForWallet;
142     balances[msg.sender] = tokensForICO;
143     emit Transfer(0x0, mainWallet, tokensForWallet);
144     emit Transfer(0x0, msg.sender, tokensForICO);
145   }
146 
147     function transfer(address _to, uint256 _value) public returns (bool) {
148         return super.transfer(_to, _value);
149     }
150 
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152         return super.transferFrom(_from, _to, _value);
153     }
154 
155     function approve(address _spender, uint256 _value) public returns (bool) {
156         return super.approve(_spender, _value);
157     }
158 
159     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
160         return super.increaseApproval(_spender, _addedValue);
161     }
162 
163     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
164         return super.decreaseApproval(_spender, _subtractedValue);
165     }
166 
167     function burn(uint256 _amount) public {
168         require(balances[msg.sender] >= _amount);
169         balances[msg.sender] = balances[msg.sender].sub(_amount);
170         totalSupply = totalSupply.sub(_amount);
171         emit Burn(msg.sender, _amount);
172     }
173 
174     event Burn(address indexed from, uint256 amount);
175 }