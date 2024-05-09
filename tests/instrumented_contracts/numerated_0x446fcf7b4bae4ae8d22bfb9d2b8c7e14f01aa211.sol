1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract TVCrowdsale {
39     uint256 public currentRate;
40     function buyTokens(address _beneficiary) public payable;
41 }
42 
43 contract TVToken {
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function balanceOf(address _owner) public view returns (uint256);
46     function allowance(address _owner, address _spender) public view returns (uint256);
47 }
48 
49 contract TVRefCrowdsale is Ownable {
50     TVToken public TVContract;
51     TVCrowdsale public TVCrowdsaleContract;
52     uint256 public refPercentage;
53     uint256 public TVThreshold;
54     address public holder;
55     mapping(address => bool) public exceptAddresses;
56 
57     event TransferRefTVs(address holder, address sender, address referer, uint256 amount, uint256 TVThreshold, uint256 balance);
58     event BuyTokens(address sender, uint256 amount);
59 
60     constructor(
61         address _TVTokenContract,
62         address _TVCrowdsaleContract,
63         uint256 _refPercentage,
64         uint256 _TVThreshold,
65         address _holder
66     ) public {
67         TVContract = TVToken(_TVTokenContract);
68         TVCrowdsaleContract = TVCrowdsale(_TVCrowdsaleContract);
69         refPercentage = _refPercentage;
70         TVThreshold = _TVThreshold;
71         holder = _holder;
72     }
73 
74     function buyTokens(address refAddress) public payable {
75         TVCrowdsaleContract.buyTokens.value(msg.value)(msg.sender);
76         emit BuyTokens(msg.sender, msg.value);
77         sendRefTVs(refAddress);
78     }
79 
80     function sendRefTVs(address refAddress) internal returns(bool) {
81         uint256 balance = TVContract.balanceOf(refAddress);
82         uint256 allowance = TVContract.allowance(holder, this);
83         uint256 amount = (msg.value * TVCrowdsaleContract.currentRate()) * refPercentage / 100;
84         if ((exceptAddresses[refAddress] || balance >= TVThreshold) && allowance >= amount) {
85             bool successful = TVContract.transferFrom(holder, refAddress, amount);
86             if (!successful) revert("Transfer refTVs failed.");
87             emit TransferRefTVs(holder, msg.sender, refAddress, amount, TVThreshold, balance);
88             return true;
89         }
90         return true;
91     }
92 
93     function changeRefPercentage(uint256 percentage) onlyOwner public {
94         require(percentage > 0);
95         refPercentage = percentage;
96     }
97 
98     function addExceptAddress(address exceptAddress) onlyOwner public {
99         exceptAddresses[exceptAddress] = true;
100     }
101 
102     function changeThreshold(uint256 threshold) onlyOwner public {
103         require(threshold > 0);
104         TVThreshold = threshold;
105     }
106 }