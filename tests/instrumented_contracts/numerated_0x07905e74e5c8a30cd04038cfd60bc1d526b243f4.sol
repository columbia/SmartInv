1 pragma solidity ^0.4.24;
2 
3 interface HourglassInterface {
4     function buy(address _playerAddress) payable external returns(uint256);
5     function withdraw() external;
6     function balanceOf(address _customerAddress) view external returns(uint256);
7 }
8 
9 interface StrongHandsManagerInterface {
10     function mint(address _owner, uint256 _amount) external;
11 }
12 
13 contract StrongHandsManager {
14     
15     event CreateStrongHand(address indexed owner, address indexed strongHand);
16     event MintToken(address indexed owner, uint256 indexed amount);
17     
18     mapping (address => address) public strongHands;
19     mapping (address => uint256) public ownerToBalance;
20     
21     //ERC20
22     string public constant name = "Stronghands3D";
23     string public constant symbol = "S3D";
24     uint8 public constant decimals = 18;
25     
26     uint256 internal tokenSupply = 0;
27 
28     function getStrong()
29         public
30     {
31         require(strongHands[msg.sender] == address(0), "you already became a Stronghand");
32         
33         strongHands[msg.sender] = new StrongHand(msg.sender);
34         
35         emit CreateStrongHand(msg.sender, strongHands[msg.sender]);
36     }
37     
38     function mint(address _owner, uint256 _amount)
39         external
40     {
41         require(strongHands[_owner] == msg.sender);
42         
43         tokenSupply+= _amount;
44         ownerToBalance[_owner]+= _amount;
45         
46         emit MintToken(_owner, _amount);
47     }
48     
49     //ERC20
50     function totalSupply()
51         public
52         view
53         returns (uint256)
54     {
55         return tokenSupply;
56     }
57     
58     function balanceOf(address _owner)
59         public
60         view
61         returns (uint256)
62     {
63         return ownerToBalance[_owner];
64     }
65 }
66 
67 contract StrongHand {
68 
69     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
70     StrongHandsManagerInterface strongHandManager;
71     
72     address public owner;
73     uint256 private p3dBalance = 0;
74     
75     modifier onlyOwner()
76     {
77         require(msg.sender == owner);
78         _;
79     }
80     
81     constructor(address _owner)
82         public
83     {
84         owner = _owner;
85         strongHandManager = StrongHandsManagerInterface(msg.sender);
86     }
87     
88     function() public payable {}
89    
90     function buy(address _referrer)
91         external
92         payable
93         onlyOwner
94     {
95         purchase(msg.value, _referrer);
96     }
97     
98     function purchase(uint256 _amount, address _referrer)
99         private
100     {
101         p3dContract.buy.value(_amount)(_referrer);
102         uint256 balance = p3dContract.balanceOf(address(this));
103         
104         uint256 diff = balance - p3dBalance;
105         p3dBalance = balance;
106         
107         strongHandManager.mint(owner, diff);
108     }
109 
110     function withdraw()
111         external
112         onlyOwner
113     {
114         p3dContract.withdraw();
115         owner.transfer(address(this).balance);
116     }
117 }