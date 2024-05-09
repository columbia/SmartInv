1 pragma solidity ^0.4.25;
2 
3 
4 contract Prosperity {
5 	/**
6      * Withdraws all of the callers earnings.
7      */
8 	function withdraw() public;
9 	
10 	/**
11      * Retrieve the dividends owned by the caller.
12      * If `_includeReferralBonus` is 1/true, the referral bonus will be included in the calculations.
13      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
14      * But in the internal calculations, we want them separate. 
15      */ 
16     function myDividends(bool _includeReferralBonus) public view returns(uint256);
17 }
18 
19 
20 contract Fund {
21     using SafeMath for *;
22     
23     /*=================================
24     =            MODIFIERS            =
25     =================================*/
26     // administrators can:
27     // -> change add or remove devs
28     // they CANNOT:
29     // -> change contract addresses
30     // -> change fees
31     // -> disable withdrawals
32     // -> kill the contract
33     modifier onlyAdministrator(){
34         address _customerAddress = msg.sender;
35         require(administrator_ == _customerAddress);
36         _;
37     }
38     
39     
40     /*================================
41     =            DATASETS            =
42     ================================*/
43     address internal administrator_;
44     address internal lending_;
45     address internal freeFund_;
46     address[] public devs_;
47 	
48 	// token exchange contract
49 	Prosperity public tokenContract_;
50     
51     // distribution percentages
52     uint8 internal lendingShare_ = 50;
53     uint8 internal freeFundShare_ = 20;
54     uint8 internal devsShare_ = 30;
55     
56     
57     /*=======================================
58     =            PUBLIC FUNCTIONS           =
59     =======================================*/
60     constructor()
61         public 
62     {
63         // set addresses
64         administrator_ = 0x28436C7453EbA01c6EcbC8a9cAa975f0ADE6Fff1;
65         lending_ = 0x961FA070Ef41C2b68D1A50905Ea9198EF7Dbfbf8;
66         freeFund_ = 0x0cCA1e8Db144d2E4a8F2A80828E780a1DC9C5112;
67         
68         // Add devs
69         devs_.push(0x28436C7453EbA01c6EcbC8a9cAa975f0ADE6Fff1); // Tobi
70         devs_.push(0x92be79705F4Fab97894833448Def30377bc7267A); // Fabi
71         devs_.push(0x000929719742ec6E0bFD0107959384F7Acd8F883); // Lukas
72         devs_.push(0x5289f0f0E8417c7475Ba33E92b1944279e183B0C); // Julian
73     }
74 	
75 	function() payable external {
76 		// prevent invalid or unintentional calls
77 		//require(msg.data.length == 0);
78 	}
79     
80     /**
81      * Distribute ether to lending, freeFund and devs
82      */
83     function pushEther()
84         public
85     {
86 		// get dividends (mainly referral)
87 		if (myDividends(true) > 0) {
88 			tokenContract_.withdraw();
89 		}
90 		
91 		// current balance (after withdraw)
92         uint256 _balance = getTotalBalance();
93         
94 		// distributed reinvestments
95         if (_balance > 0) {
96             uint256 _ethDevs      = _balance.mul(devsShare_).div(100);          // total of 30%
97             uint256 _ethFreeFund  = _balance.mul(freeFundShare_).div(100);      // total of 20%
98             uint256 _ethLending   = _balance.sub(_ethDevs).sub(_ethFreeFund);   // approx. 50%
99             
100             lending_.transfer(_ethLending);
101             freeFund_.transfer(_ethFreeFund);
102             
103             uint256 _devsCount = devs_.length;
104             for (uint8 i = 0; i < _devsCount; i++) {
105                 uint256 _ethDevPortion = _ethDevs.div(_devsCount);
106                 address _dev = devs_[i];
107                 _dev.transfer(_ethDevPortion);
108             }
109         }
110     }
111     
112     /**
113      * Add a dev to the devs fund pool.
114      */
115     function addDev(address _dev)
116         onlyAdministrator()
117         public
118     {
119         // address must not be dev before, we do not want duplicates
120         require(!isDev(_dev), "address is already dev");
121         
122         devs_.push(_dev);
123     }
124     
125     /**
126      * Remove a dev from the devs fund pool.
127      */
128     function removeDev(address _dev)
129         onlyAdministrator()
130         public
131     {
132         // address must be dev before, we need a dev address to be able to remove him
133         require(isDev(_dev), "address is not a dev");
134         
135         // get index and delte dev
136         uint8 index = getDevIndex(_dev);
137         
138         // close gap in dev list
139         uint256 _devCount = getTotalDevs();
140         for (uint8 i = index; i < _devCount - 1; i++) {
141             devs_[i] = devs_[i+1];
142         }
143         delete devs_[devs_.length-1];
144         devs_.length--;
145     }
146     
147     
148     /**
149      * Check if given address is dev or not
150      */
151     function isDev(address _dealer) 
152         public
153         view
154         returns(bool)
155     {
156         uint256 _devsCount = devs_.length;
157         
158         for (uint8 i = 0; i < _devsCount; i++) {
159             if (devs_[i] == _dealer) {
160                 return true;
161             }
162         }
163         
164         return false;
165     }
166     
167     
168     // VIEW FUNCTIONS
169     function getTotalBalance() 
170         public
171         view
172         returns(uint256)
173     {
174         return address(this).balance;
175     }
176     
177     function getTotalDevs()
178         public 
179         view 
180         returns(uint256)
181     {
182         return devs_.length;
183     }
184 	
185 	function myDividends(bool _includeReferralBonus)
186 		public
187 		view
188 		returns(uint256)
189 	{
190 		return tokenContract_.myDividends(_includeReferralBonus);
191 	}
192     
193     
194     // INTERNAL FUNCTIONS
195     /**
196      * Check index of given address
197      */
198     function getDevIndex(address _dev)
199         internal
200         view
201         returns(uint8)
202     {
203         uint256 _devsCount = devs_.length;
204         
205         for (uint8 i = 0; i < _devsCount; i++) {
206             if (devs_[i] == _dev) {
207                 return i;
208             }
209         }
210     }
211 	
212 	// SETTER
213 	/**
214 	 * Set the token contract
215 	 */
216 	function setTokenContract(address _tokenContract)
217 		onlyAdministrator()
218 		public
219 	{
220 		tokenContract_ = Prosperity(_tokenContract);
221 	}
222 }
223 
224 
225 /**
226  * @title SafeMath
227  * @dev Math operations with safety checks that revert on error
228  */
229 library SafeMath {
230 
231   /**
232   * @dev Multiplies two numbers, reverts on overflow.
233   */
234   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
236     // benefit is lost if 'b' is also tested.
237     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
238     if (a == 0) {
239       return 0;
240     }
241 
242     uint256 c = a * b;
243     require(c / a == b);
244 
245     return c;
246   }
247 
248   /**
249   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
250   */
251   function div(uint256 a, uint256 b) internal pure returns (uint256) {
252     require(b > 0); // Solidity only automatically asserts when dividing by 0
253     uint256 c = a / b;
254     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255 
256     return c;
257   }
258 
259   /**
260   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
261   */
262   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263     require(b <= a);
264     uint256 c = a - b;
265 
266     return c;
267   }
268 
269   /**
270   * @dev Adds two numbers, reverts on overflow.
271   */
272   function add(uint256 a, uint256 b) internal pure returns (uint256) {
273     uint256 c = a + b;
274     require(c >= a);
275 
276     return c;
277   }
278 
279   /**
280   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
281   * reverts when dividing by zero.
282   */
283   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
284     require(b != 0);
285     return a % b;
286   }
287 }