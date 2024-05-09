1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[_from]);
131     require(_value <= allowed[_from][msg.sender]);
132 
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
163     uint oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181   address public owner;
182 
183 
184   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() public {
192     owner = msg.sender;
193   }
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 contract TonalQuantum is StandardToken, Ownable {
216     string public name = "Tonal Quantum Token";
217     string public symbol = "TOQ";
218     uint8 public decimals = 18;
219     uint public INITIAL_SUPPLY = 300000000 * (10**uint256(decimals));
220 
221     event Bless(address indexed from, string words, uint256 value);
222     event LogBuy(address user, uint amount);
223 
224     function TonalQuantum() public {
225         totalSupply_ = INITIAL_SUPPLY;
226         balances[msg.sender] = INITIAL_SUPPLY;
227     }
228 
229     function buy() payable public returns (bool) {
230         require(msg.value >= 0.00005 ether * (18**uint256(decimals)));
231 
232         uint _value = msg.value / 0.00005 ether * (18**uint256(decimals));
233 
234         balances[owner] = balances[owner].sub(_value);
235         balances[msg.sender] = balances[msg.sender].add(_value);
236         LogBuy(msg.sender, _value);
237         
238         return true;
239     }
240 
241     function bless(string _words, uint256 _value) public returns (bool) {
242         require(_value >= bytes(_words).length);
243         require(_value <= balances[msg.sender]);
244 
245         balances[msg.sender] = balances[msg.sender].sub(_value);
246         balances[owner] = balances[owner].add(_value);
247         Bless(msg.sender, _words,  _value);
248 
249         return true;
250     }
251 
252     function reclaimEther() onlyOwner public {
253         assert(owner.send(address(this).balance));
254     }
255 
256     function() payable public {
257         buy();
258     }
259 }