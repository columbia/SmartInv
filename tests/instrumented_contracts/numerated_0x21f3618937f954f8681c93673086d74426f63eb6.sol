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
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
26     return a >= b ? a : b;
27   }
28   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
29     return a < b ? a : b;
30   }
31   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
32     return a >= b ? a : b;
33   }
34   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 }
38 contract ERC20Basic {
39   function totalSupply() public view returns (uint256);
40   function balanceOf(address who) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46   mapping(address => uint256) balances;
47   uint256 totalSupply_;
48   function totalSupply() public view returns (uint256) {
49     return totalSupply_;
50   }
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59   function balanceOf(address _owner) public view returns (uint256 balance) {
60     return balances[_owner];
61   }
62 }
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 contract StandardToken is ERC20, BasicToken {
70   mapping (address => mapping (address => uint256)) internal allowed;
71   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[_from]);
74     require(_value <= allowed[_from][msg.sender]);
75     balances[_from] = balances[_from].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78     Transfer(_from, _to, _value);
79     return true;
80   }
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86   function allowance(address _owner, address _spender) public view returns (uint256) {
87     return allowed[_owner][_spender];
88   }
89   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
90     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
91     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
92     return true;
93   }
94   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
95     uint oldValue = allowed[msg.sender][_spender];
96     if (_subtractedValue > oldValue) {
97       allowed[msg.sender][_spender] = 0;
98     } else {
99       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
100     }
101     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 
105 }
106 library SafeERC20 {
107   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
108     assert(token.transfer(to, value));
109   }
110   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
111     assert(token.transferFrom(from, to, value));
112   }
113   function safeApprove(ERC20 token, address spender, uint256 value) internal {
114     assert(token.approve(spender, value));
115   }
116 }
117 contract Ownable {
118   address public owner;
119   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120   function Ownable() public {
121     owner = msg.sender;
122   }
123   modifier onlyOwner() {
124     require(msg.sender == owner);
125     _;
126   }
127   function transferOwnership(address newOwner) public onlyOwner {
128     require(newOwner != address(0));
129     OwnershipTransferred(owner, newOwner);
130     owner = newOwner;
131   }
132 }
133 contract MintableToken is StandardToken, Ownable {
134   event Mint(address indexed to, uint256 amount);
135   event MintFinished();
136   bool public mintingFinished = false;
137   modifier canMint() {
138     require(!mintingFinished);
139     _;
140   }
141   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
142     totalSupply_ = totalSupply_.add(_amount);
143     balances[_to] = balances[_to].add(_amount);
144     Mint(_to, _amount);
145     Transfer(address(0), _to, _amount);
146     return true;
147   }
148   function finishMinting() onlyOwner canMint public returns (bool) {
149     mintingFinished = true;
150     MintFinished();
151     return true;
152   }
153 }
154 contract Pausable is Ownable {
155   event Pause();
156   event Unpause();
157   bool public paused = false;
158   modifier whenNotPaused() {
159     require(!paused);
160     _;
161   }
162   modifier whenPaused() {
163     require(paused);
164     _;
165   }
166   function pause() onlyOwner whenNotPaused public {
167     paused = true;
168     Pause();
169   }
170   function unpause() onlyOwner whenPaused public {
171     paused = false;
172     Unpause();
173   }
174 }
175 contract PausableToken is StandardToken, Pausable {
176 
177   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
178     return super.transfer(_to, _value);
179   }
180 
181   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
182     return super.transferFrom(_from, _to, _value);
183   }
184 
185   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
186     return super.approve(_spender, _value);
187   }
188 
189   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
190     return super.increaseApproval(_spender, _addedValue);
191   }
192 
193   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
194     return super.decreaseApproval(_spender, _subtractedValue);
195   }
196 }
197 contract TokenTimelock {
198   using SafeERC20 for ERC20Basic;
199   ERC20Basic public token;
200   address public beneficiary;
201   uint256 public releaseTime;
202   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
203     require(_releaseTime > now);
204     token = _token;
205     beneficiary = _beneficiary;
206     releaseTime = _releaseTime;
207   }
208   function release() public {
209     require(now >= releaseTime);
210     uint256 amount = token.balanceOf(this);
211     require(amount > 0);
212     token.safeTransfer(beneficiary, amount);
213   }
214 }
215 /**
216  * @title MageCoin
217  * @dev MageCoin Token contract
218  */
219 contract MageCoin is PausableToken, MintableToken {
220   using SafeMath for uint256;
221   string public name = "MageCoin";
222   string public symbol = "MAG";
223   uint public decimals = 18;
224   /**
225    * @dev mint timelocked tokens
226    */
227   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) onlyOwner canMint public returns (TokenTimelock) {
228     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
229     mint(timelock, _amount);
230     return timelock;
231   }
232 }