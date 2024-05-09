1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18   using SafeMath for uint256;
19 
20   mapping(address => uint256) balances;
21 
22   uint256 totalSupply_;
23 
24   function totalSupply() public view returns (uint256) {
25     return totalSupply_;
26   }
27 
28   function transfer(address _to, uint256 _value) public returns (bool) {
29     require(_to != address(0));
30     require(_value <= balances[msg.sender]);
31 
32     // SafeMath.sub will throw if there is not enough balance.
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     Transfer(msg.sender, _to, _value);
36     return true;
37   }
38   function balanceOf(address _owner) public view returns (uint256 balance) {
39     return balances[_owner];
40   }
41 
42 }
43 
44 library SafeMath {
45 
46 
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
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
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     allowed[msg.sender][_spender] = _value;
92     Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96 
97   function allowance(address _owner, address _spender) public view returns (uint256) {
98     return allowed[_owner][_spender];
99   }
100 
101   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107 
108   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109     uint oldValue = allowed[msg.sender][_spender];
110     if (_subtractedValue > oldValue) {
111       allowed[msg.sender][_spender] = 0;
112     } else {
113       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114     }
115     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118 
119 }
120 
121 contract Ownable {
122   address public owner;
123 
124 
125   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127   function Ownable() public {
128     owner = msg.sender;
129   }
130 
131   modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136   function transferOwnership(address newOwner) public onlyOwner {
137     require(newOwner != address(0));
138     OwnershipTransferred(owner, newOwner);
139     owner = newOwner;
140   }
141 
142 }
143 
144 contract YODCToken is StandardToken, Ownable {
145 
146   string public constant name = "YODCOIN";
147   string public constant symbol = "YODC";
148   uint8 public constant decimals = 18;
149 
150   uint256 public constant INITIAL_SUPPLY = 1 * (10 ** 10) * (10 ** uint256(decimals));
151 
152   function YODCToken() public {
153     totalSupply_ = INITIAL_SUPPLY;
154     balances[msg.sender] = INITIAL_SUPPLY;
155   }
156 }