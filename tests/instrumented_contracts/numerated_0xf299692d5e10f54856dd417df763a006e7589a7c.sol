1 pragma solidity ^0.4.24;
2 
3 contract OurPlace500{
4     bytes9[250000] public pixels;
5     address public owner;
6     address public manager;
7     bool public isPaused;
8     uint public pixelCost;
9     uint256 public CANVAS_HEIGHT;
10     uint256 public CANVAS_WIDTH;
11     uint public totalChangedPixels;
12     struct Terms{
13         string foreword;
14         string rules;
15         string youShouldKnow;
16         string dataCollection;
17         uint versionForeword;
18         uint versionRules;
19         uint versionYouShouldKnow;
20         uint versionDataCollection;
21     }
22     Terms public termsAndConditions;
23     string public terms;
24     mapping (address => uint) txMap;
25 
26     constructor(address ownerAddress) public{
27         owner = ownerAddress;
28         manager = msg.sender;
29         isPaused = false;
30         pixelCost = .000021 ether;
31         CANVAS_WIDTH = 500;
32         CANVAS_HEIGHT = 500;
33         totalChangedPixels = 0;
34         termsAndConditions = Terms({
35             foreword: "Welcome to ourPlace! \n \n Here you can change a pixel to any color on the Hex #RRGGBB scale for a small fee. \n Below you will find the general *rules* of the contract and other terms and conditions written in plain English. \n \n We highly suggest you give it a quick read, enjoy!",
36             versionForeword: 1,
37             rules: "The contract will only function properly if: \n \n i)  You have not changed any other pixels on this ETH block -- only one pixel is allowed to be changed per address per block, \n ii)  The Hex code, X & Y coordinate are valid values, \n iii)  The transfer value is correct (this is automatically set), \n iv)  You have accepted the Terms & Conditions. \n \n *Please note* However unlikely, it is possible that two different people could change the same pixel in the same block. The most recently processed transaction *wins* the pixel. Allow all your pixel transactions to complete before attempting again. Order of transactions is randomly chosen by ETH miners.",
38             versionRules: 1,
39             youShouldKnow: "You should know that: \n \n i) Changing a pixel costs ETH, \n ii)  We make no guarantees to keep the website running forever (obviously we will do our best), \n iii)  We may choose to permanently pause the contract, or clear large blocks of pixels if the canvas is misused, \n iv)  We may choose to point our website to an updated, empty, contract instead of the current contract. \n \n In addition we want to remind you: \n \n i) To check MetaMask and clear all errors/warnings before submitting a transaction, \n ii)You are responsible for the designs that you make, \n iii)To be on alert for look-alike websites and malicious pop-ups, \n iv)That you are solely responsible for the safety of your accounts.",
40             versionYouShouldKnow: 1,
41             dataCollection: "Our official website will contain: \n \n i)  A Google Tag Manager cookie with both Analytics and Adwords tags installed. Currently there is no intention to use this data for anything other than interest's sake and sharing generic aggregated data. \n ii)  All transactions are recorded on the Ethereum blockchain, everyone has public access to this data. We, or others, may analyze this data to see which accounts interact with this contract.",
42             versionDataCollection: 1
43         });
44     }
45 
46     modifier isManager(){
47         require(msg.sender == manager, "Only The Contract Manager Can Call This Function");
48         _;
49     }
50 
51     modifier isOwner(){
52         require(msg.sender == owner, "Only The Contract Owner Can Call This Function");
53         _;
54     }
55 
56     function changePixel(string pixelHex, uint pixelX, uint pixelY, bool acceptedTerms) public payable{
57         require(!isPaused, 'Contract Is Paused');
58         require(acceptedTerms, 'Must Accept Terms To Proceed');
59         require(msg.value >= pixelCost, 'Transaction Value Is Incorrect');
60         require(RGBAHexRegex.matches(pixelHex), 'Not A Valid Hex #RRGGBBAA Color Value');
61         require(pixelX > 0 && pixelX <= CANVAS_WIDTH, 'Invalid X Coordinate Value');
62         require(pixelY > 0 && pixelY <= CANVAS_HEIGHT, 'Invalid Y Coordinate Value');
63         require(txMap[msg.sender] != block.number, 'One Transaction Allowed Per Block');
64         txMap[msg.sender] = block.number;
65         uint index = CANVAS_WIDTH * (pixelY-1) + (pixelX-1);
66         bytes9 pixelHexBytes = stringToBytes9(pixelHex);
67         pixels[index] = pixelHexBytes;
68         totalChangedPixels = totalChangedPixels + 1;
69     }
70 
71     function changeTerms(string termsKey, string termsValue) public isManager {
72         if(compareStrings(termsKey,'foreword')){
73             termsAndConditions.foreword = termsValue;
74             termsAndConditions.versionForeword++;
75         }
76         else if(compareStrings(termsKey,'rules')){
77             termsAndConditions.rules = termsValue;
78             termsAndConditions.versionRules++;
79         }
80         else if(compareStrings(termsKey,'youShouldKnow')){
81             termsAndConditions.youShouldKnow = termsValue;
82             termsAndConditions.versionForeword++;
83         }
84         else if(compareStrings(termsKey,'dataCollection')){
85             termsAndConditions.dataCollection = termsValue;
86             termsAndConditions.versionDataCollection++;
87         }
88         else {
89             revert('Invalid Section Key');
90         }
91     }
92 
93     function changePixelCost(uint newPixelCost) public isManager{
94         pixelCost = newPixelCost;
95     }
96 
97     function clearPixels(uint xTopL, uint yTopL, uint xBottomR, uint yBottomR) public isManager{
98         require(xTopL > 0 && xTopL <= CANVAS_WIDTH, 'Invalid X Coordinate Value');
99         require(yTopL > 0 && yTopL <= CANVAS_HEIGHT, 'Invalid Y Coordinate Value');
100         require(xBottomR > 0 && xBottomR <= CANVAS_WIDTH, 'Invalid X Coordinate Value');
101         require(yBottomR > 0 && yBottomR <= CANVAS_HEIGHT, 'Invalid Y Coordinate Value');
102         require(xTopL < xBottomR, 'Double Check Corner Coordinates');
103         require(yTopL > yBottomR, 'Double Check Corner Coordinates');
104         for(uint y = yTopL; y <= yBottomR; y++)
105         {
106             for(uint x = xTopL; x <= xBottomR; x++)
107             {
108                 uint index = CANVAS_WIDTH * (y-1) + (x-1);
109                 bytes9 pixelHexBytes = stringToBytes9('');
110                 pixels[index] = pixelHexBytes;
111             }
112         }
113     }
114 
115     function changeManager(address newManager) public isOwner{
116         manager=newManager;
117     }
118 
119     function changeOwner(address newOwner) public isOwner{
120         owner=newOwner;
121     }
122 
123     function withdraw() public isOwner{
124         owner.transfer(address(this).balance);
125     }
126 
127     function pauseContract() public isManager{
128         isPaused = !isPaused;
129     }
130 
131     function getPixelArray() public view returns(bytes9[250000]){
132         return pixels;
133     }
134 
135     function compareStrings (string a, string b) private pure returns (bool){
136         return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
137     }
138 
139     function stringToBytes9(string memory source) private pure returns (bytes9 result) {
140         bytes memory tempEmptyStringTest = bytes(source);
141         if (tempEmptyStringTest.length == 0) {
142             return 0x0;
143         }
144         assembly {
145             result := mload(add(source, 32))
146         }
147     }
148 }
149 
150 library RGBAHexRegex {
151     struct State {
152         bool accepts;
153         function (byte) pure internal returns (State memory) func;
154     }
155 
156     string public constant regex = "#(([0-9a-fA-F]{2}){4})";
157 
158     function s0(byte c) pure internal returns (State memory) {
159         c = c;
160         return State(false, s0);
161     }
162 
163     function s1(byte c) pure internal returns (State memory) {
164         if (c == 35) {
165             return State(false, s2);
166         }
167         return State(false, s0);
168     }
169 
170     function s2(byte c) pure internal returns (State memory) {
171         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
172             return State(false, s3);
173         }
174         return State(false, s0);
175     }
176 
177     function s3(byte c) pure internal returns (State memory) {
178         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
179             return State(false, s4);
180         }
181         return State(false, s0);
182     }
183 
184     function s4(byte c) pure internal returns (State memory) {
185         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
186             return State(false, s5);
187         }
188         return State(false, s0);
189     }
190 
191     function s5(byte c) pure internal returns (State memory) {
192         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
193             return State(false, s6);
194         }
195         return State(false, s0);
196     }
197 
198     function s6(byte c) pure internal returns (State memory) {
199         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
200             return State(false, s7);
201         }
202         return State(false, s0);
203     }
204 
205     function s7(byte c) pure internal returns (State memory) {
206         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
207             return State(false, s8);
208         }
209         return State(false, s0);
210     }
211 
212     function s8(byte c) pure internal returns (State memory) {
213         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
214             return State(false, s9);
215         }
216         return State(false, s0);
217     }
218 
219     function s9(byte c) pure internal returns (State memory) {
220         if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
221             return State(true, s10);
222         }
223         return State(false, s0);
224     }
225 
226     function s10(byte c) pure internal returns (State memory) {
227         // silence unused var warning
228         c = c;
229         return State(false, s0);
230     }
231 
232     function matches(string input) public pure returns (bool) {
233         State memory cur = State(false, s1);
234         for (uint i = 0; i < bytes(input).length; i++) {
235             byte c = bytes(input)[i];
236             cur = cur.func(c);
237         }
238         return cur.accepts;
239     }
240 }