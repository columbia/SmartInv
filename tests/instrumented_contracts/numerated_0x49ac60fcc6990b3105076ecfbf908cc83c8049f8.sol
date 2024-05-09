1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/Whitelist.sol
46 
47 /**
48  * @title Whitelist contract
49  * @dev Whitelist for wallets.
50 */
51 contract Whitelist is Ownable {
52     mapping(address => bool) whitelist;
53 
54     uint256 public whitelistLength = 0;
55 
56     /**
57     * @dev Add wallet to whitelist.
58     * @dev Accept request from the owner only.
59     * @param _wallet The address of wallet to add.
60     */
61     function addWallet(address _wallet) public onlyOwner {
62         require(_wallet != address(0));
63         require(!isWhitelisted(_wallet));
64         whitelist[_wallet] = true;
65         whitelistLength++;
66     }
67 
68     /**
69     * @dev Remove wallet from whitelist.
70     * @dev Accept request from the owner only.
71     * @param _wallet The address of whitelisted wallet to remove.
72     */
73     function removeWallet(address _wallet) public onlyOwner {
74         require(_wallet != address(0));
75         require(isWhitelisted(_wallet));
76         whitelist[_wallet] = false;
77         whitelistLength--;
78     }
79 
80     /**
81     * @dev Check the specified wallet whether it is in the whitelist.
82     * @param _wallet The address of wallet to check.
83     */
84     function isWhitelisted(address _wallet) public view returns (bool) {
85         return whitelist[_wallet];
86     }
87 }