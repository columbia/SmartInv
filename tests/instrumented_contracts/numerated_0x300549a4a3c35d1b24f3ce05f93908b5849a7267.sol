1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     uint256 _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     emit Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) public returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     emit Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157     
158   address public owner;
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   constructor() public {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) public onlyOwner {
181     require(newOwner != address(0));      
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188  * @title Mintable token
189  * @dev Simple ERC20 Token example, with mintable token creation
190  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
191  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
192  */
193 
194 contract MintableToken is StandardToken, Ownable {
195     
196   event Mint(address indexed to, uint256 amount);
197   
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will recieve the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     emit Mint(_to, _amount);
217     emit Transfer(address(0), _to, _amount);
218     return true;
219   }
220 
221   /**
222    * @dev Function to stop minting new tokens.
223    * @return True if the operation was successful.
224    */
225   function finishMinting() onlyOwner public returns (bool) {
226     mintingFinished = true;
227     emit MintFinished();
228     return true;
229   }
230   
231 }
232 
233 contract SMAR is MintableToken {
234     
235     string public constant name = "SmartRetail ICO";
236     
237     string public constant symbol = "SMAR";
238     
239     uint32 public constant decimals = 18;
240     
241 }
242 
243 
244 contract Crowdsale is Ownable {
245     
246     using SafeMath for uint;
247     
248     address public multisig = 0xF15eE43d0345089625050c08b482C3f2285e4F12;
249     
250     uint dec = 1000000000000000000;
251     
252     SMAR public token = new SMAR();
253 
254     
255     uint public icoStartP1 = 1528675200; // GMT: Mon, 11 Jun 2018 00:00:00 GMT
256     uint public icoStartP2 = 1531267200; // Wed, 11 Jul 2018 00:00:00 GMT
257     uint public icoStartP3 = 1533945600; // GMT: Sat, 11 Aug 2018 00:00:00 GMT
258     uint public icoStartP4 = 1536624000; // Tue, 11 Sep 2018 00:00:00 GMT
259     uint public icoStartP5 = 1539216000; // GMT: Thu, 11 Oct 2018 00:00:00 GMT
260     uint public icoStartP6 = 1541894400; // GMT: Sun, 11 Nov 2018 00:00:00 GMT
261     uint public icoEnd = 1544486400; // Tue, 11 Dec 2018 00:00:00 GMT
262     
263     
264     
265     uint public icoSoftcap = 35000*dec; // 35 000 SMAR
266     uint public icoHardcap =  1000000*dec; // 1 000 000 SMAR
267 
268 
269     //----
270     uint public tokensFor1EthP6 = 50*dec; //0.02 ETH for 1 token
271     uint public tokensFor1EthP1 = tokensFor1EthP6*125/100; //0,016   ETH for 1 token
272     uint public tokensFor1EthP2 = tokensFor1EthP6*120/100; //0,01667 ETH for 1 token
273     uint public tokensFor1EthP3 = tokensFor1EthP6*115/100; //0,01739 ETH for 1 token
274     uint public tokensFor1EthP4 = tokensFor1EthP6*110/100; //0,01818 ETH for 1 token
275     uint public tokensFor1EthP5 = tokensFor1EthP6*105/100; //0,01905 ETH for 1 token
276     //----
277         
278     mapping(address => uint) public balances;
279 
280 
281 
282     constructor() public {
283        owner = multisig;
284        token.mint(multisig, 5000*dec);  
285     }
286 
287 
288     function refund() public {
289 
290       require(  (now>icoEnd)&&(token.totalSupply()<icoSoftcap) );
291       uint value = balances[msg.sender]; 
292       balances[msg.sender] = 0; 
293       msg.sender.transfer(value); 
294     }
295     
296 
297     function refundToWallet(address _wallet) public  {
298 
299       require(  (now>icoEnd)&&(token.totalSupply()<icoSoftcap) );
300       uint value = balances[_wallet]; 
301       balances[_wallet] = 0; 
302       _wallet.transfer(value); 
303     }    
304     
305 
306     function withdraw() public onlyOwner {
307 
308        require(token.totalSupply()>=icoSoftcap);
309        multisig.transfer(address(this).balance);
310     }
311 
312 
313 
314     function finishMinting() public onlyOwner {
315       if(now>icoEnd) {
316         token.finishMinting();
317         token.transferOwnership(multisig);
318       }
319     }
320 
321 
322    function createTokens()  payable public {
323 
324       require( (now>=icoStartP1)&&(now<icoEnd) );
325 
326       require(token.totalSupply()<icoHardcap);
327        
328       uint tokens = 0;
329       uint sum = msg.value;
330       uint tokensFor1EthCurr = tokensFor1EthP6;
331       uint rest = 0;
332       
333 
334       if(now < icoStartP2) {
335         tokensFor1EthCurr = tokensFor1EthP1;
336       } else if(now >= icoStartP2 && now < icoStartP3) {
337         tokensFor1EthCurr = tokensFor1EthP2;
338       } else if(now >= icoStartP3 && now < icoStartP4) {
339         tokensFor1EthCurr = tokensFor1EthP3;
340       } else if(now >= icoStartP4 && now < icoStartP5) {
341         tokensFor1EthCurr = tokensFor1EthP4;
342       } else if(now >= icoStartP5 && now < icoStartP6) {
343         tokensFor1EthCurr = tokensFor1EthP5;
344       }
345       
346       
347 
348       tokens = sum.mul(tokensFor1EthCurr).div(1000000000000000000);  
349         
350 
351       if(token.totalSupply().add(tokens) > icoHardcap){
352 
353           tokens = icoHardcap.sub(token.totalSupply());
354 
355           rest = sum.sub(tokens.mul(1000000000000000000).div(tokensFor1EthCurr));
356       }      
357       
358 
359       token.mint(msg.sender, tokens);
360       if(rest!=0){
361           msg.sender.transfer(rest);
362       }
363       
364 
365       balances[msg.sender] = balances[msg.sender].add(sum.sub(rest));
366       
367 
368       if(token.totalSupply()>=icoSoftcap){
369 
370         multisig.transfer(address(this).balance);
371       }
372     }
373 
374     function() external payable {
375       createTokens();
376     }
377     
378 }