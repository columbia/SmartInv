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
55 contract GachaDrop is Ownable {
56     uint public periodToPlay = 86400; // 86400; // seconds
57     uint256 public requireHB = 0;
58     bool public isEnded;
59     address HBWallet = address(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
60     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(HBWallet);
61     mapping(address => uint) public timeTrackUser;
62     event _random(address _from, uint _ticket);
63     constructor() public {}
64     function getAward() public {
65         require(isValidToPlay());
66         timeTrackUser[msg.sender] = block.timestamp;
67         emit _random(msg.sender, block.timestamp);
68     }
69 
70     function isValidToPlay() public view returns (bool){
71         return (!isEnded
72         && periodToPlay <= now - timeTrackUser[msg.sender]
73         && hbwalletToken.balanceOf(msg.sender) >= requireHB);
74     }
75     function changePeriodToPlay(uint _period) onlyOwner public{
76         periodToPlay = _period;
77     }
78     function updateGetAward() onlyOwner public{
79         isEnded = true;
80     }
81     function updateRequireHB(uint256 _requireHB) onlyOwner public{
82         requireHB = _requireHB;
83     }
84 
85 }