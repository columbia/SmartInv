1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title Goose Fly Token (GF)
5 */
6 
7 contract Ownable {
8   address public owner;
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   constructor() public {
13     owner = msg.sender;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   function transferOwnership(address newOwner) public onlyOwner {
22     require(newOwner != address(0));
23     emit OwnershipTransferred(owner, newOwner);
24     owner = newOwner;
25   }
26 
27 }
28 
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a / b;
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract BasicToken is Ownable {
57   using SafeMath for uint256;
58 
59   bool public mintingEnabled = true;
60   bool public transfersEnabled = true;
61 
62   mapping(address => uint256) balances;
63   mapping (address => mapping (address => uint256)) internal allowed;
64 
65   uint256 totalSupply_;
66 
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   event Transfer(address indexed from, address indexed to, uint256 value);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73   event Mint(address indexed to, uint256 amount);
74 
75   modifier mintingAllowed() {
76     require(mintingEnabled);
77     _;
78   }
79 
80   modifier transfersAllowed() {
81     require(transfersEnabled);
82     _;
83   }
84 
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   function balanceOf(address _owner) public view returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[_from]);
103     require(_value <= allowed[_from][msg.sender]);
104 
105     balances[_from] = balances[_from].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108     emit Transfer(_from, _to, _value);
109     return true;
110   }
111 
112   function approve(address _spender, uint256 _value) public returns (bool) {
113     allowed[msg.sender][_spender] = _value;
114     emit Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   function allowance(address _owner, address _spender) public view returns (uint256) {
119     return allowed[_owner][_spender];
120   }
121 
122   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
123     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
129     uint oldValue = allowed[msg.sender][_spender];
130     if (_subtractedValue > oldValue) {
131       allowed[msg.sender][_spender] = 0;
132     } else {
133       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134     }
135     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   function mint(address _to, uint256 _amount) onlyOwner mintingAllowed public returns (bool) {
140     totalSupply_ = totalSupply_.add(_amount);
141     balances[_to] = balances[_to].add(_amount);
142     emit Mint(_to, _amount);
143     emit Transfer(address(0), _to, _amount);
144     return true;
145   }
146 
147   function toogleMinting() onlyOwner public {
148     mintingEnabled = !mintingEnabled;
149   }
150 
151   function toogleTransfers() onlyOwner public {
152     transfersEnabled = !transfersEnabled;
153   }
154 
155 }
156 
157 contract GFToken is BasicToken {
158   string public constant name = "Goose Fly Token";
159   string public constant symbol = "GF";
160   uint8 public constant decimals = 0;
161 
162   constructor() public {}
163 
164   function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
165     return super.transfer(_to, _value);
166   }
167 
168   function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
169     return super.transferFrom(_from, _to, _value);
170   }
171 
172   function approve(address _spender, uint256 _value) public transfersAllowed returns (bool) {
173     return super.approve(_spender, _value);
174   }
175 
176   function increaseApproval(address _spender, uint _addedValue) public transfersAllowed returns (bool success) {
177     return super.increaseApproval(_spender, _addedValue);
178   }
179 
180   function decreaseApproval(address _spender, uint _subtractedValue) public transfersAllowed returns (bool success) {
181     return super.decreaseApproval(_spender, _subtractedValue);
182   }
183 
184 }