1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     // uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   uint256 totalSupply_;
53 
54   function totalSupply() public view returns (uint256) {
55     return totalSupply_;
56   }
57 
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61 
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     emit Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   function balanceOf(address _owner) public view returns (uint256) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) internal allowed;
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     emit Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
92     allowed[msg.sender][_spender] = _value;
93     emit Approval(msg.sender, _spender, _value);
94     return true;
95   }
96 
97   function allowance(address _owner, address _spender) public view returns (uint256) {
98     return allowed[_owner][_spender];
99   }
100 
101   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108     uint oldValue = allowed[msg.sender][_spender];
109     if (_subtractedValue > oldValue) {
110       allowed[msg.sender][_spender] = 0;
111     } else {
112       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113     }
114     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118 }
119 
120 contract SENbitGlobalToken is StandardToken {
121 
122   string public name = "SENbit Global Token";
123   string public symbol = "SGT";
124   uint8 public decimals = 8;
125   uint256 public INITIAL_SUPPLY = 400000000*10**8;
126 
127   address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
128 
129   address public owner;
130 
131   address public croupier;
132 
133   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
134   event Transfer(address indexed from, address indexed to, uint256 value);
135   event Burn(address indexed _target, uint256 _value);
136 
137   constructor() public {
138     totalSupply_ = INITIAL_SUPPLY;
139     balances[msg.sender] = INITIAL_SUPPLY;
140     owner = msg.sender; 
141     croupier = DUMMY_ADDRESS;
142   }
143 
144     modifier onlyOwner {
145         require(msg.sender == owner, "onlyOwner method called by non-owner.");
146         _;
147     }
148 
149     modifier onlyCroupier {
150         require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
151         _;
152     }
153 
154     function setCroupier(address newCroupier) external onlyOwner {
155         croupier = newCroupier;
156     }
157 
158   function transfer(address _target, uint256 _amount) public returns (bool) {
159     require(_target != address(0));
160     require(balances[msg.sender] >= _amount);
161     balances[_target] = balances[_target].add(_amount);
162     balances[msg.sender] = balances[msg.sender].sub(_amount);
163 
164     emit Transfer(msg.sender, _target, _amount);
165 
166     return true;
167   }
168 
169 
170   function burn(address _target, uint256 _amount) external onlyCroupier returns (bool) {
171         require(_target != address(0));
172         require(_amount > 0);
173         balances[_target] = balances[_target].sub(_amount);
174         totalSupply_ = totalSupply_.sub(_amount);
175         INITIAL_SUPPLY = totalSupply_;
176         emit Burn(_target, _amount);
177         return true;
178     }
179 
180 }