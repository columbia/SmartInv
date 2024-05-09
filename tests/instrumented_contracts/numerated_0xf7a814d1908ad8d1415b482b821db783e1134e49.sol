1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ERC20Interface {
25     function name() public constant returns (string);
26     function symbol() public constant returns (string);
27     function decimals() public constant returns (uint8);
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 contract Owned {
41     address public owner;
42     address public newOwner;
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     function Owned() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 
66 contract FlowStop is Owned {
67 
68     bool public stopped = false;
69 
70     modifier stoppable {
71         assert (!stopped);
72         _;
73     }
74     function stop() public onlyOwner {
75         stopped = true;
76     }
77     function start() public onlyOwner {
78         stopped = false;
79     }
80 }
81 
82 
83 contract Utils {
84     function Utils() internal {
85     }
86 
87     modifier validAddress(address _address) {
88         require(_address != 0x0);
89         _;
90     }
91 
92     modifier notThis(address _address) {
93         require(_address != address(this));
94         _;
95     }
96 }
97 
98 
99 contract BuyFlowingHair10ETH is Owned, FlowStop, Utils {
100     using SafeMath for uint;
101     ERC20Interface public flowingHairAddress;
102 
103     function BuyFlowingHair10ETH(ERC20Interface _flowingHairAddress) public{
104         flowingHairAddress = _flowingHairAddress;
105     }
106         
107     function withdrawTo(address to, uint amount)
108         public onlyOwner stoppable
109         notThis(to)
110     {   
111         require(amount <= this.balance);
112         to.transfer(amount);
113     }
114     
115     function withdrawERC20TokenTo(ERC20Interface token, address to, uint amount)
116         public onlyOwner
117         validAddress(token)
118         validAddress(to)
119         notThis(to)
120     {
121         assert(token.transfer(to, amount));
122 
123     }
124     
125     function buyToken() internal
126     {
127         require(!stopped && msg.value >= 10 ether);
128         uint amount = msg.value * 36400;
129         assert(flowingHairAddress.transfer(msg.sender, amount));
130     }
131 
132     function() public payable stoppable {
133         buyToken();
134     }
135 }