1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         assert(a == b * c);
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a - b;
22         assert(b <= a);
23         assert(a == c + b);
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         assert(a == c - b);
31         return c;
32     }
33 }
34 
35 contract ERC20Basic {
36   function totalSupply() public view returns (uint256);
37   function balanceOf(address who) public view returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 is ERC20Basic {
43   function allowance(address owner, address spender) public view returns (uint256);
44   function transferFrom(address from, address to, uint256 value) public returns (bool);
45   function approve(address spender, uint256 value) public returns (bool);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   uint256 totalSupply_;
55 
56   
57   function totalSupply() public view returns (uint256) {
58     return totalSupply_;
59   }
60 
61   
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   function balanceOf(address _owner) public view returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 contract StandardToken is ERC20, BasicToken {
80 
81   mapping (address => mapping (address => uint256)) internal allowed;
82 
83 
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[_from]);
87     require(_value <= allowed[_from][msg.sender]);
88 
89     balances[_from] = balances[_from].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92     emit Transfer(_from, _to, _value);
93     return true;
94   }
95 
96   function approve(address _spender, uint256 _value) public returns (bool) {
97     allowed[msg.sender][_spender] = _value;
98     emit Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) public view returns (uint256) {
103     return allowed[_owner][_spender];
104   }
105 
106 
107   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
108     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
109     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
114     uint oldValue = allowed[msg.sender][_spender];
115     if (_subtractedValue > oldValue) {
116       allowed[msg.sender][_spender] = 0;
117     } else {
118       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
119     }
120     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124 }
125 
126 
127 contract HGUATToken is StandardToken {
128 
129   string public constant name = "HGUAT";
130   string public constant symbol = "HGUAT"; 
131   uint8 public constant decimals = 18; 
132 
133   uint256 public constant INITIAL_SUPPLY = 100000000 * 1000 * (10 ** uint256(decimals));
134 
135   function HGUATToken() public {
136     totalSupply_ = INITIAL_SUPPLY;
137     balances[msg.sender] = INITIAL_SUPPLY;
138     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
139   }
140 
141 }