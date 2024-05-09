1 contract IXaurumToken {
2     function doCoinage(address[] _coinageAddresses, uint256[] _coinageAmounts, uint256 _usdAmount, uint256 _xaurCoined, uint256 _goldBought) returns (bool) {}
3 }
4 
5 contract MintingContract{
6     
7     //
8     /* Variables */
9     //
10     
11     /* Public variables */
12     address public curator;
13     address public dev;
14     address public defaultMintingAddress;
15     
16     uint256 public usdAmount;
17     uint256 public xaurCoined; 
18     uint256 public goldBought;
19     
20     /* Private variables */
21     IXaurumToken tokenContract;
22     
23     /* Events */    
24     event MintMade(uint256 usdAmount, uint256 xaurAmount, uint256 goldAmount);
25 
26     
27     //
28     /* Constructor */
29     //
30     
31     function MintingContract(){
32         dev = msg.sender;
33     }
34     
35     //
36     /* Contract features */
37     //
38     
39     function doCoinage() returns (bool){
40         if (msg.sender != curator){ return false; }
41         if (usdAmount == 0 || xaurCoined == 0 || goldBought == 0){ return false; }
42         
43         address[] memory tempAddressArray = new address[](1);
44         tempAddressArray[0] = defaultMintingAddress;
45         
46         uint256[] memory tempAmountArray = new uint256[](1);
47         tempAmountArray[0] = xaurCoined;
48         
49         tokenContract.doCoinage(tempAddressArray, tempAmountArray, usdAmount, xaurCoined, goldBought);
50         
51         MintMade(usdAmount, xaurCoined, goldBought);
52         usdAmount = 0;
53         xaurCoined  = 0; 
54         goldBought = 0;
55         
56         return true;
57     }
58     
59     function setDefaultMintingAddress(address _mintingAddress) returns (bool){
60         if (msg.sender != curator){ return false; }
61         defaultMintingAddress = _mintingAddress;
62         return true;
63     }
64     
65     function setUsdAmount(uint256 _usdAmount) returns (bool){
66         if (msg.sender != curator){ return false; }
67         usdAmount = _usdAmount;
68         return true;
69     }
70     
71     function getRealUsdAmount() constant returns (uint256){
72         return usdAmount / 10**8;
73     }
74     
75     function setXaurCoined(uint256 _xaurCoined) returns (bool){
76         if (msg.sender != curator){ return false; }
77         xaurCoined = _xaurCoined;
78         return true;
79     }
80     
81     function getRealXaurCoined() constant returns (uint256){
82         return xaurCoined / 10**8;
83     }
84     
85     function setGoldBought(uint256 _goldBought) returns (bool){
86         if (msg.sender != curator){ return false; }
87         goldBought = _goldBought;
88         return true;
89     }
90     
91     function getRealGoldBought() constant returns (uint256){
92         return goldBought / 10**8;
93     }
94     
95     //
96     /* Administration features */
97     //
98     
99     function setMintingCurator(address _curatorAddress) returns (uint error){
100         if (msg.sender != dev){ return 1; }
101         curator = _curatorAddress;
102         return 0;
103     }
104     
105     function setTokenContract(address _contractAddress) returns (uint error){
106         if (msg.sender != curator){ return 1; }
107         tokenContract = IXaurumToken(_contractAddress);
108         return 0;
109     }
110     
111     function killContract() returns (uint error) {
112         if (msg.sender != dev) { return 1; }
113         selfdestruct(dev);
114         return 0;
115     }
116     
117     //
118     /* Getters */
119     //
120     
121     function tokenAddress() constant returns (address tokenAddress){
122         return address(tokenContract);
123     }
124     
125     //
126     /* Other */
127     //
128     
129     function () {
130         throw;
131     }
132 }