1 pragma solidity ^0.4.18;
2 
3 
4 contract TopIvy {
5 
6   /*** CONSTANTS ***/
7   string public constant NAME = "TopIvy";
8   uint256 public constant voteCost = 0.001 ether;
9   
10   // You can use this string to verify the indices correspond to the school order below
11   string public constant schoolOrdering = "BrownColumbiaCornellDartmouthHarvardPennPrincetonYale";
12 
13   /*** STORAGE ***/
14   address public ceoAddress;
15   uint256[8] public voteCounts = [1,1,1,1,1,1,1,1];
16 
17   // Sorted alphabetically:
18   // 0: Brown
19   // 1: Columbia
20   // 2: Cornell
21   // 3: Dartmouth
22   // 4: Harvard
23   // 5: Penn
24   // 6: Princeton
25   // 7: Yale
26 
27   /*** ACCESS MODIFIERS ***/
28   /// @dev Access modifier for CEO-only functionality
29   modifier onlyCEO() {
30     require(msg.sender == ceoAddress);
31     _;
32   }
33 
34   /*** CONSTRUCTOR ***/
35   function TopIvy() public {
36     ceoAddress = msg.sender;
37   }
38 
39   /*** PUBLIC FUNCTIONS ***/
40   /// @dev Transfer contract balance
41   /// @param _to The address to receive the payout
42   function payout(address _to) public onlyCEO{
43     _payout(_to);
44   }
45 
46   /// @dev Buys votes for an option, each vote costs voteCost.
47   /// @param _id Which side gets the vote
48   function buyVotes(uint8 _id) public payable {
49       // Ensure at least one vote can be purchased
50       require(msg.value >= voteCost);
51       // Ensure vote is only for listed Ivys
52       require(_id >= 0 && _id <= 7);
53       // Calculate number of votes
54       uint256 votes = msg.value / voteCost;
55       voteCounts[_id] += votes;
56       // Don't bother sending remainder back because it is <0.001 eth
57   }
58 
59   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
60   /// @param _newCEO The address of the new CEO
61   function setCEO(address _newCEO) public onlyCEO {
62     require(_newCEO != address(0));
63     ceoAddress = _newCEO;
64   }
65   
66   // @dev Returns the list of vote counts
67   function getVotes() public view returns(uint256[8]) {
68       return voteCounts;
69   }
70 
71   /*** PRIVATE FUNCTIONS ***/
72   /// For paying out balance on contract
73   function _payout(address _to) private {
74     if (_to == address(0)) {
75       ceoAddress.transfer(this.balance);
76     } else {
77       _to.transfer(this.balance);
78     }
79   }
80 }