1 pragma solidity^0.4.21;
2 /*
3  *      ##########################################
4  *      ##########################################
5  *      ###                                                                                         ###
6  *      ###                             ???? & ??? ?????                             ###
7  *      ###                                          at                                            ###
8  *      ###                            ??????????.???                            ###
9  *      ###                                                                                         ###
10  *      ##########################################
11  *      ##########################################
12  *
13  *      Welcome to the ?????????? ??? ????? promotional contract!
14  *      First you should go and play ?????????? @ ?????://??????????.???
15  *      Then you'll have earnt free ??? ?????? via this very promotion!
16  *      Next you should learn about our ??? @ ?????://??????????.???/???
17  *      Then take part by buying even more ??? ??????! 
18  *      And don't forget to play ?????????? some more because it's brilliant!
19  *
20  *      If you want to chat to us you have loads of options:
21  *      On ???????? @ ?????://?.??/??????????
22  *      Or on ??????? @ ?????://???????.???/??????????
23  *      Or on ?????? @ ?????://??????????.??????.???
24  *
25  *      ?????????? - the only ????? ????????????? & ?????????? blockchain lottery.
26  */
27 contract EtheraffleInterface {
28     uint public tktPrice;
29     function getUserNumEntries(address _entrant, uint _week) public view returns (uint) {}
30 }
31 
32 contract LOTInterface {
33     function transfer(address _to, uint _value) public {}
34     function balanceOf(address _owner) public view returns (uint) {}
35 }
36 
37 contract EtheraffleLOTPromo {
38     
39     bool    public isActive;
40     uint    constant public RAFEND     = 500400;     // 7:00pm Saturdays
41     uint    constant public BIRTHDAY   = 1500249600; // Etheraffle's birthday <3
42     uint    constant public ICOSTART   = 1522281600; // Thur 29th March 2018
43     uint    constant public TIER1END   = 1523491200; // Thur 12th April 2018
44     uint    constant public TIER2END   = 1525305600; // Thur 3rd May 2018
45     uint    constant public TIER3END   = 1527724800; // Thur 31st May 2018
46     address constant public ETHERAFFLE = 0x97f535e98cf250CDd7Ff0cb9B29E4548b609A0bd;
47     
48     LOTInterface LOTContract;
49     EtheraffleInterface etheraffleContract;
50 
51     /* Mapping of  user address to weekNo to claimed bool */
52     mapping (address => mapping (uint => bool)) public claimed;
53     
54     event LogActiveStatus(bool currentStatus, uint atTime);
55     event LogTokenDeposit(address fromWhom, uint tokenAmount, bytes data);
56     event LogLOTClaim(address whom, uint howMany, uint inWeek, uint atTime);
57     /*
58      * @dev     Modifier requiring function caller to be the Etheraffle 
59      *          multisig wallet address
60      */
61     modifier onlyEtheraffle() {
62         require(msg.sender == ETHERAFFLE);
63         _;
64     }
65     /*
66      * @dev     Constructor - sets promo running and instantiates required
67      *          contracts.
68      */
69     function EtheraffleLOTPromo() public {
70         isActive           = true;
71         LOTContract        = LOTInterface(0xAfD9473dfe8a49567872f93c1790b74Ee7D92A9F);
72         etheraffleContract = EtheraffleInterface(0x45c58bbd535b8661110ef5296e6987573d0c8276);
73     }
74     /*
75      * @dev     Function used to redeem promotional LOT owed. Use weekNo of 
76      *          0 to get current week number. Requires user not to have already 
77      *          claimed week number in question's earnt promo LOT and for promo 
78      *          to be active. It calculates LOT owed, and sends them to the 
79      *          caller. Should contract's LOT balance fall too low, attempts 
80      *          to redeem will arrest the contract to await a resupply of LOT.
81      */
82     function redeem(uint _weekNo) public {
83         uint week    = _weekNo == 0 ? getWeek() : _weekNo;
84         uint entries = getNumEntries(msg.sender, week);
85         require(
86             !claimed[msg.sender][week] &&
87             entries > 0 &&
88             isActive
89             );
90         uint amt = getPromoLOTEarnt(entries);
91         if (getLOTBalance(this) < amt) {
92             isActive = false;
93             emit LogActiveStatus(false, now);
94             return;
95         }
96         claimed[msg.sender][week] = true;
97         LOTContract.transfer(msg.sender, amt);
98         emit LogLOTClaim(msg.sender, amt, week, now);
99     }
100     /*
101      * @dev     Returns number of entries made in Etheraffle contract by
102      *          function caller in whatever the queried week is. 
103      *
104      * @param _address  Address to be queried
105      * @param _weekNo   Desired week number. (Use 0 for current week)
106      */
107     function getNumEntries(address _address, uint _weekNo) public view returns (uint) {
108         uint week = _weekNo == 0 ? getWeek() : _weekNo;
109         return etheraffleContract.getUserNumEntries(_address, week);
110     }
111     /*
112      * @dev     Toggles promo on & off. Only callable by the Etheraffle
113      *          multisig wallet.
114      *
115      * @param _status   Desired bool status of the promo
116      */
117     function togglePromo(bool _status) public onlyEtheraffle {
118         isActive = _status;
119         emit LogActiveStatus(_status, now);
120     }
121     /*
122      * @dev     Same getWeek function as seen in main Etheraffle contract to 
123      *          ensure parity. Ddefined by number of weeks since Etheraffle's
124      *          birthday.
125      */
126     function getWeek() public view returns (uint) {
127         uint curWeek = (now - BIRTHDAY) / 604800;
128         if (now - ((curWeek * 604800) + BIRTHDAY) > RAFEND) curWeek++;
129         return curWeek;
130     }
131     /**
132      * @dev     ERC223 tokenFallback function allows to receive ERC223 tokens 
133      *          properly.
134      *
135      * @param _from  Address of the sender.
136      * @param _value Amount of deposited tokens.
137      * @param _data  Token transaction data.
138      */
139     function tokenFallback(address _from, uint256 _value, bytes _data) external {
140         if (_value > 0) emit LogTokenDeposit(_from, _value, _data);
141     }
142     /*
143      * @dev     Retrieves current LOT token balance of an address.
144      *
145      * @param _address Address whose balance is to be queried.
146      */
147     function getLOTBalance(address _address) internal view returns (uint) {
148         return LOTContract.balanceOf(_address);
149     }
150     /*
151      * @dev     Function returns bool re whether or not address in question 
152      *          has claimed promo LOT for the week in question.
153      *
154      * @param _address  Ethereum address to be queried
155      * @param _weekNo   Week number to be queried (use 0 for current week)
156      */
157     function hasRedeemed(address _address, uint _weekNo) public view returns (bool) {
158         uint week = _weekNo == 0 ? getWeek() : _weekNo;
159         return claimed[_address][week];
160     }
161     /*
162      * @dev     Returns current ticket price from the main Etheraffle
163      *          contract
164      */
165     function getTktPrice() public view returns (uint) {
166         return etheraffleContract.tktPrice();
167     }
168     /*
169      * @dev     Function returns current ICO tier's exchange rate of LOT
170      *          per ETH.
171      */
172     function getRate() public view returns (uint) {
173         if (now <  ICOSTART) return 110000 * 10 ** 6;
174         if (now <= TIER1END) return 100000 * 10 ** 6;
175         if (now <= TIER2END) return 90000  * 10 ** 6;
176         if (now <= TIER3END) return 80000  * 10 ** 6;
177         else return 0;
178     }
179     /*
180      * @dev     Returns number of promotional LOT earnt as calculated 
181      *          based on number of entries, current ICO exchange rate
182      *          and the current Etheraffle ticket price. 
183      */
184     function getPromoLOTEarnt(uint _entries) public view returns (uint) {
185         return (_entries * getRate() * getTktPrice()) / (1 * 10 ** 18);
186     }
187     /*
188      * @dev     Scuttles contract, sending any remaining LOT tokens back 
189      *          to the Etheraffle multisig (by whom it is only callable)
190      */
191     function scuttle() external onlyEtheraffle {
192         LOTContract.transfer(ETHERAFFLE, LOTContract.balanceOf(this));
193         selfdestruct(ETHERAFFLE);
194     }
195 }