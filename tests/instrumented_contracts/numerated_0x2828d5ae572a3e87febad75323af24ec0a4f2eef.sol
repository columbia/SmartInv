1 pragma solidity ^0.4.18;
2 
3 /*
4 Game Name: CryptoPlanets
5 Game Link: https://cryptoplanets.com/
6 Rules: 
7 - Acquire planets
8 - Steal resources (ETH) from other planets
9 */
10 
11 contract CryptoPlanets {
12 
13     address ceoAddress = 0x8e6DBF31540d2299a674b8240596ae85ebD21314;
14     
15     modifier onlyCeo() {
16         require (msg.sender == ceoAddress);
17         _;
18     }
19     
20     struct Planet {
21         string name;
22         address ownerAddress;
23         uint256 curPrice;
24         uint256 curResources;
25     }
26     Planet[] planets;
27 
28 
29     // How many shares an addres own
30     mapping (address => uint) public addressPlanetsCount;
31     mapping (address => uint) public addressAttackCount;
32     mapping (address => uint) public addressDefenseCount;
33     
34 
35     uint256 attackCost = 10000000000000000;
36     uint256 defenseCost = 10000000000000000;
37     
38     uint randNonce = 0;
39     bool planetsAreInitiated;
40 
41     /*
42     This function allows players to purchase planets from other players. 
43     The price of the planets is automatically multiplied by 1.5 after each purchase.
44     */
45     function purchasePlanet(uint _planetId) public payable {
46         require(msg.value == planets[_planetId].curPrice);
47 
48         // Calculate the 5% value
49         uint256 commission5percent = ((msg.value / 10)/2);
50 
51         // Calculate the owner commission on this sale & transfer the commission to the owner.      
52         uint256 commissionOwner = msg.value - (commission5percent * 2); // => 95%
53         planets[_planetId].ownerAddress.transfer(commissionOwner);
54 
55         // Reduce number of planets for previous owner
56         addressPlanetsCount[planets[_planetId].ownerAddress] = addressPlanetsCount[planets[_planetId].ownerAddress] - 1;
57 
58         // Keep 5% in the resources of the planet
59         planets[_planetId].curResources =  planets[_planetId].curResources + commission5percent;
60 
61         // Transfer the 5% commission to the developer
62         ceoAddress.transfer(commission5percent);                  
63 
64         // Update the planet owner and set the new price
65         planets[_planetId].ownerAddress = msg.sender;
66         planets[_planetId].curPrice = planets[_planetId].curPrice + (planets[_planetId].curPrice / 2);
67 
68         // Increment number of planets for new owner
69         addressPlanetsCount[msg.sender] = addressPlanetsCount[msg.sender] + 1;
70     }
71 
72     //User is purchasing attack
73     function purchaseAttack() payable {
74 
75         // Verify that user is paying the correct price
76         require(msg.value == attackCost);
77         
78         // We transfer the amount paid to the owner
79         ceoAddress.transfer(msg.value);
80 
81         addressAttackCount[msg.sender]++;
82     }
83 
84     //User is purchasing defense
85     function purchaseDefense() payable {
86         // Verify that user is paying the correct price
87         require(msg.value == defenseCost);
88         
89         // We transfer the amount paid to the owner
90         ceoAddress.transfer(msg.value);
91         
92         addressDefenseCount[msg.sender]++;
93     }
94 
95     function StealResources(uint _planetId) {
96         // Verify that the address actually own a planet
97         require(addressPlanetsCount[msg.sender] > 0);
98 
99         // We verify that this address doesn't own this planet
100         require(planets[_planetId].ownerAddress != msg.sender);
101 
102         // We verify that this planet has resources
103         require(planets[_planetId].curResources > 0);
104 
105         // Transfer a random amount of resources (between 1% and 90%) of the resources of the planet to the stealer if it's attack is better than the planet's owner defense
106         if(addressAttackCount[msg.sender] > addressDefenseCount[planets[_planetId].ownerAddress]) {
107             // Generate a random number between 1 and 49
108             uint random = uint(keccak256(now, msg.sender, randNonce)) % 49;
109             randNonce++;
110             
111             // Calculate and transfer the random amount of resources to the stealer
112             uint256 resourcesStealable = (planets[_planetId].curResources * (50 + random)) / 100;
113             msg.sender.transfer(resourcesStealable);
114             
115             // Save the new resources count
116             planets[_planetId].curResources = planets[_planetId].curResources - resourcesStealable;
117         }
118 
119     }
120     
121     // This function will return the details for the connected user (planets count, attack count, defense count)
122     function getUserDetails(address _user) public view returns(uint, uint, uint) {
123         return(addressPlanetsCount[_user], addressAttackCount[_user], addressDefenseCount[_user]);
124     }
125     
126     // This function will return the details of a planet
127     function getPlanet(uint _planetId) public view returns (
128         string name,
129         address ownerAddress,
130         uint256 curPrice,
131         uint256 curResources,
132         uint ownerAttack,
133         uint ownerDefense
134     ) {
135         Planet storage _planet = planets[_planetId];
136 
137         name = _planet.name;
138         ownerAddress = _planet.ownerAddress;
139         curPrice = _planet.curPrice;
140         curResources = _planet.curResources;
141         ownerAttack = addressAttackCount[_planet.ownerAddress];
142         ownerDefense = addressDefenseCount[_planet.ownerAddress];
143     }
144     
145     
146     // The dev can use this function to create new planets.
147     function createPlanet(string _planetName, uint256 _planetPrice) public onlyCeo {
148         uint planetId = planets.push(Planet(_planetName, ceoAddress, _planetPrice, 0)) - 1;
149     }
150     
151     // Initiate functions that will create the planets
152     function InitiatePlanets() public onlyCeo {
153         require(planetsAreInitiated == false);
154         createPlanet("Blue Lagoon", 100000000000000000); 
155         createPlanet("GreenPeace", 100000000000000000); 
156         createPlanet("Medusa", 100000000000000000); 
157         createPlanet("O'Ranger", 100000000000000000); 
158         createPlanet("Queen", 90000000000000000); 
159         createPlanet("Citrus", 90000000000000000); 
160         createPlanet("O'Ranger II", 90000000000000000); 
161         createPlanet("Craterion", 50000000000000000);
162         createPlanet("Dark'Air", 50000000000000000);
163 
164     }
165 }