1 pragma solidity ^0.4.24;
2 
3 interface HourglassInterface {
4     function buy(address _playerAddress) payable external returns(uint256);
5     function withdraw() external;
6 }
7 
8 interface StrongHandsManagerInterface {
9     function mint(address _owner, uint256 _amount) external;
10 }
11 
12 contract StrongHandsManager {
13     
14     event CreateStrongHand(address indexed owner, address indexed strongHand);
15     event MintToken(address indexed owner, uint256 indexed amount);
16     
17     mapping (address => address) public strongHands;
18     mapping (address => uint256) public ownerToBalance;
19     
20     //ERC20
21     string public constant name = "Stronghands3D";
22     string public constant symbol = "S3D";
23     uint8 public constant decimals = 18;
24     
25     uint256 internal tokenSupply = 0;
26 
27     function getStrong()
28         public
29     {
30         require(strongHands[msg.sender] == address(0), "you already became a Stronghand");
31         
32         strongHands[msg.sender] = new StrongHand(msg.sender);
33         
34         emit CreateStrongHand(msg.sender, strongHands[msg.sender]);
35     }
36     
37     function mint(address _owner, uint256 _amount)
38         external
39     {
40         require(strongHands[_owner] == msg.sender);
41         
42         tokenSupply+= _amount;
43         ownerToBalance[_owner]+= _amount;
44         
45         emit MintToken(_owner, _amount);
46     }
47     
48     //ERC20
49     function totalSupply()
50         public
51         view
52         returns (uint256)
53     {
54        return tokenSupply;
55     }
56     
57     function balanceOf(address _owner)
58         public
59         view
60         returns (uint256)
61     {
62         return ownerToBalance[_owner];
63     }
64 }
65 
66 contract StrongHand {
67 
68     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
69     StrongHandsManagerInterface strongHandManager;
70     
71     address public owner;
72     
73     modifier onlyOwner()
74     {
75         require(msg.sender == owner);
76         _;
77     }
78     
79     constructor(address _owner)
80         public
81     {
82         owner = _owner;
83         strongHandManager = StrongHandsManagerInterface(msg.sender);
84     }
85     
86     function() public payable {}
87    
88     function buy(address _referrer)
89         external
90         payable
91         onlyOwner
92     {
93         purchase(msg.value, _referrer);
94     }
95     
96     function purchase(uint256 _amount, address _referrer)
97         private
98     {
99          uint256 amountPurchased = p3dContract.buy.value(_amount)(_referrer);
100          strongHandManager.mint(owner, amountPurchased);
101     }
102 
103     function withdraw()
104         external
105         onlyOwner
106     {
107         p3dContract.withdraw();
108         owner.transfer(address(this).balance);
109     }
110 }