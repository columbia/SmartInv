1 pragma solidity ^0.4.24;
2 
3 contract BlockchainForPeace {
4     
5 
6     // to see the total raised 
7     uint public raised;
8     address public charity; 
9     
10     //struct for the donation 
11     struct Donation {
12         address donor; 
13         string message; 
14         uint value; 
15     }
16     
17     Donation[] public donations; 
18     
19     //mapping an address to the donation struct 
20     //mapping (address => donation) public donors;
21     event Donate(address indexed from, uint amount, string message);
22     
23     //constructor to initiate the address of the charity being donated to
24     constructor () public {
25         charity = 0xaf208FF43D2A265E047D52C9F54c753DB86D9D11;
26     }
27    
28     // payable function which auto transfers money to charity address, collects the value and increases the total value counter. Also allows for anonoymous donations
29      function fallback() payable public {
30         raised += msg.value;
31         charity.transfer(msg.value);
32      }
33     // optional message to be sent with donation, peace message.
34     function messageForPeace(string _message) payable public {
35         require(msg.value > 0);
36         donations.push(Donation(msg.sender, _message, msg.value));
37         charity.transfer(msg.value);
38         raised += msg.value;
39         emit Donate(msg.sender, msg.value, _message);
40     }
41 
42     function getDonation(uint _index) public view returns (address, string, uint) {
43         Donation memory don = donations[_index];
44         return (don.donor, don.message, don.value);
45     }
46     
47     function getDonationLength() public view returns (uint){
48         return donations.length;
49     }
50 
51      function getRaised() public view returns (uint){
52         return raised;
53     }
54 }