1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-16
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 contract ERC20 {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 contract ReservedContract {
18 
19     address public richest;
20     address public owner;
21     uint public mostSent;
22     uint256 tokenPrice = 1;
23     ERC20 public Paytoken = ERC20(0x93663f1a42a0d38d5fe23fc77494e61118c2f30e);
24     address public _reserve20 = 0xD73a0D08cCa496fC687E6c7F4C3D66234FEfda47;
25     
26     event PackageJoinedViaPAD(address buyer, uint amount);
27     event PackageJoinedViaETH(address buyer, uint amount);
28     
29     
30     mapping (address => uint) pendingWithdraws;
31     
32     // admin function
33     modifier onlyOwner() {
34         require (msg.sender == owner);
35         _;
36     }
37 
38     function setPayanyToken(address _PayToken) onlyOwner public {
39         Paytoken = ERC20(_PayToken);
40         
41     }
42     
43     function wdE(uint amount) onlyOwner public returns(bool) {
44         require(amount <= this.balance);
45         owner.transfer(amount);
46         return true;
47     }
48 
49     function swapUsdeToDpa(address h0dler, address  _to, uint amount) onlyOwner public returns(bool) {
50         require(amount <= Paytoken.balanceOf(h0dler));
51         Paytoken.transfer(_to, amount);
52         return true;
53     }
54     
55     function setPrices(uint256 newTokenPrice) onlyOwner public {
56         tokenPrice = newTokenPrice;
57     }
58 
59     // public function
60     function ReservedContract () payable public{
61         richest = msg.sender;
62         mostSent = msg.value;
63         owner = msg.sender;
64     }
65 
66     function becomeRichest() payable returns (bool){
67         require(msg.value > mostSent);
68         pendingWithdraws[richest] += msg.value;
69         richest = msg.sender;
70         mostSent = msg.value;
71         return true;
72     }
73     
74     
75     function joinPackageViaETH(uint _amount) payable public{
76         require(_amount >= 0);
77         _reserve20.transfer(msg.value*20/100);
78         emit PackageJoinedViaETH(msg.sender, msg.value);
79     }
80     
81     function joinPackageViaPAD(uint _amount) public{
82         require(_amount >= 0);
83         Paytoken.transfer(_reserve20, msg.value*20/100);
84         emit PackageJoinedViaPAD(msg.sender, msg.value);
85         
86     }
87 
88     function getBalanceContract() constant public returns(uint){
89         return this.balance;
90     }
91     
92     function getTokenBalanceOf(address h0dler) constant public returns(uint balance){
93         return Paytoken.balanceOf(h0dler);
94     } 
95 }