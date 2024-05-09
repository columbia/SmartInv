1 pragma solidity ^0.4.25;
2 
3 /*** @title SafeMath
4  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol */
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 interface ERC20 {
33     function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
34     function mintFromICO(address _to, uint256 _amount) external  returns(bool);
35     function isWhitelisted(address wlCandidate) external returns(bool);
36 }
37 /**
38  * @title Ownable
39  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
40  */
41 contract Ownable {
42     address public owner;
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 }
53 
54 /**
55  * @title CrowdSale
56  * @dev https://github.com/
57  */
58 contract PreICO is Ownable {
59 
60     ERC20 public token;
61     
62     ERC20 public authorize;
63     
64     using SafeMath for uint;
65 
66     address public backEndOperator = msg.sender;
67     address bounty = 0x0cdb839B52404d49417C8Ded6c3E2157A06CdD37; // 0.4% - для баунти программы
68 
69     mapping(address=>bool) public whitelist;
70 
71     mapping(address => uint256) public investedEther;
72 
73     uint256 public startPreICO = 1543700145; 
74     uint256 public endPreICO = 1547510400; 
75 
76     uint256 public investors; // total number of investors
77     uint256 public weisRaised; // total amount collected by ether
78 
79     uint256 public hardCap1Stage = 10000000*1e18; // 10,000,000 SPC = $1,000,000 EURO
80 
81     uint256 public buyPrice; // 0.1 EURO
82     uint256 public euroPrice; // Ether by USD
83 
84     uint256 public soldTokens; // solded tokens - > 10,000,000 SPC
85 
86     event Authorized(address wlCandidate, uint timestamp);
87     event Revoked(address wlCandidate, uint timestamp);
88     event UpdateDollar(uint256 time, uint256 _rate);
89 
90     modifier backEnd() {
91         require(msg.sender == backEndOperator || msg.sender == owner);
92         _;
93     }
94 
95     // contract constructor
96     constructor(ERC20 _token, ERC20 _authorize, uint256 usdETH) public {
97         token = _token;
98         authorize = _authorize;
99         euroPrice = usdETH;
100         buyPrice = (1e18/euroPrice).div(10); // 0.1 euro
101     }
102 
103     // change the date of commencement of pre-sale
104     function setStartSale(uint256 newStartSale) public onlyOwner {
105         startPreICO = newStartSale;
106     }
107 
108     // change the date of the end of pre-sale
109     function setEndSale(uint256 newEndSale) public onlyOwner {
110         endPreICO = newEndSale;
111     }
112 
113     // Change of operator’s backend address
114     function setBackEndAddress(address newBackEndOperator) public onlyOwner {
115         backEndOperator = newBackEndOperator;
116     }
117 
118     // Change in the rate of dollars to broadcast
119     function setBuyPrice(uint256 _dollar) public backEnd {
120         euroPrice = _dollar;
121         buyPrice = (1e18/euroPrice).div(10); // 0.1 euro
122         emit UpdateDollar(now, euroPrice);
123     }
124 
125 
126     /*******************************************************************************
127      * Payable's section
128      */
129 
130     function isPreICO() public constant returns(bool) {
131         return now >= startPreICO && now <= endPreICO;
132     }
133 
134     // callback contract function
135     function () public payable {
136         require(authorize.isWhitelisted(msg.sender));
137         require(isPreICO());
138         require(msg.value >= buyPrice.mul(100)); // ~ 10 EURO
139         SalePreICO(msg.sender, msg.value);
140         require(soldTokens<=hardCap1Stage);
141         investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
142     }
143 
144     // release of tokens during the pre-sale period
145     function SalePreICO(address _investor, uint256 _value) internal {
146         uint256 tokens = _value.mul(1e18).div(buyPrice);
147         token.mintFromICO(_investor, tokens);
148         soldTokens = soldTokens.add(tokens);
149 
150         uint256 tokensBoynty = tokens.div(250); // 2 %
151         token.mintFromICO(bounty, tokensBoynty);
152 
153         weisRaised = weisRaised.add(_value);
154     }
155 
156     // Sending air from the contract
157     function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
158         _to.transfer(amount);
159     }
160 
161    
162 }