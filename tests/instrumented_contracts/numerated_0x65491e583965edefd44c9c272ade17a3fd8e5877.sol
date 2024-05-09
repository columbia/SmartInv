1 pragma solidity ^0.4.18;
2 
3 
4 // Interface for contracts with buying functionality, for example, crowdsales.
5 contract Buyable {
6   function buy (address receiver) public payable;
7 }
8 
9  /// @title Ownable contract - base contract with an owner
10 contract Ownable {
11   address public owner;
12 
13   function Ownable() public {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23     if (newOwner != address(0)) {
24       owner = newOwner;
25     }
26   }
27 }
28 
29 contract TokenAdrTokenSaleProxy is Ownable {
30 
31   /// Target contract
32   Buyable public targetContract;
33 
34   /// Gas limit for buy transaction
35   uint public buyGasLimit = 200000;
36 
37   /// Is sale stopped or not
38   bool public stopped = false;
39 
40   /// Total volume of weis passed through this proxy
41   uint public totalWeiVolume = 0;
42 
43   /// @dev Constructor
44   /// @param _targetAddress Address of the target Buyable contract
45   function TokenAdrTokenSaleProxy(address _targetAddress) public {
46     require(_targetAddress > 0);
47     targetContract = Buyable(_targetAddress);
48   }
49 
50   /// @dev Fallback function - forward investment request to the target contract
51   function() public payable {
52     require(msg.value > 0);
53     require(!stopped);
54     totalWeiVolume += msg.value;
55     targetContract.buy.value(msg.value).gas(buyGasLimit)(msg.sender);
56   }
57 
58   /// @dev Change target address where investment requests are forwarded
59   /// @param newTargetAddress New target address to forward investments
60   function changeTargetAddress(address newTargetAddress) public onlyOwner {
61     require(newTargetAddress > 0);
62     targetContract = Buyable(newTargetAddress);
63   }
64 
65   /// @dev Change gas limit for buy() method call
66   /// @param newGasLimit New gas limit
67   function changeGasLimit(uint newGasLimit) public onlyOwner {
68     require(newGasLimit > 0);
69     buyGasLimit = newGasLimit;
70   }
71 
72   /// @dev Stop the sale
73   function stop() public onlyOwner {
74     require(!stopped);
75     stopped = true;
76   }
77 
78   /// @dev Resume the sale
79   function resume() public onlyOwner {
80     require(stopped);
81     stopped = false;
82   }
83 }