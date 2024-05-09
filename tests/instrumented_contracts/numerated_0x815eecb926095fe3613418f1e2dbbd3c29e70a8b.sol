1 pragma solidity ^0.4.18;
2 
3 /**
4  *  @title Smart City Token https://www.smartcitycoin.io
5  *  @dev ERC20 standard compliant / https://github.com/ethereum/EIPs/issues/20 /
6  *  @dev Amount not sold during Crowdsale is burned
7  */
8 
9 contract SmartCityToken {
10     using SafeMath for uint256;
11 
12     address public owner;  // address of Token Owner
13     address public crowdsale; // address of Crowdsale contract
14 
15     string constant public standard = "ERC20"; // token standard
16     string constant public name = "Smart City"; // token name
17     string constant public symbol = "CITY"; // token symbol
18 
19     uint256 constant public decimals = 5; // 1 CITY = 100000 tokens
20     uint256 public totalSupply = 252862966307692; // total token provision
21 
22     uint256 constant public amountForSale = 164360928100000; // amount that might be sold during ICO - 65% of total token supply
23     uint256 constant public amountReserved = 88502038207692; // amount reserved for founders / loyalty / bounties / etc. - 35% of total token supply
24     uint256 constant public amountLocked = 61951426745384; // the amount of tokens Owner cannot spend within first 2 years after Crowdsale - 70% of the reserved amount
25 
26     uint256 public startTime; // from this time on transfer and transferFrom functions are available to anyone except of token Owner
27     uint256 public unlockOwnerDate; // from this time on transfer and transferFrom functions are available to token Owner
28 
29     mapping(address => uint256) public balances; // balances array
30     mapping(address => mapping(address => uint256)) public allowances; // allowances array
31 
32     bool public burned; // indicates whether excess tokens have already been burned
33 
34     event Transfer(address indexed from, address indexed to, uint256 value); // Transfer event
35     event Approval(address indexed _owner, address indexed spender, uint256 value); // Approval event
36     event Burned(uint256 amount); // Burned event
37 
38     modifier onlyPayloadSize(uint size) {
39         assert(msg.data.length >= size + 4);
40         _;
41     }
42 
43     /**
44      *  @dev Contract initialization
45      *  @param _ownerAddress address Token owner address
46      *  @param _startTime uint256 Crowdsale end time
47      *
48      */
49     function SmartCityToken(address _ownerAddress, uint256 _startTime) public {
50         owner = _ownerAddress; // token Owner
51         startTime = _startTime; // token Start Time
52         unlockOwnerDate = startTime + 2 years;
53         balances[owner] = totalSupply; // all tokens are initially allocated to token owner
54     }
55 
56     /**
57      * @dev Transfers token for a specified address
58      * @param _to address The address to transfer to
59      * @param _value uint256 The amount to be transferred
60      */
61     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns(bool success) {
62         require(now >= startTime);
63         require(_to != address(0));
64         require(_value <= balances[msg.sender]);
65 
66         if (msg.sender == owner && now < unlockOwnerDate)
67             require(balances[msg.sender].sub(_value) >= amountLocked);
68 
69         balances[msg.sender] = balances[msg.sender].sub(_value); // subtract requested amount from the sender address
70         balances[_to] = balances[_to].add(_value); // send requested amount to the target address
71 
72         //Transfer(msg.sender, _to, _value); // trigger Transfer event
73         return true;
74     }
75 
76     /**
77      * @dev Transfers tokens from one address to another
78      * @param _from address The address which you want to send tokens from
79      * @param _to address The address which you want to transfer to
80      * @param _value uint256 the amount of tokens to be transferred
81      */
82     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns(bool success) {
83         require(_to != address(0));
84         require(_value <= balances[_from]);
85         require(_value <= allowances[_from][msg.sender]);
86 
87         if (now < startTime)
88             require(_from == owner);
89 
90         if (_from == owner && now < unlockOwnerDate)
91             require(balances[_from].sub(_value) >= amountLocked);
92 
93         uint256 _allowance = allowances[_from][msg.sender];
94         balances[_from] = balances[_from].sub(_value); // subtract requested amount from the sender address
95         balances[_to] = balances[_to].add(_value); // send requested amount to the target address
96         allowances[_from][msg.sender] = _allowance.sub(_value); // reduce sender allowance by transferred amount
97 
98         //Transfer(_from, _to, _value); // trigger Transfer event
99         return true;
100     }
101 
102     /**
103      * @dev Gets the balance of the specified address.
104      * @param _addr address The address to query the balance of.
105      * @return uint256 representing the amount owned by the passed address.
106      */
107     function balanceOf(address _addr) public view returns (uint256 balance) {
108         return balances[_addr];
109     }
110 
111     /**
112      *  @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
113      *  @param _spender address The address which will spend the funds
114      *  @param _value uint256 The amount of tokens to be spent.
115      */
116     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns(bool success) {
117         return _approve(_spender, _value);
118     }
119 
120     /**
121      *  @dev Workaround for vulnerability described here: https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM
122      */
123     function _approve(address _spender, uint256 _value) internal returns(bool success) {
124         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
125 
126         allowances[msg.sender][_spender] = _value; // Set spender allowance
127 
128         Approval(msg.sender, _spender, _value); // Trigger Approval event
129         return true;
130     }
131 
132     /**
133      *  @dev Burns all the tokens which has not been sold during ICO
134      */
135     function burn() public {
136         if (!burned && now > startTime) {
137             uint256 diff = balances[owner].sub(amountReserved); // Get the amount of unsold tokens
138 
139             balances[owner] = amountReserved;
140             totalSupply = totalSupply.sub(diff); // Reduce total provision number
141 
142             burned = true;
143             Burned(diff); // Trigger Burned event
144         }
145     }
146 
147     /**
148      *  @dev Sets Corwdsale contract address & allowance
149      *  @param _crowdsaleAddress address The address of the Crowdsale contract
150      */
151     function setCrowdsale(address _crowdsaleAddress) public {
152         require(msg.sender == owner);
153         require(crowdsale == address(0));
154 
155         crowdsale = _crowdsaleAddress;
156         assert(_approve(crowdsale, amountForSale));
157     }
158 }
159 
160 /**
161  * @title SafeMath
162  * @dev Math operations with safety checks that throw on error
163  */
164 library SafeMath {
165 
166   /**
167   * @dev Multiplies two numbers, throws on overflow.
168   */
169   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170     if (a == 0) {
171       return 0;
172     }
173     uint256 c = a * b;
174     assert(c / a == b);
175     return c;
176   }
177 
178   /**
179   * @dev Integer division of two numbers, truncating the quotient.
180   */
181   function div(uint256 a, uint256 b) internal pure returns (uint256) {
182     uint256 c = a / b;
183     return c;
184   }
185 
186   /**
187   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
188   */
189   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190     assert(b <= a);
191     return a - b;
192   }
193 
194   /**
195   * @dev Adds two numbers, throws on overflow.
196   */
197   function add(uint256 a, uint256 b) internal pure returns (uint256) {
198     uint256 c = a + b;
199     assert(c >= a);
200     return c;
201   }
202 }
203 
204 
205     /**
206     *            CITY 2.0 token by www.SmartCityCoin.io
207     * 
208     *          .ossssss:                      `+sssss`      
209     *         ` +ssssss+` `.://++++++//:.`  .osssss+       
210     *            /sssssssssssssssssssssssss+ssssso`        
211     *             -sssssssssssssssssssssssssssss+`         
212     *            .+sssssssss+:--....--:/ossssssss+.        
213     *          `/ssssssssssso`         .sssssssssss/`      
214     *         .ossssss+sssssss-       :sssss+:ossssso.     
215     *        `ossssso. .ossssss:    `/sssss/  `/ssssss.    
216     *        ossssso`   `+ssssss+` .osssss:     /ssssss`   
217     *       :ssssss`      /sssssso:ssssso.       +o+/:-`   
218     *       osssss+        -sssssssssss+`                  
219     *       ssssss:         .ossssssss/                    
220     *       osssss/          `+ssssss-                     
221     *       /ssssso           :ssssss                      
222     *       .ssssss-          :ssssss                      
223     *        :ssssss-         :ssssss          `           
224     *         /ssssss/`       :ssssss        `/s+:`        
225     *          :sssssso:.     :ssssss      ./ssssss+`      
226     *           .+ssssssso/-.`:ssssss``.-/osssssss+.       
227     *             .+ssssssssssssssssssssssssssss+-         
228     *               `:+ssssssssssssssssssssss+:`           
229     *                  `.:+osssssssssssso+:.`              
230     *                        `/ssssss.`                    
231     *                         :ssssss                      
232     */