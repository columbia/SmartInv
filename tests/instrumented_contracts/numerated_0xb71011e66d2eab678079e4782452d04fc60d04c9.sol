1 contract WhiteList {
2     
3     mapping (address => bool)   public  whiteList;
4     
5     address  public  owner;
6     
7     function WhiteList() public {
8         owner = msg.sender;
9         whiteList[owner] = true;
10     }
11     
12     function addToWhiteList(address [] _addresses) public {
13         require(msg.sender == owner);
14         
15         for (uint i = 0; i < _addresses.length; i++) {
16             whiteList[_addresses[i]] = true;
17         }
18     }
19     
20     function removeFromWhiteList(address [] _addresses) public {
21         require (msg.sender == owner);
22         for (uint i = 0; i < _addresses.length; i++) {
23             whiteList[_addresses[i]] = false;
24         }
25     }
26 }