1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract Pausable is Ownable {
41   event Pause();
42   event Unpause();
43 
44   bool public paused = false;
45 
46 
47   /**
48    * @dev Modifier to make a function callable only when the contract is not paused.
49    */
50   modifier whenNotPaused() {
51     require(!paused);
52     _;
53   }
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is paused.
57    */
58   modifier whenPaused() {
59     require(paused);
60     _;
61   }
62 
63   /**
64    * @dev called by the owner to pause, triggers stopped state
65    */
66   function pause() onlyOwner whenNotPaused public {
67     paused = true;
68     Pause();
69   }
70 
71   /**
72    * @dev called by the owner to unpause, returns to normal state
73    */
74   function unpause() onlyOwner whenPaused public {
75     paused = false;
76     Unpause();
77   }
78 }
79 
80 contract ERC20 {
81   uint256 public totalSupply;
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85   function allowance(address owner, address spender) public view returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 contract DetailedERC20 is ERC20 {
92   string public name;
93   string public symbol;
94   uint8 public decimals;
95 
96   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
97     name = _name;
98     symbol = _symbol;
99     decimals = _decimals;
100   }
101 }
102 
103 contract STMCoin is Pausable, DetailedERC20 {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107   mapping (address => mapping (address => uint256)) internal allowed;
108   mapping(address => uint256) public lockedBalances;
109 
110   uint public unlocktime;
111   address public crowdsaleContract = 0;
112 
113   function STMCoin() DetailedERC20("SATOMO", "STM", 18) public {
114     unlocktime = 1564070400;                              // 2019/7/26 00:00:00
115     totalSupply = 4 * (10**9) * 10**uint256(decimals);  // 4 billion
116     uint256 ownerLock = totalSupply -  1 * (10**9) * 10**uint256(decimals); // 3 billion
117     balances[msg.sender] = ownerLock;
118     Transfer(msg.sender, msg.sender, ownerLock);
119   }
120 
121   function setCrowdsaleContract(address crowdsale) onlyOwner public {
122     crowdsaleContract = crowdsale;
123   }
124 
125   modifier timeLock(address from, uint value) {
126     if (now < unlocktime) {
127       require(value <= balances[from] - lockedBalances[from]);
128     } else {
129       lockedBalances[from] = 0;
130     }
131     _;
132   }
133 
134   function addToBalances(address _person,uint256 value) {
135     require(msg.sender == crowdsaleContract);
136     balances[_person] = balances[_person].add(value);
137     Transfer(address(this), _person, value);
138   }
139 
140   function transfer(address _to, uint256 _value) timeLock(msg.sender, _value) whenNotPaused public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   function transferToLockedBalance(address _to, uint256 _value) whenNotPaused public returns (bool) {
151     require(msg.sender == crowdsaleContract);
152     if (transfer(_to, _value)) {
153       lockedBalances[_to] = lockedBalances[_to].add(_value);
154       return true;
155     }
156   }
157 
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 
163   function transferFrom(address _from, address _to, uint256 _value) public timeLock(_from, _value) whenNotPaused returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   function allowance(address _owner, address _spender) public view returns (uint256) {
182     return allowed[_owner][_spender];
183   }
184 
185   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   function updateUnlocktime(uint newtime) onlyOwner public {
203     unlocktime = newtime;
204   }
205 }
206 
207 library SafeMath {
208   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209     if (a == 0) {
210       return 0;
211     }
212     uint256 c = a * b;
213     assert(c / a == b);
214     return c;
215   }
216 
217   function div(uint256 a, uint256 b) internal pure returns (uint256) {
218     // assert(b > 0); // Solidity automatically throws when dividing by 0
219     uint256 c = a / b;
220     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221     return c;
222   }
223 
224   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225     assert(b <= a);
226     return a - b;
227   }
228 
229   function add(uint256 a, uint256 b) internal pure returns (uint256) {
230     uint256 c = a + b;
231     assert(c >= a);
232     return c;
233   }
234 }