1 pragma solidity ^0.4.14;
2 
3  /// @title Ownable contract - base contract with an owner
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 }
22 
23 
24 pragma solidity ^0.4.14;
25 
26  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
27 contract ERC20 {
28   uint public totalSupply;
29   function balanceOf(address who) constant returns (uint);
30   function allowance(address owner, address spender) constant returns (uint);
31   function mint(address receiver, uint amount);
32   function transfer(address to, uint value) returns (bool ok);
33   function transferFrom(address from, address to, uint value) returns (bool ok);
34   function approve(address spender, uint value) returns (bool ok);
35   function decimals() constant returns (uint decimals) { return 0; }
36   event Transfer(address indexed from, address indexed to, uint value);
37   event Approval(address indexed owner, address indexed spender, uint value);
38 }
39 
40 
41 pragma solidity ^0.4.18;
42 
43 
44 
45 
46  /// @title SilentNotary bounty reward  contract
47 contract SilentNotaryBountyReward is Ownable {
48 
49   ERC20 public token;
50 
51   /// Team wallet to withdraw remaining tokens
52   address public teamWallet;
53 
54   /// Remaining bounty rewards
55   mapping (address => uint) public bountyRewards;
56 
57   /// Total count of addresses which have collected their rewards
58   uint public collectedAddressesCount;
59 
60   /// Array of addresses which have collected their rewards
61   address[] public collectedAddresses;
62 
63   /// Starting time of the bounty collection
64   uint public startTime;
65 
66   /// Duration of the bounty collection
67   uint public constant DURATION = 2 weeks;
68 
69   event Claimed(address receiver, uint amount);
70 
71   /// @dev Constructor
72   /// @param _token Address of Silent Notary Token
73   /// @param _teamWallet Team wallet to withdraw remaining tokens
74   /// @param _startTime Starting time of the bounty collection
75   function SilentNotaryBountyReward(address _token, address _teamWallet, uint _startTime) {
76     require(_token != 0);
77     require(_teamWallet != 0);
78     require(_startTime > 0);
79 
80     token = ERC20(_token);
81     teamWallet = _teamWallet;
82     startTime = _startTime;
83   }
84 
85   /// @dev Disable ETH accepting
86   function() payable  {
87     revert();
88   }
89 
90   /// @dev Claim bounty reward
91   function claimReward() public {
92     require(now >= startTime && now <= startTime + DURATION);
93 
94     var receiver = msg.sender;
95     var reward = bountyRewards[receiver];
96     assert(reward > 0);
97     assert(token.balanceOf(address(this)) >= reward);
98 
99     delete bountyRewards[receiver];
100     collectedAddressesCount++;
101     collectedAddresses.push(receiver);
102 
103     token.transfer(receiver, reward);
104     Claimed(receiver, reward);
105   }
106 
107   /// @dev Import bounty reward (for owner)
108   /// @param receiver Address of reward receiver
109   /// @param tokenAmount Amount of tokens to reward
110   function importReward(address receiver, uint tokenAmount) public onlyOwner {
111     require(receiver != 0);
112     require(tokenAmount > 0);
113 
114     bountyRewards[receiver] = tokenAmount;
115   }
116 
117   /// @dev Clear invalid bounty reward (for owner)
118   /// @param receiver Address of reward receiver
119   function clearReward(address receiver) public onlyOwner {
120     require(receiver != 0);
121 
122     delete bountyRewards[receiver];
123   }
124 
125   /// @dev Withdraw remaining tokens after reward claim period is over (for owner)
126   function withdrawRemainder() public onlyOwner {
127     require(now > startTime + DURATION);
128     var remainingBalance = token.balanceOf(address(this));
129     require(remainingBalance > 0);
130 
131     token.transfer(teamWallet, remainingBalance);
132   }
133 }