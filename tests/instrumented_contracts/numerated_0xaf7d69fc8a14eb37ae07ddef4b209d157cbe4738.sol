1 pragma solidity ^0.4.17;
2 
3 interface Deployer_Interface {
4   function newContract(address _party, address user_contract, uint _start_date) public payable returns (address created);
5   function newToken() public returns (address created);
6 }
7 
8 interface DRCT_Token_Interface {
9   function addressCount(address _swap) public constant returns (uint count);
10   function getHolderByIndex(uint _ind, address _swap) public constant returns (address holder);
11   function getBalanceByIndex(uint _ind, address _swap) public constant returns (uint bal);
12   function getIndexByAddress(address _owner, address _swap) public constant returns (uint index);
13   function createToken(uint _supply, address _owner, address _swap) public;
14   function pay(address _party, address _swap) public;
15   function partyCount(address _swap) public constant returns(uint count);
16 }
17 
18 interface Wrapped_Ether_Interface {
19   function totalSupply() public constant returns (uint total_supply);
20   function balanceOf(address _owner) public constant returns (uint balance);
21   function transfer(address _to, uint _amount) public returns (bool success);
22   function transferFrom(address _from, address _to, uint _amount) public returns (bool success);
23   function approve(address _spender, uint _amount) public returns (bool success);
24   function allowance(address _owner, address _spender) public constant returns (uint amount);
25   function withdraw(uint _value) public;
26   function CreateToken() public;
27 
28 }
29 
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 
55   function min(uint a, uint b) internal pure returns (uint256) {
56     return a < b ? a : b;
57   }
58 }
59 
60 
61 //The Factory contract sets the standardized variables and also deploys new contracts based on these variables for the user.  
62 contract Factory {
63   using SafeMath for uint256;
64   //Addresses of the Factory owner and oracle. For oracle information, check www.github.com/DecentralizedDerivatives/Oracles
65   address public owner;
66   address public oracle_address;
67 
68   //Address of the user contract
69   address public user_contract;
70   DRCT_Token_Interface drct_interface;
71   Wrapped_Ether_Interface token_interface;
72 
73   //Address of the deployer contract
74   address deployer_address;
75   Deployer_Interface deployer;
76   Deployer_Interface tokenDeployer;
77   address token_deployer_address;
78 
79   address public token_a;
80   address public token_b;
81 
82   //A fee for creating a swap in wei.  Plan is for this to be zero, however can be raised to prevent spam
83   uint public fee;
84   //Duration of swap contract in days
85   uint public duration;
86   //Multiplier of reference rate.  2x refers to a 50% move generating a 100% move in the contract payout values
87   uint public multiplier;
88   //Token_ratio refers to the number of DRCT Tokens a party will get based on the number of base tokens.  As an example, 1e15 indicates that a party will get 1000 DRCT Tokens based upon 1 ether of wrapped wei. 
89   uint public token_ratio1;
90   uint public token_ratio2;
91 
92 
93   //Array of deployed contracts
94   address[] public contracts;
95   mapping(address => uint) public created_contracts;
96   mapping(uint => address) public long_tokens;
97   mapping(uint => address) public short_tokens;
98 
99   //Emitted when a Swap is created
100   event ContractCreation(address _sender, address _created);
101 
102   /*Modifiers*/
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108   /*Functions*/
109   // Constructor - Sets owner
110   function Factory() public {
111     owner = msg.sender;
112   }
113 
114   function getTokens(uint _date) public view returns(address _ltoken, address _stoken){
115     return(long_tokens[_date],short_tokens[_date]);
116   }
117 
118   /*
119   * Updates the fee amount
120   * @param "_fee": The new fee amount
121   */
122   function setFee(uint _fee) public onlyOwner() {
123     fee = _fee;
124   }
125 
126   /*
127   * Sets the deployer address
128   * @param "_deployer": The new deployer address
129   */
130   function setDeployer(address _deployer) public onlyOwner() {
131     deployer_address = _deployer;
132     deployer = Deployer_Interface(_deployer);
133   }
134 
135   /*
136   * Sets the token_deployer address
137   * @param "_tdeployer": The new token deployer address
138   */  
139   function settokenDeployer(address _tdeployer) public onlyOwner() {
140     token_deployer_address = _tdeployer;
141     tokenDeployer = Deployer_Interface(_tdeployer);
142   }
143   /*
144   * Sets the user_contract address
145   * @param "_userContract": The new userContract address
146   */
147   function setUserContract(address _userContract) public onlyOwner() {
148     user_contract = _userContract;
149   }
150 
151   /*
152   * Returns the base token addresses
153   */
154   function getBase() public view returns(address _base1, address base2){
155     return (token_a, token_b);
156   }
157 
158 
159   /*
160   * Sets token ratio, swap duration, and multiplier variables for a swap
161   * @param "_token_ratio1": The ratio of the first token
162   * @param "_token_ratio2": The ratio of the second token
163   * @param "_duration": The duration of the swap, in seconds
164   * @param "_multiplier": The multiplier used for the swap
165   */
166   function setVariables(uint _token_ratio1, uint _token_ratio2, uint _duration, uint _multiplier) public onlyOwner() {
167     token_ratio1 = _token_ratio1;
168     token_ratio2 = _token_ratio2;
169     duration = _duration;
170     multiplier = _multiplier;
171   }
172 
173   /*
174   * Sets the addresses of the tokens used for the swap
175   * @param "_token_a": The address of a token to be used
176   * @param "_token_b": The address of another token to be used
177   */
178   function setBaseTokens(address _token_a, address _token_b) public onlyOwner() {
179     token_a = _token_a;
180     token_b = _token_b;
181   }
182 
183   //Allows a user to deploy a new swap contract, if they pay the fee
184   //returns the newly created swap address and calls event 'ContractCreation'
185   function deployContract(uint _start_date) public payable returns (address created) {
186     require(msg.value >= fee);
187     address new_contract = deployer.newContract(msg.sender, user_contract, _start_date);
188     contracts.push(new_contract);
189     created_contracts[new_contract] = _start_date;
190     ContractCreation(msg.sender,new_contract);
191     return new_contract;
192   }
193 
194 
195   function deployTokenContract(uint _start_date, bool _long) public returns(address _token) {
196     address token;
197     if (_long){
198       require(long_tokens[_start_date] == address(0));
199       token = tokenDeployer.newToken();
200       long_tokens[_start_date] = token;
201     }
202     else{
203       require(short_tokens[_start_date] == address(0));
204       token = tokenDeployer.newToken();
205       short_tokens[_start_date] = token;
206     }
207     return token;
208   }
209 
210 
211 
212   /*
213   * Deploys new tokens on a DRCT_Token contract -- called from within a swap
214   * @param "_supply": The number of tokens to create
215   * @param "_party": The address to send the tokens to
216   * @param "_long": Whether the party is long or short
217   * @returns "created": The address of the created DRCT token
218   * @returns "token_ratio": The ratio of the created DRCT token
219   */
220   function createToken(uint _supply, address _party, bool _long, uint _start_date) public returns (address created, uint token_ratio) {
221     require(created_contracts[msg.sender] > 0);
222     address ltoken = long_tokens[_start_date];
223     address stoken = short_tokens[_start_date];
224     require(ltoken != address(0) && stoken != address(0));
225     if (_long) {
226       drct_interface = DRCT_Token_Interface(ltoken);
227       drct_interface.createToken(_supply.div(token_ratio1), _party,msg.sender);
228       return (ltoken, token_ratio1);
229     } else {
230       drct_interface = DRCT_Token_Interface(stoken);
231       drct_interface.createToken(_supply.div(token_ratio2), _party,msg.sender);
232       return (stoken, token_ratio2);
233     }
234   }
235   
236 
237   //Allows the owner to set a new oracle address
238   function setOracleAddress(address _new_oracle_address) public onlyOwner() { oracle_address = _new_oracle_address; }
239 
240   //Allows the owner to set a new owner address
241   function setOwner(address _new_owner) public onlyOwner() { owner = _new_owner; }
242 
243   //Allows the owner to pull contract creation fees
244   function withdrawFees() public onlyOwner() returns(uint atok, uint btok, uint _eth){
245    token_interface = Wrapped_Ether_Interface(token_a);
246    uint aval = token_interface.balanceOf(address(this));
247    if(aval > 0){
248       token_interface.withdraw(aval);
249     }
250    token_interface = Wrapped_Ether_Interface(token_b);
251    uint bval = token_interface.balanceOf(address(this));
252    if (bval > 0){
253     token_interface.withdraw(bval);
254   }
255    owner.transfer(this.balance);
256    return(aval,bval,this.balance);
257    }
258 
259    function() public payable {
260 
261    }
262 
263   /*
264   * Returns a tuple of many private variables
265   * @returns "_oracle_adress": The address of the oracle
266   * @returns "_operator": The address of the owner and operator of the factory
267   * @returns "_duration": The duration of the swap
268   * @returns "_multiplier": The multiplier for the swap
269   * @returns "token_a_address": The address of token a
270   * @returns "token_b_address": The address of token b
271   * @returns "start_date": The start date of the swap
272   */
273   function getVariables() public view returns (address oracle_addr, uint swap_duration, uint swap_multiplier, address token_a_addr, address token_b_addr){
274     return (oracle_address,duration, multiplier, token_a, token_b);
275   }
276 
277   /*
278   * Pays out to a DRCT token
279   * @param "_party": The address being paid
280   * @param "_long": Whether the _party is long or not
281   */
282   function payToken(address _party, address _token_add) public {
283     require(created_contracts[msg.sender] > 0);
284     drct_interface = DRCT_Token_Interface(_token_add);
285     drct_interface.pay(_party, msg.sender);
286   }
287 
288   //Returns the number of contracts created by this factory
289     function getCount() public constant returns(uint count) {
290       return contracts.length;
291   }
292 }