1 pragma solidity ^0.4.24;
2 
3 contract Ownable {}
4 contract CREDITS is Ownable{}
5 contract CREDITCoins is CREDITS{
6     mapping(address => uint256) public balanceOf;
7     function transfer(address _to, uint256 _value) public;
8 }
9 
10 contract ContractSendCreditCoins {
11     //storage
12     CREDITCoins public company_token;
13     address public PartnerAccount;
14   
15     //Events
16     event Transfer(address indexed to, uint indexed value);
17 
18     //constructor
19     constructor (CREDITCoins _company_token) public {
20         PartnerAccount = 0x4f89aaCC3915132EcE2E0Fef02036c0F33879eA8;
21         company_token = _company_token;
22     }
23   
24     function sendCurrentPayment() public {  
25             company_token.transfer(PartnerAccount, 1000000000000000000);
26             emit Transfer(PartnerAccount, 1000000000000000000);
27     }
28 }