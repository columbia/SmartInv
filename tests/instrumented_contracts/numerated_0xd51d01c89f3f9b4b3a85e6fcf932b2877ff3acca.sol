1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12     }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51     function Ownable() public {
52         owner = msg.sender;
53     }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67     function transferOwnership(address newOwner) public onlyOwner {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/179
78  */
79 contract ERC20Basic {
80     /// Total amount of tokens
81     uint256 public totalSupply;
82   
83     function balanceOf(address _owner) public view returns (uint256 balance);
84   
85     function transfer(address _to, uint256 _amount) public returns (bool success);
86   
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
96   
97     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
98   
99     function approve(address _spender, uint256 _amount) public returns (bool success);
100   
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic {
109     using SafeMath for uint256;
110 
111   //balance in each address account
112     mapping(address => uint256) balances;
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _amount The amount to be transferred.
118   */
119     function transfer(address _to, uint256 _amount) public returns (bool success) {
120         require(_to != address(0));
121         require(balances[msg.sender] >= _amount && _amount > 0
122         && balances[_to].add(_amount) > balances[_to]);
123 
124         // SafeMath.sub will throw if there is not enough balance.
125         balances[msg.sender] = balances[msg.sender].sub(_amount);
126         balances[_to] = balances[_to].add(_amount);
127         emit Transfer(msg.sender, _to, _amount);
128         return true;
129     }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136     function balanceOf(address _owner) public view returns (uint256 balance) {
137         return balances[_owner];
138     }
139 
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  */
148 contract StandardToken is ERC20, BasicToken {
149   
150   
151     mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _amount uint256 the amount of tokens to be transferred
159    */
160     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
161         require(_to != address(0));
162         require(balances[_from] >= _amount);
163         require(allowed[_from][msg.sender] >= _amount);
164         require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
165 
166         balances[_from] = balances[_from].sub(_amount);
167         balances[_to] = balances[_to].add(_amount);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
169         emit Transfer(_from, _to, _amount);
170         return true;
171     }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _amount The amount of tokens to be spent.
182    */
183     function approve(address _spender, uint256 _amount) public returns (bool success) {
184         allowed[msg.sender][_spender] = _amount;
185         emit Approval(msg.sender, _spender, _amount);
186         return true;
187     }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
196         return allowed[_owner][_spender];
197     }
198 
199 }
200 
201 /**
202  * @title Burnable Token
203  * @dev Token that can be irreversibly burned (destroyed).
204  */
205 contract BurnableToken is StandardToken, Ownable {
206 
207     //this will contain a list of addresses allowed to burn their tokens
208     mapping(address=>bool)allowedBurners;
209     
210     event Burn(address indexed burner, uint256 value);
211     
212     event BurnerAdded(address indexed burner);
213     
214     event BurnerRemoved(address indexed burner);
215     
216     //check whether the burner is eligible burner
217     modifier isBurner(address _burner){
218         require(allowedBurners[_burner]);
219         _;
220     }
221     
222     /**
223     *@dev Method to add eligible addresses in the list of burners. Since we need to burn all tokens left with the sales contract after the sale has ended. The sales contract should
224     * be an eligible burner. The owner has to add the sales address in the eligible burner list.
225     * @param _burner Address of the eligible burner
226     */
227     function addEligibleBurner(address _burner)public onlyOwner {
228         
229         require(_burner != address(0));
230         allowedBurners[_burner] = true;
231         emit BurnerAdded(_burner);
232     }
233     
234      /**
235     *@dev Method to remove addresses from the list of burners
236     * @param _burner Address of the eligible burner to be removed
237     */
238     function removeEligibleBurner(address _burner)public onlyOwner isBurner(_burner) {
239         
240         allowedBurners[_burner] = false;
241         emit BurnerRemoved(_burner);
242     }
243     
244     /**
245      * @dev Burns all tokens of the eligible burner
246      */
247     function burnAllTokens() public isBurner(msg.sender) {
248         
249         require(balances[msg.sender]>0);
250         
251         uint256 value = balances[msg.sender];
252         
253         totalSupply = totalSupply.sub(value);
254 
255         balances[msg.sender] = 0;
256         
257         emit Burn(msg.sender, value);
258     }
259 }
260 
261 contract MintableToken is StandardToken, Ownable {
262   
263     event Mint(address indexed to, uint256 amount);
264     event MintFinished();
265 
266     bool public mintingFinished = false;
267 
268 
269     modifier canMint() {
270         require(!mintingFinished);
271         _;
272     }
273 
274   /**
275    * @dev Function to mint tokens
276    * @param _to The address that will receive the minted tokens.
277    * @param _amount The amount of tokens to mint.
278    * @return A boolean that indicates if the operation was successful.
279    */
280     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281 
282         totalSupply = totalSupply.add(_amount);
283         balances[_to] = balances[_to].add(_amount);
284         emit Mint(_to, _amount);
285         emit Transfer(address(0), _to, _amount);
286         return true;
287 
288     }
289 
290   /**
291    * @dev Function to stop minting new tokens.
292    * @return True if the operation was successful.
293    */
294     function finishMinting() onlyOwner canMint public returns (bool) {
295         mintingFinished = true;
296         emit MintFinished();
297         return true;
298     }
299 }
300 /**
301  * @title Antriex Token
302  * @dev Token representing DRONE.
303  */
304 contract AntriexToken is BurnableToken, MintableToken {
305     string public name ;
306     string public symbol ;
307     uint8 public decimals = 18 ;
308      
309      /**
310      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
311      */
312     function ()public payable {
313         revert();
314     }
315      
316      /**
317      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
318      * @param initialSupply The initial supply of tokens which will be fixed through out
319      * @param tokenName The name of the token
320      * @param tokenSymbol The symboll of the token
321      */
322     function AntriexToken(
323         uint256 initialSupply,
324         string tokenName,
325         string tokenSymbol) public {
326         totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
327         name = tokenName;
328         symbol = tokenSymbol;
329         balances[msg.sender] = totalSupply;
330          
331          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
332         emit Transfer(address(0), msg.sender, totalSupply);
333     }
334      
335      /**
336      *@dev helper method to get token details, name, symbol and totalSupply in one go
337      */
338     function getTokenDetail() public view returns (string, string, uint256) {
339 
340         return (name, symbol, totalSupply);
341     }
342 }