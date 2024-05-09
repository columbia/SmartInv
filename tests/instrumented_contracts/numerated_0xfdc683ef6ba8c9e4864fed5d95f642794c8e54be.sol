1 pragma solidity 0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85 
86 /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         // Prevent transfer to 0x0 address. Use burn() instead
91         require(_to != 0x0);
92         // Check if the sender has enough
93         require(balances[_from] >= _value);
94         // Check for overflows
95         require(balances[_to] + _value > balances[_to]);
96         // Save this for an assertion in the future
97         uint previousBalances = balances[_from] + balances[_to];
98         // Subtract from the sender
99         balances[_from] = balances[_from].sub(_value);
100         // Add the same to the recipient
101         balances[_to] = balances[_to].add(_value);
102         Transfer(_from, _to, _value);
103         // Asserts are used to use static analysis to find bugs in your code. They should never fail
104         assert(balances[_from] + balances[_to] == previousBalances);
105     }
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113       _transfer(msg.sender, _to, _value);
114       return true;
115    /** require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123     **/
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract VanHardwareResourcesChain is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   
150      string public name;                   //fancy name: eg Simon Bucks
151     uint8 public decimals;                //How many decimals to show.
152     string public symbol;                 //An identifier: eg SBX
153      uint256 public sellPrice;
154     uint256 public buyPrice;
155     address public owner;
156 
157    function VanHardwareResourcesChain() public {
158         decimals = 18;                            // Amount of decimals for display purposes
159         totalSupply_ =  500000000 * 10 ** uint256(decimals);                        // Update total supply
160         balances[0x72A4e7Ea1DDd6E33eA18b3B249E66A2201A7d7f5] = totalSupply_;               // Give the creator all initial tokens
161         name = "Van hardware resources chain";                                   // Set the name for display purposes
162         symbol = "VHC";                               // Set the symbol for display purposes
163         owner = 0x72A4e7Ea1DDd6E33eA18b3B249E66A2201A7d7f5;
164         Transfer(address(0x0), 0x72A4e7Ea1DDd6E33eA18b3B249E66A2201A7d7f5 , totalSupply_);
165 
166 
167    }
168   
169    modifier onlyOwner(){
170        require(msg.sender == owner);
171        _;
172    }
173     function changeOwner(address _newOwner) public onlyOwner{
174        owner = _newOwner;
175    }
176    /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219   
220   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner{
221         sellPrice = newSellPrice;
222         buyPrice = newBuyPrice;
223     }
224   
225  /// @notice Buy tokens from contract by sending ether
226     function buy() payable public {
227         uint amount = uint(msg.value) / uint(buyPrice);               // calculates the amount
228         _transfer(this, msg.sender, amount * 10 ** uint256(decimals));              // makes the transfers
229     }
230     
231     function() payable public{
232         buy();
233     }
234 
235     /// @notice Sell `amount` tokens to contract
236     /// @param amount amount of tokens to be sold
237     function sell(uint256 amount) public {
238         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
239         _transfer(msg.sender, this, amount * 10 ** uint256(decimals));              // makes the transfers
240         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
241     }
242     
243     
244   function withdraw( address _address, uint amount) public onlyOwner{
245       require(address(this).balance > amount * 1 ether);
246       _address.transfer(amount * 1 ether);
247   }
248 
249 
250 }