1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Donatex {
32 
33     struct Donation {
34         address owner;
35         uint donation;
36         bytes32 name;
37         bytes text;
38     }
39 
40     struct DonationBox {
41         address owner;
42         uint minDonation;
43         uint numDonations;
44         uint totalDonations;
45         bool isValue;
46     }
47 
48     mapping (bytes32 => Donation[]) public donations;
49     mapping (bytes32 => DonationBox) public donationBoxes;
50 
51     /**
52     * @dev Throws if called by any address other than the one that owns the ID
53     */
54     modifier onlyOwner(bytes32 id) {
55         require(msg.sender == donationBoxes[id].owner);
56         _;
57     }
58 
59     function Donatex() {
60         
61     }
62 
63     function claimId(bytes32 id, uint minDonation) public {
64         require(!donationBoxes[id].isValue);
65         donationBoxes[id] = DonationBox(msg.sender, minDonation, 0, 0, true);
66     }
67 
68     function donate(bytes32 id, bytes32 name, bytes text) payable public {
69         require(donationBoxes[id].isValue);
70         DonationBox storage donationBox = donationBoxes[id];
71         require(msg.value >= donationBox.minDonation);
72         donations[id].push(Donation(msg.sender, msg.value, name, text));
73         donationBox.totalDonations = SafeMath.add(donationBox.totalDonations, msg.value);
74         donationBox.numDonations = SafeMath.add(donationBox.numDonations, 1);
75     }
76 
77     function transferDonations(bytes32 id, address destination) onlyOwner(id) {
78         require(donationBoxes[id].isValue);
79         DonationBox storage donationBox = donationBoxes[id];
80         require(donationBox.totalDonations > 0);
81         require(destination.send(donationBox.totalDonations));
82     }
83     
84 }