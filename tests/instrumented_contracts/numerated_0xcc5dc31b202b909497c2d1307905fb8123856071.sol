1 pragma solidity ^0.4.18;
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
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Base contract for Libre oracles.
46  *
47  * @dev Base contract for Libre oracles. Not abstract.
48  */
49 contract OwnOracle is Ownable {
50     event NewOraclizeQuery();
51     event PriceTicker(uint256 rateAmount);
52     event BankSet(address bank);
53     event UpdaterSet(address updater);
54 
55     bytes32 public oracleName = "LibreOracle Alpha";
56     bytes16 public oracleType = "Libre ETHUSD";
57     uint256 public updateTime;
58     uint256 public callbackTime;
59     address public bankAddress;
60     uint256 public rate;
61     uint256 public requestPrice = 0;
62     bool public waitQuery = false;
63     address public updaterAddress;
64 
65     modifier onlyBank() {
66         require(msg.sender == bankAddress);
67         _;
68     }
69 
70     /**
71      * @dev Sets bank address.
72      * @param bank Address of the bank contract.
73      */
74     function setBank(address bank) public onlyOwner {
75         bankAddress = bank;
76         BankSet(bankAddress);
77     }
78 
79     /**
80      * @dev Sets updateAddress address.
81      * @param updater Address of the updateAddress.
82      */
83     function setUpdaterAddress(address updater) public onlyOwner {
84         updaterAddress = updater;
85         UpdaterSet(updaterAddress);
86     }
87 
88     /**
89      * @dev Return price of LibreOracle request.
90      */
91     function getPrice() view public returns (uint256) {
92         return updaterAddress.balance < requestPrice ? requestPrice : 0;
93     }
94 
95     /**
96      * @dev oraclize setPrice.
97      * @param _requestPriceWei request price in Wei.
98      */
99     function setPrice(uint256 _requestPriceWei) public onlyOwner {
100         requestPrice = _requestPriceWei;
101     }
102 
103     /**
104      * @dev Requests updating rate from LibreOracle node.
105      */
106     function updateRate() external onlyBank returns (bool) {
107         NewOraclizeQuery();
108         updateTime = now;
109         waitQuery = true;
110         return true;
111     }
112 
113 
114     /**
115     * @dev LibreOracle callback.
116     * @param result The callback data as-is (1000$ = 1000).
117     */
118     function __callback(uint256 result) public {
119         require(msg.sender == updaterAddress && waitQuery);
120         rate = result;
121         callbackTime = now;
122         waitQuery = false;
123         PriceTicker(result);
124     }
125 
126     /**
127     * @dev Method used for funding LibreOracle updater wallet. 
128     */    
129     function () public payable {
130         updaterAddress.transfer(msg.value);
131     }
132 
133 }