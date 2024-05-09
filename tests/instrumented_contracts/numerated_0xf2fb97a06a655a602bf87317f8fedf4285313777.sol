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
15 */
16 
17 
18 contract ERC20 {
19   uint public totalSupply;
20   function balanceOf(address who) constant returns (uint);
21   function allowance(address owner, address spender) constant returns (uint);
22   function transfer(address to, uint value) returns (bool ok);
23   function transferFrom(address from, address to, uint value) returns (bool ok);
24   function approve(address spender, uint value) returns (bool ok);
25   function mintToken(address to, uint256 value) returns (uint256);
26   function changeTransfer(bool allowed);
27 }
28 
29 
30 contract Sale {
31 
32     uint256 public maxMintable;
33     uint256 public totalMinted;
34     uint public exchangeRate;
35     bool public isFunding;
36     ERC20 public Token;
37     address public ETHWallet;
38 
39     bool private configSet;
40     address public creator;
41 
42     event Contribution(address from, uint256 amount);
43 
44     function Sale(address _wallet) {
45         maxMintable = 10000000000000000000000000000; 
46         ETHWallet = _wallet;
47         isFunding = true;
48         creator = msg.sender;
49         exchangeRate = 25000;
50     }
51 
52     // setup function to be ran only 1 time
53     // setup token address
54     function setup(address token_address) {
55         require(!configSet);
56         Token = ERC20(token_address);
57         configSet = true;
58     }
59 
60     function closeSale() external {
61       require(msg.sender==creator);
62       isFunding = false;
63     }
64     
65     function () payable {
66         this.contribute();
67     }
68 
69     // CONTRIBUTE FUNCTION
70     // converts ETH to TOKEN and sends new TOKEN to the sender
71     function contribute() external payable {
72         require(msg.value>0);
73         require(isFunding);
74         uint256 amount = msg.value * exchangeRate;
75         uint256 total = totalMinted + amount;
76         require(total<=maxMintable);
77         totalMinted += amount;
78         ETHWallet.transfer(msg.value);
79         Token.mintToken(msg.sender, amount);
80         Contribution(msg.sender, amount);
81     }
82 
83     // update the ETH/COIN rate
84     function updateRate(uint256 rate) external {
85         require(msg.sender==creator);
86         require(isFunding);
87         exchangeRate = rate;
88     }
89 
90     // change creator address
91     function changeCreator(address _creator) external {
92         require(msg.sender==creator);
93         creator = _creator;
94     }
95 
96     // change transfer status for ERC20 token
97     function changeTransferStats(bool _allowed) external {
98         require(msg.sender==creator);
99         Token.changeTransfer(_allowed);
100     }
101 
102 }