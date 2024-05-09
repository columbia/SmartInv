1 pragma solidity ^0.5.7;
2 
3 interface RegistryInterface {
4     function proxies(address) external view returns (address);
5 }
6 
7 interface UserWalletInterface {
8     function owner() external view returns (address);
9 }
10 
11 interface CTokenInterface {
12     function mint(uint mintAmount) external returns (uint); // For ERC20
13     function repayBorrow(uint repayAmount) external returns (uint); // For ERC20
14     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint); // For ERC20
15     function borrowBalanceCurrent(address account) external returns (uint);
16     function redeem(uint redeemTokens) external returns (uint);
17     function redeemUnderlying(uint redeemAmount) external returns (uint);
18     function borrow(uint borrowAmount) external returns (uint);
19     function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);
20     function liquidateBorrow(address borrower, address cTokenCollateral) external payable;
21     function exchangeRateCurrent() external returns (uint);
22     function getCash() external view returns (uint);
23     function totalBorrowsCurrent() external returns (uint);
24     function borrowRatePerBlock() external view returns (uint);
25     function supplyRatePerBlock() external view returns (uint);
26     function totalReserves() external view returns (uint);
27     function reserveFactorMantissa() external view returns (uint);
28 
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address owner) external view returns (uint256 balance);
31     function allowance(address, address) external view returns (uint);
32     function approve(address, uint) external;
33     function transfer(address, uint) external returns (bool);
34     function transferFrom(address, address, uint) external returns (bool);
35 }
36 
37 interface ERC20Interface {
38     function allowance(address, address) external view returns (uint);
39     function balanceOf(address) external view returns (uint);
40     function approve(address, uint) external;
41     function transfer(address, uint) external returns (bool);
42     function transferFrom(address, address, uint) external returns (bool);
43 }
44 
45 
46 contract DSMath {
47 
48     function add(uint x, uint y) internal pure returns (uint z) {
49         require((z = x + y) >= x, "math-not-safe");
50     }
51 
52     function mul(uint x, uint y) internal pure returns (uint z) {
53         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
54     }
55 
56     uint constant WAD = 10 ** 18;
57 
58     function wmul(uint x, uint y) internal pure returns (uint z) {
59         z = add(mul(x, y), WAD / 2) / WAD;
60     }
61 
62     function wdiv(uint x, uint y) internal pure returns (uint z) {
63         z = add(mul(x, WAD), y / 2) / y;
64     }
65 
66 }
67 
68 
69 contract Helper is DSMath {
70 
71     address public daiAdd = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
72     // address public daiAdd = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa; // Rinkeby
73     address public cDaiAdd = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
74     // address public cDaiAdd = 0x6D7F0754FFeb405d23C51CE938289d4835bE3b14; // Rinkeby
75     address public registryAdd = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
76     mapping (address => uint) public deposited; // Amount of CToken deposited
77     mapping (address => bool) public isAdmin;
78 
79     /**
80      * @dev setting allowance to compound for the "user proxy" if required
81      */
82     function setApproval(address erc20, uint srcAmt, address to) internal {
83         ERC20Interface erc20Contract = ERC20Interface(erc20);
84         uint tokenAllowance = erc20Contract.allowance(address(this), to);
85         if (srcAmt > tokenAllowance) {
86             erc20Contract.approve(to, 2**255);
87         }
88     }
89 
90     modifier isUserWallet {
91         address userAdd = UserWalletInterface(msg.sender).owner();
92         address walletAdd = RegistryInterface(registryAdd).proxies(userAdd);
93         require(walletAdd != address(0), "Not-User-Wallet");
94         require(walletAdd == msg.sender, "Not-Wallet-Owner");
95         _;
96     }
97 
98 }
99 
100 
101 contract CTokens is Helper {
102 
103     struct CTokenData {
104         address cTokenAdd;
105         uint factor;
106     }
107 
108     CTokenData[] public cTokenAddr;
109 
110     uint public cArrLength = 0;
111 
112     function addCToken(address cToken, uint factor) public {
113         require(isAdmin[msg.sender], "Address not an admin");
114         CTokenData memory setCToken = CTokenData(cToken, factor);
115         cTokenAddr.push(setCToken);
116         cArrLength++;
117     }
118 
119 }
120 
121 
122 contract Bridge is CTokens {
123 
124     /**
125      * @dev Deposit DAI for liquidity
126      */
127     function depositDAI(uint amt) public {
128         ERC20Interface(daiAdd).transferFrom(msg.sender, address(this), amt);
129         CTokenInterface cToken = CTokenInterface(cDaiAdd);
130         assert(cToken.mint(amt) == 0);
131         uint cDaiAmt = wdiv(amt, cToken.exchangeRateCurrent());
132         deposited[msg.sender] += cDaiAmt;
133     }
134 
135     /**
136      * @dev Withdraw DAI from liquidity
137      */
138     function withdrawDAI(uint amt) public {
139         require(deposited[msg.sender] != 0, "Nothing to Withdraw");
140         CTokenInterface cToken = CTokenInterface(cDaiAdd);
141         uint withdrawAmt = wdiv(amt, cToken.exchangeRateCurrent());
142         uint daiAmt = amt;
143         if (withdrawAmt > deposited[msg.sender]) {
144             withdrawAmt = deposited[msg.sender];
145             daiAmt = wmul(withdrawAmt, cToken.exchangeRateCurrent());
146         }
147         require(cToken.redeem(withdrawAmt) == 0, "something went wrong");
148         ERC20Interface(daiAdd).transfer(msg.sender, daiAmt);
149         deposited[msg.sender] -= withdrawAmt;
150     }
151 
152     /**
153      * @dev Deposit CDAI for liquidity
154      */
155     function depositCDAI(uint amt) public {
156         CTokenInterface cToken = CTokenInterface(cDaiAdd);
157         require(cToken.transferFrom(msg.sender, address(this), amt), "Nothing to deposit");
158         deposited[msg.sender] += amt;
159     }
160 
161     /**
162      * @dev Withdraw CDAI from liquidity
163      */
164     function withdrawCDAI(uint amt) public {
165         require(deposited[msg.sender] != 0, "Nothing to Withdraw");
166         CTokenInterface cToken = CTokenInterface(cDaiAdd);
167         uint withdrawAmt = amt;
168         if (withdrawAmt > deposited[msg.sender]) {
169             withdrawAmt = deposited[msg.sender];
170         }
171         cToken.transfer(msg.sender, withdrawAmt);
172         deposited[msg.sender] -= withdrawAmt;
173     }
174 
175     /**
176      * @dev Transfer DAI to only to user wallet
177      */
178     function transferDAI(uint amt) public isUserWallet {
179         CTokenInterface cToken = CTokenInterface(cDaiAdd);
180         require(cToken.redeemUnderlying(amt) == 0, "something went wrong");
181         ERC20Interface(daiAdd).transfer(msg.sender, amt);
182     }
183 
184     /**
185      * @dev Take DAI back from user wallet
186      */
187     function transferBackDAI(uint amt) public isUserWallet {
188         ERC20Interface tokenContract = ERC20Interface(daiAdd);
189         tokenContract.transferFrom(msg.sender, address(this), amt);
190         CTokenInterface cToken = CTokenInterface(cDaiAdd);
191         assert(cToken.mint(amt) == 0);
192     }
193 
194 }
195 
196 
197 contract MakerCompBridge is Bridge {
198 
199     uint public version;
200 
201     /**
202      * @dev setting up variables on deployment
203      * 1...2...3 versioning in each subsequent deployments
204      */
205     constructor(uint _version) public {
206         isAdmin[0x7284a8451d9a0e7Dc62B3a71C0593eA2eC5c5638] = true;
207         isAdmin[0xa7615CD307F323172331865181DC8b80a2834324] = true;
208         addCToken(0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E, 600000000000000000);
209         addCToken(0xF5DCe57282A584D2746FaF1593d3121Fcac444dC, 750000000000000000);
210         addCToken(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5, 750000000000000000);
211         addCToken(0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1, 500000000000000000);
212         addCToken(0x39AA39c021dfbaE8faC545936693aC917d5E7563, 750000000000000000);
213         addCToken(0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407, 600000000000000000);
214         setApproval(daiAdd, 10**30, cDaiAdd);
215         setApproval(cDaiAdd, 10**30, cDaiAdd);
216         version = _version;
217     }
218 
219     function() external payable {}
220 
221 }