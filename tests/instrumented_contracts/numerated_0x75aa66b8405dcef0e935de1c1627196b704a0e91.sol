1 pragma solidity ^0.4.21;
2 
3 contract DonationGuestbook {
4     struct Entry{
5         // structure for an guestbook entry
6         address owner;
7         string alias;
8         uint timestamp;
9         uint blocknumber;
10         uint donation;
11         string message;
12     }
13 
14     address public owner; // Guestbook creator
15     address public donationWallet; // wallet to store donations
16     
17     uint public running_id = 0; // number of guestbook entries
18     mapping(uint=>Entry) public entries; // guestbook entries
19     uint public minimum_donation = 0; // to prevent spam in the guestbook
20 
21     function DonationGuestbook() public { 
22     // called at creation of contract
23         owner = msg.sender;
24         donationWallet = msg.sender;
25     }
26     
27     function() payable public {
28     // fallback function. In case somebody sends ether directly to the contract.
29         donationWallet.transfer(msg.value);
30     } 
31 
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function changeDonationWallet(address _new_storage) public onlyOwner {
38     // in case the donation wallet address ever changes
39         donationWallet = _new_storage; 
40     }
41 
42     function changeOwner(address _new_owner) public onlyOwner {
43     // in case the owner ever changes
44         owner = _new_owner;
45     }
46 
47     function changeMinimumDonation(uint _minDonation) public onlyOwner {
48     // in case people spam into the guestbook
49         minimum_donation = _minDonation;
50     }
51 
52     function destroy() onlyOwner public {
53     // kills the contract and sends all funds (which should be impossible to have) to the owner
54         selfdestruct(owner);
55     }
56 
57     function createEntry(string _alias, string _message) payable public {
58     // called by a donator to make a donation + guestbook entry
59         require(msg.value > minimum_donation); // entries only for those that donate something
60         entries[running_id] = Entry(msg.sender, _alias, block.timestamp, block.number, msg.value, _message);
61         running_id++;
62         donationWallet.transfer(msg.value);
63     }
64 
65     function getEntry(uint entry_id) public constant returns (address, string, uint, uint, uint, string) {
66     // for reading the entries of the guestbook
67         return (entries[entry_id].owner, entries[entry_id].alias, entries[entry_id].blocknumber,  entries[entry_id].timestamp,
68                 entries[entry_id].donation, entries[entry_id].message);
69     }
70 }