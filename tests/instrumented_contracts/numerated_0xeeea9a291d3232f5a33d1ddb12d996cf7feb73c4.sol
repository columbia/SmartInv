1 pragma solidity ^0.4.24;
2 
3 // AZOT Cryogenics Pre-sale Token
4 
5 // Include SafeMath Library - upgraded for compatability with 4.24
6 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7 
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     if (a == 0) {
12       return 0;
13     }
14 
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     return a / b;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30     c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 // Define the owner, and give an emergency kill switch.
37 contract Ownable {
38   address public owner;
39 
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   function kill() public onlyOwner { 
50       if (msg.sender == owner) selfdestruct(owner); 
51       
52   }
53   
54 }
55 
56 contract ERC20 is Ownable {
57   using SafeMath for uint256;
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 
63     function allowance(address owner, address spender)
64     public view returns (uint256);
65 
66     function transferFrom(address from, address to, uint256 value)
67     public returns (bool);
68 
69     function approve(address spender, uint256 value) public returns (bool);
70   event Approval(
71     address indexed owner,
72     address indexed spender,
73     uint256 value
74   );
75 }
76 
77 contract Basic is ERC20 {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     emit Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   function balanceOf(address _owner) public view returns (uint256) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 contract Functions is Basic {
104   mapping (address => mapping (address => uint256)) internal allowed;
105   function transferFrom(
106     address _from,
107     address _to,
108     uint256 _value
109   )
110     public
111     returns (bool)
112   {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     emit Transfer(_from, _to, _value);
120     return true;
121   }
122   function approve(address _spender, uint256 _value) public returns (bool) {
123     allowed[msg.sender][_spender] = _value;
124     emit Approval(msg.sender, _spender, _value);
125     return true;
126   }
127   function allowance(
128     address _owner,
129     address _spender
130    )
131     public
132     view
133     returns (uint256)
134   {
135     return allowed[_owner][_spender];
136   }
137   function increaseApproval(
138     address _spender,
139     uint256 _addedValue
140   )
141     public
142     returns (bool)
143   {
144     allowed[msg.sender][_spender] = (
145       allowed[msg.sender][_spender].add(_addedValue));
146     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149   function decreaseApproval(
150     address _spender,
151     uint256 _subtractedValue
152   )
153     public
154     returns (bool)
155   {
156     uint256 oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 }
166 
167 contract Burnable is Functions {
168   event Burn(address indexed burner, uint256 value);
169   function burn(uint256 _value) public {
170     _burn(msg.sender, _value);
171   }
172   function _burn(address _who, uint256 _value) internal {
173     require(_value <= balances[_who]);
174     balances[_who] = balances[_who].sub(_value);
175     totalSupply_ = totalSupply_.sub(_value);
176     emit Burn(_who, _value);
177     emit Transfer(_who, address(0), _value);
178   }
179 }
180 
181 contract CreateCoins is Functions {
182   event Create(address indexed to, uint256 amount);
183 
184   modifier hasCreatePermission() {
185     require(msg.sender == owner);
186     _;
187   }
188 
189   function create(
190     address _to,
191     uint256 _amount
192   )
193     hasCreatePermission
194     public
195     returns (bool)
196   {
197     totalSupply_ = totalSupply_.add(_amount);
198     balances[_to] = balances[_to].add(_amount);
199     emit Create(_to, _amount);
200     emit Transfer(address(0), _to, _amount);
201     return true;
202   }
203 }
204 
205 contract AZOTEToken is CreateCoins, Burnable {
206   string public name = "AZOTE Token";
207   string public symbol = "AZTE";
208   uint8 public decimals = 5;
209 }