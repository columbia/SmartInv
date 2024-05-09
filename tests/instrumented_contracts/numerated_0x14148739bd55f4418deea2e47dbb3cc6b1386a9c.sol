1 pragma solidity ^0.4.21;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7   function transfer(address to, uint value) returns (bool ok);
8   function transferFrom(address from, address to, uint value) returns (bool ok);
9   function approve(address spender, uint value) returns (bool ok);
10   function mintToken(address to, uint256 value) returns (uint256);
11   function changeTransfer(bool allowed);
12 }
13 
14 
15 contract Sale {
16 
17     uint256 public maxMintable;
18     uint256 public totalMinted;
19     uint public endBlock;
20     uint public startBlock;
21     uint public exchangeRate;
22     bool public isFunding;
23     ERC20 public Token;
24     address public ETHWallet;
25     uint256 public heldTotal;
26 
27     bool private configSet;
28     address public creator;
29 
30     mapping (address => uint256) public heldTokens;
31     mapping (address => uint) public heldTimeline;
32 
33     event Contribution(address from, uint256 amount);
34     event ReleaseTokens(address from, uint256 amount);
35 
36     function Sale(address _wallet) {
37         startBlock = block.number;
38         maxMintable = 110000000000000000000000000;
39         ETHWallet = _wallet;
40         isFunding = true;
41         creator = msg.sender;
42         createHeldCoins();
43         exchangeRate = 25000;
44     }
45 
46     // setup function to be ran only 1 time
47     // setup token address
48     // setup end Block number
49     function setup(address token_address, uint end_block) {
50         require(!configSet);
51         Token = ERC20(token_address);
52         endBlock = end_block;
53         configSet = true;
54     }
55 
56     function closeSale() external {
57       require(msg.sender==creator);
58       isFunding = false;
59     }
60 
61     function () payable {
62         require(msg.value>0);
63         require(isFunding);
64         require(block.number <= endBlock);
65         uint256 amount = msg.value * exchangeRate;
66         uint256 total = totalMinted + amount;
67         require(total<=maxMintable);
68         totalMinted += total;
69         ETHWallet.transfer(msg.value);
70         Token.mintToken(msg.sender, amount);
71         Contribution(msg.sender, amount);
72     }
73 
74     // CONTRIBUTE FUNCTION
75     // converts ETH to TOKEN and sends new TOKEN to the sender
76     function contribute() external payable {
77         require(msg.value>0);
78         require(isFunding);
79         require(block.number <= endBlock);
80         uint256 amount = msg.value * exchangeRate;
81         uint256 total = totalMinted + amount;
82         require(total<=maxMintable);
83         totalMinted += total;
84         ETHWallet.transfer(msg.value);
85         Token.mintToken(msg.sender, amount);
86         Contribution(msg.sender, amount);
87     }
88 
89     // update the ETH/COIN rate
90     function updateRate(uint256 rate) external {
91         require(msg.sender==creator);
92         require(isFunding);
93         exchangeRate = rate;
94     }
95 
96     // change creator address
97     function changeCreator(address _creator) external {
98         require(msg.sender==creator);
99         creator = _creator;
100     }
101 
102     // change transfer status for ERC20 token
103     function changeTransferStats(bool _allowed) external {
104         require(msg.sender==creator);
105         Token.changeTransfer(_allowed);
106     }
107 
108     // internal function that allocates a specific amount of TOKENS at a specific block number.
109     // only ran 1 time on initialization
110     function createHeldCoins() internal {
111         createHoldToken(0xd04443ceae5aed6871db555caf1a154802ce1600, 40000000000000000000000000);
112         createHoldToken(0x8ce3b3d46e994b6ec215963e385b7bf20d60683d, 40000000000000000000000000);
113         createHoldToken(0x61777c00fc0353d8c62a8f8c34336dfc46596906, 10000000000000000000000000);
114     }
115 
116     // public function to get the amount of tokens held for an address
117     function getHeldCoin(address _address) public constant returns (uint256) {
118         return heldTokens[_address];
119     }
120 
121     // function to create held tokens for developer
122     function createHoldToken(address _to, uint256 amount) internal {
123         heldTokens[_to] = amount;
124         heldTimeline[_to] = block.number + 0;
125         heldTotal += amount;
126         totalMinted += heldTotal;
127     }
128 
129     // function to release held tokens for developers
130     function releaseHeldCoins() external {
131         uint256 held = heldTokens[msg.sender];
132         uint heldBlock = heldTimeline[msg.sender];
133         require(held >= 0);
134         require(block.number >= heldBlock);
135         heldTokens[msg.sender] = 0;
136         heldTimeline[msg.sender] = 0;
137         Token.mintToken(msg.sender, held);
138         ReleaseTokens(msg.sender, held);
139     }
140 
141 
142 }