1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18         }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29     address public wallet;
30 
31     function Ownable() internal {
32         owner = msg.sender;
33         wallet = msg.sender;
34     }
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 }
41 
42 contract EthColorAccount {
43     using SafeMath for uint256;
44 
45     struct Account {
46         uint256 balance;
47         address referrer;
48     }
49 
50     mapping (address => Account) accounts;
51 
52     event Withdraw(address indexed withdrawAddress, uint256 withdrawValue);
53     event Transfer(address indexed addressFrom, address indexed addressTo, uint256 value, uint256 pixelId);
54 
55     // Check account detail
56     function getAccountBalance(address userAddress) constant public returns (uint256) {
57         return accounts[userAddress].balance;
58     }
59     function getAccountReferrer(address userAddress) constant public returns (address) {
60         return accounts[userAddress].referrer;
61     }
62 
63     // To withdraw your account balance from this contract.
64     function withdrawETH(uint256 amount) external {
65         assert(amount > 0);
66         assert(accounts[msg.sender].balance >= amount);
67 
68         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(amount);
69         msg.sender.transfer(amount);
70         Withdraw(msg.sender, amount);
71     }
72 
73     function transferToAccount(uint256 pixelId, address toWallet, uint256 permil, uint256 gridPrice) internal {
74         accounts[toWallet].balance = accounts[toWallet].balance.add(gridPrice.mul(permil).div(1000));
75         Transfer(msg.sender, toWallet, gridPrice.mul(permil).div(1000), pixelId);
76     }
77 }
78 
79 contract EthColor is Ownable, EthColorAccount {
80     using SafeMath for uint256;
81 
82     struct Pixel {
83         uint256 color;
84         uint256 times;
85         address owner;
86         uint256 price;
87     }
88 
89     Pixel [16384] public pixels;
90 
91     string public constant name = "Ethcolor";
92     string public constant version = "1.0.0";
93     uint256 public constant initialPrice = 0.08 ether;
94 
95     event Drawcolor(uint256 indexed drawGridLocation, address indexed drawerAddress, uint256 colorDraw, uint256 spend);
96 
97     function getColors() constant public returns (uint256[16384]) {
98         uint256[16384] memory result;
99         for (uint256 i = 0; i < 16384; i++) {
100             result[i] = pixels[i].color;
101         }
102         return result;
103     }
104 
105     function getTimes() constant public returns (uint256[16384]) {
106         uint256[16384] memory result;
107         for (uint256 i = 0; i < 16384; i++) {
108             result[i] = pixels[i].times;
109         }
110         return result;
111     }
112 
113     function getOwners() constant public returns (address[16384]) {
114         address[16384] memory result;
115         for (uint256 i = 0; i < 16384; i++) {
116             result[i] = pixels[i].owner;
117         }
118         return result;
119     }
120 
121     function drawColors(uint256[] pixelIdxs, uint256[] colors, address referralAddress) payable public {
122         assert(pixelIdxs.length == colors.length);
123 
124         // Set referral address
125         if ((accounts[msg.sender].referrer == address(0)) &&
126             (referralAddress != msg.sender) &&
127             (referralAddress != address(0))) {
128 
129             accounts[msg.sender].referrer = referralAddress;
130         }
131 
132         uint256 remainValue = msg.value;
133         uint256 price;
134         for (uint256 i = 0; i < pixelIdxs.length; i++) {
135             uint256 pixelIdx = pixelIdxs[i];
136             if (pixels[pixelIdx].times == 0) {
137                 price = initialPrice.mul(9).div(10);
138             } else if (pixels[pixelIdx].times == 1){
139                 price = initialPrice.mul(11).div(10);
140             } else {
141                 price = pixels[pixelIdx].price.mul(11).div(10);
142             }
143 
144             if (remainValue < price) {
145               // If the eth is not enough, the eth will be returned to his account on the contract.
146               transferToAccount(pixelIdx, msg.sender, 1000, remainValue);
147               break;
148             }
149 
150             assert(colors[i] < 25);
151             remainValue = remainValue.sub(price);
152 
153             // Update pixel
154             pixels[pixelIdx].color = colors[i];
155             pixels[pixelIdx].times = pixels[pixelIdx].times.add(1);
156             pixels[pixelIdx].price = price;
157             Drawcolor(pixelIdx, msg.sender, colors[i], price);
158 
159             transferETH(pixelIdx , price);
160 
161             // Update pixel owner
162             pixels[pixelIdx].owner = msg.sender;
163         }
164     }
165 
166     // Transfer the ETH in contract balance
167     function transferETH(uint256 pixelId, uint256 drawPrice) internal {
168         // Transfer 97% to the last owner
169         if (pixels[pixelId].times > 1) {
170             transferToAccount(pixelId, pixels[pixelId].owner, 970, drawPrice);
171         } else {
172             transferToAccount(pixelId, wallet, 970, drawPrice);
173         }
174 
175         if (accounts[msg.sender].referrer != address(0)) {
176             // If account is referred, transfer 1% to referrer and 1% to referree
177             transferToAccount(pixelId, accounts[msg.sender].referrer, 10, drawPrice);
178             transferToAccount(pixelId, msg.sender, 10, drawPrice);
179             transferToAccount(pixelId, wallet, 10, drawPrice);
180         } else {
181             transferToAccount(pixelId, wallet, 30, drawPrice);
182         }
183     }
184 
185     function finalize() onlyOwner public {
186         require(msg.sender == wallet);
187         // Check for after the end time: 2018/12/31 23:59:59 UTC
188         require(now >= 1546300799);
189         wallet.transfer(this.balance);
190     }
191 
192     // Fallback function
193     function () external {
194     }
195 }