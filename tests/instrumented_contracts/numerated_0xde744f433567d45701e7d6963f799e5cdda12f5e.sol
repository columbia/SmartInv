1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   uint256 totalSupply_;
43 
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     require(_to != address(0));
50     require(_value <= balances[msg.sender]);
51 
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     emit Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) public view returns (uint256) {
59     return balances[_owner];
60   }
61 }
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender)
65     public view returns (uint256);
66 
67   function transferFrom(address from, address to, uint256 value)
68     public returns (bool);
69 
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(
72     address indexed owner,
73     address indexed spender,
74     uint256 value
75   );
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82   function transferFrom(
83     address _from,
84     address _to,
85     uint256 _value
86   )
87     public
88     returns (bool)
89   {
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
107   function allowance(
108     address _owner,
109     address _spender
110    )
111     public
112     view
113     returns (uint256)
114   {
115     return allowed[_owner][_spender];
116   }
117 
118   function increaseApproval(
119     address _spender,
120     uint _addedValue
121   )
122     public
123     returns (bool)
124   {
125     allowed[msg.sender][_spender] = (
126       allowed[msg.sender][_spender].add(_addedValue));
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseApproval(
132     address _spender,
133     uint _subtractedValue
134   )
135     public
136     returns (bool)
137   {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 }
148 
149 contract BurnableToken is BasicToken {
150 
151   event Burn(address indexed burner, uint256 value);
152 
153   function burn(uint256 _value) public {
154     _burn(msg.sender, _value);
155   }
156 
157   function _burn(address _who, uint256 _value) internal {
158     require(_value <= balances[_who]);
159 
160     balances[_who] = balances[_who].sub(_value);
161     totalSupply_ = totalSupply_.sub(_value);
162     emit Burn(_who, _value);
163     emit Transfer(_who, address(0), _value);
164   }
165 }
166 
167 contract Bitroneum is StandardToken, BurnableToken {
168 
169   string public constant name = "Bitroneum";
170   string public constant symbol = "BITRO";
171   uint8 public constant decimals = 18;
172 
173   uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(decimals));
174 
175   constructor() public {
176     totalSupply_ = INITIAL_SUPPLY;
177     balances[msg.sender] = INITIAL_SUPPLY;
178     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
179   }
180 }