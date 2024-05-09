1 pragma solidity ^0.4.24;
2 
3 
4 contract fortunes {
5     
6     string public standard = 'Fortunes';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     
11     address owner;
12     uint public max_fortunes;
13     uint public unopened_bid;
14     bytes32[] public ur_luck;                      // store lucky say
15     
16     struct fortune {
17         address original_owner;                     // one who opened
18         address original_minter;                    // one who marked
19         address current_owner;
20         uint32 number;
21         uint8 level;
22         bytes32[144] img;
23         bytes32 str_luck;                           // 32 char max luck
24         bytes32 str_name;                           // 32 char max name
25         bool has_img;   
26         bool opened;                                // opened has set the lvl and luck
27         bool forsale;                       
28         uint current_bid;
29         address current_bidder;
30         uint bid_cnt;                               // times bid on this sale
31         uint auction_end;                           // time to end the auction
32     }
33     
34     fortune[] public fortune_arr;                   // fortunes cannot be deleted
35     mapping(uint8 => uint8) public lvl_count;       // cnt each lvl fortunes
36     mapping(address => uint) public pending_pay;    // pending withdrawals
37     
38     uint tax;
39 	uint public fortune_limitbreak;				    // current limitbreak ammount
40 	uint public fortune_break_current;				// current ammount of ether for limitbreak
41     
42     
43     modifier only_owner() 
44         { require(msg.sender == owner, "only owner can call."); _; }
45     modifier only_currowner(uint _idx) 
46         { require(fortune_arr[_idx].current_owner == msg.sender, "you're not the owner"); _; }
47     modifier idx_inrange(uint _idx)
48         { require(_idx >= 0 && _idx < fortune_arr.length, "idx out of range"); _; }
49         
50         
51     constructor() public {
52         owner = (msg.sender);
53         max_fortunes = 5000;
54         unopened_bid = 0.014 ether;
55         tax = 50; // N/25 = 4% 
56 		fortune_limitbreak = 2 ether;
57         
58         name = "FORTUNES";
59         symbol = "4TN";
60         decimals = 0;
61         
62         // initial luck
63         ur_luck.push("The WORST Possible");
64         ur_luck.push("Terrible");
65         ur_luck.push("Bad");
66         ur_luck.push("Exactly Average");
67         ur_luck.push("Good");
68         ur_luck.push("Excellent");
69         ur_luck.push("The BEST Possible");
70     }
71     
72     function is_owned(uint _idx) public view idx_inrange(_idx) returns(bool) 
73         { return msg.sender == fortune_arr[_idx].current_owner; }
74 	
75     function ret_len() public view returns(uint) { return fortune_arr.length; }
76     
77     function ret_luklen () public view returns(uint) { return ur_luck.length; }
78     
79 	function ret_img(uint _idx) public idx_inrange(_idx) view returns(bytes32[144]) {
80 		return fortune_arr[_idx].img;
81 	}
82     
83     function fortune_new() public payable {
84 		require(msg.value >= unopened_bid || 
85 		        msg.sender == owner || 
86 		        fortune_arr.length <= 500, 
87 		        "ammount below unopened bid");
88         require(fortune_arr.length <= max_fortunes,"fortunes max reached");
89         fortune memory x;
90         x.current_owner = msg.sender;
91 		x.number = uint32(fortune_arr.length);
92 		unopened_bid += unopened_bid/1000; // 0.01% increase
93         fortune_arr.push(x);
94         pending_pay[owner]+= msg.value;
95         emit event_new(fortune_arr.length-1);
96     }
97     
98     function fortune_open(uint _idx) public idx_inrange(_idx) only_currowner(_idx) {
99         require(!fortune_arr[_idx].opened, "fortune is already open");
100         require(!fortune_arr[_idx].forsale, "fortune is selling");
101         fortune_arr[_idx].original_owner = msg.sender;
102         uint _ran = arand(fortune_arr[_idx].current_owner, now)%1000;
103         uint8 clvl = 1;
104         if (_ran <= 810) clvl = 2;
105         if (_ran <= 648) clvl = 3;
106         if (_ran <= 504) clvl = 4;
107         if (_ran <= 378) clvl = 5;
108         if (_ran <= 270) clvl = 6;
109         if (_ran <= 180) clvl = 7;
110         if (_ran <= 108) clvl = 8;
111         if (_ran <= 54)  clvl = 9;
112         if (_ran <= 18)  clvl = 10;
113 
114         fortune_arr[_idx].level = clvl;
115         fortune_arr[_idx].opened = true;
116         fortune_arr[_idx].str_luck = 
117             ur_luck[arand(fortune_arr[_idx].current_owner, now)% ur_luck.length];
118         
119         // first fortune in honor of mai waifu
120         if(_idx == 0) {
121             fortune_arr[_idx].level = 0;
122             fortune_arr[_idx].str_luck = ur_luck[6];
123             lvl_count[0] += 1;
124         } else lvl_count[clvl] += 1;    
125         emit event_open(_idx);
126     }
127     
128     // mint fortune
129     function fortune_setimgnme(uint _idx, bytes32[144] _imgarr, bytes32 _nme) 
130         public idx_inrange(_idx) only_currowner(_idx) {
131         require(fortune_arr[_idx].opened, "fortune has to be opened");
132         require(!fortune_arr[_idx].has_img, "image cant be reset");
133         require(!fortune_arr[_idx].forsale, "fortune is selling");
134         fortune_arr[_idx].original_minter = fortune_arr[_idx].current_owner;
135         for(uint i = 0; i < 144; i++)
136             fortune_arr[_idx].img[i] = _imgarr[i];
137         fortune_arr[_idx].str_name = _nme;
138         emit event_mint(_idx);
139         fortune_arr[_idx].has_img = true;
140     }
141     
142     // start auction
143     function fortune_sell(uint _idx, uint basebid, uint endt) 
144         public idx_inrange(_idx) only_currowner(_idx) {
145         require(_idx > 0, "I'll always be here with you.");
146         require(!fortune_arr[_idx].forsale, "already selling");
147         require(endt <= 7 days, "auction time too long");
148         fortune_arr[_idx].current_bid = basebid;
149         fortune_arr[_idx].auction_end = now + endt;
150         fortune_arr[_idx].forsale = true;
151         emit event_sale(_idx);
152     }
153     
154     // bid auction
155     function fortune_bid(uint _idx) public payable idx_inrange(_idx) {
156         require(fortune_arr[_idx].forsale, "fortune not for sale");
157         require(now < fortune_arr[_idx].auction_end, "auction ended");
158         require(msg.value > fortune_arr[_idx].current_bid, 
159             "new bid has to be higher than current");
160 
161         // return the previous bid        
162         if(fortune_arr[_idx].bid_cnt != 0) 
163             pending_pay[fortune_arr[_idx].current_bidder] += 
164                 fortune_arr[_idx].current_bid;
165         
166         fortune_arr[_idx].current_bid = msg.value;
167         fortune_arr[_idx].current_bidder = msg.sender;
168         fortune_arr[_idx].bid_cnt += 1;
169         emit event_bids(_idx);
170     }
171     
172     // end auction
173     function fortune_endauction(uint _idx) public idx_inrange(_idx) {
174         require(now >= fortune_arr[_idx].auction_end,"auction is still going");
175         require(fortune_arr[_idx].forsale, "fortune not for sale");
176         
177         // sale
178         if(fortune_arr[_idx].bid_cnt > 0) {
179     		uint ntax = fortune_arr[_idx].current_bid/tax;              // 2%
180     		uint otax = fortune_arr[_idx].current_bid/tax;               // 2% 
181     		uint ftax = ntax;
182 
183             pending_pay[owner] += ntax;
184     		if(fortune_arr[_idx].opened) { 
185     		    ftax+= otax; 
186     		    pending_pay[fortune_arr[_idx].original_owner] += otax; 
187     		}                  
188     		if(fortune_arr[_idx].has_img) { 
189     		    ftax+= otax; 
190     		    pending_pay[fortune_arr[_idx].original_minter] += otax; 
191     		}             
192     		pending_pay[fortune_arr[_idx].current_owner] += 
193                 fortune_arr[_idx].current_bid-ftax; 
194                 
195             fortune_arr[_idx].current_owner = 
196                 fortune_arr[_idx].current_bidder;
197             emit event_sold(_idx, fortune_arr[_idx].current_owner);
198         }
199         
200         // reset bid
201         // current bid doesnt reset to save last sold price
202         fortune_arr[_idx].forsale = false;
203         fortune_arr[_idx].current_bidder = 0;
204         fortune_arr[_idx].bid_cnt = 0;
205         fortune_arr[_idx].auction_end = 0;
206     }
207     
208     
209     function withdraw() public {
210         require(pending_pay[msg.sender]>0, "insufficient funds");
211         uint _pay = pending_pay[msg.sender];
212         pending_pay[msg.sender] = 0;
213         msg.sender.transfer(_pay);
214         emit event_withdraw(msg.sender, _pay);
215     }
216     
217     function add_luck(bytes32 _nmsg) public payable {
218         require(msg.value >= unopened_bid, 
219             "adding a fortune label costs the unopened_bid eth");
220         ur_luck.push(_nmsg);
221         pending_pay[owner] += msg.value;
222         emit event_addluck(msg.sender);
223     } 
224     
225     function limitbreak_contrib() public payable {
226 		fortune_break_current += msg.value;
227 		emit event_limitbreak_contrib(msg.sender, msg.value);
228 	}
229 	
230     function limitbreak_RELEASE() public {
231 		require(fortune_break_current >= fortune_limitbreak, 
232 			"limit breaking takes a few hits more");
233 		require(fortune_arr.length >= max_fortunes, "limit not reached yet");
234         max_fortunes += max_fortunes + 500;
235 		pending_pay[owner]+= fortune_break_current;
236 		fortune_break_current = 0;
237 		if(fortune_limitbreak >= 128 ether) fortune_limitbreak = 32 ether;
238 		else fortune_limitbreak *= 2;
239 		emit event_limitbreak(fortune_limitbreak);
240     }
241     
242     
243     function arand(address _addr, uint seed) internal view returns(uint) {
244         return uint
245             (keccak256
246                 (abi.encodePacked(blockhash(block.number-1), seed, uint(_addr))));
247     }
248     
249     // erc20 semi 
250     function totalSupply() public constant returns (uint) { return max_fortunes; }
251     function balanceOf(address tokenOwner) public constant returns (uint balance)
252         { return pending_pay[tokenOwner]; }
253         
254     function giveTo(uint _idx, address _addr) public idx_inrange(_idx) only_currowner(_idx) {
255         fortune_arr[_idx].current_owner = _addr;
256     }
257     
258     
259     // events
260     event event_new(uint _idx);                                     //[x]
261     event event_open(uint _idx);                                    //[x]
262     event event_mint(uint _idx);                                    //[x]
263     event event_sale(uint _idx);                                    //[x]
264     event event_bids(uint _idx);                                    //[x]
265     event event_sold(uint _idx, address _newowner);                 //[x]
266     event event_addluck(address _addr);                             //[x]
267     event event_limitbreak(uint newlimit);                          //[x]
268     event event_limitbreak_contrib(address _addr, uint _ammount);   //[x]
269     event event_withdraw(address _addr, uint _ammount);             //[x]
270 
271 }