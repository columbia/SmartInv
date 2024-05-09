1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) onlyOwner public {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeERC20 {
55   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
56     assert(token.transfer(to, value));
57   }
58 
59   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
60     assert(token.transferFrom(from, to, value));
61   }
62 
63   function safeApprove(ERC20 token, address spender, uint256 value) internal {
64     assert(token.approve(spender, value));
65   }
66 }
67 
68 library SafeMath {
69   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a * b;
71     assert(a == 0 || c / a == b);
72     return c;
73   }
74 
75   function div(uint256 a, uint256 b) internal constant returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function add(uint256 a, uint256 b) internal constant returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {
136     require(_to != address(0));
137 
138     uint256 _allowance = allowed[_from][msg.sender];
139 
140     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141     // require (_value <= _allowance);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = _allowance.sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    */
182   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
189     uint oldValue = allowed[msg.sender][_spender];
190     if (_subtractedValue > oldValue) {
191       allowed[msg.sender][_spender] = 0;
192     } else {
193       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194     }
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199 }
200 
201 contract BurnableToken is StandardToken {
202 
203     event Burn(address indexed burner, uint256 value);
204 
205     /**
206      * @dev Burns a specific amount of tokens.
207      * @param _value The amount of token to be burned.
208      */
209     function burn(uint256 _value) public {
210         require(_value > 0);
211         require(_value <= balances[msg.sender]);
212         // no need to require value <= totalSupply, since that would imply the
213         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
214 
215         address burner = msg.sender;
216         balances[burner] = balances[burner].sub(_value);
217         totalSupply = totalSupply.sub(_value);
218         Burn(burner, _value);
219     }
220 }
221 
222 contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
223 
224 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
225 	using SafeERC20 for ERC20Basic; 
226 
227     	/* Public variables of the token for ERC20 compliance */
228 	string public name = "Peculium"; //token name 
229     	string public symbol = "PCL"; // token symbol
230     	uint256 public decimals = 8; // token number of decimal
231     	
232     	/* Public variables specific for Peculium */
233         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
234 
235 	uint256 public dateStartContract; // The date of the deployment of the token
236 	mapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens
237 	uint256 public dateDefrost; // The date when the owners of token can defrost their tokens
238 
239 
240     	/* Event for the freeze of account */
241  	event FrozenFunds(address target, bool frozen);     	 
242      	event Defroze(address msgAdd, bool freeze);
243 	
244 
245 
246    
247 	//Constructor
248 	function Peculium() {
249 		totalSupply = MAX_SUPPLY_NBTOKEN;
250 		balances[owner] = totalSupply; // At the beginning, the owner has all the tokens. 
251 		balancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.
252 		
253 		dateStartContract=now;
254 		dateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)
255 
256 	}
257 
258 	/*** Public Functions of the contract ***/	
259 	
260 	function defrostToken() public 
261 	{ // Function to defrost your own token, after the date of the defrost
262 	
263 		require(now>dateDefrost);
264 		balancesCanSell[msg.sender]=true;
265 		Defroze(msg.sender,true);
266 	}
267 				
268 	function transfer(address _to, uint256 _value) public returns (bool) 
269 	{ // We overright the transfer function to allow freeze possibility
270 	
271 		require(balancesCanSell[msg.sender]);
272 		return BasicToken.transfer(_to,_value);
273 	
274 	}
275 	
276 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
277 	{ // We overright the transferFrom function to allow freeze possibility (need to allow before)
278 	
279 		require(balancesCanSell[msg.sender]);	
280 		return StandardToken.transferFrom(_from,_to,_value);
281 	
282 	}
283 
284 	/***  Owner Functions of the contract ***/	
285 
286    	function freezeAccount(address target, bool canSell) onlyOwner 
287    	{
288         
289         	balancesCanSell[target] = canSell;
290         	FrozenFunds(target, canSell);
291     	
292     	}
293 
294 
295 	/*** Others Functions of the contract ***/	
296 	
297 	/* Approves and then calls the receiving contract */
298 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
299 		allowed[msg.sender][_spender] = _value;
300 		Approval(msg.sender, _spender, _value);
301 
302 		require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
303         	return true;
304     }
305 
306   	function getBlockTimestamp() constant returns (uint256)
307   	{
308         
309         	return now;
310   	
311   	}
312 
313   	function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  
314   	{ // Return info about the public address and balance of the account of the owner of the contract
315     	
316     		ownerAddr = owner;
317 		ownerBalance = balanceOf(ownerAddr);
318   	
319   	}
320 
321 }