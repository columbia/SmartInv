1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    * @notice Renouncing to ownership will leave the contract without an owner.
37    * It will not be possible to call the functions with the `onlyOwner`
38    * modifier anymore.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 contract Whitelist is Ownable {
65     mapping(address => uint256) public whitelist;
66 
67     event Whitelisted(address indexed who);
68     
69     uint256 public nextUserId = 1;
70 
71     function addAddress(address who) external onlyOwner {
72         require(who != address(0));
73         require(whitelist[who] == 0);
74         whitelist[who] = nextUserId;
75         nextUserId++;
76         emit Whitelisted(who); // solhint-disable-line
77     }
78 
79     function addAddresses(address[] addresses) external onlyOwner {
80         require(addresses.length <= 100);
81         address who;
82         uint256 userId = nextUserId;
83         for (uint256 i = 0; i < addresses.length; i++) {
84             who = addresses[i];
85             require(whitelist[who] == 0);
86             whitelist[who] = userId;
87             userId++;
88             emit Whitelisted(who); // solhint-disable-line
89         }
90         nextUserId = userId;
91     }
92 }