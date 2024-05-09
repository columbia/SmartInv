1 pragma solidity ^0.4.17;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11   address public owner;
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 }
39 
40 contract Pausable is Ownable {
41   event Pause();
42   event Unpause();
43 
44   bool public paused = false;
45 
46   /**
47    * @dev modifier to allow actions only when the contract IS paused
48    */
49   modifier whenNotPaused() {
50     require(!paused);
51     _;
52   }
53 
54   /**
55    * @dev modifier to allow actions only when the contract IS NOT paused
56    */
57   modifier whenPaused {
58     require(paused);
59     _;
60   }
61 
62   /**
63    * @dev called by the owner to pause, triggers stopped state
64    */
65   function pause() onlyOwner whenNotPaused returns (bool) {
66     paused = true;
67     Pause();
68     return true;
69   }
70 
71   /**
72    * @dev called by the owner to unpause, returns to normal state
73    */
74   function unpause() onlyOwner whenPaused returns (bool) {
75     paused = false;
76     Unpause();
77     return true;
78   }
79 }
80 
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) constant returns (uint256);
83   function transferFrom(address from, address to, uint256 value) returns (bool);
84   function approve(address spender, uint256 value) returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 library SafeMath {
89   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
90     uint256 c = a * b;
91     assert(a == 0 || c / a == b);
92     return c;
93   }
94 
95   function div(uint256 a, uint256 b) internal constant returns (uint256) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return c;
100   }
101 
102   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   function add(uint256 a, uint256 b) internal constant returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 contract BasicToken is ERC20Basic, Ownable {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) returns (bool) {
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of. 
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address _owner) constant returns (uint256 balance) {
137     return balances[_owner];
138   }
139 }
140 
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) allowed;
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amout of tokens to be transfered
150    */
151   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
152     var _allowance = allowed[_from][msg.sender];
153 
154     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155     // require (_value <= _allowance);
156 
157     balances[_to] = balances[_to].add(_value);
158     balances[_from] = balances[_from].sub(_value);
159     allowed[_from][msg.sender] = _allowance.sub(_value);
160     Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * @param _spender The address which will spend the funds.
167    * @param _value The amount of tokens to be spent.
168    */
169   function approve(address _spender, uint256 _value) returns (bool) {
170 
171     // To change the approve amount you first have to reduce the addresses`
172     //  allowance to zero by calling `approve(_spender, 0)` if it is not
173     //  already 0 to mitigate the race condition described here:
174     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
176 
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifing the amount of tokens still avaible for the spender.
187    */
188   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
189     return allowed[_owner][_spender];
190   }
191 
192 }
193 
194 contract BurnableToken is StandardToken, Pausable {
195 
196     event Burn(address indexed burner, uint256 value);
197 
198     function transfer(address _to, uint _value) whenNotPaused returns (bool) {
199     return super.transfer(_to, _value);
200     }
201 
202     function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
203     return super.transferFrom(_from, _to, _value);
204     }
205 
206     /**
207      * @dev Burns a specified amount of tokens from messager sender's account.
208      * @param _value The amount of tokens to burn. 
209      */
210     function burn(uint256 _value) whenNotPaused public {
211         require(_value > 0);
212         balances[msg.sender] = balances[msg.sender].sub(_value);
213         totalSupply = totalSupply.sub(_value);  // reduce total supply after burn
214         Burn(msg.sender, _value);
215     }
216 }
217 
218 contract SECToken is BurnableToken {
219 
220     string public constant symbol = "SEC";
221     string public name = "Erised(SEC)";
222     uint8 public constant decimals = 18;
223 
224     /**
225      * @dev Give all tokens to msg.sender.
226      */
227     function SECToken() {
228         uint256 _totalSupply = 567648000; // 3600sec * 24hr * 365day * 18year
229         uint256 capacity = _totalSupply.mul(1 ether);
230         totalSupply = balances[msg.sender] = capacity;
231     }
232     
233     function setName(string name_) onlyOwner {
234         name = name_;
235     }
236 
237     function burn(uint256 _value) whenNotPaused public {
238         super.burn(_value);
239     }
240 
241 }