1 pragma solidity ^0.4.19;
2 
3 /**
4 * Contract for Vanity URL on SpringRole
5 * Go to beta.springrole.com to try this out!
6 */
7 
8 contract Token{
9 
10   function doTransfer(address _from, address _to, uint256 _value) public returns (bool);
11 
12 }
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of “user permissions”.
18  */
19 
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() {
31     owner = msg.sender;
32   }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) onlyOwner public {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 /**
57  * @title Pausable
58  * @dev Base contract which allows children to implement an emergency stop mechanism.
59  */
60 
61 contract Pausable is Ownable {
62   event Pause();
63   event Unpause();
64 
65   bool public paused = false;
66 
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is not paused.
70    */
71   modifier whenNotPaused() {
72     require(!paused);
73     _;
74   }
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is paused.
78    */
79   modifier whenPaused() {
80     require(paused);
81     _;
82   }
83 
84   /**
85    * @dev called by the owner to pause, triggers stopped state
86    */
87   function pause() onlyOwner whenNotPaused public {
88     paused = true;
89     Pause();
90   }
91 
92   /**
93    * @dev called by the owner to unpause, returns to normal state
94    */
95   function unpause() onlyOwner whenPaused public {
96     paused = false;
97     Unpause();
98   }
99 }
100 
101 
102 /**
103  * @title VanityURL
104  * @dev The VanityURL contract provides functionality to reserve vanity URLs.
105  * Go to https://beta.springrole.com to reserve.
106  */
107 
108 
109 contract VanityURL is Ownable,Pausable {
110 
111   // This declares a state variable that would store the contract address
112   Token public tokenAddress;
113   // This declares a state variable that mapping for vanityURL to address
114   mapping (string => address) vanity_address_mapping;
115   // This declares a state variable that mapping for address to vanityURL
116   mapping (address => string ) address_vanity_mapping;
117   // This declares a state variable that stores pricing
118   uint256 public reservePricing;
119   // This declares a state variable address to which token to be transfered
120   address public transferTokenTo;
121 
122   /*
123     constructor function to set token address & Pricing for reserving and token transfer address
124    */
125   function VanityURL(address _tokenAddress, uint256 _reservePricing, address _transferTokenTo){
126     tokenAddress = Token(_tokenAddress);
127     reservePricing = _reservePricing;
128     transferTokenTo = _transferTokenTo;
129   }
130 
131   event VanityReserved(address _to, string _vanity_url);
132   event VanityTransfered(address _to,address _from, string _vanity_url);
133   event VanityReleased(string _vanity_url);
134 
135   /* function to update Token address */
136   function updateTokenAddress (address _tokenAddress) onlyOwner public {
137     tokenAddress = Token(_tokenAddress);
138   }
139 
140   /* function to update transferTokenTo */
141   function updateTokenTransferAddress (address _transferTokenTo) onlyOwner public {
142     transferTokenTo = _transferTokenTo;
143   }
144 
145   /* function to set reserve pricing */
146   function setReservePricing (uint256 _reservePricing) onlyOwner public {
147     reservePricing = _reservePricing;
148   }
149 
150   /* function to retrive wallet address from vanity url */
151   function retrieveWalletForVanity(string _vanity_url) constant public returns (address) {
152     return vanity_address_mapping[_vanity_url];
153   }
154 
155   /* function to retrive vanity url from address */
156   function retrieveVanityForWallet(address _address) constant public returns (string) {
157     return address_vanity_mapping[_address];
158   }
159 
160   /*
161     function to reserve vanityURL
162     1. Checks if vanity is check is valid
163     2. Checks if address has already a vanity url
164     3. check if vanity url is used by any other or not
165     4. Check if vanity url is present in reserved keyword
166     5. Transfer the token
167     6. Update the mapping variables
168   */
169   function reserve(string _vanity_url) whenNotPaused public {
170     _vanity_url = _toLower(_vanity_url);
171     require(checkForValidity(_vanity_url));
172     require(vanity_address_mapping[_vanity_url]  == address(0x0));
173     require(bytes(address_vanity_mapping[msg.sender]).length == 0);
174     require(tokenAddress.doTransfer(msg.sender,transferTokenTo,reservePricing));
175     vanity_address_mapping[_vanity_url] = msg.sender;
176     address_vanity_mapping[msg.sender] = _vanity_url;
177     VanityReserved(msg.sender, _vanity_url);
178   }
179 
180   /*
181   function to make lowercase
182   */
183 
184   function _toLower(string str) internal returns (string) {
185 		bytes memory bStr = bytes(str);
186 		bytes memory bLower = new bytes(bStr.length);
187 		for (uint i = 0; i < bStr.length; i++) {
188 			// Uppercase character...
189 			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
190 				// So we add 32 to make it lowercase
191 				bLower[i] = bytes1(int(bStr[i]) + 32);
192 			} else {
193 				bLower[i] = bStr[i];
194 			}
195 		}
196 		return string(bLower);
197 	}
198 
199   /*
200   function to verify vanityURL
201   1. Minimum length 4
202   2.Maximum lenght 200
203   3.Vanity url is only alphanumeric
204    */
205   function checkForValidity(string _vanity_url) returns (bool) {
206     uint length =  bytes(_vanity_url).length;
207     require(length >= 4 && length <= 200);
208     for (uint i =0; i< length; i++){
209       var c = bytes(_vanity_url)[i];
210       if ((c < 48 ||  c > 122 || (c > 57 && c < 65) || (c > 90 && c < 97 )) && (c != 95))
211         return false;
212     }
213     return true;
214   }
215 
216   /*
217   function to change Vanity URL
218     1. Checks whether vanity URL is check is valid
219     2. Checks if address has already a vanity url
220     3. check if vanity url is used by any other or not
221     4. Check if vanity url is present in reserved keyword
222     5. Update the mapping variables
223   */
224 
225   function changeVanityURL(string _vanity_url) whenNotPaused public {
226     require(bytes(address_vanity_mapping[msg.sender]).length != 0);
227     _vanity_url = _toLower(_vanity_url);
228     require(checkForValidity(_vanity_url));
229     require(vanity_address_mapping[_vanity_url]  == address(0x0));
230     vanity_address_mapping[_vanity_url] = msg.sender;
231     address_vanity_mapping[msg.sender] = _vanity_url;
232     VanityReserved(msg.sender, _vanity_url);
233   }
234 
235   /*
236   function to transfer ownership for Vanity URL
237   */
238   function transferOwnershipForVanityURL(address _to) whenNotPaused public {
239     require(bytes(address_vanity_mapping[_to]).length == 0);
240     require(bytes(address_vanity_mapping[msg.sender]).length != 0);
241     address_vanity_mapping[_to] = address_vanity_mapping[msg.sender];
242     vanity_address_mapping[address_vanity_mapping[msg.sender]] = _to;
243     VanityTransfered(msg.sender,_to,address_vanity_mapping[msg.sender]);
244     delete(address_vanity_mapping[msg.sender]);
245   }
246 
247   /*
248   function to transfer ownership for Vanity URL by Owner
249   */
250   function reserveVanityURLByOwner(address _to,string _vanity_url) whenNotPaused onlyOwner public {
251       _vanity_url = _toLower(_vanity_url);
252       require(checkForValidity(_vanity_url));
253       /* check if vanity url is being used by anyone */
254       if(vanity_address_mapping[_vanity_url]  != address(0x0))
255       {
256         /* Sending Vanity Transfered Event */
257         VanityTransfered(vanity_address_mapping[_vanity_url],_to,_vanity_url);
258         /* delete from address mapping */
259         delete(address_vanity_mapping[vanity_address_mapping[_vanity_url]]);
260         /* delete from vanity mapping */
261         delete(vanity_address_mapping[_vanity_url]);
262       }
263       else
264       {
265         /* sending VanityReserved event */
266         VanityReserved(_to, _vanity_url);
267       }
268       /* add new address to mapping */
269       vanity_address_mapping[_vanity_url] = _to;
270       address_vanity_mapping[_to] = _vanity_url;
271   }
272 
273   /*
274   function to release a Vanity URL by Owner
275   */
276   function releaseVanityUrl(string _vanity_url) whenNotPaused onlyOwner public {
277     require(vanity_address_mapping[_vanity_url]  != address(0x0));
278     /* delete from address mapping */
279     delete(address_vanity_mapping[vanity_address_mapping[_vanity_url]]);
280     /* delete from vanity mapping */
281     delete(vanity_address_mapping[_vanity_url]);
282     /* sending VanityReleased event */
283     VanityReleased(_vanity_url);
284   }
285 
286   /*
287     function to kill contract
288   */
289 
290   function kill() onlyOwner {
291     selfdestruct(owner);
292   }
293 
294   /*
295     transfer eth recived to owner account if any
296   */
297   function() payable {
298     owner.transfer(msg.value);
299   }
300 
301 }