1 pragma solidity 0.4.24;
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
51     constructor() public {
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
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81     /// Total amount of tokens
82     uint256 public totalSupply;
83   
84     function balanceOf(address _owner) public view returns (uint256 balance);
85   
86     function transfer(address _to, uint256 _amount) public returns (bool success);
87   
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
97   
98     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
99   
100     function approve(address _spender, uint256 _amount) public returns (bool success);
101   
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110     using SafeMath for uint256;
111 
112   //balance in each address account
113     mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _amount The amount to be transferred.
119   */
120     function transfer(address _to, uint256 _amount) public returns (bool success) {
121         require(_to != address(0));
122         require(balances[msg.sender] >= _amount && _amount > 0
123         && balances[_to].add(_amount) > balances[_to]);
124 
125         // SafeMath.sub will throw if there is not enough balance.
126         balances[msg.sender] = balances[msg.sender].sub(_amount);
127         balances[_to] = balances[_to].add(_amount);
128         emit Transfer(msg.sender, _to, _amount);
129         return true;
130     }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137     function balanceOf(address _owner) public view returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  */
149 contract StandardToken is ERC20, BasicToken {
150   
151   
152     mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _amount uint256 the amount of tokens to be transferred
160    */
161     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
162         require(_to != address(0));
163         require(balances[_from] >= _amount);
164         require(allowed[_from][msg.sender] >= _amount);
165         require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
166 
167         balances[_from] = balances[_from].sub(_amount);
168         balances[_to] = balances[_to].add(_amount);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
170         emit Transfer(_from, _to, _amount);
171         return true;
172     }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _amount The amount of tokens to be spent.
183    */
184     function approve(address _spender, uint256 _amount) public returns (bool success) {
185         allowed[msg.sender][_spender] = _amount;
186         emit Approval(msg.sender, _spender, _amount);
187         return true;
188     }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
197         return allowed[_owner][_spender];
198     }
199 
200 }
201 
202 contract MintableToken is StandardToken, Ownable {
203   
204     event Mint(address indexed to, uint256 amount);
205     event MintFinished();
206 
207     bool public mintingFinished = false;
208 
209 
210     modifier canMint() {
211         require(!mintingFinished);
212         _;
213     }
214 
215   /**
216    * @dev Function to mint tokens
217    * @param _to The address that will receive the minted tokens.
218    * @param _amount The amount of tokens to mint.
219    * @return A boolean that indicates if the operation was successful.
220    */
221     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
222 
223         totalSupply = totalSupply.add(_amount);
224         balances[_to] = balances[_to].add(_amount);
225         emit Mint(_to, _amount);
226         emit Transfer(address(0), _to, _amount);
227         return true;
228 
229     }
230 
231   /**
232    * @dev Function to stop minting new tokens.
233    * @return True if the operation was successful.
234    */
235     function finishMinting() onlyOwner canMint public returns (bool) {
236         mintingFinished = true;
237         emit MintFinished();
238         return true;
239     }
240 }
241 /**
242  * @title BLOCKER Token
243  * @dev Token representing BLOCKER.
244  */
245 contract BLOCKERToken is MintableToken {
246     string public name ;
247     string public symbol ;
248     uint8 public decimals = 18 ;
249      
250      /**
251      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
252      */
253     function ()public payable {
254         revert();
255     }
256      
257      /**
258      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
259      * @param initialSupply The initial supply of tokens which will be fixed through out
260      * @param tokenName The name of the token
261      * @param tokenSymbol The symboll of the token
262      */
263     constructor(
264         uint256 initialSupply,
265         string tokenName,
266         string tokenSymbol) public {
267         totalSupply = initialSupply.mul( 10 ** uint256(decimals)); //Update total supply with the decimal amount
268         name = tokenName;
269         symbol = tokenSymbol;
270         balances[msg.sender] = totalSupply;
271          
272          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
273         emit Transfer(address(0), msg.sender, totalSupply);
274     }
275      
276      /**
277      *@dev helper method to get token details, name, symbol and totalSupply in one go
278      */
279     function getTokenDetail() public view returns (string, string, uint256) {
280 
281         return (name, symbol, totalSupply);
282     }
283 }