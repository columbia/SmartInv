1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 
21 
22 contract RTDAirDrop is owned {
23     address public token_address;
24     string public detail;
25     string public website;
26 
27     event AirDropCoin(address target, uint256 amount);
28 
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     function setToken(address tokenAddress) onlyOwner public {
34         token_address = tokenAddress;
35     }
36 
37     function setWebsite(string airdropWebsite) onlyOwner public {
38         website = airdropWebsite;
39     }
40 
41     function setDetail(string airdropDetail) onlyOwner public {
42         detail = airdropDetail;
43     }
44 
45     function() payable public {}
46 
47     function withdrawEther() onlyOwner public {
48         owner.transfer(address(this).balance);
49     }
50 
51     function airDrop(address _user, uint256 _value)  onlyOwner public {
52             _user.transfer(_value);
53             emit AirDropCoin(_user, _value);
54     }
55 }