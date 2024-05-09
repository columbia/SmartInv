1 pragma solidity ^0.4.23;
2 
3 interface P3D {
4   function() payable external;
5   function buy(address _playerAddress) payable external returns(uint256);
6   function sell(uint256 _amountOfTokens) external;
7   function reinvest() external;
8   function withdraw() external;
9   function exit() external;
10   function dividendsOf(address _playerAddress) external view returns(uint256);
11   function balanceOf(address _playerAddress) external view returns(uint256);
12   function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
13   function stakingRequirement() external view returns(uint256);
14   function myDividends(bool _includeReferralBonus) external view returns(uint256);
15 }
16 
17 contract ProxyCrop {
18     address public owner;
19     bool public disabled;
20 
21     constructor(address _owner, address _referrer) public payable {
22       owner = _owner;
23 
24       // plant some seeds
25       if (msg.value > 0) {
26         P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe).buy.value(msg.value)(_referrer);
27       }
28     }
29 
30     function() public payable {
31       assembly {
32         // Copy msg.data. We take full control of memory in this inline assembly
33         // block because it will not return to Solidity code. We overwrite the
34         // Solidity scratch pad at memory position 0.
35         calldatacopy(0, 0, calldatasize)
36 
37         // Call the implementation.
38         // out and outsize are 0 because we don't know the size yet.
39         let result := delegatecall(gas, 0x0D6C969d0004B431189f834203CE0f5530e06259, 0, calldatasize, 0, 0)
40 
41         // Copy the returned data.
42         returndatacopy(0, 0, returndatasize)
43 
44         switch result
45         // delegatecall returns 0 on error.
46         case 0 { revert(0, returndatasize) }
47         default { return(0, returndatasize) }
48       }
49     }
50 }
51 
52 contract Farm {
53   // address mapping for owner => crop
54   mapping (address => address) public crops;
55 
56   // event for creating a new crop
57   event CreateCrop(address indexed owner, address indexed crop);
58 
59   /**
60    * @dev Create a crop contract that can hold P3D and auto-reinvest.
61    * @param _referrer referral address for buying P3D.
62    */
63   function create(address _referrer) external payable {
64     // sender must not own a crop
65     require(crops[msg.sender] == address(0));
66 
67     // create a new crop
68     crops[msg.sender] = (new ProxyCrop).value(msg.value)(msg.sender, _referrer);
69 
70     // fire event
71     emit CreateCrop(msg.sender, crops[msg.sender]);
72   }
73 }