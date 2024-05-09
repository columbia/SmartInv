1 pragma solidity ^0.4.19;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     emit OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79     /// Total amount of tokens
80   uint256 public totalSupply;
81   
82   function balanceOf(address _owner) public view returns (uint256 balance);
83   
84   function transfer(address _to, uint256 _amount) public returns (bool success);
85   
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
95   
96   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
97   
98   function approve(address _spender, uint256 _amount) public returns (bool success);
99   
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   //balance in each address account
111   mapping(address => uint256) balances;
112   address ownerWallet;
113   struct Lockup
114   {
115       uint256 lockupTime;
116       uint256 lockupAmount;
117   }
118   Lockup lockup;
119   mapping(address=>Lockup) lockupParticipants;  
120   
121   
122   uint256 startTime;
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _amount The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _amount) public returns (bool success) {
129     require(_to != address(0));
130     require(balances[msg.sender] >= _amount && _amount > 0
131         && balances[_to].add(_amount) > balances[_to]);
132 
133     if (lockupParticipants[msg.sender].lockupAmount>0)
134     {
135         uint timePassed = now - startTime;
136         if (timePassed < lockupParticipants[msg.sender].lockupTime)
137         {
138             require(balances[msg.sender].sub(_amount) >= lockupParticipants[msg.sender].lockupAmount);
139         }
140     }
141     // SafeMath.sub will throw if there is not enough balance.
142     balances[msg.sender] = balances[msg.sender].sub(_amount);
143     balances[_to] = balances[_to].add(_amount);
144     emit Transfer(msg.sender, _to, _amount);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256 balance) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  */
165 contract StandardToken is ERC20, BasicToken {
166   
167   
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _amount uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
178     require(_to != address(0));
179     require(balances[_from] >= _amount);
180     require(allowed[_from][msg.sender] >= _amount);
181     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
182     
183     if (lockupParticipants[_from].lockupAmount>0)
184     {
185         uint timePassed = now - startTime;
186         if (timePassed < lockupParticipants[_from].lockupTime)
187         {
188             require(balances[msg.sender].sub(_amount) >= lockupParticipants[_from].lockupAmount);
189         }
190     }
191     balances[_from] = balances[_from].sub(_amount);
192     balances[_to] = balances[_to].add(_amount);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
194     emit Transfer(_from, _to, _amount);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _amount The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _amount) public returns (bool success) {
209     allowed[msg.sender][_spender] = _amount;
210     emit Approval(msg.sender, _spender, _amount);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
221     return allowed[_owner][_spender];
222   }
223 
224 }
225 
226 /**
227  * @title Burnable Token
228  * @dev Token that can be irreversibly burned (destroyed).
229  */
230 contract BurnableToken is StandardToken, Ownable {
231 
232     event Burn(address indexed burner, uint256 value);
233 
234     /**
235      * @dev Burns a specific amount of tokens.
236      * @param _value The amount of token to be burned.
237      */
238     function burn(uint256 _value) public onlyOwner{
239         require(_value <= balances[ownerWallet]);
240         // no need to require value <= totalSupply, since that would imply the
241         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
242 
243         balances[ownerWallet] = balances[ownerWallet].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         emit Burn(msg.sender, _value);
246     }
247 }
248 /**
249  * @title DayDay Token
250  * @dev Token representing DD.
251  */
252  contract DayDayToken is BurnableToken {
253      string public name ;
254      string public symbol ;
255      uint8 public decimals =  2;
256      
257    
258      /**
259      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
260      */
261      function ()public payable {
262          revert();
263      }
264      
265      /**
266      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
267      */
268      function DayDayToken(address wallet) public 
269      {
270          owner = msg.sender;
271          ownerWallet = wallet;
272          totalSupply = 300000000000;
273          totalSupply = totalSupply.mul(10 ** uint256(decimals)); //Update total supply with the decimal amount
274          name = "DayDayToken";
275          symbol = "DD";
276          balances[wallet] = totalSupply;
277          startTime = now;
278          
279          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
280          emit Transfer(address(0), msg.sender, totalSupply);
281      }
282      
283      /**
284      *@dev helper method to get token details, name, symbol and totalSupply in one go
285      */
286     function getTokenDetail() public view returns (string, string, uint256) {
287 	    return (name, symbol, totalSupply);
288     }
289     
290      
291     function lockTokensForFs (address F1, address F2) public onlyOwner
292     {
293         lockup = Lockup({lockupTime:720 days,lockupAmount:90000000 * 10 ** uint256(decimals)});
294         lockupParticipants[F1] = lockup;
295         
296         lockup = Lockup({lockupTime:720 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
297         lockupParticipants[F2] = lockup;
298     }
299     function lockTokensForAs( address A1, address A2, 
300                          address A3, address A4,
301                          address A5, address A6,
302                          address A7, address A8,
303                          address A9) public onlyOwner
304     {
305         lockup = Lockup({lockupTime:180 days,lockupAmount:90000000 * 10 ** uint256(decimals)});
306         lockupParticipants[A1] = lockup;
307         
308         lockup = Lockup({lockupTime:180 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
309         lockupParticipants[A2] = lockup;
310         
311         lockup = Lockup({lockupTime:180 days,lockupAmount:30000000 * 10 ** uint256(decimals)});
312         lockupParticipants[A3] = lockup;
313         
314         lockup = Lockup({lockupTime:180 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
315         lockupParticipants[A4] = lockup;
316         
317         lockup = Lockup({lockupTime:180 days,lockupAmount:60000000 * 10 ** uint256(decimals)});
318         lockupParticipants[A5] = lockup;
319         
320         lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
321         lockupParticipants[A6] = lockup;
322         
323         lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
324         lockupParticipants[A7] = lockup;
325         
326         lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
327         lockupParticipants[A8] = lockup;
328         
329         lockup = Lockup({lockupTime:180 days,lockupAmount:15000000 * 10 ** uint256(decimals)});
330         lockupParticipants[A9] = lockup;
331     }
332     
333     function lockTokensForCs(address C1,address C2, address C3) public onlyOwner
334     {
335         lockup = Lockup({lockupTime:90 days,lockupAmount:2500000 * 10 ** uint256(decimals)});
336         lockupParticipants[C1] = lockup;
337         
338         lockup = Lockup({lockupTime:90 days,lockupAmount:1000000 * 10 ** uint256(decimals)});
339         lockupParticipants[C2] = lockup;
340         
341         lockup = Lockup({lockupTime:90 days,lockupAmount:1500000 * 10 ** uint256(decimals)});
342         lockupParticipants[C3] = lockup;   
343     }
344     
345     function lockTokensForTeamAndReserve(address team) public onlyOwner
346     {
347         lockup = Lockup({lockupTime:360 days,lockupAmount:63000000 * 10 ** uint256(decimals)});
348         lockupParticipants[team] = lockup;
349         
350         lockup = Lockup({lockupTime:720 days,lockupAmount:415000000 * 10 ** uint256(decimals)});
351         lockupParticipants[ownerWallet] = lockup;
352     }
353  }