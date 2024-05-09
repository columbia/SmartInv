1 pragma solidity ^0.4.19;
2 
3 /**
4 * Token for SpringRole PreMint. This token is usable on the mainnet
5 * Go to https://beta.springrole.com to start!
6 * At the time of writing this contract, this token can be used for reserving vanity URL.
7 * More features will be added soon.
8 */
9 
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   uint256 public totalSupply;
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 contract StandardToken is ERC20 {
32     using SafeMath for uint256;
33 
34     mapping (address => uint256) public balances;
35     mapping (address => mapping (address => uint256)) public allowed;
36 
37     /**
38     * @dev transfer token for a specified address
39     * @param _to The address to transfer to.
40     * @param _value The amount to be transferred.
41     */
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
44         balances[msg.sender] = balances[msg.sender].sub(_value);
45         balances[_to] = balances[_to].add(_value);
46         Transfer(msg.sender, _to, _value);
47         return true;
48     }
49 
50     /**
51     * @dev Transfer tokens from one address to another
52     * @param _from address The address which you want to send tokens from
53     * @param _to address The address which you want to transfer to
54     * @param _value uint256 the amout of tokens to be transfered
55     */
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
58         balances[_to] = balances[_to].add(_value);
59         balances[_from] = balances[_from].sub(_value);
60         allowed[_from][msg.sender] -= allowed[_from][msg.sender].sub(_value);
61         Transfer(_from, _to, _value);
62         return true;
63     }
64 
65     /**
66     * @dev Gets the balance of the specified address.
67     * @param _owner The address to query the the balance of.
68     * @return An uint256 representing the amount owned by the passed address.
69     */
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     /**
75     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
76     * This only works when the allowance is 0. Cannot be used to change allowance. 
77     * https://github.com/ethereum/EIPs/issues/738#issuecomment-336277632
78     * @param _spender The address which will spend the funds.
79     * @param _value The amount of tokens to be spent.
80     */
81     function approve(address _spender, uint256 _value) returns (bool success) {
82         require(allowed[msg.sender][_spender] == 0);
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     /**
89     * @dev Function to check the amount of tokens that an owner allowed to a spender.
90     * @param _owner address The address which owns the funds.
91     * @param _spender address The address which will spend the funds.
92     * @return A uint256 specifing the amount of tokens still available for the spender.
93     */
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     /**
99      * To increment allowed value is better to use this function.
100      * From MonolithDAO Token.sol
101      */
102     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
103         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105         return true;
106     }
107 
108     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109         uint oldValue = allowed[msg.sender][_spender];
110         if (_subtractedValue > oldValue) {
111             allowed[msg.sender][_spender] = 0;
112         } else {
113             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114         }
115         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116         return true;
117     }
118 }
119 
120 contract Ownable {
121   address public owner;
122 
123 
124   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126 
127   /**
128    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
129    * account.
130    */
131   function Ownable() {
132     owner = msg.sender;
133   }
134 
135 
136   /**
137    * @dev Throws if called by any account other than the owner.
138    */
139   modifier onlyOwner() {
140     require(msg.sender == owner);
141     _;
142   }
143 
144 
145   /**
146    * @dev Allows the current owner to transfer control of the contract to a newOwner.
147    * @param newOwner The address to transfer ownership to.
148    */
149   function transferOwnership(address newOwner) onlyOwner public {
150     require(newOwner != address(0));
151     OwnershipTransferred(owner, newOwner);
152     owner = newOwner;
153   }
154 
155 }
156 
157 library SafeMath {
158   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
159     uint256 c = a * b;
160     assert(a == 0 || c / a == b);
161     return c;
162   }
163 
164   function div(uint256 a, uint256 b) internal constant returns (uint256) {
165     assert(b > 0); // Solidity automatically throws when dividing by 0
166     uint256 c = a / b;
167     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168     return c;
169   }
170 
171   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
172     assert(b <= a);
173     return a - b;
174   }
175 
176   function add(uint256 a, uint256 b) internal constant returns (uint256) {
177     uint256 c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 }
182 
183 /* Contract class for adding removing whitelisted contracts */
184 contract WhiteListedContracts is Ownable {
185   mapping (address => bool ) white_listed_contracts;
186 
187   //modifer to check if the contract given is white listed or not
188   modifier whitelistedContractsOnly() {
189     require(white_listed_contracts[msg.sender]);
190     _;
191   }
192 
193   //add a contract to whitelist
194   function addWhiteListedContracts (address _address) onlyOwner public {
195     white_listed_contracts[_address] = true;
196   }
197 
198   //remove contract from whitelist
199   function removeWhiteListedContracts (address _address) onlyOwner public {
200     white_listed_contracts[_address] = false;
201   }
202 }
203 
204 /* Contract class to mint tokens and transfer */
205 contract InviteToken is Ownable,StandardToken,WhiteListedContracts {
206   using SafeMath for uint256;
207 
208   string constant public name = 'Invite Token';
209   string constant public symbol = 'INVITE';
210   uint constant public decimals = 18;
211   uint256 public totalSupply;
212   uint256 public maxSupply;
213 
214   /* Contructor function to set maxSupply*/
215   function InviteToken(uint256 _maxSupply){
216     maxSupply = _maxSupply.mul(10**decimals);
217   }
218 
219   /*
220   do transfer function will allow transfer from a _to to _from provided if the call
221   comes from whitelisted contracts only
222   */
223   function doTransfer(address _from, address _to, uint256 _value) whitelistedContractsOnly public returns (bool){
224     require(balances[_from] >= _value && balances[_to] + _value > balances[_to]);
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232  * @dev Function to mint tokens
233  * @param _amount The amount of tokens to mint.
234  * @return A boolean that indicates if the operation was successful.
235  */
236   function mint(uint256 _amount) onlyOwner public returns (bool) {
237     require (maxSupply >= (totalSupply.add(_amount)));
238     totalSupply = totalSupply.add(_amount);
239     balances[msg.sender] = balances[msg.sender].add(_amount);
240     Transfer(address(0), msg.sender, _amount);
241     return true;
242   }
243 
244 }