1 pragma solidity 0.4.23;
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
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43     /// Total amount of tokens
44     uint256 public totalSupply;
45   
46     function balanceOf(address _owner) public view returns (uint256);
47   
48     function transfer(address _to, uint256 _amount) public returns (bool);
49   
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58     function allowance(address _owner, address _spender) public view returns (uint256);
59   
60     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool);
61   
62     function approve(address _spender, uint256 _amount) public returns (bool);
63   
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72     using SafeMath for uint256;
73 
74   //balance in each address account
75     mapping(address => uint256) balances;
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _amount The amount to be transferred.
81   */
82     function transfer(address _to, uint256 _amount) public returns (bool) {
83         require(_to != address(0));
84         require(balances[msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]);
85 
86         // SafeMath.sub will throw if there is not enough balance.
87         balances[msg.sender] = balances[msg.sender].sub(_amount);
88         balances[_to] = balances[_to].add(_amount);
89         emit Transfer(msg.sender, _to, _amount);
90         return true;
91     }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102 }
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  */
110 contract StandardToken is ERC20, BasicToken {
111   
112   
113     mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _amount uint256 the amount of tokens to be transferred
121    */
122     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
123         require(_to != address(0));
124         require(balances[_from] >= _amount);
125         require(allowed[_from][msg.sender] >= _amount);
126         require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
127 
128         balances[_from] = balances[_from].sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
131         emit Transfer(_from, _to, _amount);
132         return true;
133     }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _amount The amount of tokens to be spent.
144    */
145     function approve(address _spender, uint256 _amount) public returns (bool) {
146         allowed[msg.sender][_spender] = _amount;
147         emit Approval(msg.sender, _spender, _amount);
148         return true;
149     }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157     function allowance(address _owner, address _spender) public view returns (uint256) {
158         return allowed[_owner][_spender];
159     }
160 
161 }
162 /**
163  * @title Burnable Token
164  * @dev Token that can be irreversibly burned (destroyed).
165  */
166 contract BurnableToken is StandardToken {
167 
168     event Burn(address indexed burner, uint256 value);
169 
170     /**
171      * @dev Burns a specific amount of tokens.
172      * @param _value The amount of token to be burned.
173      */
174     function burn(uint256 _value) public {
175         require(_value <= balances[msg.sender]);
176         // no need to require value <= totalSupply, since that would imply the
177         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
178 
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         totalSupply = totalSupply.sub(_value);
181         emit Burn(msg.sender, _value);
182     }
183 }
184 
185 /**
186  * @title Ownable
187  * @dev The Ownable contract has an owner address, and provides basic authorization control
188  * functions, this simplifies the implementation of "user permissions".
189  */
190 contract Ownable {
191     address public owner;
192 
193 
194   /**
195    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196    * account.
197    */
198     constructor()public {
199         owner = msg.sender;
200     }
201 
202 
203   /**
204    * @dev Throws if called by any account other than the owner.
205    */
206     modifier onlyOwner() {
207         require(msg.sender == owner);
208         _;
209     }
210 
211 
212   /**
213    * @dev Allows the current owner to transfer control of the contract to a newOwner.
214    * @param newOwner The address to transfer ownership to.
215    */
216     function transferOwnership(address newOwner)public onlyOwner {
217         if (newOwner != address(0)) {
218             owner = newOwner;
219         }
220     }
221 }
222 
223 contract MintableToken is StandardToken, Ownable {
224     event Mint(address indexed to, uint256 amount);
225     event MintFinished();
226 
227     bool public mintingFinished = false;
228 
229 
230     modifier canMint() {
231         require(!mintingFinished);
232         _;
233     }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will receive the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242         totalSupply = totalSupply.add(_amount);
243         balances[_to] = balances[_to].add(_amount);
244         emit Mint(_to, _amount);
245         emit Transfer(address(0), _to, _amount);
246         return true;
247     }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253     function finishMinting() onlyOwner canMint public returns (bool) {
254         mintingFinished = true;
255         emit MintFinished();
256         return true;
257     }
258 }
259 
260 /**
261  * @title VCT Token
262  * @dev Token representing VCT.
263  */
264 contract VCTToken is BurnableToken,Ownable,MintableToken {
265     string public name ;
266     string public symbol ;
267     uint8 public decimals = 18 ;
268      
269      /**
270      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
271      */
272     function ()public payable {
273         revert("Sending ether to the contract is not allowed");
274     }
275      
276      /**
277      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
278      * @param initialSupply The initial supply of tokens which will be fixed through out
279      * @param tokenName The name of the token
280      * @param tokenSymbol The symbol of the token
281      */
282     constructor(
283         uint256 initialSupply,
284         string tokenName,
285         string tokenSymbol
286         ) public {
287         totalSupply = initialSupply * 10 ** uint256(decimals); //Update total supply with the decimal amount
288         name = tokenName;
289         symbol = tokenSymbol;
290         balances[msg.sender] = totalSupply;
291          
292         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
293         emit Transfer(address(0), msg.sender, totalSupply);
294     }
295      
296      /**
297      * @dev allows token holders to send tokens to multiple addresses from one single transaction
298      * Beware that sending tokens to large number of addresses in one transaction might exceed gas limit of the 
299      * transaction or even for the entire block. Not putting any restriction on the number of addresses which are
300      * allowed per transaction. But it should be taken into account while creating dapps.
301      * @param dests The addresses to whom user wants to send tokens
302      * @param values The number of tokens to be sent to each address
303      */
304     function multiSend(address[]dests, uint[]values)public{
305         require(dests.length==values.length, "Number of addresses and values should be same");
306         uint256 i = 0;
307         while (i < dests.length) {
308             transfer(dests[i], values[i]);
309             i += 1;
310         }
311     }
312      
313      /**
314      *@dev helper method to get token details, name, symbol and totalSupply in one go
315      */
316     function getTokenDetail() public view returns (string, string, uint256) {
317         return (name, symbol, totalSupply);
318     }
319 }