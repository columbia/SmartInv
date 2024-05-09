1 pragma solidity ^0.5.3;
2 
3 contract FiftyContract {
4 	mapping (address => mapping (uint => mapping (uint => mapping (uint => treeNode)))) public treeChildren;
5 	mapping (address => mapping (uint => bool)) public currentNodes;
6 	mapping (address => mapping (uint => uint)) public nodeIDIndex;
7 	mapping (address => uint) public membership;
8 	mapping(address => mapping(uint => uint)) public memberOrders;
9 	mapping (address => uint) public nodeReceivedETH;
10 	struct treeNode {
11 		 address payable ethAddress; 
12 		 uint nodeType; 
13 		 uint nodeID;
14 	}
15 	uint public spread;
16 }
17 contract Adminstrator {
18   address public admin;
19   address payable public owner;
20 
21   modifier onlyAdmin() { 
22         require(msg.sender == admin || msg.sender == owner,"Not authorized"); 
23         _;
24   } 
25 
26   constructor() public {
27     admin = msg.sender;
28 	owner = msg.sender;
29   }
30 
31   function transferAdmin(address newAdmin) public onlyAdmin {
32     admin = newAdmin; 
33   }
34 }
35 contract readFiftyContract is Adminstrator{
36 	
37 	address public baseAddr = 0x7B15bd1B13ACa9127e5e3bfaF238aB51839f8Ea2;
38 	FiftyContract bcontract = FiftyContract(baseAddr);
39 	
40 	function setContract(address newAddr) public onlyAdmin {
41 		baseAddr = newAddr;
42 		bcontract = FiftyContract(baseAddr);
43 	}
44 	function getReceivedETH(address r) public view returns (uint, uint, uint, uint, uint){
45 		return ( bcontract.nodeReceivedETH(r) , bcontract.nodeIDIndex(r, 1 ether) 
46 		, bcontract.nodeIDIndex(r, 2 ether) , bcontract.nodeIDIndex(r, 3 ether) 
47 		, bcontract.nodeIDIndex(r, 5 ether) );
48 	}
49 	function getTree(address r, uint t, uint cc) public view returns(address[7] memory){
50 		address[7] memory Adds;
51 		if(bcontract.nodeIDIndex(r,t) <= cc) return Adds;
52 		(,uint pp,) = bcontract.treeChildren(r,t,cc,0);
53 		if (pp!=0 || bcontract.nodeIDIndex(r,t) == (cc+1) ) Adds[0]=r;
54 		else return Adds;
55 		uint8 spread = uint8(bcontract.spread());
56 		for (uint8 i=0; i < spread; i++) {
57 		    (address k,uint p,uint m) = bcontract.treeChildren(r,t,cc,i);
58 			if(p != 0){
59 				Adds[i+1]=k;
60 				for (uint8 a=0; a < spread; a++) {
61 				    (address L,uint q,) = bcontract.treeChildren(k,p,m,a);    
62 					if(q != 0) Adds[i*2+a+3] = L;
63 				}
64 			}
65 		}
66 		return Adds;
67 	}
68 	/*function getHistory(address r, uint s) public view returns (bool,uint8, uint8,uint256){
69 		if(bcontract.nodeLatestAction(r) <= s) return (false,0,0,0);
70 		(FiftyContract.nodeActionType aT, uint8 nP, uint256 tT) = bcontract.nodeActionHistory(r,s);
71 		uint8 actType;
72 		if(aT == FiftyContract.nodeActionType.joinMember) actType=0;
73 		if(aT == FiftyContract.nodeActionType.startTree) actType=1;
74 		if(aT == FiftyContract.nodeActionType.addNode) actType=2;
75 		if(aT == FiftyContract.nodeActionType.completeTree) actType=3;
76 		return (true,actType,nP,tT);
77 	}*/
78 	function getCurrentTree(address r, uint t) public view returns(address[7] memory){
79 		address[7] memory Adds;
80 		if(bcontract.nodeIDIndex(r,t) > (2 ** 32) -2 || !bcontract.currentNodes(r,t)) 
81 		    return Adds;
82 		uint cc=bcontract.nodeIDIndex(r,t) - 1;
83 		Adds[0]=r;
84 		uint8 spread = uint8(bcontract.spread());
85 		for (uint8 i=0; i < spread; i++) {
86 		    (address k,uint p,uint m) = bcontract.treeChildren(r,t,cc,i);
87 			if(p != 0){
88 				Adds[i+1]=k;
89 				for (uint8 a=0; a < spread; a++) {
90 				    (address L,uint q,) = bcontract.treeChildren(k,p,m,a);    
91 					if(q != 0) Adds[i*2+a+3] = L;
92 				}
93 			}
94 		}
95 		return Adds;
96 	}
97 	function getMemberShip(address r) public view returns(uint){
98 		return bcontract.membership(r);
99 	}
100 }