1 pragma solidity ^0.4.19;
2 
3 /*
4 Game: CryptoPokemon
5 Domain: CryptoPokemon.com
6 Dev: CryptoPokemon Team
7 */
8 
9 library SafeMath {
10 
11 /**
12 * @dev Multiplies two numbers, throws on overflow.
13 */
14 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15 if (a == 0) {
16 return 0;
17 }
18 uint256 c = a * b;
19 assert(c / a == b);
20 return c;
21 }
22 
23 /**
24 * @dev Integer division of two numbers, truncating the quotient.
25 */
26 function div(uint256 a, uint256 b) internal pure returns (uint256) {
27 // assert(b > 0); // Solidity automatically throws when dividing by 0
28 uint256 c = a / b;
29 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 return c;
31 }
32 
33 /**
34 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35 */
36 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37 assert(b <= a);
38 return a - b;
39 }
40 
41 /**
42 * @dev Adds two numbers, throws on overflow.
43 */
44 function add(uint256 a, uint256 b) internal pure returns (uint256) {
45 uint256 c = a + b;
46 assert(c >= a);
47 return c;
48 }
49 }
50 
51 contract CryptoPokemon {
52 using SafeMath for uint256;
53 mapping (address => bool) private admins;
54 mapping (uint => uint256) public levels;
55 mapping (uint => bool) private lock;
56 address contractCreator;
57 address devFeeAddress;
58 address tournamentPrizeAddress;
59 
60 function CryptoPokemon () public {
61 
62 contractCreator = msg.sender;
63 devFeeAddress = 0xFb2D26b0caa4C331bd0e101460ec9dbE0A4783A4;
64 tournamentPrizeAddress = 0xC6784e712229087fC91E0c77fcCb6b2F1fDE2Dc2;
65 admins[contractCreator] = true;
66 }
67 
68 struct Pokemon {
69 string pokemonName;
70 address ownerAddress;
71 uint256 currentPrice;
72 }
73 Pokemon[] pokemons;
74 
75 //modifiers
76 modifier onlyContractCreator() {
77 require (msg.sender == contractCreator);
78 _;
79 }
80 modifier onlyAdmins() {
81 require(admins[msg.sender]);
82 _;
83 }
84 
85 //Owners and admins
86 
87 /* Owner */
88 function setOwner (address _owner) onlyContractCreator() public {
89 contractCreator = _owner;
90 }
91 
92 function addAdmin (address _admin) onlyContractCreator() public {
93 admins[_admin] = true;
94 }
95 
96 function removeAdmin (address _admin) onlyContractCreator() public {
97 delete admins[_admin];
98 }
99 
100 // Adresses
101 function setdevFeeAddress (address _devFeeAddress) onlyContractCreator() public {
102 devFeeAddress = _devFeeAddress;
103 }
104 
105 function settournamentPrizeAddress (address _tournamentPrizeAddress) onlyContractCreator() public {
106 tournamentPrizeAddress = _tournamentPrizeAddress;
107 }
108 
109 
110 bool isPaused;
111 /*
112 When countdowns and events happening, use the checker.
113 */
114 function pauseGame() public onlyContractCreator {
115 isPaused = true;
116 }
117 function unPauseGame() public onlyContractCreator {
118 isPaused = false;
119 }
120 function GetGamestatus() public view returns(bool) {
121 return(isPaused);
122 }
123 
124 function addLock (uint _pokemonId) onlyContractCreator() public {
125 lock[_pokemonId] = true;
126 }
127 
128 function removeLock (uint _pokemonId) onlyContractCreator() public {
129 lock[_pokemonId] = false;
130 }
131 
132 function getPokemonLock(uint _pokemonId) public view returns(bool) {
133 return(lock[_pokemonId]);
134 }
135 
136 /*
137 This function allows users to purchase PokeMon.
138 The price is automatically multiplied by 1.5 after each purchase.
139 Users can purchase multiple PokeMon.
140 */
141 function purchasePokemon(uint _pokemonId) public payable {
142 
143 // Check new price >= currentPrice & gameStatus
144 require(msg.value >= pokemons[_pokemonId].currentPrice);
145 require(pokemons[_pokemonId].ownerAddress != address(0));
146 require(pokemons[_pokemonId].ownerAddress != msg.sender);
147 require(lock[_pokemonId] == false);
148 require(msg.sender != address(0));
149 require(isPaused == false);
150 
151 // Calculate the excess
152 address newOwner = msg.sender;
153 uint256 price = pokemons[_pokemonId].currentPrice;
154 uint256 excess = msg.value.sub(price);
155 uint256 realValue = pokemons[_pokemonId].currentPrice;
156 
157 // If excess>0 send back the amount
158 if (excess > 0) {
159 newOwner.transfer(excess);
160 }
161 
162 // Calculate the 10% value as tournment prize and dev fee
163 uint256 cutFee = realValue.div(10);
164 
165 
166 // Calculate the pokemon owner commission on this sale & transfer the commission to the owner.
167 uint256 commissionOwner = realValue - cutFee; // => 90%
168 pokemons[_pokemonId].ownerAddress.transfer(commissionOwner);
169 
170 // Transfer the 5% commission to the developer & %5 to tournamentPrizeAddress
171 devFeeAddress.transfer(cutFee.div(2)); // => 10%
172 tournamentPrizeAddress.transfer(cutFee.div(2));
173 
174 // Update the hero owner and set the new price
175 pokemons[_pokemonId].ownerAddress = msg.sender;
176 pokemons[_pokemonId].currentPrice = pokemons[_pokemonId].currentPrice.mul(3).div(2);
177 levels[_pokemonId] = levels[_pokemonId] + 1;
178 }
179 
180 // This function will return all of the details of the pokemons
181 function getPokemonDetails(uint _pokemonId) public view returns (
182 string pokemonName,
183 address ownerAddress,
184 uint256 currentPrice
185 ) {
186 Pokemon storage _pokemon = pokemons[_pokemonId];
187 
188 pokemonName = _pokemon.pokemonName;
189 ownerAddress = _pokemon.ownerAddress;
190 currentPrice = _pokemon.currentPrice;
191 }
192 
193 // This function will return only the price of a specific pokemon
194 function getPokemonCurrentPrice(uint _pokemonId) public view returns(uint256) {
195 return(pokemons[_pokemonId].currentPrice);
196 }
197 
198 // This function will return only the owner address of a specific pokemon
199 function getPokemonOwner(uint _pokemonId) public view returns(address) {
200 return(pokemons[_pokemonId].ownerAddress);
201 }
202 
203 // This function will return only the levels of pokemons
204 function getPokemonLevel(uint _pokemonId) public view returns(uint256) {
205 return(levels[_pokemonId]);
206 }
207 
208 // delete function, used when bugs comeout
209 function deletePokemon(uint _pokemonId) public onlyContractCreator() {
210 delete pokemons[_pokemonId];
211 delete pokemons[_pokemonId];
212 delete lock[_pokemonId];
213 }
214 
215 // Set function, used when bugs comeout
216 function setPokemon(uint _pokemonId, string _pokemonName, address _ownerAddress, uint256 _currentPrice, uint256 _levels) public onlyContractCreator() {
217 pokemons[_pokemonId].ownerAddress = _ownerAddress;
218 pokemons[_pokemonId].pokemonName = _pokemonName;
219 pokemons[_pokemonId].currentPrice = _currentPrice;
220 
221 levels[_pokemonId] = _levels;
222 lock[_pokemonId] = false;
223 }
224 
225 // This function will be used to add a new hero by the contract creator
226 function addPokemon(string pokemonName, address ownerAddress, uint256 currentPrice) public onlyAdmins {
227 pokemons.push(Pokemon(pokemonName,ownerAddress,currentPrice));
228 levels[pokemons.length - 1] = 0;
229 lock[pokemons.length - 1] = false;
230 }
231 
232 function totalSupply() public view returns (uint256 _totalSupply) {
233 return pokemons.length;
234 }
235 
236 }