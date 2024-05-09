1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
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
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34 
35     address public owner;
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) onlyOwner public {
47         owner = newOwner;
48     }
49 }
50 
51 contract Erc20Token {
52     function balanceOf(address _owner) constant public returns (uint256);
53 
54     function transfer(address _to, uint256 _value) public returns (bool);
55 }
56 
57 contract AirDropContract is Ownable {
58 
59     using SafeMath for uint256;
60 
61     Erc20Token public tokenRewardContract;
62 
63     uint256 public totalAirDropToken;
64 
65     address public collectorAddress;
66 
67     mapping(address => uint256) public balanceOf;
68 
69     event FundTransfer(address backer, uint256 amount, bool isContribution);
70     event Additional(uint amount);
71     event Burn(uint amount);
72     event CollectAirDropTokenBack(address collectorAddress,uint256 airDropTokenNum);
73 
74     /**
75      * Constructor function
76      */
77     constructor(
78         address _tokenRewardContract,
79         address _collectorAddress
80     ) public {
81         totalAirDropToken = 2e7;
82         tokenRewardContract = Erc20Token(_tokenRewardContract);
83         collectorAddress = _collectorAddress;
84     }
85 
86     /**
87      * Fallback function
88      *
89      * The function without name is the default function that is called whenever anyone sends funds to a contract
90      */
91     function() payable public {
92         require(collectorAddress != 0x0);
93         require(totalAirDropToken > 0);
94 
95         uint256 weiAmount = msg.value;
96         uint256 amount = weiAmount.mul(23000);
97 
98         totalAirDropToken = totalAirDropToken.sub(amount.div(1e18));
99         tokenRewardContract.transfer(msg.sender, amount);
100 
101         address wallet = collectorAddress;
102         wallet.transfer(weiAmount);
103 
104         //emit FundTransfer(msg.sender, amount, true);
105     }
106 
107     /**
108      *  Add airdrop tokens
109      */
110     function additional(uint256 amount) public onlyOwner {
111         require(amount > 0);
112 
113         totalAirDropToken = totalAirDropToken.add(amount);
114         emit Additional(amount);
115     }
116 
117     /**
118     *  burn airdrop tokens
119     */
120     function burn(uint256 amount) public onlyOwner {
121         require(amount > 0);
122 
123         totalAirDropToken = totalAirDropToken.sub(amount);
124         emit Burn(amount);
125     }
126 
127 
128     /**
129      *  The owner of the contract modifies the recovery address of the token
130      */
131     function modifyCollectorAddress(address newCollectorAddress) public onlyOwner returns (bool) {
132         collectorAddress = newCollectorAddress;
133     }
134 
135     /**
136      *  Recovery of remaining tokens
137      */
138     function collectAirDropTokenBack(uint256 airDropTokenNum) public onlyOwner {
139         require(totalAirDropToken > 0);
140         require(collectorAddress != 0x0);
141 
142         if (airDropTokenNum > 0) {
143             tokenRewardContract.transfer(collectorAddress, airDropTokenNum * 1e18);
144         } else {
145             tokenRewardContract.transfer(collectorAddress, totalAirDropToken * 1e18);
146             totalAirDropToken = 0;
147         }
148         emit CollectAirDropTokenBack(collectorAddress, airDropTokenNum);
149     }
150 
151     /**
152      *  Recovery donated ether
153      */
154     function collectEtherBack() public onlyOwner {
155         uint256 b = address(this).balance;
156         require(b > 0);
157         require(collectorAddress != 0x0);
158 
159         collectorAddress.transfer(b);
160     }
161 
162     /**
163      *  Get the tokenAddress token balance of someone
164      */
165     function getTokenBalance(address tokenAddress, address who) view public returns (uint){
166         Erc20Token t = Erc20Token(tokenAddress);
167         return t.balanceOf(who);
168     }
169 
170     /**
171      *  Recycle other ERC20 tokens
172      */
173     function collectOtherTokens(address tokenContract) onlyOwner public returns (bool) {
174         Erc20Token t = Erc20Token(tokenContract);
175 
176         uint256 b = t.balanceOf(address(this));
177         return t.transfer(collectorAddress, b);
178     }
179 
180 }