1 pragma solidity ^0.4.24;
2 
3 interface HourglassInterface {
4     function buy(address _playerAddress) payable external returns(uint256);
5     function withdraw() external;
6 }
7 
8 contract StrongHandsManager {
9     
10     event CreateStrongHand(address indexed owner, address indexed strongHand);
11     
12     mapping (address => address) public strongHands;
13     
14     function getStrong(address _referrer)
15         public
16         payable
17     {
18         require(strongHands[msg.sender] == address(0), "you already became a Stronghand");
19         
20         strongHands[msg.sender] = (new StrongHand).value(msg.value)(msg.sender, _referrer);
21         
22         emit CreateStrongHand(msg.sender, strongHands[msg.sender]);
23     }
24 }
25 
26 contract StrongHand {
27 
28     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
29     
30     address public owner;
31     
32     modifier onlyOwner()
33     {
34         require(msg.sender == owner);
35         _;
36     }
37     
38     constructor(address _owner, address _referrer)
39         public
40         payable
41     {
42         owner = _owner;
43         buy(_referrer);
44     }
45     
46     function() public payable {}
47    
48     function buy(address _referrer)
49         public
50         payable
51         onlyOwner
52     {
53         p3dContract.buy.value(msg.value)(_referrer);
54     }
55 
56     function withdraw()
57         external
58         onlyOwner
59     {
60         p3dContract.withdraw();
61         owner.transfer(address(this).balance);
62     }
63 }