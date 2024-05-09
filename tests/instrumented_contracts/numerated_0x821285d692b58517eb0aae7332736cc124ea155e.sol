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
30 contract ERC20Basic {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) public view returns (uint256);
39   function transferFrom(address from, address to, uint256 value) public returns (bool);
40   function approve(address spender, uint256 value) public returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   uint256 totalSupply_;
50 
51   function totalSupply() public view returns (uint256) {
52     return totalSupply_;
53   }
54 
55   function transfer(address _to, uint256 _value) public returns (bool) {
56     require(_to != address(0));
57     require(_value <= balances[msg.sender]);
58 
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     emit Transfer(msg.sender, _to, _value);
62     return true;
63   }
64   function balanceOf(address _owner) public view returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     allowed[msg.sender][_spender] = _value;
88     emit Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92 
93   function allowance(address _owner, address _spender) public view returns (uint256) {
94     return allowed[_owner][_spender];
95   }
96 
97   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103 
104   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     uint oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue > oldValue) {
107       allowed[msg.sender][_spender] = 0;
108     } else {
109       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     }
111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     return true;
113   }
114 
115 }
116 
117 contract Ownable {
118   address public owner;
119 
120 
121   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123   function Ownables() public {
124     owner = msg.sender;
125   }
126 
127   modifier onlyOwner() {
128     require(msg.sender == owner);
129     _;
130   }
131 
132   function transferOwnership(address newOwner) public onlyOwner {
133     require(newOwner != address(0));
134     emit OwnershipTransferred(owner, newOwner);
135     owner = newOwner;
136   }
137 
138 }
139 
140 contract Morze is StandardToken, Ownable {
141 
142   string public constant name = "Morze Token Exchange";
143   string public constant symbol = "MTE";
144   uint8 public constant decimals = 18;
145 
146   uint256 public constant INITIAL_SUPPLY = 1 * (10 ** 10) * (10 ** uint256(decimals));
147 
148   function MorzeF() public {
149     totalSupply_ = INITIAL_SUPPLY;
150     balances[msg.sender] = INITIAL_SUPPLY;
151   }
152  
153 }