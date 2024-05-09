1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 interface SaleInterface {
68     function saleTokensPerUnit() external view returns(uint256);
69     function extraTokensPerUnit() external view returns(uint256);
70     function unitContributions(address) external view returns(uint256);
71     function disbursementHandler() external view returns(address);
72 }
73 
74 
75 
76 
77 
78 contract Saft is SaleInterface, Ownable {
79 
80   uint256 public c_saleTokensPerUnit;
81   uint256 public c_extraTokensPerUnit;
82   mapping(address => uint256) public c_unitContributions;
83   address public c_disbursementHandler;
84 
85   constructor (uint256 _saleTokensPerUnit, uint256 _extraTokensPerUnit, address _disbursementHandler) Ownable() public {
86     c_saleTokensPerUnit = _saleTokensPerUnit;
87     c_extraTokensPerUnit = _extraTokensPerUnit;
88     c_disbursementHandler = _disbursementHandler;
89   }
90 
91   function saleTokensPerUnit() external view returns (uint256) { return c_saleTokensPerUnit; }
92   function extraTokensPerUnit() external view returns (uint256) { return c_extraTokensPerUnit; }
93   function unitContributions(address contributor) external view returns (uint256) { return c_unitContributions[contributor]; }
94   function disbursementHandler() external view returns (address) { return c_disbursementHandler; }
95 
96   function setSaleTokensPerUnit(uint256 _saleTokensPerUnit) public onlyOwner {
97     c_saleTokensPerUnit = _saleTokensPerUnit;
98   }
99 
100   function setExtraTokensPerUnit(uint256 _extraTokensPerUnit) public onlyOwner {
101     c_extraTokensPerUnit = _extraTokensPerUnit;
102   }
103 
104   function setUnitContributions(address contributor, uint256 units) public onlyOwner {
105     c_unitContributions[contributor] = units;
106   }
107 
108   function setDisbursementHandler(address _disbursementHandler) public onlyOwner {
109     c_disbursementHandler = _disbursementHandler;
110   }
111 }