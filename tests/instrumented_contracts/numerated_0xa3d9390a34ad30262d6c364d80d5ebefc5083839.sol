1 pragma solidity ^0.4.18;
2 
3 
4 contract EtherCashLink {
5 
6 
7     struct Payment {
8         bool paid;
9         bytes32 verification;
10         uint amount;
11         bool exists;
12         address sender;
13     }
14 
15     mapping(bytes32 => Payment) public payments;
16     
17 
18     event GotPaid(address sender, address receiver, uint amount, bytes32 verification); // Event
19     event LinkCreated(address sender, uint amount, bytes32 verification); // Event
20 
21     modifier onlyIfValidCode(string _passcode) {
22         require(keccak256(_passcode) == payments[keccak256(_passcode)].verification);
23         _;
24     }
25 
26     modifier onlyIfNotPaid(string _passcode) {
27         require(!payments[keccak256(_passcode)].paid);
28         _;
29     }
30 
31     function createLink(bytes32 _verification) public payable {
32         require(!payments[_verification].exists);
33         require(msg.value > 0);
34         var newPayment = payments[_verification];
35         newPayment.paid = false;
36         newPayment.verification = _verification;
37         newPayment.amount = msg.value;
38         newPayment.exists = true;
39         newPayment.sender = msg.sender;
40         emit LinkCreated(newPayment.sender, newPayment.amount,  newPayment.verification);
41 
42     }
43 
44     function getPaid(string _passcode, address _receiver) 
45         onlyIfValidCode(_passcode) 
46         onlyIfNotPaid(_passcode) 
47         public returns (bool) {
48         payments[keccak256(_passcode)].paid = true;
49         _receiver.transfer(payments[keccak256(_passcode)].amount);
50         return true;
51         emit GotPaid(payments[keccak256(_passcode)].sender, _receiver,payments[keccak256(_passcode)].amount, payments[keccak256(_passcode)].verification);
52     }
53     
54     function wasPaid(bytes32 _verification) public view returns (bool) {
55         return (payments[_verification].paid);
56     }
57 
58    
59 }