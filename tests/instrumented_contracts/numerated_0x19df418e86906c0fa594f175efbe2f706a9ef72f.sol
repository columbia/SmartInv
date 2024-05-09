1 /*----------------------------------------------------------------------------------------------------------
2                              Ethpixel - Ethereum based collaborative pixel art
3                              
4                                         Official site: ethpixel.io
5                                   Join us on Telegram: t.me/ethpixel
6 ----------------------------------------------------------------------------------------------------------*/
7 
8 pragma solidity >=0.5.0 <0.6.0;
9 
10 contract EthPixel {
11 
12     /*------------------------------------------------------------------------------------------------------
13         * Variables
14     ------------------------------------------------------------------------------------------------------*/
15     /* Pixel attributes */
16     struct Pixel {                                  // Should fit into 256 bits
17         address owner;                              //                 160
18         uint8   color;                              //                +  8
19         uint88  price;                              //                + 88
20     }
21     
22     /* Player attributes */
23     struct Player {
24         uint32 holding;                             // Number of pixels the player owns
25         uint96 sub_total;
26         uint96 one_pixel_value_offset;
27     }
28     
29     mapping(uint    => Pixel)  canvas;              // The playing field
30     mapping(address => Player) players;             // Players
31     
32     /* Parameters */
33     uint32 constant width                = 400;             // Canvas width, 400 px
34     uint32 constant height               = 400;             // Canvas height, 400 px
35     uint88 constant new_price            =   0.0005 ether;  // Unmodified price of newly sold pixels
36     uint96 constant increment_percentage = 135;             // Increment in units of 1/100
37     uint96 constant pot_percentage       =  40;             // Purchase price percentage going to pot
38     uint96 constant payout_percentage    =  50;             // Purchase price percentage going to payout
39     uint96 constant revenue_percentage   =  80;             // Purchase price percentage going to previous owner
40     uint96 constant dev_percentage       =   2;             // Purchase price percentage going to developers
41     uint32 constant time_increment       =  60 seconds;     // Expiration deadline increment
42     
43     /* number of pixels */
44     uint32 constant playing_field = width * height;
45     
46     /* State variables */
47     uint32 public expiration;                       // End of the game unix timestamp
48     uint32 public sold_pixels;                      // Number of sold visible pixels
49     uint96 public pot;                              // Total pot to be divided between the last buyer and the most pixel owner
50     uint96 public payout;                           // Total payout to be divided between all pixel owners
51     
52     uint96 public revenues;                         // Pixel owner revenues resulting from pixel purchases and referrals
53     uint96 public one_pixel_value;
54     uint96 public withdrawals;                      // Total amount withdrawn so far by pixel owners
55     
56     bool last_buyer_cashed_out = false;
57     bool biggest_holder_cashed_out = false;
58     
59     address payable public last_buyer;              // Last buyer address
60     address payable public biggest_holder;          // Most pixel owner address
61     
62     address payable dev_account;
63     
64     /*------------------------------------------------------------------------------------------------------
65         * Events that will be emitted on changes
66     ------------------------------------------------------------------------------------------------------*/
67     event PixelBought(uint _index, address _owner, uint _color, uint _price);
68     event NewConditions(uint _expiration, uint _sold_pixels, uint _pot, uint _payout, address _last_buyer, uint32 _totalBuy, address _sender);
69     /*------------------------------------------------------------------------------------------------------
70         * Initialization of a new game
71     ------------------------------------------------------------------------------------------------------*/
72     constructor() public {
73         require(pot_percentage + payout_percentage <= 100, "revert1");
74         require(increment_percentage >= 100, "revert2");
75         require(revenue_percentage * increment_percentage >= 10000, "revert3");
76         require(revenue_percentage + dev_percentage <= 100, "revert4");
77         
78         dev_account = msg.sender;
79         expiration = uint32(now) + 1 days;
80         biggest_holder = dev_account;
81     }
82     /*------------------------------------------------------------------------------------------------------
83         * External functions
84     ------------------------------------------------------------------------------------------------------*/
85     /* Is the game still going? */
86     function isGameGoing() external view returns (bool _gameIsGoing) {
87         return (now < expiration);
88     }
89     
90     /* Get information of one particular pixel */
91     function getPixel(uint _index) external view returns (address owner, uint color, uint price) {
92         if (canvas[_index].price == 0) return (address(0),           0,                    new_price);
93         else                           return (canvas[_index].owner, canvas[_index].color, canvas[_index].price);
94     }
95     
96     /* Get information of a pixel array, starting from _indexFrom, at _len length */
97     function getPixel(uint _indexFrom, uint _len) external view returns (address[] memory owner, uint[] memory color, uint[] memory price) {
98         address[] memory _owner = new address[](_len);
99         uint[] memory _color = new uint[](_len);
100         uint[] memory _price = new uint[](_len);
101         uint counter = 0;
102         uint iLen = _indexFrom + _len;
103         for (uint i = _indexFrom; i < iLen; i++) {
104             if (canvas[i].price == 0) {_owner[counter] = address(0);      _color[counter] = 0;               _price[counter] = new_price;      } 
105             else                      {_owner[counter] = canvas[i].owner; _color[counter] = canvas[i].color; _price[counter] = canvas[i].price;}
106             counter++; 
107         }
108         return (_owner, _color, _price);
109     }
110     
111     /* Get color of every pixel super fast */
112     function getColor() external view returns (uint[] memory color) {
113         uint[] memory _color = new uint[](playing_field / 32);
114         uint temp;
115         for (uint i = 0; i < (playing_field / 32); i++) {
116             temp = 0;
117             for (uint j = 0; j < 32; j++) {
118                 temp += uint(canvas[i * 32 + j].color) << (8 * j);
119             }
120             _color[i] = temp;
121         }
122         return (_color);
123     }
124     
125     /* Get price and owner of every pixel in a bandwidth saving way */
126     function getPriceOwner(uint _index, uint _len) external view returns (uint[] memory) {
127         uint[] memory result = new uint[](_len);
128         for (uint i = 0; i < _len; i++) {
129             if (canvas[_index + i].price == 0) result[i] = new_price;
130             else result[i] = (uint256(canvas[_index + i].owner) << 96) + canvas[_index + i].price;
131         }
132         return result;
133     }
134     
135     /* Number of pixels of a player */
136     function getHoldingOf(address _address) external view returns(uint32 _holding) {
137         return players[_address].holding;
138     }
139     
140     /* My balance */
141     function getBalanceOf(address _address) external view returns(uint96 _value) {
142         require(_address == msg.sender, "revert5");
143         return players[_address].sub_total + players[_address].holding * (one_pixel_value - players[_address].one_pixel_value_offset);
144     }
145     /*------------------------------------------------------------------------------------------------------
146         * Private functions
147     ------------------------------------------------------------------------------------------------------*/
148     /* Update pixel information */
149     function putPixel(uint _index, address _owner, uint8 _color, uint88 _price) private {
150         canvas[_index].owner = _owner;
151         canvas[_index].color = _color;
152         canvas[_index].price = _price;
153     }
154     
155     /* Update player information */
156     function putPlayer(address _player, uint32 _holding, uint96 _sub_total, uint96 _one_pixel_value_offset) private {
157         players[_player].holding                = _holding;
158         players[_player].sub_total              = _sub_total;
159         players[_player].one_pixel_value_offset = _one_pixel_value_offset;
160     }
161     
162     function putStateVariables(
163         uint32 _expiration,
164         uint32 _sold_pixels,
165         uint96 _pot,
166         uint96 _payout,
167         uint96 _revenues,
168         uint96 _one_pixel_value
169     )
170         private
171     {
172         expiration      = _expiration;
173         sold_pixels     = _sold_pixels;
174         pot             = _pot;
175         payout          = _payout;
176         revenues        = _revenues;
177         one_pixel_value = _one_pixel_value;
178     }
179     
180     function balanceOf(address _address) private view returns(uint96 _value) {
181         return players[_address].sub_total + players[_address].holding * (one_pixel_value - players[_address].one_pixel_value_offset);
182     }
183     /*------------------------------------------------------------------------------------------------------
184         * Public functions
185     ------------------------------------------------------------------------------------------------------*/
186     /* Purchase pixel */
187     function buy(uint[] memory _index, uint8[] memory _color, uint[] memory _price, address _referrar) public payable {
188         require(now < expiration, "revert8");                   // Is the game still going?
189         require(_index.length == _color.length, "revert9");
190         require(_index.length == _price.length, "revert10");
191         
192         uint96 spendETH         = 0;
193         uint32 f_sold_pixels    = 0;
194         uint32 f_holding        = 0;
195         uint96 f_sub_total      = 0;
196         uint96 f_revenues       = 0;
197         uint96 increase         = 0;
198         uint32 totalBuy         = 0;
199         uint96 pixel_price;
200 
201         for(uint i = 0; i < _index.length; i++) {
202             if(_index[i] >= playing_field) continue;            // Must be a valid pixel
203             
204             address previous_owner = canvas[_index[i]].owner;
205             /* New pixel */
206             if(previous_owner == address(0)) {
207                 pixel_price = new_price;
208                 if(pixel_price != _price[i]) continue;
209                 if((spendETH + pixel_price) > msg.value) continue;
210                 spendETH += pixel_price;
211                 
212                 increase += pixel_price;
213                 f_sold_pixels++;
214                 f_holding++;
215             }
216             
217             /* Existing pixel */
218             else {
219                 pixel_price = canvas[_index[i]].price;
220                 if(pixel_price != _price[i]) continue;
221                 if((spendETH + pixel_price) > msg.value) continue;
222                 spendETH += pixel_price;
223                 
224                 uint96 to_previous_owner = (pixel_price * revenue_percentage) / 100;
225                 f_revenues += to_previous_owner;
226                 increase += pixel_price - to_previous_owner - ((pixel_price * dev_percentage) / 100);
227                 
228                 /* normal purchase */
229                 if(previous_owner != msg.sender) {
230                     f_holding++;
231                     putPlayer(previous_owner, players[previous_owner].holding - 1, balanceOf(previous_owner) + to_previous_owner, one_pixel_value);
232                 }
233                 /* self purchase */
234                 else f_sub_total += to_previous_owner;
235             }
236             
237             totalBuy++;
238             pixel_price = (pixel_price * increment_percentage) / 100;
239             putPixel(_index[i], msg.sender, _color[i], uint88(pixel_price));
240             emit PixelBought(_index[i], msg.sender, _color[i], pixel_price);
241         }
242         
243         /* Player */
244         if(spendETH < uint96(msg.value)) {
245             f_sub_total += uint96(msg.value) - spendETH;   // Add remaining ether to user balance
246         }
247         putPlayer(msg.sender, players[msg.sender].holding + f_holding, balanceOf(msg.sender) + f_sub_total, one_pixel_value);
248         
249         if(totalBuy != 0) {
250             /* Referral bonus */
251             uint96 f_payout = (increase * payout_percentage) / 100;
252             uint96 f_pot;
253             if((players[_referrar].holding > 0) && (_referrar != msg.sender)) {
254                 f_pot = (increase * pot_percentage) / 100;
255                 uint96 referral_bonus = increase - f_payout - f_pot;
256                 /* Pay referrar */
257                 f_revenues += referral_bonus;
258                 players[_referrar].sub_total += referral_bonus;
259             }
260             else f_pot = increase - f_payout;             // If no referrar, bonus goes to the pot
261             
262             /* One pixel value */
263             uint96 f_one_pixel_value = f_payout / (sold_pixels + f_sold_pixels);
264             
265             /* Add more time, capped at 24h */
266             uint32 maxExpiration = uint32(now) + 1 days;
267             uint32 f_expiration = expiration + (totalBuy * time_increment);
268             if (f_expiration > maxExpiration) f_expiration = maxExpiration;
269             
270             /* Update state variables */
271             f_sold_pixels += sold_pixels;
272             f_pot += pot;
273             f_payout += payout;
274             f_revenues += revenues;
275             f_one_pixel_value += one_pixel_value;
276             putStateVariables(
277                 f_expiration,
278                 f_sold_pixels,
279                 f_pot,
280                 f_payout,
281                 f_revenues,
282                 f_one_pixel_value
283             );
284             
285             if(last_buyer != msg.sender) last_buyer = msg.sender;
286         }
287         
288         emit NewConditions(expiration, sold_pixels, pot, payout, last_buyer, totalBuy, msg.sender);
289     }
290     /*------------------------------------------------------------------------------------------------------
291         * Withdrawals
292     ------------------------------------------------------------------------------------------------------*/
293     modifier notFinalDeadline() {
294         require(now < expiration + 365 days, "revert9");
295         _;
296     }
297     
298     /* Player withdrawals */
299     function withdraw() public notFinalDeadline {
300         uint96 amount = balanceOf(msg.sender);
301         putPlayer(msg.sender, players[msg.sender].holding, 0, one_pixel_value);
302         withdrawals += amount;
303         msg.sender.transfer(amount);
304     }
305     
306     /* Developer withdrawals */
307     function dev_withdrawal(uint96 _amount) public {
308         require(msg.sender == dev_account);
309         
310         uint ether_paid = address(this).balance + withdrawals;
311         uint ether_used = payout + pot + revenues;
312         uint max = ether_paid - ether_used;
313         require(_amount <= max, "revert10");
314         dev_account.transfer(_amount);
315     }
316     
317     function final_dev_withdrawal() public {
318         require(now > expiration + 365 days, "revert11");
319         require(msg.sender == dev_account);
320         dev_account.transfer(address(this).balance);
321     }
322     /*------------------------------------------------------------------------------------------------------
323         * Awards
324     ------------------------------------------------------------------------------------------------------*/
325     /* Update the most pixel holder */
326     function update_biggest_holder(address payable _address) public notFinalDeadline returns(address _biggest_holder) {
327         require(biggest_holder != address(0));
328         if (players[_address].holding > players[biggest_holder].holding) biggest_holder = _address;
329         return biggest_holder;
330     }
331     
332     /* Awards */
333     function award_last_buyer() public notFinalDeadline {
334         require(now > expiration);
335         require(last_buyer_cashed_out == false);
336         
337         last_buyer_cashed_out = true;
338         uint96 half_award = pot / 2;
339         withdrawals += half_award;
340         last_buyer.transfer(half_award);
341     }
342     
343     function award_biggest_holder() public notFinalDeadline {
344         /* Biggest holder can cash out earliest 1 week after the game ends. */
345         /* This 1 week period is there to give enough time to update_biggest_holder() */
346         require(now > expiration + 7 days);
347         require(biggest_holder_cashed_out == false);
348 
349         biggest_holder_cashed_out = true;
350         uint96 half_award = pot / 2;
351         withdrawals += half_award;
352         biggest_holder.transfer(half_award);
353     }
354 }