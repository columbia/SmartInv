1 pragma solidity ^0.4.16;
2 
3 interface CCCRCoin {
4     function transfer(address receiver, uint amount);
5 }
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 /**
94  * @title Pausable
95  * @dev Base contract which allows children to implement an emergency stop mechanism.
96  */
97 contract Pausable is Ownable {
98   event Pause();
99   event Unpause();
100 
101   bool public paused = false;
102 
103 
104   /**
105    * @dev Modifier to make a function callable only when the contract is not paused.
106    */
107   modifier whenNotPaused() {
108     require(!paused);
109     _;
110   }
111 
112   /**
113    * @dev Modifier to make a function callable only when the contract is paused.
114    */
115   modifier whenPaused() {
116     require(paused);
117     _;
118   }
119 
120   /**
121    * @dev called by the owner to pause, triggers stopped state
122    */
123   function pause() onlyOwner whenNotPaused public {
124     paused = true;
125     Pause();
126   }
127 
128   /**
129    * @dev called by the owner to unpause, returns to normal state
130    */
131   function unpause() onlyOwner whenPaused public {
132     paused = false;
133     Unpause();
134   }
135 }
136 
137 contract CCCRSale is Pausable {
138     using SafeMath for uint256;
139 
140     address public investWallet = 0xbb2efFab932a4c2f77Fc1617C1a563738D71B0a7;
141     CCCRCoin public tokenReward; 
142     uint256 public tokenPrice = 856; // 1ETH (856$) / 1$
143     uint256 zeroAmount = 10000000000; // 10 zero
144     uint256 startline = 1510736400; // 15.11.17 12:00
145     uint256 public minCap = 300000000000000;
146     uint256 public totalRaised = 207008997355300;
147 
148     function CCCRSale(address _tokenReward) {
149         tokenReward = CCCRCoin(_tokenReward);
150     }
151 
152     function () whenNotPaused payable {
153         buy(msg.sender, msg.value); 
154     }
155 
156     function getRate() constant internal returns (uint256) {
157         if      (block.timestamp < startline + 19 days) return tokenPrice.mul(138).div(100);
158         else if (block.timestamp <= startline + 46 days) return tokenPrice.mul(123).div(100);
159         else if (block.timestamp <= startline + 60 days) return tokenPrice.mul(115).div(100);
160         else if (block.timestamp <= startline + 74 days) return tokenPrice.mul(109).div(100);
161         return tokenPrice;
162     }
163 
164     function buy(address buyer, uint256 _amount) whenNotPaused payable {
165         require(buyer != address(0));
166         require(msg.value != 0);
167 
168         uint256 amount = _amount.div(zeroAmount);
169         uint256 tokens = amount.mul(getRate());
170         tokenReward.transfer(buyer, tokens);
171 
172         investWallet.transfer(this.balance);
173         totalRaised = totalRaised.add(tokens);
174 
175         if (totalRaised >= minCap) {
176           paused = true;
177         }
178     }
179 
180     function updatePrice(uint256 _tokenPrice) external onlyOwner {
181         tokenPrice = _tokenPrice;
182     }
183 
184     function transferTokens(uint256 _tokens) external onlyOwner {
185         tokenReward.transfer(owner, _tokens); 
186     }
187 
188     function airdrop(address[] _array1, uint256[] _array2) external onlyOwner {
189        address[] memory arrayAddress = _array1;
190        uint256[] memory arrayAmount = _array2;
191        uint256 arrayLength = arrayAddress.length.sub(1);
192        uint256 i = 0;
193        
194       while (i <= arrayLength) {
195            tokenReward.transfer(arrayAddress[i], arrayAmount[i]);
196            i = i.add(1);
197       }  
198     }
199 
200 }