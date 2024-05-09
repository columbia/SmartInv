1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   uint256 public totalSupply;
51   function balanceOf(address who) constant returns (uint256);
52   function transfer(address to, uint256 value) returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 
57 
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) constant returns (uint256);
65   function transferFrom(address from, address to, uint256 value) returns (bool);
66   function approve(address spender, uint256 value) returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 contract Drainable is Ownable {
72 	function withdrawToken(address tokenaddr) 
73 		onlyOwner 
74 	{
75 		ERC20 token = ERC20(tokenaddr);
76 		uint bal = token.balanceOf(address(this));
77 		token.transfer(msg.sender, bal);
78 	}
79 
80 	function withdrawEther() 
81 		onlyOwner
82 	{
83 	    require(msg.sender.send(this.balance));
84 	}
85 }
86 
87 
88 contract ADXRegistry is Ownable, Drainable {
89 	string public name = "AdEx Registry";
90 
91 	// Structure:
92 	// AdUnit (advertiser) - a unit of a single advertisement
93 	// AdSlot (publisher) - a particular property (slot) that can display an ad unit
94 	// Campaign (advertiser) - group of ad units ; not vital
95 	// Channel (publisher) - group of properties ; not vital
96 	// Each Account is linked to all the items they own through the Account struct
97 
98 	mapping (address => Account) public accounts;
99 
100 	// XXX: mostly unused, because solidity does not allow mapping with enum as primary type.. :( we just use uint
101 	enum ItemType { AdUnit, AdSlot, Campaign, Channel }
102 
103 	// uint here corresponds to the ItemType
104 	mapping (uint => uint) public counts;
105 	mapping (uint => mapping (uint => Item)) public items;
106 
107 	// Publisher or Advertiser (could be both)
108 	struct Account {		
109 		address addr;
110 		address wallet;
111 
112 		bytes32 ipfs; // ipfs addr for additional (larger) meta
113 		bytes32 name; // name
114 		bytes32 meta; // metadata, can be JSON, can be other format, depends on the high-level implementation
115 
116 		bytes32 signature; // signature in the off-blockchain state channel
117 		
118 		// Items, by type, then in an array of numeric IDs	
119 		mapping (uint => uint[]) items;
120 	}
121 
122 	// Sub-item, such as AdUnit, AdSlot, Campaign, Channel
123 	struct Item {
124 		uint id;
125 		address owner;
126 
127 		ItemType itemType;
128 
129 		bytes32 ipfs; // ipfs addr for additional (larger) meta
130 		bytes32 name; // name
131 		bytes32 meta; // metadata, can be JSON, can be other format, depends on the high-level implementation
132 	}
133 
134 	modifier onlyRegistered() {
135 		var acc = accounts[msg.sender];
136 		require(acc.addr != 0);
137 		_;
138 	}
139 
140 	// can be called over and over to update the data
141 	// XXX consider entrance barrier, such as locking in some ADX
142 	function register(bytes32 _name, address _wallet, bytes32 _ipfs, bytes32 _sig, bytes32 _meta)
143 		external
144 	{
145 		require(_wallet != 0);
146 		// XXX should we ensure _sig is not 0? if so, also add test
147 		
148 		require(_name != 0);
149 
150 		var isNew = accounts[msg.sender].addr == 0;
151 
152 		var acc = accounts[msg.sender];
153 
154 		if (!isNew) require(acc.signature == _sig);
155 		else acc.signature = _sig;
156 
157 		acc.addr = msg.sender;
158 		acc.wallet = _wallet;
159 		acc.ipfs = _ipfs;
160 		acc.name = _name;
161 		acc.meta = _meta;
162 
163 		if (isNew) LogAccountRegistered(acc.addr, acc.wallet, acc.ipfs, acc.name, acc.meta, acc.signature);
164 		else LogAccountModified(acc.addr, acc.wallet, acc.ipfs, acc.name, acc.meta, acc.signature);
165 	}
166 
167 	// use _id = 0 to create a new item, otherwise modify existing
168 	function registerItem(uint _type, uint _id, bytes32 _ipfs, bytes32 _name, bytes32 _meta)
169 		onlyRegistered
170 	{
171 		// XXX _type sanity check?
172 		var item = items[_type][_id];
173 
174 		if (_id != 0)
175 			require(item.owner == msg.sender);
176 		else {
177 			// XXX: what about overflow here?
178 			var newId = ++counts[_type];
179 
180 			item = items[_type][newId];
181 			item.id = newId;
182 			item.itemType = ItemType(_type);
183 			item.owner = msg.sender;
184 
185 			accounts[msg.sender].items[_type].push(item.id);
186 		}
187 
188 		item.name = _name;
189 		item.meta = _meta;
190 		item.ipfs = _ipfs;
191 
192 		if (_id == 0) LogItemRegistered(
193 			item.owner, uint(item.itemType), item.id, item.ipfs, item.name, item.meta
194 		);
195 		else LogItemModified(
196 			item.owner, uint(item.itemType), item.id, item.ipfs, item.name, item.meta
197 		);
198 	}
199 
200 	// NOTE
201 	// There's no real point of un-registering items
202 	// Campaigns need to be kept anyway, as well as ad units
203 	// END NOTE
204 
205 	//
206 	// Constant functions
207 	//
208 	function isRegistered(address who)
209 		public 
210 		constant
211 		returns (bool)
212 	{
213 		var acc = accounts[who];
214 		return acc.addr != 0;
215 	}
216 
217 	// Functions exposed for web3 interface
218 	// NOTE: this is sticking to the policy of keeping static-sized values at the left side of tuples
219 	function getAccount(address _acc)
220 		constant
221 		public
222 		returns (address, bytes32, bytes32, bytes32)
223 	{
224 		var acc = accounts[_acc];
225 		require(acc.addr != 0);
226 		return (acc.wallet, acc.ipfs, acc.name, acc.meta);
227 	}
228 
229 	function getAccountItems(address _acc, uint _type)
230 		constant
231 		public
232 		returns (uint[])
233 	{
234 		var acc = accounts[_acc];
235 		require(acc.addr != 0);
236 		return acc.items[_type];
237 	}
238 
239 	function getItem(uint _type, uint _id) 
240 		constant
241 		public
242 		returns (address, bytes32, bytes32, bytes32)
243 	{
244 		var item = items[_type][_id];
245 		require(item.id != 0);
246 		return (item.owner, item.ipfs, item.name, item.meta);
247 	}
248 
249 	function hasItem(uint _type, uint _id)
250 		constant
251 		public
252 		returns (bool)
253 	{
254 		var item = items[_type][_id];
255 		return item.id != 0;
256 	}
257 
258 	// Events
259 	event LogAccountRegistered(address addr, address wallet, bytes32 ipfs, bytes32 accountName, bytes32 meta, bytes32 signature);
260 	event LogAccountModified(address addr, address wallet, bytes32 ipfs, bytes32 accountName, bytes32 meta, bytes32 signature);
261 	
262 	event LogItemRegistered(address owner, uint itemType, uint id, bytes32 ipfs, bytes32 itemName, bytes32 meta);
263 	event LogItemModified(address owner, uint itemType, uint id, bytes32 ipfs, bytes32 itemName, bytes32 meta);
264 }