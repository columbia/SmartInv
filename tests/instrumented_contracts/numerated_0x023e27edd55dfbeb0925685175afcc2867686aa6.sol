1 pragma solidity 0.4.20;
2 
3 contract IOwnable {
4     function getOwner() public view returns (address);
5     function transferOwnership(address newOwner) public returns (bool);
6 }
7 
8 contract Ownable is IOwnable {
9     address internal owner;
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     function Ownable() public {
16         owner = msg.sender;
17     }
18 
19     /**
20      * @dev Throws if called by any account other than the owner.
21      */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     function getOwner() public view returns (address) {
28         return owner;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param _newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address _newOwner) public onlyOwner returns (bool) {
36         if (_newOwner != address(0)) {
37             onTransferOwnership(owner, _newOwner);
38             owner = _newOwner;
39         }
40         return true;
41     }
42 
43     // Subclasses of this token may want to send additional logs through the centralized Augur log emitter contract
44     function onTransferOwnership(address, address) internal returns (bool);
45 }
46 
47 contract IRepPriceOracle {
48     function setRepPriceInAttoEth(uint256 _repPriceInAttoEth) external returns (bool);
49     function getRepPriceInAttoEth() external view returns (uint256);
50 }
51 
52 contract RepPriceOracle is Ownable, IRepPriceOracle {
53     // A rough initial estimate based on the current date (04/10/2018) 1 REP ~= .06 ETH
54     uint256 private repPriceInAttoEth = 6 * 10 ** 16;
55 
56     function setRepPriceInAttoEth(uint256 _repPriceInAttoEth) external onlyOwner returns (bool) {
57         repPriceInAttoEth = _repPriceInAttoEth;
58         return true;
59     }
60 
61     function getRepPriceInAttoEth() external view returns (uint256) {
62         return repPriceInAttoEth;
63     }
64 
65     function onTransferOwnership(address, address) internal returns (bool) {
66         return true;
67     }
68 }