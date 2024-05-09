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
60   address public manager;
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68     manager = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     owner = newOwner;
82   }
83   
84   modifier onlyManager() {
85     require(msg.sender == manager || msg.sender == owner);
86     _;
87   }
88 
89   function transferManagment(address newManager) public onlyOwner {
90     require(newManager != address(0));
91     manager = newManager;
92   }
93 
94 }
95 
96 /**
97  * @title Pausable
98  * @dev Base contract which allows children to implement an emergency stop mechanism.
99  */
100 contract Pausable is Ownable {
101 
102   bool public paused = false;
103   bool public finished = false;
104   
105   modifier whenSaleNotFinish() {
106     require(!finished);
107     _;
108   }
109 
110   modifier whenSaleFinish() {
111     require(finished);
112     _;
113   }
114 
115   modifier whenNotPaused() {
116     require(!paused);
117     _;
118   }
119 
120   modifier whenPaused() {
121     require(paused);
122     _;
123   }
124 
125   function pause() onlyOwner whenNotPaused public {
126     paused = true;
127   }
128 
129   function unpause() onlyOwner whenPaused public {
130     paused = false;
131   }
132 }
133 
134 contract CCCRSale is Pausable {
135     using SafeMath for uint256;
136 
137     address public investWallet = 0xbb2efFab932a4c2f77Fc1617C1a563738D71B0a7;
138     CCCRCoin public tokenReward; 
139     uint256 public tokenPrice = 723; // 1ETH / 1$
140     uint256 zeroAmount = 10000000000; // 10 zero
141     uint256 startline = 1510736400; // 15.11.17 12:00
142     uint256 public minCap = 300000000000000;
143     uint256 public totalRaised = 207038943697300;
144     uint256 public etherOne = 1000000000000000000;
145     uint256 public minimumTokens = 10;
146 
147     function CCCRSale(address _tokenReward) {
148         tokenReward = CCCRCoin(_tokenReward);
149     }
150 
151     function bytesToAddress(bytes source) internal pure returns(address) {
152         uint result;
153         uint mul = 1;
154         for(uint i = 20; i > 0; i--) {
155             result += uint8(source[i-1])*mul;
156             mul = mul*256;
157         }
158         return address(result);
159     }
160 
161     function () whenNotPaused whenSaleNotFinish payable {
162 
163       require(msg.value >= etherOne.div(tokenPrice).mul(minimumTokens));
164         
165       uint256 amountWei = msg.value;        
166       uint256 amount = amountWei.div(zeroAmount);
167       uint256 tokens = amount.mul(getRate());
168       
169       if(msg.data.length == 20) {
170           address referer = bytesToAddress(bytes(msg.data));
171           require(referer != msg.sender);
172           referer.transfer(amountWei.div(100).mul(20));
173       }
174       
175       tokenReward.transfer(msg.sender, tokens);
176       investWallet.transfer(this.balance);
177       totalRaised = totalRaised.add(tokens);
178 
179       if (totalRaised >= minCap) {
180           finished = true;
181       }
182     }
183 
184     function getRate() constant internal returns (uint256) {
185         if      (block.timestamp < startline + 19 days) return tokenPrice.mul(138).div(100);
186         else if (block.timestamp <= startline + 46 days) return tokenPrice.mul(123).div(100);
187         else if (block.timestamp <= startline + 60 days) return tokenPrice.mul(115).div(100);
188         else if (block.timestamp <= startline + 74 days) return tokenPrice.mul(109).div(100);
189         return tokenPrice;
190     }
191 
192     function updatePrice(uint256 _tokenPrice) external onlyManager {
193         tokenPrice = _tokenPrice;
194     }
195 
196     function transferTokens(uint256 _tokens) external onlyManager {
197         tokenReward.transfer(msg.sender, _tokens); 
198     }
199 
200     function newMinimumTokens(uint256 _minimumTokens) external onlyManager {
201         minimumTokens = _minimumTokens; 
202     }
203 
204     function getWei(uint256 _etherAmount) external onlyManager {
205         uint256 etherAmount = _etherAmount.mul(etherOne);
206         investWallet.transfer(etherAmount); 
207     }
208 
209     function airdrop(address[] _array1, uint256[] _array2) external whenSaleNotFinish onlyManager {
210        address[] memory arrayAddress = _array1;
211        uint256[] memory arrayAmount = _array2;
212        uint256 arrayLength = arrayAddress.length.sub(1);
213        uint256 i = 0;
214        
215       while (i <= arrayLength) {
216            tokenReward.transfer(arrayAddress[i], arrayAmount[i]);
217            i = i.add(1);
218       }  
219     }
220 
221 }