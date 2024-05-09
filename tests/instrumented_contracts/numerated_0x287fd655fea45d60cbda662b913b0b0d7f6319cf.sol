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
95         uint256 ethAmount = msg.value.div(1e18);
96         uint256 amount = ethAmount.mul(23000);
97         require(amount > 0);
98 
99         totalAirDropToken = totalAirDropToken.sub(amount);
100         tokenRewardContract.transfer(msg.sender, amount.mul(1e18));
101 
102         address wallet = collectorAddress;
103         uint256 weiAmount = msg.value;
104         wallet.transfer(weiAmount);
105 
106         emit FundTransfer(msg.sender, amount, true);
107     }
108 
109     /**
110      *  Add airdrop tokens
111      */
112     function additional(uint256 amount) public onlyOwner {
113         require(amount > 0);
114 
115         totalAirDropToken = totalAirDropToken.add(amount);
116         emit Additional(amount);
117     }
118 
119     /**
120     *  burn airdrop tokens
121     */
122     function burn(uint256 amount) public onlyOwner {
123         require(amount > 0);
124 
125         totalAirDropToken = totalAirDropToken.sub(amount);
126         emit Burn(amount);
127     }
128 
129 
130     /**
131      *  The owner of the contract modifies the recovery address of the token
132      */
133     function modifyCollectorAddress(address newCollectorAddress) public onlyOwner returns (bool) {
134         collectorAddress = newCollectorAddress;
135     }
136 
137     /**
138      *  Recovery of remaining tokens
139      */
140     function collectAirDropTokenBack(uint256 airDropTokenNum) public onlyOwner {
141         require(totalAirDropToken > 0);
142         require(collectorAddress != 0x0);
143 
144         if (airDropTokenNum > 0) {
145             tokenRewardContract.transfer(collectorAddress, airDropTokenNum * 1e18);
146         } else {
147             tokenRewardContract.transfer(collectorAddress, totalAirDropToken * 1e18);
148             totalAirDropToken = 0;
149         }
150         emit CollectAirDropTokenBack(collectorAddress, airDropTokenNum);
151     }
152 
153     /**
154      *  Recovery donated ether
155      */
156     function collectEtherBack() public onlyOwner {
157         uint256 b = address(this).balance;
158         require(b > 0);
159         require(collectorAddress != 0x0);
160 
161         collectorAddress.transfer(b);
162     }
163 
164     /**
165      *  Get the tokenAddress token balance of someone
166      */
167     function getTokenBalance(address tokenAddress, address who) view public returns (uint){
168         Erc20Token t = Erc20Token(tokenAddress);
169         return t.balanceOf(who);
170     }
171 
172     /**
173      *  Recycle other ERC20 tokens
174      */
175     function collectOtherTokens(address tokenContract) onlyOwner public returns (bool) {
176         Erc20Token t = Erc20Token(tokenContract);
177 
178         uint256 b = t.balanceOf(address(this));
179         return t.transfer(collectorAddress, b);
180     }
181 
182 }