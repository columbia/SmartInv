1 pragma solidity ^0.4.21;
2 
3 /*
4 
5   BASIC ERC20 Sale Contract
6 
7   Create this Sale contract first!
8 
9      Sale(address ethwallet)   // this will send the received ETH funds to this address
10 
11 
12   @author Hunter Long
13   @repo https://github.com/hunterlong/ethereum-ico-contract
14 
15 
16 */
17 
18 contract ERC20 {
19   uint public totalSupply;
20   function balanceOf(address who) constant public returns (uint);
21   function allowance(address owner, address spender) constant public returns (uint);
22   function transfer(address to, uint value) public returns (bool ok);
23   function transferFrom(address from, address to, uint value)public returns (bool ok);
24   function approve(address spender, uint value) public returns (bool ok);
25   function mintToken(address to, uint256 value) public returns (uint256);
26   function changeTransfer(bool allowed) public;
27 }
28 
29 
30 contract Sale {
31 
32     uint256 public maxMintable;
33     uint256 public totalMinted;
34     uint public endBlock;
35     uint public startBlock;
36     uint public exchangeRate;
37     bool public isFunding;
38     ERC20 public Token;
39     address public ETHWallet;
40     uint256 public heldTotal;
41 
42     bool private configSet;
43     address public creator;
44 
45     mapping (address => uint256) public heldTokens;
46     mapping (address => uint) public heldTimeline;
47 
48     event Contribution(address from, uint256 amount);
49     event ReleaseTokens(address from, uint256 amount);
50 
51     function Sale(address _wallet) public{
52         startBlock = block.number;
53         maxMintable = 4000000000000000000000000; // 3 million max sellable (18 decimals)
54         ETHWallet = _wallet;
55         isFunding = true;
56         creator = msg.sender;
57         exchangeRate = 53689; //563.73 / 0.0105
58     }
59 
60     // setup function to be ran only 1 time
61     // setup token address
62     // setup end Block number
63     function setup(address token_address, uint end_block) public{
64         require(!configSet);
65         Token = ERC20(token_address);
66         endBlock = end_block;
67         configSet = true;
68     }
69 
70     function closeSale() external {
71       require(msg.sender==creator);
72       isFunding = false;
73     }
74 
75     function () payable public {
76         require(msg.value>0);
77         require(isFunding);
78         require(block.number <= endBlock);
79         uint256 amount = msg.value * exchangeRate;
80         uint256 total = totalMinted + amount;
81         require(total<=maxMintable);
82         totalMinted += total;
83         ETHWallet.transfer(msg.value);
84         Token.mintToken(msg.sender, amount);
85         emit Contribution(msg.sender, amount);
86     }
87 
88     // CONTRIBUTE FUNCTION
89     // converts ETH to TOKEN and sends new TOKEN to the sender
90     function contribute() external payable {
91         require(msg.value>0);
92         require(isFunding);
93         require(block.number <= endBlock);
94         uint256 amount = msg.value * exchangeRate;
95         uint256 total = totalMinted + amount;
96         require(total<=maxMintable);
97         totalMinted += total;
98         ETHWallet.transfer(msg.value);
99         Token.mintToken(msg.sender, amount);
100         emit Contribution(msg.sender, amount);
101     }
102 
103     // update the ETH/COIN rate
104     function updateRate(uint256 rate) external {
105         require(msg.sender==creator);
106         require(isFunding);
107         exchangeRate = rate;
108     }
109 
110     // change creator address
111     function changeCreator(address _creator) external {
112         require(msg.sender==creator);
113         creator = _creator;
114     }
115 
116     // change transfer status for ERC20 token
117     function changeTransferStats(bool _allowed) external {
118         require(msg.sender==creator);
119         Token.changeTransfer(_allowed);
120     }
121 
122 
123     // public function to get the amount of tokens held for an address
124     function getHeldCoin(address _address) public constant returns (uint256) {
125         return heldTokens[_address];
126     }
127 
128     // function to create held tokens for developer
129     function createHoldToken(address _to, uint256 amount) internal {
130         heldTokens[_to] = amount;
131         heldTimeline[_to] = block.number + 0;
132         heldTotal += amount;
133         totalMinted += heldTotal;
134     }
135 
136     // function to release held tokens for developers
137     function releaseHeldCoins() external {
138         uint256 held = heldTokens[msg.sender];
139         uint heldBlock = heldTimeline[msg.sender];
140         require(!isFunding);
141         require(held >= 0);
142         require(block.number >= heldBlock);
143         heldTokens[msg.sender] = 0;
144         heldTimeline[msg.sender] = 0;
145         Token.mintToken(msg.sender, held);
146         emit ReleaseTokens(msg.sender, held);
147     }
148 
149 
150 }