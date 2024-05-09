1 /*
2  * Copyright 2019 Authpaper Team
3  *
4  * Licensed under the Apache License, Version 2.0 (the "License");
5  * you may not use this file except in compliance with the License.
6  * You may obtain a copy of the License at
7  *
8  *      http://www.apache.org/licenses/LICENSE-2.0
9  *
10  * Unless required by applicable law or agreed to in writing, software
11  * distributed under the License is distributed on an "AS IS" BASIS,
12  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13  * See the License for the specific language governing permissions and
14  * limitations under the License.
15  */
16 pragma solidity ^0.5.1;
17 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
18 
19 contract Adminstrator {
20   address public admin;
21   address payable public owner;
22 
23   modifier onlyAdmin() { 
24         require(msg.sender == admin || msg.sender == owner,"Not authorized"); 
25         _;
26   } 
27 
28   constructor() public {
29     admin = msg.sender;
30 	owner = msg.sender;
31   }
32 
33   function transferAdmin(address newAdmin) public onlyAdmin {
34     admin = newAdmin; 
35   }
36 }
37 contract FiftyContract is Adminstrator {//,usingOraclize {
38     uint public mRate = 150 finney; //membership fee
39 	uint public membershiptime = 183 * 86400; //183 days, around 0.5 year
40 	uint public divideRadio = 49; //The divide ratio, each uplevel will get 0.48 by default
41 	mapping (address => uint) public membership;
42 	event membershipExtended(address indexed _self, uint newexpiretime);
43 	
44 	string public website="http://globalcfo.org/getAddresses.php?eth=";
45 	string public websiteGrand="http://globalcfo.org/getAddresses.php?grand=1&eth=";
46 	mapping (bytes32 => treeNode) public oraclizeCallbacks;
47 	
48 	//About the tree
49 	event completeTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);
50 	event startTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);
51 	event assignTreeNode(address indexed _self, uint indexed _nodeID, uint indexed _amount, address _root);
52 	event distributeETH(address indexed _to, address _from, uint _amount);
53 	//Keep the nodeID they are using, (2 ** 32) - 1 means they are banned
54 	mapping (address => mapping (uint => uint)) public nodeIDIndex;
55 	//Keep children of a node, no matter the tree is completed or not
56 	//treeNode => mapping (uint => treeNode)
57 	mapping (address => mapping (uint => mapping (uint => mapping (uint => treeNode)))) public treeChildren;
58 	mapping (address => mapping (uint => mapping (uint => treeNode))) public treeParent;
59 	//Keep the current running nodes given an address
60 	mapping (address => mapping (uint => bool)) public currentNodes;
61 	//Temporary direct referral
62 	mapping (address => mapping (uint => mapping (uint => address))) public tempDirRefer;
63 	mapping (address => address) public tempSearchRefer;
64 	uint public spread=2;
65 	uint public minimumTreeNodeReferred=2;
66 	uint public minTreeType=1;
67 	uint public maxTreeType=4;
68 	
69 	struct treeNode {
70 		 address payable ethAddress; 
71 		 uint nodeType; 
72 		 uint nodeID;
73 		 bool isDirectParent;
74 	}
75 	struct rewardDistribution {
76 		address payable first;
77 		address payable second;
78 	}
79 	
80 	//Statistic issue
81 	uint256 public receivedAmount=0;
82 	uint256 public sentAmount=0;
83 	bool public paused=false;
84 	mapping (address => uint) public nodeLatestAction;
85 	mapping (address => uint) public nodeReceivedETH;
86 	mapping (address => mapping (uint => nodeAction)) public nodeActionHistory;
87 	struct nodeAction {
88 		nodeActionType aType;
89 		uint8 nodePlace;
90 		uint256 treeType;
91 	}
92 	enum nodeActionType{
93 		joinMember,
94 		startTree,
95 		addNode,
96 		completeTree
97 	}
98 	event Paused(address account);
99 	event Unpaused(address account);
100 	event makeQuery(address indexed account, string msg);
101 	
102 	//Setting the variables
103 	function setMembershipFee(uint newMrate, uint newTime) public onlyAdmin{
104 		require(newMrate > 0, "new rate must be positive");
105 		require(newTime > 0, "new membership time must be positive");
106 		mRate = newMrate * 10 ** uint256(15); //In finney
107 		membershiptime = newTime * 86400; //In days
108 		
109 	}
110 	function setTreeSpec(uint newSpread, uint newDivideRate, uint newTreeNodeReferred) public onlyAdmin{
111 		require(newSpread > 1, "new spread must > 1");
112 		require(newDivideRate > 1, "new divide level must > 1");
113 		require(newTreeNodeReferred > 1, "new min tree nodes referred by root must > 1");
114 		spread = newSpread;
115 		divideRadio = newDivideRate;
116 		minimumTreeNodeReferred = newTreeNodeReferred;
117 	}
118 	function setWebAndTreeType(string memory web, string memory webGrand, uint minTreeSize, uint maxTreeSize) public onlyAdmin{
119 		require(minTreeSize > 0, "min tree size must > 0");
120 		require(maxTreeSize > minTreeSize, "max tree size must > min");
121 		website = web;
122 		websiteGrand = webGrand;
123 		minTreeType = minTreeSize;
124 		maxTreeType = maxTreeSize;
125 	}
126 	function pause(bool isPause) public onlyAdmin{
127 		paused = isPause;
128 		if(isPause) emit Paused(msg.sender);
129 		else emit Unpaused(msg.sender);
130 	}
131 	function withdraw(uint amount) public onlyAdmin returns(bool) {
132         require(amount < address(this).balance);
133         owner.transfer(amount);
134         return true;
135     }
136     function withdrawAll() public onlyAdmin returns(bool) {
137         uint balanceOld = address(this).balance;
138         owner.transfer(balanceOld);
139         return true;
140     }
141 	function _addMember(address _member) internal {
142 		require(_member != address(0));
143 		if(membership[_member] <= now) membership[_member] = now;
144 		membership[_member] += membershiptime;
145 		emit membershipExtended(_member,membership[_member]);
146 		nodeActionHistory[_member][nodeLatestAction[_member]] 
147 		    = nodeAction(nodeActionType.joinMember,0,membership[_member]);
148 		nodeLatestAction[_member] +=1;
149 	}
150 	function addMember(address member) public onlyAdmin {
151 		_addMember(member);
152 	}
153 	function banMember(address member) public onlyAdmin {
154 		require(member != address(0));
155 		membership[member] = 0;
156 	}
157 	function checkMemberShip(address member) public view returns(uint) {
158 		require(member != address(0));
159 		return membership[member];
160 	}
161 	
162 	function testReturnDefault() public{
163 		__callback(bytes32("AAA"),"0xa5bc03ddc951966b0df385653fa5b7cadf1fc3da");
164 	}
165 	function testReturnRoot() public{
166 		__callback(bytes32("AAA"),"0x22dc2c686e2e23af806aaa0c7c65f81e00adbc99");
167 	}
168 	function testReturnRootGrand() public{
169 		__callback(bytes32("BBB"),"0x22dc2c686e2e23af806aaa0c7c65f81e00adbc99");
170 	}
171 	function testReturnChild1() public{
172 		__callback(bytes32("AAA"),"0x44822c4b2f76d05d7e0749908021453d205275fc");
173 	}
174 	function testReturnChild1Grand() public{
175 		__callback(bytes32("BBB"),"0x44822c4b2f76d05d7e0749908021453d205275fc");
176 	}
177 	
178 	function() external payable { 
179 		require(!paused,"The contract is paused");
180 		require(address(this).balance + msg.value > address(this).balance);
181 		
182 		uint newTreeType; uint reminder;
183 		for(uint i=minTreeType;i<=maxTreeType;i++){
184 		    uint tti = i * 10 ** uint256(18);
185 			if(msg.value>=tti) newTreeType=tti;
186 		}
187 		reminder = msg.value-newTreeType;
188 		if(newTreeType <minTreeType && msg.value == mRate){
189 			_addMember(msg.sender);
190 			return;
191 		}
192 		require(newTreeType >= (minTreeType *10 ** uint256(18)),
193 		    "No tree can create");
194 		if(reminder >= mRate){
195 			_addMember(msg.sender);
196 			reminder -= mRate;
197 		}
198 		//require(msg.value >= 1 ether ,"Not enough ETH");
199 		require(reminder <= msg.value, "Too much reminder");
200 		require(membership[msg.sender] > now,"Membership not valid");
201 		//First of all, create a tree with this node as the root
202 		address payable sender = msg.sender;
203 		require(currentNodes[sender][newTreeType] == false,"Started this kind of tree already");
204 		require(nodeIDIndex[sender][newTreeType] < (2 ** 32) -1,"Banned from this kind of tree already");
205 		currentNodes[sender][newTreeType] = true;
206 		nodeIDIndex[sender][newTreeType] += 1;
207 		receivedAmount += msg.value;
208 		emit startTree(sender, nodeIDIndex[sender][newTreeType] - 1, newTreeType);
209 		if(reminder>0){
210 			sender.transfer(reminder);
211 			sentAmount +=reminder;
212 		}
213 		nodeActionHistory[sender][nodeLatestAction[sender]] = nodeAction(nodeActionType.startTree,0,newTreeType);
214 		nodeLatestAction[sender] +=1;
215 		//Make web call to find its uplines
216 		//Remember, each query burns 0.01 USD from the contract !!
217 		string memory queryStr = strConcating(website,addressToString(sender));
218 		emit makeQuery(msg.sender,"Oraclize query sent");
219 		//bytes32 queryId=oraclize_query("URL", queryStr, 600000);
220 		bytes32 queryId=bytes32("AAA");
221         oraclizeCallbacks[queryId] = 
222 			treeNode(msg.sender,newTreeType,nodeIDIndex[msg.sender][newTreeType] - 1,true);
223 	}
224 	function __callback(bytes32 myid, string memory result) public {
225         //if (msg.sender != oraclize_cbAddress()) revert();
226         treeNode memory o = oraclizeCallbacks[myid];
227 		bytes memory _baseBytes = bytes(result);
228 		require(_baseBytes.length == 42, "The return string is not valid");
229 		address payable firstUpline=parseAddrFromStr(result);
230 		require(firstUpline != address(0), "The firstUpline is incorrect");
231 		
232 		uint treeType = o.nodeType;
233 		address payable treeRoot = o.ethAddress;
234 		uint treeNodeID = o.nodeID;
235 		//If this has been searched before
236 		if(tempSearchRefer[treeRoot] == firstUpline || firstUpline == owner) return;
237 		if(o.isDirectParent) tempDirRefer[treeRoot][treeType][treeNodeID] = firstUpline;
238 		//Now check its parent for a place for node
239 		rewardDistribution memory rewardResult = _placeChildTree(firstUpline,treeType,treeRoot,treeNodeID);
240 		if(rewardResult.first == address(0)){
241 			//Search not successful, find upline
242 			tempSearchRefer[treeRoot] = firstUpline;
243 			string memory queryStr = strConcating(websiteGrand,result);
244 			emit makeQuery(msg.sender,"Oraclize query sent");
245 			//bytes32 queryId=oraclize_query("URL", queryStr, 600000);
246 			bytes32 queryId=bytes32("BBB");
247             oraclizeCallbacks[queryId] = treeNode(treeRoot,treeType,treeNodeID,false);            
248 			return;
249 		}
250 		tempSearchRefer[treeRoot] = address(0);
251 		emit assignTreeNode(treeRoot,treeNodeID,treeType,rewardResult.first);
252 		//Distribute the award
253 		uint moneyToDistribute = (treeType * divideRadio) / 100;
254 		require(treeType >= 2*moneyToDistribute, "Too much ether to send");
255 		require(address(this).balance > treeType, "Nothing to send");
256 		uint previousBalances = address(this).balance;
257 		if(rewardResult.first != address(0)){
258 			rewardResult.first.transfer(moneyToDistribute);
259 			sentAmount += moneyToDistribute;
260 			nodeReceivedETH[rewardResult.first] += moneyToDistribute;
261 			emit distributeETH(rewardResult.first, treeRoot, moneyToDistribute);
262 		} 
263 		if(rewardResult.second != address(0)){
264 			rewardResult.second.transfer(moneyToDistribute);
265 			sentAmount += moneyToDistribute;
266 			nodeReceivedETH[rewardResult.second] += moneyToDistribute;
267 			emit distributeETH(rewardResult.second, treeRoot, moneyToDistribute);
268 		}
269 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
270         assert(address(this).balance + (2*moneyToDistribute) >= previousBalances);
271     }
272 	function _placeChildTree(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) internal returns(rewardDistribution memory) {
273 		//We do BFS here, so need to search layer by layer
274 		address payable getETHOne = address(0); address payable getETHTwo = address(0);
275 		uint8 firstLevelSearch=_placeChild(firstUpline,treeType,treeRoot,treeNodeID); 
276 		if(firstLevelSearch == 1){
277 			getETHOne=firstUpline;
278 			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
279 			nodeActionHistory[getETHOne][nodeLatestAction[getETHOne]] = nodeAction(nodeActionType.addNode,1,treeType);
280 			nodeLatestAction[getETHOne] +=1;
281 			//So the firstUpline will get the money, as well as the parent of the firstUpline
282 			if(treeParent[firstUpline][treeType][cNodeID].nodeType != 0){
283 				getETHTwo = treeParent[firstUpline][treeType][cNodeID].ethAddress;
284 				nodeActionHistory[getETHTwo][nodeLatestAction[getETHTwo]] = nodeAction(nodeActionType.addNode,2,treeType);
285 				nodeLatestAction[getETHTwo] +=1;
286 			}
287 		}
288 		//The same address has been here before
289 		if(firstLevelSearch == 2) return rewardDistribution(address(0),address(0));
290 		if(getETHOne == address(0)){
291 			//Now search the grandchildren of the firstUpline for a place
292 			if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
293 				uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
294 				for (uint256 i=0; i < spread; i++) {
295 					if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType != 0){
296 						treeNode memory kids = treeChildren[firstUpline][treeType][cNodeID][i];
297 						if(_placeChild(kids.ethAddress,treeType,treeRoot,treeNodeID) == 1){
298 							getETHOne=kids.ethAddress;
299 							//So the child of firstUpline will get the money, as well as the child
300 							getETHTwo = firstUpline;
301 							nodeActionHistory[getETHOne][nodeLatestAction[getETHOne]] = nodeAction(nodeActionType.addNode,1,treeType);
302 							nodeLatestAction[getETHOne] +=1;
303 							nodeActionHistory[getETHTwo][nodeLatestAction[getETHTwo]] = nodeAction(nodeActionType.addNode,2,treeType);
304 							nodeLatestAction[getETHTwo] +=1;
305 						}
306 					}
307 				}
308 			}
309 		}
310 		return rewardDistribution(getETHOne,getETHTwo);
311 	}
312 	//Return 0, there is no place for the node, 1, there is a place and placed, 2, duplicate node is found
313 	function _placeChild(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) internal returns(uint8) {
314 		if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
315 			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
316 			for (uint256 i=0; i < spread; i++) {
317 				if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType == 0){
318 					//firstUpline has a place
319 					treeChildren[firstUpline][treeType][cNodeID][i]
320 						= treeNode(treeRoot,treeType,treeNodeID,false);
321 					//Set parent
322 					treeParent[treeRoot][treeType][treeNodeID] 
323 						= treeNode(firstUpline,treeType,cNodeID,false);
324 					_checkTreeComplete(firstUpline,treeType,cNodeID);
325 					return 1;
326 				}else{
327 				    treeNode memory kids = treeChildren[firstUpline][treeType][cNodeID][i];
328 				    //The child has been here in previous project
329 				    if(kids.ethAddress == treeRoot) return 2;
330 				}
331 			}
332 		}
333 		return 0;
334 	}
335 	function _checkTreeComplete(address _root, uint _treeType, uint _nodeID) internal {
336 		require(_root != address(0), "Tree root to check completness is 0");
337 		bool _isCompleted = true;
338 		uint _isDirectRefCount = 0;
339 		for (uint256 i=0; i < spread; i++) {
340 			if(treeChildren[_root][_treeType][_nodeID][i].nodeType == 0){
341 				_isCompleted = false;
342 				break;
343 			}else{
344 				//Search the grandchildren
345 				treeNode memory _child = treeChildren[_root][_treeType][_nodeID][i];
346 				address referral = tempDirRefer[_child.ethAddress][_child.nodeType][_child.nodeID];
347 				if(referral == _root) _isDirectRefCount += 1;
348 				for (uint256 a=0; a < spread; a++) {
349 					if(treeChildren[_child.ethAddress][_treeType][_child.nodeID][a].nodeType == 0){
350 						_isCompleted = false;
351 						break;
352 					}else{
353 						treeNode memory _gChild=treeChildren[_child.ethAddress][_treeType][_child.nodeID][a];
354 						address referral2 = tempDirRefer[_gChild.ethAddress][_gChild.nodeType][_gChild.nodeID];
355 						if(referral2 == _root) _isDirectRefCount += 1;
356 					}
357 				}
358 				if(!_isCompleted) break;
359 			}
360 		}
361 		if(!_isCompleted) return;
362 		//The tree is completed, root can start over again
363 		currentNodes[_root][_treeType] = false;
364 		//Ban this user
365 		if(_isDirectRefCount <= minimumTreeNodeReferred) nodeIDIndex[_root][_treeType] = (2 ** 32) -1;
366 		nodeActionHistory[_root][nodeLatestAction[_root]] = nodeAction(nodeActionType.completeTree,0,_treeType);
367 		nodeLatestAction[_root] +=1;
368 	}
369     function strConcating(string memory _a, string memory _b) internal pure returns (string memory){
370         bytes memory _ba = bytes(_a);
371         bytes memory _bb = bytes(_b);
372         string memory ab = new string(_ba.length + _bb.length);
373         bytes memory bab = bytes(ab);
374         uint k = 0;
375         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
376         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
377         return string(bab);
378     }
379     function addressToString(address _addr) public pure returns(string memory) {
380         bytes32 value = bytes32(uint256(_addr));
381         bytes memory alphabet = "0123456789abcdef";    
382         bytes memory str = new bytes(42);
383         str[0] = '0';
384         str[1] = 'x';
385         for (uint i = 0; i < 20; i++) {
386             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
387             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
388         }
389         return string(str);
390     }
391 
392       function parseAddrFromStr(string memory _a) internal pure returns (address payable){
393          bytes memory tmp = bytes(_a);
394          uint160 iaddr = 0;
395          uint160 b1;
396          uint160 b2;
397          for (uint i=2; i<2+2*20; i+=2){
398              iaddr *= 256;
399              b1 = uint8(tmp[i]);
400              b2 = uint8(tmp[i+1]);
401              if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
402              else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
403              if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
404              else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
405              iaddr += (b1*16+b2);
406          }
407          return address(iaddr);
408     }
409 }