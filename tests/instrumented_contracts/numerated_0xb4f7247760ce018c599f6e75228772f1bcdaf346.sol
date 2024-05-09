1 pragma solidity ^0.5.3;
2 
3 contract FiftyContract {
4 	mapping (address => mapping (uint => mapping (uint => mapping (uint => treeNode)))) public treeChildren;
5 	mapping (address => mapping (uint => bool)) public currentNodes;
6 	mapping (address => mapping (uint => uint)) public nodeIDIndex;
7 	mapping (address => uint) public membership;
8 	struct treeNode {
9 		 address payable ethAddress; 
10 		 uint nodeType; 
11 		 uint nodeID;
12 	}
13 	uint public spread;
14 	mapping (address => uint) public nodeLatestAction;
15 	mapping (address => uint) public nodeReceivedETH;
16 	mapping (address => mapping (uint => nodeAction)) public nodeActionHistory;
17 	struct nodeAction {
18 		nodeActionType aType;
19 		uint8 nodePlace;
20 		uint256 treeType;
21 	}
22 	enum nodeActionType{
23 		joinMember,
24 		startTree,
25 		addNode,
26 		completeTree
27 	}
28 }
29 contract Adminstrator {
30   address public admin;
31   address payable public owner;
32 
33   modifier onlyAdmin() { 
34         require(msg.sender == admin || msg.sender == owner,"Not authorized"); 
35         _;
36   } 
37 
38   constructor() public {
39     admin = msg.sender;
40 	owner = msg.sender;
41   }
42 
43   function transferAdmin(address newAdmin) public onlyAdmin {
44     admin = newAdmin; 
45   }
46 }
47 contract readFiftyContract is Adminstrator{
48 	
49 	address public baseAddr = 0x8F3290F075A1ebB50275545980cF1f9EAC647A54;
50 	FiftyContract bcontract = FiftyContract(baseAddr);
51 	
52 	function setContract(address newAddr) public onlyAdmin {
53 		baseAddr = newAddr;
54 		bcontract = FiftyContract(baseAddr);
55 	}
56 	function getReceivedETH(address r) public view returns (uint, uint, uint, uint, uint){
57 		return ( bcontract.nodeReceivedETH(r) , bcontract.nodeIDIndex(r, 1 ether) 
58 		, bcontract.nodeIDIndex(r, 2 ether) , bcontract.nodeIDIndex(r, 3 ether) 
59 		, bcontract.nodeIDIndex(r, 4 ether) );
60 	}
61 	function getTree(address r, uint t, uint cc) public view returns(address[7] memory){
62 		address[7] memory Adds;
63 		if(bcontract.nodeIDIndex(r,t) <= cc) return Adds;
64 		(,uint pp,) = bcontract.treeChildren(r,t,cc,0);
65 		if (pp!=0 || bcontract.nodeIDIndex(r,t) == (cc+1) ) Adds[0]=r;
66 		else return Adds;
67 		uint8 spread = uint8(bcontract.spread());
68 		for (uint8 i=0; i < spread; i++) {
69 		    (address k,uint p,uint m) = bcontract.treeChildren(r,t,cc,i);
70 			if(p != 0){
71 				Adds[i+1]=k;
72 				for (uint8 a=0; a < spread; a++) {
73 				    (address L,uint q,) = bcontract.treeChildren(k,p,m,a);    
74 					if(q != 0) Adds[i*2+a+3] = L;
75 				}
76 			}
77 		}
78 		return Adds;
79 	}
80 	/*function getHistory(address r, uint s) public view returns (bool,uint8, uint8,uint256){
81 		if(bcontract.nodeLatestAction(r) <= s) return (false,0,0,0);
82 		(FiftyContract.nodeActionType aT, uint8 nP, uint256 tT) = bcontract.nodeActionHistory(r,s);
83 		uint8 actType;
84 		if(aT == FiftyContract.nodeActionType.joinMember) actType=0;
85 		if(aT == FiftyContract.nodeActionType.startTree) actType=1;
86 		if(aT == FiftyContract.nodeActionType.addNode) actType=2;
87 		if(aT == FiftyContract.nodeActionType.completeTree) actType=3;
88 		return (true,actType,nP,tT);
89 	}*/
90 	function getCurrentTree(address r, uint t) public view returns(address[7] memory){
91 		address[7] memory Adds;
92 		if(bcontract.nodeIDIndex(r,t) > (2 ** 32) -2 || !bcontract.currentNodes(r,t)) 
93 		    return Adds;
94 		uint cc=bcontract.nodeIDIndex(r,t) - 1;
95 		Adds[0]=r;
96 		uint8 spread = uint8(bcontract.spread());
97 		for (uint8 i=0; i < spread; i++) {
98 		    (address k,uint p,uint m) = bcontract.treeChildren(r,t,cc,i);
99 			if(p != 0){
100 				Adds[i+1]=k;
101 				for (uint8 a=0; a < spread; a++) {
102 				    (address L,uint q,) = bcontract.treeChildren(k,p,m,a);    
103 					if(q != 0) Adds[i*2+a+3] = L;
104 				}
105 			}
106 		}
107 		return Adds;
108 	}
109 	function getMemberShip(address r) public view returns(uint){
110 		return bcontract.membership(r);
111 	}
112 }