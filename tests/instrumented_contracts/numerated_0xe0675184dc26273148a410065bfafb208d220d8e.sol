1 pragma solidity 0.4.24;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
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
17 library SafeMath {
18       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28 // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30 // assert(a == b * c + a % b); 
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35 assert(b <= a);
36 return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40 uint256 c = a + b;
41 assert(c >= a);
42 return c;
43   }
44 }
45 
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   function transfer(address _to, uint256 _value) public returns (bool) {
53 require(_to != address(0));
54 require(_value <= balances[msg.sender]);
55 
56 // SafeMath.sub will throw if there is not enough balance.
57 balances[msg.sender] = balances[msg.sender].sub(_value);
58 balances[_to] = balances[_to].add(_value);
59 emit Transfer(msg.sender, _to, _value);
60 return true;
61   }
62 
63   function balanceOf(address _owner) public view returns (uint256 balance) {
64 return balances[_owner];
65   }
66 
67 }
68 
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72 
73   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74 require(_to != address(0));
75 require(_value <= balances[_from]);
76 require(_value <= allowed[_from][msg.sender]);
77 
78 balances[_from] = balances[_from].sub(_value);
79 balances[_to] = balances[_to].add(_value);
80 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81 emit Transfer(_from, _to, _value);
82 return true;
83   }
84 
85   function approve(address _spender, uint256 _value) public returns (bool) {
86 allowed[msg.sender][_spender] = _value;
87 emit Approval(msg.sender, _spender, _value);
88 return true;
89   }
90 
91   function allowance(address _owner, address _spender) public view returns (uint256) {
92 return allowed[_owner][_spender];
93   }
94 
95   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
97 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98 return true;
99   }
100 
101         function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
102 uint oldValue = allowed[msg.sender][_spender];
103 if (_subtractedValue > oldValue) {
104   allowed[msg.sender][_spender] = 0;
105 } else {
106   allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
107 }
108 emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109 return true;
110   }
111 
112     }
113 
114 contract Ownable {
115    address public owner;
116 
117 
118    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120 
121   function Ownable() public {
122 owner = msg.sender;
123   }
124 
125    modifier onlyOwner() {
126 require(msg.sender == owner);
127 _;
128   }
129 
130 
131   function transferOwnership(address newOwner) public onlyOwner {
132 require(newOwner != address(0));
133 emit OwnershipTransferred(owner, newOwner);
134 owner = newOwner;
135   }
136 
137 }
138 
139 contract Pausable is Ownable {
140    event Pause();
141    event Unpause();
142 
143   bool public paused = false;
144 
145   modifier whenNotPaused() {
146 require(!paused);
147 _;
148   }
149 
150   modifier whenPaused() {
151 require(paused);
152 _;
153   }
154 
155   function pause() onlyOwner whenNotPaused public {
156 paused = true;
157 emit Pause();
158   }
159 
160    function unpause() onlyOwner whenPaused public {
161 paused = false;
162 emit Unpause();
163   }
164  }
165 
166 contract PausableToken is StandardToken, Pausable {
167 
168   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
169 return super.transfer(_to, _value);
170   }
171 
172    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
173 return super.transferFrom(_from, _to, _value);
174    }
175 
176   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
177 return super.approve(_spender, _value);
178   }
179 
180   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
181 return super.increaseApproval(_spender, _addedValue);
182   }
183 
184    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
185 return super.decreaseApproval(_spender, _subtractedValue);
186  }
187 }
188 
189 contract Uptrennd is StandardToken, PausableToken {
190    string public constant name = 'Uptrennd';                                      // Set the token name for display
191    string public constant symbol = '1UP';                                       // Set the token symbol for display
192    uint8 public constant decimals = 18;                                          // Set the number of decimals for display
193    uint256 public constant INITIAL_SUPPLY = 10000000000 * 1**uint256(decimals);  // 50 billions 
194 
195   function Uptrennd() public{
196 totalSupply = INITIAL_SUPPLY;                               // Set the total supply
197 balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
198 emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
199   }
200 
201    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
202 require(_to != address(0));
203 return super.transfer(_to, _value);
204    }
205 
206    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
207 require(_to != address(0));
208 return super.transferFrom(_from, _to, _value);
209    }
210 
211   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
212 return super.approve(_spender, _value);
213   }
214 
215     event Burn(address indexed _burner, uint _value);
216 
217     function burn(uint _value) public returns (bool)
218 {
219     balances[msg.sender] = balances[msg.sender].sub(_value);
220     totalSupply = totalSupply.sub(_value);
221     emit Burn(msg.sender, _value);
222     emit Transfer(msg.sender, address(0x0), _value);
223     return true;
224     }
225  }