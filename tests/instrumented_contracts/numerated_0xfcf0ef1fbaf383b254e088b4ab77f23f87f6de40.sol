1 pragma solidity ^0.4.22;
2 
3 //standard library for uint
4 library SafeMath { 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0 || b == 0){
7         return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 
25   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
26     if (b == 0){
27       return 1;
28     }
29     uint256 c = a**b;
30     assert (c >= a);
31     return c;
32   }
33 }
34 
35 //standard contract to identify owner
36 contract Ownable {
37 
38   address public owner;
39 
40   address public newOwner;
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46   
47   function transferOwnership(address _newOwner) public onlyOwner {
48     require(_newOwner != address(0));
49     newOwner = _newOwner;
50   }
51 
52   function acceptOwnership() public {
53     if (msg.sender == newOwner) {
54       owner = newOwner;
55     }
56   }
57 }
58 //Abstract Token contract
59 contract SHAREToken{
60   function setCrowdsaleContract (address) public;
61   function sendCrowdsaleTokens(address, uint256)  public;
62 }
63 
64 //Crowdsale contract
65 contract ShareCrowdsale is Ownable{
66 
67   using SafeMath for uint;
68 
69   uint decimals = 6;
70 
71   // Token contract address
72   SHAREToken public token;
73 
74   address public distributionAddress;
75 
76   constructor (address _tokenAddress) public {
77     token = SHAREToken(_tokenAddress);
78     owner = 0x4fD26ff0Af100C017BEA88Bd6007FcB68C237960;
79 
80     distributionAddress = 0xdF4F78fb8B8201ea3c42A1D91A05c97071B59BF2;
81 
82     setupStages();
83 
84     token.setCrowdsaleContract(this);    
85   }
86 
87   uint public constant ICO_START = 1526860800; //21st May 2018
88   uint public constant ICO_FINISH = 1576713600; //19th December 2019
89 
90   uint public constant ICO_MIN_CAP = 1 ether;
91 
92   uint public tokensSold;
93   uint public ethCollected;
94 
95   uint public constant MIN_DEPOSIT = 0.01 ether;
96 
97   struct Stage {
98     uint tokensPrice;
99     uint tokensDistribution;
100     uint discount;
101     bool isActive;
102   }
103   
104   Stage[] public icoStages;
105 
106   function setupStages () internal {
107     icoStages.push(Stage(1650,2500000 * ((uint)(10) ** (uint)(decimals)), 10000, true));
108     icoStages.push(Stage(1650,5000000 * ((uint)(10) ** (uint)(decimals)), 5000, true));
109     icoStages.push(Stage(1650,8000000 * ((uint)(10) ** (uint)(decimals)), 3500, true));
110     icoStages.push(Stage(1650,10000000 * ((uint)(10) ** (uint)(decimals)), 2500, true));
111     icoStages.push(Stage(1650,15000000 * ((uint)(10) ** (uint)(decimals)), 1800, true));
112     icoStages.push(Stage(1650,15000000 * ((uint)(10) ** (uint)(decimals)), 1200, true));
113     icoStages.push(Stage(1650,15000000 * ((uint)(10) ** (uint)(decimals)), 600, true));
114     icoStages.push(Stage(1650,49500000 * ((uint)(10) ** (uint)(decimals)), 0, true)); 
115   }
116 
117   function stopIcoPhase (uint _phase) external onlyOwner {
118     icoStages[_phase].isActive = false;
119   }
120 
121   function startIcoPhase (uint _phase) external onlyOwner {
122     icoStages[_phase].isActive = true;
123   }
124   
125   function changeIcoStageTokenPrice (uint _phase, uint _tokenPrice) external onlyOwner {
126     icoStages[_phase].tokensPrice = _tokenPrice;
127   }
128   
129   function () public payable {
130     require (isIco());
131     require (msg.value >= MIN_DEPOSIT);
132     require (buy(msg.sender, msg.value));
133   }
134 
135   function buy (address _address, uint _value) internal returns(bool) {
136     uint currentStage = getCurrentStage();
137     if (currentStage == 100){
138       return false;
139     }
140 
141     uint _phasePrice = icoStages[currentStage].tokensPrice;
142     uint _tokenPrice = _phasePrice.add(_phasePrice.mul(icoStages[currentStage].discount)/10000);
143     uint tokensToSend = _value.mul(_tokenPrice)/(uint(10).pow(uint(12))); //decimals difference
144 
145     if(ethCollected >= ICO_MIN_CAP){
146       distributionAddress.transfer(address(this).balance);
147     }
148 
149     token.sendCrowdsaleTokens(_address,tokensToSend);
150     
151     tokensSold = tokensSold.add(tokensToSend);
152     ethCollected += _value;
153     
154     return true;
155   }
156 
157   function getCurrentStage () public view returns(uint) {
158     uint buffer;
159 
160     if(isIco()){
161       for (uint i = 0; i < icoStages.length; i++){
162         buffer += icoStages[i].tokensDistribution;
163         if(tokensSold <= buffer && icoStages[i].isActive){
164           return i;
165         }
166       }
167     }
168     return 100; //something went wrong
169   }
170 
171   function isIco() public view returns(bool) {
172     if(ICO_START <= now && now <= ICO_FINISH){
173       return true;
174     }
175     return false;
176   }
177 
178   function sendCrowdsaleTokensManually (address _address, uint _value) external onlyOwner {
179     token.sendCrowdsaleTokens(_address,_value);
180     tokensSold = tokensSold.add(_value);
181   }
182 
183   //if something went wrong
184   function sendEtherManually () public onlyOwner {
185     distributionAddress.transfer(address(this).balance);
186   }
187 }