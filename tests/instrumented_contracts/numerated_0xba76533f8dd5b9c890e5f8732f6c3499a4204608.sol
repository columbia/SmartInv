1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   function balanceOf(address _owner) public view returns (uint256 balance) {
62     return balances[_owner];
63   }
64 }
65 
66 
67 contract StandardToken is ERC20, BasicToken {
68 
69   mapping (address => mapping (address => uint256)) internal allowed;
70 
71   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[_from]);
74     require(_value <= allowed[_from][msg.sender]);
75 
76     balances[_from] = balances[_from].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
79     Transfer(_from, _to, _value);
80     return true;
81   }
82 
83   function approve(address _spender, uint256 _value) public returns (bool) {
84     allowed[msg.sender][_spender] = _value;
85     Approval(msg.sender, _spender, _value);
86     return true;
87   }
88 
89   function allowance(address _owner, address _spender) public view returns (uint256) {
90     return allowed[_owner][_spender];
91   }
92 
93   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
94     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
95     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
96     return true;
97   }
98 
99 
100   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
101     uint oldValue = allowed[msg.sender][_spender];
102     if (_subtractedValue > oldValue) {
103       allowed[msg.sender][_spender] = 0;
104     } else {
105       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
106     }
107     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108     return true;
109   }
110 }
111 
112 
113 contract Ownable {
114   address public owner;
115 
116   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118   function Ownable() public {
119     owner = msg.sender;
120   }
121 
122   modifier onlyOwner() {
123     require(msg.sender == owner);
124     _;
125   }
126 
127   function transferOwnership(address newOwner) public onlyOwner {
128     require(newOwner != address(0));
129     OwnershipTransferred(owner, newOwner);
130     owner = newOwner;
131   }
132 
133 }
134 
135 
136 contract Pausable is Ownable {
137   event Pause();
138   event Unpause();
139 
140   bool public paused = false;
141 
142   modifier whenNotPaused() {
143     require(!paused);
144     _;
145   }
146 
147   modifier whenPaused() {
148     require(paused);
149     _;
150   }
151 
152   function pause() onlyOwner whenNotPaused public {
153     paused = true;
154     Pause();
155   }
156 
157   function unpause() onlyOwner whenPaused public {
158     paused = false;
159     Unpause();
160   }
161 }
162 
163 contract PausableToken is StandardToken, Pausable {
164 
165   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
166     return super.transfer(_to, _value);
167   }
168 
169   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
170     return super.transferFrom(_from, _to, _value);
171   }
172 
173   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
174     return super.approve(_spender, _value);
175   }
176 
177   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
178     return super.increaseApproval(_spender, _addedValue);
179   }
180 
181   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
182     return super.decreaseApproval(_spender, _subtractedValue);
183   }
184 }
185 
186 contract AzisCoin is PausableToken {
187 	string  public  name       = "AzisCoin";
188 	string  public  symbol     = "AZCN";
189 	uint    public  decimals   = 18;
190 
191 	function AzisCoin(uint256 initBalance) {
192 		balances[msg.sender] = totalSupply = initBalance;
193 	}
194 }