1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 contract Ownable {
33   address public owner;
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) constant public returns (uint256);
74   function transfer(address to, uint256 value) internal returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) tokenBalances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) internal returns (bool) {
93     //TRANSFER Functionality has been disabled as we wanted to make the token non-tradable
94     //and we are nice people so we don't want anyone to not get their payout :)
95     return false;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) constant public returns (uint256 balance) {
104     return tokenBalances[_owner];
105   }
106 
107 }
108 contract HareemMinePoolToken is BasicToken, Ownable {
109 
110    using SafeMath for uint256;
111    string public constant name = "HareemMinePool";
112    string public constant symbol = "HMP";
113    uint256 public constant decimals = 18;
114 
115    uint256 constant INITIAL_SUPPLY = 1000 * (10 ** uint256(decimals));
116    uint256 public sellPrice = 2;  
117    uint256 public buyPrice = 1; 
118   
119    string public constant COLLATERAL_HELD = "1000 ETH";
120    uint payout_worth = 0;
121    
122    event Debug(string message, uint256 num);
123    
124    mapping(address => uint256) amountLeftToBePaid;
125    mapping(address => uint256) partialAmtToBePaid;
126    
127    address[] listAddr;
128    
129    //Client addresses
130    address ethStore = 0x66Ef84EE378B07012FE44Df83b64Ea2Ae35fD09b;   
131    address exchange = 0x093af86909F7E2135aD764e9cB384Ed7311799d3;
132    
133    uint perTokenPayout = 0;
134    uint tokenToTakeBack = 0;
135    
136    event addr(string message, address sender);
137    event logString(string message);
138    
139    // fallback function can be used to buy tokens
140     function () public payable {
141     buy(msg.sender);
142     }
143   
144     /**
145     * @dev Contructor that gives msg.sender all of existing tokens.
146     */
147     function HareemMinePoolToken() public {
148     owner = ethStore;
149     totalSupply = INITIAL_SUPPLY;
150     tokenBalances[owner] = INITIAL_SUPPLY;
151     }
152     
153     function transferOwnership(address newOwner) public onlyOwner {
154         transferOwnership(newOwner);
155     }
156 
157     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
158         sellPrice = newSellPrice;
159         buyPrice = newBuyPrice;
160     }
161   
162     function payoutWorth(address beneficiary) constant public returns (uint amount) {
163         amount = tokenBalances[beneficiary].mul(sellPrice);
164     }
165     
166     function tokensLeft() public view returns (uint amount) {
167         amount = tokenBalances[owner];
168     }
169     
170     function payoutLeft() internal constant returns (uint amount) {
171         for (uint i=0;i<listAddr.length;i++)
172         {
173             amount = amount + amountLeftToBePaid[listAddr[i]];
174         }
175         return amount;
176     }
177     function doPayout() payable public onlyOwner{
178       uint payLeft = payoutLeft();
179       uint cashBack = msg.value;
180       require (payLeft>0 && cashBack <=payLeft);
181       uint soldTokens = totalSupply.sub(tokenBalances[owner]);
182       cashBack = cashBack.mul(10**18);
183       perTokenPayout =cashBack.div(soldTokens);
184       tokenToTakeBack = perTokenPayout.div(sellPrice);
185       makePayments();
186     }
187     
188     function makePayments() internal {
189         uint exchangeAmount;
190         uint customerAmt;
191         for (uint i=0;i<listAddr.length;i++)
192         {
193             uint payAmt = amountLeftToBePaid[listAddr[i]];
194             if (payAmt >0)
195             {
196                 uint tokensHeld = payAmt.div(sellPrice);
197                 if (tokensHeld >0)
198                 {
199                     uint sendMoney = tokensHeld.mul(perTokenPayout);
200                     sendMoney = sendMoney.div(10**decimals);
201                     uint takeBackTokens = tokenToTakeBack.mul(tokensHeld);
202                     takeBackTokens = takeBackTokens.div(10**decimals);
203                     (exchangeAmount,customerAmt) = getExchangeAndEthStoreAmount(sendMoney); 
204                     exchange.transfer(exchangeAmount);
205                     listAddr[i].transfer(customerAmt);
206                     amountLeftToBePaid[listAddr[i]] = amountLeftToBePaid[listAddr[i]].sub(sendMoney);
207                     tokenBalances[listAddr[i]] = tokenBalances[listAddr[i]].sub(takeBackTokens);
208                     tokenBalances[owner] = tokenBalances[owner].add(takeBackTokens);
209                     Transfer(listAddr[i],owner, takeBackTokens); 
210                     takeBackTokens = takeBackTokens.div(10**decimals);
211                 }
212             }
213         }
214     }
215     
216     function buy(address beneficiary) payable public returns (uint amount) {
217         require (msg.value >= 10 ** decimals);   //  see this
218         uint exchangeAmount;
219         uint ethStoreAmt;
220         (exchangeAmount,ethStoreAmt) = getExchangeAndEthStoreAmount(msg.value); 
221         ethStore.transfer(ethStoreAmt);    
222         exchange.transfer(exchangeAmount);
223         uint tempBuyPrice = buyPrice.mul(10**decimals);
224         amount = msg.value.div(tempBuyPrice);                    // calculates the amount
225         amount = amount.mul(10**decimals);
226         require(tokenBalances[owner] >= amount);               // checks if it has enough to sell
227         tokenBalances[beneficiary] = tokenBalances[beneficiary].add(amount);                  // adds the amount to buyer's balance
228         tokenBalances[owner] = tokenBalances[owner].sub(amount);                        // subtracts amount from seller's balance
229         amountLeftToBePaid[beneficiary] = amount.mul(sellPrice);   //input how much has to be paid out to the customer later on
230         Transfer(owner, beneficiary, amount);
231         listAddr.push(beneficiary);
232         return amount;                                    // ends function and returns
233     }
234    
235    function getExchangeAndEthStoreAmount(uint value) internal pure returns (uint exchangeAmt, uint ethStoreAmt) {
236        exchangeAmt = value.div(100);    //since 1% means divide by 100
237        ethStoreAmt = value - exchangeAmt;   //the rest would be eth store amount
238    }
239 }