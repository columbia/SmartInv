1 pragma solidity ^0.4.24;
2 
3 contract pyramidMKII {
4     address owner;
5 	
6 	struct blockinfo {
7         uint256 outstanding;                                                    // remaining debt at block
8         uint256 dividend;                                                      	// % dividend all previous can claim, 1 ether 
9 		uint256 value;															// actual ether value at block
10 		uint256 index;                                                          // used in frontend bc async checks
11 	}
12 	struct debtinfo {
13 		uint256 idx;															// dividend array position
14 		uint256 pending;														// pending balance at block
15 		uint256 initial;														// initial ammount for stats
16 	}
17     struct account {
18         uint256 ebalance;                                                       // ether balance
19 		mapping(uint256=>debtinfo) owed;										// keeps track of outstanding debt 
20     }
21 	
22 	uint256 public blksze;														// block size
23 	uint256 public surplus;
24 	uint256 public IDX;														    // current dividend block
25 	mapping(uint256=>blockinfo) public blockData;								// dividend block data
26 	mapping(address=>account) public balances;
27 	
28 	bytes32 public consul_nme;
29 	uint256 public consul_price;
30 	address public consul;
31 	address patrician;
32 	
33     string public standard = 'PYRAMIDMKII';
34     string public name = 'PYRAMIDMKII';
35     string public symbol = 'PM2';
36     uint8 public decimals = 0 ;
37 	
38 	constructor() public {                                                     
39         owner = msg.sender;  
40         blksze = 1 ether; 
41         consul= owner;                                                          // owner is 1st consul    
42         patrician = owner;                                                      // owner is 1st patrician
43 	}
44 	
45 	function addSurplus() public payable { surplus += msg.value; }              // used to pay off the debt in final round
46 	
47 	function callSurplus() public {                                             // if there's enough surplus 
48 	    require(surplus >= blksze, "not enough surplus");                       // users can call this to make a new block 
49 	    blockData[IDX].value += blksze;                                         // without increasing outstanding
50 	    surplus -= blksze;
51 	    nextBlock();
52 	}
53 	    
54 	function owedAt(uint256 blk) public view returns(uint256, uint256, uint256)
55 		{ return (	balances[msg.sender].owed[blk].idx, 
56 					balances[msg.sender].owed[blk].pending, 
57 					balances[msg.sender].owed[blk].initial); }
58 	
59 	function setBlockSze(uint256 _sze) public {
60 		require(msg.sender == owner && _sze >= 1 ether, "error blksze");
61 		blksze = _sze;
62 	}
63 	
64 	function withdraw() public {
65 		require(balances[msg.sender].ebalance > 0, "not enough divs claimed");
66         uint256 sval = balances[msg.sender].ebalance;
67         balances[msg.sender].ebalance = 0;
68         msg.sender.transfer(sval);
69         emit event_withdraw(msg.sender, sval);
70 	}
71 	
72 	function chkConsul(address addr, uint256 val, bytes32 usrmsg) internal returns(uint256) {
73 	    if(val <= consul_price) return val;
74 	    balances[owner].ebalance += val/4;                                      // 25% for fund
75 	    balances[consul].ebalance += val/4;                                     // 25% for current consul
76 	    consul = addr;
77 	    consul_price = val;
78 	    consul_nme = usrmsg;
79 	    balances[addr].owed[IDX].pending += (val/2) + (val/4);                  // compensates for val/2
80 	    balances[addr].owed[IDX].initial += (val/2) + (val/4);
81 	    blockData[IDX].outstanding += (val/2) + (val/4);
82 	    emit event_consul(val, usrmsg);
83 	    return val/2;
84 	}
85 	
86 	function nextBlock() internal {
87 	    if(blockData[IDX].value>= blksze) { 
88 			surplus += blockData[IDX].value - blksze;
89 			blockData[IDX].value = blksze;
90 			if(IDX > 0) 
91 			    blockData[IDX].outstanding -= 
92 			        (blockData[IDX-1].outstanding * blockData[IDX-1].dividend)/100 ether;
93 			blockData[IDX].dividend = 
94 				(blksze * 100 ether) / blockData[IDX].outstanding;				// blocksize as % of total outstanding
95 			IDX += 1;															// filled block, next
96 			blockData[IDX].index = IDX;                                         // to avoid rechecking on frontend
97 			blockData[IDX].outstanding = blockData[IDX-1].outstanding;			// debt rolls over
98 			if(IDX % 200 == 0 && IDX != 0) blksze += 1 ether;                   // to keep a proper div distribution
99 			emit event_divblk(IDX);
100 		}
101 	}
102 	
103 	function pyramid(address addr, uint256 val, bytes32 usrmsg) internal {
104 	    val = chkConsul(addr, val, usrmsg);
105 		uint256 mval = val - (val/10);                                          // 10% in patrician, consul && fund money
106 		uint256 tval = val + (val/2);
107 		balances[owner].ebalance += (val/100);                                  // 1% for hedge fund
108 		balances[consul].ebalance += (val*7)/100 ;                              // 7% for consul
109 		balances[patrician].ebalance+= (val/50);                                // 2% for patrician
110 		patrician = addr;                                                       // now you're the patrician
111 		uint256 nsurp = (mval < blksze)? blksze-mval : (surplus < blksze)? surplus : 0;
112 		nsurp = (surplus >= nsurp)? nsurp : 0;
113 		mval += nsurp;                                                          // complete a block using surplus
114 		surplus-= nsurp;                                                        
115 		blockData[IDX].value += mval;
116         blockData[IDX].outstanding += tval;                                     // block outstanding debt increases until block fills
117 		balances[addr].owed[IDX].idx = IDX;							            // user can claim when block is full
118 		balances[addr].owed[IDX].pending += tval;                               // 1.5x for user
119 		balances[addr].owed[IDX].initial += tval;
120 		nextBlock();
121 		emit event_deposit(val, usrmsg);
122 	}
123 	
124 	function deposit(bytes32 usrmsg) public payable {
125 		require(msg.value >= 0.001 ether, "not enough ether");
126 		pyramid(msg.sender, msg.value, usrmsg);
127 	}
128 	
129 	function reinvest(uint256 val, bytes32 usrmsg) public {
130 		require(val <= balances[msg.sender].ebalance && 
131 				val > 0.001 ether, "no funds");
132 		balances[msg.sender].ebalance -= val;
133 		pyramid(msg.sender, val, usrmsg);
134 	}	
135 	
136 	function mine1000(uint256 blk) public {
137 		require(balances[msg.sender].owed[blk].idx < IDX && blk < IDX, "current block");
138 		require(balances[msg.sender].owed[blk].pending > 0.001 ether, "no more divs");
139 		uint256 cdiv = 0;
140 		for(uint256 i = 0; i < 1000; i++) {
141 			cdiv = (balances[msg.sender].owed[blk].pending *
142                     blockData[balances[msg.sender].owed[blk].idx].dividend ) / 100 ether; // get %
143 			cdiv = (cdiv > balances[msg.sender].owed[blk].pending)?     
144 						balances[msg.sender].owed[blk].pending : cdiv;          // check for overflow
145 			balances[msg.sender].owed[blk].idx += 1;                            // update the index
146 			balances[msg.sender].owed[blk].pending -= cdiv;
147 			balances[msg.sender].ebalance += cdiv;
148 			if( balances[msg.sender].owed[blk].pending == 0 || 
149 			    balances[msg.sender].owed[blk].idx >= IDX ) 
150 				return;
151 		}
152 	}
153 
154     // events ------------------------------------------------------------------
155     event event_withdraw(address addr, uint256 val);
156     event event_deposit(uint256 val, bytes32 umsg);
157     event event_consul(uint256 val, bytes32 umsg);
158     event event_divblk(uint256 idx);
159 }