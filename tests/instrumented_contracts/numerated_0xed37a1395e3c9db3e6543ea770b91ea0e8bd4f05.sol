1 pragma solidity ^0.4.11;
2 
3 contract Mineable {
4     address public owner;
5     uint public supply = 100000000000000;
6     string public name = 'MineableBonusEthereumToken';
7     string public symbol = 'MBET';
8     uint8 public decimals = 8;
9     uint public price = 1 finney;
10     uint public durationInBlocks = 157553; // 1 month
11     uint public miningReward = 100000000;
12     uint public amountRaised;
13     uint public deadline;
14     uint public tokensSold;
15     uint private divider;
16     
17     /* This creates an array with all balances */
18     mapping (address => uint256) public balanceOf;
19     mapping (address => uint256) public successesOf;
20     mapping (address => uint256) public failsOf;
21     
22     /* This generates a public event on the blockchain that will notify clients */
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     
25     event FundTransfer(address backer, uint amount, bool isContribution);
26     
27     function isOwner() returns (bool isOwner) {
28         return msg.sender == owner;
29     }
30     
31     function addressIsOwner(address addr)  returns (bool isOwner) {
32         return addr == owner;
33     }
34 
35     modifier onlyOwner {
36         if (msg.sender != owner) revert();
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner {
41         owner = newOwner;
42     }
43     
44     /* Initializes contract with initial supply tokens to the creator of the contract */
45     function Mineable() {
46         owner = msg.sender;
47         divider -= 1;
48         divider /= 1048576;
49         balanceOf[msg.sender] = supply;
50         deadline = block.number + durationInBlocks;
51     }
52     
53     function isCrowdsale() returns (bool isCrowdsale) {
54         return block.number < deadline;
55     }
56     
57     /* Send coins */
58     function transfer(address _to, uint256 _value) {
59         /* if the sender doesnt have enough balance then stop */
60         if (balanceOf[msg.sender] < _value) revert();
61         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
62         
63         /* Add and subtract new balances */
64         balanceOf[msg.sender] -= _value;
65         balanceOf[_to] += _value;
66         
67         /* Notify anyone listening that this transfer took place */
68         Transfer(msg.sender, _to, _value);
69     }
70     
71     function () payable {
72         if (isOwner()) {
73             owner.transfer(amountRaised);
74             FundTransfer(owner, amountRaised, false);
75             amountRaised = 0;
76         } else if (isCrowdsale()) {
77             uint amount = msg.value;
78             if (amount == 0) revert();
79             
80             uint tokensCount = amount * 100000000 / price;
81             if (tokensCount < 100000000) revert();
82             
83             balanceOf[msg.sender] += tokensCount;
84             supply += tokensCount;
85             tokensSold += tokensCount;
86             Transfer(0, this, tokensCount);
87             Transfer(this, msg.sender, tokensCount);
88             amountRaised += amount;
89         } else if (msg.value == 0) {
90             uint minedAtBlock = uint(block.blockhash(block.number - 1));
91             uint minedHashRel = uint(sha256(minedAtBlock + uint(msg.sender))) / divider;
92             uint balanceRel = balanceOf[msg.sender] * 1048576 / supply;
93             
94             if (minedHashRel < balanceRel * 933233 / 1048576 + 10485) {
95                 uint reward = miningReward + minedHashRel * 10000;
96                 balanceOf[msg.sender] += reward;
97                 supply += reward;
98                 Transfer(0, this, reward);
99                 Transfer(this, msg.sender, reward);
100                 successesOf[msg.sender]++;
101             } else {
102                 failsOf[msg.sender]++;
103             }
104         } else {
105             revert();
106         }
107     }
108 }