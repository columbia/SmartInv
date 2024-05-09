1 pragma solidity ^0.4.19;
2 
3 /**
4  * @dev Pre-ico contract interface
5  */
6 contract PreIcoContract {
7     function buyTokens (address _investor) public payable;
8     uint256 public startTime;
9     uint256 public endTime;
10 }
11 
12 /**
13  * @title Reservation contract
14  * @notice Forword ether to pre-ico address
15  */
16 contract ReservationContract {
17 
18     // Keep track of who invested
19     mapping(address => bool) public invested;
20     // Minimum investment for reservation contract
21     uint public MIN_INVESTMENT = 1 ether;
22     // address of the pre-ico
23     PreIcoContract public preIcoAddr;
24     // start and end time of the pre-ico
25     uint public preIcoStart;
26     uint public preIcoEnd;
27 
28     /**
29      * @dev Constructor
30      * @notice Initialize reservation contract
31      * @param _preIcoAddr Pre ico address 
32      */
33     function ReservationContract(address _preIcoAddr) public {
34         require(_preIcoAddr != 0x0);
35         require(isContract(_preIcoAddr) == true);
36 
37         // load pre-ico contract instance
38         preIcoAddr = PreIcoContract(_preIcoAddr);
39 
40         // get and set start and end time
41         preIcoStart = preIcoAddr.startTime();
42         preIcoEnd = preIcoAddr.endTime();
43         require(preIcoStart != 0 && preIcoEnd != 0 && now <= preIcoEnd);
44     }
45 
46     /**
47      * @dev Fallback function
48      * @notice This function will record your investment in
49      * this reservation contract and forward eths to the pre-ico,
50      * please note, you need to invest at least MIN_INVESTMENT and
51      * you must invest directly from your address, contracts are not
52      * allowed
53      */
54     function() public payable {
55         require(msg.value >= MIN_INVESTMENT);
56         require(now >= preIcoStart && now <= preIcoEnd);
57         // check if it's a contract
58         require(isContract(msg.sender) == false);
59 
60         // update records (used for reference only)
61         if (invested[msg.sender] == false) {
62             invested[msg.sender] = true;
63         }
64 
65         // buy tokens
66         preIcoAddr.buyTokens.value(msg.value)(msg.sender);
67     }
68 
69     /**
70     * @dev Check if an address is a contract
71     * @param addr Address to check
72     * @return True if is a contract
73     */
74     function isContract(address addr) public constant returns (bool) {
75         uint size;
76         assembly { size := extcodesize(addr) }
77         return size > 0;
78     }
79 }