1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant public returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Unsigned math operations with safety checks that revert on error
26  */
27 library SafeMath {
28     /**
29      * @dev Multiplies two unsigned integers, reverts on overflow.
30      */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b);
41 
42         return c;
43     }
44 
45     /**
46      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
47      */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0);
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54         return c;
55     }
56 
57     /**
58      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b <= a);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Adds two unsigned integers, reverts on overflow.
69      */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a);
73 
74         return c;
75     }
76 
77     /**
78      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
79      * reverts when dividing by zero.
80      */
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b != 0);
83         return a % b;
84     }
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances. 
91  */
92 contract BasicToken is ERC20Basic {
93     
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) balances;
97 
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100 	balances[_to] = balances[_to].add(_value);
101 	emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of. 
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) constant public returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) allowed;
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amout of tokens to be transfered
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
134     balances[_to] = balances[_to].add(_value);
135     balances[_from] = balances[_from].sub(_value);
136     emit Transfer(_from, _to, _value);
137     return true;
138   }
139 
140 }
141 
142 /**
143  * @title Ownable
144  * @dev The Ownable contract has an owner address, and provides basic authorization control
145  * functions, this simplifies the implementation of "user permissions".
146  */
147 contract Ownable {
148     
149   address public owner;
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151  
152   constructor() public {
153     owner = msg.sender;
154   }
155 
156   modifier onlyOwner() {
157     require(msg.sender == owner);
158     _;
159   }
160 
161 }
162 
163 /**
164  * @title Mintable token
165  * @dev Simple ERC20 Token example, with mintable token creation
166  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
167  * Based on code by https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
168  */
169 
170 contract MintableToken is StandardToken, Ownable {
171     
172   event Mint(address indexed to, uint256 amount);
173   
174   event MintFinished();
175 
176   bool public mintingFinished = false;
177 
178   modifier canMint() {
179     require(!mintingFinished);
180     _;
181   }
182 
183 
184   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
185     totalSupply = totalSupply.add(_amount);
186     balances[_to] = balances[_to].add(_amount);
187     emit Mint(_to, _amount);
188     return true;
189   }
190 
191   /**
192    * @dev Function to stop minting new tokens.
193    * @return True if the operation was successful.
194    */
195   function finishMinting() onlyOwner public returns (bool) {
196     mintingFinished = true;
197     emit MintFinished();
198     return true;
199   }
200   
201 }
202 
203 contract Doli is MintableToken {
204     
205     string public constant name = "DOLI Token";
206     
207     string public constant symbol = "DOLI";
208     
209     uint32 public constant decimals = 18;
210 
211 }
212 
213 
214 contract DoliCrowdsale is Ownable {
215     
216     using SafeMath for uint;
217     
218     uint restrictedPercent;
219 
220     address restrictedAccount;
221 
222     Doli public token = new Doli();
223 
224     uint startDate;
225 	
226 	uint endDate;
227     
228     uint period2;
229 	
230 	uint period3;
231 	
232 	uint period4;
233 	
234     uint rate;
235    
236     uint hardcap;
237     
238    
239 
240     constructor() public payable {
241 	
242         restrictedAccount = 0x023770c61B9372be44bDAB41f396f8129C14c377;
243         restrictedPercent = 40;
244         rate = 100000000000000000000;
245         startDate = 1553385600;
246 	    period2 = 1557446400;
247 		period3 = 1561420800;
248 		period4 = 1565395200;
249 		endDate = 1569369600;
250 
251         hardcap = 500000000000000000000000000;
252        
253     }
254     modifier saleIsOn() {
255     	require(now > startDate && now < endDate);
256     	_;
257     }
258 	
259 	modifier isUnderHardCap() {
260         require(token.totalSupply() <= hardcap);
261         _;
262     }
263     
264     function finishMinting() public onlyOwner {
265         uint issuedTokenSupply = token.totalSupply();
266         uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
267         token.mint(restrictedAccount, restrictedTokens);
268         token.finishMinting();
269     }
270         
271     /** value - amount in EURO! */
272     function createTokens(address customer, uint256 value) onlyOwner saleIsOn public {
273         
274         uint256 tokens;
275         uint bonusRate = 10;
276         if (customer==owner) {
277           revert();  
278         }
279         if(now >= startDate &&  now < period2) {
280           bonusRate = 7;
281         } else 
282 		if(now >= period2 &&  now < period3) {
283           bonusRate = 8;
284         } else 
285 		if(now >= period3 &&  now < period4) {
286           bonusRate = 9;
287         } if(now >= period4 &&  now < endDate) {
288           bonusRate = 10;
289         }
290 		tokens = value.mul(1 ether).mul(10).div(bonusRate); 
291 		token.mint(owner, tokens);
292 		token.transferFrom(owner, customer, tokens); 
293     }
294     
295     function getTokensCount() public constant returns(uint256){
296        return token.totalSupply().div(1 ether); }
297 
298     function getBalance(address customer) onlyOwner public constant returns(uint256){
299        return token.balanceOf(customer).div(1 ether); }
300 	   
301      function() external payable  onlyOwner {
302        revert();}
303 }