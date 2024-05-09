1 pragma solidity^0.4.21;
2 /*
3  *      ##########################################
4  *      ##########################################
5  *      ###                                    ###
6  *      ###          ???? & ??? ?????          ###
7  *      ###                 at                 ###
8  *      ###          ??????????.???          ###
9  *      ###                                    ###
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
46     address constant public ETHERAFFLE = 0x97f535e98cf250CDd7Ff0cb9B29E4548b609A0bd; // ER multisig wallet address
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
68      *
69      * @param _LOT      Address of the LOT token contract
70      * @param _ER       Address of the Etheraffle contract
71      */
72     function EtheraffleLOTPromo(address _LOT, address _ER) public {
73         isActive           = true;
74         LOTContract        = LOTInterface(_LOT);
75         etheraffleContract = EtheraffleInterface(_ER);
76     }
77     
78     /*
79      * @dev     Function used to redeem promotional LOT owed. Use weekNo of 
80      *          0 to get current week number. Requires user not to have already 
81      *          claimed week number in question's earnt promo LOT and for promo 
82      *          to be active. It calculates LOT owed, and sends them to the 
83      *          caller. Should contract's LOT balance fall too low, attempts 
84      *          to redeem will arrest the contract to await a resupply of LOT.
85      */
86     function redeem(uint _weekNo) public {
87         uint week    = _weekNo == 0 ? getWeek() : _weekNo;
88         uint entries = getNumEntries(msg.sender, week);
89         require(
90             !claimed[msg.sender][week] &&
91             entries > 0 &&
92             isActive
93             );
94         uint amt = getPromoLOTEarnt(entries);
95         if (getLOTBalance(this) < amt) {
96             isActive = false;
97             emit LogActiveStatus(false, now);
98             return;
99         }
100         claimed[msg.sender][week] = true;
101         LOTContract.transfer(msg.sender, amt);
102         emit LogLOTClaim(msg.sender, amt, week, now);
103     }
104     /*
105      * @dev     Returns number of entries made in Etheraffle contract by
106      *          function caller in whatever the queried week is. 
107      *
108      * @param _address  Address to be queried
109      * @param _weekNo   Desired week number. (Use 0 for current week)
110      */
111     function getNumEntries(address _address, uint _weekNo) public view returns (uint) {
112         uint week = _weekNo == 0 ? getWeek() : _weekNo;
113         return etheraffleContract.getUserNumEntries(_address, week);
114     }
115     /*
116      * @dev     Toggles promo on & off. Only callable by the Etheraffle
117      *          multisig wallet.
118      *
119      * @param _status   Desired bool status of the promo
120      */
121     function togglePromo(bool _status) public onlyEtheraffle {
122         isActive = _status;
123         emit LogActiveStatus(_status, now);
124     }
125     /*
126      * @dev     Same getWeek function as seen in main Etheraffle contract to 
127      *          ensure parity. Ddefined by number of weeks since Etheraffle's
128      *          birthday.
129      */
130     function getWeek() public view returns (uint) {
131         uint curWeek = (now - BIRTHDAY) / 604800;
132         if (now - ((curWeek * 604800) + BIRTHDAY) > RAFEND) curWeek++;
133         return curWeek;
134     }
135     /**
136      * @dev     ERC223 tokenFallback function allows to receive ERC223 tokens 
137      *          properly.
138      *
139      * @param _from  Address of the sender.
140      * @param _value Amount of deposited tokens.
141      * @param _data  Token transaction data.
142      */
143     function tokenFallback(address _from, uint256 _value, bytes _data) external {
144         if (_value > 0) emit LogTokenDeposit(_from, _value, _data);
145     }
146     /*
147      * @dev     Retrieves current LOT token balance of an address.
148      *
149      * @param _address Address whose balance is to be queried.
150      */
151     function getLOTBalance(address _address) internal view returns (uint) {
152         return LOTContract.balanceOf(_address);
153     }
154     /*
155      * @dev     Function returns bool re whether or not address in question 
156      *          has claimed promo LOT for the week in question.
157      *
158      * @param _address  Ethereum address to be queried
159      * @param _weekNo   Week number to be queried (use 0 for current week)
160      */
161     function hasRedeemed(address _address, uint _weekNo) public view returns (bool) {
162         uint week = _weekNo == 0 ? getWeek() : _weekNo;
163         return claimed[_address][week];
164     }
165     /*
166      * @dev     Returns current ticket price from the main Etheraffle
167      *          contract
168      */
169     function getTktPrice() public view returns (uint) {
170         return etheraffleContract.tktPrice();
171     }
172     /*
173      * @dev     Function returns current ICO tier's exchange rate of LOT
174      *          per ETH.
175      */
176     function getRate() public view returns (uint) {
177         if (now <  ICOSTART) return 110000 * 10 ** 6;
178         if (now <= TIER1END) return 100000 * 10 ** 6;
179         if (now <= TIER2END) return 90000  * 10 ** 6;
180         if (now <= TIER3END) return 80000  * 10 ** 6;
181         else return 0;
182     }
183     /*
184      * @dev     Returns number of promotional LOT earnt as calculated 
185      *          based on number of entries, current ICO exchange rate
186      *          and the current Etheraffle ticket price. 
187      */
188     function getPromoLOTEarnt(uint _entries) public view returns (uint) {
189         return (_entries * getRate() * getTktPrice()) / (1 * 10 ** 18);
190     }
191     /*
192      * @dev     Allows contract addresses to be changed in the event of 
193      *          future contract upgrades.
194      *
195      * @param _LOT      Address of the LOT token contract
196      * @param _ER       Address of the Etheraffle contract
197      */
198     function updateAddresses(address _LOT, address _ER) external onlyEtheraffle {
199         LOTContract        = LOTInterface(_LOT);
200         etheraffleContract = EtheraffleInterface(_ER);
201     }
202     /*
203      * @dev     Scuttles contract, sending any remaining LOT tokens back 
204      *          to the Etheraffle multisig (by whom it is only callable)
205      */
206     function scuttle() external onlyEtheraffle {
207         LOTContract.transfer(ETHERAFFLE, LOTContract.balanceOf(this));
208         selfdestruct(ETHERAFFLE);
209     }
210 }