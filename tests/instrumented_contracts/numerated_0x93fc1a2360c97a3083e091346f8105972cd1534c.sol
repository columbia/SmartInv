1 pragma solidity ^0.4.21;
2 
3 /* This contract is the Proof of Community whale contract that will buy and sell tokens to share dividends to token holders.
4    This contract can also handle multiple games to donate ETH to it, which will be needed for future game developement.
5 
6     Kenny - Solidity developer
7 	Bungalogic - website developer, concept and design, graphics. 
8 
9 
10    该合同是社区鲸鱼合同的证明，它将购买和出售代币以向代币持有者分享股息。
11    该合同还可以处理多个游戏以向其捐赠ETH，这将是未来游戏开发所需要的。  
12 
13    Kenny  -  Solidity开发人员
14    Bungalogic  - 网站开发人员，概念和设计，图形。
15 */
16 
17 
18 
19 contract Kujira 
20 { 
21     /*
22       Modifiers
23       修饰符
24      */
25 
26     // Only the people that published this contract
27     // 只有发布此合同的人才
28     modifier onlyOwner()
29     {
30         require(msg.sender == owner || msg.sender == owner2);
31         _;
32     }
33     
34     // Only PoC token contract
35     // 只有PoC令牌合同
36     modifier notPoC(address aContract)
37     {
38         require(aContract != address(pocContract));
39         _;
40     }
41    
42     /*
43       Events
44       活动
45      */
46     event Deposit(uint256 amount, address depositer);
47     event Purchase(uint256 amountSpent, uint256 tokensReceived);
48     event Sell();
49     event Payout(uint256 amount, address creditor);
50     event Transfer(uint256 amount, address paidTo);
51 
52    /**
53       Global Variables
54       全局变量
55      */
56     address owner;
57     address owner2;
58     PoC pocContract;
59     uint256 tokenBalance;
60    
61     
62     /*
63        Constructor
64        施工人
65      */
66     constructor(address owner2Address) 
67     public 
68     {
69         owner = msg.sender;
70         owner2 = owner2Address;
71         pocContract = PoC(address(0x1739e311ddBf1efdFbc39b74526Fd8b600755ADa));
72         tokenBalance = 0;
73     }
74     
75     function() payable public { }
76      
77     /*
78       Only way to give contract ETH and have it immediately use it, is by using donate function
79       给合同ETH并让它立即使用的唯一方法是使用捐赠功能
80      */
81     function donate() 
82     public payable 
83     {
84         //You have to send more than 1000000 wei
85         //你必须发送超过1000000 wei
86         require(msg.value > 1000000 wei);
87         uint256 ethToTransfer = address(this).balance;
88         uint256 PoCEthInContract = address(pocContract).balance;
89        
90         // if PoC contract balance is less than 5 ETH, PoC is dead and there is no reason to pump it
91         // 如果PoC合同余额低于5 ETH，PoC已经死亡，没有理由将其泵出
92         if(PoCEthInContract < 5 ether)
93         {
94             pocContract.exit();
95             tokenBalance = 0;
96             ethToTransfer = address(this).balance;
97 
98             owner.transfer(ethToTransfer);
99             emit Transfer(ethToTransfer, address(owner));
100         }
101 
102         // let's buy and sell tokens to give dividends to PoC tokenholders
103         // 让我们买卖代币给PoC代币持有人分红
104         else
105         {
106             tokenBalance = myTokens();
107 
108              // if token balance is greater than 0, sell and rebuy 
109              // 如果令牌余额大于0，则出售并重新购买
110 
111             if(tokenBalance > 0)
112             {
113                 pocContract.exit();
114                 tokenBalance = 0; 
115 
116                 ethToTransfer = address(this).balance;
117 
118                 if(ethToTransfer > 0)
119                 {
120                     pocContract.buy.value(ethToTransfer)(0x0);
121                 }
122                 else
123                 {
124                     pocContract.buy.value(msg.value)(0x0);
125                 }
126             }
127             else
128             {   
129                 // we have no tokens, let's buy some if we have ETH balance
130                 // 我们没有代币，如果我们有ETH余额，我们就买一些
131                 if(ethToTransfer > 0)
132                 {
133                     pocContract.buy.value(ethToTransfer)(0x0);
134                     tokenBalance = myTokens();
135                     emit Deposit(msg.value, msg.sender);
136                 }
137             }
138         }
139     }
140 
141     
142     /**
143        Number of tokens the contract owns.
144        合同拥有的代币数量。
145      */
146     function myTokens() 
147     public 
148     view 
149     returns(uint256)
150     {
151         return pocContract.myTokens();
152     }
153     
154     /**
155        Number of dividends owed to the contract.
156        欠合同的股息数量。
157      */
158     function myDividends() 
159     public 
160     view 
161     returns(uint256)
162     {
163         return pocContract.myDividends(true);
164     }
165 
166     /**
167        ETH balance of contract
168        合约的ETH余额
169      */
170     function ethBalance() 
171     public 
172     view 
173     returns (uint256)
174     {
175         return address(this).balance;
176     }
177 
178     /**
179        If someone sends tokens other than PoC tokens, the owner can return them.
180        如果有人发送除PoC令牌以外的令牌，则所有者可以退回它们。
181      */
182     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) 
183     public 
184     onlyOwner() 
185     notPoC(tokenAddress) 
186     returns (bool success) 
187     {
188         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
189     }
190     
191 }
192 
193 // Define the PoC token for the contract
194 // 为合同定义PoC令牌
195 contract PoC 
196 {
197     function buy(address) public payable returns(uint256);
198     function exit() public;
199     function myTokens() public view returns(uint256);
200     function myDividends(bool) public view returns(uint256);
201     function totalEthereumBalance() public view returns(uint);
202 }
203 
204 // Define ERC20Interface.transfer, so contract can transfer tokens accidently sent to it.
205 // 定义ERC20 Interface.transfer，因此合同可以转移意外发送给它的令牌。
206 contract ERC20Interface 
207 {
208     function transfer(address to, uint256 tokens) 
209     public 
210     returns (bool success);
211 }