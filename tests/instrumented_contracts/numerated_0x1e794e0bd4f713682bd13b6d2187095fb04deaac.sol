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
16     
17     mapping (address => address) public strongHands;
18     mapping (address => uint256) public ownerToBalance;
19     
20     //ERC20
21     event Transfer(address indexed from, address indexed to, uint256 tokens);
22     
23     string public constant name = "Stronghands3D";
24     string public constant symbol = "S3D";
25     uint8 public constant decimals = 18;
26     
27     uint256 internal tokenSupply = 0;
28 
29     function getStrong()
30         public
31     {
32         require(strongHands[msg.sender] == address(0), "you already became a Stronghand");
33         
34         strongHands[msg.sender] = new StrongHand(msg.sender);
35         
36         emit CreateStrongHand(msg.sender, strongHands[msg.sender]);
37     }
38     
39     function mint(address _owner, uint256 _amount)
40         external
41     {
42         require(strongHands[_owner] == msg.sender);
43         
44         tokenSupply+= _amount;
45         ownerToBalance[_owner]+= _amount;
46         
47         emit Transfer(address(0), _owner, _amount);
48     }
49     
50     //ERC20
51     function totalSupply()
52         public
53         view
54         returns (uint256)
55     {
56         return tokenSupply;
57     }
58     
59     function balanceOf(address _owner)
60         public
61         view
62         returns (uint256)
63     {
64         return ownerToBalance[_owner];
65     }
66 }
67 
68 contract StrongHand {
69 
70     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
71     StrongHandsManagerInterface strongHandManager;
72     
73     address public owner;
74     uint256 private p3dBalance = 0;
75     
76     modifier onlyOwner()
77     {
78         require(msg.sender == owner);
79         _;
80     }
81     
82     constructor(address _owner)
83         public
84     {
85         owner = _owner;
86         strongHandManager = StrongHandsManagerInterface(msg.sender);
87     }
88     
89     function() public payable {}
90    
91     function buy(address _referrer)
92         external
93         payable
94         onlyOwner
95     {
96         purchase(msg.value, _referrer);
97     }
98     
99     function purchase(uint256 _amount, address _referrer)
100         private
101     {
102         p3dContract.buy.value(_amount)(_referrer);
103         uint256 balance = p3dContract.balanceOf(address(this));
104         
105         uint256 diff = balance - p3dBalance;
106         p3dBalance = balance;
107         
108         strongHandManager.mint(owner, diff);
109     }
110 
111     function withdraw()
112         external
113         onlyOwner
114     {
115         p3dContract.withdraw();
116         owner.transfer(address(this).balance);
117     }
118 }