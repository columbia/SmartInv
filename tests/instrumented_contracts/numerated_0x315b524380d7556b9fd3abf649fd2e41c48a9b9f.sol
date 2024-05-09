1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title IHFVesting
66  * @dev IHFVesting is a token holder contract that allows the specified beneficiary
67  * to claim stored tokens after 6 month intervals
68 */
69 
70  contract IHFVesting {
71     using SafeMath for uint256;
72 
73     address public beneficiary;
74     uint256 public fundingEndBlock;
75 
76     bool private initClaim = false; // state tracking variables
77 
78     uint256 public firstRelease; // vesting times
79     bool private firstDone = false;
80     uint256 public secondRelease;
81     bool private secondDone = false;
82     uint256 public thirdRelease;
83     bool private thirdDone = false;
84     uint256 public fourthRelease;
85 
86     ERC20Basic public ERC20Token; // ERC20 basic token contract to hold
87 
88     enum Stages {
89         initClaim,
90         firstRelease,
91         secondRelease,
92         thirdRelease,
93         fourthRelease
94     }
95 
96     Stages public stage = Stages.initClaim;
97 
98     modifier atStage(Stages _stage) {
99         if(stage == _stage) _;
100     }
101 
102     function IHFVesting(address _token, uint256 fundingEndBlockInput) public {
103         require(_token != address(0));
104         beneficiary = msg.sender;
105         fundingEndBlock = fundingEndBlockInput;
106         ERC20Token = ERC20Basic(_token);
107     }
108 
109     function changeBeneficiary(address newBeneficiary) external {
110         require(newBeneficiary != address(0));
111         require(msg.sender == beneficiary);
112         beneficiary = newBeneficiary;
113     }
114 
115     function updateFundingEndBlock(uint256 newFundingEndBlock) public {
116         require(msg.sender == beneficiary);
117         require(block.number < fundingEndBlock);
118         require(block.number < newFundingEndBlock);
119         fundingEndBlock = newFundingEndBlock;
120     }
121 
122     function checkBalance() public view returns (uint256 tokenBalance) {
123         return ERC20Token.balanceOf(this);
124     }
125 
126     // in total 2.5% of IHF tokens will be sent to this contract
127     // INVICTUS: 1%
128     // TEAM: 1.5%
129     //  initalPaymen: 0.3%
130     //  firstRelease: 0.3%
131     //  secondRelease: 0.3%
132     //  thirdRelease: 0.3%
133     //  fourthRelease: 0.3%
134     // initial claim is Invictus + initial team payment
135     // initial claim is thus (1 + 0.3)/2.5 = 52% of C20 tokens sent here
136     // each other release (for team) is 12% of tokens sent here
137 
138     function claim() external {
139         require(msg.sender == beneficiary);
140         require(block.number > fundingEndBlock);
141         uint256 balance = ERC20Token.balanceOf(this);
142         // in reverse order so stages changes don't carry within one claim
143         fourth_release(balance);
144         third_release(balance);
145         second_release(balance);
146         first_release(balance);
147         init_claim(balance);
148     }
149 
150     function nextStage() private {
151         stage = Stages(uint256(stage) + 1);
152     }
153 
154     function init_claim(uint256 balance) private atStage(Stages.initClaim) {
155         firstRelease = now + 26 weeks; // assign 4 claiming times
156         secondRelease = firstRelease + 26 weeks;
157         thirdRelease = secondRelease + 26 weeks;
158         fourthRelease = thirdRelease + 26 weeks;
159         uint256 amountToTransfer = balance.mul(52).div(100);
160         ERC20Token.transfer(beneficiary, amountToTransfer); // now 48% tokens left
161         nextStage();
162     }
163     function first_release(uint256 balance) private atStage(Stages.firstRelease) {
164         require(now > firstRelease);
165         uint256 amountToTransfer = balance.div(4);
166         ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
167         nextStage();
168     }
169     function second_release(uint256 balance) private atStage(Stages.secondRelease) {
170         require(now > secondRelease);
171         uint256 amountToTransfer = balance.div(3);
172         ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
173         nextStage();
174     }
175     function third_release(uint256 balance) private atStage(Stages.thirdRelease) {
176         require(now > thirdRelease);
177         uint256 amountToTransfer = balance.div(2);
178         ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
179         nextStage();
180     }
181     function fourth_release(uint256 balance) private atStage(Stages.fourthRelease) {
182         require(now > fourthRelease);
183         ERC20Token.transfer(beneficiary, balance); // send remaining 25 % of team releases
184     }
185 
186     function claimOtherTokens(address _token) external {
187         require(msg.sender == beneficiary);
188         require(_token != address(0));
189         ERC20Basic token = ERC20Basic(_token);
190         require(token != ERC20Token);
191         uint256 balance = token.balanceOf(this);
192         token.transfer(beneficiary, balance);
193      }
194 
195  }