1 pragma solidity ^0.4.18;
2 /**
3  * Official POWToken creation Smart Contract from PowerLineUp.io
4  * PowerLineUp is the Standard ERC20 Token for Fantasy Strategy, powered by the Ethereum Network.
5  */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
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
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   /**
59   * @dev transfer token for a specified address
60   * @param _to The address to transfer to.
61   * @param _value The amount to be transferred.
62   */
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) constant public returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public constant returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     var _allowance = allowed[_from][msg.sender];
115 
116     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117     // require (_value <= _allowance);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = _allowance.sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) public returns (bool) {
132 
133     // To change the approve amount you first have to reduce the addresses`
134     //  allowance to zero by calling `approve(_spender, 0)` if it is not
135     //  already 0 to mitigate the race condition described here:
136     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137     
138     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    */
160 
161   function increaseApproval (address _spender, uint _addedValue)public returns (bool success) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178 }
179 
180 /**
181  * @title POWToken
182  * POWToken is the Standard ERC20 Token for Fantasy Strategy, powered by the Ethereum Network.
183  */
184 contract POWToken is StandardToken {
185 
186   string public constant name = "POWToken";
187   string public constant symbol = "POW";
188   uint8 public constant decimals = 18; // 18 decimal to fully comply with ERC20 Standard.
189 
190 //30 million POWtokens will be distributed via CrowdSale for Early Adopters. 
191 //30 million POWtokens will be available only by mining or staking in-game with the previously distributed tokens.
192 //All tokens are transferable through the Ethereum Blockchain. 
193 //All tokens are redeemable for tournament prizes and ether at regular token prize in-platform. 
194 //Since number of tokens is limited, the price of each token will increase as the number of users and demand increases. 
195 
196   uint256 public constant totalSupplyWithDecimals = 60000000000000000000000000; //60 million unique tokens for a single distribution and 18 decimal places to fully comply with ERC20 Standard. 
197   
198   uint256 public mineableSupply;                        //Amount of POWTokens stored for in-platform mining, staking and prizes.
199   address public mineableTokenStorageContract;          //Smart Contract to store in-platform tokens.
200   uint256 public openSaleSupply;                        //Amount of POWTokens distributed to Early Adpoters. 
201   address public openDistributionContract;              //Smart Contract to store tokens for Open Distribution (CrowdSale).
202 
203   //No tokens for founders. Full-transparency distribution.
204 
205   string public tokenCreationDate;
206           
207   /**
208    * @dev Contructor that gives msg.sender all of existing tokens.
209    */
210   function POWToken()public {
211     
212     balances[msg.sender] = totalSupplyWithDecimals;
213 
214   }
215 
216 
217 // setup contract addresses.
218   function setupFunctionalAddresses(address _mineableTokenStorageContract, address _OpenDistributionContract) public returns (bytes32 response) {
219       
220           mineableSupply = 30000000000000000000000000;                           
221           mineableTokenStorageContract = _mineableTokenStorageContract;
222           openSaleSupply = 30000000000000000000000000;
223           openDistributionContract = _OpenDistributionContract;
224           tokenCreationDate = "December-27-2017";
225           
226           return "Addresses Setup.";
227 
228          }
229     
230 }