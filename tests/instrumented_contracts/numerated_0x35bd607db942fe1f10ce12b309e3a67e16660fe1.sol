1 pragma solidity ^0.4.9;
2 
3 contract OrangeGov_Main {
4     address public currentContract;
5     
6 	mapping(address=>mapping(string=>bool)) permissions;
7 	mapping(address=>mapping(string=>bool)) userStatuses;
8 	mapping(string=>address) contractIDs;
9 	mapping(string=>bool) contractIDExists;
10 	address[] contractArray; //the contracts in the above 2 tables
11 	function OrangeGov_Main () {
12 	    permissions[msg.sender]["all"]=true;
13 	}
14 	function getHasPermission(address user, string permissionName, string userStatusAllowed) returns (bool hasPermission){ //for use between contracts
15 	    return permissions[msg.sender][permissionName]||permissions[msg.sender]["all"]||userStatuses[msg.sender][userStatusAllowed];
16 	}
17 	function getContractByID(string ID) returns (address addr,bool exists){ //for use between contracts
18 	    return (contractIDs[ID],contractIDExists[ID]);
19 	}
20 	
21     modifier permissionRequired(string permissionName,string userStatusAllowed) {
22         _; //code will be run; code MUST have variable permissionName(name of permission) and userStatusAllowed(a certain user statu is the only thing necessary)
23         if (getHasPermission(msg.sender,permissionName,userStatusAllowed)){
24             throw;
25         }
26     }
27     
28     function removeFromContractIDArray(address contractToRemove) {
29         for (uint x=0;x<contractArray.length-1;x++) {
30             if (contractArray[x]==contractToRemove) {
31                 contractArray[x]=contractArray[contractArray.length-1];
32 	            contractArray.length--;
33 	            return;
34             }
35         }
36     }
37     
38 	function addContract(string ID,bytes code) permissionRequired("addContract",""){
39 	    address addr;
40         assembly {
41             addr := create(0,add(code,0x20), mload(code))
42             jumpi(invalidJumpLabel,iszero(extcodesize(addr)))
43         }
44         address oldAddr = contractIDs[ID];
45 	    contractIDs[ID]=addr;
46 	    contractIDExists[ID]=true;
47 	    oldAddr.call.gas(msg.gas)(bytes4(sha3("changeCurrentContract(address)")),addr); //if there was a previous contract, tell it the new one's address
48 	    addr.call.gas(msg.gas)(bytes4(sha3("tellPreviousContract(address)")),oldAddr); //feed it the address of the previous contract
49 	    removeFromContractIDArray(addr);
50 	    contractArray.length++;
51 	    contractArray[contractArray.length-1]=addr;
52 	}
53 	function removeContract(string ID) permissionRequired("removeContract",""){
54 	    contractIDExists[ID]=false;
55 	    contractIDs[ID].call.gas(msg.gas)(bytes4(sha3("changeCurrentContract(address)")),currentContract); //make sure people using know it's out of service
56 	    removeFromContractIDArray(contractIDs[ID]);
57 	}
58 	function update(bytes code) permissionRequired("update",""){
59 	    address addr;
60         assembly {
61             addr := create(0,add(code,0x20), mload(code))
62             jumpi(invalidJumpLabel,iszero(extcodesize(addr)))
63         }
64         addr.call.gas(msg.gas)(bytes4(sha3("tellPreviousContract(address)")),currentContract);
65         currentContract = addr;
66         for (uint x=0;x<contractArray.length-1;x++) {
67             contractArray[x].call.gas(msg.gas)(bytes4(sha3("changeMain(address)")),currentContract);
68         }
69 	}
70 	function tellPreviousContract(address prev) { //called in the update process
71 	    
72 	}
73 	function spendEther(address addr, uint256 weiAmt) permissionRequired("spendEther",""){
74 	    if (!addr.send(weiAmt)) throw;
75 	}
76 	function givePermission(address addr, string permission) permissionRequired("givePermission",""){
77 	    if (getHasPermission(msg.sender,permission,"")){
78 	        permissions[addr][permission]=true;
79 	    }
80 	}
81 	function removePermission(address addr, string permission) permissionRequired("removePermission",""){
82 	    permissions[addr][permission]=false;
83 	}
84 }