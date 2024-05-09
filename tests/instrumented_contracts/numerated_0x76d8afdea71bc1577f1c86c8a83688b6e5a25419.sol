1 contract Ownable {
2   address public owner;
3 
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5 
6   /**
7    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8    * account.
9    */
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   /**
15    * @dev Throws if called by any account other than the owner.
16    */
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   /**
23    * @dev Allows the current owner to transfer control of the contract to a newOwner.
24    * @param newOwner The address to transfer ownership to.
25    */
26   function transferOwnership(address newOwner) public onlyOwner {
27     require(newOwner != address(0));
28     OwnershipTransferred(owner, newOwner);
29     owner = newOwner;
30   }
31 }
32 
33 contract AccountLevels {
34   //given a user, returns an account level
35   //0 = regular user (pays take fee and make fee)
36   //1 = market maker silver (pays take fee, no make fee, gets rebate)
37   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
38   function accountLevel(address user) constant returns(uint) {}
39 }
40 
41 contract AccountLevelsTest is AccountLevels, Ownable {
42   mapping (address => uint) public accountLevels;
43 
44   function setAccountLevel(address user, uint level) onlyOwner {
45     accountLevels[user] = level;
46   }
47 
48   function accountLevel(address user) constant returns(uint) {
49     return accountLevels[user];
50   }
51 }