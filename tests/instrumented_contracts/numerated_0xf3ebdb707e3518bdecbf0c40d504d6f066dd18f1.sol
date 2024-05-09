1 pragma solidity 0.5.10;
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
42 contract ERC20BasicInterface {
43     function totalSupply() public view returns (uint256);
44 
45     function balanceOf(address who) public view returns (uint256);
46 
47     function transfer(address to, uint256 value) public returns (bool);
48 
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     uint8 public decimals;
54 }
55 contract Bussiness is Ownable {
56     uint public periodToPlay = 900; // 86400; // seconds
57     bool public isEnded;
58     mapping(address => uint) public timeTrackUser;
59     event _random(address _from, uint _ticket);
60     constructor() public {}
61     function getAward() public {
62         require(isValidToPlay());
63         timeTrackUser[msg.sender] = block.timestamp;
64         emit _random(msg.sender, block.timestamp);
65     }
66 
67     function isValidToPlay() public view returns (bool){
68         return (!isEnded
69         && periodToPlay <= now - timeTrackUser[msg.sender]);
70     }
71     function changePeriodToPlay(uint _period) onlyOwner public{
72         periodToPlay = _period;
73     }
74     function updateGetAward() onlyOwner public{
75         isEnded = true;
76     }
77 
78 }