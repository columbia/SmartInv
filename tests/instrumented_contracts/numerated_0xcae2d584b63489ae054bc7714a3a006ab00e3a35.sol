1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface token  
4 {
5     function transfer(address receiver, uint amount) external;
6 }
7 
8 contract Levblockchain_LVE_Private_Sale_Limited_Offer
9 {
10     address public Levblockchain;
11     uint public ether_raised;
12     uint public cost_LVE;
13     token public Levblockchain_token;
14 
15     mapping(address => uint256) public balanceOf;
16     
17     bool ether_raised_success = false;
18      bool private_sale_off = false;
19     
20 
21     event value_Transfer(address investor, uint amount, bool isContribution);
22     event FundTransfer(address Levblockchain, uint ether_raised,bool success);
23     event tokenTransfer(address Levblockchain,uint amount,bool success);
24     
25     constructor(
26     ) 
27    
28     public
29     { 
30     Levblockchain = 0x555716FECaa29Ba9ef58880a963E44f6a257747C;
31     cost_LVE = 1112 ;
32     Levblockchain_token = token(0xA93F28cca763E766f96D008f815adaAb16A8E38b);
33     }
34     
35  function () payable external 
36  {
37         require(!private_sale_off);
38         uint amount = msg.value;
39         balanceOf[msg.sender] += amount;
40         ether_raised += amount;
41         Levblockchain_token.transfer(msg.sender, amount * cost_LVE);
42         
43        emit value_Transfer(msg.sender, amount, true);
44     }
45     
46      modifier ifsuccessful ()
47      
48         
49         { require (msg.sender == Levblockchain); _;
50              ether_raised_success = true;
51             private_sale_off = true;
52         }
53       
54 
55      function draw() public  ifsuccessful {
56            if (ether_raised_success && Levblockchain == msg.sender) {
57              if (msg.sender.send(ether_raised)) {
58                
59                emit FundTransfer(Levblockchain, ether_raised, true);}}}
60               
61                function draw(uint amount ) public ifsuccessful {
62                      if (ether_raised_success && Levblockchain == msg.sender){
63                         Levblockchain_token.transfer(msg.sender,amount);
64                     
65                        emit tokenTransfer(Levblockchain, amount, true);
66                          
67                      }
68                    
69                }
70 }