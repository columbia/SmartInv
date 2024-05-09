1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14     function transferOwnership(address newOwner) public onlyOwner {
15         require(newOwner != address(0));
16         emit OwnershipTransferred(owner, newOwner);
17         owner = newOwner;
18     }
19 }
20 
21 contract ERC20 {
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24 }
25 
26 contract SafeMath {
27     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
28         uint256 z = x + y;
29         assert((z >= x) && (z >= y));
30         return z;
31     }
32     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
33         assert(x >= y);
34         uint256 z = x - y;
35         return z;
36     }
37     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
38         uint256 z = x * y;
39         assert((x == 0)||(z/x == y));
40         return z;
41     }
42     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
43         uint256 z = x / y;
44         return z;
45     }
46 }
47 
48 contract LuckyBaby is Ownable, SafeMath {
49 
50     ERC20 public token;
51     bool public activityClosed = false;
52     uint public maxGasPrice = 30000000000;
53     struct LuckyItem {
54         address luckyMan;
55         uint amount;
56     }
57 
58     LuckyItem[] public history;
59 
60     uint public tokenRewardRate;
61 
62     uint public minTicket;
63     uint public maxTicket;
64     
65     function () payable public {
66         if (msg.sender == owner) {
67             return;   
68         }
69         require(!activityClosed);
70         require(tx.gasprice <= maxGasPrice);
71         require(msg.value >= minTicket);
72         require(msg.value <= maxTicket);
73         award(msg.value, msg.sender);
74     }
75     
76     function award (uint amount, address add) private {
77         uint random_number = (uint(block.blockhash(block.number-1)) - uint(add)) % 100;
78         if (random_number == 0) {
79             uint reward = safeMult(amount, 100);
80             require(address(this).balance >= reward);
81             add.transfer(reward);
82             LuckyItem memory item = LuckyItem({luckyMan:add, amount:reward});
83             history.push(item);
84         }
85         if (token.balanceOf(this) >= tokenRewardRate) {
86             token.transfer(add, tokenRewardRate);
87         }
88     }
89     function LuckyBaby() public {
90         token = ERC20(address(0x00));
91         tokenRewardRate = 20*10**18;
92         minTicket = 10**16;
93         maxTicket = 10**17;
94     }
95     function setToken(ERC20 newToken) onlyOwner public {
96         token = newToken;
97     }
98     function setMaxGasPrice(uint max) onlyOwner public {
99         maxGasPrice = max;
100     }
101     function setActivityState(bool close) onlyOwner public {
102         activityClosed = close;
103     }
104     function setTokenRewardRate(uint rate) onlyOwner public {
105         tokenRewardRate = rate;
106     }
107     function setMaxTicket(uint max) onlyOwner public {
108         maxTicket = max;
109     }
110     function withdrawToken(uint amount) onlyOwner public {
111         uint256 leave = token.balanceOf(this);
112         if (leave >= amount) {
113             token.transfer(owner, amount);
114         }
115     }
116     function withdrawEther(uint amount) onlyOwner public {
117        owner.transfer(amount);
118     }
119     function clear() onlyOwner public {
120         uint leave = token.balanceOf(this);
121         if (leave > 0) {
122             token.transfer(owner, leave);
123         }
124         uint balance = address(this).balance;
125         if (balance > 0) {
126             owner.transfer(balance);
127         }
128     }
129 }