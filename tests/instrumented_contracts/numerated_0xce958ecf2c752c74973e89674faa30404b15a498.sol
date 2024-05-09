1 library SafeMath {
2 
3   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
4     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
5     // benefit is lost if 'b' is also tested.
6     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
7     if (a == 0) {
8       return 0;
9     }
10 
11     c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     // uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return a / b;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 contract ERC20Basic {
36   function totalSupply() public view returns (uint256);
37   function balanceOf(address who) public view returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract BasicToken is ERC20Basic {
43   using SafeMath for uint256;
44 
45   mapping(address => uint256) balances;
46 
47   uint256 totalSupply_;
48 
49 
50   function totalSupply() public view returns (uint256) {
51     return totalSupply_;
52   }
53 
54   function transfer(address _to, uint256 _value) public returns (bool) {
55     require(_to != address(0));
56     require(_value <= balances[msg.sender]);
57 
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     emit Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   function balanceOf(address _owner) public view returns (uint256) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 
71 
72 
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender)
75     public view returns (uint256);
76 
77   function transferFrom(address from, address to, uint256 value)
78     public returns (bool);
79 
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(
82     address indexed owner,
83     address indexed spender,
84     uint256 value
85   );
86 }
87 
88 
89 contract StandardToken is ERC20, BasicToken {
90   mapping (address => mapping (address => uint256)) internal allowed;
91   
92   function transferFrom(
93     address _from,
94     address _to,
95     uint256 _value
96   )
97     public
98     returns (bool)
99   {
100     require(_to != address(0));
101     require(_value <= balances[_from]);
102     require(_value <= allowed[_from][msg.sender]);
103 
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107     emit Transfer(_from, _to, _value);
108     return true;
109   }
110 
111 
112   function approve(address _spender, uint256 _value) public returns (bool) {
113     allowed[msg.sender][_spender] = _value;
114     emit Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118 
119   function allowance(
120     address _owner,
121     address _spender
122    )
123     public
124     view
125     returns (uint256)
126   {
127     return allowed[_owner][_spender];
128   }
129 
130   function increaseApproval(
131     address _spender,
132     uint _addedValue
133   )
134     public
135     returns (bool)
136   {
137     allowed[msg.sender][_spender] = (
138       allowed[msg.sender][_spender].add(_addedValue));
139     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   function decreaseApproval(
144     address _spender,
145     uint _subtractedValue
146   )
147     public
148     returns (bool)
149   {
150     uint oldValue = allowed[msg.sender][_spender];
151     if (_subtractedValue > oldValue) {
152       allowed[msg.sender][_spender] = 0;
153     } else {
154       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155     }
156     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160 }
161 
162 
163 contract MaspToken is StandardToken {
164     string public name = "MaspToken";
165     string public symbol = "MASP";
166     uint public decimals = 18;
167     uint public constant INITIAL_SUPPLY = 102228579 * (10 ** uint256(decimals));
168 
169     address private owner;
170 
171     constructor() public {
172         owner = msg.sender;
173         totalSupply_ = INITIAL_SUPPLY;
174         balances[owner] = INITIAL_SUPPLY;
175     }
176 }