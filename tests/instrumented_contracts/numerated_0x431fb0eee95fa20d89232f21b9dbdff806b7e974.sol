1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: contracts/Checker.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 interface RegulatorServiceI {
74   function check(address _token, address _spender, address _from, address _to, uint256 _amount) external returns (uint8);
75   function participants(address _token, address participant) external view returns (uint8);
76   function messageForReason(uint8 reason) external view returns (string);
77 }
78 
79 interface RegulatedTokenERC1404I {
80   function _service() external view returns (RegulatorServiceI);
81 }
82 
83 contract PermissionChecker is Ownable {
84   mapping(bytes32 => address) internal tokenAddresses;
85 
86   event NewToken(string name, address addr);
87 
88     function getTokenAddress(string name) public view returns (address) {
89         return tokenAddresses[stringToBytes32(name)];
90     }
91     
92   function setTokenAddress(string name, address addr) public onlyOwner {
93     tokenAddresses[stringToBytes32(name)] = addr;
94     emit NewToken(name, addr);
95   }
96   
97   function checkTransfer(string _token, address _from, address _to, uint256 _amount) public view returns (uint8) {
98     bytes32 token = stringToBytes32(_token);
99     RegulatedTokenERC1404I rtoken = RegulatedTokenERC1404I(tokenAddresses[token]);
100     RegulatorServiceI service = rtoken._service();
101     return service.check(tokenAddresses[token], _from, _from, _to, _amount);
102   }
103 
104   function checkPermission(string tokenName, address addr) public view returns (uint8) {
105     bytes32 token = stringToBytes32(tokenName);
106     RegulatedTokenERC1404I rtoken = RegulatedTokenERC1404I(tokenAddresses[token]);
107     RegulatorServiceI service = rtoken._service();
108     return service.participants(tokenAddresses[token], addr);
109   }
110   
111   function messageForReason(string tokenName, uint8 _reason) public view returns (string) {
112     bytes32 token = stringToBytes32(tokenName);
113     RegulatedTokenERC1404I rtoken = RegulatedTokenERC1404I(tokenAddresses[token]);
114     RegulatorServiceI service = rtoken._service();
115     return service.messageForReason(_reason);
116   }
117   
118   function stringToBytes32(string memory source) public pure returns (bytes32 result) {
119     bytes memory tempEmptyStringTest = bytes(source);
120     if (tempEmptyStringTest.length == 0) {
121         return 0x0;
122     }
123 
124     assembly {
125         result := mload(add(source, 32))
126     }
127   }
128 }