1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 contract BlockvPublicLedger is Ownable {
44 
45   struct logEntry{
46         string txType;
47         string txId;
48         address to;
49         uint256 amountContributed;
50         uint8 discount;
51         uint256 blockTimestamp;
52   }
53   struct distributionEntry{
54         string txId;
55         address to;
56         uint256 amountContributed;    
57         uint8 discount;
58         uint256 tokenAmount;
59   }
60   struct index {
61     uint256 index;
62     bool set;
63   }
64   uint256 public txCount = 0;
65   uint256 public distributionEntryCount = 0;
66   mapping (string => index) distributionIndex;
67   logEntry[] public transactionLog;
68   distributionEntry[] public distributionList;
69   bool public distributionFixed = false;
70 
71 
72   /**
73    * @dev BlockvPublicLedger Constructor
74    * Runs only on initial contract creation.
75    */
76   function BlockvPublicLedger() {
77   }
78 
79   /**
80    * @dev update/create a record in the Distribution List
81    * @param _tx_id A unique id for the transaction, could be the BTC or ETH tx_id
82    * @param _to The address to transfer to.
83    * @param _amount The amount contributed in ETH grains.
84    * @param _discount The discount value in percent; 100 meaning no discount, 80 meaning 20% discount.
85    */
86   function appendToDistributionList(string _tx_id, address _to, uint256 _amount, uint8 _discount)  onlyOwner returns (bool) {
87         index memory idx = distributionIndex[_tx_id];
88         bool ret;
89         logEntry memory le;
90         distributionEntry memory de;
91 
92         if(distributionFixed) {  
93           revert();
94         }
95 
96         if ( _discount > 100 ) {
97           revert();
98         }
99         /* build the log record and add it to the transaction log first */
100         if ( !idx.set ) {
101             ret = false;
102             le.txType = "INSERT";
103         } else {
104             ret = true;
105             le.txType = "UPDATE";          
106         }
107         le.to = _to;
108         le.amountContributed = _amount;
109         le.blockTimestamp = block.timestamp;
110         le.txId = _tx_id;
111         le.discount = _discount;
112         transactionLog.push(le);
113         txCount++;
114 
115         /* now append or update the distributionList */
116         de.txId = _tx_id;
117         de.to = _to;
118         de.amountContributed = _amount;
119         de.discount = _discount;
120         de.tokenAmount = 0;
121         if (!idx.set) {
122           idx.index = distributionEntryCount;
123           idx.set = true;
124           distributionIndex[_tx_id] = idx;
125           distributionList.push(de);
126           distributionEntryCount++;
127         } else {
128           distributionList[idx.index] = de;
129         }
130         return ret;
131   }
132 
133 
134   /**
135   * @dev finalize the distributionList after token price is set and ETH conversion is known
136   * @param _tokenPrice the price of a VEE in USD-cents
137   * @param _usdToEthConversionRate in grains
138   */
139   function fixDistribution(uint8 _tokenPrice, uint256 _usdToEthConversionRate) onlyOwner {
140 
141     distributionEntry memory de;
142     logEntry memory le;
143     uint256 i = 0;
144 
145     if(distributionFixed) {  
146       revert();
147     }
148 
149     for(i = 0; i < distributionEntryCount; i++) {
150       de = distributionList[i];
151       de.tokenAmount = (de.amountContributed * _usdToEthConversionRate * 100) / (_tokenPrice  * de.discount / 100);
152       distributionList[i] = de;
153     }
154     distributionFixed = true;
155   
156     le.txType = "FIXED";
157     le.blockTimestamp = block.timestamp;
158     le.txId = "__FIXED__DISTRIBUTION__";
159     transactionLog.push(le);
160     txCount++;
161 
162   }
163 
164 }