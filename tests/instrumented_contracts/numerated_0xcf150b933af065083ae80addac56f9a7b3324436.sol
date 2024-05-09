1 pragma solidity ^0.4.18;
2 
3 /*
4 Game Name: PlayCryptoGaming
5 Game Link: https://playcryptogaming.com/
6 */
7 
8 contract PlayCryptoGaming {
9 
10     address contractOwnerAddress = 0x46d9112533ef677059c430E515775e358888e38b;
11     uint256 priceContract = 26000000000000000000;
12 
13 
14     modifier onlyOwner() {
15         require (msg.sender == contractOwnerAddress);
16         _;
17     }
18     
19     struct CryptoGamer {
20         string name;
21         address ownerAddress;
22         uint256 curPrice;
23     }
24     CryptoGamer[] cryptoGamers;
25 
26     bool cryptoGamersAreInitiated;
27     bool isPaused;
28     
29     /*
30     We use the following functions to pause and unpause the game.
31     */
32     function pauseGame() public onlyOwner {
33         isPaused = true;
34     }
35     function unPauseGame() public onlyOwner {
36         isPaused = false;
37     }
38     function GetIsPaused() public view returns(bool) {
39        return(isPaused);
40     }
41 
42     /*
43     This function allows players to purchase cryptogamers from other players. 
44     The price is automatically multiplied by 1.5 after each purchase.
45     */
46     function purchaseCryptoGamer(uint _cryptoGamerId) public payable {
47         require(msg.value == cryptoGamers[_cryptoGamerId].curPrice);
48         require(isPaused == false);
49 
50         // Calculate the 5% value
51         uint256 commission5percent = ((msg.value / 10)/2);
52         
53         // Transfer the 5% commission to the owner of the least expensive and most expensive cryptogame
54         address leastExpensiveCryptoGamerOwner = cryptoGamers[getLeastExpensiveCryptoGamer()].ownerAddress;
55         address mostExpensiveCryptoGamerOwner = cryptoGamers[getMostExpensiveCryptoGamer()].ownerAddress;
56         
57         // We check if the contract is still the owner of the most/least expensive cryptogamers 
58         if(leastExpensiveCryptoGamerOwner == address(this)) { 
59             leastExpensiveCryptoGamerOwner = contractOwnerAddress; 
60         }
61         if(mostExpensiveCryptoGamerOwner == address(this)) { 
62             mostExpensiveCryptoGamerOwner = contractOwnerAddress; 
63         }
64         
65         leastExpensiveCryptoGamerOwner.transfer(commission5percent); // => 5%  
66         mostExpensiveCryptoGamerOwner.transfer(commission5percent); // => 5%  
67 
68         // Calculate the owner commission on this sale & transfer the commission to the owner.      
69         uint256 commissionOwner = msg.value - (commission5percent * 3); // => 85%
70         
71         // This cryptoGamer is still owned by the contract, we transfer the commission to the ownerAddress
72         if(cryptoGamers[_cryptoGamerId].ownerAddress == address(this)) {
73             contractOwnerAddress.transfer(commissionOwner);
74 
75         } else {
76             // This cryptogamer is owned by a user, we transfer the commission to this player
77             cryptoGamers[_cryptoGamerId].ownerAddress.transfer(commissionOwner);
78         }
79         
80 
81         // Transfer the 5% commission to the developer
82         contractOwnerAddress.transfer(commission5percent); // => 5%                   
83 
84         // Update the company owner and set the new price
85         cryptoGamers[_cryptoGamerId].ownerAddress = msg.sender;
86         cryptoGamers[_cryptoGamerId].curPrice = cryptoGamers[_cryptoGamerId].curPrice + (cryptoGamers[_cryptoGamerId].curPrice / 2);
87     }
88 
89     /*
90     This is the function that will allow players to purchase the contract. 
91     The initial price is set to 26ETH (26000000000000000000 WEI).
92     The owner of the contract can create new players and will receive a 5% commission on every sales
93     */
94     function purchaseContract() public payable {
95         require(msg.value == priceContract);
96         
97         // Calculate the 5% value
98         uint256 commission5percent = ((msg.value / 10)/2);
99         
100         // Transfer the 5% commission to the owner of the least expensive and most expensive cryptogame
101         address leastExpensiveCryptoGamerOwner = cryptoGamers[getLeastExpensiveCryptoGamer()].ownerAddress;
102         address mostExpensiveCryptoGamerOwner = cryptoGamers[getMostExpensiveCryptoGamer()].ownerAddress;
103         
104         // We check if the contract is still the owner of the most/least expensive cryptogamers 
105         if(leastExpensiveCryptoGamerOwner == address(this)) { 
106             leastExpensiveCryptoGamerOwner = contractOwnerAddress; 
107         }
108         if(mostExpensiveCryptoGamerOwner == address(this)) { 
109             mostExpensiveCryptoGamerOwner = contractOwnerAddress; 
110         }
111         
112         // Transfer the commission
113         leastExpensiveCryptoGamerOwner.transfer(commission5percent); // => 5%  
114         mostExpensiveCryptoGamerOwner.transfer(commission5percent); // => 5%  
115 
116         // Calculate the owner commission on this sale & transfer the commission to the owner.      
117         uint256 commissionOwner = msg.value - (commission5percent * 2); // => 85%
118         
119         contractOwnerAddress.transfer(commissionOwner);
120         contractOwnerAddress = msg.sender;
121     }
122 
123     function getPriceContract() public view returns(uint) {
124         return(priceContract);
125     }
126 
127     /*
128     The owner of the contract can use this function to modify the price of the contract.
129     The price is set in WEI
130     */
131     function updatePriceContract(uint256 _newPrice) public onlyOwner {
132         priceContract = _newPrice;
133     }
134 
135     // Simply returns the current owner address
136     function getContractOwnerAddress() public view returns(address) {
137         return(contractOwnerAddress);
138     }
139 
140     /*
141     The owner of a company can reduce the price of the company using this function.
142     The price can be reduced but cannot be bigger.
143     The price is set in WEI.
144     */
145     function updateCryptoGamerPrice(uint _cryptoGamerId, uint256 _newPrice) public {
146         require(_newPrice > 0);
147         require(cryptoGamers[_cryptoGamerId].ownerAddress == msg.sender);
148         require(_newPrice < cryptoGamers[_cryptoGamerId].curPrice);
149         cryptoGamers[_cryptoGamerId].curPrice = _newPrice;
150     }
151     
152     // This function will return the details of a cryptogamer
153     function getCryptoGamer(uint _cryptoGamerId) public view returns (
154         string name,
155         address ownerAddress,
156         uint256 curPrice
157     ) {
158         CryptoGamer storage _cryptoGamer = cryptoGamers[_cryptoGamerId];
159 
160         name = _cryptoGamer.name;
161         ownerAddress = _cryptoGamer.ownerAddress;
162         curPrice = _cryptoGamer.curPrice;
163     }
164     
165     /*
166     Get least expensive crypto gamers (to transfer the owner 5% of the transaction)
167     If multiple cryptogamers have the same price, the selected one will be the cryptogamer with the smalled id 
168     */
169     function getLeastExpensiveCryptoGamer() public view returns(uint) {
170         uint _leastExpensiveGamerId = 0;
171         uint256 _leastExpensiveGamerPrice = 9999000000000000000000;
172 
173         // Loop through all the shares of this company
174         for (uint8 i = 0; i < cryptoGamers.length; i++) {
175             if(cryptoGamers[i].curPrice < _leastExpensiveGamerPrice) {
176                 _leastExpensiveGamerPrice = cryptoGamers[i].curPrice;
177                 _leastExpensiveGamerId = i;
178             }
179         }
180         return(_leastExpensiveGamerId);
181     }
182 
183     /* 
184     Get most expensive crypto gamers (to transfer the owner 5% of the transaction)
185      If multiple cryptogamers have the same price, the selected one will be the cryptogamer with the smalled id 
186      */
187     function getMostExpensiveCryptoGamer() public view returns(uint) {
188         uint _mostExpensiveGamerId = 0;
189         uint256 _mostExpensiveGamerPrice = 9999000000000000000000;
190 
191         // Loop through all the shares of this company
192         for (uint8 i = 0; i < cryptoGamers.length; i++) {
193             if(cryptoGamers[i].curPrice > _mostExpensiveGamerPrice) {
194                 _mostExpensiveGamerPrice = cryptoGamers[i].curPrice;
195                 _mostExpensiveGamerId = i;
196             }
197         }
198         return(_mostExpensiveGamerId);
199     }
200     
201     /**
202     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
203     */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         if (a == 0) {
206           return 0;
207         }
208         uint256 c = a * b;
209         assert(c / a == b);
210         return c;
211     }
212 
213     /**
214     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
215     */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         // assert(b > 0); // Solidity automatically throws when dividing by 0
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220         return c;
221     }
222     
223     /*
224     The owner can use this function to create new cryptoGamers.
225     The price is set in WEI
226     Important: If you purchased the contract and are the owner of this game, create the CryptoGamers from your admin section in the game instead calling this function from another place.
227     */
228     function createCryptoGamer(string _cryptoGamerName, uint256 _cryptoGamerPrice) public onlyOwner {
229         cryptoGamers.push(CryptoGamer(_cryptoGamerName, address(this), _cryptoGamerPrice));
230     }
231     
232     // Initiate functions that will create the cryptoGamers
233     function InitiateCryptoGamers() public onlyOwner {
234         require(cryptoGamersAreInitiated == false);
235         createCryptoGamer("Phil", 450000000000000000); 
236         createCryptoGamer("Carlini8", 310000000000000000); 
237         createCryptoGamer("Ferocious", 250000000000000000); 
238         createCryptoGamer("Pranked", 224000000000000000); 
239         createCryptoGamer("SwagDaPanda", 181000000000000000); 
240         createCryptoGamer("Slush", 141000000000000000); 
241         createCryptoGamer("Acapuck", 107000000000000000); 
242         createCryptoGamer("Arwynian", 131000000000000000); 
243         createCryptoGamer("Bohl", 106000000000000000);
244         createCryptoGamer("Corgi", 91500000000000000);
245         createCryptoGamer("Enderhero", 104000000000000000);
246         createCryptoGamer("Hecatonquiro", 105000000000000000);
247         createCryptoGamer("herb", 101500000000000000);
248         createCryptoGamer("Kail", 103000000000000000);
249         createCryptoGamer("karupin the cat", 108100000000000000);
250         createCryptoGamer("LiveFree", 90100000000000000);
251         createCryptoGamer("Prokiller", 100200000000000000);
252         createCryptoGamer("Sanko", 101000000000000000);
253         createCryptoGamer("TheHermitMonk", 100000000000000000);
254         createCryptoGamer("TomiSharked", 89000000000000000);
255         createCryptoGamer("Zalman", 92000000000000000);
256         createCryptoGamer("xxFyMxx", 110000000000000000);
257         createCryptoGamer("UncleTom", 90000000000000000);
258         createCryptoGamer("legal", 115000000000000000);
259         createCryptoGamer("Terpsicores", 102000000000000000);
260         createCryptoGamer("triceratops", 109000000000000000);
261         createCryptoGamer("souto", 85000000000000000);
262     }
263 }