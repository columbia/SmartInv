1 pragma solidity ^0.4.24;
2 
3 // written by madgustave from Team Chibi Fighters
4 // find us at https://chibigame.io
5 // info@chibifighters.io
6 // version 1.0.0
7 
8 contract ExternalTokensSupport {
9     function calculateAmount(address, uint256, address, bytes, uint256) public pure returns(uint256, uint256, uint256) {}
10 }
11 
12 
13 contract Owned {
14     address public owner;
15     address public newOwner;
16 
17     event OwnershipTransferred(address indexed _from, address indexed _to);
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function transferOwnership(address _newOwner) public onlyOwner {
29         newOwner = _newOwner;
30     }
31     
32     function acceptOwnership() public {
33         require(msg.sender == newOwner);
34         emit OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36         newOwner = address(0);
37     }
38 }
39 
40 
41 interface ERC20Interface {
42     function transferFrom(address from, address to, uint tokens) external returns (bool success);
43     function transfer(address to, uint tokens) external;
44     function balanceOf(address _owner) external view returns (uint256 _balance);
45 }
46 
47 interface ERC20InterfaceClassic {
48     function transfer(address to, uint tokens) external returns (bool success);
49 }
50 
51 contract Crystals is Owned {
52 	// price of one crystal in wei
53 	uint256 public crystalPrice;
54     ExternalTokensSupport public etsContract;    
55 
56 	event crystalsBought(
57 		address indexed buyer,
58 		uint256 amount,
59         uint256 indexed paymentMethod 
60 	);
61 
62 	constructor(uint256 startPrice, address etsAddress) public {
63 		crystalPrice = startPrice;
64         etsContract = ExternalTokensSupport(etsAddress);
65 	}
66 
67 	function () public payable {
68 		require(msg.value >= crystalPrice);
69 
70 		// crystal is indivisible
71 		require(msg.value % crystalPrice == 0);
72 
73 		emit crystalsBought(msg.sender, msg.value / crystalPrice, 0);
74 	}
75 
76     function buyWithERC20(address _sender, uint256 _value, ERC20Interface _tokenContract, bytes _extraData) internal {
77         require(etsContract != address(0));
78 
79         (uint256 crystalsAmount, uint256 neededTokensAmount, uint256 paymentMethod) = etsContract.calculateAmount(_sender, _value, _tokenContract, _extraData, crystalPrice);
80 
81         require(_tokenContract.transferFrom(_sender, address(this), neededTokensAmount));
82 
83         emit crystalsBought(_sender, crystalsAmount, paymentMethod);
84     }
85 
86     function receiveApproval(address _sender, uint256 _value, ERC20Interface _tokenContract, bytes _extraData) public {
87         buyWithERC20(_sender, _value, _tokenContract, _extraData);
88     }
89 
90 	function changePrice(uint256 newPrice) public onlyOwner {
91 		crystalPrice = newPrice;
92 	}
93 
94     function changeEtsAddress(address etsAddress) public onlyOwner {
95         etsContract = ExternalTokensSupport(etsAddress);
96     }
97 
98     /**
99     * @dev Send Ether to owner
100     * @param _address Receiving address
101     * @param _amountWei Amount in WEI to send
102     **/
103     function weiToOwner(address _address, uint _amountWei) public onlyOwner returns (bool) {
104         require(_amountWei <= address(this).balance);
105         _address.transfer(_amountWei);
106         return true;
107     }
108 
109     function ERC20ToOwner(address _to, uint256 _amount, ERC20Interface _tokenContract) public onlyOwner {
110         _tokenContract.transfer(_to, _amount);
111     }
112 
113     function ERC20ClassicToOwner(address _to, uint256 _amount, ERC20InterfaceClassic _tokenContract) public onlyOwner {
114         _tokenContract.transfer(_to, _amount);
115     }
116     
117     function queryERC20(ERC20Interface _tokenContract) public view onlyOwner returns (uint) {
118         return _tokenContract.balanceOf(this);
119     }
120 }