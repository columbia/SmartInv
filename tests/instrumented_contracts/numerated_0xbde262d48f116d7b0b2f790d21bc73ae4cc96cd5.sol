1 pragma solidity ^0.5.1;
2 
3 contract KingoftheBill {
4     address owner = msg.sender;
5     address payable donee = 0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71;
6     
7     struct Record {
8         string donorName; 
9         uint donation; 
10     }
11 
12     mapping(address => Record) private donorsbyAddress;
13 
14     address[] public addressLUT;
15 
16     uint public sumDonations;                       
17 
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function donate(string memory _name) public payable {
24         require(msg.value > 0);
25         donorsbyAddress[msg.sender].donorName = _name; 
26         donorsbyAddress[msg.sender].donation = donorsbyAddress[msg.sender].donation + msg.value;
27         sumDonations = sumDonations + msg.value;
28         addressLUT.push(msg.sender);
29         donee.transfer(msg.value);   
30     }
31 
32     function getDonationsofDonor (address _donor) external view returns(uint){ 
33         return donorsbyAddress[_donor].donation;
34     }
35 
36     function getNameofDonor (address _donor) external view returns(string memory){
37         return donorsbyAddress[_donor].donorName;
38     }
39 
40     function getaddressLUT() external view returns(address[] memory){
41         return addressLUT;
42     }
43 
44     function killContract() public onlyOwner {
45         selfdestruct(donee);
46     }
47 
48 }