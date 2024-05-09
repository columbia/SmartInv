1 contract P3D {
2   uint256 public stakingRequirement;
3   function buy(address _referredBy) public payable returns(uint256) {}
4   function balanceOf(address _customerAddress) view public returns(uint256) {}
5   function exit() public {}
6   function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {}
7   function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) { }
8   function myDividends(bool _includeReferralBonus) public view returns(uint256) {}
9   function withdraw() public {}
10   function totalSupply() public view returns(uint256);
11 }
12 
13 contract Pool {
14   P3D constant public p3d = P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
15 
16   address public owner;
17   uint256 public minimum;
18 
19   event Contribution(address indexed caller, address indexed receiver, uint256 contribution, uint256 payout);
20   event Approved(address addr);
21   event Removed(address addr);
22   event OwnerChanged(address owner);
23   event MinimumChanged(uint256 minimum);
24 
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   function() external payable {
30     // accept donations
31     if (msg.sender != address(p3d)) {
32       p3d.buy.value(msg.value)(msg.sender);
33       emit Contribution(msg.sender, address(0), msg.value, 0);
34     }
35   }
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   mapping (address => bool) public approved;
43 
44   function approve(address _addr) external onlyOwner() {
45     approved[_addr] = true;
46     emit Approved(_addr);
47   }
48 
49   function remove(address _addr) external onlyOwner() {
50     approved[_addr] = false;
51     emit Removed(_addr);
52   }
53 
54   function changeOwner(address _newOwner) external onlyOwner() {
55     owner = _newOwner;
56     emit OwnerChanged(owner);
57   }
58   
59   function changeMinimum(uint256 _minimum) external onlyOwner() {
60     minimum = _minimum;
61     emit MinimumChanged(minimum);
62   }
63 
64   function contribute(address _masternode, address _receiver) external payable {
65     // buy p3d
66     p3d.buy.value(msg.value)(_masternode);
67     
68     uint256 payout;
69     
70     // caller must be approved and value must meet the minimum
71     if (approved[msg.sender] && msg.value >= minimum) {
72       payout = p3d.myDividends(true);
73       if (payout != 0) {
74         p3d.withdraw();
75         // send divs to receiver
76         _receiver.transfer(payout);
77       }
78     }
79     
80     emit Contribution(msg.sender, _receiver, msg.value, payout);
81   }
82 
83   function getInfo() external view returns (uint256, uint256) {
84     return (
85       p3d.balanceOf(address(this)),
86       p3d.myDividends(true)
87     );
88   }
89 }