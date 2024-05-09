1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-31
3 */
4 
5 pragma solidity 0.5.10;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14 
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 contract ERC20BasicInterface {
47     function totalSupply() public view returns (uint256);
48 
49     function balanceOf(address who) public view returns (uint256);
50 
51     function transfer(address to, uint256 value) public returns (bool);
52 
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     uint8 public decimals;
58 }
59 contract GachaDrop is Ownable {
60     uint public periodToPlay = 86400; // 86400; // seconds
61     bool public isEnded;
62     mapping(address => uint) public timeTrackUser;
63     event _random(address _from, uint _ticket);
64     constructor() public {}
65     function getAward() public {
66         require(isValidToPlay());
67         timeTrackUser[msg.sender] = block.timestamp;
68         emit _random(msg.sender, block.timestamp);
69     }
70 
71     function isValidToPlay() public view returns (bool){
72         return (!isEnded
73         && periodToPlay <= now - timeTrackUser[msg.sender]);
74     }
75     function changePeriodToPlay(uint _period) onlyOwner public{
76         periodToPlay = _period;
77     }
78     function updateGetAward() onlyOwner public{
79         isEnded = true;
80     }
81 
82 }