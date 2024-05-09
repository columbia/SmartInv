1 pragma solidity ^0.4.24;
2 
3 contract Nicks {
4   mapping (address => string) private nickOfOwner;
5   mapping (string => address) private ownerOfNick;
6 
7   event Set (string indexed _nick, address indexed _owner);
8   event Unset (string indexed _nick, address indexed _owner);
9 
10   constructor () public {
11 	contractOwner = msg.sender;
12   }
13   
14   address public contractOwner; 
15   
16 
17 modifier onlyOwner() {
18 		require(contractOwner == msg.sender);
19 		_;
20 	}
21 
22 	
23   function nickOf (address _owner) public view returns (string _nick) {
24     return nickOfOwner[_owner];
25   }
26 
27   function ownerOf (string _nick) public view returns (address _owner) {
28     return ownerOfNick[_nick];
29   }
30 
31   function set (string _nick) public {
32     require(bytes(_nick).length > 2);
33     require(ownerOf(_nick) == address(0));
34 
35     address owner = msg.sender;
36     string storage oldNick = nickOfOwner[owner];
37 
38     if (bytes(oldNick).length > 0) {
39       emit Unset(oldNick, owner);
40       delete ownerOfNick[oldNick];
41     }
42 
43     nickOfOwner[owner] = _nick;
44     ownerOfNick[_nick] = owner;
45     emit Set(_nick, owner);
46   }
47 
48   function unset () public {
49     require(bytes(nickOfOwner[msg.sender]).length > 0);
50 
51     address owner = msg.sender;
52     string storage oldNick = nickOfOwner[owner];
53 
54     emit Unset(oldNick, owner);
55 
56     delete ownerOfNick[oldNick];
57     delete nickOfOwner[owner];
58   }
59 
60   
61   
62 
63 /////////////////////////////////
64 /// USEFUL FUNCTIONS ///
65 ////////////////////////////////
66 
67 /* Fallback function to accept all ether sent directly to the contract */
68 
69     function() payable public
70     {    }
71 	
72 	
73 	function withdrawEther() public onlyOwner {
74 		require(address(this).balance > 0);
75 		
76         contractOwner.transfer(address(this).balance);
77     }
78 	
79 }