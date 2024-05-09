1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 contract BCEOInterface {
78   function owner() public view returns (address);
79   function balanceOf(address who) public view returns (uint256);
80   function transferFrom(address from, address to, uint256 value) public returns (bool);
81   function approve(address spender, uint256 value) public returns (bool);
82   
83 }
84 
85 
86 contract TransferContract is Ownable {
87   address private addressBCEO; 
88   address private addressABT; 
89   
90   BCEOInterface private bCEOInstance;
91 
92   function initTransferContract(address _addressBCEO) public onlyOwner returns (bool) {
93     require(_addressBCEO != address(0));
94     addressBCEO = _addressBCEO;
95     bCEOInstance = BCEOInterface(addressBCEO);
96     return true;
97   }
98 
99   function batchTransfer (address sender, address[] _receivers,  uint256[] _amounts) public onlyOwner {
100     uint256 cnt = _receivers.length;
101     require(cnt > 0);
102     require(cnt == _amounts.length);
103     for ( uint i = 0 ; i < cnt ; i++ ) {
104       uint256 numBitCEO = _amounts[i];
105       address receiver = _receivers[i];
106       bCEOInstance.transferFrom(sender, receiver, numBitCEO * (10 ** uint256(18)));
107     }
108   }
109 
110 }