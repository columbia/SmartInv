1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
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
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68   function balanceOf(address _owner) public view returns (uint256 balance) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) internal allowed;
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] = balances[_from].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool) {
93     allowed[msg.sender][_spender] = _value;
94     Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98 
99   function allowance(address _owner, address _spender) public view returns (uint256) {
100     return allowed[_owner][_spender];
101   }
102 
103   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
104     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
105     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 
109 
110   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129   function Ownable() public {
130     owner = msg.sender;
131   }
132 
133   modifier onlyOwner() {
134     require(msg.sender == owner);
135     _;
136   }
137 
138   function transferOwnership(address newOwner) public onlyOwner {
139     require(newOwner != address(0));
140     OwnershipTransferred(owner, newOwner);
141     owner = newOwner;
142   }
143 
144 }
145 
146 contract EBITOKEN is StandardToken, Ownable {
147 
148   string public constant name = "EBITOKEN";
149   string public constant symbol = "EBI";
150   uint8 public constant decimals = 18;
151 
152   uint256 public constant INITIAL_SUPPLY = 1 * (10 ** 10) * (10 ** uint256(decimals));
153 
154   function EBITOKEN() public {
155     totalSupply_ = INITIAL_SUPPLY;
156     balances[msg.sender] = INITIAL_SUPPLY;
157   }
158 }