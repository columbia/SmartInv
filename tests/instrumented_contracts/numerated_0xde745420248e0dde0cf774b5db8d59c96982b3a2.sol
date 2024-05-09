1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public view returns (uint256);
6 }
7 
8 contract Payout {
9     ERC20Basic HorseToken;
10     address payoutPoolAddress;
11     address owner;
12     address dev;
13     address devTokensVestingAddress;
14     bool payoutPaused;
15     bool payoutSetup;
16     uint256 public payoutPoolAmount;
17     mapping(address => bool) public hasClaimed;
18 
19     constructor() public {
20         HorseToken = ERC20Basic(0x5B0751713b2527d7f002c0c4e2a37e1219610A6B);        // Horse Token Address
21         payoutPoolAddress = address(0xf783A81F046448c38f3c863885D9e99D10209779);    // takeout pool
22         dev = address(0x1F92771237Bd5eae04e91B4B6F1d1a78D41565a2);                  // dev wallet
23         devTokensVestingAddress = address(0x44935883932b0260C6B1018Cf6436650BD52a257); // vesting contract
24         owner = msg.sender;
25     }
26 
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31     
32     modifier isPayoutPaused {
33         require(!payoutPaused);
34         _;
35     }
36     
37     modifier hasNotClaimed {
38         require(!hasClaimed[msg.sender]);
39         _;
40     }
41      modifier isPayoutSetup {
42          require(payoutSetup);
43          _;
44      }
45     
46     function setupPayout() external payable {
47         require(!payoutSetup);
48         require(msg.sender == payoutPoolAddress);
49         payoutPoolAmount = msg.value;
50         payoutSetup = true;
51         payoutPaused = true;
52     }
53     
54     function getTokenBalance() public view returns (uint256) {
55         if (msg.sender == dev) {
56             return (HorseToken.balanceOf(devTokensVestingAddress));
57         } else {
58             return (HorseToken.balanceOf(msg.sender));
59         }
60     }
61     
62     function getRewardEstimate() public view isPayoutSetup returns(uint256 rewardEstimate) {
63         uint factor = getTokenBalance();
64         uint totalSupply = HorseToken.totalSupply();
65         factor = factor*(10**18);   // 18 decimal precision
66         factor = (factor/(totalSupply));
67         rewardEstimate = (payoutPoolAmount*factor)/(10**18); // 18 decimal correction
68     }
69     
70     function claim() external isPayoutPaused hasNotClaimed isPayoutSetup {
71         uint rewardAmount = getRewardEstimate();
72         hasClaimed[msg.sender] = true;
73         require(rewardAmount <= address(this).balance);
74         msg.sender.transfer(rewardAmount);
75     }
76     
77     function payoutControlSwitch(bool status) external onlyOwner {
78         payoutPaused = status;
79     }
80     
81     function extractFund(uint256 _amount) external onlyOwner {
82         if (_amount == 0) {
83             owner.transfer(address(this).balance);
84         } else {
85             require(_amount <= address(this).balance);
86             owner.transfer(_amount);
87         }
88     }
89 }