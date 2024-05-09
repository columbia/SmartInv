1 pragma solidity ^0.4.18;
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
56     address public backendAddress;
57 
58     /**
59     * @dev Add wallet to whitelist.
60     * @dev Accept request from the owner only.
61     * @param _wallet The address of wallet to add.
62     */  
63     function addWallet(address _wallet) public onlyPrivilegedAddresses {
64         require(_wallet != address(0));
65         require(!isWhitelisted(_wallet));
66         whitelist[_wallet] = true;
67         whitelistLength++;
68     }
69 
70     /**
71     * @dev Remove wallet from whitelist.
72     * @dev Accept request from the owner only.
73     * @param _wallet The address of whitelisted wallet to remove.
74     */  
75     function removeWallet(address _wallet) public onlyOwner {
76         require(_wallet != address(0));
77         require(isWhitelisted(_wallet));
78         whitelist[_wallet] = false;
79         whitelistLength--;
80     }
81 
82     /**
83     * @dev Check the specified wallet whether it is in the whitelist.
84     * @param _wallet The address of wallet to check.
85     */ 
86     function isWhitelisted(address _wallet) constant public returns (bool) {
87         return whitelist[_wallet];
88     }
89 
90     /**
91     * @dev Sets the backend address for automated operations.
92     * @param _backendAddress The backend address to allow.
93     */
94     function setBackendAddress(address _backendAddress) public onlyOwner {
95         require(_backendAddress != address(0));
96         backendAddress = _backendAddress;
97     }
98 
99     /**
100     * @dev Allows the function to be called only by the owner and backend.
101     */
102     modifier onlyPrivilegedAddresses() {
103         require(msg.sender == owner || msg.sender == backendAddress);
104         _;
105     }
106 }