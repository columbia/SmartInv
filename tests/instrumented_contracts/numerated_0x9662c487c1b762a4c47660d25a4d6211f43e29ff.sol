1 contract Owned {
2     address public owner;
3     address public newOwner;
4 
5     constructor() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         assert(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address _newOwner) public onlyOwner {
15         require(_newOwner != owner);
16         newOwner = _newOwner;
17     }
18 
19     function acceptOwnership() public {
20         require(msg.sender == newOwner);
21         emit OwnerUpdate(owner, newOwner);
22         owner = newOwner;
23         newOwner = 0x0;
24     }
25 
26     event OwnerUpdate(address _prevOwner, address _newOwner);
27 }
28 
29 interface XaurumInterface {
30     function doMelt(uint256 _xaurAmount, uint256 _goldAmount) external returns (bool);
31     function balanceOf(address _owner) external constant returns (uint256 balance);
32     function totalSupply() external constant returns (uint256 supply);
33     function totalGoldSupply() external constant returns (uint256 supply);
34 }
35 
36 interface OldMeltingContractInterface {
37     function XaurumAmountMelted() external constant returns (uint256 supply);
38     function GoldAmountMelted() external constant returns (uint256 supply);
39 }
40 
41 contract DestructionContract is Owned{
42     address XaurumAddress;
43     address BurningAddress;
44     address OldMeltingContract;
45     
46     uint xaurumDestroyed;
47     uint goldMelted;
48     uint xaurumBurned;
49     uint xaurumMelted;
50     
51     
52     event MeltDone(uint xaurAmount, uint goldAmount);
53     event BurnDone(uint xaurAmount);
54     
55     constructor() public {
56         XaurumAddress = 0x4DF812F6064def1e5e029f1ca858777CC98D2D81;
57         BurningAddress = 0xed3f8C4c63524a376833b0f687487182C9f9bbf8;
58         OldMeltingContract = 0x6A25216f75d7ee83D06e5fC6B96bCD52233BC69b;
59     }
60     
61     function XaurumBurned() public constant returns(uint){
62         return xaurumBurned + XaurumInterface(XaurumAddress).balanceOf(BurningAddress);
63     }
64     
65     function XaurumMelted() public constant returns(uint) {
66         return xaurumMelted + OldMeltingContractInterface(OldMeltingContract).XaurumAmountMelted();
67     }
68     
69     function FreeXaurum() public constant returns(uint) {
70         return XaurumInterface(XaurumAddress).balanceOf(address(this)) - xaurumDestroyed;
71     }
72     
73     function GoldMelted() public constant returns(uint) {
74         return OldMeltingContractInterface(OldMeltingContract).GoldAmountMelted() + goldMelted;
75     }
76     
77     function doMelt(uint256 _xaurAmount, uint256 _goldAmount) public onlyOwner returns (bool) {
78         uint actualBalance = FreeXaurum();
79         uint totalSupply = XaurumInterface(XaurumAddress).totalSupply();
80         require(totalSupply >= _xaurAmount);
81         require(actualBalance >= _xaurAmount);
82         require(XaurumInterface(XaurumAddress).totalGoldSupply() >= _goldAmount);
83         XaurumInterface(XaurumAddress).doMelt(_xaurAmount, _goldAmount);
84         xaurumMelted += _xaurAmount;
85         goldMelted += _goldAmount;
86         xaurumDestroyed += _xaurAmount;
87         emit MeltDone(_xaurAmount, _goldAmount);
88     }
89     
90     function doBurn(uint256 _xaurAmount) public onlyOwner returns (bool) {
91         uint actualBalance = FreeXaurum();
92         uint totalSupply = XaurumInterface(XaurumAddress).totalSupply();
93         require(totalSupply >= _xaurAmount);
94         require(actualBalance >= _xaurAmount);
95         XaurumInterface(XaurumAddress).doMelt(_xaurAmount, 0);
96         xaurumBurned += _xaurAmount;
97         xaurumDestroyed += _xaurAmount;
98         emit BurnDone(_xaurAmount);
99     }
100 }