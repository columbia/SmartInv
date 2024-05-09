1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title Opyns's FactoryStorage Contract
5  * @notice Stores contract, user, exchange, and token data. Deploys FactoryLogic.
6  * @author Opyn, Aparna Krishnan and Zubin Koticha
7  */
8 contract FactoryStorage {
9 
10     //TODO: add more events
11 
12     event NewPositionContract(
13         address userAddress,
14         address newPositionContractAddress,
15         address factoryLogicAddress
16     );
17 
18     event NewTokenAddedToPositionContract(
19         string ticker,
20         address tokenAddr,
21         address cTokenAddr,
22         address exchangeAddr
23     );
24 
25     event UserAdded(
26         address userAddr
27     );
28 
29     event TickerAdded(
30         string ticker
31     );
32 
33     event FactoryLogicChanged(
34         address factoryLogicAddr
35     );
36 
37     //maybe the name positionContractAddresses is better?!
38     //ticker => userAddr => positionContractAddr
39     //e.g. ticker = 'REP'
40     mapping (string => mapping (address => address)) public positionContracts;
41 
42     /**
43     * @notice the following give the ERC20 token address, ctoken, and Uniswap Exchange for a given token ticker symbol.
44     * e.g tokenAddresses('REP') => 0x1a...
45     * e.g ctokenAddresses('REP') => 0x51...
46     * e.g exchangeAddresses('REP') => 0x9a...
47     */
48     mapping (string => address) public tokenAddresses;
49     mapping (string => address) public ctokenAddresses;
50     mapping (string => address) public exchangeAddresses;
51 
52     //TODO: think about - using CarefulMath for uint;
53 
54     address public factoryLogicAddress;
55 
56     /**
57     * @notice The array of owners with write privileges.
58     */
59     address[3] public ownerAddresses;
60 
61     /**
62     * @notice The array of all users with contracts.
63     */
64     address[] public userAddresses;
65     string[] public tickers;
66 
67     /**
68     * @notice These mappings act as sets to see if a key is in string[] public tokens or address[] public userAddresses
69     */
70     mapping (address => bool) public userAddressesSet;
71     mapping (string => bool) public tickerSet;
72 
73     /**
74     * @notice Constructs a new FactoryStorage
75     * @param owner1 The second owner (after msg.sender)
76     * @param owner2 The third owner (after msg.sender)
77     */
78     constructor(address owner1, address owner2) public {
79         //TODO: deal with keys and ownership
80         ownerAddresses[0] = msg.sender;
81         ownerAddresses[1] = owner1;
82         ownerAddresses[2] = owner2;
83 
84         tickers = ['DAI','ZRX','BAT','ETH'];
85         tickerSet['DAI'] = true;
86         tickerSet['ZRX'] = true;
87         tickerSet['BAT'] = true;
88         tickerSet['ETH'] = true;
89 
90         //TODO: ensure all the following are accurate for mainnet.
91         tokenAddresses['DAI'] = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
92         tokenAddresses['BAT'] = 0x0D8775F648430679A709E98d2b0Cb6250d2887EF;
93         tokenAddresses['ZRX'] = 0xE41d2489571d322189246DaFA5ebDe1F4699F498;
94         tokenAddresses['REP'] = 0x1985365e9f78359a9B6AD760e32412f4a445E862;
95 
96         ctokenAddresses['DAI'] = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
97         ctokenAddresses['BAT'] = 0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E;
98         ctokenAddresses['ZRX'] = 0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407;
99         ctokenAddresses['REP'] = 0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1;
100         ctokenAddresses['ETH'] = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
101 
102         exchangeAddresses['DAI'] = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
103         exchangeAddresses['BAT'] = 0x2E642b8D59B45a1D8c5aEf716A84FF44ea665914;
104         exchangeAddresses['ZRX'] = 0xaE76c84C9262Cdb9abc0C2c8888e62Db8E22A0bF;
105         exchangeAddresses['REP'] = 0x48B04d2A05B6B604d8d5223Fd1984f191DED51af;
106     }
107 
108     /**
109     * @notice Sets a FactoryLogic contract that this contract interacts with, this clause is responsibility for upgradeability.
110     * @param newAddress the address of the new FactoryLogic contract
111     */
112     function setFactoryLogicAddress(address newAddress) public {
113         require(factoryLogicAddress == msg.sender|| ownerAddresses[0] == msg.sender || ownerAddresses[1] == msg.sender || ownerAddresses[2] == msg.sender);
114         //TODO: better security practices required than the above
115         factoryLogicAddress = newAddress;
116         emit FactoryLogicChanged(newAddress);
117     }
118 
119     /**
120     * @notice Adds a new user to the userAddresses array.
121     * @param newAddress the address of the new user
122     */
123     function addUser(address newAddress) public {
124         require(factoryLogicAddress == msg.sender|| ownerAddresses[0] == msg.sender || ownerAddresses[1] == msg.sender || ownerAddresses[2] == msg.sender);
125         //TODO: ensure that this is how it works.
126         if (!userAddressesSet[newAddress]) {
127             userAddresses.push(newAddress);
128             userAddressesSet[newAddress] = true;
129             emit UserAdded(newAddress);
130         }
131     }
132 
133     /**
134    * @notice Adds a new token to the tokens array.
135    * @param ticker ticker symbol of the new token
136    */
137     function addTicker(string memory ticker) public {
138         require(factoryLogicAddress == msg.sender|| ownerAddresses[0] == msg.sender || ownerAddresses[1] == msg.sender || ownerAddresses[2] == msg.sender);
139         //TODO: ensure that this is how it works.
140         if (!tickerSet[ticker]) {
141             tickers.push(ticker);
142             tickerSet[ticker] = true;
143             emit TickerAdded(ticker);
144         }
145     }
146 
147     /**
148     * @notice Sets the newAddress of a ticker in the tokenAddresses array.
149     * @param ticker string ticker symbol of the new token being added
150     * @param newAddress the new address of the token
151     */
152     function updateTokenAddress(string memory ticker, address newAddress) public {
153         require(factoryLogicAddress == msg.sender|| ownerAddresses[0] == msg.sender || ownerAddresses[1] == msg.sender || ownerAddresses[2] == msg.sender);
154         tokenAddresses[ticker] = newAddress;
155     }
156 
157     /**
158     * @notice Sets the newAddress of a ticker in the ctokenAddresses array.
159     * @param newAddress the address of the ctoken
160     */
161     function updatecTokenAddress(string memory ticker, address newAddress) public {
162         require(factoryLogicAddress == msg.sender|| ownerAddresses[0] == msg.sender || ownerAddresses[1] == msg.sender || ownerAddresses[2] == msg.sender);
163         ctokenAddresses[ticker] = newAddress;
164     }
165 
166     /**
167     * @notice Sets the newAddress of a position contract, this clause is responsibility for upgradeability.
168     * @param newAddress the address of the new FactoryLogic contract
169     */
170     function updateExchangeAddress(string memory ticker, address newAddress) public {
171         require(factoryLogicAddress == msg.sender|| ownerAddresses[0] == msg.sender || ownerAddresses[1] == msg.sender || ownerAddresses[2] == msg.sender);
172         exchangeAddresses[ticker] = newAddress;
173     }
174 
175     //  TODO: proper solidity style for following function
176     /**
177     * @notice Sets the newAddress of a position contract, this clause is responsibility for upgradeability.
178     * @param ticker the ticker symbol for this new token
179     * @param tokenAddr the address of the token
180     * @param cTokenAddr the address of the cToken
181     * @param exchangeAddr the address of the particular DEX pair
182     */
183     function addNewTokenToPositionContracts(string memory ticker, address tokenAddr, address cTokenAddr, address exchangeAddr) public {
184         require(factoryLogicAddress == msg.sender|| ownerAddresses[0] == msg.sender || ownerAddresses[1] == msg.sender || ownerAddresses[2] == msg.sender);
185         //TODO: do we want to first ensure ticker not already there?!
186         tokenAddresses[ticker] = tokenAddr;
187         ctokenAddresses[ticker] = cTokenAddr;
188         exchangeAddresses[ticker] = exchangeAddr;
189         emit NewTokenAddedToPositionContract(ticker, tokenAddr, cTokenAddr, exchangeAddr);
190     }
191 
192     /**
193     * @notice Sets the newAddress of a position contract, this clause is responsibility for upgradeability.
194     * @param ticker the ticker symbol that this PositionContract corresponds to
195     * @param userAddress the address of the user creating this PositionContract
196     * @param newContractAddress the address of the new position contract
197     */
198     function addNewPositionContract(string memory ticker, address userAddress, address newContractAddress) public {
199         //TODO: ensure userAddress has been added and ticker is valid.
200         require(factoryLogicAddress == msg.sender);
201         positionContracts[ticker][userAddress] = newContractAddress;
202         addUser(userAddress);
203         //TODO: shouldn't the following event include the ticker?
204         emit NewPositionContract(userAddress, newContractAddress, msg.sender);
205     }
206     
207     function updateRootAddr(address newAddress) public{
208         if(ownerAddresses[0] == msg.sender){
209             ownerAddresses[0] = newAddress;
210         } else if (ownerAddresses[1] == msg.sender) {
211             ownerAddresses[1] = newAddress;
212         } else if (ownerAddresses[2] == msg.sender) {
213             ownerAddresses[2] = newAddress;
214         }
215     }
216 }