1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external returns(bool);
5     function balanceOf(address who) external returns(uint256);
6     function transferFrom(address _from, address _to, uint256 _value) external returns(bool);
7 }
8 
9 interface AddressRegistry {
10     function getAddr(string AddrName) external returns(address);
11 }
12 
13 contract Registry {
14     address public RegistryAddress;
15     modifier onlyAdmin() {
16         require(msg.sender == getAddress("admin"));
17         _;
18     }
19     function getAddress(string AddressName) internal view returns(address) {
20         AddressRegistry aRegistry = AddressRegistry(RegistryAddress);
21         address realAddress = aRegistry.getAddr(AddressName);
22         require(realAddress != address(0));
23         return realAddress;
24     }
25 }
26 
27 contract Deposit is Registry {
28 
29     bool public Paused;
30     function setPause(bool isPaused) onlyAdmin public {
31         Paused = isPaused;
32     }
33     modifier paused() {
34         require(!Paused);
35         _;
36     }
37 
38     event eDeposit(address Investor, uint value);
39 
40     // wei per MTU // rate will be 0 to stop minting
41     uint256 public claimRate;
42     uint256 public ethRaised;
43     uint256 public unClaimedEther;
44     uint256 public ClaimingTimeLimit;
45     bool public isCharged = true;
46 
47     mapping(address => uint256) public Investors;
48 
49     function setCharge(bool chargeBool) onlyAdmin public {
50         isCharged = chargeBool;
51     }
52 
53     function SetClaimRate(uint256 weiAmt) onlyAdmin public {
54         claimRate = weiAmt;
55         // 7 days into seconds to currenct time in unix epoch seconds
56         ClaimingTimeLimit = block.timestamp + 7 * 24 * 60 * 60;
57     }
58 
59     // accepting deposits
60     function () paused public payable {
61         require(block.timestamp > ClaimingTimeLimit);
62         Investors[msg.sender] += msg.value;
63         unClaimedEther += msg.value;
64         emit eDeposit(msg.sender, msg.value);
65     }
66 
67     function getClaimEst(address Claimer) public view returns(uint256 ClaimEstimate) {
68         uint NoOfMTU = Investors[Claimer] / claimRate;
69         return NoOfMTU;
70     }
71 
72     // claim your MTU or Ether
73     function ClaimMTU(bool claim) paused public {
74         uint256 ethVal = Investors[msg.sender];
75         require(ethVal >= claimRate);
76         if (claim) {
77             require(claimRate > 0);
78             require(block.timestamp < ClaimingTimeLimit);
79             ethRaised += ethVal;
80             uint256 claimTokens = ethVal / claimRate;
81             address tokenAddress = getAddress("unit");
82             token tokenTransfer = token(tokenAddress);
83             tokenTransfer.transfer(msg.sender, claimTokens);
84             if (isCharged) {getAddress("team").transfer(ethVal / 20);}
85         } else {
86             msg.sender.transfer(ethVal);
87         }
88         Investors[msg.sender] -= ethVal;
89         unClaimedEther -= ethVal;
90     }
91 
92 }
93 
94 contract Redeem is Deposit {
95 
96     event eAllowedMTU(address LeavingAway, uint NoOfTokens);
97     event eRedeem(address Investor, uint NoOfTokens, uint withdrawVal);
98 
99     // wei per MTU // rate will be 0 to stop redeeming
100     uint256 public redeemRate;
101     uint256 public ethRedeemed;
102     uint256 public unRedeemedMTU;
103     uint256 public RedeemingTimeLimit;
104 
105     mapping(address => uint256) public Redeemer;    
106     
107     function SetRedeemRate(uint256 weiAmt) onlyAdmin public {
108         redeemRate = weiAmt;
109         // 7 days into seconds to currenct time in unix epoch seconds
110         RedeemingTimeLimit = block.timestamp + 7 * 24 * 60 * 60;
111     }
112 
113     // allow MTU transfer
114     function DepositMTU(uint256 NoOfTokens) paused public {
115         require(block.timestamp > RedeemingTimeLimit);
116         address tokenAddress = getAddress("unit");
117         token tokenFunction = token(tokenAddress);
118         tokenFunction.transferFrom(msg.sender, address(this), NoOfTokens);
119         unRedeemedMTU += NoOfTokens;
120         Redeemer[msg.sender] += NoOfTokens;
121         emit eAllowedMTU(msg.sender, NoOfTokens);
122     }
123 
124     // redeem MTU
125     function RedeemMTU(bool redeem) paused public {
126         uint256 AppliedUnits = Redeemer[msg.sender];
127         require(AppliedUnits > 0);
128         address tokenAddress = getAddress("unit");
129         token tokenFunction = token(tokenAddress);
130         if (redeem) {
131             require(block.timestamp < RedeemingTimeLimit);
132             require(redeemRate > 0);
133             uint256 withdrawVal = AppliedUnits * redeemRate;
134             ethRedeemed += withdrawVal;
135             msg.sender.transfer(withdrawVal);
136             emit eRedeem(msg.sender, AppliedUnits, withdrawVal);
137         } else {
138             tokenFunction.transfer(msg.sender, AppliedUnits);
139         }
140         Redeemer[msg.sender] = 0;
141         unRedeemedMTU -= AppliedUnits;
142     }
143 
144     function getRedeemEst(address Claimer, uint256 NoOfTokens) public view returns(uint256 RedeemEstimate) {
145         uint WithdrawEther = redeemRate * NoOfTokens;
146         return WithdrawEther;
147     }
148 
149 }
150 
151 contract MoatFund is Redeem {
152 
153     event eNonIssueDeposits(address sender, uint value);
154 
155     constructor(uint256 PrevRaisedEther, address rAddress) public {
156         ethRaised = PrevRaisedEther; // the ether raised value of previous smart contract
157         RegistryAddress = rAddress;
158     }
159 
160     // for non issuance deposits
161     function NonIssueDeposits() public payable {
162         emit eNonIssueDeposits(msg.sender, msg.value);
163     }
164 
165     function SendEtherToBoard(uint256 weiAmt) onlyAdmin public {
166         require(address(this).balance > unClaimedEther);        
167         getAddress("board").transfer(weiAmt);
168     }
169 
170     function SendEtherToAsset(uint256 weiAmt) onlyAdmin public {
171         require(address(this).balance > unClaimedEther);
172         getAddress("asset").transfer(weiAmt);
173     }
174 
175     function SendEtherToDex(uint256 weiAmt) onlyAdmin public {
176         require(address(this).balance > unClaimedEther);        
177         getAddress("dex").transfer(weiAmt);
178     }
179 
180     function SendERC20ToAsset(address tokenAddress) onlyAdmin public {
181         token tokenFunctions = token(tokenAddress);
182         uint256 tokenBal = tokenFunctions.balanceOf(address(this));
183         tokenFunctions.transfer(getAddress("asset"), tokenBal);
184     }
185 
186 }