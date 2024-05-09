1 pragma solidity ^0.4.23;
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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract TuurntWhitelist is Ownable{
63 
64     mapping(address => bool) public whitelist;
65     address public airdrop;
66     
67     /**
68     * @dev Set the airdrop contract address.
69     @param _airdrop Airdrop contract address
70     */
71     function setAirdropAddress(address _airdrop) public onlyOwner{
72         airdrop = _airdrop;
73     }
74   /**
75    * @dev Adds single address to whitelist.
76    * @param _beneficiary Address to be added to the whitelist
77    */
78     function addToWhitelist(address _beneficiary) external onlyOwner {
79         whitelist[_beneficiary] = true;
80     }
81 
82   /**
83    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
84    * @param _beneficiaries Addresses to be added to the whitelist
85    */
86     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
87         for (uint256 i = 0; i < _beneficiaries.length; i++) {
88             whitelist[_beneficiaries[i]] = true;
89         }
90     }
91 
92   /**
93    * @dev Removes single address from whitelist.
94    * @param _beneficiary Address to be removed to the whitelist
95    */
96     function removeFromWhitelist(address _beneficiary) external onlyOwner {
97         whitelist[_beneficiary] = false;
98     }
99 
100     /**
101     * @dev Check whether the address is in the whitelist.
102     * @param _whiteListAddress Whitelisted user address 
103     */
104     function checkWhitelist(address _whiteListAddress) public view returns(bool){
105         if(whitelist[_whiteListAddress])
106             return true;
107         else
108             return false;
109     }
110 
111 }