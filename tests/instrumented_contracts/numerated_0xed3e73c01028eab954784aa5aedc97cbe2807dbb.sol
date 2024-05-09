1 // Tipper Inc.
2 // Official Token
3 // Tipper: The Social Economy
4 
5 pragma solidity ^0.4.18;
6 
7 /**
8  * @title SafeMath
9  * Math operations with safety checks that throw on error
10  */
11  
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41  /**
42  * This official token of Tipper Inc. is based off of the Standard ERC20 token
43  * implementation of the basic standard token.
44  * 
45  * https://github.com/ethereum/EIPs/issues/20
46  * 
47  * Partially based on ideas and code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
48  * and code found at OpenZeppelin.org
49  */
50 
51 contract TipperToken {
52     
53   using SafeMath for uint256;
54   
55   string public name;
56   string public symbol;
57   uint256 public decimals;
58   
59   uint256 public totalSupply;
60   
61   uint256 private tprFund;
62   uint256 private founderCoins;
63   uint256 private icoReleaseTokens;
64   
65   uint256 private tprFundReleaseTime;
66   uint256 private founderCoinsReleaseTime;
67   
68   bool private tprFundUnlocked;
69   bool private founderCoinsUnlocked;
70   
71   address private tprFundDeposit;
72   address private founderCoinsDeposit;
73 
74   mapping(address => uint256) internal balances;
75   
76   mapping (address => mapping (address => uint256)) internal allowed;
77   
78   event Transfer(address indexed from, address indexed to, uint256 value);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80   event Burn(address indexed burner, uint256 value);
81   
82   function TipperToken () public {
83       
84       name = "Tipper";
85       symbol = "TIPR";
86       decimals = 18;
87       
88       tprFund = 420000000 * (10**decimals); // Reserved for TIPR User Fund and Tipper Inc. use
89       founderCoins = 70000000 * (10**decimals); // Founder Coins
90       icoReleaseTokens = 210000000 * (10**decimals); // Tokens to be released for ICO
91       
92       totalSupply = tprFund + founderCoins + icoReleaseTokens; // Total Supply of TIPR = 700,000,000
93       
94       balances[msg.sender] = icoReleaseTokens;
95       
96       Transfer(0, msg.sender, icoReleaseTokens);
97       
98       tprFundDeposit = 0x443174D48b39a18Aae6d7FfCa5c7712B6E94496b; // Deposit address for TIPR User Fund
99       balances[tprFundDeposit] = 0;
100       tprFundReleaseTime = 129600 * 1 minutes; // TIPR User Fund to be available after 3 months
101       
102       tprFundUnlocked = false;
103       
104       founderCoinsDeposit = 0x703D1d5DFf7D6079f44D6C56a2E455DaC7f2D8e6; // Deposit address for founders coins
105       balances[founderCoinsDeposit] = 0;
106       founderCoinsReleaseTime = 525600 * 1 minutes; // Founders coins to be unlocked after 1 year
107       founderCoinsUnlocked = false;
108   } 
109   
110   
111   /**
112    * Transfers tokens held by the timelock to the specified address.
113    * This function releases the TIPR User Fund for Tipper Inc. use
114    * after 3 months.
115    */
116    
117   function releaseTprFund() public {
118     require(now >= tprFundReleaseTime); // Check that 3 months have passed
119     require(!tprFundUnlocked); // Check that the fund has not been released yet
120 
121     balances[tprFundDeposit] = tprFund; // Assign the funds to the specified account
122     
123     Transfer(0, tprFundDeposit, tprFund); // Log the transfer on the blockchain
124 
125     tprFundUnlocked = true; 
126     
127   }
128   
129     
130   /**
131    * Transfers tokens held by the timelock to the specified address.
132    * This function releases the founders coins after 1 year.
133    */
134   
135   function releaseFounderCoins() public {
136     require(now >= founderCoinsReleaseTime); // Check that 1 year has passed
137     require(!founderCoinsUnlocked); // Check that the coins have not been released yet
138 
139     balances[founderCoinsDeposit] = founderCoins; // Assign the coins to the founders accounts
140     
141     Transfer(0, founderCoinsDeposit, founderCoins); // Log the transfer on the blockchain
142     
143     founderCoinsUnlocked = true;
144   }
145 
146   /**
147   * @dev transfer tokens to a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[msg.sender]);
154     require(_value > 0);
155 
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     Transfer(msg.sender, _to, _value);
159     return true;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256 balance) {
168     return balances[_owner];
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181     require(_value > 0);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     require(_value>0);
198     require(balances[msg.sender]>_value);
199     allowed[msg.sender][_spender] = 0;
200     allowed[msg.sender][_spender] = _value;
201     Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) public view returns (uint256) {
212     return allowed[_owner][_spender];
213   }
214   
215 
216     /**
217      * Burns a specific amount of tokens.
218      * @param _value The amount of tokens to be burned.
219      */
220     function burn(uint256 _value) public {
221         require(_value <= balances[msg.sender]);
222 
223         address burner = msg.sender;
224         balances[burner] = balances[burner].sub(_value);
225         totalSupply = totalSupply.sub(_value);
226         Burn(burner, _value);
227     }
228 
229 }