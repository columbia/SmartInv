1 pragma solidity 0.4.24;
2 
3 // File: contracts/ZTXInterface.sol
4 
5 contract ZTXInterface {
6     function transferOwnership(address _newOwner) public;
7     function mint(address _to, uint256 amount) public returns (bool);
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function unpause() public;
11 }
12 
13 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipRenounced(address indexed previousOwner);
25   event OwnershipTransferred(
26     address indexed previousOwner,
27     address indexed newOwner
28   );
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address _newOwner) public onlyOwner {
60     _transferOwnership(_newOwner);
61   }
62 
63   /**
64    * @dev Transfers control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function _transferOwnership(address _newOwner) internal {
68     require(_newOwner != address(0));
69     emit OwnershipTransferred(owner, _newOwner);
70     owner = _newOwner;
71   }
72 }
73 
74 // File: contracts/ZTXOwnershipHolder.sol
75 
76 /**
77  * @title ZTXOwnershipHolder - Sole responsibility is to hold and transfer ZTX ownership
78  * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
79  * @author Timo Hedke - <timo@zulurepublic.io>
80  */
81 contract ZTXOwnershipHolder is Ownable {
82 
83       /**
84      * @dev Constructor for the airdrop contract
85      * @param _ztx ZTX contract address
86      * @param newZuluOwner New ZTX owner address
87      */
88     function transferZTXOwnership(address _ztx, address newZuluOwner) external onlyOwner{
89         ZTXInterface(_ztx).transferOwnership(newZuluOwner);
90     }
91 }