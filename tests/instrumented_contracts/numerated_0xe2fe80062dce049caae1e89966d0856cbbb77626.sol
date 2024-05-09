1 pragma solidity ^0.4.16;
2 
3 interface CCCRCoin {
4     function transfer(address receiver, uint amount);
5 }
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32 }
33 
34 contract Ownable {
35   address public owner;
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address newOwner) onlyOwner {
54     if (newOwner != address(0)) {
55       owner = newOwner;
56     }
57   }
58 
59 }
60 
61 /**
62  * @title Pausable
63  * @dev Base contract which allows children to implement an emergency stop mechanism.
64  */
65 contract Pausable is Ownable {
66   event Pause();
67   event Unpause();
68 
69   bool public paused = false;
70 
71 
72   /**
73    * @dev Modifier to make a function callable only when the contract is not paused.
74    */
75   modifier whenNotPaused() {
76     require(!paused);
77     _;
78   }
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is paused.
82    */
83   modifier whenPaused() {
84     require(paused);
85     _;
86   }
87 
88   /**
89    * @dev called by the owner to pause, triggers stopped state
90    */
91   function pause() onlyOwner whenNotPaused public {
92     paused = true;
93     Pause();
94   }
95 
96   /**
97    * @dev called by the owner to unpause, returns to normal state
98    */
99   function unpause() onlyOwner whenPaused public {
100     paused = false;
101     Unpause();
102   }
103 }
104 
105 contract CCCRSale is Pausable {
106     using SafeMath for uint256;
107 
108     address public investWallet = 0xbb2efFab932a4c2f77Fc1617C1a563738D71B0a7;
109     CCCRCoin public tokenReward; 
110     uint256 public tokenPrice = 856; // 1ETH (856$) / 1$
111     uint256 zeroAmount = 10000000000; // 10 zero
112     uint256 startline = 1510736400; // 15.11.17 12:00
113     uint256 public minCap = 300000000000000;
114     uint256 public totalRaised = 207008997355300;
115 
116     function CCCRSale(address _tokenReward) {
117         tokenReward = CCCRCoin(_tokenReward);
118     }
119 
120     function () whenNotPaused payable {
121         buy(msg.sender, msg.value); 
122     }
123 
124     function getRate() constant internal returns (uint256) {
125         if      (block.timestamp < startline + 19 days) return tokenPrice.mul(138).div(100); // 15.11.17-4.12.17 38%
126         else if (block.timestamp <= startline + 46 days) return tokenPrice.mul(123).div(100); // 4.12.17-31.12.17 23%
127         else if (block.timestamp <= startline + 60 days) return tokenPrice.mul(115).div(100); // 1.01.18-14.01.18 15%
128         else if (block.timestamp <= startline + 74 days) return tokenPrice.mul(109).div(100); // 15.01.18-28.01.18 9%
129         return tokenPrice; // 29.01.18-31.03.18 
130     }
131 
132     function buy(address buyer, uint256 _amount) whenNotPaused payable {
133         require(buyer != address(0));
134         require(msg.value != 0);
135 
136         uint256 amount = _amount.div(zeroAmount);
137         uint256 tokens = amount.mul(getRate());
138         tokenReward.transfer(buyer, tokens);
139 
140         investWallet.transfer(this.balance);
141         totalRaised = totalRaised.add(tokens);
142 
143         if (totalRaised >= minCap) {
144           paused = true;
145         }
146     }
147 
148     function updatePrice(uint256 _tokenPrice) external onlyOwner {
149         tokenPrice = _tokenPrice;
150     }
151 
152     function transferTokens(uint256 _tokens) external onlyOwner {
153         tokenReward.transfer(owner, _tokens); 
154     }
155 
156     function airdrop(address[] _array1, uint256[] _array2) external onlyOwner {
157        address[] memory arrayAddress = _array1;
158        uint256[] memory arrayAmount = _array2;
159        uint256 arrayLength = arrayAddress.length.sub(1);
160        uint256 i = 0;
161        
162        while (i <= arrayLength) {
163            tokenReward.transfer(arrayAddress[i], arrayAmount[i]);
164            i = i.add(1);
165        }  
166    }
167 
168 }