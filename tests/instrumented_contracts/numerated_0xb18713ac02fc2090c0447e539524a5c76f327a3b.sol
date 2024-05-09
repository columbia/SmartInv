1 pragma solidity ^0.4.20;
2 
3 // 😸 WWW.SWAP.CAT 😸
4 //
5 // a simple DEX for fixed price token offers directly from wallet to wallet
6 //
7 // users can set up erc20 tokens for sale for any other erc20
8 //
9 // funds stay in users wallets, dex contract gets a spending allowance
10 //
11 // payments go directly into the sellers wallet
12 //
13 // this DEX takes no fees
14 //
15 // mostly useful to provide stablecoin liquidity or sell tokens for a premium
16 //
17 // offers have to be adjusted by the user if prices change
18 //
19 
20 
21 
22 
23 // we need the erc20 interface to access the tokens details
24 
25 interface IERC20 {
26     function balanceOf(address account) external view returns (uint256);
27     function allowance(address owner, address spender) external view returns (uint256);
28     // no return value on transfer and transferFrom to tolerate old erc20 tokens
29     // we work around that in the buy function by checking balance twice
30     function transferFrom(address sender, address recipient, uint256 amount) external;
31     function transfer(address to, uint256 amount) external;
32     function decimals() external view returns (uint256);
33     function symbol() external view returns (string);
34     function name() external view returns (string);
35 
36 }
37 
38 
39 
40 
41 
42 contract SWAPCAT {
43 
44 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
45 // lets make mappings to store offer data
46 
47     mapping (uint24 => uint256) internal price;
48     mapping (uint24 => address) internal offertoken;
49     mapping (uint24 => address) internal buyertoken;
50     mapping (uint24 => address) internal seller;
51     uint24 internal offercount;
52 
53 
54 // admin address, receives donations and can move stuck funds, nothing else    
55     address internal admin = 0xc965E082B0082449047501032F0E9e7F3DC5Cc12;
56 
57 
58 
59 
60 
61 
62 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
63 // set up your erc20 offer. give token addresses and the price in baseunits
64 // to change a price simply call this again with the changed price + offerid
65 
66 function makeoffer(address _offertoken, address _buyertoken, uint256 _price, uint24 _offerid) public returns (uint24) {
67 
68 // if no offerid is given a new offer is made, if offerid is given only the offers price is changed if owner matches
69         if(_offerid==0)
70                     {
71                     _offerid=offercount;
72                     offercount++;seller[_offerid]=msg.sender;
73                     offertoken[_offerid]=_offertoken;
74                     buyertoken[_offerid]=_buyertoken;
75                     }
76                     else
77                     {
78                     require(seller[_offerid]==msg.sender,"only original seller can change offer!");
79                     }
80         price[_offerid]=_price;
81 
82 // returns the offerid
83         return _offerid;
84     }
85 //
86 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
87 
88 
89 
90 
91 
92 
93 
94 
95 
96 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
97 // delete an offer
98 
99 function deleteoffer(uint24 _offerid) public returns (string) {
100         require(seller[_offerid]==msg.sender,"only original seller can change offer!");
101         delete seller[_offerid];
102         delete offertoken[_offerid];
103         delete buyertoken[_offerid];
104         delete price[_offerid];
105         return "offer deleted";
106     }
107 //
108 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
109 
110 
111 
112 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
113 // return the total number of offers to loop through all offers
114 // its the web frontends job to keep track of offers
115 
116 function getoffercount() public view returns (uint24){ return offercount-1;}
117 
118 //
119 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
120 
121 
122 
123 
124 
125 
126 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
127 // get a tokens name, symbol and decimals 
128 
129     function tokeninfo(address _tokenaddr) public view returns (uint256, string, string) {
130         IERC20 tokeni = IERC20(_tokenaddr);
131         return (tokeni.decimals(),tokeni.symbol(),tokeni.name());
132         }   
133 //
134 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
147 // get a single offers details
148 
149     function showoffer(uint24 _offerid) public view returns (address, address, address, uint256, uint256) {
150         
151 
152         IERC20 offertokeni = IERC20(offertoken[_offerid]);
153 
154 
155 // get offertokens balance and allowance, whichever is lower is the available amount        
156         uint256 availablebalance = offertokeni.balanceOf(seller[_offerid]);
157         uint256 availableallow = offertokeni.allowance(seller[_offerid],address(this));
158 
159         if(availableallow<availablebalance){availablebalance = availableallow;}
160 
161         return (offertoken[_offerid],buyertoken[_offerid],seller[_offerid],price[_offerid],availablebalance);
162         
163     }   
164 //
165 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
166 
167 
168 
169 
170 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
171 // return the price in buyertokens for the specified amount of offertokens
172 
173 function pricepreview(uint24 _offerid, uint256 _amount) public view returns (uint256) {
174         IERC20 offertokeni = IERC20(offertoken[_offerid]);
175         return  _amount * price[_offerid] / (uint256(10) ** offertokeni.decimals())+1;
176     }
177 //
178 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
179 
180 
181 
182 
183 
184 
185 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
186 // return the amount in offertokens for the specified amount of buyertokens, for debugging
187 
188 //function pricepreviewreverse(uint24 _offerid, uint256 _amount) public view returns (uint256) {
189 //        IERC20 offertokeni = IERC20(offertoken[_offerid]);
190 //        return  _amount * (uint256(10) ** offertokeni.decimals()) / price[_offerid];
191 //    }
192 //
193 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
194 
195 
196 
197 
198 
199 
200 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
201 // the actual exchange function
202 // the buyer must bring the price correctly to ensure no frontrunning / changed offer
203 // if the offer is changed in meantime, it will not execute
204 
205 function buy(uint24 _offerid, uint256 _offertokenamount, uint256 _price) public returns (string) {
206 
207         IERC20 offertokeninterface = IERC20(offertoken[_offerid]);
208         IERC20 buyertokeninterface = IERC20(buyertoken[_offerid]);
209 
210 
211 // given price is being checked with recorded data from mappings
212        require(price[_offerid] == _price,"offer price wrong");
213 
214 
215 // calculate the price of the order
216         uint256 buyertokenAmount =  _offertokenamount * _price / (uint256(10) ** offertokeninterface.decimals())+1;
217 
218 
219 ////// these 4 checks have been spared out since the final check suffices, this save ~50000 gas
220 ////        // check if the buyers allowance and balance are right
221 ////                require(buyertokeninterface.allowance(msg.sender, address(this)) >= buyertokenAmount, "Check the buyers token allowance");
222 ////                require(buyertokeninterface.balanceOf(msg.sender) >= buyertokenAmount,"buyer not enough to pay");
223 ////        // check if the sellers allowance and balance are right        
224 ////                require(offertokeninterface.allowance(seller[_offerid], address(this)) >= _offertokenamount, "Check the sellers token allowance");
225 ////                require(offertokeninterface.balanceOf(seller[_offerid]) >= _offertokenamount,"seller not enough on stock");
226   
227         
228 // some old erc20 tokens give no return value so we must work around by getting their balance before and after the exchange        
229         uint256 oldbuyerbalance = buyertokeninterface.balanceOf(msg.sender);
230         uint256 oldsellerbalance = offertokeninterface.balanceOf(seller[_offerid]);
231 
232 
233 // finally do the exchange        
234         buyertokeninterface.transferFrom(msg.sender,seller[_offerid], buyertokenAmount);
235         offertokeninterface.transferFrom(seller[_offerid],msg.sender,_offertokenamount);
236 
237 
238 // now check if the balances changed on both accounts.
239 // we do not check for exact amounts since some tokens behave differently with fees, burnings, etc
240 // we assume if both balances are higher than before all is good
241         require(oldbuyerbalance > buyertokeninterface.balanceOf(msg.sender),"buyer error");
242         require(oldsellerbalance > offertokeninterface.balanceOf(seller[_offerid]),"seller error");
243         return "tokens exchanged. ENJOY!";
244     }
245 //
246 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
247 
248 
249 
250 
251 
252 
253 
254 
255 
256 
257 
258 
259 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
260 // in case someone wrongfully directly sends erc20 to this contract address, the admin can move them out
261 function losttokens(address token) public {
262         IERC20 tokeninterface = IERC20(token);
263         tokeninterface.transfer(admin,tokeninterface.balanceOf(address(this)));
264 }
265 //
266 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
267 
268 
269 
270 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
271 // straight ether payments to this contract are considered donations. thank you!
272 function () public payable {admin.transfer(address(this).balance);        }
273 //
274 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
275 
276 
277 
278 
279 
280 
281 }