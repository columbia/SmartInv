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
15     uint256 counter = 0;
16 
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     /**
20      * Constructor
21      *
22      * Setup the owner
23      */
24     constructor(
25         address SendTo,
26         uint etherCostOfEachCollectible,
27         address addressOfCollectibleUsedAsReward
28     ) public {
29         beneficiary = SendTo;
30         price = etherCostOfEachCollectible * 1 szabo;
31         swapaddress = collectible(addressOfCollectibleUsedAsReward);
32     }
33  
34 
35     
36     function () payable external {
37         require(check[msg.sender] == false);
38         require(msg.value < 1000000000000000001 wei);
39         
40         uint amount = msg.value;
41         balanceOf[msg.sender] += amount;
42         
43         
44         uint second = price;
45         uint third = price;
46         
47         if (counter <= 6000) {
48         counter += 1;
49         swapaddress.transfer(msg.sender, 5000000);
50         msg.sender.send(msg.value);
51         } else if (amountRaised <= 8000 ether) {
52         amountRaised += amount;
53         uint secondvalue = second / 5;
54         swapaddress.transfer(msg.sender, amount / secondvalue);
55         } else {
56         amountRaised += amount;
57         uint thirdvalue = third / 3;
58         swapaddress.transfer(msg.sender, amount / thirdvalue);
59         }
60         
61         beneficiary.send(msg.value);
62         emit FundTransfer(msg.sender, amount, true);
63         check[msg.sender] = true;
64     }
65 
66 }