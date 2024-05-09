1 pragma solidity ^0.4.19;
2 
3 contract Storage{
4     address public founder;
5     bool public changeable;
6     mapping( address => bool) public adminStatus;
7     mapping( address => uint256) public slot;
8     
9     event Update(address whichAdmin, address whichUser, uint256 data);
10     event Set(address whichAdmin, address whichUser, uint256 data);
11     event Admin(address addr, bool yesno);
12 
13     modifier onlyFounder() {
14         require(msg.sender==founder);
15         _;
16     }
17     
18     modifier onlyAdmin() {
19         assert (adminStatus[msg.sender]==true);
20         _;
21     }
22     
23     function Storage() public {
24         founder=msg.sender;
25         adminStatus[founder]=true;
26         changeable=true;
27     }
28     
29     function update(address userAddress,uint256 data) public onlyAdmin(){
30         assert(changeable==true);
31         assert(slot[userAddress]+data>slot[userAddress]);
32         slot[userAddress]+=data;
33         Update(msg.sender,userAddress,data);
34     }
35     
36     function set(address userAddress, uint256 data) public onlyAdmin() {
37         require(changeable==true || msg.sender==founder);
38         slot[userAddress]=data;
39         Set(msg.sender,userAddress,data);
40     }
41     
42     function admin(address addr) public onlyFounder(){
43         adminStatus[addr] = !adminStatus[addr];
44         Admin(addr, adminStatus[addr]);
45     }
46     
47     function halt() public onlyFounder(){
48         changeable=!changeable;
49     }
50     
51     function() public{
52         revert();
53     }
54     
55 }