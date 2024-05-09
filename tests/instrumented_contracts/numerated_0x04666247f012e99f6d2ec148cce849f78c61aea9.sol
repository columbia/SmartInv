1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.6;
4 
5 contract NFTommo
6 {
7     address private owner;
8     
9     uint256 private registerPrice;
10     mapping (address => bool) private userToRegistered;
11     
12     constructor()
13     {
14         owner = msg.sender;   
15         registerPrice = 0.1 ether;
16     }
17     
18     //////////
19     // Getters
20     
21     function getRegisterPrice() external view returns(uint256)
22     {
23         return(registerPrice);
24     }
25 
26     function getOwner() external view returns(address)
27     {
28         return(owner);
29     }
30     
31     function isAddressRegistered(address _account) external view returns(bool)
32     {
33         return(userToRegistered[_account]);
34     }
35     
36     //////////
37     // Setters
38     function setOwner(address _owner) external
39     {
40         require(msg.sender == owner, "Function only callable by owner!");
41     
42         owner = _owner;    
43     }
44     
45     function setRegisterPrice(uint256 _registerPrice) external
46     {
47         require(msg.sender == owner, "Function only callable by owner!");
48         
49         registerPrice = _registerPrice;
50     }
51     
52     /////////////////////
53     // Register functions
54     receive() external payable
55     {
56         register();
57     }
58     
59     function register() public payable
60     {
61         require(!userToRegistered[msg.sender], "Address already registered!");
62         require(msg.value >= registerPrice);
63         
64         userToRegistered[msg.sender] = true;
65     }
66     
67     /////////////////
68     // Withdraw Ether
69     function withdraw(uint256 _amount, address _receiver) external
70     {   
71         require(msg.sender == owner, "Function only callable by owner!");
72         
73         payable(_receiver).transfer(_amount);
74     }
75 }