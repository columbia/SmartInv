1 pragma solidity ^0.4.18 ;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     return a / b;
15   }
16 
17   
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Ownable {
32   address public owner;
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44   
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     emit OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 }
51 
52 
53 contract ContractiumInterface {
54     function balanceOf(address who) public view returns (uint256);
55     function contractSpend(address _from, uint256 _value) public returns (bool);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function allowance(address _owner, address _spender) public view returns (uint256);
58 
59     function owner() public view returns (address);
60 
61     function bonusRateOneEth() public view returns (uint256);
62     function currentTotalTokenOffering() public view returns (uint256);
63     function currentTokenOfferingRaised() public view returns (uint256);
64 
65     function isOfferingStarted() public view returns (bool);
66     function offeringEnabled() public view returns (bool);
67     function startTime() public view returns (uint256);
68     function endTime() public view returns (uint256);
69 }
70 
71 
72 contract ContractiumSalePackage is Ownable {
73 
74     using SafeMath for uint256;
75 
76     ContractiumInterface ctuContract;
77     address public constant CONTRACTIUM = 0x943aca8ed65fbf188a7d369cfc2bee0ae435ee1b;
78     address public ownerCtuContract;
79     address public owner;
80 
81     uint8 public constant decimals = 18;
82     uint256 public unitsOneEthCanBuy = 15000;
83     
84     // Current token offering raised in CTUSalePackages
85     uint256 public currentTokenOfferingRaised;
86     
87     // Sale packages and intervals
88     uint256[] public intervals;
89     uint256[] public packages;
90     
91     constructor() public {
92         ctuContract = ContractiumInterface(CONTRACTIUM);
93         ownerCtuContract = ctuContract.owner();
94         owner = msg.sender;
95         
96         intervals = [
97             0,
98             10000000000000000,      // 0.01 Ether
99             100000000000000000,     // 0.1 ether
100             1000000000000000000,    // 01 Ether
101             3000000000000000000,    // 03 Ether
102             5000000000000000000,    // 05 Ether
103             10000000000000000000    // 10 Ether
104         ];
105         
106         packages = [
107             0,
108             750,   // 5% 
109             1500,  // 10% 
110             3000,  // 20%
111             4500,  // 30%
112             6000,  // 40%
113             7500   // 50%
114         ];
115     }
116 
117     function() public payable {
118 
119         require(msg.sender != owner);
120 
121         // Number of tokens to sale in wei
122         uint256 amount = msg.value.mul(unitsOneEthCanBuy);
123         
124         // Bonus rate
125         uint256 bonusRate = getNearestPackage(msg.value);
126         
127         // Amount of bonus tokens
128         uint256 amountBonus = msg.value.mul(bonusRate);
129         
130         // Amount with bonus value
131         amount = amount.add(amountBonus);
132 
133         // Offering validation
134         uint256 remain = ctuContract.balanceOf(ownerCtuContract);
135         require(remain >= amount);
136         preValidatePurchase(amount);
137 
138         address _from = ownerCtuContract;
139         address _to = msg.sender;
140         require(ctuContract.transferFrom(_from, _to, amount));
141         ownerCtuContract.transfer(msg.value);  
142 
143         currentTokenOfferingRaised = currentTokenOfferingRaised.add(amount);  
144     }
145     
146     /**
147     * @dev Get package bonus.
148     */
149     function getNearestPackage(uint256 _amount) view internal returns (uint256) {
150         require(_amount > 0);
151         uint indexPackage = 0;
152         for (uint i = intervals.length - 1; i >= 0 ; i--){
153             if (intervals[i] <= _amount) {
154                 indexPackage = i;
155                 break;
156             }
157         }
158         return packages[indexPackage];
159     }
160     
161     /**
162     * @dev Validate before purchasing.
163     */
164     function preValidatePurchase(uint256 _amount) view internal {
165         require(_amount > 0);
166         require(ctuContract.isOfferingStarted());
167         require(ctuContract.offeringEnabled());
168         require(currentTokenOfferingRaised.add(ctuContract.currentTokenOfferingRaised().add(_amount)) <= ctuContract.currentTotalTokenOffering());
169         require(block.timestamp >= ctuContract.startTime() && block.timestamp <= ctuContract.endTime());
170     }
171     
172     /**
173     * @dev Set Contractium address and related parameter from Contractium Smartcontract.
174     */
175     function setCtuContract(address _ctuAddress) public onlyOwner {
176         require(_ctuAddress != address(0x0));
177         ctuContract = ContractiumInterface(_ctuAddress);
178         ownerCtuContract = ctuContract.owner();
179     }
180 
181     /**
182     * @dev Reset current token offering raised for new Sale.
183     */
184     function resetCurrentTokenOfferingRaised() public onlyOwner {
185         currentTokenOfferingRaised = 0;
186     }
187     
188     /**
189     * @dev Clear package bonus.
190     */
191     function clearPackages() public onlyOwner returns (bool) {
192         intervals = [0];
193         packages = [0];
194         return true;
195     }
196     
197     /**
198     * @dev Set package bonus.
199     */
200     function setPackages(uint256[] _interval, uint256[] _packages) public checkPackages(_interval, _packages) returns (bool) {
201         intervals = _interval;
202         packages = _packages;
203         return true;
204     }
205     
206     /**
207     *  Check packages and intervals is valid or not
208     */
209     modifier checkPackages(uint256[] _interval, uint256[] _packages) {
210         require(_interval.length == _packages.length);
211         bool validIntervalArr = true;
212         for (uint i = 0; i < intervals.length - 1 ; i++){
213             if (intervals[i] >= intervals[i + 1]) {
214                 validIntervalArr = false;
215                 break;
216             }
217         }
218         require(validIntervalArr);
219         _;
220     }
221 }