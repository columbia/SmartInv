1 pragma solidity ^0.4.21;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16  
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   
23   function transferOwnership(address newOwner) public onlyOwner {
24     require(newOwner != address(0));
25     emit OwnershipTransferred(owner, newOwner);
26     owner = newOwner;
27   }
28 
29 }
30 
31 
32 library SafeMath {
33 
34   
35 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36 		if (a == 0) {
37 		  return 0;
38 		}
39 		c = a * b;
40 		assert(c / a == b);
41 		return c;
42 	}
43 
44 
45 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
46 	// assert(b > 0); // Solidity automatically throws when dividing by 0
47 	// uint256 c = a / b;
48 	// assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 	return a / b;
50 	}
51 
52 
53 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54 	assert(b <= a);
55 	return a - b;
56 	}
57 
58 
59 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60 	c = a + b;
61 	assert(c >= a);
62 	return c;
63 	}
64 }
65 
66 
67 contract ERC20Basic {
68   function totalSupply() public view returns (uint256);
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 
75 
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 
116 contract StandardToken is ERC20, BasicToken {
117 
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120 
121   
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     emit Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   
142   function allowance(address _owner, address _spender) public view returns (uint256) {
143     return allowed[_owner][_spender];
144   }
145 
146   
147   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
148     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
149     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153  
154   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
155     uint oldValue = allowed[msg.sender][_spender];
156     if (_subtractedValue > oldValue) {
157       allowed[msg.sender][_spender] = 0;
158     } else {
159       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
160     }
161     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165 }
166 
167 
168 contract DMDPangea is StandardToken, Ownable {
169 
170   string public constant name ="DMD Pangea Token"; 
171   string public constant symbol ="DMPNG"; 
172   uint8 public constant decimals = 18;
173 
174   uint256 public constant INITIAL_SUPPLY = 50000 * (10 ** uint256(decimals));
175 
176   /**
177    * @dev Constructor that gives msg.sender all of existing tokens.
178    */
179   function DMDPangea() public {
180     totalSupply_ = INITIAL_SUPPLY;
181     balances[msg.sender] = INITIAL_SUPPLY;
182     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
183   }
184 
185 }