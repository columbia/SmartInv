1 pragma solidity ^0.4.21;
2 
3 // File: @gnosis.pm/util-contracts/contracts/Token.sol
4 
5 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 pragma solidity ^0.4.18;
7 
8 
9 /// @title Abstract token contract - Functions to be implemented by token contracts
10 contract Token {
11 
12     /*
13      *  Events
14      */
15     event Transfer(address indexed from, address indexed to, uint value);
16     event Approval(address indexed owner, address indexed spender, uint value);
17 
18     /*
19      *  Public functions
20      */
21     function transfer(address to, uint value) public returns (bool);
22     function transferFrom(address from, address to, uint value) public returns (bool);
23     function approve(address spender, uint value) public returns (bool);
24     function balanceOf(address owner) public view returns (uint);
25     function allowance(address owner, address spender) public view returns (uint);
26     function totalSupply() public view returns (uint);
27 }
28 
29 // File: contracts/RewardClaimHandler.sol
30 
31 contract RewardClaimHandler {
32     Token public rewardToken;
33     address public operator;
34     address[] public winners;
35     mapping (address => uint) public rewardAmounts;
36     uint public guaranteedClaimEndTime;
37 
38     function RewardClaimHandler(Token _rewardToken) public {
39         rewardToken = _rewardToken;
40         operator = msg.sender;
41     }
42 
43     function registerRewards(address[] _winners, uint[] _rewardAmounts, uint duration) public {
44         require(
45             winners.length == 0 &&
46             _winners.length > 0 &&
47             _winners.length == _rewardAmounts.length &&
48             msg.sender == operator
49         );
50 
51         uint totalAmount = 0;
52         for(uint i = 0; i < _winners.length; i++) {
53             totalAmount += _rewardAmounts[i];
54             rewardAmounts[_winners[i]] = _rewardAmounts[i];
55         }
56 
57         require(rewardToken.transferFrom(msg.sender, this, totalAmount));
58 
59         winners = _winners;
60         guaranteedClaimEndTime = now + duration;
61     }
62 
63     function claimReward() public {
64         require(winners.length > 0 && rewardToken.transfer(msg.sender, rewardAmounts[msg.sender]));
65         rewardAmounts[msg.sender] = 0;
66     }
67 
68     function retractRewards() public {
69         require(winners.length > 0 && msg.sender == operator && now >= guaranteedClaimEndTime);
70 
71         uint totalAmount = 0;
72         for(uint i = 0; i < winners.length; i++) {
73             totalAmount += rewardAmounts[winners[i]];
74             rewardAmounts[winners[i]] = 0;
75             // We don't use:
76             //     winners[i] = 0;
77             // because of this:
78             // https://ethereum.stackexchange.com/questions/3373/how-to-clear-large-arrays-without-blowing-the-gas-limit
79             // This is a more gas efficient overall if more than one run happens
80         }
81 
82         require(rewardToken.transfer(msg.sender, totalAmount));
83 
84         winners.length = 0;
85     }
86 }