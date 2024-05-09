1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 
76 contract InvestorsList is Ownable {
77     using SafeMath for uint;
78 
79     /* Investor */
80 
81     enum WhiteListStatus  {Usual, WhiteList, PreWhiteList}
82 
83     struct Investor {
84         bytes32 id;
85         uint tokensCount;
86         address walletForTokens;
87         WhiteListStatus whiteListStatus;
88         bool isVerified;
89     }
90 
91     /*Investor's end*/
92 
93     mapping (address => bool) manipulators;
94     mapping (address => bytes32) public nativeInvestorsIds;
95     mapping (bytes32 => Investor) public investorsList;
96 
97     /*Manipulators*/
98 
99     modifier allowedToManipulate(){
100         require(manipulators[msg.sender] || msg.sender == owner);
101         _;
102     }
103 
104     function changeManipulatorAddress(address saleAddress, bool isAllowedToManipulate) external onlyOwner{
105         require(saleAddress != 0x0);
106         manipulators[saleAddress] = isAllowedToManipulate;
107     }
108 
109     /*Manipulators' end*/
110 
111     function setInvestorId(address investorAddress, bytes32 id) external onlyOwner{
112         require(investorAddress != 0x0 && id != 0);
113         nativeInvestorsIds[investorAddress] = id;
114     }
115 
116     function addInvestor(
117         bytes32 id,
118         WhiteListStatus status,
119         bool isVerified
120     ) external onlyOwner {
121         require(id != 0);
122         require(investorsList[id].id == 0);
123 
124         investorsList[id].id = id;
125         investorsList[id].tokensCount = 0;
126         investorsList[id].whiteListStatus = status;
127         investorsList[id].isVerified = isVerified;
128     }
129 
130     function removeInvestor(bytes32 id) external onlyOwner {
131         require(id != 0 && investorsList[id].id != 0);
132         investorsList[id].id = 0;
133     }
134 
135     function isAllowedToBuyByAddress(address investor) external view returns(bool){
136         require(investor != 0x0);
137         bytes32 id = nativeInvestorsIds[investor];
138         require(id != 0 && investorsList[id].id != 0);
139         return investorsList[id].isVerified;
140     }
141 
142     function isAllowedToBuyByAddressWithoutVerification(address investor) external view returns(bool){
143         require(investor != 0x0);
144         bytes32 id = nativeInvestorsIds[investor];
145         require(id != 0 && investorsList[id].id != 0);
146         return true;
147     }
148 
149     function isAllowedToBuy(bytes32 id) external view returns(bool){
150         require(id != 0 && investorsList[id].id != 0);
151         return investorsList[id].isVerified;
152     }
153 
154     function isPreWhiteListed(bytes32 id) external constant returns(bool){
155         require(id != 0 && investorsList[id].id != 0);
156         return investorsList[id].whiteListStatus == WhiteListStatus.PreWhiteList;
157     }
158 
159     function isWhiteListed(bytes32 id) external view returns(bool){
160         require(id != 0 && investorsList[id].id != 0);
161         return investorsList[id].whiteListStatus == WhiteListStatus.WhiteList;
162     }
163 
164     function setVerificationStatus(bytes32 id, bool status) external onlyOwner{
165         require(id != 0 && investorsList[id].id != 0);
166         investorsList[id].isVerified = status;
167     }
168 
169     function setWhiteListStatus(bytes32 id, WhiteListStatus status) external onlyOwner{
170         require(id != 0 && investorsList[id].id != 0);
171         investorsList[id].whiteListStatus = status;
172     }
173 
174     function addTokens(bytes32 id, uint tokens) external allowedToManipulate{
175         require(id != 0 && investorsList[id].id != 0);
176         investorsList[id].tokensCount = investorsList[id].tokensCount.add(tokens);
177     }
178 
179     function subTokens(bytes32 id, uint tokens) external allowedToManipulate{
180         require(id != 0 && investorsList[id].id != 0);
181         investorsList[id].tokensCount = investorsList[id].tokensCount.sub(tokens);
182     }
183 
184     function setWalletForTokens(bytes32 id, address wallet) external onlyOwner{
185         require(id != 0 && investorsList[id].id != 0);
186         investorsList[id].walletForTokens = wallet;
187     }
188 }