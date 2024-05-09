1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81     /// Total amount of tokens
82   uint256 public totalSupply;
83   
84   function balanceOf(address _owner) public view returns (uint256 balance);
85   
86   function transfer(address _to, uint256 _amount) public returns (bool success);
87   
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
97   
98   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
99   
100   function approve(address _spender, uint256 _amount) public returns (bool success);
101   
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111   uint balanceOfParticipant;
112   uint lockedAmount;
113   uint allowedAmount;
114   //balance in each address account
115   mapping(address => uint256) balances;
116   struct Lockup
117   {
118       uint256 lockupTime;
119       uint256 lockupAmount;
120   }
121   Lockup lockup;
122   mapping(address=>Lockup) lockupParticipants;  
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
133      if (lockupParticipants[msg.sender].lockupAmount>0)
134     {
135         uint timePassed = now - lockupParticipants[msg.sender].lockupTime;
136         //12 months have passed
137         if (timePassed <92 days)
138         {
139             //only 5% amount is unlocked
140             balanceOfParticipant = balances[msg.sender];
141             lockedAmount = lockupParticipants[msg.sender].lockupAmount;
142             allowedAmount = lockedAmount.mul(5).div(100);
143             require(balanceOfParticipant.sub(_amount)>=lockedAmount.sub(allowedAmount));
144         }
145         //3 months have passed
146         else if (timePassed >= 92 days && timePassed < 183 days)
147         {
148             //upto 30% amount is unlocked
149             balanceOfParticipant = balances[msg.sender];
150             lockedAmount = lockupParticipants[msg.sender].lockupAmount;
151             allowedAmount = lockedAmount.mul(30).div(100);
152             require(balanceOfParticipant.sub(_amount)>=lockedAmount.sub(allowedAmount));
153         
154         }
155          //6 months have passed
156         else if (timePassed >= 183 days && timePassed < 365 days)
157         {
158             //upto 55% amount is unlocked
159             balanceOfParticipant = balances[msg.sender];
160             lockedAmount = lockupParticipants[msg.sender].lockupAmount;
161             allowedAmount = lockedAmount.mul(55).div(100);
162             require(balanceOfParticipant.sub(_amount)>=lockedAmount.sub(allowedAmount));
163         }
164         else if (timePassed > 365 days)
165         {
166             //do nothing, any amount is allowed -- all amount has been unlocked
167         }
168     }
169     // SafeMath.sub will throw if there is not enough balance.
170     balances[msg.sender] = balances[msg.sender].sub(_amount);
171     balances[_to] = balances[_to].add(_amount);
172     emit Transfer(msg.sender, _to, _amount);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256 balance) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  */
193 contract StandardToken is ERC20, BasicToken {
194   
195   
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _amount uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
206     require(_to != address(0));
207     require(balances[_from] >= _amount);
208     require(allowed[_from][msg.sender] >= _amount);
209     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
210     if (lockupParticipants[_from].lockupAmount>0)
211     {
212         uint timePassed = now - lockupParticipants[_from].lockupTime;
213         //12 months have passed
214         if (timePassed <92 days)
215         {
216             //only 5% amount is unlocked
217             balanceOfParticipant = balances[_from];
218             lockedAmount = lockupParticipants[_from].lockupAmount;
219             allowedAmount = lockedAmount.mul(5).div(100);
220             require(balanceOfParticipant.sub(_amount)>=lockedAmount.sub(allowedAmount));
221         }
222         //3 months have passed
223         else if (timePassed >= 92 days && timePassed < 183 days)
224         {
225             //upto 30% amount is unlocked
226             balanceOfParticipant = balances[_from];
227             lockedAmount = lockupParticipants[_from].lockupAmount;
228             allowedAmount = lockedAmount.mul(30).div(100);
229             require(balanceOfParticipant.sub(_amount)>=lockedAmount.sub(allowedAmount));
230         
231         }
232          //6 months have passed
233         else if (timePassed >= 183 days && timePassed < 365 days)
234         {
235             //upto 55% amount is unlocked
236             balanceOfParticipant = balances[_from];
237             lockedAmount = lockupParticipants[_from].lockupAmount;
238             allowedAmount = lockedAmount.mul(55).div(100);
239             require(balanceOfParticipant.sub(_amount)>=lockedAmount.sub(allowedAmount));
240         }
241         else if (timePassed > 365 days)
242         {
243             //do nothing, any amount is allowed -- all amount has been unlocked
244         }
245     }
246     balances[_from] = balances[_from].sub(_amount);
247     balances[_to] = balances[_to].add(_amount);
248     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
249     emit Transfer(_from, _to, _amount);
250     return true;
251   }
252 
253   /**
254    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255    *
256    * Beware that changing an allowance with this method brings the risk that someone may use both the old
257    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender The address which will spend the funds.
261    * @param _amount The amount of tokens to be spent.
262    */
263   function approve(address _spender, uint256 _amount) public returns (bool success) {
264     allowed[msg.sender][_spender] = _amount;
265     emit Approval(msg.sender, _spender, _amount);
266     return true;
267   }
268 
269   /**
270    * @dev Function to check the amount of tokens that an owner allowed to a spender.
271    * @param _owner address The address which owns the funds.
272    * @param _spender address The address which will spend the funds.
273    * @return A uint256 specifying the amount of tokens still available for the spender.
274    */
275   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
276     return allowed[_owner][_spender];
277   }
278 
279 }
280 
281 /**
282  * @title Burnable Token
283  * @dev Token that can be irreversibly burned (destroyed).
284  */
285 contract BurnableToken is StandardToken, Ownable {
286 
287     event Burn(address indexed burner, uint256 value);
288 
289     /**
290      * @dev Burns a specific amount of tokens.
291      * @param _value The amount of token to be burned.
292      */
293     function burn(uint256 _value) public onlyOwner{
294         require(_value <= balances[msg.sender]);
295         // no need to require value <= totalSupply, since that would imply the
296         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
297 
298         balances[msg.sender] = balances[msg.sender].sub(_value);
299         totalSupply = totalSupply.sub(_value);
300         emit Burn(msg.sender, _value);
301     }
302 }
303 /**
304  * @title PVC Token
305  * @dev Token representing PVC.
306  */
307  contract PVCToken is BurnableToken {
308      string public name ;
309      string public symbol ;
310      uint8 public decimals = 18 ;
311      
312      /**
313      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
314      */
315      function ()public payable {
316          revert();
317      }
318      
319      /**
320      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
321      */
322      function PVCToken(address wallet) public {
323          owner = wallet;
324          totalSupply = uint(50000000).mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
325          name = "Pryvate";
326          symbol = "PVC";
327          balances[wallet] = totalSupply;
328          
329          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
330          emit Transfer(address(0), msg.sender, totalSupply);
331      }
332      
333      /**
334      *@dev helper method to get token details, name, symbol and totalSupply in one go
335      */
336     function getTokenDetail() public view returns (string, string, uint256) {
337       return (name, symbol, totalSupply);
338     }
339 
340     function teamVesting(address[] teamMembers, uint[] tokens) public onlyOwner
341      {
342          require(teamMembers.length == tokens.length);
343          for (uint i=0;i<teamMembers.length;i++)
344          {
345              tokens[i] = tokens[i].mul(10**18);
346               require(teamMembers[i] != address(0));
347               require(balances[owner] >= tokens[i] && tokens[i] > 0
348             && balances[teamMembers[i]].add(tokens[i]) > balances[teamMembers[i]]);
349 
350             // SafeMath.sub will throw if there is not enough balance.
351             balances[owner] = balances[owner].sub(tokens[i]);
352             balances[teamMembers[i]] = balances[teamMembers[i]].add(tokens[i]);
353             emit Transfer(owner, teamMembers[i], tokens[i]);
354             lockup = Lockup({lockupTime:now,lockupAmount:tokens[i]});
355             lockupParticipants[teamMembers[i]] = lockup;
356          }
357      }
358      
359      function advisorVesting(address[] advisors, uint[] tokens) public onlyOwner
360      {
361          require(advisors.length == tokens.length);
362          for (uint i=0;i<advisors.length;i++)
363          {
364              tokens[i] = tokens[i].mul(10**18);
365               require(advisors[i] != address(0));
366               require(balances[owner] >= tokens[i] && tokens[i] > 0
367             && balances[advisors[i]].add(tokens[i]) > balances[advisors[i]]);
368 
369             // SafeMath.sub will throw if there is not enough balance.
370             balances[owner] = balances[owner].sub(tokens[i]);
371             balances[advisors[i]] = balances[advisors[i]].add(tokens[i]);
372             emit Transfer(owner, advisors[i], tokens[i]);
373             lockup = Lockup({lockupTime:now,lockupAmount:tokens[i]});
374             lockupParticipants[advisors[i]] = lockup;
375          }
376      }
377  }