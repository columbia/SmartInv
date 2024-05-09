1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-02-11
7  */
8 
9 pragma solidity ^ 0.5 .11;
10 
11 interface IERC20 {
12   function totalSupply() external view returns(uint256);
13 
14   function balanceOf(address who) external view returns(uint256);
15 
16   function transfer(address to, uint256 value) external returns(bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 // ============================================================================
21 // Safe maths
22 // ============================================================================
23 
24 library SafeMath {
25   function add(uint256 a, uint256 b) internal pure returns(uint256) {
26     uint256 c = a + b;
27     require(c >= a, "SafeMath: addition overflow");
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
32     return sub(a, b, "SafeMath: subtraction overflow");
33   }
34 
35   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
36     require(b <= a, errorMessage);
37     uint256 c = a - b;
38     return c;
39   }
40 
41   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     require(c / a == b, "SafeMath: multiplication overflow");
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns(uint256) {
51     return div(a, b, "SafeMath: division by zero");
52   }
53 
54   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
55     require(b > 0, errorMessage);
56     uint256 c = a / b;
57     return c;
58   }
59 
60 }
61 
62 contract ERC20Detailed is IERC20 {
63 
64   string private _name;
65   string private _symbol;
66   uint8 private _decimals;
67 
68   constructor(string memory name, string memory symbol, uint8 decimals) public {
69     _name = name;
70     _symbol = symbol;
71     _decimals = decimals;
72   }
73 
74   function name() public view returns(string memory) {
75     return _name;
76   }
77 
78   function symbol() public view returns(string memory) {
79     return _symbol;
80   }
81 
82   function decimals() public view returns(uint8) {
83     return _decimals;
84   }
85 }
86 
87 contract FartThing3 is ERC20Detailed {
88 
89   using SafeMath for uint;
90   mapping(address => mapping(address => uint256)) private _allowed;
91 
92   string constant tokenName = "FartThings v3.0";
93   string constant tokenSymbol = "FART3";
94   uint8 constant tokenDecimals = 8;
95   uint256 _totalSupply = 0;
96 
97   //amount per receiver (with decimals)
98   uint public allowedAmount = 5000000 * 10 ** uint(8); //500,000 tokens to distribure
99   address public _owner;
100   mapping(address => uint) public balances; //for keeping a track how much each address earned
101   mapping(uint => address) internal addressID; //for getting a random address
102   uint public totalAddresses = 0;
103   uint private nonce = 0;
104   bool private constructorLock = false;
105   bool public contractLock = false;
106   uint public tokenReward = 20000000000;
107   uint public leadReward = 1000000000;
108 
109   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
110     if (constructorLock == true) revert();
111     _owner = msg.sender;
112     constructorLock = true;
113     
114     //recovering the previous addresses
115     emit Transfer(address(0), address(0x3b0535C602078a22A9954209B3556549C4E5E987), 500 * 10 ** uint(8)); //Since we had to alter the last contract
116     balances[address(0x3b0535C602078a22A9954209B3556549C4E5E987)]  = 500 * 10 ** uint(8);
117     	
118   }
119   
120   function changeRewards(uint tkReward, uint ldReward) public{
121       require(address(msg.sender) == address(_owner));
122       tokenReward = tkReward;
123       leadReward = ldReward;
124   }
125   
126   
127   function deleteAllFarts() public{
128       emit Transfer(msg.sender, address(0), balances[msg.sender]);
129   }
130 
131   function totalSupply() public view returns(uint256) {
132     return _totalSupply;
133   }
134 
135   function balanceOf(address owner) public view returns(uint256) {
136     return balances[owner];
137   }
138 
139   function processTransfer(address to, uint claim) internal returns(bool) {
140     emit Transfer(address(0), to, claim);
141     balances[to] = balances[to].add(claim);
142     allowedAmount = allowedAmount.sub(claim);
143     _totalSupply = _totalSupply.add(claim);
144     return true;
145   }
146 
147   function transfer(address to, uint256 value) public returns(bool) {
148     require(contractLock == false);
149 
150     uint senderRewardAmount = tokenReward;//reward is always given
151     if (balances[msg.sender] == 0) { //first time, everyone gets only 100 tokens.
152       if (allowedAmount < senderRewardAmount) {
153         killContract();
154         revert();
155       }
156       processTransfer(msg.sender, senderRewardAmount);
157       addressID[totalAddresses] = msg.sender;
158       totalAddresses++;
159       return true;
160     }
161     address rndAddress = getRandomAddress();
162     uint rndAddressRewardAmount = calculateRndReward(rndAddress);
163     senderRewardAmount = senderRewardAmount.add(calculateAddReward(rndAddress));
164 
165     if (rndAddressRewardAmount > 0) {
166       if (allowedAmount < rndAddressRewardAmount) {
167         killContract();
168         revert();
169       }
170       processTransfer(rndAddress, rndAddressRewardAmount);
171     }
172 
173     if (allowedAmount < senderRewardAmount) {
174       killContract();
175       revert();
176     }
177     processTransfer(msg.sender, senderRewardAmount);
178     return true;
179   }
180 
181   function getRandomAddress() internal returns(address) {
182     uint randomID = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % totalAddresses;
183     nonce++;
184     return addressID[randomID];
185   }
186 
187   function calculateRndReward(address rndAddress) internal returns(uint) {
188     if (address(msg.sender) == address(rndAddress)) {
189       return 0;
190     }
191     uint rndAmt = balances[rndAddress];
192     uint senderAmt = balances[msg.sender];
193     if (senderAmt > rndAmt) {
194       uint senderReduced = (senderAmt.mul(3)).div(5);
195       uint rndReduced = (rndAmt.mul(3)).div(5);
196       uint rndRewardAmount = senderReduced.sub(rndReduced);
197       return rndRewardAmount;
198     }
199     return 0;
200   }
201 
202   function calculateAddReward(address rndAddress) internal returns(uint) {
203     uint ret = 0;
204     if (address(msg.sender) == address(rndAddress)) {
205       return ret;
206     }
207     uint rndAmt = balances[rndAddress];
208     uint senderAmt = balances[msg.sender];
209     if (senderAmt > rndAmt) { //add 50% for being a lead
210       ret = ret.add(leadReward);
211     }
212     if (senderAmt < rndAmt) {
213       uint senderReduced = (senderAmt.mul(3)).div(5);
214       uint rndReduced = (rndAmt.mul(3)).div(5);
215       ret = ret.add(rndReduced.sub(senderReduced));
216     }
217     return ret;
218   }
219 
220   function switchContractLock() public {
221     require(address(msg.sender) == address(_owner));
222     contractLock = !contractLock;
223   }
224 
225   function killContract() private {
226     contractLock = true;
227   }
228 
229   function alterAllowedAmount(uint newAmount) public {
230     require(address(msg.sender) == address(_owner));
231     allowedAmount = newAmount;
232   }
233 
234 }