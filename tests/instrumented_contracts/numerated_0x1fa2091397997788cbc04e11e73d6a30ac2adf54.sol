1 pragma solidity 0.4.20;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88 
89 /**
90      * Internal transfer, only can be called by this contract
91      */
92     function _transfer(address _from, address _to, uint _value) internal {
93         // Prevent transfer to 0x0 address. Use burn() instead
94         require(_to != 0x0);
95         // Check if the sender has enough
96         require(balances[_from] >= _value);
97         // Check for overflows
98         require(balances[_to] + _value > balances[_to]);
99         // Save this for an assertion in the future
100         uint previousBalances = balances[_from] + balances[_to];
101         // Subtract from the sender
102         balances[_from] = balances[_from].sub(_value);
103         // Add the same to the recipient
104         balances[_to] = balances[_to].add(_value);
105         Transfer(_from, _to, _value);
106         // Asserts are used to use static analysis to find bugs in your code. They should never fail
107         assert(balances[_from] + balances[_to] == previousBalances);
108     }
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116       _transfer(msg.sender, _to, _value);
117       return true;
118    /** require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126     **/
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract HelloToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152   
153      string public name;                   //fancy name: eg Simon Bucks
154     uint8 public decimals;                //How many decimals to show.
155     string public symbol;                 //An identifier: eg SBX
156      uint256 public sellPrice;
157     uint256 public buyPrice;
158 
159    function HelloToken(uint256 _initialAmount,
160         string _tokenName,
161         uint8 _decimalUnits,
162         string _tokenSymbol
163     ) public {
164         balances[msg.sender] = _initialAmount * 10 ** uint256(_decimalUnits);               // Give the creator all initial tokens
165         totalSupply_ = _initialAmount * 10 ** uint256(_decimalUnits);                        // Update total supply
166         name = _tokenName;                                   // Set the name for display purposes
167         decimals = _decimalUnits;                            // Amount of decimals for display purposes
168         symbol = _tokenSymbol;                               // Set the symbol for display purposes
169    }
170    /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213   
214   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public {
215         sellPrice = newSellPrice;
216         buyPrice = newBuyPrice;
217     }
218   
219  /// @notice Buy tokens from contract by sending ether
220     function buy() payable public {
221         uint amount = uint(msg.value) / uint(buyPrice);               // calculates the amount
222         _transfer(this, msg.sender, amount * 10 ** uint256(decimals));              // makes the transfers
223     }
224     
225     function() payable public{
226         buy();
227     }
228 
229     /// @notice Sell `amount` tokens to contract
230     /// @param amount amount of tokens to be sold
231     function sell(uint256 amount) public {
232         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
233         _transfer(msg.sender, this, amount * 10 ** uint256(decimals));              // makes the transfers
234         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
235     }
236   
237 
238 
239 }