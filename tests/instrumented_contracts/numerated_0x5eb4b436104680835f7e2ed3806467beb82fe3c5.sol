1 pragma solidity ^0.4.24;
2 
3 /*
4     YumeriumManager(address ethwallet, address YUM Token)   
5     @author Yumerium Ltd
6 */
7 contract YumeriumManager {
8     using SafeMath for uint256;
9     address public creator;
10 
11     YUM public Yumerium;
12     address public YumeriumTeamWallet;
13     mapping (address => bool) public YumeriumProducts;
14     address[] public arrProducts; // array of players to tract and distribute them tokens when the game ends
15 
16     uint public eventSaleEnd = 1537920000; // 09/26/2018 @ 12:00am (UTC)
17     uint public mainSaleEnd = 1539129600; //10/10/2018 @ 12:00am (UTC)
18 
19     uint256 public saleExchangeRate4 = 3333;
20     uint256 public saleExchangeRate5 = 3158;
21     uint256 public saleExchangeRate = 3000;
22     
23     uint256 public volumeType1 = 1429 * 10 ** 16; //14.29 eth
24     uint256 public volumeType2 = 7143 * 10 ** 16;
25     uint256 public volumeType3 = 14286 * 10 ** 16;
26     uint256 public volumeType4 = 42857 * 10 ** 16;
27     uint256 public volumeType5 = 71429 * 10 ** 16;
28     uint256 public volumeType6 = 142857 * 10 ** 16;
29     uint256 public volumeType7 = 428571 * 10 ** 16;
30 
31     event GetYumerium(address product, address sender, uint256 amount);
32 
33     constructor(address _token_address) public {
34         creator = msg.sender;
35         Yumerium = YUM(_token_address);
36         YumeriumTeamWallet = msg.sender;
37         YumeriumProducts[this] = true;
38     }
39 
40     function () external payable {
41         getYumerium(msg.sender);
42     }
43     
44     
45     function getYumerium(address sender) public payable returns (uint256) {
46         require(YumeriumProducts[msg.sender], "This isn't our product!");
47         uint256 amount;
48         uint256 exchangeRate;
49         if(now < eventSaleEnd) {
50             exchangeRate = saleExchangeRate4;
51         } else if (now < mainSaleEnd) { // this must be applied even after the sale period is done
52             exchangeRate = saleExchangeRate5;
53         } else { // this must be applied even after the sale period is done
54             exchangeRate = saleExchangeRate;
55         }
56         
57         amount = msg.value.mul(exchangeRate).div(10 ** 10);
58         
59         if(msg.value >= volumeType7) {
60             amount = amount.mul(180).div(100);
61         } else if(msg.value >= volumeType6) {
62             amount = amount.mul(160).div(100);
63         } else if(msg.value >= volumeType5) {
64             amount = amount.mul(140).div(100);
65         } else if(msg.value >= volumeType4) {
66             amount = amount.mul(130).div(100);
67         } else if(msg.value >= volumeType3) {
68             amount = amount.mul(120).div(100);
69         } else if(msg.value >= volumeType2) {
70             amount = amount.mul(110).div(100);
71         } else if(msg.value >= volumeType1) {
72             amount = amount.mul(105).div(100);
73         }
74 
75         YumeriumTeamWallet.transfer(msg.value);
76         Yumerium.sale(sender, amount);
77         
78         emit GetYumerium(msg.sender, sender, amount);
79         return amount;
80     }
81 
82     function calculateToken(uint256 ethValue) public view returns (uint256) {
83         uint256 amount;
84         uint256 exchangeRate;
85         if(now < eventSaleEnd) {
86             exchangeRate = saleExchangeRate4;
87         } else if (now < mainSaleEnd) { // this must be applied even after the sale period is done
88             exchangeRate = saleExchangeRate5;
89         } else { // this must be applied even after the sale period is done
90             exchangeRate = saleExchangeRate;
91         }
92         
93         amount = ethValue.mul(exchangeRate).div(10 ** 10);
94         
95         if(ethValue >= volumeType7) {
96             amount = amount.mul(180).div(100);
97         } else if(ethValue >= volumeType6) {
98             amount = amount.mul(160).div(100);
99         } else if(ethValue >= volumeType5) {
100             amount = amount.mul(140).div(100);
101         } else if(ethValue >= volumeType4) {
102             amount = amount.mul(130).div(100);
103         } else if(ethValue >= volumeType3) {
104             amount = amount.mul(120).div(100);
105         } else if(ethValue >= volumeType2) {
106             amount = amount.mul(110).div(100);
107         } else if(ethValue >= volumeType1) {
108             amount = amount.mul(105).div(100);
109         }
110 
111         return amount;
112     }
113 
114     // change creator address
115     function changeCreator(address _creator) external {
116         require(msg.sender==creator, "You're not a creator!");
117         creator = _creator;
118     }
119     // change creator address
120     function changeTeamWallet(address _teamWallet) external {
121         require(msg.sender==creator, "You're not a creator!");
122         YumeriumTeamWallet = _teamWallet;
123     }
124 
125     // change creator address
126     function addProduct(address _contractAddress) external {
127         require(msg.sender==creator, "You're not a creator!");
128         require(!YumeriumProducts[_contractAddress], "This product is already in the manager");
129         if (!YumeriumProducts[_contractAddress])
130         {
131             YumeriumProducts[_contractAddress] = true;
132             arrProducts.push(_contractAddress);
133         }
134     }
135     // change creator address
136     function replaceProduct(address _old_contract_address, address _new_contract_address) external {
137         require(msg.sender==creator, "You're not a creator!");
138         require(YumeriumProducts[_old_contract_address], "This product isn't already in the manager");
139         if (YumeriumProducts[_old_contract_address])
140         {
141             YumeriumProducts[_old_contract_address] = false;
142             for (uint256 i = 0; i < arrProducts.length; i++) {
143                 if (arrProducts[i] == _old_contract_address) {
144                     arrProducts[i] = _new_contract_address;
145                     YumeriumProducts[_new_contract_address] = true;
146                     break;
147                 }
148             }
149         }
150     }
151 
152     function getNumProducts() public view returns(uint256) {
153         return arrProducts.length;
154     }
155 }
156 
157 contract YUM {
158     function sale(address to, uint256 value) public;
159 }
160 
161 /**
162  * @title SafeMath
163  * @dev Math operations with safety checks that throw on error
164  */
165 library SafeMath {
166 
167     /**
168     * @dev Multiplies two numbers, throws on overflow.
169     */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
171         if (a == 0) {
172             return 0;
173         }
174         c = a * b;
175         assert(c / a == b);
176         return c;
177     }
178 
179     /**
180     * @dev Integer division of two numbers, truncating the quotient.
181     */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         // assert(b > 0); // Solidity automatically throws when dividing by 0
184         // uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186         return a / b;
187     }
188 
189     /**
190     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
191     */
192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193         assert(b <= a);
194         return a - b;
195     }
196 
197     /**
198     * @dev Adds two numbers, throws on overflow.
199     */
200     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
201         c = a + b;
202         assert(c >= a);
203         return c;
204     }
205 }