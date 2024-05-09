1 pragma solidity 0.4.24;
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
111 
112  struct TokenVest
113     {
114         address vestAddress;
115         uint vestTokensLimit;
116         uint vestTill;
117     }
118   //balance in each address account
119   mapping(address => uint256) balances;
120   
121   // list of tokens vest
122   TokenVest[] listofVest;
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _amount The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _amount) public returns (bool success) {
130     require(isTransferAllowed(msg.sender,_amount));
131     require(_to != address(0));
132     require(balances[msg.sender] >= _amount && _amount > 0
133         && balances[_to].add(_amount) > balances[_to]);
134 
135     // SafeMath.sub will throw if there is not enough balance.
136     balances[msg.sender] = balances[msg.sender].sub(_amount);
137     balances[_to] = balances[_to].add(_amount);
138     emit Transfer(msg.sender, _to, _amount);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 
151     function isTransferAllowed(address trans_from, uint amt) internal returns(bool)
152     {
153         for(uint i=0;i<listofVest.length;i++)
154         {
155             if(listofVest[i].vestAddress==trans_from)
156             {
157                 if(now<=listofVest[i].vestTill)
158                 {
159                     if((balanceOf(trans_from).sub(amt)<listofVest[i].vestTokensLimit))
160                     {
161                         return false;
162                     }
163                 }
164             }
165         }
166         return true;
167     }
168 }
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  */
176 contract StandardToken is ERC20, BasicToken {
177   
178   
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _amount uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
189     require(isTransferAllowed(_from,_amount));
190     require(_to != address(0));
191     require(balances[_from] >= _amount);
192     require(allowed[_from][msg.sender] >= _amount);
193     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
194 
195     balances[_from] = balances[_from].sub(_amount);
196     balances[_to] = balances[_to].add(_amount);
197     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
198     emit Transfer(_from, _to, _amount);
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    *
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param _spender The address which will spend the funds.
210    * @param _amount The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _amount) public returns (bool success) {
213     allowed[msg.sender][_spender] = _amount;
214     emit Approval(msg.sender, _spender, _amount);
215     return true;
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifying the amount of tokens still available for the spender.
223    */
224   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
225     return allowed[_owner][_spender];
226   }
227 
228 }
229 
230 /**
231  * @title Burnable Token
232  * @dev Token that can be irreversibly burned (destroyed).
233  */
234 contract BurnableToken is StandardToken, Ownable {
235 
236     event Burn(address indexed burner, uint256 value);
237 
238     /**
239      * @dev Burns a specific amount of tokens.
240      * @param _value The amount of token to be burned.
241      */
242     function burn(uint256 _value) public onlyOwner{
243         require(_value <= balances[msg.sender]);
244         // no need to require value <= totalSupply, since that would imply the
245         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
246 
247         balances[msg.sender] = balances[msg.sender].sub(_value);
248         totalSupply = totalSupply.sub(_value);
249         emit Burn(msg.sender, _value);
250     }
251 }
252 /**
253  * @title EthereumTravelToken Token
254  * @dev 
255  */
256  contract EthereumTravelToken is BurnableToken {
257      
258      
259      string public name ;
260      string public symbol ;
261      uint8 public decimals = 18 ;
262      address public AdvisorsAddress;
263      address public TeamAddress;
264      address public ReserveAddress;
265      
266      TokenVest vestObject;
267      uint public TeamVestTimeLimit;
268     
269      
270      /**
271      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
272      */
273      function ()public payable {
274          revert();
275      }
276      
277      /**
278      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
279      */
280      function EthereumTravelToken(
281             address wallet,
282             uint supply,
283             string nam, 
284             string symb
285             ) public {
286          owner = wallet;
287          totalSupply = supply;
288          totalSupply = totalSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
289          name = nam;
290          symbol = symb;
291          balances[wallet] = totalSupply;
292          TeamAddress=0xACE8841DF22F7b5d112db5f5AE913c7adA3457aF;
293          AdvisorsAddress=0x49695C3cB19aA4A32F6f465b54CE62e337A07c7b;
294          ReserveAddress=0xec599e12B45BB77B65291C30911d9B2c3991aB3D;
295          TeamVestTimeLimit = now + 365 days;
296          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
297          emit Transfer(address(0), msg.sender, totalSupply);
298          
299          // transferring 18% of the tokens to team Address
300          transfer(TeamAddress, (totalSupply.mul(18)).div(100));
301          
302          // transferring 1% of the tokens to advisors Address
303          transfer(AdvisorsAddress, (totalSupply.mul(1)).div(100));
304          
305          // transferring 21% of the tokens to company Address
306          transfer(ReserveAddress, (totalSupply.mul(21)).div(100));
307          
308          // vesting team address
309          vestTokens(TeamAddress,(totalSupply.mul(18)).div(100),TeamVestTimeLimit);
310      }
311      
312      /**
313      *@dev helper method to get token details, name, symbol and totalSupply in one go
314      */
315     function getTokenDetail() public view returns (string, string, uint256) {
316       return (name, symbol, totalSupply);
317     }
318     /**
319      *@dev internal method to add a vest in token memory
320      */
321      function vestTokens(address ad, uint tkns, uint timelimit) internal {
322       vestObject = TokenVest({
323           vestAddress:ad,
324           vestTokensLimit:tkns,
325           vestTill:timelimit
326       });
327       listofVest.push(vestObject);
328     }
329  }