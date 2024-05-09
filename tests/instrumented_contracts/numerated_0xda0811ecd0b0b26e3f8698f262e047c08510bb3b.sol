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
32 contract Ownable {
33   address public owner;
34   
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 }
63 
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     // SafeMath.sub will throw if there is not enough balance.
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99   }
100 }
101 
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     emit Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     emit Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   function allowance(address _owner, address _spender) public view returns (uint256) {
132     return allowed[_owner][_spender];
133   }
134 
135   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 }
152 
153 contract Pausable is Ownable {
154   event Pause();
155   event Unpause();
156 
157   bool public paused = false;
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is not paused.
161    */
162   modifier whenNotPaused() {
163     require(!paused);
164     _;
165   }
166 
167   /**
168    * @dev Modifier to make a function callable only when the contract is paused.
169    */
170   modifier whenPaused() {
171     require(paused);
172     _;
173   }
174 
175   /**
176    * @dev called by the owner to pause, triggers stopped state
177    */
178   function pause() onlyOwner whenNotPaused public {
179     paused = true;
180     emit Pause();
181   }
182 
183   /**
184    * @dev called by the owner to unpause, returns to normal state
185    */
186   function unpause() onlyOwner whenPaused public {
187     paused = false;
188     emit Unpause();
189   }
190 }
191 
192 contract PausableToken is StandardToken, Pausable {
193 
194   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
195     return super.transfer(_to, _value);
196   }
197 
198   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
199     return super.transferFrom(_from, _to, _value);
200   }
201 
202   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
203     return super.approve(_spender, _value);
204   }
205 
206   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
207     return super.increaseApproval(_spender, _addedValue);
208   }
209 
210   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
211     return super.decreaseApproval(_spender, _subtractedValue);
212   }
213 }
214 
215 contract YDTToken is PausableToken {
216     string public name = "YDT Token";
217     string public symbol = "YDT";
218     uint public decimals = 18;
219     uint public INITIAL_SUPPLY = 10500000000000000000000000000;
220 
221     function YDTToken() public {
222         totalSupply = INITIAL_SUPPLY;
223         balances[msg.sender] = INITIAL_SUPPLY;
224     }
225 }