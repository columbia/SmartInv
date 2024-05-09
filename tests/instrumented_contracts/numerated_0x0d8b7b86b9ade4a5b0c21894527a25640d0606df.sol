1 // Roman Storm Multi Sender
2 pragma solidity 0.4.20;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public view returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 contract MultiSender {
26     mapping(address => uint256) public txCount;
27     address public owner;
28     address public pendingOwner;
29     uint16 public arrayLimit = 150;
30     uint256 public fee = 0.05 ether;
31     
32     modifier onlyOwner(){
33         assert(msg.sender == owner);
34         _;
35     }
36     
37     modifier hasFee(){
38         // uint256 fee = txCount[msg.sender]
39         require(msg.value >= fee - discountRate(msg.sender));
40         _;
41     }
42     function MultiSender(address _owner, address _pendingOwner){
43         owner = _owner;
44         pendingOwner = _pendingOwner;
45     }
46     
47     function discountRate(address _customer) public view returns(uint256) {
48         uint256 count = txCount[_customer];
49         return count / (10) * 0.005 ether;
50     }
51     
52     function currentFee(address _customer) public view returns(uint256) {
53         return fee - discountRate(_customer);
54     }
55     
56     function claimOwner(address _newPendingOwner) public {
57         require(msg.sender == pendingOwner);
58         owner = pendingOwner;
59         pendingOwner = _newPendingOwner;
60     }
61     
62     function changeTreshold(uint16 _newLimit) public onlyOwner {
63         arrayLimit = _newLimit;
64     }
65     
66     function changeFee(uint256 _newFee) public onlyOwner {
67         fee = _newFee;
68     }
69     
70     function() payable {
71     }
72     
73     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
74         require(_contributors.length <= arrayLimit);
75         ERC20 erc20token = ERC20(token);
76         uint8 i = 0;
77         require(erc20token.allowance(msg.sender, this) > 0);
78         for(i; i<_contributors.length;i++){
79             erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
80         }
81         txCount[msg.sender]++;
82     }
83     
84     function multisendEther(address[] _contributors, uint256[] _balances) public hasFee payable{
85         // this function is always free, however if there is anything left over, I will keep it.
86         require(_contributors.length <= arrayLimit);
87         uint8 i = 0;
88         for(i; i<_contributors.length;i++){
89             _contributors[i].transfer(_balances[i]);
90         }
91         txCount[msg.sender]++;
92     }
93     
94     event ClaimedTokens(address token, address owner, uint256 balance);
95     function claimTokens(address _token) public onlyOwner {
96         if (_token == 0x0) {
97           owner.transfer(this.balance);
98           return;
99         }
100         ERC20 erc20token = ERC20(_token);
101         uint256 balance = erc20token.balanceOf(this);
102         erc20token.transfer(owner, balance);
103         ClaimedTokens(_token, owner, balance);
104    }
105 }