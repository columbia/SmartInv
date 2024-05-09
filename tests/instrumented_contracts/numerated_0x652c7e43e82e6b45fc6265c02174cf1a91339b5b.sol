1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   
14   function add(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a + b;
16     assert(c >= a);
17     return c;
18   }
19 }
20 
21 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
22 
23 contract MB {
24     /* Public variables of the token */
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28     uint256 public totalSupply;
29 
30     /* This creates an array with all balances */
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     /* This generates a public event on the blockchain that will notify clients */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /* This notifies clients about the amount burnt */
38     event Burn(address indexed from, uint256 value);
39 
40     /* Initializes contract with initial supply tokens to the creator of the contract */
41     function MB(
42         uint256 initialSupply,
43         string tokenName,
44         uint8 decimalUnits,
45         string tokenSymbol
46         ) {
47         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
48         totalSupply = initialSupply;                        // Update total supply
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51         decimals = decimalUnits;                            // Amount of decimals for display purposes
52     }
53 
54     /* Internal transfer, only can be called by this contract */
55     function _transfer(address _from, address _to, uint _value) internal {
56         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
57         require (balanceOf[_from] > _value);                // Check if the sender has enough
58         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
59         balanceOf[_from] -= _value;                         // Subtract from the sender
60         balanceOf[_to] += _value;                            // Add the same to the recipient
61         Transfer(_from, _to, _value);
62     }
63 
64     /// @notice Send `_value` tokens to `_to` from your account
65     /// @param _to The address of the recipient
66     /// @param _value the amount to send
67     function transfer(address _to, uint256 _value) {
68         _transfer(msg.sender, _to, _value);
69     }
70 
71     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
72     /// @param _from The address of the sender
73     /// @param _to The address of the recipient
74     /// @param _value the amount to send
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76         require (_value < allowance[_from][msg.sender]);     // Check allowance
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81 
82     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
83     /// @param _spender The address authorized to spend
84     /// @param _value the max amount they can spend
85     function approve(address _spender, uint256 _value)
86         returns (bool success) {
87         allowance[msg.sender][_spender] = _value;
88         return true;
89     }
90 
91     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
92     /// @param _spender The address authorized to spend
93     /// @param _value the max amount they can spend
94     /// @param _extraData some extra information to send to the approved contract
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
96         returns (bool success) {
97         tokenRecipient spender = tokenRecipient(_spender);
98         if (approve(_spender, _value)) {
99             spender.receiveApproval(msg.sender, _value, this, _extraData);
100             return true;
101         }
102     }        
103 
104     /// @notice Remove `_value` tokens from the system irreversibly
105     /// @param _value the amount of money to burn
106     function burn(uint256 _value) returns (bool success) {
107         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
108         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
109         totalSupply -= _value;                                // Updates totalSupply
110         Burn(msg.sender, _value);
111         return true;
112     }
113 
114     function burnFrom(address _from, uint256 _value) returns (bool success) {
115         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
116         require(_value <= allowance[_from][msg.sender]);    // Check allowance
117         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
118         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
119         totalSupply -= _value;                              // Update totalSupply
120         Burn(_from, _value);
121         return true;
122     }
123 }
124 
125 
126 /**
127  * @title Ownable
128  * @dev The Ownable contract has an owner address, and provides basic authorization control
129  * functions, this simplifies the implementation of "user permissions".
130  */
131 contract Ownable {
132   address public owner;
133 
134 
135   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137 
138   /**
139    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
140    * account.
141    */
142   function Ownable() {
143     owner = msg.sender;
144   }
145 
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(msg.sender == owner);
152     _;
153   }
154 
155 
156   /**
157    * @dev Allows the current owner to transfer control of the contract to a newOwner.
158    * @param newOwner The address to transfer ownership to.
159    */
160   function transferOwnership(address newOwner) onlyOwner public {
161     require(newOwner != address(0));
162     OwnershipTransferred(owner, newOwner);
163     owner = newOwner;
164   }
165 
166 }
167 
168 /**
169  * @title Token 
170  * @dev API interface for interacting with the MRAToken contract
171  * /
172  interface Token {
173  function transfer (address _to, uint256 _value) returns (bool);
174  function balanceOf (address_owner) constant returns (uint256 balance);
175 }
176 
177 /**
178  * @title Crowdsale
179  * @dev Crowdsale is a base contract for managing a token crowdsale.
180  * Crowdsales have a start and end timestamps, where investors can make
181  * token purchases and the crowdsale will assign them tokens based
182  * on a token per ETH rate. Funds collected are forwarded to a wallet
183  * as they arrive.
184  */
185 contract MediCrowdsale is Ownable {
186   using SafeMath for uint256;
187 
188   // The token being sold
189   MB public token;
190 
191   // start and end timestamps where investments are allowed (both inclusive
192 
193   
194   uint256 public startTime = 1507540345;//Mon, 09 Oct 2017 09:12:25 +0000
195   uint256 public endTime = 1511222399;//Mon, 20 Nov 2017 23:59:59 +0000
196   
197   
198   // address where funds are collected
199   address public wallet;
200 
201   // how many token units a buyer gets per wei
202   uint256 public rate = 4000;
203 
204 
205   // amount of raised money in wei
206   uint256 public weiRaised;
207 
208   /**
209    * event for token purchase logging
210    * @param purchaser who paid for the tokens
211    * @param beneficiary who got the tokens
212    * @param value weis paid for purchase
213    * @param amount amount of tokens purchased
214    */
215   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
216 
217 
218   function MediCrowdsale(address tokenContractAddress, address _walletAddress) {
219     wallet = _walletAddress;
220     token = MB(tokenContractAddress);
221   }
222 
223   // fallback function can be used to buy tokens
224   function () payable {
225     buyTokens(msg.sender);
226   }
227 
228   // low level token purchase function
229   function buyTokens(address beneficiary) public payable {
230     require(beneficiary != 0x0);
231     require(validPurchase());
232 
233     uint256 weiAmount = msg.value;
234 
235     // calculate token amount to be created
236     uint256 tokens = weiAmount.mul(rate);
237 
238     // update state
239     weiRaised = weiRaised.add(weiAmount);
240 
241     token.transfer(beneficiary, tokens);
242     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
243 
244     forwardFunds();
245   }
246 
247   // send ether to the fund collection wallet
248   // override to create custom fund forwarding mechanisms
249   function forwardFunds() internal {
250     wallet.transfer(msg.value);
251   }
252 
253   // @return true if the transaction can buy tokens
254   function validPurchase() internal constant returns (bool) {
255     bool withinPeriod = now >= startTime && now <= endTime;
256     bool nonZeroPurchase = msg.value != 0;
257     return withinPeriod && nonZeroPurchase;
258   }
259 
260   // @return true if crowdsale event has ended
261   function hasEnded() public constant returns (bool) {
262     return now > endTime;
263   }
264 
265   function transferBackTo(uint256 tokens, address beneficiary) onlyOwner returns (bool){
266   	token.transfer(beneficiary, tokens);
267   	return true;
268   }
269 
270 }