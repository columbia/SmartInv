1 pragma solidity ^0.4.24;
2 
3 /*
4     Sale(address ethwallet)   // this will send the received ETH funds to this address
5   @author Yumerium Ltd
6 */
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract YumeriumManager {
54     function getYumerium(uint256 value, address sender) external returns (uint256);
55 }
56 
57 contract Sale {
58     uint public saleEnd1 = 1535846400 + 1 days; //9/3/2018 @ 12:00am (UTC)
59     uint public saleEnd2 = saleEnd1 + 1 days; //9/4/2018 @ 12:00am (UTC)
60     uint public saleEnd3 = saleEnd2 + 1 days; //9/5/2018 @ 12:00am (UTC)
61     uint public saleEnd4 = 1539129600; //10/10/2018 @ 12:00am (UTC)
62     uint256 public minEthValue = 10 ** 15; // 0.001 eth
63 
64     uint256 public totalPariticpants = 0;
65     uint256 public adjustedValue = 0;
66     mapping(address => Renowned) public renownedPlayers; // map for the player information
67     mapping(bytes8 => address) public referral; // map for the player information
68     
69     using SafeMath for uint256;
70     uint256 public maxSale;
71     uint256 public totalSaled;
72     
73     YumeriumManager public manager;
74     address public owner;
75 
76     event Contribution(address from, uint256 amount);
77 
78     constructor(address _manager_address) public {
79         maxSale = 316906850 * 10 ** 8; 
80         manager = YumeriumManager(_manager_address);
81         owner = msg.sender;
82     }
83 
84     function () external payable {
85         buy("");
86     }
87 
88     // CONTRIBUTE FUNCTION
89     // converts ETH to TOKEN and sends new TOKEN to the sender
90     function contribute(bytes8 referralCode) external payable {
91         buy(referralCode);
92     }
93     
94     function becomeRenown() public payable {
95         generateRenown();
96         owner.transfer(msg.value);
97     }
98 
99     function generateRenown() private {
100         require(!renownedPlayers[msg.sender].isRenowned, "You already registered as renowned!");
101         bytes8 referralCode = bytes8(keccak256(abi.encodePacked(totalPariticpants + adjustedValue)));
102         // check hash collision and regenerate hash value again
103         while (renownedPlayers[referral[referralCode]].isRenowned)
104         {
105             adjustedValue = adjustedValue.add(1);
106             referralCode = bytes8(keccak256(abi.encodePacked(totalPariticpants + adjustedValue)));
107         }
108         renownedPlayers[msg.sender].addr = msg.sender;
109         renownedPlayers[msg.sender].referralCode = referralCode;
110         renownedPlayers[msg.sender].isRenowned = true;
111         referral[renownedPlayers[msg.sender].referralCode] = msg.sender;
112         totalPariticpants = totalPariticpants.add(1);
113     }
114     
115     function buy(bytes8 referralCode) internal {
116         require(msg.value>=minEthValue);
117         require(now < saleEnd4); // main sale postponed
118 
119         // distribution for referral
120         uint256 remainEth = msg.value;
121         if (referral[referralCode] != msg.sender && renownedPlayers[referral[referralCode]].isRenowned)
122         {
123             uint256 referEth = msg.value.mul(10).div(100);
124             referral[referralCode].transfer(referEth);
125             remainEth = remainEth.sub(referEth);
126         }
127 
128         if (!renownedPlayers[msg.sender].isRenowned)
129         {
130             generateRenown();
131         }
132         
133         uint256 amount = manager.getYumerium(msg.value, msg.sender);
134         uint256 total = totalSaled.add(amount);
135         owner.transfer(remainEth);
136         
137         require(total<=maxSale);
138         
139         totalSaled = total;
140         
141         emit Contribution(msg.sender, amount);
142     }
143 
144     // change yumo address
145     function changeManagerAddress(address _manager_address) external {
146         require(msg.sender==owner, "You are not an owner!");
147         manager = YumeriumManager(_manager_address);
148     }
149     // change yumo address
150     function changeTeamWallet(address _team_address) external {
151         require(msg.sender==owner, "You are not an owner!");
152         owner = YumeriumManager(_team_address);
153     }
154 
155     struct Renowned {
156         bool isRenowned;
157         address addr;
158         bytes8 referralCode;
159     }
160 }