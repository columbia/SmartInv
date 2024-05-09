1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     if (a == 0) {
28       return 0;
29     }
30     c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70   address public owner;
71 
72 
73   event OwnershipRenounced(address indexed previousOwner);
74   event OwnershipTransferred(
75     address indexed previousOwner,
76     address indexed newOwner
77   );
78 
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() public {
85     owner = msg.sender;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     emit OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106   /**
107    * @dev Allows the current owner to relinquish control of the contract.
108    */
109   function renounceOwnership() public onlyOwner {
110     emit OwnershipRenounced(owner);
111     owner = address(0);
112   }
113 }
114 
115   /**
116   * @title ForeignToken
117   * @dev Enables smart contract to hold and send other ERC20 tokens.
118   */
119 contract ForeignToken {
120   function balanceOf(address _owner) public view returns (uint256);
121   function transfer(address _to, uint256 _value) public returns (bool);
122 }
123 
124   contract Eurno is ERC20Basic, Ownable, ForeignToken {
125     using SafeMath for uint256;
126 
127     string public constant name = "Eurno";
128     string public constant symbol = "ENO";
129     uint public constant decimals = 8;
130     uint256 public totalSupply = 28e14;
131     uint256 internal functAttempts;
132 
133     event Transfer(address indexed _from, address indexed _to, uint256 _value); // Define the transfer event
134     event Burn(address indexed burner, uint256 value);
135 
136     mapping(address => uint256) balances;
137     mapping(address => mapping (address => uint256)) internal allowed;
138    
139     /**
140      * @dev modifier to limit the number of times a function can be called to once. 
141      */
142     modifier onlyOnce(){
143         require(functAttempts <= 0);
144         _;
145     }
146 
147   /**
148   * @dev Constructor function to start the Eurno token chain.
149   * Transfer's the owner's wallet with the development fund of 5 million tokens.
150   */
151   constructor() public {
152     balances[msg.sender] = balances[msg.sender].add(totalSupply); // Update balances on the Ledger.
153     emit Transfer(this, owner, totalSupply); // Transfer owner 5 mil dev fund.
154   }
155   
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply;
161   }
162 
163   /**
164   * @dev transfer token for a specified address.
165   * 
166   * Using onlyPayloadSize to prevent short address attack
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[msg.sender]);
173 
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     emit Transfer(msg.sender, _to, _value);
177     return true;
178   }
179   
180   /**
181    * @dev Allows the owner of the contract to distribute to other contracts. 
182    * Used, for example, to distribute the airdrop balance to the airdrop contract.
183    * 
184    * @param _to is the address of the contract.
185    * @param _value is the amount of ENO to send to it.
186    */
187   function distAirdrop(address _to, uint256 _value) onlyOwner onlyOnce public returns (bool) {
188     require(_value <= balances[msg.sender]);
189     balances[msg.sender] = balances[msg.sender].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     emit Transfer(msg.sender, _to, _value);
192     functAttempts = 1;
193     return true;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param _owner The address to query the the balance of.
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address _owner) public view returns (uint256) {
202     return balances[_owner];
203   }
204   
205   /**
206    * @dev Function to withdraw foreign tokens stored in this contract.
207    * 
208    * @param _tokenContract is the smart contract address of the token to be withdrawn.
209    */ 
210   function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
211     ForeignToken token = ForeignToken(_tokenContract);
212     uint256 amount = token.balanceOf(address(this));
213     return token.transfer(owner, amount);
214     }
215 
216   /**
217    * @dev Fallback function to allow the contract to accept Eth donations.
218    */
219   function() public payable {
220   }
221   
222   /**
223    * @dev Function to allow contract owner to withdraw Ethereum deposited to the Eurno contract.
224    */
225   function withdraw() onlyOwner public {
226     uint256 etherBalance = address(this).balance;
227     owner.transfer(etherBalance);
228     }
229     
230   /**
231    * @dev Burns a specific amount of tokens. Can only be called by contract owner.
232    * 
233    * @param _value The amount of token to be burned.
234    */
235   function burn(uint256 _value) onlyOwner public {
236     _burn(msg.sender, _value);
237   }
238   
239   /**
240    * @dev actual function to burn tokens.
241    * 
242    * @param _who is the address of the person burning tokens.
243    * @param _value is the number of tokens burned.
244    */
245   function _burn(address _who, uint256 _value) internal {
246     require(_value <= balances[_who]);
247     // no need to require value <= totalSupply, since that would imply the
248     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
249 
250     balances[_who] = balances[_who].sub(_value);
251     totalSupply = totalSupply.sub(_value);
252     emit Burn(_who, _value);
253     emit Transfer(_who, address(0), _value);
254   }
255 
256 }