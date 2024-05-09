1 pragma solidity ^0.4.21;
2 
3 /*
4   
5     ****************************************************************
6     AVALANCHE BLOCKCHAIN GENESIS BLOCK COIN ALLOCATION SALE CONTRACT
7     ****************************************************************
8 
9     The Genesis Block in the Avalanche will deploy with pre-filled addresses
10     according to the results of this token sale.
11     
12     The Avalanche tokens will be sent to the Ethereum address that buys them.
13     
14     When the Avalanche blockchain deploys, all ethereum addresses that contains
15     Avalanche tokens will be credited with the equivalent AVALANCHE ICE (XAI) in the Genesis Block.
16 
17     There will be no developer premine. There will be no private presale. This is it.
18 
19     @author CHRIS DCOSTA For Meek Inc 2018.
20     
21     Reference Code by Hunter Long
22     @repo https://github.com/hunterlong/ethereum-ico-contract
23 
24 */
25 
26 
27 contract ERC20 {
28   uint public totalSupply;
29   function balanceOf(address who) public constant returns (uint);
30   function allowance(address owner, address spender) public constant returns (uint);
31   function transfer(address to, uint value) public returns (bool ok);
32   function transferFrom(address from, address to, uint value) public returns (bool ok);
33   function approve(address spender, uint value) public returns (bool ok);
34   function mintToken(address to, uint256 value) public returns (uint256);
35   function changeTransfer(bool allowed) public;
36 }
37 
38 
39 contract Sale {
40 
41     uint256 public maxMintable;
42     uint256 public totalMinted;
43     uint public endBlock;
44     uint public startBlock;
45     uint public exchangeRate;
46     bool public isFunding;
47     ERC20 public Token;
48     address public ETHWallet;
49     uint256 public heldTotal;
50 
51     bool private configSet;
52     address public creator;
53 
54     event Contribution(address from, uint256 amount);
55 
56     constructor(address _wallet) public {
57         startBlock = block.number; // imediate start 
58         maxMintable = 4045084999529091000000000000; // max sellable (18 decimals)
59         ETHWallet = _wallet; // 0x696863b0099394384cd595468b8b6270ea77fC68
60         isFunding = true;
61         creator = msg.sender;
62         exchangeRate = 13483;
63     }
64 
65     // setup function to be ran only 1 time
66     // setup token address
67     // setup end Block number
68     function setup(address token_address, uint end_block) public {
69         require(!configSet);
70         Token = ERC20(token_address);
71         endBlock = end_block;
72         configSet = true;
73     }
74 
75     function closeSale() external {
76       require(msg.sender==creator);
77       isFunding = false;
78     }
79 
80     function () payable public {
81         require(msg.value>0);
82         require(isFunding);
83         require(block.number <= endBlock);
84         uint256 amount = msg.value * exchangeRate;
85         uint256 total = totalMinted + amount;
86         require(total<=maxMintable);
87         totalMinted += total;
88         ETHWallet.transfer(msg.value);
89         Token.mintToken(msg.sender, amount);
90         emit Contribution(msg.sender, amount);
91     }
92 
93     // CONTRIBUTE FUNCTION
94     // converts ETH to Avalanche Genesis Block TOKEN and sends new Avalanche TOKEN to the sender
95     function contribute() external payable {
96         require(msg.value>0);
97         require(isFunding);
98         require(block.number <= endBlock);
99         uint256 amount = msg.value * exchangeRate;
100         uint256 total = totalMinted + amount;
101         require(total<=maxMintable);
102         totalMinted += total;
103         ETHWallet.transfer(msg.value);
104         Token.mintToken(msg.sender, amount);
105         emit Contribution(msg.sender, amount);
106     }
107 
108     // update the ETH/XAIT rate
109     function updateRate(uint256 rate) external {
110         require(msg.sender==creator);
111         require(isFunding);
112         exchangeRate = rate;
113     }
114 
115     // change creator address
116     function changeCreator(address _creator) external {
117         require(msg.sender==creator);
118         creator = _creator;
119     }
120 
121     // change transfer ability for ERC20 token (toggle on/off) 
122     function changeTransferStats(bool _allowed) external {
123         require(msg.sender==creator);
124         Token.changeTransfer(_allowed);
125     }
126 
127 }