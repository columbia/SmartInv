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
19     uint public totalSupply;
20     function balanceOf(address who) public view returns (uint);
21     function allowance(address owner, address spender) public view returns (uint);
22     function transfer(address to, uint value) public returns (bool ok);
23     function transferFrom(address from, address to, uint value) public returns (bool ok);
24     function approve(address spender, uint value) public returns (bool ok);
25     function mintToken(address to, uint256 value) public returns (uint256);
26     function mintTokenFree(address to, uint256 value) public returns (uint256);
27     function changeTransfer(bool allowed) public;
28 }
29 
30 
31 contract Sale {
32 
33     uint256 public totalMinted;
34     uint public exchangeRate;
35     bool public isFunding;
36     ERC20 public Token;
37     address public ETHWallet;
38 
39     bool private configSet;
40     bool private walletSet;
41     address public creator;
42 
43     mapping (address => uint256) public heldTokens;
44     mapping (address => uint) public heldTimeline;
45 
46     event Contribution(address from, uint256 amount);
47     event ReleaseTokens(address from, uint256 amount);
48 
49     constructor(address _wallet) public{
50         ETHWallet = _wallet;
51         isFunding = true;
52         creator = msg.sender;
53         exchangeRate = 27334; //204.370778509 / 0.00972 => 21026 + 30%
54     }
55 
56     // setup function to be ran only 1 time
57     // setup token address
58     // setup end Block number
59     function setup(address token_address) public{
60         require(!configSet, "already setup");
61         Token = ERC20(token_address);
62         configSet = true;
63     }
64 
65     function setupETHWallet(address _wallet) public{
66         require(msg.sender==creator, "Creator reuired");
67         require(!walletSet, "wallet already setup");
68         ETHWallet = _wallet;
69         walletSet = true;
70     }
71 
72     function closeSale() external {
73         require(msg.sender==creator, "Creator reuired");
74         isFunding = false;
75     }
76 
77     function() payable public {
78         require(msg.value>0, "value need to be more than 0");
79         require(isFunding, "isFunding required");
80         uint256 amount = msg.value * exchangeRate;
81         uint256 total = totalMinted + amount;
82         totalMinted += total;
83         ETHWallet.transfer(msg.value);
84         Token.mintToken(msg.sender, amount);
85         emit Contribution(msg.sender, amount);
86     }
87 
88     // CONTRIBUTE FUNCTION
89     // converts ETH to TOKEN and sends new TOKEN to the sender
90     function contribute(address sender, uint256 value) external {
91         require(msg.sender==creator, "creator required");
92         require(isFunding, "isFunding required");
93         Token.mintTokenFree(sender, value);
94         emit Contribution(sender, value);
95     }
96 
97     // update the ETH/COIN rate
98     function updateRate(uint256 rate) external {
99         require(msg.sender==creator, "creator required");
100         require(isFunding, "isFunding required");
101         exchangeRate = rate;
102     }
103 
104     // change creator address
105     function changeCreator(address _creator) external {
106         require(msg.sender==creator, "creator required");
107         creator = _creator;
108     }
109 
110     // change transfer status for ERC20 token
111     function changeTransferStats(bool _allowed) external {
112         require(msg.sender==creator, "creator required");
113         Token.changeTransfer(_allowed);
114     }
115 
116 }