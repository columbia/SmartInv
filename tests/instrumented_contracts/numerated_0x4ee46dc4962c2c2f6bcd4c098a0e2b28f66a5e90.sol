1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract IHumanity {
6     function mint(address account, uint256 value) public;
7     function totalSupply() public view returns (uint256);
8 }
9 
10 
11 /**
12  * @title HumanityRegistry
13  * @dev A list of Ethereum addresses that belong to unique humans as determined by Humanity governance.
14  */
15 contract HumanityRegistry {
16 
17     mapping (address => bool) public humans;
18 
19     IHumanity public humanity;
20     address public governance;
21 
22     constructor(IHumanity _humanity, address _governance) public {
23         humanity = _humanity;
24         governance = _governance;
25     }
26 
27     function add(address who) public {
28         require(msg.sender == governance, "HumanityRegistry::add: Only governance can add an identity");
29         require(humans[who] == false, "HumanityRegistry::add: Address is already on the registry");
30 
31         _reward(who);
32         humans[who] = true;
33     }
34 
35     function remove(address who) public {
36         require(
37             msg.sender == governance || msg.sender == who,
38             "HumanityRegistry::remove: Only governance or the identity owner can remove an identity"
39         );
40         delete humans[who];
41     }
42 
43     function isHuman(address who) public view returns (bool) {
44         return humans[who];
45     }
46 
47     function _reward(address who) internal {
48         uint totalSupply = humanity.totalSupply();
49 
50         if (totalSupply < 28000000e18) {
51             humanity.mint(who, 30000e18); // 1 - 100
52         } else if (totalSupply < 46000000e18) {
53             humanity.mint(who, 20000e18); // 101 - 1000
54         } else if (totalSupply < 100000000e18) {
55             humanity.mint(who, 6000e18); // 1001 - 10000
56         }
57 
58     }
59 
60 }