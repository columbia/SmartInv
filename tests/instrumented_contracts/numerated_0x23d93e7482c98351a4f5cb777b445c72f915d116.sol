1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     /**
8      * The address whcih deploys this contrcat is automatically assgined ownership.
9      * */
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     /**
15      * Functions with this modifier can only be executed by the owner of the contract. 
16      * */
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     event OwnershipTransferred(address indexed from, address indexed to);
23 
24     /**
25     * Transfers ownership to new Ethereum address. This function can only be called by the 
26     * owner.
27     * @param _newOwner the address to be granted ownership.
28     **/
29     function transferOwnership(address _newOwner) public onlyOwner {
30         require(_newOwner != 0x0);
31         emit OwnershipTransferred(owner, _newOwner);
32         owner = _newOwner;
33     }
34 }
35 
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, throws on overflow.
45   */
46   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (_a == 0) {
51       return 0;
52     }
53 
54     c = _a * _b;
55     assert(c / _a == _b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
63     // assert(_b > 0); // Solidity automatically throws when dividing by 0
64     // uint256 c = _a / _b;
65     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
66     return _a / _b;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
73     assert(_b <= _a);
74     return _a - _b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
81     c = _a + _b;
82     assert(c >= _a);
83     return c;
84   }
85 }
86 
87 
88 
89 contract ERC20Basic {
90     uint256 public totalSupply;
91     string public name;
92     string public symbol;
93     uint8 public decimals;
94     function balanceOf(address who) constant public returns (uint256);
95     function transfer(address to, uint256 value) public returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 
100 contract ERC20 is ERC20Basic {
101     function allowance(address owner, address spender) constant public returns (uint256);
102     function transferFrom(address from, address to, uint256 value) public  returns (bool);
103     function approve(address spender, uint256 value) public returns (bool);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 contract UsdPrice {
109     function USD(uint _id) public constant returns (uint256);
110 }
111 
112 
113 contract ICO is Ownable {
114     
115     using SafeMath for uint256;
116     
117     UsdPrice public fiat;
118     ERC20 public ELYC;
119     
120     uint256 private tokenPrice;
121     uint256 private tokensSold;
122     
123     constructor() public {
124         fiat = UsdPrice(0x8055d0504666e2B6942BeB8D6014c964658Ca591); 
125         ELYC = ERC20(0xFD96F865707ec6e6C0d6AfCe1f6945162d510351); 
126         tokenPrice = 8; //$0.08
127         tokensSold = 0;
128     }
129     
130     
131     /**
132      * EVENTS
133      * */
134     event PurchaseMade(address indexed by, uint256 tokensPurchased, uint256 tokenPricee);
135     event WithdrawOfELYC(address recipient, uint256 tokensSent);
136     event TokenPriceChanged(uint256 oldPrice, uint256 newPrice);
137      
138      
139 
140     /**
141      * GETTERS
142      * */  
143      
144     /**
145      * @return The unit price of the ELYC token in ETH. 
146      * */
147     function getTokenPriceInETH() public view returns(uint256) {
148         return fiat.USD(0).mul(tokenPrice);
149     }
150     
151     
152     /**
153      * @return The unit price of ELYC in USD cents. 
154      * */
155     function getTokenPriceInUsdCents() public view returns(uint256) {
156         return tokenPrice;
157     }
158     
159     
160     /**
161      * @return The total amount of tokens which have been sold.
162      * */
163     function getTokensSold() public view returns(uint256) {
164         return tokensSold;
165     }
166     
167     
168     /**
169      * @return 1 ETH worth of ELYC tokens. 
170      * */
171     function getRate() public view returns(uint256) {
172         uint256 e18 = 1e18;
173         return e18.div(getTokenPriceInETH());
174     }
175 
176 
177     /**
178      * Fallback function invokes the buyTokens() function when ETH is received to 
179      * enable easy and automatic token distributions to investors.
180      * */
181     function() public payable {
182         buyTokens(msg.sender);
183     }
184     
185     
186     /**
187      * Allows investors to buy tokens. In most cases this function will be invoked 
188      * internally by the fallback function, so no manual work is required from investors
189      * (unless they want to purchase tokens for someone else).
190      * @param _investor The address which will be receiving ELYC tokens 
191      * @return true if the address is on the blacklist, false otherwise
192      * */
193     function buyTokens(address _investor) public payable returns(bool) {
194         require(_investor != address(0) && msg.value > 0);
195         ELYC.transfer(_investor, msg.value.mul(getRate()));
196         tokensSold = tokensSold.add(msg.value.mul(getRate()));
197         owner.transfer(msg.value);
198         emit PurchaseMade(_investor, msg.value.mul(getRate()), getTokenPriceInETH());
199         return true;
200     }
201     
202     
203     /**
204      * ONLY OWNER FUNCTIONS
205      * */
206      
207     /**
208      * Allows the owner to withdraw any ERC20 token which may have been sent to this 
209      * contract address by mistake. 
210      * @param _addressOfToken The contract address of the ERC20 token
211      * @param _recipient The receiver of the token. 
212      * */
213     function withdrawAnyERC20(address _addressOfToken, address _recipient) public onlyOwner {
214         ERC20 token = ERC20(_addressOfToken);
215         token.transfer(_recipient, token.balanceOf(address(this)));
216     }
217     
218 
219     /**
220      * Allows the owner to withdraw any unsold ELYC tokens at any time during or 
221      * after the ICO. Can also be used to process offchain payments such as from 
222      * BTC, LTC or any other currency and can be used to pay partners and team 
223      * members. 
224      * @param _recipient The receiver of the token. 
225      * @param _value The total amount of tokens to send 
226      * */
227     function withdrawELYC(address _recipient, uint256 _value) public onlyOwner {
228         require(_recipient != address(0));
229         ELYC.transfer(_recipient, _value);
230         emit WithdrawOfELYC(_recipient, _value);
231     }
232     
233     
234     /**
235      * Allows the owner to change the price of the token in USD cents anytime during 
236      * the ICO. 
237      * @param _newTokenPrice The price in cents. For example the value 1 would mean 
238      * $0.01
239      * */
240     function changeTokenPriceInCent(uint256 _newTokenPrice) public onlyOwner {
241         require(_newTokenPrice != tokenPrice && _newTokenPrice > 0);
242         emit TokenPriceChanged(tokenPrice, _newTokenPrice);
243         tokenPrice = _newTokenPrice;
244     }
245     
246     
247     /**
248      * Allows the owner to kill the ICO contract. This function call is irreversible
249      * and cannot be invoked until there are no remaining ELYC tokens stored on the 
250      * ICO contract address. 
251      * */
252     function terminateICO() public onlyOwner {
253         require(ELYC.balanceOf(address(this)) == 0);
254         selfdestruct(owner);
255     }
256 }