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
13 
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
33 contract Ownable {
34   address public owner;
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   function Ownable() public {
38     owner = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 }
52 
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69   mapping(address => uint256) balances;
70   uint256 totalSupply_;
71 
72   function totalSupply() public view returns (uint256) {
73     return totalSupply_;
74   }
75 
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   function balanceOf(address _owner) public view returns (uint256 balance) {
86     return balances[_owner];
87   }
88 }
89 
90 contract StandardToken is ERC20, BasicToken {
91   mapping (address => mapping (address => uint256)) internal allowed;
92 
93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[_from]);
96     require(_value <= allowed[_from][msg.sender]);
97 
98     balances[_from] = balances[_from].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   function approve(address _spender, uint256 _value) public returns (bool) {
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   function allowance(address _owner, address _spender) public view returns (uint256) {
112     return allowed[_owner][_spender];
113   }
114 
115   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
116     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
122     uint oldValue = allowed[msg.sender][_spender];
123     if (_subtractedValue > oldValue) {
124       allowed[msg.sender][_spender] = 0;
125     } else {
126       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
127     }
128     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129     return true;
130   }
131 }
132 
133 contract Pausable is Ownable {
134   event Pause();
135   event Unpause();
136   bool public paused = false;
137 
138   modifier whenNotPaused() {
139     require(!paused);
140     _;
141   }
142 
143   modifier whenPaused() {
144     require(paused);
145     _;
146   }
147 
148   function pause() onlyOwner whenNotPaused public {
149     paused = true;
150     Pause();
151   }
152 
153   function unpause() onlyOwner whenPaused public {
154     paused = false;
155     Unpause();
156   }
157 }
158 
159 contract PausableToken is StandardToken, Pausable {
160   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
161     return super.transfer(_to, _value);
162   }
163 
164   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
165     return super.transferFrom(_from, _to, _value);
166   }
167 
168   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
169     return super.approve(_spender, _value);
170   }
171 
172   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
173     return super.increaseApproval(_spender, _addedValue);
174   }
175 
176   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
177     return super.decreaseApproval(_spender, _subtractedValue);
178   }
179 }
180 
181 contract EladToken is PausableToken {
182   string public constant name = "Elad Token";
183   string public constant symbol = "ELAD";
184   uint8 public constant decimals = 18;
185 
186   uint256 public constant initialSupply = 100000000 * 10 ** uint256(decimals);
187 
188   uint256 public startTime = 1524470400; // 04/23/2018 @ 8:00am (UTC)
189   
190   struct TokenLock { uint256 amount; uint256 duration; bool withdrawn; }
191 
192   TokenLock public advisorLock = TokenLock({
193     amount: initialSupply.div(uint256(100/5)), // 5% of initialSupply
194     duration: 180 days,
195     withdrawn: false
196   });
197 
198   TokenLock public foundationLock = TokenLock({
199     amount: initialSupply.div(uint256(100/10)), // 10% of initialSupply
200     duration: 360 days,
201     withdrawn: false
202   });
203 
204   TokenLock public teamLock = TokenLock({
205     amount: initialSupply.div(uint256(100/10)), // 10% of initialSupply
206     duration: 720 days,
207     withdrawn: false
208   });
209 
210   function EladToken() public {
211     totalSupply_ = initialSupply;
212     balances[owner] = initialSupply;
213     Transfer(address(0), owner, balances[owner]);
214 
215     lockTokens(advisorLock);
216     lockTokens(foundationLock);
217     lockTokens(teamLock);
218   }
219 
220   function withdrawLocked() external onlyOwner {
221     if (unlockTokens(advisorLock)) advisorLock.withdrawn = true;
222     if (unlockTokens(foundationLock)) foundationLock.withdrawn = true;
223     if (unlockTokens(teamLock)) teamLock.withdrawn = true;
224   }
225 
226   function lockTokens(TokenLock lock) internal {
227     balances[owner] = balances[owner].sub(lock.amount);
228     balances[address(0)] = balances[address(0)].add(lock.amount);
229     Transfer(owner, address(0), lock.amount);
230   }
231 
232   function unlockTokens(TokenLock lock) internal returns (bool) {
233     if (startTime + lock.duration < now && lock.withdrawn == false) {
234       balances[owner] = balances[owner].add(lock.amount);
235       balances[address(0)] = balances[address(0)].sub(lock.amount);
236       Transfer(address(0), owner, lock.amount);
237       return true;
238     }
239     return false;
240   }
241 }