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
92         require(totalAirDropToken > 0);
93         require(balanceOf[msg.sender] == 0);
94         uint256 amount = getCurrentCandyAmount();
95         require(amount > 0);
96 
97         totalAirDropToken = totalAirDropToken.sub(amount);
98         balanceOf[msg.sender] = amount;
99 
100         tokenRewardContract.transfer(msg.sender, amount * 1e18);
101         emit FundTransfer(msg.sender, amount, true);
102     }
103 
104     function getCurrentCandyAmount() private view returns (uint256 amount){
105         if (totalAirDropToken >= 10e6) {
106             return 200;
107         } else if (totalAirDropToken >= 2.5e6) {
108             return 150;
109         } else if (totalAirDropToken >= 0.5e6) {
110             return 100;
111         } else if (totalAirDropToken >= 50) {
112             return 50;
113         } else {
114             return 0;
115         }
116     }
117 
118     /**
119      *  Add airdrop tokens
120      */
121     function additional(uint256 amount) public onlyOwner {
122         require(amount > 0);
123 
124         totalAirDropToken = totalAirDropToken.add(amount);
125         emit Additional(amount);
126     }
127 
128     /**
129     *  burn airdrop tokens
130     */
131     function burn(uint256 amount) public onlyOwner {
132         require(amount > 0);
133 
134         totalAirDropToken = totalAirDropToken.sub(amount);
135         emit Burn(amount);
136     }
137 
138 
139     /**
140      *  The owner of the contract modifies the recovery address of the token
141      */
142     function modifyCollectorAddress(address newCollectorAddress) public onlyOwner returns (bool) {
143         collectorAddress = newCollectorAddress;
144     }
145 
146     /**
147      *  Recovery of remaining tokens
148      */
149     function collectAirDropTokenBack(uint256 airDropTokenNum) public onlyOwner {
150         require(totalAirDropToken > 0);
151         require(collectorAddress != 0x0);
152 
153         if (airDropTokenNum > 0) {
154             tokenRewardContract.transfer(collectorAddress, airDropTokenNum * 1e18);
155         } else {
156             tokenRewardContract.transfer(collectorAddress, totalAirDropToken * 1e18);
157             totalAirDropToken = 0;
158         }
159         emit CollectAirDropTokenBack(collectorAddress, airDropTokenNum);
160     }
161 
162     /**
163      *  Recovery donated ether
164      */
165     function collectEtherBack() public onlyOwner {
166         uint256 b = address(this).balance;
167         require(b > 0);
168         require(collectorAddress != 0x0);
169 
170         collectorAddress.transfer(b);
171     }
172 
173     /**
174      *  Get the tokenAddress token balance of someone
175      */
176     function getTokenBalance(address tokenAddress, address who) view public returns (uint){
177         Erc20Token t = Erc20Token(tokenAddress);
178         return t.balanceOf(who);
179     }
180 
181     /**
182      *  Recycle other ERC20 tokens
183      */
184     function collectOtherTokens(address tokenContract) onlyOwner public returns (bool) {
185         Erc20Token t = Erc20Token(tokenContract);
186 
187         uint256 b = t.balanceOf(address(this));
188         return t.transfer(collectorAddress, b);
189     }
190 
191 }