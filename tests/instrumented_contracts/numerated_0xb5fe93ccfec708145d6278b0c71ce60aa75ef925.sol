1 pragma solidity ^0.4.15;
2 
3 contract KetherHomepage {
4     /// Buy is emitted when an ad unit is reserved.
5     event Buy(
6         uint indexed idx,
7         address owner,
8         uint x,
9         uint y,
10         uint width,
11         uint height
12     );
13 
14     /// Publish is emitted whenever the contents of an ad is changed.
15     event Publish(
16         uint indexed idx,
17         string link,
18         string image,
19         string title,
20         bool NSFW
21     );
22 
23     /// SetAdOwner is emitted whenever the ownership of an ad is transfered
24     event SetAdOwner(
25         uint indexed idx,
26         address from,
27         address to
28     );
29 
30     /// Price is 1 kether divided by 1,000,000 pixels
31     uint public constant weiPixelPrice = 1000000000000000;
32 
33     /// Each grid cell represents 100 pixels (10x10).
34     uint public constant pixelsPerCell = 100;
35 
36     bool[100][100] public grid;
37 
38     /// contractOwner can withdraw the funds and override NSFW status of ad units.
39     address contractOwner;
40 
41     /// withdrawWallet is the fixed destination of funds to withdraw. It is
42     /// separate from contractOwner to allow for a cold storage destination.
43     address withdrawWallet;
44 
45     struct Ad {
46         address owner;
47         uint x;
48         uint y;
49         uint width;
50         uint height;
51         string link;
52         string image;
53         string title;
54 
55         /// NSFW is whether the ad is suitable for people of all
56         /// ages and workplaces.
57         bool NSFW;
58         /// forceNSFW can be set by owner.
59         bool forceNSFW;
60     }
61 
62     /// ads are stored in an array, the id of an ad is its index in this array.
63     Ad[] public ads;
64 
65     function KetherHomepage(address _contractOwner, address _withdrawWallet) {
66         require(_contractOwner != address(0));
67         require(_withdrawWallet != address(0));
68 
69         contractOwner = _contractOwner;
70         withdrawWallet = _withdrawWallet;
71     }
72 
73     /// getAdsLength tells you how many ads there are
74     function getAdsLength() constant returns (uint) {
75         return ads.length;
76     }
77 
78     /// Ads must be purchased in 10x10 pixel blocks.
79     /// Each coordinate represents 10 pixels. That is,
80     ///   _x=5, _y=10, _width=3, _height=3
81     /// Represents a 30x30 pixel ad at coordinates (50, 100)
82     function buy(uint _x, uint _y, uint _width, uint _height) payable returns (uint idx) {
83         uint cost = _width * _height * pixelsPerCell * weiPixelPrice;
84         require(cost > 0);
85         require(msg.value >= cost);
86 
87         // Loop over relevant grid entries
88         for(uint i=0; i<_width; i++) {
89             for(uint j=0; j<_height; j++) {
90                 if (grid[_x+i][_y+j]) {
91                     // Already taken, undo.
92                     revert();
93                 }
94                 grid[_x+i][_y+j] = true;
95             }
96         }
97 
98         // We reserved space in the grid, now make a placeholder entry.
99         Ad memory ad = Ad(msg.sender, _x, _y, _width, _height, "", "", "", false, false);
100         idx = ads.push(ad) - 1;
101         Buy(idx, msg.sender, _x, _y, _width, _height);
102         return idx;
103     }
104 
105     /// Publish allows for setting the link, image, and NSFW status for the ad
106     /// unit that is identified by the idx which was returned during the buy step.
107     /// The link and image must be full web3-recognizeable URLs, such as:
108     ///  - bzz://a5c10851ef054c268a2438f10a21f6efe3dc3dcdcc2ea0e6a1a7a38bf8c91e23
109     ///  - bzz://mydomain.eth/ad.png
110     ///  - https://cdn.mydomain.com/ad.png
111     /// Images should be valid PNG.
112     function publish(uint _idx, string _link, string _image, string _title, bool _NSFW) {
113         Ad storage ad = ads[_idx];
114         require(msg.sender == ad.owner);
115         ad.link = _link;
116         ad.image = _image;
117         ad.title = _title;
118         ad.NSFW = _NSFW;
119 
120         Publish(_idx, ad.link, ad.image, ad.title, ad.NSFW || ad.forceNSFW);
121     }
122 
123     /// setAdOwner changes the owner of an ad unit
124     function setAdOwner(uint _idx, address _newOwner) {
125         Ad storage ad = ads[_idx];
126         require(msg.sender == ad.owner);
127         ad.owner = _newOwner;
128 
129         SetAdOwner(_idx, msg.sender, _newOwner);
130     }
131 
132     /// forceNSFW allows the owner to override the NSFW status for a specific ad unit.
133     function forceNSFW(uint _idx, bool _NSFW) {
134         require(msg.sender == contractOwner);
135         Ad storage ad = ads[_idx];
136         ad.forceNSFW = _NSFW;
137 
138         Publish(_idx, ad.link, ad.image, ad.title, ad.NSFW || ad.forceNSFW);
139     }
140 
141     /// withdraw allows the owner to transfer out the balance of the contract.
142     function withdraw() {
143         require(msg.sender == contractOwner);
144         withdrawWallet.transfer(this.balance);
145     }
146 }