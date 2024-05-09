1 pragma solidity^0.4.21;
2 
3 contract EtheraffleInterface {
4     uint public tktPrice;
5     function getUserNumEntries(address _entrant, uint _week) public view returns (uint) {}
6 }
7 
8 contract LOTInterface {
9     function transfer(address _to, uint _value) public {}
10     function balanceOf(address _owner) public view returns (uint) {}
11 }
12 /*
13  * @everyone    
14  *              Welcome to the ?????????? ??? ????? promotional contract!
15  *              First you should go and play ?????????? @ ?????://??????????.???
16  *              Then you'll have earnt free ??? ?????? via this very promotion!
17  *              Next you should learn about our ??? @ ?????://??????????.???/???
18  *              Then take part by buying even more ??? ??????! 
19  *              And don't forget to play ?????????? some more because it's brilliant!
20  *
21  *              If you want to chat to us you have loads of options:
22  *              On ???????? @ ?????://?.??/??????????
23  *              Or on ??????? @ ?????://???????.???/??????????
24  *              Or on ?????? @ ?????://??????????.??????.???
25  *
26  *              ?????????? - the only ????? ????????????? & ?????????? blockchain lottery.
27  */
28 contract EtheraffleLOTPromo {
29     
30     bool    public isActive;
31     uint    constant public RAFEND     = 500400;     // 7:00pm Saturdays
32     uint    constant public BIRTHDAY   = 1500249600; // Etheraffle's birthday <3
33     uint    constant public ICOSTART   = 1522281600; // Thur 29th March 2018
34     uint    constant public TIER1END   = 1523491200; // Thur 12th April 2018
35     uint    constant public TIER2END   = 1525305600; // Thur 3rd May 2018
36     uint    constant public TIER3END   = 1527724800; // Thur 31st May 2018
37     address constant public ETHERAFFLE = 0x97f535e98cf250CDd7Ff0cb9B29E4548b609A0bd;
38     
39     LOTInterface LOTContract;
40     EtheraffleInterface etheraffleContract;
41 
42     /* Mapping of  user address to weekNo to claimed bool */
43     mapping (address => mapping (uint => bool)) public claimed;
44     
45     event LogActiveStatus(bool currentStatus, uint atTime);
46     event LogTokenDeposit(address fromWhom, uint tokenAmount, bytes data);
47     event LogLOTClaim(address whom, uint howMany, uint inWeek, uint atTime);
48     /*
49      * @dev     Modifier requiring function caller to be the Etheraffle 
50      *          multisig wallet address
51      */
52     modifier onlyEtheraffle() {
53         require(msg.sender == ETHERAFFLE);
54         _;
55     }
56     /*
57      * @dev     Constructor - sets promo running and instantiates required
58      *          contracts.
59      */
60     function EtheraffleLOTPromo() public {
61         isActive           = true;
62         LOTContract        = LOTInterface(0xAfD9473dfe8a49567872f93c1790b74Ee7D92A9F);
63         etheraffleContract = EtheraffleInterface(0x4251139bF01D46884c95b27666C9E317DF68b876);
64     }
65     /*
66      * @dev     Function used to redeem promotional LOT owed. Use weekNo of 
67      *          0 to get current week number. Requires user not to have already 
68      *          claimed week number in question's earnt promo LOT and for promo 
69      *          to be active. It calculates LOT owed, and sends them to the 
70      *          caller. Should contract's LOT balance fall too low, attempts 
71      *          to redeem will arrest the contract to await a resupply of LOT.
72      */
73     function redeem(uint _weekNo) public {
74         uint week    = _weekNo == 0 ? getWeek() : _weekNo;
75         uint entries = getNumEntries(msg.sender, week);
76         require(
77             !claimed[msg.sender][week] &&
78             entries > 0 &&
79             isActive
80             );
81         uint amt = getPromoLOTEarnt(entries);
82         if (getLOTBalance(this) < amt) {
83             isActive = false;
84             emit LogActiveStatus(false, now);
85             return;
86         }
87         claimed[msg.sender][week] = true;
88         LOTContract.transfer(msg.sender, amt);
89         emit LogLOTClaim(msg.sender, amt, week, now);
90     }
91     /*
92      * @dev     Returns number of entries made in Etheraffle contract by
93      *          function caller in whatever the queried week is. 
94      *
95      * @param _address  Address to be queried
96      * @param _weekNo   Desired week number. (Use 0 for current week)
97      */
98     function getNumEntries(address _address, uint _weekNo) public view returns (uint) {
99         uint week = _weekNo == 0 ? getWeek() : _weekNo;
100         return etheraffleContract.getUserNumEntries(_address, week);
101     }
102     /*
103      * @dev     Toggles promo on & off. Only callable by the Etheraffle
104      *          multisig wallet.
105      *
106      * @param _status   Desired bool status of the promo
107      */
108     function togglePromo(bool _status) public onlyEtheraffle {
109         isActive = _status;
110         emit LogActiveStatus(_status, now);
111     }
112     /*
113      * @dev     Same getWeek function as seen in main Etheraffle contract to 
114      *          ensure parity. Ddefined by number of weeks since Etheraffle's
115      *          birthday.
116      */
117     function getWeek() public view returns (uint) {
118         uint curWeek = (now - BIRTHDAY) / 604800;
119         if (now - ((curWeek * 604800) + BIRTHDAY) > RAFEND) curWeek++;
120         return curWeek;
121     }
122     /**
123      * @dev     ERC223 tokenFallback function allows to receive ERC223 tokens 
124      *          properly.
125      *
126      * @param _from  Address of the sender.
127      * @param _value Amount of deposited tokens.
128      * @param _data  Token transaction data.
129      */
130     function tokenFallback(address _from, uint256 _value, bytes _data) external {
131         if (_value > 0) emit LogTokenDeposit(_from, _value, _data);
132     }
133     /*
134      * @dev     Retrieves current LOT token balance of an address.
135      *
136      * @param _address Address whose balance is to be queried.
137      */
138     function getLOTBalance(address _address) internal view returns (uint) {
139         return LOTContract.balanceOf(_address);
140     }
141     /*
142      * @dev     Function returns bool re whether or not address in question 
143      *          has claimed promo LOT for the week in question.
144      *
145      * @param _address  Ethereum address to be queried
146      * @param _weekNo   Week number to be queried (use 0 for current week)
147      */
148     function hasRedeemed(address _address, uint _weekNo) public view returns (bool) {
149         uint week = _weekNo == 0 ? getWeek() : _weekNo;
150         return claimed[_address][week];
151     }
152     /*
153      * @dev     Returns current ticket price from the main Etheraffle
154      *          contract
155      */
156     function getTktPrice() public view returns (uint) {
157         return etheraffleContract.tktPrice();
158     }
159     /*
160      * @dev     Function returns current ICO tier's exchange rate of LOT
161      *          per ETH.
162      */
163     function getRate() public view returns (uint) {
164         if (now <  ICOSTART) return 110000 * 10 ** 6;
165         if (now <= TIER1END) return 100000 * 10 ** 6;
166         if (now <= TIER2END) return 90000  * 10 ** 6;
167         if (now <= TIER3END) return 80000  * 10 ** 6;
168         else return 0;
169     }
170     /*
171      * @dev     Returns number of promotional LOT earnt as calculated 
172      *          based on number of entries, current ICO exchange rate
173      *          and the current Etheraffle ticket price. 
174      */
175     function getPromoLOTEarnt(uint _entries) public view returns (uint) {
176         return (_entries * getRate() * getTktPrice()) / (1 * 10 ** 18);
177     }
178     /*
179      * @dev     Scuttles contract, sending any remaining LOT tokens back 
180      *          to the Etheraffle multisig (by whom it is only callable)
181      */
182     function scuttle() external onlyEtheraffle {
183         LOTContract.transfer(ETHERAFFLE, LOTContract.balanceOf(this));
184         selfdestruct(ETHERAFFLE);
185     }
186 }