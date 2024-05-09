1 pragma solidity ^0.4.25;
2 
3 contract EthMonsters {
4 
5 	address public owner;
6 
7 
8     event BuyMonsterEvent(
9         uint price
10     );
11 
12 	uint public typesNumber = 0;
13 	uint public monstersNumber = 0;
14 	mapping (address => uint) public userMonstersCount;
15 	mapping (address => uint) goodContracts; 
16     monster[] public monsters;
17    	mapping (uint => address) public monsterToOwner;
18    	mapping (address => uint) public userBalance;
19    	mapping (address => uint[]) public userToMonsters;
20    	uint public contractFees = 0;
21 	
22 	monsterType[] public types;
23 
24 	constructor() public {
25       	owner = msg.sender;
26    	}
27     
28 	modifier onlyOwner { 
29     	require(msg.sender == owner);
30     	_;
31   	}
32   	
33   	modifier allowedContract { 
34   	    address contractAddress = msg.sender;
35   		require(goodContracts[contractAddress] == 1);
36   		_;
37   	}
38 
39   	struct monsterType {
40   		string name;
41   		uint currentPrice;
42   		uint basePrice;
43   		uint sales;
44   		uint id;
45   		uint maxPower;
46    	}
47    	
48    	struct monster {
49   		string name;
50   		uint purchasePrice;
51   		uint earnings;
52   		uint monsterType;
53   		uint id;
54   		uint power;
55   		uint exp;
56   		uint eggs;
57   		uint gen;
58   		address creator;
59   		address owner;
60   		uint isEgg;
61    	}
62 
63     function random(uint min, uint max) private view returns (uint) {
64         return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%(max-min+1))+min;
65     }
66     
67     function addGoodContract(address _con) public onlyOwner { //add address of a contract to be whitelisted
68 		goodContracts[_con] = 1;
69 	}
70 
71 	function removeGoodContract(address _con) public onlyOwner { //remove address of a contract from whitelist
72 		goodContracts[_con] = 0;
73 	}
74 	
75 	function addExpToMonster(uint _id, uint amount) public allowedContract {
76 	    monsters[_id].exp += amount;
77 	}
78 	
79 	function transferMonster(uint _id, address newOwner) public allowedContract {
80 	    address oldOwner = monsterToOwner[_id];
81 	    uint[] memory oldUserMonsters = userToMonsters[oldOwner];
82 	    for(uint i=0; i<userMonstersCount[oldOwner]; i++) {
83 	        if(oldUserMonsters[i] == _id) {
84 	            oldUserMonsters[i] = oldUserMonsters[oldUserMonsters.length-1];
85 	            delete oldUserMonsters[oldUserMonsters.length-1];
86 	            userToMonsters[oldOwner] = oldUserMonsters;
87 	            userToMonsters[oldOwner].length--;
88 	            userToMonsters[newOwner].push(_id);
89 	            break;
90 	        }
91 	    }
92 	    userMonstersCount[oldOwner]--;
93 	    userMonstersCount[newOwner]++;
94 	    monsters[_id].owner = newOwner;
95 	    monsterToOwner[_id] = newOwner;
96 	}
97 	
98 	function hatchEgg(uint _id, uint _newPower) public allowedContract {
99 	    require(monsters[_id].isEgg == 1);
100 	    monsters[_id].isEgg = 0;
101 	    monsters[_id].power = _newPower;
102 	}
103 	
104 	function changeMonsterName(string _newName, uint _id) public allowedContract {
105 	    monsters[_id].name = _newName;
106 	}
107 
108 	
109     function buyMonster(string _name, uint _type) public payable { //starts with 0; public function to buy a monsters 
110 		require(_type < typesNumber);
111 		require(_type >= 0);
112 		if(msg.value < types[_type].currentPrice) { //if sent amount < the monster's price, the amount is added to the address's balance
113 			userBalance[msg.sender] += msg.value;
114 			emit BuyMonsterEvent(0);
115 		} else { //if the sent amount >= the kind's price, 
116 			userBalance[msg.sender] += (msg.value - types[_type].currentPrice);
117 			sendEarnings(_type);
118 			uint numberOfEggs = random(1, 3);
119 			for(uint _i=0; _i<numberOfEggs; _i++)
120 			    createMonster(_name, _type, 1, msg.sender, 100, 0, 1);
121 			createMonster(_name, _type, 0, msg.sender, types[_type].maxPower, types[_type].currentPrice, 0);
122 			emit BuyMonsterEvent(types[_type].currentPrice);
123 			types[_type].currentPrice += types[_type].basePrice;
124 		}
125 		types[_type].sales++;
126 	}
127 	
128 	function sendEarnings(uint _type) private { 
129 		require(_type < typesNumber);
130 		require(_type >= 0);
131 		contractFees += types[_type].basePrice;
132 		for(uint _id=0; _id<monsters.length; _id++)
133  			if(monsters[_id].monsterType == _type && monsters[_id].gen == 0) {
134  				userBalance[monsterToOwner[_id]] += types[_type].basePrice;
135  				monsters[_id].earnings += types[_type].basePrice;
136  			}
137 	}
138 	
139 	function withdrawFees() public onlyOwner payable {
140 	    require(contractFees > 0);
141 	    uint amount = contractFees;
142 	    contractFees = 0;
143 	    msg.sender.transfer(amount);
144 	}
145 	
146 	function withdraw() public payable{
147 	    require(userBalance[msg.sender] > 0);
148 	    uint amount = userBalance[msg.sender];
149 	    userBalance[msg.sender] = 0;
150 	    msg.sender.transfer(amount);
151 	}
152 	
153     function createMonster(string _name, uint _type, uint _gen, address _owner, uint _power, uint _purchasePrice, uint _isEgg) private { 
154 		monsters.push(monster(_name, _purchasePrice, 0, _type, monstersNumber, _power, 0, 0 ,_gen ,_owner, _owner, _isEgg));
155 		monsterToOwner[monstersNumber] = _owner;
156 		userToMonsters[_owner].push(monstersNumber);
157 		monstersNumber++;
158 		userMonstersCount[_owner]++;
159 	}
160 	
161 	function getUserMonstersCount(address _address) public view returns(uint) {
162 	    return userMonstersCount[_address];
163 	}
164 	
165 	function getUserMonster(uint id, address _owner) public view returns (string, uint, uint, uint, uint, uint, uint, address, address) {
166 	    monster memory mon = monsters[userToMonsters[_owner][id]];
167 		return (mon.name, mon.purchasePrice, mon.earnings, mon.gen, mon.monsterType, mon.power, mon.isEgg, mon.creator, mon.owner);
168 	}
169 	
170 	function getMonster(uint id) public view returns (string, uint, uint, uint, uint, uint, uint, address, address) {
171 	    monster memory mon = monsters[id];
172 		return (mon.name, mon.purchasePrice, mon.earnings, mon.gen, mon.monsterType, mon.power, mon.isEgg, mon.creator, mon.owner);
173 	} 
174 	
175    	function addNewType(string _name, uint _basePrice, uint _maxPower) public onlyOwner { //add new kind
176 		require(_maxPower > 0);
177 		types.push(monsterType(_name, _basePrice, _basePrice, 0, typesNumber, _maxPower));
178 		typesNumber++;
179 	}
180 
181 	function getType(uint id) public view returns (string, uint, uint, uint, uint, uint) {
182 		return (types[id].name, types[id].currentPrice, types[id].basePrice, types[id].sales, types[id].id, types[id].maxPower);
183 	} 
184 }