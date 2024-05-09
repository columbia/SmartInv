1 pragma solidity ^0.5.3;
2 
3 contract FiftyContract {
4 	mapping (address => mapping (uint => mapping (uint => mapping (uint => treeNode)))) public treeChildren;
5 	mapping (address => mapping (uint => mapping (uint => treeNode))) public treeParent;
6 	mapping (address => mapping (uint => bool)) public currentNodes;
7 	mapping (address => mapping (uint => uint)) public nodeIDIndex;
8 	mapping (address => uint) public membership;
9 	mapping(address => mapping(uint => uint)) public memberOrders;
10 	mapping (address => uint) public nodeReceivedETH;
11 	struct treeNode {
12 		 address payable ethAddress; 
13 		 uint nodeType; 
14 		 uint nodeID;
15 	}
16 	uint public spread;
17 }
18 contract Adminstrator {
19   address public admin;
20   address payable public owner;
21 
22   modifier onlyAdmin() { 
23         require(msg.sender == admin || msg.sender == owner,"Not authorized"); 
24         _;
25   } 
26 
27   constructor() public {
28     admin = msg.sender;
29 	owner = msg.sender;
30   }
31 
32   function transferAdmin(address newAdmin) public onlyAdmin {
33     admin = newAdmin; 
34   }
35 }
36 contract readFiftyContract is Adminstrator{
37 	
38 	address public baseAddr = 0x0C00a40c0eB7b208900AbeA6587bfb07EFb0C6b6;
39 	FiftyContract bcontract = FiftyContract(baseAddr);
40 	
41 	function setContract(address newAddr) public onlyAdmin {
42 		baseAddr = newAddr;
43 		bcontract = FiftyContract(baseAddr);
44 	}
45 
46 	function getStatus(address r) public view returns(uint, uint,
47 	uint, uint, uint, uint, uint, uint, uint){
48 	    uint[9] memory result;
49 	    result[0] = bcontract.membership(r);
50 	    result[1] = bcontract.nodeReceivedETH(r);
51 	    if(bcontract.currentNodes(r,1 ether)) result[2] = 1;
52 	    if(bcontract.nodeIDIndex(r,1 ether) > (2 ** 32) -2) result[2] = 2;
53 	    if(bcontract.currentNodes(r,2 ether)) result[3] = 1;
54 	    if(bcontract.nodeIDIndex(r,2 ether) > (2 ** 32) -2) result[3] = 2;
55 	    if(bcontract.currentNodes(r,3 ether)) result[4] = 1;
56 	    if(bcontract.nodeIDIndex(r,3 ether) > (2 ** 32) -2) result[4] = 2;
57 	    if(bcontract.currentNodes(r,5 ether)) result[5] = 1;
58 	    if(bcontract.nodeIDIndex(r,5 ether) > (2 ** 32) -2) result[5] = 2;
59 	    if(bcontract.currentNodes(r,10 ether)) result[6] = 1;
60 	    if(bcontract.nodeIDIndex(r,10 ether) > (2 ** 32) -2) result[6] = 2;
61 	    if(bcontract.currentNodes(r,50 ether)) result[7] = 1;
62 	    if(bcontract.nodeIDIndex(r,50 ether) > (2 ** 32) -2) result[7] = 2;
63 	    if( (bcontract.nodeIDIndex(r,1 ether) > 1 
64 	        || (bcontract.nodeIDIndex(r,1 ether) == 1 && !bcontract.currentNodes(r,1 ether))
65 	        ) &&
66 	        (bcontract.nodeIDIndex(r,2 ether) > 1 
67 	        || (bcontract.nodeIDIndex(r,2 ether) == 1 && !bcontract.currentNodes(r,2 ether))
68 	        ) &&
69 	        (bcontract.nodeIDIndex(r,3 ether) > 1 
70 	        || (bcontract.nodeIDIndex(r,3 ether) == 1 && !bcontract.currentNodes(r,3 ether))
71 	        ) &&
72 	        (bcontract.nodeIDIndex(r,2 ether) > 1 
73 	        || (bcontract.nodeIDIndex(r,5 ether) == 1 && !bcontract.currentNodes(r,5 ether))
74 	        )
75 	        ) result[8] = 1;
76 	    return(result[0],result[1],result[2],result[3],result[4],result[5],
77 	    result[6],result[7],result[8]);
78 	}
79 	function getLastTree(address r, uint t) public view returns(address[7] memory, address[7] memory){
80 	    address[7] memory latestTree;
81 	    address[7] memory lastCompletedTree;
82 	    if(bcontract.nodeIDIndex(r,t) >0 && bcontract.nodeIDIndex(r,t) <= (2 ** 32) -2 
83 	        && bcontract.currentNodes(r,t)){
84 	        uint cc=bcontract.nodeIDIndex(r,t) - 1;
85     		latestTree = getTree(r,t,cc);
86     		if(bcontract.nodeIDIndex(r,t) > 1){
87     		    lastCompletedTree = getTree(r,t,cc-1);
88     		}
89     		return (latestTree,lastCompletedTree);
90 	    } 
91 		if(bcontract.nodeIDIndex(r,t) >0 && bcontract.nodeIDIndex(r,t) <= (2 ** 32) -2 
92 		    && !bcontract.currentNodes(r,t)){
93 		    uint cc=bcontract.nodeIDIndex(r,t) - 1;
94     		lastCompletedTree = getTree(r,t,cc);
95     		return (latestTree,lastCompletedTree);
96 		}
97 		if(bcontract.nodeIDIndex(r,t) > (2 ** 32) -2){
98 		    for(uint cc=0;cc < (2 ** 32) -2;cc++){
99 		        latestTree = getTree(r,t,cc);
100 		        if(latestTree[0] == address(0)) break;
101 		        else lastCompletedTree = getTree(r,t,cc);
102 		    }
103 		}
104 		return (latestTree,lastCompletedTree);
105 	}
106 	
107 	function getTree(address r, uint t, uint cc) public view returns(address[7] memory){
108 		address[7] memory Adds;
109 		if(bcontract.nodeIDIndex(r,t) <= cc) return Adds;
110 		(,uint pp,) = bcontract.treeChildren(r,t,cc,0);
111 		//if (pp!=0 || bcontract.nodeIDIndex(r,t) == (cc+1) ) Adds[0]=r;
112 		if (pp!=0 || bcontract.nodeIDIndex(r,t) == (cc+1) ){
113 		  (address parent,,)=bcontract.treeParent(r,t,cc);
114 		  Adds[0] = parent;
115 		} 
116 		else return Adds;
117 		uint8 spread = uint8(bcontract.spread());
118 		for (uint8 i=0; i < spread; i++) {
119 		    (address k,uint p,uint m) = bcontract.treeChildren(r,t,cc,i);
120 			if(p != 0){
121 				Adds[i+1]=k;
122 				for (uint8 a=0; a < spread; a++) {
123 				    (address L,uint q,) = bcontract.treeChildren(k,p,m,a);    
124 					if(q != 0) Adds[i*2+a+3] = L;
125 				}
126 			}
127 		}
128 		return Adds;
129 	}
130 }