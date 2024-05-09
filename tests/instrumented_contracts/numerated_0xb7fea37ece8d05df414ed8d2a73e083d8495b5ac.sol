1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
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
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 }
97 
98 
99 interface BittechToken {
100     function balanceOf(address who) external view returns (uint256);
101     function transfer(address receiver, uint amount) external;
102     function burn(uint256 _value) external;
103 }
104 
105 
106 contract BittechSale is Ownable {
107     using SafeMath for uint256;
108     
109     BittechToken public token;
110     uint256 public minimalPriceUSD = 10000; // 10 usd
111     uint256 public ETHUSD = 300;
112     uint256 public tokenPricePerUSD = 100; // 1 usd
113     
114     address public constant fundsWallet = 0x1ba99f4F5Aa56684423a122D72990A7851AaFD9e;
115     uint256 public startTime;
116     uint256 public constant weekTime = 604800;
117     
118     constructor() public {
119        token = BittechToken(0x6EE2EE1a5a257E6E7AdE7fe537617EaD9C7BD3D2);
120        startTime = now;
121     }
122     
123     function getBonus() public view returns (uint256) {
124         
125         if (now >= startTime.add(weekTime.mul(8))) {
126             return 104;
127         } else if (now >= startTime.add(weekTime.mul(7))) {
128             return 106;
129         } else if (now >= startTime.add(weekTime.mul(6))) {
130             return 108;
131         } else if (now >= startTime.add(weekTime.mul(5))) {
132             return 110;
133         } else if (now >= startTime.add(weekTime.mul(4))) {
134             return 112;
135         } else if (now >= startTime.add(weekTime.mul(3))) {
136             return 114;
137         } else if (now >= startTime.add(weekTime.mul(2))) {
138             return 116;
139         } else if (now >= startTime.add(weekTime)) {
140             return 118;
141         } else {
142             return 120;
143         }
144         
145     }
146     
147     function () external payable {
148         require(msg.sender != address(0));
149         require(msg.value.mul(ETHUSD) >= minimalPriceUSD.mul(10 ** 18).div(1000));
150         
151         uint256 tokens = msg.value.mul(ETHUSD).mul(getBonus()).mul(tokenPricePerUSD).div(100).div(100);
152         token.transfer(msg.sender, tokens);
153         
154         if (now >= startTime.add(weekTime.mul(8))) {
155             fundsWallet.transfer(address(this).balance);
156             token.burn(token.balanceOf(address(this)));
157         }
158     }
159     
160     function sendTokens(address _to, uint256 _amount) external onlyOwner {
161         token.transfer(_to, _amount);
162     }
163     
164     function updatePrice(uint256 _ETHUSD) onlyOwner public {
165         ETHUSD = _ETHUSD;
166     }
167 
168     function updateMinimal(uint256 _minimalPriceUSD) onlyOwner public {
169         minimalPriceUSD = _minimalPriceUSD;
170     }
171 
172     function updateTokenPricePerUSD(uint256 _tokenPricePerUSD) onlyOwner public {
173         tokenPricePerUSD = _tokenPricePerUSD;
174     }
175     
176 }