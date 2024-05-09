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
23         address CryptoGamerAddress;
24     }
25     CryptoGamer[] cryptoGamers;
26 
27     bool cryptoGamersAreInitiated;
28     bool isPaused;
29     
30     /*
31     We use the following functions to pause and unpause the game.
32     */
33     function pauseGame() public onlyOwner {
34         isPaused = true;
35     }
36     function unPauseGame() public onlyOwner {
37         isPaused = false;
38     }
39     function GetIsPaused() public view returns(bool) {
40        return(isPaused);
41     }
42 
43     /*
44     This function allows players to purchase cryptogamers from other players. 
45     The price is automatically multiplied by 1.5 after each purchase.
46     */
47     function purchaseCryptoGamer(uint _cryptoGamerId) public payable {
48         require(msg.value == cryptoGamers[_cryptoGamerId].curPrice);
49         require(isPaused == false);
50 
51         // Calculate the 5% value
52         uint256 commission1percent = (msg.value / 100);
53         
54         // Transfer the 5% commission to the owner of the least expensive and most expensive cryptogame
55         address leastExpensiveCryptoGamerOwner = cryptoGamers[getLeastExpensiveCryptoGamer()].ownerAddress;
56         address mostExpensiveCryptoGamerOwner = cryptoGamers[getMostExpensiveCryptoGamer()].ownerAddress;
57         
58         // We check if the contract is still the owner of the most/least expensive cryptogamers 
59         if(leastExpensiveCryptoGamerOwner == address(this)) { 
60             leastExpensiveCryptoGamerOwner = contractOwnerAddress; 
61         }
62         if(mostExpensiveCryptoGamerOwner == address(this)) { 
63             mostExpensiveCryptoGamerOwner = contractOwnerAddress; 
64         }
65         
66         leastExpensiveCryptoGamerOwner.transfer(commission1percent * 5); // => 5%  
67         mostExpensiveCryptoGamerOwner.transfer(commission1percent * 5); // => 5%  
68 
69         // Calculate the owner commission on this sale & transfer the commission to the owner.      
70         uint256 commissionOwner = msg.value - (commission1percent * 15); // => 85%
71         
72         // This cryptoGamer is still owned by the contract, we transfer the commission to the ownerAddress
73         if(cryptoGamers[_cryptoGamerId].ownerAddress == address(this)) {
74             contractOwnerAddress.transfer(commissionOwner);
75 
76         } else {
77             // This cryptogamer is owned by a user, we transfer the commission to this player
78             cryptoGamers[_cryptoGamerId].ownerAddress.transfer(commissionOwner);
79         }
80         
81 
82         // Transfer the 3% commission to the developer
83         contractOwnerAddress.transfer(commission1percent * 3); // => 3%
84         
85         // Transfer the 2% commission to the actual cryptogamer
86         if(cryptoGamers[_cryptoGamerId].CryptoGamerAddress != 0x0) {
87             cryptoGamers[_cryptoGamerId].CryptoGamerAddress.transfer(commission1percent * 2); // => 2%
88         } else {
89             // We don't konw the address of the crypto gamer yet, we transfer the commission to the owner
90             contractOwnerAddress.transfer(commission1percent * 2); // => 2%
91         }
92         
93 
94         // Update the company owner and set the new price
95         cryptoGamers[_cryptoGamerId].ownerAddress = msg.sender;
96         cryptoGamers[_cryptoGamerId].curPrice = cryptoGamers[_cryptoGamerId].curPrice + (cryptoGamers[_cryptoGamerId].curPrice / 2);
97     }
98 
99     /*
100     This is the function that will allow players to purchase the contract. 
101     The initial price is set to 26ETH (26000000000000000000 WEI).
102     The owner of the contract can create new players and will receive a 5% commission on every sales
103     */
104     function purchaseContract() public payable {
105         require(msg.value == priceContract);
106         
107         // Calculate the 5% value
108         uint256 commission5percent = ((msg.value / 10)/2);
109         
110         // Transfer the 5% commission to the owner of the least expensive and most expensive cryptogame
111         address leastExpensiveCryptoGamerOwner = cryptoGamers[getLeastExpensiveCryptoGamer()].ownerAddress;
112         address mostExpensiveCryptoGamerOwner = cryptoGamers[getMostExpensiveCryptoGamer()].ownerAddress;
113         
114         // We check if the contract is still the owner of the most/least expensive cryptogamers 
115         if(leastExpensiveCryptoGamerOwner == address(this)) { 
116             leastExpensiveCryptoGamerOwner = contractOwnerAddress; 
117         }
118         if(mostExpensiveCryptoGamerOwner == address(this)) { 
119             mostExpensiveCryptoGamerOwner = contractOwnerAddress; 
120         }
121         
122         // Transfer the commission
123         leastExpensiveCryptoGamerOwner.transfer(commission5percent); // => 5%  
124         mostExpensiveCryptoGamerOwner.transfer(commission5percent); // => 5%  
125 
126         // Calculate the owner commission on this sale & transfer the commission to the owner.      
127         uint256 commissionOwner = msg.value - (commission5percent * 2); // => 85%
128         
129         contractOwnerAddress.transfer(commissionOwner);
130         contractOwnerAddress = msg.sender;
131     }
132 
133     function getPriceContract() public view returns(uint) {
134         return(priceContract);
135     }
136 
137     /*
138     The owner of the contract can use this function to modify the price of the contract.
139     The price is set in WEI
140     */
141     function updatePriceContract(uint256 _newPrice) public onlyOwner {
142         priceContract = _newPrice;
143     }
144 
145     // Simply returns the current owner address
146     function getContractOwnerAddress() public view returns(address) {
147         return(contractOwnerAddress);
148     }
149 
150     /*
151     The owner of a company can reduce the price of the company using this function.
152     The price can be reduced but cannot be bigger.
153     The price is set in WEI.
154     */
155     function updateCryptoGamerPrice(uint _cryptoGamerId, uint256 _newPrice) public {
156         require(_newPrice > 0);
157         require(cryptoGamers[_cryptoGamerId].ownerAddress == msg.sender);
158         require(_newPrice < cryptoGamers[_cryptoGamerId].curPrice);
159         cryptoGamers[_cryptoGamerId].curPrice = _newPrice;
160     }
161     
162     // This function will return the details of a cryptogamer
163     function getCryptoGamer(uint _cryptoGamerId) public view returns (
164         string name,
165         address ownerAddress,
166         uint256 curPrice,
167         address CryptoGamerAddress
168     ) {
169         CryptoGamer storage _cryptoGamer = cryptoGamers[_cryptoGamerId];
170 
171         name = _cryptoGamer.name;
172         ownerAddress = _cryptoGamer.ownerAddress;
173         curPrice = _cryptoGamer.curPrice;
174         CryptoGamerAddress = _cryptoGamer.CryptoGamerAddress;
175     }
176     
177     /*
178     Get least expensive crypto gamers (to transfer the owner 5% of the transaction)
179     If multiple cryptogamers have the same price, the selected one will be the cryptogamer with the smalled id 
180     */
181     function getLeastExpensiveCryptoGamer() public view returns(uint) {
182         uint _leastExpensiveGamerId = 0;
183         uint256 _leastExpensiveGamerPrice = 9999000000000000000000;
184 
185         // Loop through all the shares of this company
186         for (uint8 i = 0; i < cryptoGamers.length; i++) {
187             if(cryptoGamers[i].curPrice < _leastExpensiveGamerPrice) {
188                 _leastExpensiveGamerPrice = cryptoGamers[i].curPrice;
189                 _leastExpensiveGamerId = i;
190             }
191         }
192         return(_leastExpensiveGamerId);
193     }
194 
195     /* 
196     Get most expensive crypto gamers (to transfer the owner 5% of the transaction)
197      If multiple cryptogamers have the same price, the selected one will be the cryptogamer with the smalled id 
198      */
199     function getMostExpensiveCryptoGamer() public view returns(uint) {
200         uint _mostExpensiveGamerId = 0;
201         uint256 _mostExpensiveGamerPrice = 9999000000000000000000;
202 
203         // Loop through all the shares of this company
204         for (uint8 i = 0; i < cryptoGamers.length; i++) {
205             if(cryptoGamers[i].curPrice > _mostExpensiveGamerPrice) {
206                 _mostExpensiveGamerPrice = cryptoGamers[i].curPrice;
207                 _mostExpensiveGamerId = i;
208             }
209         }
210         return(_mostExpensiveGamerId);
211     }
212     
213     /**
214     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
215     */
216     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
217         if (a == 0) {
218           return 0;
219         }
220         uint256 c = a * b;
221         assert(c / a == b);
222         return c;
223     }
224 
225     /**
226     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
227     */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         // assert(b > 0); // Solidity automatically throws when dividing by 0
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232         return c;
233     }
234     /*
235     The dev can update the verified address of the crypto gamer. Email me at contact@playcryptogaming.com to get your account verified and earn a commission.
236     */
237     function updateCryptoGamerVerifiedAddress(uint _cryptoGamerId, address _newAddress) public onlyOwner {
238         cryptoGamers[_cryptoGamerId].CryptoGamerAddress = _newAddress;
239     }
240     
241     /*
242     The owner can use this function to create new cryptoGamers.
243     The price is set in WEI
244     Important: If you purchased the contract and are the owner of this game, create the CryptoGamers from your admin section in the game instead calling this function from another place.
245     */
246     function createCryptoGamer(string _cryptoGamerName, uint256 _cryptoGamerPrice, address _verifiedAddress) public onlyOwner {
247         cryptoGamers.push(CryptoGamer(_cryptoGamerName, address(this), _cryptoGamerPrice, _verifiedAddress));
248     }
249     
250     // Initiate functions that will create the cryptoGamers
251     function InitiateCryptoGamers() public onlyOwner {
252         require(cryptoGamersAreInitiated == false);
253         cryptoGamers.push(CryptoGamer("Phil", 0x183febd8828a9ac6c70c0e27fbf441b93004fc05, 1012500000000000000, 0x0));
254         cryptoGamers.push(CryptoGamer("Carlini8", address(this), 310000000000000000, 0x0));
255         cryptoGamers.push(CryptoGamer("Ferocious", 0x1A5fe261E8D9e8efC5064EEccC09B531E6E24BD3, 375000000000000000, 0x1A5fe261E8D9e8efC5064EEccC09B531E6E24BD3));
256         cryptoGamers.push(CryptoGamer("Pranked", address(this), 224000000000000000, 0xD387A6E4e84a6C86bd90C158C6028A58CC8Ac459));
257         cryptoGamers.push(CryptoGamer("SwagDaPanda", address(this), 181000000000000000, 0x0));
258         cryptoGamers.push(CryptoGamer("Slush", address(this), 141000000000000000, 0x70580eA14d98a53fd59376dC7e959F4a6129bB9b));
259         cryptoGamers.push(CryptoGamer("Acapuck", address(this), 107000000000000000, 0x0));
260         cryptoGamers.push(CryptoGamer("Arwynian", address(this), 131000000000000000, 0xA3b61695E46432E5CCCd0427AD956fa146379D08));
261         cryptoGamers.push(CryptoGamer("Bohl", address(this), 106000000000000000, 0x0));
262         cryptoGamers.push(CryptoGamer("Corgi", address(this), 91500000000000000, 0x0));
263         cryptoGamers.push(CryptoGamer("Enderhero", address(this), 104000000000000000, 0x0));
264         cryptoGamers.push(CryptoGamer("Hecatonquiro", address(this), 105000000000000000, 0xB87e73ad25086C43a16fE5f9589Ff265F8A3A9Eb));
265         cryptoGamers.push(CryptoGamer("herb", address(this), 101500000000000000, 0x466aCFE9f93D167EA8c8fa6B8515A65Aa47784dD));
266         cryptoGamers.push(CryptoGamer("Kail", address(this), 103000000000000000, 0x0));
267         cryptoGamers.push(CryptoGamer("karupin the cat", 0x5632ca98e5788eddb2397757aa82d1ed6171e5ad, 108100000000000000, 0x0));
268         cryptoGamers.push(CryptoGamer("LiveFree", 0x3177abbe93422c9525652b5d4e1101a248a99776, 90100000000000000, 0x0));
269         cryptoGamers.push(CryptoGamer("Prokiller", address(this), 100200000000000000, 0x0));
270         cryptoGamers.push(CryptoGamer("Sanko", address(this), 101000000000000000, 0x71f35825a3B1528859dFa1A64b24242BC0d12990));
271         cryptoGamers.push(CryptoGamer("TheHermitMonk", address(this), 100000000000000000, 0x0));
272         cryptoGamers.push(CryptoGamer("TomiSharked", 0x9afbaa3003d9e75c35fde2d1fd283b13d3335f00, 89000000000000000, 0x0));
273         cryptoGamers.push(CryptoGamer("Zalman", 0x9afbaa3003d9e75c35fde2d1fd283b13d3335f00, 92000000000000000, 0x0));
274         cryptoGamers.push(CryptoGamer("xxFyMxx", address(this), 110000000000000000, 0x0));
275         cryptoGamers.push(CryptoGamer("UncleTom", address(this), 90000000000000000, 0x0));
276         cryptoGamers.push(CryptoGamer("legal", address(this), 115000000000000000, 0x0));
277         cryptoGamers.push(CryptoGamer("Terpsicores", address(this), 102000000000000000, 0x0));
278         cryptoGamers.push(CryptoGamer("triceratops", 0x9afbaa3003d9e75c35fde2d1fd283b13d3335f00, 109000000000000000, 0x0));
279         cryptoGamers.push(CryptoGamer("souto", address(this), 85000000000000000, 0x0));
280         cryptoGamers.push(CryptoGamer("Danimal", 0xa586a3b8939e9c0dc72d88166f6f6bb7558eedce, 85000000000000000, 0x3177Abbe93422c9525652b5d4e1101a248A99776));
281 
282     }
283 }