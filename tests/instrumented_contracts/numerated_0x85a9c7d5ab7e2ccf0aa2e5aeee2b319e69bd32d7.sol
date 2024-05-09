1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * VNET Token Pre-Sale Contract
6  * 
7  * Send ETH here, and you will receive the VNET Tokens immediately.
8  * 
9  * https://vision.network/
10  */
11 
12 
13 /**
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19     function totalSupply() public view returns (uint256);
20     function balanceOf(address _who) public view returns (uint256);
21     function transfer(address _to, uint256 _value) public returns (bool);
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 }
24 
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32     address public owner;
33 
34 
35     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
36 
37 
38     /**
39      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40      * account.
41      */
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     /**
55      * @dev Allows the current owner to transfer control of the contract to a newOwner.
56      * @param _newOwner The address to transfer ownership to.
57      */
58     function transferOwnership(address _newOwner) public onlyOwner {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 
64     /**
65      * @dev Rescue compatible ERC20Basic Token
66      *
67      * @param _token ERC20Basic The address of the token contract
68      */
69     function rescueTokens(ERC20Basic _token, address _receiver) external onlyOwner {
70         uint256 balance = _token.balanceOf(this);
71         assert(_token.transfer(_receiver, balance));
72     }
73 }
74 
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81 
82     /**
83      * @dev Multiplies two numbers, throws on overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
86         if (a == 0) {
87             return 0;
88         }
89         c = a * b;
90         assert(c / a == b);
91         return c;
92     }
93 
94     /**
95      * @dev Integer division of two numbers, truncating the quotient.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         // assert(b > 0); // Solidity automatically throws when dividing by 0
99         // uint256 c = a / b;
100         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101         return a / b;
102     }
103 
104     /**
105      * @dev Adds two numbers, throws on overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108         c = a + b;
109         assert(c >= a);
110         return c;
111     }
112 
113     /**
114      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         assert(b <= a);
118         return a - b;
119     }
120 }
121 
122 
123 /**
124  * @title VNET Token Pre-Sale
125  */
126 contract VNETTokenPreSale is Ownable {
127     using SafeMath for uint256;
128 
129     string public description = "VNET Token Pre-Sale Contract";
130     
131     ERC20Basic public vnetToken;
132     address wallet;
133     uint256 public ratioNext; // with 6 decimals
134     uint256 public ethPrice; // with 8 decimals
135     uint256 public vnetSold; // with 8 decimals
136     uint256 public vnetSupply = 30 * (10 ** 8) * (10 ** 6); // 30 billion supply
137     uint256 public vnetPriceStart = 0.0013 * (10 ** 8); // 0.0013 USD
138     uint256 public vnetPriceTarget = 0.0035 * (10 ** 8); // 0.0035 USD
139     uint256 public weiMinimum = 1 * (10 ** 18); // 1 Ether
140     uint256 public weiMaximum = 100 * (10 ** 18); // 100 Ether
141     uint256 public weiWelfare = 10 * (10 ** 18); // 10 Ether
142 
143     mapping(address => bool) public welfare;
144 
145     event Welfare(address indexed _buyer);
146     event BuyVNET(address indexed _buyer, uint256 _ratio, uint256 _vnetAmount, uint256 _weiAmount);
147     event EthPrice(uint256 _ethPrice);
148 
149 
150     /**
151      * @dev Constructor
152      */
153     constructor(ERC20Basic _vnetToken, uint256 _ethPrice) public {
154         vnetToken = _vnetToken;
155         wallet = owner;
156         calcRatioNext();
157         updateEthPrice(_ethPrice);
158     }
159 
160     /**
161      * @dev receive ETH and send tokens
162      */
163     function () public payable {
164         // Make sure token balance > 0
165         uint256 vnetBalance = vnetToken.balanceOf(address(this));
166         require(vnetBalance > 0);
167         require(vnetSold < vnetSupply);
168         
169         // Minimum & Maximum Limit
170         uint256 weiAmount = msg.value;
171         require(weiAmount >= weiMinimum);
172         require(weiAmount <= weiMaximum);
173 
174         // VNET Token Amount to be transfer
175         uint256 vnetAmount = weiAmount.mul(ratioNext).div(10 ** 18);
176 
177         // Transfer VNET
178         if (vnetBalance >= vnetAmount) {
179             assert(vnetToken.transfer(msg.sender, vnetAmount));
180             emit BuyVNET(msg.sender, ratioNext, vnetAmount, weiAmount);
181             vnetSold = vnetSold.add(vnetAmount);
182             if (weiAmount >= weiWelfare) {
183                 welfare[msg.sender] = true;
184                 emit Welfare(msg.sender);
185             }
186         } else {
187             uint256 weiExpend = vnetBalance.mul(10 ** 18).div(ratioNext);
188             assert(vnetToken.transfer(msg.sender, vnetBalance));
189             emit BuyVNET(msg.sender, ratioNext, vnetBalance, weiExpend);
190             vnetSold = vnetSold.add(vnetBalance);
191             msg.sender.transfer(weiAmount.sub(weiExpend));
192             if (weiExpend >= weiWelfare) {
193                 welfare[msg.sender] = true;
194                 emit Welfare(msg.sender);
195             }
196         }
197 
198         // Calculate: ratioNext
199         calcRatioNext();
200 
201         // transfer Ether
202         uint256 etherBalance = address(this).balance;
203         wallet.transfer(etherBalance);
204     }
205 
206     /**
207      * @dev calculate ration next
208      */
209     function calcRatioNext() private {
210         ratioNext = ethPrice.mul(10 ** 6).div(vnetPriceStart.add(vnetPriceTarget.sub(vnetPriceStart).mul(vnetSold).div(vnetSupply)));
211     }
212 
213     /**
214      * @dev update wallet
215      */
216     function updateWallet(address _wallet) onlyOwner public {
217         wallet = _wallet;
218     }
219 
220     /**
221      * @dev update ETH Price
222      */
223     function updateEthPrice(uint256 _ethPrice) onlyOwner public {
224         ethPrice = _ethPrice;
225         emit EthPrice(_ethPrice);
226         calcRatioNext();
227     }
228 }