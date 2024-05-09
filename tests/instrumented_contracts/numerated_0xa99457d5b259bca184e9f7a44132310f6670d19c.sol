1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract BntyTokenInterface {
46   function destroyTokens(address _owner, uint _amount) public returns (bool);
47   function changeController(address newController) public;
48 }
49 
50 contract BntyController is Ownable {
51     
52     address public stakingContract;
53     address public Bounty0xToken;
54     
55     modifier onlyStakingContract() {
56         require(msg.sender == stakingContract);
57         _;
58     }
59     
60     constructor(address _stakingContract, address _Bounty0xToken) public {
61         stakingContract = _stakingContract;
62         Bounty0xToken = _Bounty0xToken;
63     }
64     
65     
66     function changeStakingContract(address _stakingContract) onlyOwner public {
67         stakingContract = _stakingContract;
68     }
69 
70     function destroyTokensInBntyTokenContract(address _owner, uint _amount) onlyStakingContract public returns (bool) {
71         require(BntyTokenInterface(Bounty0xToken).destroyTokens(_owner, _amount));
72         return true;
73     }
74     
75     function changeControllerInBntyTokenContract(address newController) onlyOwner public {
76         BntyTokenInterface(Bounty0xToken).changeController(newController);
77     }
78     
79 }