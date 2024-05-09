1 /*
2 NOBLE NATION SOVEREIGN TOKEN - ISSUANCE POLICIES & TERMS OF SERVICE
3 Background
4 
5 Noble Nation is a global social, economic and political movement based around a revolutionary new crypto-block-chain technology and platform called Chakra. This platform is a cohesive and self sustaining society, economy and a governance framework bound by universal moral principles. Our technology and principles have the potential to bring about enormous positive change in our world and correct many of its existing flaws.
6 
7 Purpose of this Initial Coin Offering
8 
9 The funds raised from this ICO is to be utilized for the furtherance of the goals and objectives of our movement as detailed in our program white paper. SVT Tokens are granted to you purely as a reward for contributing to our cause and also to encourage you to be an active participant in the Noble Society, Economy and Government. 
10 
11 What Sovereign Tokens (SVT) and Sovereigns (SOV) ARE and ARE NOT
12 
13 Ownership of Sovereign tokens or the Sovereign currency implies that the holder is a member of the Noble Nation’s society and has all rights and privileges to operate within the Noble Nation platform in accordance with the constitution of the Noble Nation, including:
14 1. Participation in the noble society and the merit framework;
15 2. Participation and trade in the noble economy;
16 3. Participation in the direct democracy;
17 4. Participation in all other frameworks of Noble Nation as may be applicable.
18 
19 The acquisition of Sovereign tokens or currency and/or the participation in any of the above activities implies that the individual has pledged to abide and uphold the principles and the constitution of Noble Nation.
20 
21 Ownership of Sovereign tokens or the Sovereign currency DOES NOT in any way grant the holder any:
22 1. Ownership interest in any legal entity;
23 2. Equity interest;
24 3. Share of profits and/or losses, or assets and/or liabilities;
25 4. Status as a creditor or lender;
26 5. Claim in bankruptcy as equity interest holder or creditor;
27 6. Repayment/refund obligation from the system or the legal entity issuer.
28 
29 The Inherent Risks of the Noble Nation Project
30 
31 While the founding members have committed their lives to the cause of Noble Nation and they will endeavor to the best of their human ability to fulfill this vision, it is not possible to make any guarantee as to the final outcome of our vision and goals.
32 
33 We do not make any guarantees or representations as to the Token’s/Sovereign’s tradeability, reliability or fitness for a financial transaction – these are all dependent on market conditions within and outside the Noble Nation and the technical maturity of the platform.
34 
35 In summary, your primary motivation for participating in this ICO should be to support the vision and mission of Noble Nation and to participate in the Noble Economy, Society and Government.
36 
37 Nationals from all Countries are Welcome to Participate in the Noble Nation ICO
38 
39 However, you should not participate in this ICO if you live in a country where basic political and economic expression is suppressed and the acquisition of these tokens may violate any laws or regulations you are subject to.
40 
41 We do not screen participants by nationality as we cannot practically be expected to keep track of regulations in over 200 national jurisdictions across the the world.
42 
43 Noble Nation Network is engaged in Social, Political and Economic action in conformance with the political and economic rights guaranteed by the universal declaration of human rights while adhering to very high standards of ethics, morality and natural justice. But you are responsible for making sure that you are in conformance with applicable laws in your jurisdiction.
44 
45 Converting Sovereign Tokens (SVT) to Sovereigns in the Noble Economy
46 
47 When the beta Noble Nation platform is functional, SVT token holders will be provided instructions on creating an Identity in the Noble Nation, and how to convert SVT tokens into Sovereigns. All trade within the Noble Nation platform will utilize the currency of the Noble Economy, the Sovereign.
48 
49 To create an identity on the Noble Nation platform, the token holder must agree to honor and uphold the principles of Noble Nation. Each human individual may hold only a single Identity in the Noble Nation. At this stage, they will be required to provide identity details conforming to generally accepted KYC/AML requirements. Unlike other platforms though these details will be cryptographically protected by the privacy framework backed by the 3rd root law of the Noble Nation. 
50 
51 By contributing to this ICO, all participants confirm that:
52 
53 1. You are 18 years or above at the date of contribution.
54 2. You are not under any restrictions to use the website and participate in this ICO.
55 3. You have never been engaged in any illegal activity including but not limited to money laundering, financing of terrorism or any other activity deemed illegal by applicable law.
56 4. You further confirm that you will not be using this website, SVT Tokens or any other system or aspect of Noble Nation for any illegal activity whatsoever.
57 5. You are the absolute owner of the ethereum address and/or the crypto currency wallet used to contribute to this ICO and have full control over the same.
58 6. The address provided is a ERC-20 wallet (not an “exchange” wallet).
59 
60 Apart from the above, all participants are bound by the general Terms of Service (https://www.noblenation.net/tos) & Privacy Policy (https://www.noblenation.net/privacy-policy) of the Noble Nation Network.
61 */
62 
63 /* This file is a flattened version of OpenZeppelin (https://github.com/OpenZeppelin) 
64  * SafeMath.sol so as to fix the code base and simplify compilation in Remix etc..
65  * with no external dependencies.
66  */
67  
68  pragma solidity ^0.4.18;
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     if (a == 0) {
81       return 0;
82     }
83     uint256 c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return c;
96   }
97 
98   /**
99   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256) {
110     uint256 c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 /* This file is a flattened version of OpenZeppelin (https://github.com/OpenZeppelin) 
117  * Ownable.sol so as to fix the code base and simplify compilation in Remix etc..
118  * with no external dependencies. 
119  */
120  
121 /**
122  * @title Ownable
123  * @dev The Ownable contract has an owner address, and provides basic authorization control
124  * functions, this simplifies the implementation of "user permissions".
125  */
126 contract Ownable {
127   address public owner;
128   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() public {
135     owner = msg.sender;
136   }
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) public onlyOwner {
151     require(newOwner != address(0));
152     OwnershipTransferred(owner, newOwner);
153     owner = newOwner;
154   }
155 }
156 
157 /* This file is a flattened version of OpenZeppelin (https://github.com/OpenZeppelin) 
158  * MintableToken.sol so as to fix the code base and simplify compilation in Remix etc..
159  * with no external dependencies. 
160  */
161 
162 /****************************************************************************************
163  * @title ERC20Basic
164  * @dev Simpler version of ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/179
166  */
167 contract ERC20Basic {
168   function totalSupply() public view returns (uint256);
169   function balanceOf(address who) public view returns (uint256);
170   function transfer(address to, uint256 value) public returns (bool);
171   event Transfer(address indexed from, address indexed to, uint256 value);
172 }
173 
174 /***************************************************************************************
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender) public view returns (uint256);
180   function transferFrom(address from, address to, uint256 value) public returns (bool);
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 /***************************************************************************************
186  * @title Basic token
187  * @dev Basic version of StandardToken, with no allowances.
188  */
189 contract BasicToken is ERC20Basic {
190   using SafeMath for uint256;
191 
192   mapping(address => uint256) balances;
193 
194   uint256 totalSupply_;
195 
196   /**
197   * @dev total number of tokens in existence
198   */
199   function totalSupply() public view returns (uint256) {
200     return totalSupply_;
201   }
202 
203   /**
204   * @dev transfer token for a specified address
205   * @param _to The address to transfer to.
206   * @param _value The amount to be transferred.
207   */
208   function transfer(address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[msg.sender]);
211 
212     // SafeMath.sub will throw if there is not enough balance.
213     balances[msg.sender] = balances[msg.sender].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     Transfer(msg.sender, _to, _value);
216     return true;
217   }
218 
219   /**
220   * @dev Gets the balance of the specified address.
221   * @param _owner The address to query the the balance of.
222   * @return An uint256 representing the amount owned by the passed address.
223   */
224   function balanceOf(address _owner) public view returns (uint256 balance) {
225     return balances[_owner];
226   }
227 }
228 
229 /***************************************************************************************
230  * @title Standard ERC20 token
231  *
232  * @dev Implementation of the basic standard token.
233  * @dev https://github.com/ethereum/EIPs/issues/20
234  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
235  */
236 contract StandardToken is ERC20, BasicToken {
237 
238   mapping (address => mapping (address => uint256)) internal allowed;
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param _from address The address which you want to send tokens from
243    * @param _to address The address which you want to transfer to
244    * @param _value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
247     require(_to != address(0));
248     require(_value <= balances[_from]);
249     require(_value <= allowed[_from][msg.sender]);
250 
251     balances[_from] = balances[_from].sub(_value);
252     balances[_to] = balances[_to].add(_value);
253     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
254     Transfer(_from, _to, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
260    *
261    * Beware that changing an allowance with this method brings the risk that someone may use both the old
262    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
263    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
264    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265    * @param _spender The address which will spend the funds.
266    * @param _value The amount of tokens to be spent.
267    */
268   function approve(address _spender, uint256 _value) public returns (bool) {
269     allowed[msg.sender][_spender] = _value;
270     Approval(msg.sender, _spender, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Function to check the amount of tokens that an owner allowed to a spender.
276    * @param _owner address The address which owns the funds.
277    * @param _spender address The address which will spend the funds.
278    * @return A uint256 specifying the amount of tokens still available for the spender.
279    */
280   function allowance(address _owner, address _spender) public view returns (uint256) {
281     return allowed[_owner][_spender];
282   }
283 
284   /**
285    * @dev Increase the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To increment
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _addedValue The amount of tokens to increase the allowance by.
293    */
294   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
295     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
296     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300   /**
301    * @dev Decrease the amount of tokens that an owner allowed to a spender.
302    *
303    * approve should be called when allowed[_spender] == 0. To decrement
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _subtractedValue The amount of tokens to decrease the allowance by.
309    */
310   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
311     uint oldValue = allowed[msg.sender][_spender];
312     if (_subtractedValue > oldValue) {
313       allowed[msg.sender][_spender] = 0;
314     } else {
315       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
316     }
317     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318     return true;
319   }
320 }
321 
322 /***************************************************************************************
323  * @title Mintable token
324  * @dev Simple ERC20 Token example, with mintable token creation
325  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334   modifier canMint() {
335     require(!mintingFinished);
336     _;
337   }
338 
339   /**
340    * @dev Function to mint tokens
341    * @param _to The address that will receive the minted tokens.
342    * @param _amount The amount of tokens to mint.
343    * @return A boolean that indicates if the operation was successful.
344    */
345   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     Mint(_to, _amount);
349     Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() onlyOwner canMint public returns (bool) {
358     mintingFinished = true;
359     MintFinished();
360     return true;
361   }
362 }
363 
364 contract SovToken is MintableToken {
365   string public name = "Noble Nation Sovereign Token";
366   string public symbol = "SVT";
367   uint256 public decimals = 18;
368 
369   uint256 private constant _tradeableDate = 1529776800; // 2018 23rd June 18:00h
370   
371   //please update the following addresses before deployment
372   address private constant CONVERT_ADDRESS = 0x9376B2Ff3E68Be533bAD507D99aaDAe7180A8175; 
373   address private constant POOL = 0xE06be458ad8E80d8b8f198579E0Aa0Ce5f571294;
374   
375   event Burn(address indexed burner, uint256 value);
376 
377   function transfer(address _to, uint256 _value) public returns (bool) 
378   {
379     require(_to != address(0));
380     require(_value <= balances[msg.sender]);
381     
382     // reject transaction if the transfer is before tradeable date and
383     // the transfer is not from or to the pool
384     require(now > _tradeableDate || _to == POOL || msg.sender == POOL);
385     
386     // if the transfer address is the conversion address - burn the tokens
387     if (_to == CONVERT_ADDRESS)
388     {   
389         address burner = msg.sender;
390         balances[burner] = balances[burner].sub(_value);
391         totalSupply_ = totalSupply_.sub(_value);
392         Burn(burner, _value);
393         Transfer(msg.sender, _to, _value);
394         return true;
395     }
396     else
397     {
398         balances[msg.sender] = balances[msg.sender].sub(_value);
399         balances[_to] = balances[_to].add(_value);
400         Transfer(msg.sender, _to, _value);
401         return true;
402     }
403   }
404 }