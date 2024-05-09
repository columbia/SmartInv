1 contract MarriageRegistry {
2     address [] public registeredMarriages;
3     event ContractCreated(address contractAddress);
4 
5     function createMarriage(string _leftName, string _leftVows, string _rightName, string _rightVows, uint _date) public {
6         address newMarriage = new Marriage(msg.sender, _leftName, _leftVows, _rightName, _rightVows, _date);
7         emit ContractCreated(newMarriage);
8         registeredMarriages.push(newMarriage);
9     }
10 
11     function getDeployedMarriages() public view returns (address[]) {
12         return registeredMarriages;
13     }
14 }
15 
16 /**
17  * @title Marriage
18  * @dev The Marriage contract provides basic storage for names and vows, and has a simple function
19  * that lets people ring a bell to celebrate the wedding
20  */
21 contract Marriage {
22 
23     event weddingBells(address ringer, uint256 count);
24 
25     // Owner address
26     address public owner;
27 
28     /// Marriage Vows
29     string public leftName;
30     string public leftVows;
31     string public rightName;
32     string public rightVows;
33     // date public marriageDate;
34     uint public marriageDate;
35     
36     // Bell counter
37     uint256 public bellCounter;
38 
39     /**
40     * @dev Throws if called by any account other than the owner
41     */
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     /**
48     * @dev Constructor sets the original `owner` of the contract to the sender account, and
49     * commits the marriage details and vows to the blockchain
50     */
51     constructor(address _owner, string _leftName, string _leftVows, string _rightName, string _rightVows, uint _date) public {
52         // TODO: Assert statements for year, month, day
53         owner = _owner;
54         leftName = _leftName;
55         leftVows = _leftVows;
56         rightName = _rightName;
57         rightVows = _rightVows;
58         marriageDate = _date; 
59     }
60 
61     /**
62     * @dev Adds two numbers, throws on overflow.
63     */
64     function add(uint256 a, uint256 b) private pure returns (uint256 c) {
65         c = a + b;
66         assert(c >= a);
67         return c;
68     }
69 
70     /**
71     * @dev ringBell is a payable function that allows people to celebrate the couple's marriage, and
72     * also send Ether to the marriage contract
73     */
74     function ringBell() public payable {
75         bellCounter = add(1, bellCounter);
76         emit weddingBells(msg.sender, bellCounter);
77     }
78 
79     /**
80     * @dev withdraw allows the owner of the contract to withdraw all ether collected by bell ringers
81     */
82     function collect() external onlyOwner {
83         owner.transfer(address(this).balance);
84     }
85 
86     /**
87     * @dev withdraw allows the owner of the contract to withdraw all ether collected by bell ringers
88     */
89     function getBalance() public view returns (uint) {
90         return address(this).balance;
91     }
92 
93     /**
94     * @dev returns contract metadata in one function call, rather than separate .call()s
95     * Not sure if this works yet
96     */
97     function getMarriageDetails() public view returns (
98         address, string, string, string, string, uint, uint256) {
99         return (
100             owner,
101             leftName,
102             leftVows,
103             rightName,
104             rightVows,
105             marriageDate,
106             bellCounter
107         );
108     }
109 }