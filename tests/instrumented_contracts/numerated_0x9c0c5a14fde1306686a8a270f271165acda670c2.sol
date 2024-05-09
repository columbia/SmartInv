1 pragma solidity ^0.4.16;
2 /** @title Ether to the Moon */
3 contract EtherToTheMoon {
4  // Publically visible who is the owner of this contract. Also,
5  // this adds get functions for this variable automatically.
6  address public owner;
7  uint public totalContribution;
8 
9  /// Runs only once when the contract is deployed.
10  function EtherToTheMoon() public{
11    owner = msg.sender;
12  }
13  modifier onlyOwner() {
14    require(msg.sender == owner);
15    _;
16  }
17  struct richData {
18    uint amount;
19    bytes32 message;
20    address sender;
21  }
22  /* DATABASES */
23  // We are creating a publically accessible database for all
24  // the bids that we will recieve. We are mapping address of
25  // each sender to the value inside it.
26  mapping(address => uint) public users;
27  richData[10] public richDatabase; // [0] = Richest & [9] = Poorest
28 
29  // Function to be called when anyone sends us money. We take the money
30  // in wei and add it to his total bid.
31  function takeMyMoney(bytes32 message) public payable returns (bool){
32    // Add value to his total amount.
33    users[msg.sender] += msg.value;
34    totalContribution += msg.value;
35    if(users[msg.sender] >= users[richDatabase[9].sender] ){
36      richData[] memory arr = new richData[](10);
37      bool updated = false;
38      uint j = 0;
39      for (uint i = 0; i < 10; i++) {
40        if(j == 10) break;
41        if(!updated && users[msg.sender] > richDatabase[i].amount) {
42          richData memory newData;
43          newData.amount = users[msg.sender];
44          newData.message = message;
45          newData.sender = msg.sender;
46          arr[j] = newData;
47          j++;
48          if(richDatabase[i].sender != msg.sender) {
49           arr[j] = richDatabase[i];
50           j++;
51          }
52          updated = true;
53        } else if(richDatabase[i].sender != msg.sender){
54          arr[j] = richDatabase[i];
55          j++;
56        }
57      }
58      for(i = 0; i < 10; i++) {
59          richDatabase[i] = arr[i];
60        }
61    }
62    return updated;
63  }
64  function buyerHistory() public constant returns (address[], uint[], bytes32[]){
65 
66      uint length;
67      length = 10;
68      address[] memory senders = new address[](length);
69      uint[] memory amounts = new uint[](length);
70      bytes32[] memory statuses = new bytes32[](length);
71 
72      for (uint i = 0; i < length; i++)
73      {
74          senders[i] = (richDatabase[i].sender);
75          amounts[i] = (richDatabase[i].amount);
76          statuses[i] = (richDatabase[i].message);
77      }
78      return (senders, amounts, statuses);
79  }
80  function withdraw(address _to, uint _amount) onlyOwner external payable{
81      require(_amount <= totalContribution);
82      totalContribution -= _amount;
83      _to.transfer(_amount);
84  }
85 }