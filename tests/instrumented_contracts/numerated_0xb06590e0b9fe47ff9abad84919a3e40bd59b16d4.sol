1 // produced by the Solididy File Flattener (c) David Appleton 2018
2 // contact : dave@akomba.com
3 // released under Apache 2.0 licence
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipRenounced(address indexed previousOwner);
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to relinquish control of the contract.
79    */
80   function renounceOwnership() public onlyOwner {
81     emit OwnershipRenounced(owner);
82     owner = address(0);
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param _newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address _newOwner) public onlyOwner {
90     _transferOwnership(_newOwner);
91   }
92 
93   /**
94    * @dev Transfers control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function _transferOwnership(address _newOwner) internal {
98     require(_newOwner != address(0));
99     emit OwnershipTransferred(owner, _newOwner);
100     owner = _newOwner;
101   }
102 }
103 
104 contract Claimable is Ownable {
105   address public pendingOwner;
106 
107   /**
108    * @dev Modifier throws if called by any account other than the pendingOwner.
109    */
110   modifier onlyPendingOwner() {
111     require(msg.sender == pendingOwner);
112     _;
113   }
114 
115   /**
116    * @dev Allows the current owner to set the pendingOwner address.
117    * @param newOwner The address to transfer ownership to.
118    */
119   function transferOwnership(address newOwner) onlyOwner public {
120     pendingOwner = newOwner;
121   }
122 
123   /**
124    * @dev Allows the pendingOwner address to finalize the transfer.
125    */
126   function claimOwnership() onlyPendingOwner public {
127     emit OwnershipTransferred(owner, pendingOwner);
128     owner = pendingOwner;
129     pendingOwner = address(0);
130   }
131 }
132 
133 contract AmmuNationStore is Claimable{
134 
135     using SafeMath for uint256;
136 
137     GTAInterface public token;
138 
139     uint256 private tokenSellPrice; //wei
140     uint256 private tokenBuyPrice; //wei
141     uint256 public buyDiscount; //%
142 
143     event Buy(address buyer, uint256 amount, uint256 payed);
144     event Robbery(address robber);
145 
146     constructor (address _tokenAddress) public {
147         token = GTAInterface(_tokenAddress);
148     }
149 
150     /** Owner's operations to fill and empty the stock */
151 
152     // Important! remember to call GoldenThalerToken(address).approve(this, amount)
153     // or this contract will not be able to do the transfer on your behalf.
154     function depositGTA(uint256 amount) onlyOwner public {
155         require(token.transferFrom(msg.sender, this, amount), "Insufficient funds");
156     }
157 
158     function withdrawGTA(uint256 amount) onlyOwner public {
159         require(token.transfer(msg.sender, amount), "Amount exceeds the available balance");
160     }
161 
162     function robCashier() onlyOwner public {
163         msg.sender.transfer(address(this).balance);
164         emit Robbery(msg.sender);
165     }
166 
167     /** */
168 
169     /**
170    * @dev Set the prices in wei for 1 GTA
171    * @param _newSellPrice The price people can sell GTA for
172    * @param _newBuyPrice The price people can buy GTA for
173    */
174     function setTokenPrices(uint256 _newSellPrice, uint256 _newBuyPrice) onlyOwner public {
175         tokenSellPrice = _newSellPrice;
176         tokenBuyPrice = _newBuyPrice;
177     }
178 
179 
180     function buy() payable public returns (uint256){
181         //note: the price of 1 GTA is in wei, but the token transfer expects the amount in 'token wei'
182         //so we're missing 10*18
183         uint256 value = msg.value.mul(1 ether);
184         uint256 _buyPrice = tokenBuyPrice;
185         if (buyDiscount > 0) {
186             //happy discount!
187             _buyPrice = _buyPrice.sub(_buyPrice.mul(buyDiscount).div(100));
188         }
189         uint256 amount = value.div(_buyPrice);
190         require(token.balanceOf(this) >= amount, "Sold out");
191         require(token.transfer(msg.sender, amount), "Couldn't transfer token");
192         emit Buy(msg.sender, amount, msg.value);
193         return amount;
194     }
195 
196     // Important! remember to call GoldenThalerToken(address).approve(this, amount)
197     // or this contract will not be able to do the transfer on your behalf.
198     //TODO No sell at this moment
199     /*function sell(uint256 amount) public returns (uint256){
200         require(token.balanceOf(msg.sender) >= amount, "Insufficient funds");
201         require(token.transferFrom(msg.sender, this, amount), "Couldn't transfer token");
202         uint256 revenue = amount.mul(tokenSellPrice).div(1 ether);
203         msg.sender.transfer(revenue);
204         return revenue;
205     }*/
206 
207     function applyDiscount(uint256 discount) onlyOwner public {
208         buyDiscount = discount;
209     }
210 
211     function getTokenBuyPrice() public view returns (uint256) {
212         uint256 _buyPrice = tokenBuyPrice;
213         if (buyDiscount > 0) {
214             _buyPrice = _buyPrice.sub(_buyPrice.mul(buyDiscount).div(100));
215         }
216         return _buyPrice;
217     }
218 
219     function getTokenSellPrice() public view returns (uint256) {
220         return tokenSellPrice;
221     }
222 }
223 
224 /**
225  * @title GTA contract interface
226  */
227 interface GTAInterface {
228 
229     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
230 
231     function transfer(address to, uint256 value) external returns (bool);
232 
233     function balanceOf(address _owner) external view returns (uint256);
234 
235 }