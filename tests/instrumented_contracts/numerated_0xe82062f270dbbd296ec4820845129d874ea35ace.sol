1 pragma solidity ^0.4.10;
2 
3 contract ERC20 {
4   function balanceOf(address owner) constant returns (uint balance);
5   function transfer(address to, uint value) returns (bool success);
6 }
7 
8 contract TokenPool {
9   string public name;
10   uint public fundingLimit;
11   uint public rewardPercentage;
12   uint public amountRaised;
13   uint public tokensCreated;
14   ERC20 public tokenContract;
15   address public tokenCreateContract;
16   string public tokenCreateFunction;
17   mapping (address => uint) funders;
18   address public tokenCreator;
19   bytes4 tokenCreateFunctionHash;
20 
21   function TokenPool(
22     TokenPoolList list,
23     string _name,
24     uint _fundingLimit,
25     uint _rewardPercentage,
26     ERC20 _tokenContract,
27     address _tokenCreateContract,
28     string _tokenCreateFunction)
29   {
30     list.add(this);
31     name = _name;
32     fundingLimit = _fundingLimit;
33     rewardPercentage = _rewardPercentage;
34     tokenContract = _tokenContract;
35     tokenCreateContract = _tokenCreateContract;
36     tokenCreateFunction = _tokenCreateFunction;
37     tokenCreateFunctionHash = bytes4(sha3(tokenCreateFunction));
38   }
39 
40   function Fund() payable {
41     if (tokensCreated > 0) throw;
42     uint amount = msg.value;
43     amountRaised += amount;
44     if (amountRaised > fundingLimit) throw;
45     funders[msg.sender] += amount;
46   }
47 
48   function() payable {
49     Fund();
50   }
51 
52   function Withdraw() {
53     if (tokensCreated > 0) return;
54     uint amount = funders[msg.sender];
55     if (amount == 0) return;
56     funders[msg.sender] -= amount;
57     amountRaised -= amount;
58     if (!msg.sender.send(amount)) {
59       funders[msg.sender] += amount;
60       amountRaised += amount;
61     }
62   }
63 
64   function CreateTokens() {
65     if (tokensCreated > 0) return;
66     uint amount = amountRaised * (100 - rewardPercentage) / 100;
67     if (!tokenCreateContract.call.value(amount)(tokenCreateFunctionHash)) throw;
68     tokensCreated = tokenContract.balanceOf(this);
69     tokenCreator = msg.sender;
70   }
71 
72   function ClaimTokens() {
73     if (tokensCreated == 0) return;
74     uint amount = funders[msg.sender];
75     if (amount == 0) return;
76     uint tokens = tokensCreated * amount / amountRaised;
77     funders[msg.sender] = 0;
78     if (!tokenContract.transfer(msg.sender, tokens)) {
79       funders[msg.sender] = amount;
80     }
81   }
82 
83   function ClaimReward() {
84     if (msg.sender != tokenCreator) return;
85     uint amount = amountRaised * (100 - rewardPercentage) / 100;
86     uint reward = amountRaised - amount;
87     if (msg.sender.send(reward)) {
88       tokenCreator = 0;
89     }
90   }
91 
92 }
93 pragma solidity ^0.4.10;
94 
95 contract TokenPoolList {
96   address[] public list;
97 
98   event Added(address x);
99 
100   function add(address x) {
101     list.push(x);
102     Added(x);
103   }
104 
105   function getCount() public constant returns(uint) {
106     return list.length;
107   }
108 
109   function getAddress(uint index) public constant returns(address) {
110     return list[index];
111   }
112 }