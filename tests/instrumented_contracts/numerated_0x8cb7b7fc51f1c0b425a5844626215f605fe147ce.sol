1 pragma solidity ^0.4.24;
2 interface IExchangeFormula {
3     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) external view returns (uint256);
4     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) external view returns (uint256);
5 }
6 
7 interface ITradeableAsset {
8     function totalSupply() external view returns (uint256);
9     function approve(address spender, uint tokens) external returns (bool success);
10     function transferFrom(address from, address to, uint tokens) external returns (bool success);
11     function decimals() external view returns (uint256);
12     function transfer(address _to, uint256 _value) external;
13     function balanceOf(address _address) external view returns (uint256);
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 
18 contract Administered {
19     address public creator;
20 
21     mapping (address => bool) public admins;
22 
23     constructor() public {
24         creator = msg.sender;
25         admins[creator] = true;
26     }
27 
28     modifier onlyOwner {
29         require(creator == msg.sender);
30         _;
31     }
32 
33     modifier onlyAdmin {
34         require(admins[msg.sender] || creator == msg.sender);
35         _;
36     }
37 
38     function grantAdmin(address newAdmin) onlyOwner  public {
39         _grantAdmin(newAdmin);
40     }
41 
42     function _grantAdmin(address newAdmin) internal
43     {
44         admins[newAdmin] = true;
45     }
46 
47     function changeOwner(address newOwner) onlyOwner public {
48         creator = newOwner;
49     }
50 
51     function revokeAdminStatus(address user) onlyOwner public {
52         admins[user] = false;
53     }
54 }
55 
56 contract ExchangerV4 is Administered, tokenRecipient {
57     bool public enabled = false;
58 
59     ITradeableAsset public tokenContract;
60     IExchangeFormula public formulaContract;
61     uint32 public weight;
62     uint32 public fee=5000; //0.5%
63     uint256 public uncirculatedSupplyCount=0;
64     uint256 public collectedFees=0;
65     uint256 public virtualReserveBalance=0;
66 
67     uint public thresholdSendToSafeWallet = 100000000000000000; 
68     uint public sendToSafeWalletPercentage = 10; 
69 
70     constructor(address _token,
71                 uint32 _weight,
72                 address _formulaContract) {
73         require (_weight > 0 && weight <= 1000000);
74 
75         weight = _weight;
76         tokenContract = ITradeableAsset(_token);
77         formulaContract = IExchangeFormula(_formulaContract);
78     }
79 
80     event Buy(address indexed purchaser, uint256 amountInWei, uint256 amountInToken);
81     event Sell(address indexed seller, uint256 amountInToken, uint256 amountInWei);
82 
83     function depositTokens(uint amount) onlyOwner public {
84         tokenContract.transferFrom(msg.sender, this, amount);
85     }
86 
87     function depositEther() onlyOwner public payable {
88     //return getQuotePrice();
89     }
90 
91     function withdrawTokens(uint amount) onlyOwner public {
92         tokenContract.transfer(msg.sender, amount);
93     }
94 
95     function withdrawEther(uint amountInWei) onlyOwner public {
96         msg.sender.transfer(amountInWei); //Transfers in wei
97     }
98 
99     function extractFees(uint amountInWei) onlyAdmin public {
100         require (amountInWei <= collectedFees);
101         msg.sender.transfer(amountInWei);
102     }
103 
104     function enable() onlyAdmin public {
105         enabled = true;
106     }
107 
108     function disable() onlyAdmin public {
109         enabled = false;
110     }
111 
112     function setReserveWeight(uint ppm) onlyAdmin public {
113         require (ppm>0 && ppm<=1000000);
114         weight = uint32(ppm);
115     }
116 
117     function setFee(uint ppm) onlyAdmin public {
118         require (ppm >= 0 && ppm <= 1000000);
119         fee = uint32(ppm);
120     }
121 
122     function setUncirculatedSupplyCount(uint newValue) onlyAdmin public {
123         require (newValue > 0);
124         uncirculatedSupplyCount = uint256(newValue);
125     }
126 
127     function setVirtualReserveBalance(uint256 amountInWei) onlyAdmin public {
128         virtualReserveBalance = amountInWei;
129     }
130 
131     function getReserveBalances() public view returns (uint256, uint256) {
132         return (tokenContract.balanceOf(this), address(this).balance+virtualReserveBalance);
133     }
134 
135     function getPurchasePrice(uint256 amountInWei) public view returns(uint) {
136         uint256 purchaseReturn = formulaContract.calculatePurchaseReturn(
137             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
138             address(this).balance + virtualReserveBalance,
139             weight,
140             amountInWei
141         );
142 
143         purchaseReturn = (purchaseReturn - ((purchaseReturn * fee) / 1000000));
144 
145         if (purchaseReturn > tokenContract.balanceOf(this)){
146             return tokenContract.balanceOf(this);
147         }
148         return purchaseReturn;
149     }
150 
151     function getSalePrice(uint256 tokensToSell) public view returns(uint) {
152         uint256 saleReturn = formulaContract.calculateSaleReturn(
153             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
154             address(this).balance + virtualReserveBalance,
155             weight,
156             tokensToSell
157         );
158         saleReturn = (saleReturn - ((saleReturn * fee) / 1000000));
159         if (saleReturn > address(this).balance) {
160             return address(this).balance;
161         }
162         return saleReturn;
163     }
164 
165     function buy(uint minPurchaseReturn) public payable {
166         uint amount = formulaContract.calculatePurchaseReturn(
167             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
168             (address(this).balance + virtualReserveBalance) - msg.value,
169             weight,
170             msg.value);
171         amount = (amount - ((amount * fee) / 1000000));
172 
173         require (enabled);
174         require (amount >= minPurchaseReturn);
175         require (tokenContract.balanceOf(this) >= amount);
176 
177         if(msg.value > thresholdSendToSafeWallet){
178             uint transferToSafeWallet = msg.value * sendToSafeWalletPercentage / 100;
179             creator.transfer(transferToSafeWallet);
180             virtualReserveBalance += transferToSafeWallet;
181         }
182 
183         collectedFees += (msg.value * fee) / 1000000;
184 
185         emit Buy(msg.sender, msg.value, amount);
186         tokenContract.transfer(msg.sender, amount);
187     }
188 
189     function sell(uint quantity, uint minSaleReturn) public {
190         uint amountInWei = formulaContract.calculateSaleReturn(
191             (tokenContract.totalSupply()- uncirculatedSupplyCount) - tokenContract.balanceOf(this),
192              address(this).balance + virtualReserveBalance,
193              weight,
194              quantity
195         );
196         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
197 
198         require (enabled);
199         require (amountInWei >= minSaleReturn);
200         require (amountInWei <= address(this).balance);
201         require (tokenContract.transferFrom(msg.sender, this, quantity));
202 
203         collectedFees += (amountInWei * fee) / 1000000;
204 
205         emit Sell(msg.sender, quantity, amountInWei);
206         msg.sender.transfer(amountInWei);
207     }
208 
209     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external {
210         sellOneStep(_value, 0, _from);
211     }
212 
213     function sellOneStep(uint quantity, uint minSaleReturn, address seller) public {
214         uint amountInWei = formulaContract.calculateSaleReturn(
215             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
216              address(this).balance + virtualReserveBalance,
217              weight,
218              quantity
219         );
220         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
221 
222         require (enabled);
223         require (amountInWei >= minSaleReturn);
224         require (amountInWei <= address(this).balance);
225         require (tokenContract.transferFrom(seller, this, quantity));
226 
227         collectedFees += (amountInWei * fee) / 1000000;
228 
229         emit Sell(seller, quantity, amountInWei);
230         seller.transfer(amountInWei);
231     }
232 
233     function setSendToSafeWalletPercentage(uint newValue) onlyOwner public {
234         require (newValue > 0);
235         sendToSafeWalletPercentage = uint(newValue);
236     }
237 
238     function setThresholdSendToSafeWallet(uint256 amountInWei) onlyOwner public {
239         thresholdSendToSafeWallet = amountInWei;
240     }
241 
242 }