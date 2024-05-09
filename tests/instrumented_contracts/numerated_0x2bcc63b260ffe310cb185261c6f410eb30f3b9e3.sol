1 pragma solidity 0.4.25;
2 
3 // File: contracts/saga/interfaces/IModelDataSource.sol
4 
5 /**
6  * @title Model Data Source Interface.
7  */
8 interface IModelDataSource {
9     /**
10      * @dev Get interval parameters.
11      * @param _rowNum Interval row index.
12      * @param _colNum Interval column index.
13      * @return Interval minimum amount of SGA.
14      * @return Interval maximum amount of SGA.
15      * @return Interval minimum amount of SDR.
16      * @return Interval maximum amount of SDR.
17      * @return Interval alpha value (scaled up).
18      * @return Interval beta  value (scaled up).
19      */
20     function getInterval(uint256 _rowNum, uint256 _colNum) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);
21 
22     /**
23      * @dev Get interval alpha and beta.
24      * @param _rowNum Interval row index.
25      * @param _colNum Interval column index.
26      * @return Interval alpha value (scaled up).
27      * @return Interval beta  value (scaled up).
28      */
29     function getIntervalCoefs(uint256 _rowNum, uint256 _colNum) external view returns (uint256, uint256);
30 
31     /**
32      * @dev Get the amount of SGA required for moving to the next minting-point.
33      * @param _rowNum Interval row index.
34      * @return Required amount of SGA.
35      */
36     function getRequiredMintAmount(uint256 _rowNum) external view returns (uint256);
37 }
38 
39 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Ownable.sol
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipRenounced(address indexed previousOwner);
51   event OwnershipTransferred(
52     address indexed previousOwner,
53     address indexed newOwner
54   );
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   constructor() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to relinquish control of the contract.
75    * @notice Renouncing to ownership will leave the contract without an owner.
76    * It will not be possible to call the functions with the `onlyOwner`
77    * modifier anymore.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Claimable.sol
104 
105 /**
106  * @title Claimable
107  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
108  * This allows the new owner to accept the transfer.
109  */
110 contract Claimable is Ownable {
111   address public pendingOwner;
112 
113   /**
114    * @dev Modifier throws if called by any account other than the pendingOwner.
115    */
116   modifier onlyPendingOwner() {
117     require(msg.sender == pendingOwner);
118     _;
119   }
120 
121   /**
122    * @dev Allows the current owner to set the pendingOwner address.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address newOwner) public onlyOwner {
126     pendingOwner = newOwner;
127   }
128 
129   /**
130    * @dev Allows the pendingOwner address to finalize the transfer.
131    */
132   function claimOwnership() public onlyPendingOwner {
133     emit OwnershipTransferred(owner, pendingOwner);
134     owner = pendingOwner;
135     pendingOwner = address(0);
136   }
137 }
138 
139 // File: contracts/saga/ModelDataSource.sol
140 
141 /**
142  * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
143  */
144 
145 /**
146  * @title Model Data Source.
147  */
148 contract ModelDataSource is IModelDataSource, Claimable {
149     string public constant VERSION = "1.0.0";
150 
151     struct Interval {
152         uint256 minN;
153         uint256 maxN;
154         uint256 minR;
155         uint256 maxR;
156         uint256 alpha;
157         uint256 beta;
158     }
159 
160     bool public intervalListsLocked;
161     Interval[11][105] public intervalLists;
162 
163     /**
164      * @dev Lock the interval lists.
165      */
166     function lock() external onlyOwner {
167         intervalListsLocked = true;
168     }
169 
170     /**
171      * @dev Set interval parameters.
172      * @param _rowNum Interval row index.
173      * @param _colNum Interval column index.
174      * @param _minN   Interval minimum amount of SGA.
175      * @param _maxN   Interval maximum amount of SGA.
176      * @param _minR   Interval minimum amount of SDR.
177      * @param _maxR   Interval maximum amount of SDR.
178      * @param _alpha  Interval alpha value (scaled up).
179      * @param _beta   Interval beta  value (scaled up).
180      */
181     function setInterval(uint256 _rowNum, uint256 _colNum, uint256 _minN, uint256 _maxN, uint256 _minR, uint256 _maxR, uint256 _alpha, uint256 _beta) external onlyOwner {
182         require(!intervalListsLocked, "interval lists are already locked");
183         intervalLists[_rowNum][_colNum] = Interval({minN: _minN, maxN: _maxN, minR: _minR, maxR: _maxR, alpha: _alpha, beta: _beta});
184     }
185 
186     /**
187      * @dev Get interval parameters.
188      * @param _rowNum Interval row index.
189      * @param _colNum Interval column index.
190      * @return Interval minimum amount of SGA.
191      * @return Interval maximum amount of SGA.
192      * @return Interval minimum amount of SDR.
193      * @return Interval maximum amount of SDR.
194      * @return Interval alpha value (scaled up).
195      * @return Interval beta  value (scaled up).
196      */
197     function getInterval(uint256 _rowNum, uint256 _colNum) external view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
198         Interval storage interval = intervalLists[_rowNum][_colNum];
199         return (interval.minN, interval.maxN, interval.minR, interval.maxR, interval.alpha, interval.beta);
200     }
201 
202     /**
203      * @dev Get interval alpha and beta.
204      * @param _rowNum Interval row index.
205      * @param _colNum Interval column index.
206      * @return Interval alpha value (scaled up).
207      * @return Interval beta  value (scaled up).
208      */
209     function getIntervalCoefs(uint256 _rowNum, uint256 _colNum) external view returns (uint256, uint256) {
210         Interval storage interval = intervalLists[_rowNum][_colNum];
211         return (interval.alpha, interval.beta);
212     }
213 
214     /**
215      * @dev Get the amount of SGA required for moving to the next minting-point.
216      * @param _rowNum Interval row index.
217      * @return Required amount of SGA.
218      */
219     function getRequiredMintAmount(uint256 _rowNum) external view returns (uint256) {
220         uint256 currMaxN = intervalLists[_rowNum + 0][0].maxN;
221         uint256 nextMinN = intervalLists[_rowNum + 1][0].minN;
222         assert(nextMinN >= currMaxN);
223         return nextMinN - currMaxN;
224     }
225 }
