1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface collectible {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Swap {
8     address public beneficiary;
9     uint public amountRaised;
10     uint public price;
11     bool contractover = false;
12     collectible public swapaddress;
13     mapping(address => uint256) public balanceOf;
14     mapping(address => bool) public check;
15 
16     event FundTransfer(address backer, uint amount, bool isContribution);
17 
18     /**
19      * Constructor
20      *
21      * Setup the owner
22      */
23     constructor(
24         address SendTo,
25         uint etherCostOfEachCollectible,
26         address addressOfCollectibleUsedAsReward
27     ) public {
28         beneficiary = SendTo;
29         price = etherCostOfEachCollectible * 1 szabo;
30         swapaddress = collectible(addressOfCollectibleUsedAsReward);
31     }
32 
33     
34     function () payable external {
35         require(check[msg.sender] == false);
36         require(msg.value < 1000000000000000001 wei);
37         
38         uint amount = msg.value;
39         balanceOf[msg.sender] += amount;
40         amountRaised += amount;
41         uint copy = price;
42         uint second = price;
43         uint third = price;
44         
45         if (amountRaised <= 100 ether) {
46         uint newvalue = copy / 10;
47         swapaddress.transfer(msg.sender, amount / newvalue);
48         } else if (amountRaised <= 2100 ether) {
49         uint secondvalue = second / 2;
50         swapaddress.transfer(msg.sender, amount / secondvalue);
51         } else {
52         swapaddress.transfer(msg.sender, amount / third);
53         }
54         
55         beneficiary.send(msg.value);
56         emit FundTransfer(msg.sender, amount, true);
57         check[msg.sender] = true;
58     }
59 
60 }