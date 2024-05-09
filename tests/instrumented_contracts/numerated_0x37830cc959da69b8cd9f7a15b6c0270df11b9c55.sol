1 pragma solidity ^0.4.21;
2 
3 contract Items{
4     address owner;
5     address helper = 0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58;
6     
7     // Marketplace written by Etherguy and Poorguy
8     
9     // Change the below numbers to edit the development fee. 
10     // This can also be done by calling SetDevFee and SetHFee 
11     // Numbers are divided by 10000 to calcualte the cut 
12     uint16 public DevFee = 500; // 500 / 10000 -> 5% 
13     uint16 public HelperPortion = 5000; // 5000 / 10000 -> 50% (This is the cut taken from the total dev fee)
14     
15     // Increase in price 
16     // 0 means that the price stays the same 
17     // Again divide by 10000
18     // 10000 means: 10000/10000 = 1, which means the new price = OldPrice * (1 + (10000/1000)) = OldPrice * (1+1) = 2*OldPrice 
19     // Hence the price doubles.
20     // This setting can be changed via SetPriceIncrease
21     // The maximum setting is the uint16 max value 65535 which means an insane increase of more than 6.5x 
22     uint16 public PriceIncrease = 2000;
23     
24     struct Item{
25         address Owner;
26         uint256 Price;
27     }
28     
29     mapping(uint256 => Item) Market; 
30     
31     uint256 public NextItemID = 0;
32     event ItemBought(address owner, uint256 id, uint256 newprice);
33     
34     function Items() public {
35         owner = msg.sender;
36         
37         // Add initial items here to created directly by contract release. 
38         
39       //  AddMultipleItems(0.00666 ether, 3); // Create 3 items for 0.00666 ether basic price at start of contract.
40       
41       
42       // INITIALIZE 17 items so we can transfer ownership ...
43       AddMultipleItems(0.006666 ether, 36);
44       
45       
46       // SETUP their data 
47       Market[0].Owner = 0xC84c18A88789dBa5B0cA9C13973435BbcE7e961d;
48       Market[0].Price = 32000000000000000;
49       Market[1].Owner = 0x86b0b5Bb83D18FfdAE6B6E377971Fadf4F9aE6c0;
50       Market[1].Price = 16000000000000000;
51       Market[2].Owner = 0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD;
52       Market[2].Price = 16000000000000000;
53       Market[3].Owner = 0xC84c18A88789dBa5B0cA9C13973435BbcE7e961d;
54       Market[3].Price = 16000000000000000;
55       Market[4].Owner = 0xC84c18A88789dBa5B0cA9C13973435BbcE7e961d;
56       Market[4].Price = 32000000000000000;
57       Market[5].Owner = 0x1Eb695D7575EDa1F2c8a0aA6eDf871B5FC73eA6d;
58       Market[5].Price = 16000000000000000;
59       Market[6].Owner = 0xC84c18A88789dBa5B0cA9C13973435BbcE7e961d;
60       Market[6].Price = 32000000000000000;
61       Market[7].Owner = 0x183feBd8828a9ac6c70C0e27FbF441b93004fC05;
62       Market[7].Price = 16000000000000000;
63       Market[8].Owner = 0x74e5a4cbA4E44E2200844670297a0D5D0abe281F;
64       Market[8].Price = 16000000000000000;
65       Market[9].Owner = 0xC84c18A88789dBa5B0cA9C13973435BbcE7e961d;
66       Market[9].Price = 13320000000000000;
67       Market[10].Owner = 0xc34434842b9dC9CAB4E4727298A166be765B4F32;
68       Market[10].Price = 13320000000000000;
69       Market[11].Owner = 0xDE7002143bFABc4c5b214b00C782608b19312831;
70       Market[11].Price = 13320000000000000;
71       Market[12].Owner = 0xd33614943bCaaDb857a58fF7c36157F21643dF36;
72       Market[12].Price = 13320000000000000;
73       Market[13].Owner = 0xc34434842b9dC9CAB4E4727298A166be765B4F32;
74       Market[13].Price = 13320000000000000;
75       Market[14].Owner = 0xb03bEF1D9659363a9357aB29a05941491AcCb4eC;
76       Market[14].Price = 26640000000000000;
77       Market[15].Owner = 0x36E058332aE39efaD2315776B9c844E30d07388B;
78       Market[15].Price = 26640000000000000;
79       Market[16].Owner = 0xd33614943bCaaDb857a58fF7c36157F21643dF36;
80       Market[16].Price = 13320000000000000;
81       Market[17].Owner = 0x976b7B7E25e70C569915738d58450092bFAD5AF7;
82       Market[17].Price = 26640000000000000;
83       Market[18].Owner = 0xB7619660956C55A974Cb02208D7B723217193528;
84       Market[18].Price = 13320000000000000;
85       Market[19].Owner = 0x36E058332aE39efaD2315776B9c844E30d07388B;
86       Market[19].Price = 26640000000000000;
87       Market[20].Owner = 0x221D8F6B44Da3572Ffa498F0fFC6bD0bc3A84d94;
88       Market[20].Price = 26640000000000000;
89       Market[21].Owner = 0xB7619660956C55A974Cb02208D7B723217193528;
90       Market[21].Price = 13320000000000000;
91       Market[22].Owner = 0x0960069855Bd812717E5A8f63C302B4e43bAD89F;
92       Market[22].Price = 26640000000000000;
93       Market[23].Owner = 0x45F8262F7Ec0D5433c7541309a6729FE96e1d482;
94       Market[23].Price = 13320000000000000;
95       Market[24].Owner = 0xB7619660956C55A974Cb02208D7B723217193528;
96       Market[24].Price = 53280000000000000;
97       Market[25].Owner = 0x36E058332aE39efaD2315776B9c844E30d07388B;
98       Market[25].Price = 53280000000000000;
99       
100       // Uncomment to add MORE ITEMS
101      // AddMultipleItems(0.006666 ether, 17);
102     }
103     
104     // web function, return item info 
105     function ItemInfo(uint256 id) public view returns (uint256 ItemPrice, address CurrentOwner){
106         return (Market[id].Price, Market[id].Owner);
107     }
108     
109     // Add a single item. 
110     function AddItem(uint256 price) public {
111         require(price != 0); // Price 0 means item is not available. 
112         require(msg.sender == owner);
113         Item memory ItemToAdd = Item(0x0, price); // Set owner to 0x0 -> Recognized as owner
114         Market[NextItemID] = ItemToAdd;
115         NextItemID = add(NextItemID, 1); // This absolutely prevents overwriting items
116     }
117     
118     // Add multiple items 
119     // All for same price 
120     // This saves sending 10 tickets to create 10 items. 
121     function AddMultipleItems(uint256 price, uint8 howmuch) public {
122         require(msg.sender == owner);
123         require(price != 0);
124         require(howmuch != 255); // this is to prevent an infinite for loop
125         uint8 i=0;
126         for (i; i<howmuch; i++){
127             AddItem(price);
128         }
129     }
130     
131 
132     function BuyItem(uint256 id) payable public{
133         Item storage MyItem = Market[id];
134         require(MyItem.Price != 0); // It is not possible to edit existing items.
135         require(msg.value >= MyItem.Price); // Pay enough thanks .
136         uint256 ValueLeft = DoDev(MyItem.Price);
137         uint256 Excess = sub(msg.value, MyItem.Price);
138         if (Excess > 0){
139             msg.sender.transfer(Excess); // Pay back too much sent 
140         }
141         
142         // Proceed buy 
143         address target = MyItem.Owner;
144         
145         // Initial items are owned by owner. 
146         if (target == 0x0){
147             target = owner; 
148         }
149         
150         target.transfer(ValueLeft);
151         // set owner and price. 
152         MyItem.Price = mul(MyItem.Price, (uint256(PriceIncrease) + uint256(10000)))/10000; // division 10000 to scale stuff right. No need SafeMath this only errors when DIV by 0.
153         MyItem.Owner = msg.sender;
154         emit ItemBought(msg.sender, id, MyItem.Price);
155     }
156     
157     
158     
159     
160     
161     // Management stuff, not interesting after here .
162     
163     
164     function DoDev(uint256 val) internal returns (uint256){
165         uint256 tval = (mul(val, DevFee)) / 10000;
166         uint256 hval = (mul(tval, HelperPortion)) / 10000;
167         uint256 dval = sub(tval, hval); 
168         
169         owner.transfer(dval);
170         helper.transfer(hval);
171         return (sub(val,tval));
172     }
173     
174     // allows to change dev fee. max is 6.5%
175     function SetDevFee(uint16 tfee) public {
176         require(msg.sender == owner);
177         require(tfee <= 650);
178         DevFee = tfee;
179     }
180     
181     // allows to change helper fee. minimum is 10%, max 100%. 
182     function SetHFee(uint16 hfee) public  {
183         require(msg.sender == owner);
184         require(hfee <= 10000);
185 
186         HelperPortion = hfee;
187     
188     }
189     
190     // allows to change helper fee. minimum is 10%, max 100%. 
191     function SetPriceIncrease(uint16 increase) public  {
192         require(msg.sender == owner);
193         PriceIncrease = increase;
194     }
195     
196     
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198 		if (a == 0) {
199 			return 0;
200 		}
201 		uint256 c = a * b;
202 		assert(c / a == b);
203 		return c;
204 	}
205 
206 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
207 		// assert(b > 0); // Solidity automatically throws when dividing by 0
208 		uint256 c = a / b;
209 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 		return c;
211 	}
212 
213 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214 		assert(b <= a);
215 		return a - b;
216 	}
217 
218 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
219 		uint256 c = a + b;
220 		assert(c >= a);
221 		return c;
222 	}
223 }