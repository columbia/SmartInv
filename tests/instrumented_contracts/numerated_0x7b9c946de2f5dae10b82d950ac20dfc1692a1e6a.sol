1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * Math operations with safety checks that throw on error
6  */
7  
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
36 
37  /**
38  * Official T_Token as issued by The T****
39  * Based off of Standard ERC20 token
40  *
41  * Implementation of the basic standard token.
42  * https://github.com/ethereum/EIPs/issues/20
43  * Partially based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
44  */
45 
46 contract T_Token_11 {
47     
48   using SafeMath for uint256;
49   
50   string public name;
51   string public symbol;
52   uint256 public decimals;
53   
54   uint256 public totalSupply;
55   
56   uint256 private tprFund;
57   uint256 private founderCoins;
58   uint256 private icoReleaseTokens;
59   
60   uint256 private tprFundReleaseTime;
61   uint256 private founderCoinsReleaseTime;
62   
63   bool private tprFundUnlocked;
64   bool private founderCoinsUnlocked;
65   
66   address private tprFundDeposit;
67   address private founderCoinsDeposit;
68 
69   mapping(address => uint256) internal balances;
70   
71   mapping (address => mapping (address => uint256)) internal allowed;
72   
73   event Transfer(address indexed from, address indexed to, uint256 value);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75   event Burn(address indexed burner, uint256 value);
76   
77   function T_Token_11 () public {
78       
79       name = "T_Token_11";
80       symbol = "T_TPR_T11";
81       decimals = 18;
82       
83       tprFund = 260000000 * (10**decimals);
84       founderCoins = 30000000 * (10**decimals);
85       icoReleaseTokens = 210000000 * (10**decimals);
86       
87       totalSupply = tprFund + founderCoins + icoReleaseTokens;
88       
89       balances[msg.sender] = icoReleaseTokens;
90       
91       tprFundDeposit = 0xF1F465C345b6DBc4Bcdf98aB286762ba282BA69a; //TPR Fund
92       balances[tprFundDeposit] = 0;
93       tprFundReleaseTime = 30 * 1 minutes; // TPR Fund to be available after 6 months
94       tprFundUnlocked = false;
95       
96       founderCoinsDeposit = 0x64108822C128D11b6956754056ec4bCBe0B0CDaf; // Founders Coins
97       balances[founderCoinsDeposit] = 0;
98       founderCoinsReleaseTime = 60 * 1 minutes; // Founders coins to be unlocked after 1 year
99       founderCoinsUnlocked = false;
100   } 
101   
102   
103   /**
104    * @notice Transfers tokens held by timelock to beneficiary.
105    */
106    
107   function releaseTprFund() public {
108     require(now >= tprFundReleaseTime);
109     require(!tprFundUnlocked);
110 
111     balances[tprFundDeposit] = tprFund;
112     
113     Transfer(0, tprFundDeposit, tprFund);
114 
115     tprFundUnlocked = true;
116     
117   }
118   
119   function releaseFounderCoins() public {
120     require(now >= founderCoinsReleaseTime);
121     require(!founderCoinsUnlocked);
122 
123     balances[founderCoinsDeposit] = founderCoins;
124     
125     Transfer(0, founderCoinsDeposit, founderCoins);
126     
127     founderCoinsUnlocked = true;
128     
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139     require(_value > 0);
140 
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     Transfer(msg.sender, _to, _value);
144     return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_value > 0);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) public returns (bool) {
182     require(_value>0);
183     require(balances[msg.sender]>_value);
184     allowed[msg.sender][_spender] = 0;
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199   
200 
201     /**
202      * Burns a specific amount of tokens.
203      * @param _value The amount of tokens to be burned.
204      */
205     function burn(uint256 _value) public {
206         require(_value <= balances[msg.sender]);
207 
208         address burner = msg.sender;
209         balances[burner] = balances[burner].sub(_value);
210         totalSupply = totalSupply.sub(_value);
211         Burn(burner, _value);
212     }
213 
214 }