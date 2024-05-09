1 pragma solidity >0.4.99 <0.6.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 pragma experimental ABIEncoderV2;
76 
77 contract HashGame is Ownable {
78 
79     uint256 constant public MAX_BET = 1 ether;
80     uint256 public ethRaised;
81     uint256 public countRound = 1;
82 
83     struct Game {
84         address player;
85         uint256 betAmount;
86         uint256 blockNumber;
87         uint256 prize;
88         uint256[] symbols;
89         bool started;
90         bool isWinner;
91         string symbolWinner;
92     }
93     mapping(uint256 => Game) public games;
94     mapping(address => uint256) public roundPlayer;
95 
96     address payable public beneficiar;
97 
98     event Result(address indexed player, uint[] symbols, string winSymbol, uint256 betAmount, uint256 prizeAmount, uint256 blockNumber);
99     event PlaceBet(address indexed player, uint256 betAmount, uint256 prizeAmount, uint256 blockNumber, uint256[] symbols);
100 
101     constructor (address payable beneficiarAddress) public {
102         setBeneficiarAddress(beneficiarAddress);
103     }
104 
105     function () external payable {}
106 
107     function placeBet(uint[] memory symbolsUint) public payable {
108         require(msg.value > 0 && msg.value <= MAX_BET, "Requires msg.value > 0 && msg.value <= MAX_BET");
109         require(!games[roundPlayer[msg.sender]].started, "Requires not started");
110         require(symbolsUint.length > 0 && symbolsUint.length <= 5, "Requires symbols.length > 0 && symbols.length <= 5");
111         uint256 prize = calcPrize(symbolsUint.length, msg.value);
112         require(address(this).balance >= prize, "require balance of contract >= prize");
113 
114         Game storage game = games[countRound];
115         game.player = msg.sender;
116         game.betAmount = msg.value;
117         game.blockNumber = block.number;
118         game.prize = prize;
119         game.symbols = symbolsUint;
120         game.started = true;
121 
122         roundPlayer[msg.sender]  = countRound;
123 
124         countRound++;
125         emit PlaceBet(msg.sender, msg.value, prize, block.number, symbolsUint);
126     }
127 
128     function bet() public {
129         Game storage game = games[roundPlayer[msg.sender]];
130         require(game.started, "require game started");
131         require(block.number > game.blockNumber, "require current number of block > game number of block");
132         if (block.number - game.blockNumber > 256) {
133             if (address(this).balance > game.betAmount) {
134                 game.started = false;
135                 msg.sender.transfer(game.betAmount);
136             }
137         } else {
138             string [] memory symbols = getValueSymbols(game.symbols);
139             byte lastBlockhashByte = getLastByte(blockhash(game.blockNumber));
140             string memory lastByteRightSymbol = getRightSymbolFromByte(lastBlockhashByte);
141             game.symbolWinner = lastByteRightSymbol;
142             uint256 prize = game.prize;
143             if (address(this).balance > prize) {
144                 for (uint i = 0; i < symbols.length; i++) {
145                     if ( keccak256(bytes(symbols[i])) == keccak256(bytes(lastByteRightSymbol)) ) {
146                         ethRaised = ethRaised + prize;
147                         game.isWinner = true;
148                         msg.sender.transfer(prize);
149                     }
150                 }
151                 game.started = false;
152             }
153             emit Result(msg.sender, game.symbols, lastByteRightSymbol, game.betAmount, prize, game.blockNumber);
154         }
155     }
156 
157     function getEtherFromBank(uint256 weiAmount) public {
158         require(msg.sender == owner() || msg.sender == beneficiar);
159         beneficiar.transfer(weiAmount);
160     }
161 
162     function getBalanceContract() public view returns (uint) {
163         return address(this).balance;
164     }
165 
166     function getGamesByIndex(uint index) public view returns
167     (
168         address player,
169         uint betAmount,
170         uint prize,
171         bool isWinner,
172         uint[] memory symbols,
173         bool started,
174         string memory symbolWinner
175     ) {
176         Game memory game = games[index];
177         player = game.player;
178         betAmount = game.betAmount;
179         prize = game.prize;
180         isWinner = game.isWinner;
181         symbols = game.symbols;
182         started = game.started;
183         symbolWinner = game.symbolWinner;
184     }
185 
186     function setBeneficiarAddress(address payable beneficiarAddress) public onlyOwner {
187         beneficiar = beneficiarAddress;
188     }
189 
190     function getLastByte(bytes32 strBytes) private pure returns (byte lastByte) {
191         lastByte = strBytes[31];
192     }
193 
194     function getRightSymbolFromByte(byte input) private pure returns(string memory symbol) {
195         byte val = input & 0x0f;
196         if (val == 0x00) {
197             symbol = '0';
198         } else if (val == 0x01) {
199             symbol = '1';
200         } else if (val == 0x02) {
201             symbol = '2';
202         } else if (val == 0x03) {
203             symbol = '3';
204         } else if (val == 0x04) {
205             symbol = '4';
206         } else if (val == 0x05) {
207             symbol = '5';
208         } else if (val == 0x06) {
209             symbol = '6';
210         } else if (val == 0x07) {
211             symbol = '7';
212         } else if (val == 0x08) {
213             symbol = '8';
214         } else if (val == 0x09) {
215             symbol = '9';
216         } else if (val == 0x0a) {
217             symbol = 'a';
218         } else if (val == 0x0b) {
219             symbol = 'b';
220         } else if (val == 0x0c) {
221             symbol = 'c';
222         } else if (val == 0x0d) {
223             symbol = 'd';
224         } else if (val == 0x0e) {
225             symbol = 'e';
226         } else if (val == 0x0f) {
227             symbol = 'f';
228         }
229     }
230 
231     function convertToSymbol(uint val) private pure returns(string memory symbol) {
232         if (val == 0) {
233             symbol = '0';
234         } else if (val == 1) {
235             symbol = '1';
236         } else if (val == 2) {
237             symbol = '2';
238         } else if (val == 3) {
239             symbol = '3';
240         } else if (val == 4) {
241             symbol = '4';
242         } else if (val == 5) {
243             symbol = '5';
244         } else if (val == 6) {
245             symbol = '6';
246         } else if (val == 7) {
247             symbol = '7';
248         } else if (val == 8) {
249             symbol = '8';
250         } else if (val == 9) {
251             symbol = '9';
252         } else if (val == 10) {
253             symbol = 'a';
254         } else if (val == 11) {
255             symbol = 'b';
256         } else if (val == 12) {
257             symbol = 'c';
258         } else if (val == 13) {
259             symbol = 'd';
260         } else if (val == 14) {
261             symbol = 'e';
262         } else if (val == 15) {
263             symbol = 'f';
264         }
265     }
266 
267     function calcPrize(uint len, uint value) internal pure returns (uint) {
268         if (len == 1) {
269             return value * 10;
270         }
271         if (len == 2) {
272             return value * 5;
273         }
274         if (len == 3) {
275             return value * 4;
276         }
277         if (len == 4) {
278             return value * 3;
279         }
280         if (len == 5) {
281             return value * 2;
282         }
283     }
284 
285     function getValueSymbols(uint[] memory arrayUintSymbols) internal pure returns (string[] memory arrayStrSymbols) {
286         delete arrayStrSymbols;
287         string [] memory arrayString = new string[](arrayUintSymbols.length);
288         for (uint i = 0; i < arrayUintSymbols.length; i++) {
289             arrayString[i] = convertToSymbol(arrayUintSymbols[i]);
290         }
291         arrayStrSymbols = arrayString;
292     }
293 
294 }