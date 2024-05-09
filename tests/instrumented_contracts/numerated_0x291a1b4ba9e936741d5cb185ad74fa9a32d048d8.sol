1 pragma solidity ^0.4.19;
2 
3 contract owned {
4     address public owner;
5     function owned() public {owner = msg.sender;}
6     modifier onlyOwner {require(msg.sender == owner);_;}
7     function transferOwnership(address newOwner) onlyOwner public {owner = newOwner;}
8 }
9 
10 contract WithdrawalContract is owned {
11     address public richest;
12     uint public mostSent;
13     mapping (address => uint) pendingWithdrawals;
14     function WithdrawalContract() public payable {
15         richest = msg.sender;
16         mostSent = msg.value;
17     }
18     function becomeRichest() public payable returns (bool) {
19         if (msg.value > mostSent) {
20             pendingWithdrawals[richest] += msg.value;
21             richest = msg.sender;
22             mostSent = msg.value;
23             return true;
24         } else {
25             return false;
26         }
27     }
28     function withdraw() public onlyOwner {
29         uint amount = pendingWithdrawals[msg.sender];
30         pendingWithdrawals[msg.sender] = 0;
31         msg.sender.transfer(amount);
32     }
33     function setMostSent(uint _newMostSent) public onlyOwner {
34         mostSent = _newMostSent;
35     }
36 }
37 
38 contract SimpleMarket is owned, WithdrawalContract {
39 
40     uint public    startPrice;
41     uint public    fixPrice  = 0.1 ether;
42     uint internal  decimals  = 0;
43     bytes32 public productId = 0x0;
44 
45 	struct UserStruct {
46 		uint userListPointer;
47 		bytes32[] productKeys;
48 		bytes32 userEmail;
49 		bytes32 userName;
50 		mapping(bytes32 => uint) productKeyPointers;
51 	}
52 
53 	mapping(bytes32 => UserStruct) public userStructs;
54 	bytes32[] public userList;
55 
56 	struct ProductStruct {
57 		uint productListPointer;
58 		bytes32 userKey;
59 		bytes32 size;
60 		uint productPrice;
61 		string delivery;
62 		bool inSale;
63 		address[] historyUser;
64 		uint[] historyDate;
65 		uint[] historyPrice;
66 	}
67 
68 	mapping(bytes32 => ProductStruct) public productStructs;
69 	bytes32[] public productList;
70 
71 	event LogNewUser(address sender, bytes32 userId);
72 	event LogNewProduct(address sender, bytes32 productId, bytes32 userId);
73 	event LogUserDeleted(address sender, bytes32 userId);
74 	event LogProductDeleted(address sender, bytes32 productId);
75 
76 	function getUserCount() public constant returns(uint userCount) {
77 		return userList.length;
78 	}
79 
80 	function getProductCount() public constant returns(uint productCount){
81 		return productList.length;
82 	}
83 	
84 	function getUserProductsKeys(bytes32 _userId) public view returns(bytes32[]){
85 	    require(isUser(_userId));
86 	    return userStructs[_userId].productKeys;
87 	}
88 
89 	function getProductHistoryUser(bytes32 _productId) public view returns(address[]) {
90 	    return productStructs[_productId].historyUser;
91 	}
92 
93 	function getProductHistoryDate(bytes32 _productId) public view returns(uint[]) {
94 	    return productStructs[_productId].historyDate;
95 	}
96 
97 	function getProductHistoryPrice(bytes32 _productId) public view returns(uint[]) {
98 	    return productStructs[_productId].historyPrice;
99 	}
100 
101 	function isUser(bytes32 userId) public constant returns(bool isIndeed) {
102 		if(userList.length==0) return false;
103 		return userList[userStructs[userId].userListPointer] == userId;
104 	}
105 
106 	function isProduct(bytes32 _productId) public constant returns(bool isIndeed) {
107 		if(productList.length==0) return false;
108 		return productList[productStructs[_productId].productListPointer] == _productId;
109 	}
110 
111 	function isUserProduct(bytes32 _productId, bytes32 _userId) public constant returns(bool isIndeed) {
112 
113 		if(productList.length==0) return false;
114 		if(userList.length==0) return false;
115 
116 		return productStructs[_productId].userKey == _userId;
117 	}
118 
119 	function getUserProductCount(bytes32 userId) public constant returns(uint productCount) {
120 		require(isUser(userId));
121 		return userStructs[userId].productKeys.length;
122 	}
123 
124 	function getUserProductAtIndex(bytes32 userId, uint row) public constant returns(bytes32 productKey) {
125 		require(isUser(userId));
126 		return userStructs[userId].productKeys[row];
127 	}
128 
129 	function createUser(bytes32 _userName, bytes32 _userEmail) public {
130 	    require(msg.sender != 0);
131         bytes32 userId = bytes32(msg.sender);
132 		require(!isUser(userId));
133 
134 		userStructs[userId].userListPointer = userList.push(userId)-1;
135 		userStructs[userId].userEmail       = _userEmail;
136 		userStructs[userId].userName        = _userName;
137 
138 		LogNewUser(msg.sender, userId);
139 	}
140 
141 	function createProduct(bytes32 _size, string delivery, bytes32 _userName, bytes32 _userEmail) public payable returns(bool success) {
142 		
143 		require(msg.sender != 0);
144         require(startPrice != 0);
145         require(msg.value  >= startPrice);
146         require(productList.length <= 100);
147         
148 		bytes32 userId    = bytes32(msg.sender);
149 		uint productCount = productList.length + 1;
150 		productId         = bytes32(productCount);
151 
152         if(!isUser(userId)) {
153             require(_userName !=0);
154             require(_userEmail !=0);
155             createUser(_userName, _userEmail);
156         }
157 
158 		require(isUser(userId));
159 		require(!isProduct(productId));
160 
161 		productStructs[productId].productListPointer = productList.push(productId)-1;
162 		productStructs[productId].userKey            = userId;
163 		productStructs[productId].size               = _size;
164 		productStructs[productId].productPrice       = startPrice;
165 		productStructs[productId].delivery           = delivery;
166 		productStructs[productId].inSale             = false;
167 
168 		productStructs[productId].historyUser.push(msg.sender);
169 		productStructs[productId].historyDate.push(now);
170 		productStructs[productId].historyPrice.push(startPrice);
171 		
172 		userStructs[userId].productKeyPointers[productId] = userStructs[userId].productKeys.push(productId) - 1;
173 		
174 		LogNewProduct(msg.sender, productId, userId);
175 		
176 		uint oddMoney = msg.value - startPrice;
177 
178         this.transfer(startPrice);
179         uint countProduct = getProductCount();
180         startPrice        = ((countProduct * fixPrice) + fixPrice) * 10 ** decimals;
181 
182         msg.sender.transfer(oddMoney);
183 
184 		return true;
185 	}
186 
187 	function deleteUser(bytes32 userId) public onlyOwner returns(bool succes) {
188 
189 		require(isUser(userId));
190 		require(userStructs[userId].productKeys.length <= 0);
191 
192 		uint rowToDelete  = userStructs[userId].userListPointer;
193 		bytes32 keyToMove = userList[userList.length-1];
194 
195 		userList[rowToDelete]                  = keyToMove;
196 		userStructs[keyToMove].userListPointer = rowToDelete;
197 		userStructs[keyToMove].userEmail       = 0x0;
198 		userStructs[keyToMove].userName        = 0x0;
199 
200 		userList.length--;
201 
202 		LogUserDeleted(msg.sender, userId);
203 
204 		return true;
205 	}
206 
207 	function deleteProduct(bytes32 _productId) public onlyOwner returns(bool success) {
208 		
209 		require(isProduct(_productId));
210 		
211 		uint rowToDelete                              = productStructs[_productId].productListPointer;
212 		bytes32 keyToMove                             = productList[productList.length-1];
213 
214 		productList[rowToDelete]                      = keyToMove;
215 		productStructs[_productId].productListPointer = rowToDelete;
216 		
217 		productList.length--;
218 
219 		bytes32 userId = productStructs[_productId].userKey;
220 		rowToDelete    = userStructs[userId].productKeyPointers[_productId];
221 		keyToMove      = userStructs[userId].productKeys[userStructs[userId].productKeys.length-1];
222 
223 		userStructs[userId].productKeys[rowToDelete]      = keyToMove;
224 		userStructs[userId].productKeyPointers[keyToMove] = rowToDelete;
225 		
226 		userStructs[userId].productKeys.length--;
227 		
228 		LogProductDeleted(msg.sender, _productId);
229 		uint countProduct = getProductCount();
230 		productId = bytes32(countProduct - 1);
231 		
232 		return true;
233 	}
234 
235 	function changeOwner(
236 	    bytes32 _productId, 
237 	    bytes32 _oldOwner, 
238 	    bytes32 _newOwner, 
239 	    address oldOwner, 
240 	    string _newDelivery,
241 	    bytes32 _userName,
242 	    bytes32 _userEmail
243 	    ) public payable returns (bool success) {
244 
245 	    require(isProduct(_productId));
246 	    require(isUser(_oldOwner));
247 	    require(msg.value >= productStructs[_productId].productPrice);
248 
249 	    if(isUserProduct(_productId, _newOwner)) return false;
250 
251 	    if(!isUser(_newOwner)) {
252             require(_userName !=0);
253             require(_userEmail !=0);
254             createUser(_userName, _userEmail);
255         }
256 
257 	    productStructs[_productId].userKey  = _newOwner;
258 		productStructs[_productId].delivery = _newDelivery;
259 		productStructs[_productId].inSale   = false;
260 
261 		productStructs[_productId].historyUser.push(msg.sender);
262 		productStructs[_productId].historyDate.push(now);
263 		productStructs[_productId].historyPrice.push(productStructs[_productId].productPrice);
264 		
265     	userStructs[_newOwner].productKeyPointers[_productId] = userStructs[_newOwner].productKeys.push(_productId) - 1;
266 
267         bool start = false;
268 
269     	for(uint i=0;i<userStructs[_oldOwner].productKeys.length;i++) {
270     	    if((i+1) == userStructs[_oldOwner].productKeys.length){
271     	        userStructs[_oldOwner].productKeys[i] = 0x0;
272     	    }else{
273     	        if(userStructs[_oldOwner].productKeys[i] == _productId || start){
274     	            userStructs[_oldOwner].productKeys[i] = userStructs[_oldOwner].productKeys[i+1];
275     	            start = true;
276     	        }
277     	    }
278 		}
279 		
280 		delete userStructs[_oldOwner].productKeyPointers[_productId];
281 		delete userStructs[_oldOwner].productKeys[userStructs[_oldOwner].productKeys.length-1];
282         userStructs[_oldOwner].productKeys.length--;
283 		
284 		this.transfer(msg.value);
285 		oldOwner.transfer(msg.value);
286 
287 	    return true;
288 	}
289 	
290 	function changeInSale(bytes32 _productId, bytes32 _userId, uint _newPrice) public payable returns(bool success) {
291 
292 	   require(isProduct(_productId));
293 	   require(isUser(_userId));
294 
295 	   productStructs[_productId].productPrice = _newPrice;
296 	   productStructs[_productId].inSale       = true;
297 
298 	   return true;
299 	}
300 
301     function setPrices(uint _newPrice) internal {
302         require(_newPrice != 0);
303         if(startPrice == 0) {
304             startPrice = (1 ether / _newPrice) * 10 ** decimals;
305         } else {
306             uint countProduct = getProductCount();
307             startPrice = (1 ether / (countProduct * _newPrice)) * 10 ** decimals;
308         }
309     }
310 
311     function setFixPrice(uint _newFixPrice) public payable onlyOwner returns(bool success) {
312         require(msg.sender   != 0);
313         require(_newFixPrice != 0);
314         fixPrice = _newFixPrice;
315         return true;
316     }
317 
318     function setDecimals(uint _newDecimals) public payable onlyOwner returns(bool success) {
319         require(msg.sender != 0);
320         decimals = _newDecimals;
321         return true;
322     }
323 
324     function() public payable {}
325 
326     function SimpleMarket() public payable {
327         startPrice = 0.1 ether;
328     }
329 }