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
17 
18   event Contribution(address indexed caller, address indexed receiver, uint256 contribution, uint256 divs);
19 
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   function() external payable {
25     // contract accepts donations
26     if (msg.sender != address(p3d)) {
27       p3d.buy.value(msg.value)(address(0));
28       emit Contribution(msg.sender, address(0), msg.value, 0);
29     }
30   }
31 
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   mapping (address => bool) public approved;
38 
39   function approve(address _addr) external onlyOwner() {
40     approved[_addr] = true;
41   }
42 
43   function remove(address _addr) external onlyOwner() {
44     approved[_addr] = false;
45   }
46 
47   function changeOwner(address _newOwner) external onlyOwner() {
48     owner = _newOwner;
49   }
50 
51   function contribute(address _masternode, address _receiver) external payable {
52     // buy p3d
53     p3d.buy.value(msg.value)(_masternode);
54 
55     // caller must be approved to send divs
56     if (approved[msg.sender]) {
57       // send divs to receiver
58       uint256 divs = p3d.myDividends(true);
59       if (divs != 0) {
60         p3d.withdraw();
61         _receiver.transfer(divs);
62       }
63       emit Contribution(msg.sender, _receiver, msg.value, divs);
64     }
65   }
66 
67   function getInfo() external view returns (uint256, uint256) {
68     return (
69       p3d.balanceOf(address(this)),
70       p3d.myDividends(true)
71     );
72   }
73 }