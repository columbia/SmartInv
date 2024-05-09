1 pragma solidity ^0.4.18;
2 
3 /**
4  *  @title Smart City Token http://www.smartcitycoin.io
5  *  @dev ERC20 standard compliant / https://github.com/ethereum/EIPs/issues/20 /
6  *  @dev Amount not sold during Crowdsale can be burned by anyone
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
20     uint256 public totalSupply = 252862966307692; // total token provision; 1 CITY = 0,0001 ETH
21 
22     uint256 constant public amountForSale = 164360928100000; // amount that might be sold during ICO - 65% of total token supply; 164361 ETH equivalent
23     uint256 constant public amountReserved = 88502038207692; // amount reserved for founders / loyalty / bounties / etc. - 35% of total token supply
24     uint256 constant public amountLocked = 61951426745384; // the amount of tokens Owner cannot spend within first 2 years after Crowdsale - 70% of the reserved amount
25 
26     uint256 public startTime; // Crowdsale end time: from this time on transfer and transferFrom functions are available to anyone except of token Owner
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
72         Transfer(msg.sender, _to, _value); // trigger Transfer event
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
98         Transfer(_from, _to, _value); // trigger Transfer event
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
158 
159     /**
160      *  @dev Crowdsale contract is allowed to shift token start time to earlier than initially defined date
161      *  @param _newStartTime uint256 New Start Date
162      */
163     function setTokenStart(uint256 _newStartTime) public {
164         require(msg.sender == crowdsale && _newStartTime < startTime);
165         startTime = _newStartTime;
166     }
167 }
168 
169 
170 /**
171  * @title SafeMath
172  * @dev Math operations with safety checks that throw on error
173  */
174 library SafeMath {
175 
176   /**
177   * @dev Multiplies two numbers, throws on overflow.
178   */
179   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180     if (a == 0) {
181       return 0;
182     }
183     uint256 c = a * b;
184     assert(c / a == b);
185     return c;
186   }
187 
188   /**
189   * @dev Integer division of two numbers, truncating the quotient.
190   */
191   function div(uint256 a, uint256 b) internal pure returns (uint256) {
192     uint256 c = a / b;
193     return c;
194   }
195 
196   /**
197   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     assert(b <= a);
201     return a - b;
202   }
203 
204   /**
205   * @dev Adds two numbers, throws on overflow.
206   */
207   function add(uint256 a, uint256 b) internal pure returns (uint256) {
208     uint256 c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 }
213 
214 
215     /**
216     *            CITY token by www.SmartCityCoin.io
217     * 
218     *          .ossssss:                      `+sssss`      
219     *         ` +ssssss+` `.://++++++//:.`  .osssss+       
220     *            /sssssssssssssssssssssssss+ssssso`        
221     *             -sssssssssssssssssssssssssssss+`         
222     *            .+sssssssss+:--....--:/ossssssss+.        
223     *          `/ssssssssssso`         .sssssssssss/`      
224     *         .ossssss+sssssss-       :sssss+:ossssso.     
225     *        `ossssso. .ossssss:    `/sssss/  `/ssssss.    
226     *        ossssso`   `+ssssss+` .osssss:     /ssssss`   
227     *       :ssssss`      /sssssso:ssssso.       +o+/:-`   
228     *       osssss+        -sssssssssss+`                  
229     *       ssssss:         .ossssssss/                    
230     *       osssss/          `+ssssss-                     
231     *       /ssssso           :ssssss                      
232     *       .ssssss-          :ssssss                      
233     *        :ssssss-         :ssssss          `           
234     *         /ssssss/`       :ssssss        `/s+:`        
235     *          :sssssso:.     :ssssss      ./ssssss+`      
236     *           .+ssssssso/-.`:ssssss``.-/osssssss+.       
237     *             .+ssssssssssssssssssssssssssss+-         
238     *               `:+ssssssssssssssssssssss+:`           
239     *                  `.:+osssssssssssso+:.`              
240     *                        `/ssssss.`                    
241     *                         :ssssss                      
242     */