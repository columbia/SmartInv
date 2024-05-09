1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 
32 contract Owned {
33     address public owner;
34 
35     function Owned() public {
36         owner = msg.sender;
37     }
38 
39     function withdraw() public onlyOwner {
40         owner.transfer(this.balance);
41     }
42 
43     modifier onlyOwner() {
44         require(owner == msg.sender);
45         _;
46     }
47 }
48 
49 contract ERC20Basic {
50     uint256 public totalSupply;
51     function balanceOf(address who) public view returns (uint256);
52     function transfer(address to, uint256 value) public returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57     function allowance(address owner, address spender) public view returns (uint256);
58     function transferFrom(address from, address to, uint256 value) public returns (bool);
59     function approve(address spender, uint256 value) public returns (bool);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract Distributor is Owned {
64 
65     using SafeMath for uint256;
66 
67     ERC20 public token;
68     uint256 public eligibleTokens;
69     mapping(address => uint256) public distributed;
70     uint256 public totalDistributionAmountInWei;
71 
72     event Dividend(address holder, uint256 amountDistributed);
73 
74     function Distributor(address _targetToken, uint256 _eligibleTokens) public payable {
75         require(msg.value > 0);
76 
77         token = ERC20(_targetToken);
78         assert(_eligibleTokens <= token.totalSupply());
79         eligibleTokens = _eligibleTokens;
80         totalDistributionAmountInWei = msg.value;
81     }
82 
83     function percent(uint numerator, uint denominator, uint precision) internal pure returns (uint quotient) {
84         uint _numerator = numerator * 10 ** (precision + 1);
85         quotient = ((_numerator / denominator) + 5) / 10;
86     }
87 
88     function distribute(address holder) public onlyOwner returns (uint256 amountDistributed) {
89         require(distributed[holder] == 0);
90 
91         uint256 holderBalance = token.balanceOf(holder);
92         uint256 portion = percent(holderBalance, eligibleTokens, uint256(18));
93         amountDistributed = totalDistributionAmountInWei.mul(portion).div(1000000000000000000);
94 
95         distributed[holder] = amountDistributed;
96         Dividend(holder, amountDistributed);
97         holder.transfer(amountDistributed);
98     }
99 
100 
101 }