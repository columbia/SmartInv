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
22 contract RTDReward is owned {
23     address public token;
24     string public detail;
25     string public website;
26 
27     event Reward(address target, uint256 amount);
28 
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     function setContract(address _token,string _website, string _detail) onlyOwner public {
34         token = _token;
35         website = _website;
36         detail = _detail;
37     }
38 
39     function() payable public {}
40 
41     function withdrawEther() onlyOwner public {
42         owner.transfer(address(this).balance);
43     }
44 
45     function sendReward(address _user, uint256 _value)  onlyOwner public {
46             _user.transfer(_value);
47             emit Reward(_user, _value);
48     }
49 }