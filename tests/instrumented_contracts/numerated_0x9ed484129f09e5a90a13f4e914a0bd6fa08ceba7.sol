1 pragma solidity 0.4.21;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
7     function transfer(address to, uint256 tokens) public returns (bool success);
8     function approve(address spender, uint256 tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract P3D {
16     function withdraw() public;
17     function buy(address) public payable returns(uint256);
18 }
19 
20 contract Owned {
21     address public owner;
22     address public ownerCandidate;
23 
24     function Owned() public {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32     
33     function changeOwner(address _newOwner) public onlyOwner {
34         ownerCandidate = _newOwner;
35     }
36     
37     function acceptOwnership() public {
38         require(msg.sender == ownerCandidate);  
39         owner = ownerCandidate;
40     }
41     
42 }
43 
44 contract BoomerangLiquidity is Owned {
45     
46     modifier onlyOwner(){
47         require(msg.sender == owner);
48         _;
49     }
50 
51     P3D internal constant p3dContract = P3D(address(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe));
52     address internal constant sk2xContract = address(0xAfd87E1E1eCe09D18f4834F64F63502718d1b3d4);
53     
54     function() payable public {
55         invest();
56     }
57     
58     function invest() public {
59         uint256 amountToSend = address(this).balance;
60         if(amountToSend > 1){
61             uint256 half = amountToSend / 2;
62             sk2xContract.call(half);
63             p3dContract.buy.value(half)(msg.sender);
64         }
65     }
66 
67     function withdraw(address withdrawAddress) public {
68         P3D(withdrawAddress).withdraw();
69         invest();
70     }
71     
72     function withdraw() public {
73         p3dContract.withdraw();
74         invest();
75     }
76     
77     function withdrawAndSend() public {
78         p3dContract.withdraw();
79         invest();
80     }
81     
82     function donate() payable public {
83         sk2xContract.call(msg.value);
84     }
85     
86     function donate(address withdrawAddress) payable public {
87         p3dContract.buy.value(msg.value)(msg.sender);
88     }
89     
90     function donateP3D() payable public {
91         p3dContract.buy.value(msg.value)(msg.sender);
92     }
93     
94 }