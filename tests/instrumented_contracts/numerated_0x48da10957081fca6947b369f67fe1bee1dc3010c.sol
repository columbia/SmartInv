1 pragma solidity ^0.4.20;
2 
3 
4 contract Ownable {
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     
8 	address public owner;
9 
10     constructor() public { owner = msg.sender; }
11 
12     modifier onlyOwner() { require(msg.sender == owner); _; }
13 
14     function transferOwnership(address newOwner) public onlyOwner {
15         require(newOwner != address(0));
16         emit OwnershipTransferred(owner, newOwner);
17         owner = newOwner;
18     }
19 }
20 
21 contract Pausable is Ownable {
22 
23     event Pause();
24 	
25     event Unpause();
26 
27     bool public paused = false;
28 
29     modifier whenNotPaused() { require(!paused); _; }
30 
31     modifier whenPaused() { require(paused); _; }
32 
33     function pause() onlyOwner whenNotPaused public {
34         paused = true;
35         emit Pause();
36     }
37 
38     function unpause() onlyOwner whenPaused public {
39         paused = false;
40         emit Unpause();
41     }
42 }
43 
44 contract EtherDrop is Pausable {
45 
46     /*
47      * subscription ticket price
48      */
49     uint priceWei;
50 
51     /*
52      * subscription queue size: power of 10
53      */
54 	uint qMax;
55     
56 	/*
57      * Queue Order - Log10 qMax
58      * e.g. random [0 to 999] is of order 3 => rand = 100*x + 10*y + z
59      */
60 	 uint dMax;
61 
62 	/*
63      * log a new subscription
64      */
65     event NewSubscriber(address indexed addr, uint indexed round, uint place);
66     
67 	/*
68      * log a new round - drop out
69      */
70 	event NewDropOut(address indexed addr, uint indexed round, uint place, uint price);
71 	
72 	/*
73      * round lock - future block hash lock
74      */
75 	uint _lock;
76 	
77 	/*
78      * last round block
79      */
80 	uint _block;
81     
82 	/*
83      * active round
84      */
85 	uint _round; 
86 	
87     /*
88      * team support
89      */
90     uint _collectibles;
91 	
92 	/*
93      * active subscription queue
94      */
95 	address[] _queue;
96 	
97     /*
98      * last user subscriptions
99      */
100 	mapping(address => uint) _userRound;
101 	
102 	/*
103 	 * starting by round one
104 	 * set round block
105 	 */
106 	constructor(uint order, uint price) public {
107 		
108 		/* 
109 		 * queue order and price limits 
110 		 */
111 		require(0 < order && order < 4 && price >= 1e16 && price <= 1e18);
112 		
113 		/*
114 		 * queue size
115 		 */
116 		dMax = order;
117 		qMax = 10**order;
118 
119         /*
120 	     * subscription price
121 	     */
122 	    priceWei = price;
123 		
124 		/*
125 		 * initial round & block start
126 		 */
127 	    _round = 1;
128 	    _block = block.number;
129 	}
130 	
131 	/*
132 	 * returns current drop stats: [ round, position, max, price, block, lock]
133 	 */
134     function stat() public view returns (uint round, uint position, uint max, 
135         uint price, uint blok, uint lock) {
136         return ( _round - (_queue.length == qMax ? 1 : 0), _queue.length, qMax, 
137             priceWei, _block, _lock);
138     }
139 	
140 	/*
141 	 * returns user's stats: [last_subscription_round, current_drop_round]
142 	 */
143 	function userRound(address user) public view returns (uint lastRound, uint currentRound) {
144 		return (_userRound[user], _round - (_queue.length == qMax ? 1 : 0));
145 	}
146 
147 	/*
148 	 * fallback subscription
149 	 */
150     function() public payable whenNotPaused {
151 
152 		/*
153 		 * contracts are not allowed to participate
154 		 */
155         require(tx.origin == msg.sender && msg.value >= priceWei);
156 	
157 		/*
158 		 * unlock new round condition
159 		 */
160 		if (_lock > 0 && block.number >= _lock) {	
161 			/*
162 			 * random winner ticket position
163 			 * block hash number derivation
164 			 */
165 			uint _r = dMax;
166             uint _winpos = 0;
167 			bytes32 _a = blockhash(_lock);
168 			for (uint i = 31; i >= 1; i--) {
169 				if (uint8(_a[i]) >= 48 && uint8(_a[i]) <= 57) {
170 					_winpos = 10 * _winpos + (uint8(_a[i]) - 48);
171 					if (--_r == 0) break;
172 				}
173 			}
174             
175 			/*
176 			 * rewards and collection
177 			 */
178 			uint _reward = (qMax * priceWei * 90) / 100;
179             _collectibles += address(this).balance - _reward;
180 			_queue[_winpos].transfer(_reward);
181             
182 			/*
183 			 * log ether drop event
184 			 */
185 			emit NewDropOut(_queue[_winpos], _round - 1, _winpos + 1, _reward);
186 			
187 			/*
188 			 * update the block number
189 			 */
190             _block = block.number;
191             
192             /*
193 			 * reset lock
194 			 */
195             _lock = 0;
196 			
197 			/*
198 			 * queue reset
199 			 */
200 			delete _queue;
201         }
202 		/*
203 		 * prevent round Txn(s) in one block overflow
204 		 */
205 		else if (block.number + 1 == _lock) {
206 			revert();
207 		}
208         
209 		/*
210 		 * only one address per round
211 		 */
212 		require(_userRound[msg.sender] != _round);
213 		
214 		/*
215 		 * set address subscription flag
216 		 */
217 		_userRound[msg.sender] = _round;
218 		
219 		/*
220 		 * save subscription
221 		 */
222         _queue.push(msg.sender);
223 
224 		/*
225 		 * log ticket subscription event
226 		 */
227         emit NewSubscriber(msg.sender, _round, _queue.length);
228         
229 		/*
230 		 * new round handler
231 		 */
232         if (_queue.length == qMax) {
233             _round++;
234             _lock = block.number + 1;
235         }
236     }
237 
238     /*
239 	 * team R&D support
240 	 */
241     function support() public onlyOwner {
242         owner.transfer(_collectibles);
243 		_collectibles = 0;
244     }
245 }