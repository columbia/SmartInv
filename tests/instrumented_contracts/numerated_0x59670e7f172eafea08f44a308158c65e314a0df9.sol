1 pragma solidity ^0.4.23;
2 
3 contract PumpAndDump {
4 
5   address owner;
6   uint newCoinFee = 0.005 ether;
7   uint newCoinFeeIncrease = 0.001 ether;
8   uint defaultCoinPrice = 0.001 ether;
9   uint coinPriceIncrease = 0.0001 ether;
10   uint devFees = 0;
11   uint16[] coinIds;
12 
13   struct Coin {
14     bool exists;
15     string name;
16     uint price;
17     uint marketValue;
18     address[] investors;
19   }
20 
21   mapping (uint16 => Coin) coins;
22 
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   function kill() external {
28     require(msg.sender == owner);
29     selfdestruct(owner);
30   }
31 
32   function getNewCoinFee() public constant returns (uint) {
33     return newCoinFee;
34   }
35 
36   function isCoinIdUnique(uint16 newId) private constant returns (bool) {
37     for (uint i = 0; i < coinIds.length; i++) {
38       if (coinIds[i] == newId) {
39         return false;
40       }
41     }
42     return true;
43   }
44 
45 
46   function createCoin(uint16 id, string name) public payable {
47     require(msg.value >= newCoinFee);
48     require(id < 17576); // 26*26*26
49     require(bytes(name).length > 0);
50     require(isCoinIdUnique(id));
51     devFees += msg.value - defaultCoinPrice;
52     coins[id].exists = true;
53     coins[id].name = name;
54     coins[id].price = defaultCoinPrice;
55     coins[id].marketValue = defaultCoinPrice;
56     coins[id].investors.push(msg.sender);
57     coinIds.push(id);
58     newCoinFee += newCoinFeeIncrease;
59   }
60 
61   function getCoinIds() public view returns (uint16[]) {
62     return coinIds;
63   }
64 
65   function getCoinInfoFromId(uint16 coinId) public view returns (string, uint, uint, address[]) {
66     return (
67       coins[coinId].name,
68       coins[coinId].price,
69       coins[coinId].marketValue,
70       coins[coinId].investors
71     );
72   }
73 
74   function getUserCoinMarketValue(uint16 coinId, uint userIndex) private view returns (uint) {
75       uint numInvestors = coins[coinId].investors.length;
76       // If this is the most recent investor
77       if (numInvestors == userIndex + 1) {
78         return coins[coinId].price;
79       } else {
80         uint numShares = (numInvestors * (numInvestors + 1)) / 2;
81         return ((numInvestors - userIndex) * coins[coinId].marketValue) / numShares;
82       }
83   }
84 
85   function isSenderInvestor(address sender, address[] investors) private pure returns (bool) {
86     for (uint i = 0; i < investors.length; i++) {
87       if (investors[i] == sender) {
88         return true;
89       }
90     }
91     return false;
92   }
93 
94   function buyCoin(uint16 coinId) public payable {
95     require(msg.value >= coins[coinId].price);
96     require(coins[coinId].exists);
97     require(!isSenderInvestor(msg.sender, coins[coinId].investors));
98     coins[coinId].investors.push(msg.sender);
99     uint amount = (msg.value * 99) / 100;
100     devFees += msg.value - amount;
101     coins[coinId].marketValue += amount;
102     coins[coinId].price += coinPriceIncrease;
103   }
104 
105   function payAndRemoveInvestor(uint16 coinId, uint investorIndex) private {
106     uint value = getUserCoinMarketValue(coinId, investorIndex);
107     coins[coinId].investors[investorIndex].transfer(value);
108     coins[coinId].price -= coinPriceIncrease;
109     coins[coinId].marketValue -= value;
110     if (coins[coinId].investors.length == 1) {
111       delete coins[coinId].investors[0];
112     } else {
113       uint secondLastIndex = coins[coinId].investors.length - 1;
114       for (uint j = investorIndex; j < secondLastIndex; j++) {
115         coins[coinId].investors[j] = coins[coinId].investors[j - 1];
116       }
117     }
118     coins[coinId].investors.length -= 1;
119   }
120 
121   function sellCoin(uint16 coinId) public {
122     bool senderIsInvestor = false;
123     uint investorIndex = 0;
124     require(coins[coinId].exists);
125     for (uint i = 0; i < coins[coinId].investors.length; i++) {
126       if (coins[coinId].investors[i] == msg.sender) {
127         senderIsInvestor = true;
128         investorIndex = i;
129         break;
130       }
131     }
132     require(senderIsInvestor);
133     payAndRemoveInvestor(coinId, investorIndex);
134   }
135 
136   function getDevFees() public view returns (uint) {
137     require(msg.sender == owner);
138     return devFees;
139   }
140 
141   function collectDevFees() public {
142     require(msg.sender == owner);
143     owner.transfer(devFees);
144     devFees = 0;
145   }
146 
147   function() public payable {}
148 
149 }