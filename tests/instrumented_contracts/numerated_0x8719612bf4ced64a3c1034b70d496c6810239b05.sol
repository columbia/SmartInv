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
31 contract Owned {
32     address public owner;
33 
34     function Owned() public {
35         owner = msg.sender;
36     }
37 
38     function withdraw() public onlyOwner {
39         owner.transfer(this.balance);
40     }
41 
42     modifier onlyOwner() {
43         require(owner == msg.sender);
44         _;
45     }
46 }
47 
48 contract ERC20Basic {
49     uint256 public totalSupply;
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public view returns (uint256);
57     function transferFrom(address from, address to, uint256 value) public returns (bool);
58     function approve(address spender, uint256 value) public returns (bool);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract Distributor is Owned {
63 
64     using SafeMath for uint256;
65 
66     ERC20 public token;
67     uint256 public eligibleTokens;
68     mapping(address => uint256) public distributed;
69     uint256 public totalDistributionAmountInWei;
70 
71     event Dividend(address holder, uint256 amountDistributed);
72 
73     function Distributor(address _targetToken, uint256 _eligibleTokens) public payable {
74         require(msg.value > 0);
75 
76         token = ERC20(_targetToken);
77         assert(_eligibleTokens <= token.totalSupply());
78         eligibleTokens = _eligibleTokens;
79         totalDistributionAmountInWei = msg.value;
80     }
81 
82     function percent(uint numerator, uint denominator, uint precision) internal pure returns (uint quotient) {
83         uint _numerator = numerator * 10 ** (precision + 1);
84         quotient = ((_numerator / denominator) + 5) / 10;
85     }
86 
87     function distribute(address holder) public onlyOwner returns (uint256 amountDistributed) {
88         require(distributed[holder] == 0);
89 
90         uint256 holderBalance = token.balanceOf(holder);
91         uint256 portion = percent(holderBalance, eligibleTokens, uint256(4));
92         amountDistributed = totalDistributionAmountInWei.mul(portion).div(10000);
93 
94         distributed[holder] = amountDistributed;
95         Dividend(holder, amountDistributed);
96         holder.transfer(amountDistributed);
97     }
98 
99 
100 }