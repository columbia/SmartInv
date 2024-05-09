1 pragma solidity ^0.4.26;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 contract SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10         return 0;
11     }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34   
35     function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(uint quotient) {
36         uint _numerator  = numerator * 10 ** (precision+1);
37         uint _quotient =  ((_numerator / denominator) + 5) / 10;
38         return (value*_quotient/1000000000000000000);
39     }
40 }
41 
42 contract DochStar is SafeMath {
43     string public constant name                         = "DochStar";                       // Name of the token
44     string public constant symbol                       = "DCHS";                           // Symbol of token
45     uint256 public constant decimals                    = 18;                               // Decimal of token
46     uint256 public constant _totalsupply                = 300000000 * 10 ** decimals;       // 300 million total supply
47     uint256 public constant _premined                   = 200000000 * 10 ** decimals;       // 200 million premined tokens
48     uint256 public _mined                               = 0;                                // Mined tokens
49     uint256 internal stakePer_                          = 200000000000000000;               // 0.2% Daily reward
50     address public owner                                = msg.sender;                       // Owner of smart contract
51     address public admin                                = 0x124AA9541961C4Dd648b176fD3b4D5D62fb77F17;// Admin of smart contract 
52 
53     mapping (address => uint256) balances;
54     mapping (address => uint256) mintbalances;
55     mapping (address => uint256) mintingTime;
56     
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     
59     // Only owner can access the function
60     modifier onlyOwner() {
61         if (msg.sender != owner) {
62             revert();
63         }
64         _;
65     }
66     
67     // Only admin can access the function
68     modifier onlyAdmin() {
69         if (msg.sender != admin) {
70             revert();
71         }
72         _;
73     }
74     
75     constructor() public {
76         balances[admin]        = _premined;
77         emit Transfer(0, admin, _premined);
78     }
79     
80     // Token minting function
81     function mint(uint256 _amount) public returns (bool success) {
82         address _customerAddress    = msg.sender;
83         require(_totalsupply > (SafeMath.add(_premined, _mined)));                                   // Total supply should be > premined token and mined token combined
84         require(mintingTime[_customerAddress] == 0);                                                
85         require(balances[msg.sender] >= _amount && _amount >= 0);
86         mintbalances[_customerAddress]      = _amount;
87         mintingTime[_customerAddress]       = now;
88         return true;
89     }
90     
91     function mintTokensROI(address _customerAddress) public view returns(uint256){
92         uint256 timediff                    = SafeMath.sub(now, mintingTime[_customerAddress]);
93         uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
94         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
95         uint256 roiTokens                   = SafeMath.percent(mintbalances[_customerAddress],roiPercent,100,18);
96         uint256 finalBalance                = roiTokens/1e18;
97         return finalBalance;
98     }
99     
100     function mintTokens(address _customerAddress) public view returns(uint256){
101         return mintbalances[_customerAddress];
102     }
103     
104     function mintTokensTime(address _customerAddress) public view returns(uint256){
105         return mintingTime[_customerAddress];
106     }
107     
108     function unmintTokens() public returns(bool success){
109         address _customerAddress    = msg.sender;
110         require(mintingTime[_customerAddress] > 0); 
111         uint256 timediff                    = SafeMath.sub(now, mintingTime[_customerAddress]);
112         uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
113         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
114         uint256 roiTokens                   = SafeMath.percent(mintbalances[_customerAddress],roiPercent,100,18);
115         balances[_customerAddress]          = SafeMath.add(balances[_customerAddress],roiTokens/1e18);
116         _mined                              = SafeMath.add(_mined, roiTokens/1e18);
117         mintbalances[_customerAddress]      = 0;
118         mintingTime[_customerAddress]       = 0;
119         return true;
120     }
121     
122     function changeStakePercent(uint256 stakePercent) onlyAdmin public {
123         stakePer_                           = stakePercent;
124     }
125     
126     // Show token balance of address owner
127     function balanceOf(address _owner) public view returns (uint256 balance) {
128         uint256 finalBalance = SafeMath.sub(balances[_owner],mintbalances[_owner]);
129         return finalBalance;
130     }
131     
132     // Token transfer function
133     // Token amount should be in 18 decimals (eg. 199 * 10 ** 18)
134     function transfer(address _to, uint256 _amount ) public {
135         uint256 finalBalance = SafeMath.sub(balances[msg.sender],mintbalances[msg.sender]);
136         require(finalBalance >= _amount && _amount >= 0);
137         balances[msg.sender]            = sub(balances[msg.sender], _amount);
138         balances[_to]                   = add(balances[_to], _amount);
139         emit Transfer(msg.sender, _to, _amount);
140     }
141     
142     // Total Supply of DochStar
143     function totalSupply() public pure returns (uint256 total_Supply) {
144         total_Supply = _totalsupply;
145     }
146     
147     // Change Admin of this contract
148     function changeAdmin(address _newAdminAddress) external onlyOwner {
149         admin = _newAdminAddress;
150     }
151     
152 }