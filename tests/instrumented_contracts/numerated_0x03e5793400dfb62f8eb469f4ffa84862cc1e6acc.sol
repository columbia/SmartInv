1 pragma solidity ^0.4.24;
2 
3 contract TeamDreamHub {
4     using SafeMath for uint256;
5     
6 //==============================================================================
7 //     _| _ _|_ _    _ _ _|_    _   .
8 //    (_|(_| | (_|  _\(/_ | |_||_)  .
9 //=============================|================================================    
10 	address private owner;
11 	uint256 maxShareHolder = 100;
12     mapping(uint256 => ShareHolder) public shareHolderTable;	
13 
14 	struct ShareHolder {
15         address targetAddr;  // target address
16         uint256 ratio; 		 // profit ‰
17     }	
18 //==============================================================================
19 //     _ _  _  __|_ _    __|_ _  _  .
20 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
21 //==============================================================================    
22     constructor()
23         public
24     {
25 		owner = msg.sender;
26     }
27 //==============================================================================
28 //     _ _  _  _|. |`. _  _ _  .
29 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
30 //==============================================================================    
31     /**
32      * @dev prevents contracts from interacting with fomo3d 
33      */
34     modifier isHuman() {
35         address _addr = msg.sender;
36 		require (_addr == tx.origin);
37 		
38         uint256 _codeLength;
39         
40         assembly {_codeLength := extcodesize(_addr)}
41         require(_codeLength == 0, "sorry humans only");
42         _;
43     }    
44 	
45 	modifier onlyOwner() {
46 		require (msg.sender == owner);
47 		_;
48 	}
49 
50 	
51 //==============================================================================
52 //     _    |_ |. _   |`    _  __|_. _  _  _  .
53 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
54 //====|=========================================================================
55 
56     /**
57      * @dev fallback function
58      */
59     function()      
60 		isHuman()
61         public
62         payable
63     {
64 		// if use this through SC, will fail because gas not enough.
65 		distribute(msg.value);
66     }
67 	
68     function deposit()
69         external
70         payable
71     {
72 		distribute(msg.value);
73     }
74 	
75 	function distribute(uint256 _totalInput)
76         private
77     {		
78 		uint256 _toBeDistribute = _totalInput;
79 		
80 		uint256 fund;
81 		address targetAddress;
82 		for (uint i = 0 ; i < maxShareHolder; i++) {			
83 			targetAddress = shareHolderTable[i].targetAddr;
84 			if(targetAddress != address(0))
85 			{
86 				fund = _totalInput.mul(shareHolderTable[i].ratio) / 100;			
87 				targetAddress.transfer(fund);
88 				_toBeDistribute = _toBeDistribute.sub(fund);
89 			}
90 			else
91 				break;
92 		}		
93         
94 		//remainder to contract owner
95 		owner.transfer(_toBeDistribute);	
96     }
97 	
98 	
99 	//setup the target addresses abd ratio (sum = 100%)
100     function updateEntry(uint256 tableIdx, address _targetAddress, uint256 _ratio)
101         onlyOwner()
102         public
103     {
104 		require (tableIdx < maxShareHolder);
105 		require (_targetAddress != address(0));
106 		require (_ratio <= 100);
107 		
108 		uint256 totalShare = 0;		
109 		for (uint i = 0 ; i < maxShareHolder; i++) {
110 			if(i != tableIdx)
111 				totalShare += shareHolderTable[i].ratio;
112 			else
113 				totalShare += _ratio;
114 			
115 			if(totalShare > 100) // if larger than 100%, should REJECT
116 				revert('totalShare is larger than 100.');
117 		}
118 		
119 		shareHolderTable[tableIdx] = ShareHolder(_targetAddress,_ratio);        
120     }	
121 	
122 	//function removeEntry(uint256 tableIdx)
123     //    onlyOwner()
124     //    public
125     //{
126 	//	require (tableIdx < maxShareHolder);
127 	//			
128     //    shareHolderTable[tableIdx] = ShareHolder(address(0),0);
129     //}		
130 }
131 
132 //==============================================================================
133 // ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ 
134 // ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  
135 // ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ 
136 //==============================================================================
137 /**
138  * @title SafeMath v0.1.9
139  * @dev Math operations with safety checks that throw on error
140  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
141  * - added sqrt
142  * - added sq
143  * - added pwr 
144  * - changed asserts to requires with error log outputs
145  * - removed div, its useless
146  */
147 library SafeMath {
148     
149     /**
150     * @dev Multiplies two numbers, throws on overflow.
151     */
152     function mul(uint256 a, uint256 b) 
153         internal 
154         pure 
155         returns (uint256 c) 
156     {
157         if (a == 0) {
158             return 0;
159         }
160         c = a * b;
161         require(c / a == b, "SafeMath mul failed");
162         return c;
163     }
164 
165     /**
166     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
167     */
168     function sub(uint256 a, uint256 b)
169         internal
170         pure
171         returns (uint256) 
172     {
173         require(b <= a, "SafeMath sub failed");
174         return a - b;
175     }
176 
177     /**
178     * @dev Adds two numbers, throws on overflow.
179     */
180     function add(uint256 a, uint256 b)
181         internal
182         pure
183         returns (uint256 c) 
184     {
185         c = a + b;
186         require(c >= a, "SafeMath add failed");
187         return c;
188     }
189     
190     /**
191      * @dev gives square root of given x.
192      */
193     function sqrt(uint256 x)
194         internal
195         pure
196         returns (uint256 y) 
197     {
198         uint256 z = ((add(x,1)) / 2);
199         y = x;
200         while (z < y) 
201         {
202             y = z;
203             z = ((add((x / z),z)) / 2);
204         }
205     }
206     
207     /**
208      * @dev gives square. multiplies x by x
209      */
210     function sq(uint256 x)
211         internal
212         pure
213         returns (uint256)
214     {
215         return (mul(x,x));
216     }
217     
218     /**
219      * @dev x to the power of y 
220      */
221     function pwr(uint256 x, uint256 y)
222         internal 
223         pure 
224         returns (uint256)
225     {
226         if (x==0)
227             return (0);
228         else if (y==0)
229             return (1);
230         else 
231         {
232             uint256 z = x;
233             for (uint256 i=1; i < y; i++)
234                 z = mul(z,x);
235             return (z);
236         }
237     }
238 }