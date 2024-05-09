1 pragma solidity ^0.4.18;
2 
3 contract Guestbook {
4     struct Entry{
5         // structure for an guestbook entry
6         address owner;
7         string alias;
8         uint timestamp;
9         uint donation;
10         string message;
11     }
12 
13     address public owner; // Observeth owner
14     address public donationWallet; // wallet to store donations
15     
16     uint public running_id = 0; // number of guestbook entries
17     mapping(uint=>Entry) public entries; // guestbook entries
18     uint public minimum_donation = 0; // to prevent spam in the guestbook
19 
20     function Guestbook() public { // called at creation of contract
21         owner = msg.sender;
22         donationWallet = msg.sender;
23     }
24     
25     function() payable public {} // fallback function
26 
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     function changeDonationWallet(address _new_storage) public onlyOwner {
33         donationWallet = _new_storage; 
34     }
35 
36     function changeOwner(address _new_owner) public onlyOwner {
37         owner = _new_owner;
38     }
39 
40     function changeMinimumDonation(uint _minDonation) public onlyOwner {
41         minimum_donation = _minDonation;
42     }
43 
44     function destroy() onlyOwner public {
45         selfdestruct(owner);
46     }
47 
48     function createEntry(string _alias, string _message) payable public {
49         require(msg.value > minimum_donation); // entries only for those that donate something
50         entries[running_id] = Entry(msg.sender, _alias, block.timestamp, msg.value, _message);
51         running_id++;
52         donationWallet.transfer(msg.value);
53     }
54 
55     function getEntry(uint entry_id) public constant returns (address, string, uint, uint, string) {
56         return (entries[entry_id].owner, entries[entry_id].alias, entries[entry_id].timestamp,
57                 entries[entry_id].donation, entries[entry_id].message);
58     }
59 }