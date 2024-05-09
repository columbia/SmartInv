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
37 	address public baseAddr = 0xfF7B74ccc06Af60f5D8D7ba2FBdCA3C0376CF7d2;
38 	FiftyContract bcontract = FiftyContract(baseAddr);
39 	
40 	function setContract(address newAddr) public onlyAdmin {
41 		baseAddr = newAddr;
42 		bcontract = FiftyContract(baseAddr);
43 	}
44 
45 	function getStatus(address r) public view returns(uint, uint,
46 	uint, uint, uint, uint, uint, uint, uint){
47 	    uint[9] memory result;
48 	    result[0] = bcontract.membership(r);
49 	    result[1] = bcontract.nodeReceivedETH(r);
50 	    if(bcontract.currentNodes(r,1 ether)) result[2] = 1;
51 	    if(bcontract.nodeIDIndex(r,1 ether) > (2 ** 32) -2) result[2] = 2;
52 	    if(bcontract.currentNodes(r,2 ether)) result[3] = 1;
53 	    if(bcontract.nodeIDIndex(r,2 ether) > (2 ** 32) -2) result[3] = 2;
54 	    if(bcontract.currentNodes(r,3 ether)) result[4] = 1;
55 	    if(bcontract.nodeIDIndex(r,3 ether) > (2 ** 32) -2) result[4] = 2;
56 	    if(bcontract.currentNodes(r,5 ether)) result[5] = 1;
57 	    if(bcontract.nodeIDIndex(r,5 ether) > (2 ** 32) -2) result[5] = 2;
58 	    if(bcontract.currentNodes(r,10 ether)) result[6] = 1;
59 	    if(bcontract.nodeIDIndex(r,10 ether) > (2 ** 32) -2) result[6] = 2;
60 	    if(bcontract.currentNodes(r,50 ether)) result[7] = 1;
61 	    if(bcontract.nodeIDIndex(r,50 ether) > (2 ** 32) -2) result[7] = 2;
62 	    if( (bcontract.nodeIDIndex(r,1 ether) > 1 
63 	        || (bcontract.nodeIDIndex(r,1 ether) == 1 && !bcontract.currentNodes(r,1 ether))
64 	        ) &&
65 	        (bcontract.nodeIDIndex(r,2 ether) > 1 
66 	        || (bcontract.nodeIDIndex(r,2 ether) == 1 && !bcontract.currentNodes(r,2 ether))
67 	        ) &&
68 	        (bcontract.nodeIDIndex(r,3 ether) > 1 
69 	        || (bcontract.nodeIDIndex(r,3 ether) == 1 && !bcontract.currentNodes(r,3 ether))
70 	        ) &&
71 	        (bcontract.nodeIDIndex(r,2 ether) > 1 
72 	        || (bcontract.nodeIDIndex(r,5 ether) == 1 && !bcontract.currentNodes(r,5 ether))
73 	        )
74 	        ) result[8] = 1;
75 	    return(result[0],result[1],result[2],result[3],result[4],result[5],
76 	    result[6],result[7],result[8]);
77 	}
78 	function getLastTree(address r, uint t) public view returns(address[7] memory, address[7] memory, uint){
79 	    address[7] memory latestTree;
80 	    address[7] memory lastCompletedTree;
81 	    if(bcontract.nodeIDIndex(r,t) >0 && bcontract.nodeIDIndex(r,t) <= (2 ** 32) -2 
82 	        && bcontract.currentNodes(r,t)){
83 	        uint cc=bcontract.nodeIDIndex(r,t) - 1;
84     		latestTree = getTree(r,t,cc);
85     		if(bcontract.nodeIDIndex(r,t) > 1){
86     		    lastCompletedTree = getTree(r,t,cc-1);
87     		}
88     		return (latestTree,lastCompletedTree,bcontract.nodeIDIndex(r,t)-1);
89 	    } 
90 		if(bcontract.nodeIDIndex(r,t) >0 && bcontract.nodeIDIndex(r,t) <= (2 ** 32) -2 
91 		    && !bcontract.currentNodes(r,t)){
92 		    uint cc=bcontract.nodeIDIndex(r,t) - 1;
93     		lastCompletedTree = getTree(r,t,cc);
94     		return (latestTree,lastCompletedTree,bcontract.nodeIDIndex(r,t)-1);
95 		}
96 		if(bcontract.nodeIDIndex(r,t) > (2 ** 32) -2){
97 		    uint cc=0;
98 		    for(;cc < (2 ** 32) -2;cc++){
99 		        latestTree = getTree(r,t,cc);
100 		        if(latestTree[0] == address(0)) break;
101 		        else lastCompletedTree = getTree(r,t,cc);
102 		    }
103 		    return (latestTree,lastCompletedTree,cc);
104 		}
105 		return (latestTree,lastCompletedTree,0);
106 	}
107 	
108 	function getTree(address r, uint t, uint cc) public view returns(address[7] memory){
109 		address[7] memory Adds;
110 		if(bcontract.nodeIDIndex(r,t) <= cc) return Adds;
111 		(,uint pp,) = bcontract.treeChildren(r,t,cc,0);
112 		if (pp!=0 || bcontract.nodeIDIndex(r,t) == (cc+1) ) Adds[0]=r;
113 		else return Adds;
114 		uint8 spread = uint8(bcontract.spread());
115 		for (uint8 i=0; i < spread; i++) {
116 		    (address k,uint p,uint m) = bcontract.treeChildren(r,t,cc,i);
117 			if(p != 0){
118 				Adds[i+1]=k;
119 				for (uint8 a=0; a < spread; a++) {
120 				    (address L,uint q,) = bcontract.treeChildren(k,p,m,a);    
121 					if(q != 0) Adds[i*2+a+3] = L;
122 				}
123 			}
124 		}
125 		return Adds;
126 	}
127 	function getMemberOrder(address addr, uint orderID) public view returns (uint){
128 		return bcontract.memberOrders(addr,orderID);
129 	}
130 	function getCurrentTree(address r, uint t) public view returns(address[7] memory){
131 		address[7] memory Adds;
132 		if(bcontract.nodeIDIndex(r,t) > (2 ** 32) -2 || !bcontract.currentNodes(r,t)) 
133 		    return Adds;
134 		uint cc=bcontract.nodeIDIndex(r,t) - 1;
135 		Adds[0]=r;
136 		uint8 spread = uint8(bcontract.spread());
137 		for (uint8 i=0; i < spread; i++) {
138 		    (address k,uint p,uint m) = bcontract.treeChildren(r,t,cc,i);
139 			if(p != 0){
140 				Adds[i+1]=k;
141 				for (uint8 a=0; a < spread; a++) {
142 				    (address L,uint q,) = bcontract.treeChildren(k,p,m,a);    
143 					if(q != 0) Adds[i*2+a+3] = L;
144 				}
145 			}
146 		}
147 		return Adds;
148 	}
149 	function getMemberShip(address r) public view returns(uint){
150 		return bcontract.membership(r);
151 	}
152 }