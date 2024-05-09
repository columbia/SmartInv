1 pragma solidity ^0.4.19;
2 
3 /**
4 * Contract for Vanity URL on SpringRole
5 * Go to beta.springrole.com to try this out!
6 */
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of “user permissions”.
12  */
13 
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() {
25     owner = msg.sender;
26   }
27 
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) onlyOwner public {
43     require(newOwner != address(0));
44     OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 /**
51  * @title Pausable
52  * @dev Base contract which allows children to implement an emergency stop mechanism.
53  */
54 
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     Unpause();
92   }
93 }
94 
95 
96 /**
97  * @title VanityURL
98  * @dev The VanityURL contract provides functionality to reserve vanity URLs.
99  * Go to https://beta.springrole.com to reserve.
100  */
101 
102 
103 contract VanityURL is Ownable,Pausable {
104 
105   // This declares a state variable that mapping for vanityURL to address
106   mapping (string => address) vanity_address_mapping;
107   // This declares a state variable that mapping for address to vanityURL
108   mapping (address => string ) address_vanity_mapping;
109   /*
110     constructor function to set token address & Pricing for reserving and token transfer address
111    */
112   function VanityURL(){
113   }
114 
115   event VanityReserved(address _to, string _vanity_url);
116   event VanityTransfered(address _to,address _from, string _vanity_url);
117   event VanityReleased(string _vanity_url);
118 
119   /* function to retrive wallet address from vanity url */
120   function retrieveWalletForVanity(string _vanity_url) constant public returns (address) {
121     return vanity_address_mapping[_vanity_url];
122   }
123 
124   /* function to retrive vanity url from address */
125   function retrieveVanityForWallet(address _address) constant public returns (string) {
126     return address_vanity_mapping[_address];
127   }
128 
129   /*
130     function to reserve vanityURL
131     1. Checks if vanity is check is valid
132     2. Checks if address has already a vanity url
133     3. check if vanity url is used by any other or not
134     4. Check if vanity url is present in reserved keyword
135     5. Transfer the token
136     6. Update the mapping variables
137   */
138   function reserve(string _vanity_url) whenNotPaused public {
139     _vanity_url = _toLower(_vanity_url);
140     require(checkForValidity(_vanity_url));
141     require(vanity_address_mapping[_vanity_url]  == address(0x0));
142     require(bytes(address_vanity_mapping[msg.sender]).length == 0);
143     vanity_address_mapping[_vanity_url] = msg.sender;
144     address_vanity_mapping[msg.sender] = _vanity_url;
145     VanityReserved(msg.sender, _vanity_url);
146   }
147 
148   /*
149   function to make lowercase
150   */
151 
152   function _toLower(string str) internal returns (string) {
153 		bytes memory bStr = bytes(str);
154 		bytes memory bLower = new bytes(bStr.length);
155 		for (uint i = 0; i < bStr.length; i++) {
156 			// Uppercase character...
157 			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
158 				// So we add 32 to make it lowercase
159 				bLower[i] = bytes1(int(bStr[i]) + 32);
160 			} else {
161 				bLower[i] = bStr[i];
162 			}
163 		}
164 		return string(bLower);
165 	}
166 
167   /*
168   function to verify vanityURL
169   1. Minimum length 4
170   2.Maximum lenght 200
171   3.Vanity url is only alphanumeric
172    */
173   function checkForValidity(string _vanity_url) returns (bool) {
174     uint length =  bytes(_vanity_url).length;
175     require(length >= 4 && length <= 200);
176     for (uint i =0; i< length; i++){
177       var c = bytes(_vanity_url)[i];
178       if ((c < 48 ||  c > 122 || (c > 57 && c < 65) || (c > 90 && c < 97 )) && (c != 95))
179         return false;
180     }
181     return true;
182   }
183 
184   /*
185   function to change Vanity URL
186     1. Checks whether vanity URL is check is valid
187     2. Checks if address has already a vanity url
188     3. check if vanity url is used by any other or not
189     4. Check if vanity url is present in reserved keyword
190     5. Update the mapping variables
191   */
192 
193   function changeVanityURL(string _vanity_url) whenNotPaused public {
194     require(bytes(address_vanity_mapping[msg.sender]).length != 0);
195     _vanity_url = _toLower(_vanity_url);
196     require(checkForValidity(_vanity_url));
197     require(vanity_address_mapping[_vanity_url]  == address(0x0));
198     vanity_address_mapping[_vanity_url] = msg.sender;
199     address_vanity_mapping[msg.sender] = _vanity_url;
200     VanityReserved(msg.sender, _vanity_url);
201   }
202 
203   /*
204   function to transfer ownership for Vanity URL
205   */
206   function transferOwnershipForVanityURL(address _to) whenNotPaused public {
207     require(bytes(address_vanity_mapping[_to]).length == 0);
208     require(bytes(address_vanity_mapping[msg.sender]).length != 0);
209     address_vanity_mapping[_to] = address_vanity_mapping[msg.sender];
210     vanity_address_mapping[address_vanity_mapping[msg.sender]] = _to;
211     VanityTransfered(msg.sender,_to,address_vanity_mapping[msg.sender]);
212     delete(address_vanity_mapping[msg.sender]);
213   }
214 
215   /*
216   function to transfer ownership for Vanity URL by Owner
217   */
218   function reserveVanityURLByOwner(address _to,string _vanity_url) whenNotPaused onlyOwner public {
219       _vanity_url = _toLower(_vanity_url);
220       require(checkForValidity(_vanity_url));
221       /* check if vanity url is being used by anyone */
222       if(vanity_address_mapping[_vanity_url]  != address(0x0))
223       {
224         /* Sending Vanity Transfered Event */
225         VanityTransfered(vanity_address_mapping[_vanity_url],_to,_vanity_url);
226         /* delete from address mapping */
227         delete(address_vanity_mapping[vanity_address_mapping[_vanity_url]]);
228         /* delete from vanity mapping */
229         delete(vanity_address_mapping[_vanity_url]);
230       }
231       else
232       {
233         /* sending VanityReserved event */
234         VanityReserved(_to, _vanity_url);
235       }
236       /* add new address to mapping */
237       vanity_address_mapping[_vanity_url] = _to;
238       address_vanity_mapping[_to] = _vanity_url;
239   }
240 
241   /*
242   function to release a Vanity URL by Owner
243   */
244   function releaseVanityUrl(string _vanity_url) whenNotPaused onlyOwner public {
245     require(vanity_address_mapping[_vanity_url]  != address(0x0));
246     /* delete from address mapping */
247     delete(address_vanity_mapping[vanity_address_mapping[_vanity_url]]);
248     /* delete from vanity mapping */
249     delete(vanity_address_mapping[_vanity_url]);
250     /* sending VanityReleased event */
251     VanityReleased(_vanity_url);
252   }
253 
254   /*
255     function to kill contract
256   */
257 
258   function kill() onlyOwner {
259     selfdestruct(owner);
260   }
261 
262   /*
263     transfer eth recived to owner account if any
264   */
265   function() payable {
266     owner.transfer(msg.value);
267   }
268 
269 }