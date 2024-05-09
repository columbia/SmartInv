1 pragma solidity ^0.5.0;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x, "ds-math-add-overflow");
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x, "ds-math-sub-underflow");
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42     function rpow(uint x, uint n) internal pure returns (uint z) {
43         z = n % 2 != 0 ? x : RAY;
44 
45         for (n /= 2; n != 0; n /= 2) {
46             x = rmul(x, x);
47 
48             if (n % 2 != 0) {
49                 z = rmul(z, x);
50             }
51         }
52     }
53 }
54 
55 
56 contract Bank is DSMath {
57   mapping(address => uint) public balances;
58 
59   function deposit() public payable returns (uint balance) {
60     balances[msg.sender] = add(balances[msg.sender], msg.value);
61     return balances[msg.sender];
62   }
63 
64   function withdraw(uint amount) public returns (uint remainingBalance){
65     require(min(amount,balances[msg.sender]) == amount);
66     balances[msg.sender] = sub(balances[msg.sender],amount);
67     msg.sender.transfer(amount);
68     return balances[msg.sender];
69   }
70 
71   function balance() view public returns (uint) {
72     return balances[msg.sender];
73   }
74 }
75 
76 
77 contract OwnsArtSplit is DSMath, Bank{
78     struct Bundle{
79         address owner;
80         uint decayedTime;
81     }
82     //8 bits: exponent
83     //124 bits: generation
84     //124 bits: sibling
85     uint public constant exponentMask    = 0xff00000000000000000000000000000000000000000000000000000000000000;
86     uint public constant generationMask  = 0x00fffffffffffffffffffffffffffffff0000000000000000000000000000000;
87     uint public constant siblingMask     = 0xff0000000000000000000000000000000fffffffffffffffffffffffffffffff;
88     mapping(uint => Bundle) public bundleTable;
89     
90     //maps the bundle exponent to find sibling for that bundle size
91     //next sibling for generation
92     mapping(uint8 => mapping(uint128 => uint128)) public siblingTable;
93 
94     address public artist;
95     uint public constant price = 0.01 ether;
96     uint public constant resaleFee = 0.001 ether;
97     uint public constant maxBundlesPerPurchase = 0xff;
98     uint public constant maxBundleExponent = 16;
99     uint public constant artDecayTime = 30 days;
100     uint public constant itemsPerBundle = 10;
101     
102     bool private buyArtMutex = false;
103     
104     event LogPurchase(uint[] destroyedBundleID, uint[] createdBundleID1, uint[] createdBundleID2, uint decay, address buyer);
105     event LogBundling(uint[] bundledIDs, uint newBundleID, uint decay, address bundler);
106     event LogUnbundling(uint unbundledID, uint[] newBundleIDs, uint decay, address bundler);
107     
108     constructor() public {
109         artist = msg.sender;
110         bundleTable[0] = Bundle(msg.sender, now+artDecayTime);
111         siblingTable[0][0] = 1;
112     }
113     
114     function buyArtworkBundles(uint[] memory bundleIDs) public{
115         require(min(bundleIDs.length,maxBundlesPerPurchase)==bundleIDs.length,"Cannot buy too many bundles at once.");
116         uint8 numberOfBundles = uint8(bundleIDs.length);
117         require(numberOfBundles != 0,"Must buy more than zero bundles.");
118         
119         uint[] memory createdBundleID1  = new uint[](numberOfBundles);
120         uint[] memory createdBundleID2  = new uint[](numberOfBundles);
121         
122         require(!buyArtMutex,"Only one person can buy bundles at the same time. Try again later.");
123         buyArtMutex = true;
124         
125         for (uint i=0; i<numberOfBundles; i++) {
126             Bundle memory bundle = bundleTable[bundleIDs[i]];
127             (uint128 generation, , uint8 exponent) = splitBundleID(bundleIDs[i]);
128             require(testValidBundle(bundle),"Bundle is invalid. Check decaytime, existence.");
129             require(bundle.owner != msg.sender,"Buyer cannot be same as current owner.");
130             require(min(exponent,maxBundleExponent)==exponent,"Exponent cannot be too large");
131 
132             //sell old bundle
133             uint multiplier = itemsPerBundle**uint(exponent);
134             balances[msg.sender] = sub(balances[msg.sender],price*multiplier);
135             balances[bundle.owner] = add(balances[bundle.owner],sub(price*multiplier,resaleFee*multiplier));
136             balances[artist] = add(balances[artist],resaleFee*multiplier);
137             
138             //destroy old bundle
139             delete bundleTable[bundleIDs[i]] ;//= bundle;
140             
141             //create two new bundles
142             uint128 sibling = siblingTable[exponent][generation+1];
143             uint bundleID1 = generateBundleID(generation+1,sibling,exponent);
144             uint bundleID2 = generateBundleID(generation+1,sibling+1,exponent);
145             Bundle memory newBundle = Bundle(msg.sender, add(now, artDecayTime));
146             bundleTable[bundleID1] = newBundle;
147             bundleTable[bundleID2] = newBundle;
148             
149             //save IDs for logging
150             createdBundleID1[i] = bundleID1;
151             createdBundleID2[i] = bundleID2;
152             
153             //update next sibling
154             siblingTable[exponent][generation+1] = siblingTable[exponent][generation+1] + 2;
155         }
156         
157         emit LogPurchase(bundleIDs,createdBundleID1,createdBundleID2,add(now,artDecayTime),msg.sender);
158         
159         buyArtMutex = false;
160     }
161     
162     function bundling(uint[] memory bundleIDs) public{
163         require(bundleIDs.length == itemsPerBundle);
164         //prevent bundling that goes over maxBundleExponent
165         (,,uint8 exponent) = splitBundleID(bundleIDs[0]);
166         require(min(exponent,maxBundleExponent-1)==exponent);
167         
168         
169         //deactivate and test old bundles
170         uint soonestDecay = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
171         for (uint i=0; i<itemsPerBundle; i++){
172             Bundle memory bundle = bundleTable[bundleIDs[i]];
173             (,,uint8 currentExponent) = splitBundleID(bundleIDs[i]);
174             require(currentExponent == exponent,"All bundles must have the same exponent");
175             require(testValidBundle(bundle),"Bundle is invalid. Check decaytime, existence.");
176             require(bundle.owner == msg.sender, "Cannot bundle items sender does not own.");
177             delete bundleTable[bundleIDs[i]];
178             if(min(soonestDecay,bundle.decayedTime)==bundle.decayedTime){
179                 soonestDecay = bundle.decayedTime;
180             }
181         }
182         
183         //generate new bundle
184         uint128 generation = 0;
185         uint128 sibling = siblingTable[exponent+1][generation];
186         uint newBundleID = generateBundleID(generation,sibling,exponent+1);
187         bundleTable[newBundleID] = Bundle(msg.sender, soonestDecay);
188         siblingTable[exponent+1][generation] = sibling + 1;
189         
190         emit LogBundling(bundleIDs,newBundleID,soonestDecay,msg.sender);
191     }
192     
193     function unbundling(uint bundleID) public{
194         (,,uint8 exponent) = splitBundleID(bundleID);
195         require(min(exponent,maxBundleExponent)==exponent,"Exponent must be less than max.");
196         require(min(exponent,0)!=exponent,"Bundle must have an exponent greater than 0.");
197         Bundle memory bundle = bundleTable[bundleID];
198         require(testValidBundle(bundle),"Bundle is invalid. Check decaytime, existence.");
199         require(bundle.owner == msg.sender,"Can only unbundle items owned by sender.");
200         Bundle memory newBundle = Bundle(msg.sender,bundle.decayedTime);
201         uint[] memory newBundleIDs = new uint[](10);
202         for (uint i=0; i<itemsPerBundle; i++){
203             uint id = generateBundleID(0,siblingTable[exponent-1][0],exponent-1);
204             bundleTable[id] = newBundle;
205             newBundleIDs[i] = id;
206             siblingTable[exponent-1][0] = siblingTable[exponent-1][0] + 1;
207         }
208         delete bundleTable[bundleID];
209         
210         emit LogUnbundling(bundleID,newBundleIDs,newBundle.decayedTime,msg.sender);
211     }
212     
213     function splitBundleID(uint bundleID) pure public returns (uint128 generation, uint128 sibling, uint8 exponent){
214         return(uint128((bundleID&generationMask)>>124),uint128((bundleID&siblingMask)),uint8((bundleID&exponentMask)>>248));
215     }
216     
217     function generateBundleID(uint128 generation, uint128 sibling, uint8 exponent) pure public returns(uint bundleID){
218         return (uint(generation) << 124) | uint(sibling) | (uint(exponent) << 248);
219     }
220     
221     function testValidBundle(Bundle memory bundle) view private returns (bool){
222         return 
223             (bundle.decayedTime != 0) &&
224             (!isDecayed(bundle.decayedTime));
225     }
226 
227     function isDecayed(uint decayedTime) view public returns (bool){
228         return (min(now,decayedTime) != now);
229     }
230 }