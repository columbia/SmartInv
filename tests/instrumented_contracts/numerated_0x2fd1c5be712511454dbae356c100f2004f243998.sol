1 pragma solidity 0.4.25;
2 
3 ////////////////////////////////////////////////////////////////////////////////
4 //
5 // Eth17 - Master Contract that holds the Factory address and Eth funds
6 //
7 ////////////////////////////////////////////////////////////////////////////////
8 
9 contract Master {
10     
11     address public admin;
12     address public thisContractAddress;
13     address public factoryContractAddress;
14     
15     // MODIFIERS
16     modifier onlyAdmin { 
17         require(msg.sender == admin
18         ); 
19         _; 
20     }
21     
22     // MODIFIERS
23     modifier onlyAdminOrFactory { 
24         require(
25             msg.sender == admin ||
26             msg.sender == factoryContractAddress
27         ); 
28         _; 
29     }
30 
31     constructor() public payable {
32         admin = msg.sender;
33         thisContractAddress = address(this);
34     }
35 
36     // FALLBACK
37     function () private payable {}
38     
39     function setAdmin(address _address) onlyAdmin public {
40         admin = address(_address);
41     }
42 
43     function setFactoryContractAddress(address _address) onlyAdmin public {
44         factoryContractAddress = address(_address);
45     }
46 
47     function adminWithdraw(uint _amount) onlyAdmin public {
48 	    address(admin).transfer(_amount);
49     }
50 
51     function adminWithdrawAll() onlyAdmin public {
52 	    address(admin).transfer(address(this).balance);
53     }
54 
55     function transferEth() onlyAdminOrFactory public {
56         address(factoryContractAddress).transfer(1 ether);
57     }
58 
59     function thisContractBalance() public view returns(uint) {
60         return address(this).balance;
61     }
62 
63 }