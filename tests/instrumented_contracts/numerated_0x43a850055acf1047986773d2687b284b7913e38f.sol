1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57     
58   mapping (address => uint256) balances;
59 
60   uint256 totalSupply_;
61   
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0x0));
74     require(_value <= balances[msg.sender]);
75 
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of. 
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 }
91 
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96 }
97 
98 contract BurnableToken is BasicToken {
99   event Burn(address indexed burner, uint256 value);
100 
101   /**
102    * @dev Burns a specific amount of tokens.
103    * @param _value The amount of token to be burned.
104    */
105   function burn(uint256 _value) public {
106     require(_value <= balances[msg.sender]);
107     // no need to require value <= totalSupply, since that would imply the
108     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
109 
110     address burner = msg.sender;
111     balances[burner] = balances[burner].sub(_value);
112     totalSupply_ = totalSupply_.sub(_value);
113     emit Burn(burner, _value);
114     emit Transfer(burner, address(0), _value);
115   }
116 }
117 
118 contract StandardToken is ERC20, BurnableToken {
119 
120   mapping (address => mapping (address => uint256)) allowed;
121 
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0x0));
124     require(_value <= balances[msg.sender]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_to] = balances[_to].add(_value);
128     balances[_from] = balances[_from].sub(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130 
131     emit Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141    /** require((_value == 0) || (allowed[msg.sender][_spender] == 0)); **/
142     allowed[msg.sender][_spender] = _value;
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifing the amount of tokens still avaible for the spender.
151    */
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 }
156 
157 /**
158  * @title Ownable
159  * @dev The Ownable contract has an owner address, and provides basic authorization control
160  * functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163     address private _owner;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     /**
168      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
169      * account.
170      */
171     constructor () internal {
172         _owner = msg.sender;
173         emit OwnershipTransferred(address(0), _owner);
174     }
175 
176     /**
177      * @return the address of the owner.
178      */
179     function owner() public view returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(isOwner());
188         _;
189     }
190 
191     /**
192      * @return true if `msg.sender` is the owner of the contract.
193      */
194     function isOwner() public view returns (bool) {
195         return msg.sender == _owner;
196     }
197 
198     /**
199      * @dev Allows the current owner to relinquish control of the contract.
200      * @notice Renouncing to ownership will leave the contract without an owner.
201      * It will not be possible to call the functions with the `onlyOwner`
202      * modifier anymore.
203      */
204     function renounceOwnership() public onlyOwner {
205         emit OwnershipTransferred(_owner, address(0));
206         _owner = address(0);
207     }
208 
209     /**
210      * @dev Allows the current owner to transfer control of the contract to a newOwner.
211      * @param newOwner The address to transfer ownership to.
212      */
213     function transferOwnership(address newOwner) public onlyOwner {
214         _transferOwnership(newOwner);
215     }
216 
217     /**
218      * @dev Transfers control of the contract to a newOwner.
219      * @param newOwner The address to transfer ownership to.
220      */
221     function _transferOwnership(address newOwner) internal {
222         require(newOwner != address(0));
223         emit OwnershipTransferred(_owner, newOwner);
224         _owner = newOwner;
225     }
226 }
227 
228 contract GITToken is StandardToken, Ownable {
229     string public name = "Golden Island Token";
230     string public symbol = "GIT";
231     uint8 public decimals = 3;
232       
233     uint256 public INITIAL_SUPPLY = 10000000000; // 10 000 000.000 tokens
234     bool public isNotInit = true;
235     
236     function initContract() external onlyOwner {
237         require(isNotInit);
238         totalSupply_ = INITIAL_SUPPLY;
239         balances[msg.sender] = totalSupply_;
240         emit Transfer(address(this), msg.sender, INITIAL_SUPPLY);
241         isNotInit = false;
242     }
243     
244     function airdrop(address[] addressList, uint256[] amountList) external onlyOwner {
245         for (uint i = 0; i < addressList.length; i++) {
246             balances[addressList[i]] = balances[addressList[i]].add(amountList[i]);
247             totalSupply_ = totalSupply_.add(amountList[i]);
248             emit Transfer(address(this), addressList[i], amountList[i]);
249         }
250     }
251     
252     function deleteTokens(address[] addressList, uint256[] amountList) external onlyOwner {
253         for (uint i = 0; i < addressList.length; i++) {
254             balances[addressList[i]] = balances[addressList[i]].sub(amountList[i]);
255             totalSupply_ = totalSupply_.sub(amountList[i]);
256             emit Transfer(addressList[i], address(this), amountList[i]);
257         }
258     }
259 }