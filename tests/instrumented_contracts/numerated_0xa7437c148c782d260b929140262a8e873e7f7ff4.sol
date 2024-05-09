1 pragma solidity 0.5.9;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 contract Bussiness is Ownable {
43     uint public periodToPlay = 60; // 86400; // seconds
44 
45     mapping(address => uint) public timeTrackUser;
46     event _random(address _from, uint _ticket);
47     constructor() public {}
48     function getAward() public {
49         require(isValidToPlay());
50         timeTrackUser[msg.sender] = block.timestamp;
51         emit _random(msg.sender, block.timestamp);
52     }
53 
54     function isValidToPlay() public view returns (bool){
55         return periodToPlay <= now - timeTrackUser[msg.sender];
56     }
57     function changePeriodToPlay(uint _period) onlyOwner public{
58         periodToPlay = _period;
59     }
60 
61 }