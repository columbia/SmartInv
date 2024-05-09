1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 /*
8  * SafeMath - Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract Crowdsale {
37     using SafeMath for uint256;
38 
39     address public owner;
40     uint256 public amountRaised;
41     uint256 public amountRaisedPhase;
42     uint256 public price;
43     token public tokenReward;
44     mapping(address => uint256) public balanceOf;
45 
46     event FundTransfer(address backer, uint amount, bool isContribution);
47 
48     /*
49     * Throws if called by any account other than the owner
50     */
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     /*
57      * Constrctor function - setup the owner
58      */
59     function Crowdsale(
60         address ownerAddress,
61         uint256 weiCostPerToken,
62         address rewardTokenAddress
63     ) public {
64         owner = ownerAddress;
65         price = weiCostPerToken;
66         tokenReward = token(rewardTokenAddress);
67     }
68 
69     /*
70      * Fallback function - called when funds are sent to the contract
71      */
72     function () public payable {
73         uint256 amount = msg.value;
74         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
75         amountRaised = amountRaised.add(amount);
76         amountRaisedPhase = amountRaisedPhase.add(amount);
77         tokenReward.transfer(msg.sender, amount.mul(10**4).div(price));
78         FundTransfer(msg.sender, amount, true);
79     }
80 
81     /*
82      * Withdraw the funds safely
83      */
84     function safeWithdrawal() public onlyOwner {
85         uint256 withdraw = amountRaisedPhase;
86         amountRaisedPhase = 0;
87         FundTransfer(owner, withdraw, false);
88         owner.transfer(withdraw);
89     }
90 
91     /*
92      * Transfers the current balance to the owner and terminates the contract
93      */
94     function destroy() public onlyOwner {
95         selfdestruct(owner);
96     }
97     function destroyAndSend(address _recipient) public onlyOwner {
98         selfdestruct(_recipient);
99     }
100 }