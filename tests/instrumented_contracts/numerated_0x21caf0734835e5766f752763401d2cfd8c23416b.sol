1 pragma solidity 0.4.19;
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
36     function Sale() {
37         startBlock = block.number;
38         maxMintable = 10000000e18; 
39         ETHWallet = 0x56710010B234A104D7E67dA5765A081eF7f2B4C8; 
40         isFunding = true;
41         creator = 0x0E6EFB81B03ea30Fd7Eac2a416FB5ec943B5cdBA;
42         createHeldCoins();
43         exchangeRate = 2000; 
44     }
45 
46     
47     
48     
49     function setup(address TOKEN, uint endBlockTime) {
50         require(!configSet);
51         Token = ERC20(TOKEN);
52         endBlock = endBlockTime;
53         configSet = true;
54     }
55 
56     function closeSale() external {
57       require(msg.sender==creator);
58       isFunding = false;
59     }
60 
61     
62     
63     function contribute() external payable {
64         require(msg.value>0);
65         require(isFunding);
66         require(block.number <= endBlock);
67         uint256 amount = msg.value * exchangeRate;
68         uint256 total = totalMinted + amount;
69         require(total<=maxMintable);
70         totalMinted = total; 
71         ETHWallet.transfer(msg.value);
72         Token.mintToken(msg.sender, amount);
73         Contribution(msg.sender, amount);
74     }
75     
76     
77     function() payable public {
78         require(msg.value>0);
79         require(isFunding);
80         require(block.number <= endBlock);
81         uint256 amount = msg.value * exchangeRate;
82         uint256 total = totalMinted + amount;
83         require(total<=maxMintable);
84         totalMinted = total; 
85         ETHWallet.transfer(msg.value);
86         Token.mintToken(msg.sender, amount);
87         Contribution(msg.sender, amount);
88     }
89 
90     
91     function updateRate(uint256 rate) external {
92         require(msg.sender==creator);
93         require(isFunding);
94         exchangeRate = rate;
95     }
96 
97     
98     function changeCreator(address _creator) external {
99         require(msg.sender==creator);
100         creator = _creator;
101     }
102 
103     
104     function changeTransferStats(bool _allowed) external {
105         require(msg.sender==creator);
106         Token.changeTransfer(_allowed);
107     }
108 
109     
110     
111     function createHeldCoins() internal {
112         
113         createHoldToken(0x44Bb8D9036Db5453219189E0a7262BFe1a69AfEB, 4000000e18); 
114         
115         
116     }
117 
118     
119     function createHoldToken(address _to, uint256 amount) internal {
120         
121         heldTokens[_to] = amount;
122         heldTimeline[_to] = block.number + 0;
123         heldTotal += amount;
124         totalMinted += heldTotal;
125     }
126 
127     
128     function releaseHeldCoins() external {
129         uint256 held = heldTokens[msg.sender];
130         uint heldBlock = heldTimeline[msg.sender];
131         require(!isFunding);
132         require(held >= 0);
133         require(block.number >= heldBlock);
134         heldTokens[msg.sender] = 0;
135         heldTimeline[msg.sender] = 0;
136         Token.mintToken(msg.sender, held);
137         ReleaseTokens(msg.sender, held);
138     }
139 
140 
141 }