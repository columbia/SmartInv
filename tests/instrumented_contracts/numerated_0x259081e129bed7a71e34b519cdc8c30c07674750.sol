1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address public owner;
11     address public secondOwner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     modifier bothOwner() {
32         require(msg.sender == owner || msg.sender == secondOwner);
33         _;
34     }
35 
36     function changeSecOwner(address targetAddress) public bothOwner {
37         require(targetAddress != address(0));
38         secondOwner = targetAddress;
39     }
40 
41     /**
42     * @dev Allows the current owner to transfer control of the contract to a newOwner.
43     * @param newOwner The address to transfer ownership to.
44     */
45     function transferOwnership(address newOwner) public bothOwner {
46         require(newOwner != address(0));
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 
51 }
52 
53 interface token {
54     function transfer(address receiver, uint amount) public returns (bool);
55     function redeemToken(uint256 _mtcTokens, address _from) public;
56 }
57 
58 contract addressKeeper is Ownable {
59     address public tokenAddress;
60     address public boardAddress;
61     address public teamAddress;
62     function setTokenAdd(address addr) onlyOwner public {
63         tokenAddress = addr;
64     }
65     function setBoardAdd(address addr) onlyOwner public {
66         boardAddress = addr;
67     }
68     function setTeamAdd(address addr) onlyOwner public {
69         teamAddress = addr;
70     }
71 }
72 
73 contract MoatFund is addressKeeper {
74 
75     // wei per MTC
76     // 1 ETH = 5000 MTC
77     // 1 MTC = 200000000000000 wei
78     uint256 public mtcRate; // in wei
79     bool public mintBool;
80     uint256 public minInvest; // minimum investment in wei
81 
82     uint256 public redeemRate;     // When redeeming, 1MTC=fixed ETH
83     bool public redeemBool;
84 
85     uint256 public ethRaised;       // ETH deposited in owner's address
86     uint256 public ethRedeemed;     // ETH transferred from owner's address
87 
88     // function to start minting MTC
89     function startMint(uint256 _rate, bool canMint, uint256 _minWeiInvest) onlyOwner public {
90         minInvest = _minWeiInvest;
91         mtcRate = _rate;
92         mintBool = canMint;
93     }
94 
95     // function to redeem ETH from MTC
96     function startRedeem(uint256 _rate, bool canRedeem) onlyOwner public {
97         redeemRate = _rate;
98         redeemBool = canRedeem;
99     }
100 
101     function () public payable {
102         transferToken();
103     }
104 
105     // function called from MoatFund.sol
106     function transferToken() public payable {
107         if (msg.sender != owner &&
108             msg.sender != tokenAddress &&
109             msg.sender != boardAddress) {
110                 require(mintBool);
111                 require(msg.value >= minInvest);
112 
113                 uint256 MTCToken = (msg.value / mtcRate);
114                 uint256 teamToken = (MTCToken / 20);
115 
116                 ethRaised += msg.value;
117 
118                 token tokenTransfer = token(tokenAddress);
119                 tokenTransfer.transfer(msg.sender, MTCToken);
120                 tokenTransfer.transfer(teamAddress, teamToken);
121         }
122     }
123 
124     // calculate value of MTC that can be redeemed from the ETH
125     function redeem(uint256 _mtcTokens) public {
126         if (msg.sender != owner) {
127             require(redeemBool);
128 
129             token tokenBalance = token(tokenAddress);
130             tokenBalance.redeemToken(_mtcTokens, msg.sender);
131 
132             uint256 weiVal = (_mtcTokens * redeemRate);
133             ethRedeemed += weiVal;                                  // adds the value of transferred ETH to the redeemed ETH till now
134             // it need to stay last for reentery attack purpose
135             msg.sender.transfer(weiVal);                            // transfer the amount of ETH
136         }
137     }
138 
139     function sendETHtoBoard(uint _wei) onlyOwner public {
140         boardAddress.transfer(_wei);
141     }
142 
143     function collectERC20(address tokenAddress, uint256 amount) onlyOwner public {
144         token tokenTransfer = token(tokenAddress);
145         tokenTransfer.transfer(owner, amount);
146     }
147 
148 }