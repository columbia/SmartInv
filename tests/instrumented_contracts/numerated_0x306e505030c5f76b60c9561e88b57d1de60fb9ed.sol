1 pragma solidity ^0.5.5;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8     address payable owner;
9     address payable newOwner;
10     function changeOwner(address payable _newOwner) public onlyOwner {
11         newOwner = _newOwner;
12     }
13     function acceptOwnership() public {
14         if (msg.sender == newOwner) {
15             owner = newOwner;
16         }
17     }
18 }
19 
20 contract Save is Owned {
21     uint8 public fee;
22     uint32 public deadline;
23     uint32 public savers;
24     mapping (address=>uint256) saves;
25     event Saved(address indexed _from, uint256 _value);
26     function saveOf(address _user) view public returns (uint256 save) {return saves[_user];}
27 }
28 
29 contract KodDeneg is Save{
30     
31     constructor() public{
32         fee = 3;
33         deadline = 1577836799;
34         savers = 0;
35         owner = msg.sender;
36     }
37     
38     function payOut() public returns (bool ok){
39         require(now>=deadline && saves[msg.sender]>0);
40         uint256 royalty = saves[msg.sender]*fee/100;
41         if (royalty>0) owner.transfer(royalty);
42         msg.sender.transfer(saves[msg.sender]-royalty);
43         return true;
44     }
45     function () payable external {
46         require(msg.value>0);
47         if (saves[msg.sender]==0) savers++;
48         saves[msg.sender]+=msg.value;
49         emit Saved(msg.sender,msg.value);
50     }
51 }