1 // v7
2 
3 /**
4  * Token.sol
5  */
6 
7 pragma solidity ^0.4.23;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16    * @dev Multiplies two numbers, throws on overflow.
17    * @param a First number
18    * @param b Second number
19    */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30    * @dev Integer division of two numbers, truncating the quotient.
31    * @param a First number
32    * @param b Second number
33    */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   /**
42    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43    * @param a First number
44    * @param b Second number
45    */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52    * @dev Adds two numbers, throws on overflow.
53    * @param a First number
54    * @param b Second number
55    */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner {
94     require(newOwner != address(0));
95     emit OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 }
99 
100 contract ERC20Basic {
101   uint256 public totalSupply;
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 contract ERC20 {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   function balanceOf(address _owner) public view returns (uint256 balance) {
131     return balances[_owner];
132   }
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     emit Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     allowed[msg.sender][_spender] = _value;
153     emit Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   function allowance(address _owner, address _spender) public view returns (uint256) {
158     return allowed[_owner][_spender];
159   }
160 
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 }
178 
179 /**
180  * @title TokenContract
181  * @dev Main Token Contract which is Ownable, Standard ERC20 token
182  */
183 contract TokenContract is Ownable, StandardToken {
184   string public constant name = "ExtraToken";
185   string public constant symbol = "ELT";
186   uint8 public constant decimals = 18;
187   uint256 public constant INITIAL_SUPPLY = 30000000 * (10 ** uint256(decimals));
188 
189   /**
190    * @dev Constructor of TokenContract
191    */
192   constructor() public {
193     
194     address presaleAddress = 0xEA674F79ACF3C974085784f0B3E9549B39A5E10a;
195     address crowdSaleAddress = 0xE71B9432B01d692008843Ca1727b957635B253Df;
196     address affiliatesAddress = 0xFD534c1Fd8f9F230deA015B31B77679a8475052A;
197     address advisorAddress = 0x775b67b563DD0407fd4b17a46737bB09cc9Aeb6D;
198     address bountyAddress = 0x6Bbbf95F3EEA93A2BFD42b3C2A42d616980e146E;
199     address airdropAddress = 0xc2ca8b7a7788da1799ba786174Abd17611Cf9B03;
200     address extraLoversAddress = 0xE517012CBDcCa3d86216019B4158f0C89827e586;
201     totalSupply = INITIAL_SUPPLY;
202     balances[msg.sender] = 600000 * (10 ** uint256(decimals));  // transferred to the owner (2%)
203     emit Transfer(0x0, msg.sender, 600000 * (10 ** uint256(decimals)));
204 
205     balances[presaleAddress] = 4500000 * (10 ** uint256(decimals));  // transfer to presale contract
206     emit Transfer(0x0, presaleAddress, 4500000 * (10 ** uint256(decimals)));
207 
208     balances[crowdSaleAddress] = 15000000 * (10 ** uint256(decimals)); // transfer to crowdsale contract
209     emit Transfer(0x0, presaleAddress, 15000000 * (10 ** uint256(decimals)));
210 
211     balances[affiliatesAddress] = 3600000 * (10 ** uint256(decimals)); // transfer to affiliates contract
212     emit Transfer(0x0, affiliatesAddress, 3600000 * (10 ** uint256(decimals)));
213 
214     balances[advisorAddress] = 2700000 * (10 ** uint256(decimals)); // transfer to advisors wallet (9%)
215     emit Transfer(0x0, advisorAddress, 2700000 * (10 ** uint256(decimals)));
216 
217     balances[bountyAddress] = 900000 * (10 ** uint256(decimals)); // transfer to bounty wallet
218     emit Transfer(0x0, bountyAddress, 900000 * (10 ** uint256(decimals)));
219 
220     balances[airdropAddress] = 900000 * (10 ** uint256(decimals)); // transfer to airdrop wallet / contract
221     emit Transfer(0x0, airdropAddress, 900000 * (10 ** uint256(decimals)));
222 
223     balances[extraLoversAddress] = 1800000 * (10 ** uint256(decimals)); // transfer to valult contract
224     emit Transfer(0x0, extraLoversAddress, 1800000 * (10 ** uint256(decimals)));
225   }
226 
227   /**
228    * @dev Transfer funds
229    * @param _to To whom address
230    * @param _value Amount of tokens
231    */
232   function transfer(address _to, uint256 _value) public returns (bool) {
233     return super.transfer(_to, _value);
234   }
235 
236   /**
237    * @dev Transfer tokens from one address to another
238    * @param _from address The address which you want to send tokens from
239    * @param _to address The address which you want to transfer to
240    * @param _value uint256 the amount of tokens to be transferred
241    */
242   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
243     return super.transferFrom(_from, _to, _value);
244   }
245 
246   /**
247    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     return super.approve(_spender, _value);
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    * Approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
269     return super.increaseApproval(_spender, _addedValue);
270   }
271 
272   /**
273    * @dev Decrease the amount of tokens that an owner allowed to a spender.
274    * Approve should be called when allowed[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
282     return super.decreaseApproval(_spender, _subtractedValue);
283   }
284 }