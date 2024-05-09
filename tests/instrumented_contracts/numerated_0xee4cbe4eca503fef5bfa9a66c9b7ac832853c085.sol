1 pragma solidity ^0.4.21;
2 contract BLInterface {
3     function setPrimaryAccount(address newMainAddress) public;
4     function withdraw() public;
5 }
6 contract CSInterface {
7     function goalReached() public;
8     function goal() public returns (uint);
9     function hasClosed() public returns(bool);
10     function weiRaised() public returns (uint);
11 }
12 contract StorageInterface {
13     function getUInt(bytes32 record) public constant returns (uint);
14 }
15 contract Interim {
16     // Define DS, Bubbled and Token Sale addresses
17     address public owner; // DS wallet
18     address public bubbled; // bubbled dwallet
19     BLInterface internal BL; // Blocklord Contract Interface
20     CSInterface internal CS; // Crowdsale contract interface
21     StorageInterface internal s; // Eternal Storage Interface
22     uint public rate; // ETH to GBP rate
23     function Interim() public {
24         // Setup owner DS
25         owner = msg.sender;
26     }
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31     modifier onlyBubbled() {
32         require(msg.sender == bubbled);
33         _;
34     }
35     modifier onlyMembers() {
36         require(msg.sender == owner || msg.sender == bubbled);
37         _;
38     }
39     // Setup the interface to the Blocklord contract
40     function setBLInterface(address newAddress) public onlyOwner {
41         BL = BLInterface(newAddress);
42     }
43     // Setup the interface to the storage contract
44     function setStorageInterface(address newAddress) public onlyOwner {
45         s = StorageInterface(newAddress);
46     }
47     // Setup the interface to the Blocklord contract
48     function setCSInterface(address newAddress) public onlyOwner {
49         CS = CSInterface(newAddress);
50     }
51     // Setup the interface to the Bubbled multisig contract
52     function setBubbled(address newAddress) public onlyMembers {
53         bubbled = newAddress;
54     }
55     // Setup the interface to the DS Personal address
56     function setDS(address newAddress) public onlyOwner {
57         owner = newAddress;
58     }
59 
60     function setRate(uint _rate) public onlyOwner {
61       rate = _rate;
62     }
63 
64     // we can call this function to check the status of both crowdsale and blocklord
65     function checkStatus () public returns(uint raisedBL, uint raisedCS, uint total, uint required, bool goalReached){
66       raisedBL = s.getUInt(keccak256(address(this), "balance"));
67       raisedCS = CS.weiRaised();
68       total = raisedBL + raisedCS;
69       required = CS.goal();
70       goalReached = total >= required;
71     }
72 
73     function completeContract (bool toSplit) public payable {
74     //   require(CS.hasClosed()); // fail if crowdsale has not closed
75     bool goalReached;
76     (,,,goalReached) = checkStatus();
77     if (goalReached) require(toSplit == false);
78       uint feeDue;
79       if (toSplit == false) {
80         feeDue = 20000 / rate * 1000000000000000000; // fee due in Wei
81         require(msg.value >= feeDue);
82       }
83       BL.withdraw(); // withdraw ETH from Blocklord contract to Interim contract
84        if (goalReached) { // if goal reached
85          BL.setPrimaryAccount(bubbled); // Transfer Blocklord contract and payment to be maade offline
86          owner.transfer(feeDue);
87          bubbled.transfer(this.balance);
88        } else { // if goal not reached
89          if (toSplit) { // if Bubbled decides to split
90            BL.setPrimaryAccount(owner); //set ownership to DS
91            uint balance = this.balance;
92            bubbled.transfer(balance / 2);
93            owner.transfer(balance / 2);
94          } else {
95            // Bubbled decides to keep blocklord
96            BL.setPrimaryAccount(bubbled);
97            owner.transfer(feeDue);
98            bubbled.transfer(this.balance);
99          }
100        }
101     }
102     // receive ether from blocklord contract
103     function () public payable {
104     }
105 }