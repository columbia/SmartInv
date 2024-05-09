1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor() public{
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) external onlyOwner {
16         if (newOwner != address(0)) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 contract ERC20RewardToken {
23   function totalSupply() public view returns (uint256);
24   function balanceOf(address who) public view returns (uint256);
25   function transfer(address to, uint256 value) public returns (bool);
26   function decimals() public returns (uint8);
27 }
28 
29 contract Reward is Ownable {
30     
31     ERC20RewardToken public token;
32     address public presaleAddress;
33     uint64 public doubleRewardEndTime = 1538006400;
34     
35     constructor(address _tokenAddr, address _presaleAddr) public {
36         token = ERC20RewardToken(_tokenAddr);
37         presaleAddress = _presaleAddr;
38     }
39     
40     function get(address _receiver, uint256 _ethValue) external {
41 
42         require(msg.sender == presaleAddress);
43         
44         uint256 tokensValue = calculateValue(_ethValue, token.decimals());
45 
46         if(token.balanceOf(address(this)) > tokensValue) {
47             token.transfer(_receiver, tokensValue);
48         }
49     }
50     
51 	function setDoubleRewardEndTime(uint64 _time) onlyOwner external {
52 		doubleRewardEndTime = _time;
53 	}
54 	
55     function calculateValue(uint256 _ethValue, uint8 decimals) view public returns (uint256 tokensValue) {
56         
57         uint8 TokensPerEthereum = 10;
58         uint8 additionalBonusPercent = 10;
59         
60         if(_ethValue > 3 * 10**17)
61             additionalBonusPercent = 25;
62         if(_ethValue > 10**18)
63             additionalBonusPercent = 30;
64         if(_ethValue > 5 * 10**18)
65             additionalBonusPercent = 60;
66         
67         tokensValue = _ethValue * TokensPerEthereum;
68         
69         tokensValue+= (tokensValue * additionalBonusPercent ) / 100;
70         
71         if(decimals < 18)
72         {
73             uint256 difference = 18 - uint256(decimals);
74             tokensValue = tokensValue / 10**difference;
75         }
76         else if(decimals > 18)
77         {
78             difference = uint256(decimals) - 18;
79             tokensValue = tokensValue * 10**difference;
80         }
81 		
82 		// an additional small bonus to compensate for the difference in calculating the recommended price of the egg
83 		if(_ethValue > 10**18)
84 			tokensValue+= 3 * 10**(uint256(decimals) - 2);
85         
86         if(now <= doubleRewardEndTime)
87             tokensValue*=2;
88     }
89     
90     function () public payable {
91         revert();
92     }
93     
94     function withdraw() onlyOwner external {
95         uint256 balance = token.balanceOf(address(this));
96         token.transfer(msg.sender, balance);
97     }
98 }